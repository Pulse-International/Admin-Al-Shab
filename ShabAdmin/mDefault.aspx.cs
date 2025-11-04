using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.UI;

namespace ShabAdmin
{
    public partial class mDefault : Page
    {
        protected DashboardData CurrentData { get; set; }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadDashboardData();
            }
        }

        private void LoadDashboardData()
        {
            int countryId = GetCountryIdFromCookieOrDefault();
            int companyId = GetCompanyIdFromCookieOrDefault();

            // Load data directly from database
            CurrentData = LoadDashboardDataFromDb(countryId, companyId);
        }

        private DashboardData LoadDashboardDataFromDb(int countryId, int companyId)
        {
            var data = new DashboardData
            {
                OrdersLast7 = new List<int>(Enumerable.Repeat(0, 7)),
                SalesLast7 = new List<decimal>(Enumerable.Repeat(0m, 7)),
                SalesMonthly6 = new List<(int Y, int M, decimal Sum)>(),
                CountrySalesList = new List<CountrySales>(),
                TimelineEvents = new List<TimelineEvent>(),
                SelectedCurrencySymbol = GetCurrencySymbolByCountry(countryId)
            };

            var startDay = DateTime.Now.Date.AddDays(-6);
            var startMonth = new DateTime(DateTime.Now.Year, DateTime.Now.Month, 1).AddMonths(-5);

            using (var cn = new SqlConnection(ConfigurationManager.ConnectionStrings["ShabDB_connection"].ConnectionString))
            {
                cn.Open();

                using (var cmd = new SqlCommand("dbo.DashboardData", cn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@CountryId", countryId);
                    cmd.Parameters.AddWithValue("@CompanyId", companyId);

                    // Add timeout for long queries
                    cmd.CommandTimeout = 30;

                    using (var rdr = cmd.ExecuteReader())
                    {
                        // Process all result sets...
                        ProcessOrdersPerDay(rdr, data, startDay);
                        ProcessSalesPerDay(rdr, data, startDay);
                        ProcessMonthlySales(rdr, data, startMonth);
                        ProcessScalarValues(rdr, data);
                        ProcessCountrySales(rdr, data, countryId);
                        ProcessTimelineEvents(rdr, data);
                    }
                }
            }

            return data;
        }

        private void ProcessOrdersPerDay(SqlDataReader rdr, DashboardData data, DateTime startDay)
        {
            var tmpOrders = new Dictionary<DateTime, int>();
            while (rdr.Read())
            {
                var day = Convert.ToDateTime(rdr["Day"]);
                var cnt = Convert.ToInt32(rdr["OrderCount"]);
                tmpOrders[day.Date] = cnt;
            }

            for (int i = 0; i < 7; i++)
            {
                var d = startDay.AddDays(i);
                data.OrdersLast7[i] = tmpOrders.TryGetValue(d, out var v) ? v : 0;
            }
        }

        private void ProcessSalesPerDay(SqlDataReader rdr, DashboardData data, DateTime startDay)
        {
            rdr.NextResult();
            var tmpSales = new Dictionary<DateTime, decimal>();
            while (rdr.Read())
            {
                var day = Convert.ToDateTime(rdr["Day"]);
                var amt = rdr["TotalAmount"] == DBNull.Value ? 0m : Convert.ToDecimal(rdr["TotalAmount"]);
                tmpSales[day.Date] = amt;
            }

            for (int i = 0; i < 7; i++)
            {
                var d = startDay.AddDays(i);
                data.SalesLast7[i] = tmpSales.TryGetValue(d, out var v) ? v : 0m;
            }
        }

        private void ProcessMonthlySales(SqlDataReader rdr, DashboardData data, DateTime startMonth)
        {
            rdr.NextResult();
            var tmpMonthly = new Dictionary<(int Y, int M), decimal>();
            while (rdr.Read())
            {
                int y = Convert.ToInt32(rdr["Y"]);
                int m = Convert.ToInt32(rdr["M"]);
                decimal sum = rdr["TotalAmount"] == DBNull.Value ? 0m : Convert.ToDecimal(rdr["TotalAmount"]);
                tmpMonthly[(y, m)] = sum;
            }

            for (int i = 0; i < 6; i++)
            {
                var dt = startMonth.AddMonths(i);
                var key = (dt.Year, dt.Month);
                var sum = tmpMonthly.TryGetValue(key, out var v) ? v : 0m;
                data.SalesMonthly6.Add((dt.Year, dt.Month, sum));
            }
        }

        private void ProcessScalarValues(SqlDataReader rdr, DashboardData data)
        {
            // Users Count
            rdr.NextResult();
            if (rdr.Read())
                data.UsersCountByCountry = Convert.ToInt32(rdr["UsersCountByCountry"]);

            // Today Registered Users
            rdr.NextResult();
            if (rdr.Read())
                data.TodayRegisteredUsers = Convert.ToInt32(rdr["TodayRegisteredUsers"]);

            // Today Sales Amount
            rdr.NextResult();
            if (rdr.Read())
                data.TodaySalesAmount = rdr["TodaySalesAmount"] == DBNull.Value ? 0m : Convert.ToDecimal(rdr["TodaySalesAmount"]);

            // Today Orders
            rdr.NextResult();
            if (rdr.Read())
                data.TodayOrders = Convert.ToInt32(rdr["TodayOrders"]);

            // Today Delivery Amount
            rdr.NextResult();
            if (rdr.Read())
                data.TodayDeliveryAmount = rdr["TodayDeliveryAmount"] == DBNull.Value ? 0m : Convert.ToDecimal(rdr["TodayDeliveryAmount"]);

            // Companies Count
            rdr.NextResult();
            if (rdr.Read())
                data.CompaniesCount = Convert.ToInt32(rdr["CompaniesCount"]);
        }

        private void ProcessCountrySales(SqlDataReader rdr, DashboardData data, int countryId)
        {
            rdr.NextResult();
            var tmpCountrySales = new List<CountrySales>();
            decimal grandTotal = 0;

            while (rdr.Read())
            {
                var cs = new CountrySales
                {
                    CountryId = Convert.ToInt32(rdr["CountryId"]),
                    CountryName = rdr["countryName"].ToString(),
                    TotalSales = rdr["TotalSales"] == DBNull.Value ? 0m : Convert.ToDecimal(rdr["TotalSales"]),
                    CurrencySymbol = GetCurrencySymbolByCountry(Convert.ToInt32(rdr["CountryId"]))
                };
                tmpCountrySales.Add(cs);
                grandTotal += cs.TotalSales;
            }

            // Calculate percentages
            foreach (var cs in tmpCountrySales)
            {
                cs.Percentage = grandTotal > 0 ? Math.Round((cs.TotalSales / grandTotal) * 100, 2) : 0;
            }

            data.CountrySalesList = tmpCountrySales;
        }

        private void ProcessTimelineEvents(SqlDataReader rdr, DashboardData data)
        {
            rdr.NextResult();
            while (rdr.Read())
            {
                data.TimelineEvents.Add(new TimelineEvent
                {
                    Title = rdr["Title"].ToString(),
                    Description = rdr["Description"].ToString(),
                    EventDate = Convert.ToDateTime(rdr["EventDate"]),
                    Icon = rdr["Icon"].ToString(),
                    Color = rdr["Color"].ToString()
                });
            }
        }

        // Helper methods remain the same
        private int GetCountryIdFromCookieOrDefault()
        {
            try
            {
                var c = Request.Cookies["mSelectedCountry"];
                if (c != null && int.TryParse(c.Value, out int id))
                    return id;
            }
            catch { }
            return 1;
        }

        private int GetCompanyIdFromCookieOrDefault()
        {
            try
            {
                var c = Request.Cookies["mSelectedCompany"];
                if (c != null && int.TryParse(c.Value, out int id))
                    return id;
            }
            catch { }
            return 1000;
        }

        private string GetCurrencySymbolByCountry(int countryId)
        {
            switch (countryId)
            {
                case 1: return "د.أ";   // الأردن
                case 2: return "د.أ";   // العقبة
                case 3: return "ر.ق";   // قطر
                case 4: return "د.ب";   // البحرين
                case 5: return "د.إ";   // الإمارات
                case 6: return "د.ك";   // الكويت
                default: return "";
            }
        }

        private string GetArabicDayName(DayOfWeek dayOfWeek)
        {
            switch (dayOfWeek)
            {
                case DayOfWeek.Sunday: return "الأحد";
                case DayOfWeek.Monday: return "الاثنين";
                case DayOfWeek.Tuesday: return "الثلاثاء";
                case DayOfWeek.Wednesday: return "الأربعاء";
                case DayOfWeek.Thursday: return "الخميس";
                case DayOfWeek.Friday: return "الجمعة";
                case DayOfWeek.Saturday: return "السبت";
                default: return "---";
            }
        }

        // Properties for ASPX binding
        protected List<int> OrdersLast7 => CurrentData?.OrdersLast7 ?? new List<int>();
        protected List<decimal> SalesLast7 => CurrentData?.SalesLast7 ?? new List<decimal>();
        protected List<(int Y, int M, decimal Sum)> SalesMonthly6 => CurrentData?.SalesMonthly6 ?? new List<(int Y, int M, decimal Sum)>();
        protected List<CountrySales> CountrySalesList => CurrentData?.CountrySalesList ?? new List<CountrySales>();
        protected List<TimelineEvent> TimelineEvents => CurrentData?.TimelineEvents ?? new List<TimelineEvent>();
        protected string SelectedCurrencySymbol => CurrentData?.SelectedCurrencySymbol ?? "";
        protected int UsersCountByCountry => CurrentData?.UsersCountByCountry ?? 0;
        protected int TodayRegisteredUsers => CurrentData?.TodayRegisteredUsers ?? 0;
        protected decimal TodaySalesAmount => CurrentData?.TodaySalesAmount ?? 0m;
        protected int TodayOrders => CurrentData?.TodayOrders ?? 0;
        protected decimal TodayDeliveryAmount => CurrentData?.TodayDeliveryAmount ?? 0m;
        protected int CompaniesCount => CurrentData?.CompaniesCount ?? 0;

        // JSON serialization methods
        protected string GetLast7DayLabelsArabic()
        {
            var labels = new List<string>();
            for (int i = 6; i >= 0; i--)
            {
                var d = DateTime.Now.AddDays(-i).DayOfWeek;
                labels.Add(GetArabicDayName(d));
            }
            return new JavaScriptSerializer().Serialize(labels);
        }

        protected string GetOrdersLast7Json()
            => new JavaScriptSerializer().Serialize(OrdersLast7);

        protected string GetSalesLast7Json()
            => new JavaScriptSerializer().Serialize(SalesLast7);

        protected string GetMonthlyLabelsJson()
        {
            var culture = new CultureInfo("ar-JO");
            var labels = SalesMonthly6
                .Select(x => new DateTime(x.Y, x.M, 1))
                .Select(d => culture.DateTimeFormat.GetMonthName(d.Month) + " " + d.Year)
                .ToList();
            return new JavaScriptSerializer().Serialize(labels);
        }

        protected string GetMonthlyDataJson()
            => new JavaScriptSerializer().Serialize(SalesMonthly6.Select(x => x.Sum).ToList());

        // Data classes
        public class DashboardData
        {
            public List<int> OrdersLast7 { get; set; }
            public List<decimal> SalesLast7 { get; set; }
            public List<(int Y, int M, decimal Sum)> SalesMonthly6 { get; set; }
            public List<CountrySales> CountrySalesList { get; set; }
            public List<TimelineEvent> TimelineEvents { get; set; }
            public string SelectedCurrencySymbol { get; set; }
            public int UsersCountByCountry { get; set; }
            public int TodayRegisteredUsers { get; set; }
            public decimal TodaySalesAmount { get; set; }
            public int TodayOrders { get; set; }
            public decimal TodayDeliveryAmount { get; set; }
            public int CompaniesCount { get; set; }
        }

        public class CountrySales
        {
            public int CountryId { get; set; }
            public string CountryName { get; set; }
            public decimal TotalSales { get; set; }
            public decimal Percentage { get; set; }
            public string CurrencySymbol { get; set; }
        }

        public class TimelineEvent
        {
            public string Title { get; set; }
            public string Description { get; set; }
            public DateTime EventDate { get; set; }
            public string Icon { get; set; }
            public string Color { get; set; }
        }
    }
}