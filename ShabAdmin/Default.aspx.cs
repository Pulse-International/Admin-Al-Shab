using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.UI;

namespace ShabAdmin
{
    public partial class Default : Page
    {
        protected DashboardData CurrentData { get; set; }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string code = Request.QueryString["i"];

                if (!string.IsNullOrEmpty(code))
                {
                    RedirectShortLink(code);
                    return; 
                }

                LoadDashboardData();
            }
        }

        private void RedirectShortLink(string code)
        {
            string connStr = ConfigurationManager.ConnectionStrings["ShabDB_connection"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                string sql = "SELECT link FROM shortlinks WHERE code = @code";

                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@code", code);

                    object result = cmd.ExecuteScalar();

                    if (result != null)
                    {
                        string originalLink = result.ToString();
                        Response.Redirect(originalLink, true);
                    }
                    return;
                }
            }
        }
        private void LoadDashboardData()
        {
            int countryId = GetCountryIdFromCookieOrDefault();
            int companyId = GetCompanyIdFromCookieOrDefault();

            CurrentData = LoadDashboardDataFromDb(countryId, companyId);
        }

        private DashboardData LoadDashboardDataFromDb(int countryId, int companyId)
        {
            var data = new DashboardData
            {
                SelectedCurrencySymbol = GetCurrencySymbolByCountry(countryId),
                ProductSalesLast7 = new List<decimal>(),
                ProductSalesLast6Months = new List<decimal>(),
                TopProductsToday = new List<(string ProductName, int SalesCount)>(),
                CountrySalesList = new List<CountrySales>(),
                Last6ProductsSold = new List<(string ProductName, int OrderId, DateTime OrderDate)>()
            };

            var startDay = DateTime.Now.Date.AddDays(-6);
            var startMonth = new DateTime(DateTime.Now.Year, DateTime.Now.Month, 1).AddMonths(-5);

            using (var cn = new SqlConnection(ConfigurationManager.ConnectionStrings["ShabDB_connection"].ConnectionString))
            {
                cn.Open();

                // الإجراء الوحيد: blueDashboardData
                using (var cmd2 = new SqlCommand("dbo.blueDashboardData", cn))
                {
                    cmd2.CommandType = System.Data.CommandType.StoredProcedure;
                    cmd2.Parameters.AddWithValue("@CountryId", countryId);
                    cmd2.Parameters.AddWithValue("@CompanyId", companyId);

                    using (var rdr2 = cmd2.ExecuteReader())
                    {
                        // 1) ProductsSoldToday
                        if (rdr2.Read())
                            data.ProductsSoldToday = rdr2["ProductsSoldToday"] == DBNull.Value ? 0 : Convert.ToInt32(rdr2["ProductsSoldToday"]);

                        // 2) SalesFromCartsToday
                        if (rdr2.NextResult() && rdr2.Read())
                            data.SalesFromCartsToday = rdr2["SalesFromCartsToday"] == DBNull.Value ? 0m : Convert.ToDecimal(rdr2["SalesFromCartsToday"]);

                        // 3) BranchesCount
                        if (rdr2.NextResult() && rdr2.Read())
                            data.BranchesCount = rdr2["BranchesCount"] == DBNull.Value ? 0 : Convert.ToInt32(rdr2["BranchesCount"]);

                        // 4) CategoriesSoldToday
                        if (rdr2.NextResult() && rdr2.Read())
                            data.CategoriesSoldToday = rdr2["CategoriesSoldToday"] == DBNull.Value ? 0 : Convert.ToInt32(rdr2["CategoriesSoldToday"]);

                        // 5) ProductSalesLast7
                        if (rdr2.NextResult())
                        {
                            var tmpProductSales = new Dictionary<DateTime, decimal>();
                            startDay = DateTime.Now.Date.AddDays(-6);

                            while (rdr2.Read())
                            {
                                var day = Convert.ToDateTime(rdr2["Day"]);
                                var amt = rdr2["ProductSales"] == DBNull.Value ? 0m : Convert.ToDecimal(rdr2["ProductSales"]);
                                tmpProductSales[day.Date] = amt;
                            }

                            for (int i = 0; i < 7; i++)
                            {
                                var d = startDay.AddDays(i);
                                data.ProductSalesLast7.Add(tmpProductSales.TryGetValue(d, out var v) ? v : 0m);
                            }
                        }

                        // 6) ProductSalesLast6Months
                        if (rdr2.NextResult())
                        {
                            var tmpMonthly = new Dictionary<(int Y, int M), decimal>();
                            startMonth = new DateTime(DateTime.Now.Year, DateTime.Now.Month, 1).AddMonths(-5);

                            while (rdr2.Read())
                            {
                                int y = Convert.ToInt32(rdr2["Y"]);
                                int m = Convert.ToInt32(rdr2["M"]);
                                decimal sum = rdr2["ProductSales"] == DBNull.Value ? 0m : Convert.ToDecimal(rdr2["ProductSales"]);
                                tmpMonthly[(y, m)] = sum;
                            }

                            for (int i = 0; i < 6; i++)
                            {
                                var dt = startMonth.AddMonths(i);
                                var key = (dt.Year, dt.Month);
                                data.ProductSalesLast6Months.Add(tmpMonthly.TryGetValue(key, out var v) ? v : 0m);
                            }
                        }

                        // 7) CountrySalesCountAllTime
                        if (rdr2.NextResult())
                        {
                            var tmpCountrySales = new List<CountrySales>();
                            Decimal grandCount = 0;

                            while (rdr2.Read())
                            {
                                var cs = new CountrySales
                                {
                                    CountryId = Convert.ToInt32(rdr2["CountryId"]),
                                    CountryName = rdr2["CountryName"].ToString(),
                                    SalesAmount = rdr2["SalesAmount"] == DBNull.Value ? 0 : (decimal)(rdr2["SalesAmount"]),
                                    CurrencySymbol = GetCurrencySymbolByCountry(Convert.ToInt32(rdr2["CountryId"]))
                                };
                                tmpCountrySales.Add(cs);
                                grandCount += (decimal)cs.SalesAmount;
                            }

                            foreach (var cs in tmpCountrySales)
                            {
                                cs.Percentage = grandCount > 0
                                    ? Math.Round((cs.SalesAmount * 100m) / grandCount, 2)
                                    : 0;
                            }

                            data.CountrySalesList = tmpCountrySales;
                        }

                        // 8) Last 6 products sold
                        if (rdr2.NextResult())
                        {
                            while (rdr2.Read())
                            {
                                string productName = rdr2["name"].ToString();
                                int orderId = Convert.ToInt32(rdr2["OrderId"]);
                                DateTime orderDate = Convert.ToDateTime(rdr2["OrderDate"]);
                                data.Last6ProductsSold.Add((productName, orderId, orderDate));
                            }
                        }

                        // 9) TopProductsToday
                        if (rdr2.NextResult())
                        {
                            while (rdr2.Read())
                            {
                                string name = rdr2["name"].ToString();
                                int count = Convert.ToInt32(rdr2["SalesCount"]);
                                data.TopProductsToday.Add((name, count));
                            }
                        }

                        // 10) Fallback TopProducts
                        if (data.TopProductsToday.Count == 0 && rdr2.NextResult())
                        {
                            while (rdr2.Read())
                            {
                                string name = rdr2["name"].ToString();
                                int count = Convert.ToInt32(rdr2["SalesCount"]);
                                data.TopProductsToday.Add((name, count));
                            }
                        }
                    }
                }
            }

            return data;
        }

        private int GetCountryIdFromCookieOrDefault()
        {
            try
            {
                var c = Request.Cookies["SelectedCountry"];
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
                var c = Request.Cookies["SelectedCompany"];
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
                case 1: return "د.أ";
                case 2: return "د.أ";
                case 3: return "ر.ق";
                case 4: return "د.ب";
                case 5: return "د.إ";
                case 6: return "د.ك";
                default: return "";
            }
        }

        // JSON serialization
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

        // Properties exposed to ASPX
        protected int ProductsSoldToday => CurrentData?.ProductsSoldToday ?? 0;
        protected decimal SalesFromCartsToday => CurrentData?.SalesFromCartsToday ?? 0m;
        protected int BranchesCount => CurrentData?.BranchesCount ?? 0;
        protected int CategoriesSoldToday => CurrentData?.CategoriesSoldToday ?? 0;

        protected List<(string ProductName, int SalesCount)> TopProductsToday
            => CurrentData?.TopProductsToday ?? new List<(string, int)>();

        protected List<decimal> ProductSalesLast7
            => CurrentData?.ProductSalesLast7 ?? new List<decimal>();

        protected List<decimal> ProductSalesLast6Months
            => CurrentData?.ProductSalesLast6Months ?? new List<decimal>();

        protected List<CountrySales> CountrySalesList
            => CurrentData?.CountrySalesList ?? new List<CountrySales>();

        protected List<(string ProductName, int OrderId, DateTime OrderDate)> Last6ProductsSold
            => CurrentData?.Last6ProductsSold ?? new List<(string, int, DateTime)>();

        protected string SelectedCurrencySymbol
            => CurrentData?.SelectedCurrencySymbol ?? "";

        protected string GetProductSalesLast7Json()
            => new JavaScriptSerializer().Serialize(CurrentData?.ProductSalesLast7 ?? new List<decimal>());

        protected string GetTopProductsTodayLabelsJson()
            => new JavaScriptSerializer().Serialize(
                CurrentData?.TopProductsToday.Select(x => x.ProductName).ToList() ?? new List<string>());

        protected string GetTopProductsTodayDataJson()
            => new JavaScriptSerializer().Serialize(
                CurrentData?.TopProductsToday.Select(x => x.SalesCount).ToList() ?? new List<int>());

        protected string GetProductSalesLast6MonthsJson()
            => new JavaScriptSerializer().Serialize(CurrentData?.ProductSalesLast6Months ?? new List<decimal>());

        protected string GetProductSalesLast6MonthsLabelsJson()
        {
            var culture = new CultureInfo("ar-JO");
            var startMonth = new DateTime(DateTime.Now.Year, DateTime.Now.Month, 1).AddMonths(-5);
            var labels = new List<string>();

            for (int i = 0; i < 6; i++)
            {
                var dt = startMonth.AddMonths(i);
                labels.Add(culture.DateTimeFormat.GetMonthName(dt.Month) + " " + dt.Year);
            }

            return new JavaScriptSerializer().Serialize(labels);
        }

        // Data classes
        public class DashboardData
        {
            public int ProductsSoldToday { get; set; }
            public decimal SalesFromCartsToday { get; set; }
            public int BranchesCount { get; set; }
            public int CategoriesSoldToday { get; set; }
            public List<decimal> ProductSalesLast7 { get; set; }
            public List<decimal> ProductSalesLast6Months { get; set; }
            public List<(string ProductName, int SalesCount)> TopProductsToday { get; set; }
            public List<CountrySales> CountrySalesList { get; set; }
            public List<(string ProductName, int OrderId, DateTime OrderDate)> Last6ProductsSold { get; set; }
            public string SelectedCurrencySymbol { get; set; }
        }

        public class CountrySales
        {
            public int CountryId { get; set; }
            public string CountryName { get; set; }
            public Decimal SalesAmount { get; set; }
            public decimal Percentage { get; set; }
            public string CurrencySymbol { get; set; }
        }
    }
}