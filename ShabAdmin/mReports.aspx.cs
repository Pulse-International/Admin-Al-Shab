using Antlr.Runtime.Misc;
using DevExpress.Web;
using DevExpress.Web.Data;
using System;
using System.Collections.Generic;
using System.ComponentModel.Design;
using System.Configuration;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using System.Diagnostics;
using System.Drawing;
using System.Drawing.Imaging;
using System.IO;
using System.Linq;
using System.Net.NetworkInformation;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ShabAdmin
{
    public partial class Reports : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void Page_Init(object sender, EventArgs e)
        {
            var (countryId, companyId) = GetUserPrivileges();

            // Clear all parameters first
            dsOrders.SelectParameters.Clear();
            dsOrdersInfo.SelectParameters.Clear();
            db_AppUsers.SelectParameters.Clear();
            db_Branches.SelectParameters.Clear();
            dsCountries.SelectParameters.Clear();
            dsCompanies.SelectParameters.Clear();
            dsBranches.SelectParameters.Clear();

            // Set default date parameters
            DateTime defaultFromDate = new DateTime(2025, 1, 1);
            DateTime defaultToDate = DateTime.Now;

            if (countryId != 1000 && companyId != 1000)
            {
                #region Both Country and Company Restricted

                // dsOrders - Financial Tab
                dsOrders.SelectCommand = @"
            SELECT 
                o.[id], 
                o.[companyId], 
                c.[countryID] AS countryId, 
                c.[companyName] AS companyName, 
                co.[countryName] AS countryName,
                o.[username], 
                u.[firstName] + ' ' + u.[lastName] AS fullName,
                o.[addressId], 
                o.[amount], 
                o.[deliveryAmount], 
                o.[taxAmount], 
                o.[totalAmount], 
                o.[couponId], 
                o.[l_paymentMethodId],
                o.[l_RefundType],
                pm.[description] AS paymentMethod, 
                br.[name] AS branchName, 
                o.[transactionId], 
                o.[invoiceNo], 
                o.[notes], 
                o.[l_orderStatus], 
                os.[description] AS orderStatus,  
                o.[refundedAmount], 
                o.[realTotalAmount], 
                o.[realTax], 
                o.[userDate]
            FROM [Orders] o
            JOIN [companies] c ON o.companyId = c.id
            LEFT JOIN l_paymentMethod pm ON o.l_paymentMethodId = pm.id
            LEFT JOIN branches br ON o.branchId = br.id
            LEFT JOIN countries co ON c.countryID = co.id
            LEFT JOIN l_orderStatus os ON o.l_orderStatus = os.id
            LEFT JOIN [usersApp] u ON o.username = u.username
            WHERE 
                o.l_orderStatus = 4
                AND (co.id = @countryId OR @countryId = 0 )
                AND (c.id = @companyId OR @companyId = 0 )
                AND (br.id = @branchId OR @branchId = 0)
                AND o.userDate BETWEEN @dateFrom AND @dateTo
            ORDER BY o.id DESC";

                dsOrders.SelectParameters.Add("countryId", countryId.ToString());
                dsOrders.SelectParameters.Add("companyId", companyId.ToString());
                dsOrders.SelectParameters.Add("branchId", "0");
                dsOrders.SelectParameters.Add("dateFrom", TypeCode.DateTime, defaultFromDate.ToString());
                dsOrders.SelectParameters.Add("dateTo", TypeCode.DateTime, defaultToDate.ToString());

                // dsOrdersInfo - Orders Tab
                dsOrdersInfo.SelectCommand = @"
            SELECT 
                o.[id], 
                o.[companyId], 
                c.[countryID] AS countryId, 
                c.[companyName] AS companyName, 
                co.[countryName] AS countryName,
                o.[username], 
                u.[firstName] + ' ' + u.[lastName] AS fullName,
                o.[addressId], 
                o.[amount], 
                o.[deliveryAmount], 
                o.[taxAmount], 
                o.[totalAmount], 
                o.[couponId], 
                o.[l_paymentMethodId],
                o.[l_RefundType],
                pm.[description] AS paymentMethod, 
                br.[name] AS branchName, 
                o.[transactionId], 
                o.[invoiceNo], 
                o.[notes], 
                o.[l_orderStatus], 
                os.[description] AS orderStatus,  
                o.[refundedAmount], 
                o.[realTotalAmount], 
                c.[maxDeliveryTime],
                c.[minDeliveryTime],
                o.[realTax], 
                o.[userDate]
            FROM [Orders] o
            JOIN [companies] c ON o.companyId = c.id
            LEFT JOIN l_paymentMethod pm ON o.l_paymentMethodId = pm.id
            LEFT JOIN branches br ON o.branchId = br.id
            LEFT JOIN countries co ON c.countryID = co.id
            LEFT JOIN l_orderStatus os ON o.l_orderStatus = os.id
            LEFT JOIN [usersApp] u ON o.username = u.username
            WHERE 
                (@countryId = 0 OR co.id = @countryId)
                AND (@companyId = 0 OR c.id = @companyId )
                AND (@StatusId = 0 OR o.l_orderStatus = @StatusId)
                AND (@PaymentMethodId = 0 OR o.l_paymentMethodId = @PaymentMethodId)
                AND o.userDate BETWEEN @dateFrom1 AND @dateTo1
            ORDER BY o.id DESC";

                dsOrdersInfo.SelectParameters.Add("countryId", countryId.ToString());
                dsOrdersInfo.SelectParameters.Add("companyId", companyId.ToString());
                dsOrdersInfo.SelectParameters.Add("StatusId", "0");
                dsOrdersInfo.SelectParameters.Add("PaymentMethodId", "0");
                dsOrdersInfo.SelectParameters.Add("dateFrom1", TypeCode.DateTime, defaultFromDate.ToString());
                dsOrdersInfo.SelectParameters.Add("dateTo1", TypeCode.DateTime, defaultToDate.ToString());

                // db_AppUsers - Users Tab
                db_AppUsers.SelectCommand = @"
            SELECT 
                u.id,
                u.username,
                u.firstName,
                u.lastName,
                COUNT(CASE WHEN o.id IS NOT NULL AND o.companyId = @companyId2
                      AND CAST(o.userDate AS DATE) BETWEEN @FromDate2 AND @ToDate2 
                      THEN o.id END) AS OrderCount,
                ISNULL(SUM(CASE WHEN o.companyId = @companyId2 AND CAST(o.userDate AS DATE) BETWEEN @FromDate2 AND @ToDate2 
                           THEN o.totalAmount ELSE 0 END), 0) AS TotalAmount,
                u.isActive,
                u.balance,
                u.freeDeliveryCount,
                u.l_userLevelId,
                u.twoAuthenticationEnabled,
                u.userPoints,
                u.isDeleted,
                LEFT(u.FCMToken, 5) AS FCMToken,
                u.userPlatform,
                c.countryCode,
                c.id AS countryId
            FROM usersApp u
            LEFT JOIN orders o ON u.username = o.username
            LEFT JOIN countries c ON u.countryCode = c.countryCode
            WHERE c.id = @countryId2
            GROUP BY 
                u.id, u.username, u.firstName, u.lastName, 
                u.isActive, u.balance, u.freeDeliveryCount, u.l_userLevelId,
                u.twoAuthenticationEnabled, u.userPoints, u.isDeleted,
                u.FCMToken, u.userPlatform, c.countryCode, c.id
            HAVING 
                (@Option2 = 0)
                OR (@Option2 = 1 AND COUNT(CASE WHEN o.id IS NOT NULL AND o.companyId = @companyId2
                    AND CAST(o.userDate AS DATE) BETWEEN @FromDate2 AND @ToDate2 
                    THEN o.id END) > 0)
                OR (@Option2 = 2 AND COUNT(CASE WHEN o.id IS NOT NULL AND o.companyId = @companyId2
                    AND CAST(o.userDate AS DATE) BETWEEN @FromDate2 AND @ToDate2 
                    THEN o.id END) = 0)
            ORDER BY TotalAmount DESC, OrderCount DESC";

                db_AppUsers.SelectParameters.Add("countryId2", countryId.ToString());
                db_AppUsers.SelectParameters.Add("companyId2", companyId.ToString());
                db_AppUsers.SelectParameters.Add("FromDate2", TypeCode.DateTime, defaultFromDate.ToString());
                db_AppUsers.SelectParameters.Add("ToDate2", TypeCode.DateTime, defaultToDate.ToString());
                db_AppUsers.SelectParameters.Add("Country2", "0");
                db_AppUsers.SelectParameters.Add("Option2", "0");

                // db_Branches - Branches Section
                db_Branches.SelectCommand = @"
            SELECT 
                b.[id], 
                b.[name], 
                b.[l_branchStatus],
                b.[countryId], 
                b.[companyId], 
                c.[companyName],
                b.[cityId],
                b.[latitude], 
                b.[longitude], 
                b.[phone], 
                b.[extensionNumber],
                b.[isMain],
                ISNULL(SUM(o.totalAmount), 0) AS TotalSales
            FROM branches b
            LEFT JOIN companies c ON b.companyId = c.id
            LEFT JOIN orders o ON o.branchId = b.id AND CAST(o.userDate AS DATE) BETWEEN @FromDate4 AND @ToDate4
            WHERE b.countryId = @countryId4 AND b.companyId = @companyId4
            GROUP BY 
                b.[id], b.[name], b.[l_branchStatus], b.[countryId], b.[companyId], 
                c.[companyName], b.[cityId], b.[latitude], b.[longitude], 
                b.[phone], b.[extensionNumber], b.[isMain]
            ORDER BY TotalSales DESC";

                db_Branches.SelectParameters.Add("countryId4", countryId.ToString());
                db_Branches.SelectParameters.Add("companyId4", companyId.ToString());
                db_Branches.SelectParameters.Add("FromDate4", TypeCode.DateTime, defaultFromDate.ToString());
                db_Branches.SelectParameters.Add("ToDate4", TypeCode.DateTime, defaultToDate.ToString());

                // Filter dropdowns
                dsCountries.SelectCommand = "SELECT id, countryName, countryCode FROM countries WHERE id = @countryId";
                dsCountries.SelectParameters.Add("countryId", countryId.ToString());

                dsCompanies.SelectCommand = "SELECT id, companyName FROM companies WHERE id = @companyId";
                dsCompanies.SelectParameters.Add("companyId", companyId.ToString());

                dsBranches.SelectCommand = "SELECT id, name, companyId FROM branches WHERE companyId = @companyId";
                dsBranches.SelectParameters.Add("companyId", companyId.ToString());

                #endregion
            }
            else if (countryId != 1000)
            {
                #region Country Only Restricted

                // dsOrders - Financial Tab
                dsOrders.SelectCommand = @"
            SELECT 
                o.[id], 
                o.[companyId], 
                c.[countryID] AS countryId, 
                c.[companyName] AS companyName, 
                co.[countryName] AS countryName,
                o.[username], 
                u.[firstName] + ' ' + u.[lastName] AS fullName,
                o.[addressId], 
                o.[amount], 
                o.[deliveryAmount], 
                o.[taxAmount], 
                o.[totalAmount], 
                o.[couponId], 
                o.[l_paymentMethodId],
                o.[l_RefundType],
                pm.[description] AS paymentMethod, 
                br.[name] AS branchName, 
                o.[transactionId], 
                o.[invoiceNo], 
                o.[notes], 
                o.[l_orderStatus], 
                os.[description] AS orderStatus,  
                o.[refundedAmount], 
                o.[realTotalAmount], 
                o.[realTax], 
                o.[userDate]
            FROM [Orders] o
            JOIN [companies] c ON o.companyId = c.id
            LEFT JOIN l_paymentMethod pm ON o.l_paymentMethodId = pm.id
            LEFT JOIN branches br ON o.branchId = br.id
            LEFT JOIN countries co ON c.countryID = co.id
            LEFT JOIN l_orderStatus os ON o.l_orderStatus = os.id
            LEFT JOIN [usersApp] u ON o.username = u.username
            WHERE 
                o.l_orderStatus = 4
                AND c.countryID = @countryId
                AND (c.id = @companyId OR @companyId = 0)
                AND (br.id = @branchId OR @branchId = 0)
                AND o.userDate BETWEEN @dateFrom AND @dateTo
            ORDER BY o.id DESC";

                dsOrders.SelectParameters.Add("countryId", countryId.ToString());
                dsOrders.SelectParameters.Add("companyId", "0");
                dsOrders.SelectParameters.Add("branchId", "0");
                dsOrders.SelectParameters.Add("dateFrom", TypeCode.DateTime, defaultFromDate.ToString());
                dsOrders.SelectParameters.Add("dateTo", TypeCode.DateTime, defaultToDate.ToString());

                // dsOrdersInfo - Orders Tab
                dsOrdersInfo.SelectCommand = @"
            SELECT 
                o.[id], 
                o.[companyId], 
                c.[countryID] AS countryId, 
                c.[companyName] AS companyName, 
                co.[countryName] AS countryName,
                o.[username], 
                u.[firstName] + ' ' + u.[lastName] AS fullName,
                o.[addressId], 
                o.[amount], 
                o.[deliveryAmount], 
                o.[taxAmount], 
                o.[totalAmount], 
                o.[couponId], 
                o.[l_paymentMethodId],
                o.[l_RefundType],
                pm.[description] AS paymentMethod, 
                br.[name] AS branchName, 
                o.[transactionId], 
                o.[invoiceNo], 
                o.[notes], 
                o.[l_orderStatus], 
                os.[description] AS orderStatus,  
                o.[refundedAmount], 
                o.[realTotalAmount], 
                c.[maxDeliveryTime],
                c.[minDeliveryTime],
                o.[realTax], 
                o.[userDate]
            FROM [Orders] o
            JOIN [companies] c ON o.companyId = c.id
            LEFT JOIN l_paymentMethod pm ON o.l_paymentMethodId = pm.id
            LEFT JOIN branches br ON o.branchId = br.id
            LEFT JOIN countries co ON c.countryID = co.id
            LEFT JOIN l_orderStatus os ON o.l_orderStatus = os.id
            LEFT JOIN [usersApp] u ON o.username = u.username
            WHERE 
                c.countryID = @countryId
                AND (o.l_orderStatus = @StatusId OR @StatusId = 0)
                AND (o.l_paymentMethodId = @PaymentMethodId OR @PaymentMethodId = 0)
                AND o.userDate BETWEEN @dateFrom1 AND @dateTo1
            ORDER BY o.id DESC";

                dsOrdersInfo.SelectParameters.Add("countryId", countryId.ToString());
                dsOrdersInfo.SelectParameters.Add("StatusId", "0");
                dsOrdersInfo.SelectParameters.Add("PaymentMethodId", "0");
                dsOrdersInfo.SelectParameters.Add("dateFrom1", TypeCode.DateTime, defaultFromDate.ToString());
                dsOrdersInfo.SelectParameters.Add("dateTo1", TypeCode.DateTime, defaultToDate.ToString());

                // db_AppUsers - Users Tab
                db_AppUsers.SelectCommand = @"
            SELECT 
                u.id,
                u.username,
                u.firstName,
                u.lastName,
                COUNT(CASE WHEN o.id IS NOT NULL 
                      AND CAST(o.userDate AS DATE) BETWEEN @FromDate2 AND @ToDate2 
                      THEN o.id END) AS OrderCount,
                ISNULL(SUM(CASE WHEN CAST(o.userDate AS DATE) BETWEEN @FromDate2 AND @ToDate2 
                           THEN o.totalAmount ELSE 0 END), 0) AS TotalAmount,
                u.isActive,
                u.balance,
                u.freeDeliveryCount,
                u.l_userLevelId,
                u.twoAuthenticationEnabled,
                u.userPoints,
                u.isDeleted,
                LEFT(u.FCMToken, 5) AS FCMToken,
                u.userPlatform,
                c.countryCode,
                c.id AS countryId
            FROM usersApp u
            LEFT JOIN orders o ON u.username = o.username
            LEFT JOIN countries c ON u.countryCode = c.countryCode
            WHERE c.id = @countryId2
            GROUP BY 
                u.id, u.username, u.firstName, u.lastName, 
                u.isActive, u.balance, u.freeDeliveryCount, u.l_userLevelId,
                u.twoAuthenticationEnabled, u.userPoints, u.isDeleted,
                u.FCMToken, u.userPlatform, c.countryCode, c.id
            HAVING 
                (@Option2 = 0)
                OR (@Option2 = 1 AND COUNT(CASE WHEN o.id IS NOT NULL 
                    AND CAST(o.userDate AS DATE) BETWEEN @FromDate2 AND @ToDate2 
                    THEN o.id END) > 0)
                OR (@Option2 = 2 AND COUNT(CASE WHEN o.id IS NOT NULL 
                    AND CAST(o.userDate AS DATE) BETWEEN @FromDate2 AND @ToDate2 
                    THEN o.id END) = 0)
            ORDER BY TotalAmount DESC, OrderCount DESC";

                db_AppUsers.SelectParameters.Add("countryId2", countryId.ToString());
                db_AppUsers.SelectParameters.Add("FromDate2", TypeCode.DateTime, defaultFromDate.ToString());
                db_AppUsers.SelectParameters.Add("ToDate2", TypeCode.DateTime, defaultToDate.ToString());
                db_AppUsers.SelectParameters.Add("Country2", "0");
                db_AppUsers.SelectParameters.Add("Option2", "0");

                // db_Branches - Branches Section
                db_Branches.SelectCommand = @"
            SELECT 
                b.[id], 
                b.[name], 
                b.[l_branchStatus],
                b.[countryId], 
                b.[companyId], 
                c.[companyName],
                b.[cityId],
                b.[latitude], 
                b.[longitude], 
                b.[phone], 
                b.[extensionNumber],
                b.[isMain],
                ISNULL(SUM(o.totalAmount), 0) AS TotalSales
            FROM branches b
            LEFT JOIN companies c ON b.companyId = c.id
            LEFT JOIN orders o ON o.branchId = b.id AND CAST(o.userDate AS DATE) BETWEEN @FromDate4 AND @ToDate4
            WHERE b.countryId = @countryId4
            GROUP BY 
                b.[id], b.[name], b.[l_branchStatus], b.[countryId], b.[companyId], 
                c.[companyName], b.[cityId], b.[latitude], b.[longitude], 
                b.[phone], b.[extensionNumber], b.[isMain]
            ORDER BY TotalSales DESC";

                db_Branches.SelectParameters.Add("countryId4", countryId.ToString());
                db_Branches.SelectParameters.Add("FromDate4", TypeCode.DateTime, defaultFromDate.ToString());
                db_Branches.SelectParameters.Add("ToDate4", TypeCode.DateTime, defaultToDate.ToString());

                // Filter dropdowns
                dsCountries.SelectCommand = "SELECT id, countryName, countryCode FROM countries WHERE id = @countryId";
                dsCountries.SelectParameters.Add("countryId", countryId.ToString());

                dsCompanies.SelectCommand = "SELECT id, companyName FROM companies WHERE countryID = @countryId";
                dsCompanies.SelectParameters.Add("countryId", countryId.ToString());

                dsBranches.SelectCommand = "SELECT id, name, companyId FROM branches WHERE countryId = @countryId";
                dsBranches.SelectParameters.Add("countryId", countryId.ToString());

                #endregion
            }
            else
            {
                #region No Restrictions (Admin)

                // dsOrders - Financial Tab
                dsOrders.SelectParameters.Add("countryId", "0");
                dsOrders.SelectParameters.Add("companyId", "0");
                dsOrders.SelectParameters.Add("branchId", "0");
                dsOrders.SelectParameters.Add("dateFrom", TypeCode.DateTime, defaultFromDate.ToString());
                dsOrders.SelectParameters.Add("dateTo", TypeCode.DateTime, defaultToDate.ToString());

                // dsOrdersInfo - Orders Tab
                dsOrdersInfo.SelectParameters.Add("StatusId", "0");
                dsOrdersInfo.SelectParameters.Add("PaymentMethodId", "0");
                dsOrdersInfo.SelectParameters.Add("dateFrom1", TypeCode.DateTime, defaultFromDate.ToString());
                dsOrdersInfo.SelectParameters.Add("dateTo1", TypeCode.DateTime, defaultToDate.ToString());

                // db_AppUsers - Users Tab
                db_AppUsers.SelectParameters.Add("FromDate2", TypeCode.DateTime, defaultFromDate.ToString());
                db_AppUsers.SelectParameters.Add("ToDate2", TypeCode.DateTime, defaultToDate.ToString());
                db_AppUsers.SelectParameters.Add("Country2", "0");
                db_AppUsers.SelectParameters.Add("Option2", "0");

                // db_Branches - Branches Section
                db_Branches.SelectParameters.Add("FromDate4", TypeCode.DateTime, defaultFromDate.ToString());
                db_Branches.SelectParameters.Add("ToDate4", TypeCode.DateTime, defaultToDate.ToString());

                // Filter dropdowns - Show all
                dsCountries.SelectCommand = "SELECT id, countryName, countryCode FROM countries WHERE id <> 1000";
                dsCompanies.SelectCommand = "SELECT id, companyName FROM companies WHERE id <> 1000";
                dsBranches.SelectCommand = "SELECT id, name, companyId FROM branches";

                #endregion
            }
        }
        private (int countryId, int companyId) GetUserPrivileges()
        {
            string username = MainHelper.M_Check(Request.Cookies["M_Username"]?.Value);
            int privilegeCountryID = 0;
            int privilegeCompanyID = 0;

            if (!string.IsNullOrEmpty(username))
            {
                string connStr = ConfigurationManager.ConnectionStrings["ShabDB_connection"].ConnectionString;
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();
                    string query = "SELECT privilegeCountryID, privilegeCompanyID FROM users WHERE username = @username";
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@username", username);
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                if (reader["privilegeCountryID"] != DBNull.Value)
                                    privilegeCountryID = Convert.ToInt32(reader["privilegeCountryID"]);
                                if (reader["privilegeCompanyID"] != DBNull.Value)
                                    privilegeCompanyID = Convert.ToInt32(reader["privilegeCompanyID"]);
                            }
                        }
                    }
                }
            }

            return (privilegeCountryID, privilegeCompanyID);
        }


        protected void callbackRefundDetails_Callback(object sender, DevExpress.Web.CallbackEventArgsBase e)
        {
            int orderId;
            if (int.TryParse(e.Parameter, out orderId))
            {
                string connStr = ConfigurationManager.ConnectionStrings["ShabDB_connection"].ConnectionString;
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();
                    SqlCommand cmd = new SqlCommand(@"
                    SELECT 
                        refundedAmount, 
                        realTotalAmount, 
                        realTax,   
                        [amount], 
                        [deliveryAmount], 
                        [taxAmount], 
                        [totalAmount]
                    FROM Orders
                    WHERE id = @id", conn);

                    cmd.Parameters.AddWithValue("@id", orderId);

                    SqlDataReader reader = cmd.ExecuteReader();
                    if (reader.Read())
                    {
                        lblRefundDetails.Text = $@"
                        <div style='font-family: Cairo; direction: rtl; font-size: 1em; padding: 10px;'>

                            <div style='border: 2px solid #ccc; border-radius: 10px; padding: 15px; margin-bottom: 20px; background-color: #f9f9f9; box-shadow: 0 2px 5px rgba(0,0,0,0.05);'>
                                <h4 style='margin-top: 0; text-align:center; color: #333;'>تفاصيل المبلغ الأصلي</h4>
                                <div style='display: flex; border-top: 1px solid #ccc; margin-top: 10px;'>
                                    <div style='flex: 1; padding: 10px; text-align: left; border-left: 1px solid #ccc; color: #444;'>
                                        💵 السعر<br />
                                        🚚 التوصيل<br />
                                        🧾 الضريبة<br />
                                        <strong style='font-size: 1.4em;'>💳 المجموع</strong>
                                    </div>
                                    <div style='flex: 1; padding: 10px; text-align: right;'>
                                        {reader["amount"]}<br />
                                        {reader["deliveryAmount"]}<br />
                                        {reader["taxAmount"]}<br />
                                        <strong style='font-size: 1.4em;'>{reader["totalAmount"]}</strong>
                                    </div>
                                </div>
                            </div>

                            <div style='border: 2px solid #8bc34a; border-radius: 10px; padding: 15px; background-color: #f1fff0; box-shadow: 0 2px 5px rgba(0,0,0,0.05);'>
                                <h4 style='margin-top: 0; text-align:center; color: #4caf50;'>تفاصيل المبلغ المسترجع</h4>
                                <div style='display: flex; border-top: 1px solid #b2df8a; margin-top: 10px;'>
                                    <div style='flex: 1; padding: 10px; text-align: left; border-left: 1px solid #8bc34a; color: #33691e;'>
                                        💰 المبلغ الفعلي<br />
                                        🧾 الضريبة الفعلية<br />
                                        <strong style='font-size: 1.4em;'>💸 المبلغ المرتجع</strong>
                                    </div>
                                    <div style='flex: 1; padding: 10px; text-align: right;'>
                                        {reader["realTotalAmount"]}<br />
                                        {reader["realTax"]}<br />
                                        <strong style='font-size: 1.4em;'>{reader["refundedAmount"]}</strong>
                                    </div>
                                </div>
                            </div>

                        </div>";



                    }
                    else
                    {
                        lblRefundDetails.Text = "لا توجد بيانات لهذا الطلب.";
                    }
                }
            }
            else
            {
                lblRefundDetails.Text = "رقم الطلب غير صالح.";
            }
        }
        protected void cbpCompany_Callback(object sender, DevExpress.Web.CallbackEventArgsBase e)
        {
            string countryId = e.Parameter;
            var (_, privilegeCompanyId) = GetUserPrivileges();

            if (!string.IsNullOrEmpty(countryId))
            {
                if (privilegeCompanyId != 1000)
                {
                    dsCompanies.SelectCommand = $"SELECT id, companyName FROM companies WHERE countryId = {countryId} AND id = {privilegeCompanyId}";
                }
                else
                {
                    dsCompanies.SelectCommand = $"SELECT id, companyName FROM companies WHERE countryId = {countryId}";
                }
            }
            CompanyList.DataBind();
        }

        protected void cbpBranch_Callback(object sender, DevExpress.Web.CallbackEventArgsBase e)
        {
            string companyId = e.Parameter;
            if (!string.IsNullOrEmpty(companyId))
            {
                dsBranches.SelectCommand = $"SELECT id, name, companyId FROM branches WHERE companyId = {companyId}";
            }
            else
            {
                dsBranches.SelectCommand = "SELECT id, name, companyId FROM branches";
            }
            BranchList.DataBind();
        }

        // GridOrders filters and Privelages 
        protected void GridOrders_CustomCallback(object sender, DevExpress.Web.ASPxGridViewCustomCallbackEventArgs e)
        {
            dsOrders.DataBind();
        }
        protected void GridOrders_BeforePerformDataSelect(object sender, EventArgs e)
        {
            var (countryId, companyId) = GetUserPrivileges();

            DateTime defaultFromDate = new DateTime(2025, 1, 1);
            DateTime defaultToDate = DateTime.Now;

            dsOrders.SelectParameters.Clear();

            int sessionCountryId = Convert.ToInt32(CountryList?.Value ?? 0);
            int sessionCompanyId = Convert.ToInt32(CompanyList?.Value ?? 0);
            int sessionBranchId = Convert.ToInt32(BranchList?.Value ?? 0);

            // تحقق من صحة التاريخ لتفادي SqlDateTime overflow
            DateTime dateFrom = (DateFrom != null && DateFrom.Date >= SqlDateTime.MinValue.Value)
                ? DateFrom.Date
                : defaultFromDate;

            DateTime dateTo = (DateTo != null && DateTo.Date >= SqlDateTime.MinValue.Value)
                ? DateTo.Date
                : defaultToDate;

            // تأكد أن dateFrom <= dateTo
            if (dateFrom > dateTo)
                dateFrom = dateTo.AddDays(-1);

            int finalCountryId = (countryId != 1000)
                ? (sessionCountryId != 0 ? sessionCountryId : countryId)
                : sessionCountryId;

            int finalCompanyId = (companyId != 1000)
                ? (sessionCompanyId != 0 ? sessionCompanyId : companyId)
                : sessionCompanyId;

            int finalBranchId = sessionBranchId;

            dsOrders.SelectCommand = @"
        SELECT 
            o.[id], 
            o.[companyId], 
            c.[countryID] AS countryId, 
            c.[companyName], 
            co.[countryName],
            o.[username], 
            u.[firstName] + ' ' + u.[lastName] AS fullName,
            o.[addressId], 
            o.[amount], 
            o.[deliveryAmount], 
            o.[taxAmount], 
            o.[totalAmount], 
            o.[couponId], 
            o.[l_paymentMethodId],
            o.[l_RefundType],
            pm.[description] AS paymentMethod, 
            br.[name] AS branchName, 
            o.[transactionId], 
            o.[invoiceNo], 
            o.[notes], 
            o.[l_orderStatus], 
            os.[description] AS orderStatus,  
            o.[refundedAmount], 
            o.[realTotalAmount], 
            o.[realTax], 
            o.[userDate]
        FROM [Orders] o
        JOIN [companies] c ON o.companyId = c.id
        LEFT JOIN l_paymentMethod pm ON o.l_paymentMethodId = pm.id
        LEFT JOIN branches br ON o.branchId = br.id
        LEFT JOIN countries co ON c.countryID = co.id
        LEFT JOIN l_orderStatus os ON o.l_orderStatus = os.id
        LEFT JOIN [usersApp] u ON o.username = u.username
        WHERE 
            o.l_orderStatus = 4
            AND (@countryId = 0 OR c.countryID = @countryId)
            AND (@companyId = 0 OR c.id = @companyId)
            AND (@branchId = 0 OR br.id = @branchId)
            AND o.userDate BETWEEN @dateFrom AND @dateTo
        ORDER BY o.id DESC";

            // البراميترات الآمنة
            dsOrders.SelectParameters.Add("countryId", finalCountryId.ToString());
            dsOrders.SelectParameters.Add("companyId", finalCompanyId.ToString());
            dsOrders.SelectParameters.Add("branchId", finalBranchId.ToString());
            dsOrders.SelectParameters.Add("dateFrom", TypeCode.DateTime, dateFrom.ToString("yyyy-MM-dd"));
            dsOrders.SelectParameters.Add("dateTo", TypeCode.DateTime, dateTo.AddDays(1).ToString("yyyy-MM-dd"));
        }


        protected string GetCurrency(object countryIdObj)
        {
            int countryId = countryIdObj != DBNull.Value ? Convert.ToInt32(countryIdObj) : 0;
            string currencyText;

            switch (countryId)
            {
                case 1:
                case 2:
                    currencyText = "دينار أردني";
                    break;
                case 3:
                    currencyText = "ريال قطري";
                    break;
                case 4:
                    currencyText = "دينار بحريني";
                    break;
                case 5:
                    currencyText = "درهم إماراتي";
                    break;
                case 6:
                    currencyText = "دينار كويتي";
                    break;
                default:
                    currencyText = "دولار";
                    break;
            }

            return currencyText;
        }
        protected string GetTotalPaidAmount(object productPrice, object quantityObj, object weightObj)
        {
            decimal price = 0, quantity = 0, weight = 0;

            decimal.TryParse(productPrice?.ToString(), out price);

            decimal.TryParse(quantityObj?.ToString(), out quantity);
            decimal.TryParse(weightObj?.ToString(), out weight);

            decimal basePrice = price;

            decimal multiplier = quantity > 0 ? quantity : weight;

            decimal total = basePrice * multiplier;

            if (total <= 0)
                return "<span style='color:gray;'>0</span>";

            return $"{total:F3}";
        }
        protected string GetOptionDisplayText(object optionNameObj, object optionPriceObj, object offerPriceObj)
        {
            string optionName = optionNameObj?.ToString();
            string optionPrice = optionPriceObj?.ToString();
            string offerPrice = offerPriceObj?.ToString();

            if (string.IsNullOrEmpty(optionName) || optionName == "لا يوجد")
                return "<span style='color:gray;'>لا يوجد</span>";

            string html = $"<div><strong>{optionName}</strong></div>";

            //if (!string.IsNullOrEmpty(optionPrice) && decimal.TryParse(optionPrice, out decimal priceVal) && priceVal > 0)
            //    html += $"<div>السعر: {priceVal}</div>";

            //if (!string.IsNullOrEmpty(offerPrice) && decimal.TryParse(offerPrice, out decimal offerVal) && offerVal > 0)
            //    html += $"<div><span style='color:red;'>سعر العرض: {offerVal}</span></div>";

            return html;
        }
        protected string GetFirstImagePath(object productIdObj)
        {
            var list = new List<object>();
            string connStr = ConfigurationManager.ConnectionStrings["ShabDB_connection"].ConnectionString;
            using (var conn = new SqlConnection(connStr))
            using (var cmd = new SqlCommand(
                "SELECT imagePath AS ImagePath FROM productsimages WHERE productId = @pid AND isDefault = 1", conn))
            {
                cmd.Parameters.AddWithValue("@pid", Convert.ToInt32(productIdObj));
                conn.Open();
                using (var rdr = cmd.ExecuteReader())
                    while (rdr.Read())
                        list.Add(new { ImagePath = rdr.GetString(0) });
            }

            if (list != null && list.Count > 0)
                return ((dynamic)list[0]).ImagePath;
            return "/assets/uploads/noFile.png";
        }
        protected void gridOrderProducts_CustomCallback(object sender, DevExpress.Web.ASPxGridViewCustomCallbackEventArgs e)
        {
            if (int.TryParse(e.Parameters, out int orderId))
            {
                dsOrderProducts.SelectParameters["orderId"].DefaultValue = orderId.ToString();
                gridOrderProducts.DataBind();
            }
        }


        // GridOrdersInfo filters and Privelages 
        protected void GridOrdersInfo_CustomCallback(object sender, ASPxGridViewCustomCallbackEventArgs e)
        {
            GridOrdersInfo.DataBind();
        }
        protected void GridOrdersInfo_BeforePerformDataSelect(object sender, EventArgs e)
        {
            DateTime defaultFromDate = new DateTime(2025, 1, 1);
            DateTime defaultToDate = DateTime.Now.AddDays(1);

            DateTime sessionDateFrom = defaultFromDate;
            DateTime sessionDateTo = defaultToDate;


            int status = Convert.ToInt32(StatusList.Value ?? 0);
            int paymentMethod = Convert.ToInt32(PaymentMethodList.Value ?? 0);

            // تحقق من صحة التاريخ لتفادي SqlDateTime overflow
            DateTime dateFrom = (DateFrom1 != null && DateFrom1.Date >= SqlDateTime.MinValue.Value)
                ? DateFrom1.Date
                : defaultFromDate;

            DateTime dateTo = (DateTo1 != null && DateTo1.Date >= SqlDateTime.MinValue.Value)
                ? DateTo1.Date
                : defaultToDate;

            dsOrdersInfo.SelectParameters["StatusId"].DefaultValue = status.ToString();
            dsOrdersInfo.SelectParameters["PaymentMethodId"].DefaultValue = paymentMethod.ToString();
            dsOrdersInfo.SelectParameters["dateFrom1"].DefaultValue = dateFrom.ToString("yyyy-MM-dd");
            dsOrdersInfo.SelectParameters["dateTo1"].DefaultValue = dateTo.AddDays(1).ToString("yyyy-MM-dd");
        }


        public string GetOrderStatusLottie(string status)
        {
            if (status == "1")
            {
                return @"
                <div style='width: 100px; margin: auto; text-align: center; font-family: Cairo;'>
                    <lottie-player 
                        src='/assets/animations/pending.json' 
                        background='transparent' 
                        speed='1' 
                        style='width: 80px; height: 80px; margin: 0 auto;' 
                        loop 
                        autoplay>
                    </lottie-player>
                    <div style='margin-top: 5px; font-size: 0.95em; color: #444;'>بانتظار الموافقة</div>
                </div>";
            }
            else if (status == "2")
            {
                return @"
                <div style='width: 100px; margin: auto; text-align: center; font-family: Cairo;'>
                    <lottie-player 
                        src='/assets/animations/preparing.json' 
                        background='transparent' 
                        speed='1' 
                        style='width: 80px; height: 80px; margin: 0 auto;' 
                        loop 
                        autoplay>
                    </lottie-player>
                    <div style='margin-top: 5px; font-size: 0.95em; color: #444;'>قيد التحضير</div>
                </div>";
            }
            else if (status == "3")
            {
                return @"
                <div style='width: 100px; margin: auto; text-align: center; font-family: Cairo;'>
                    <lottie-player 
                        src='/assets/animations/delivery.json' 
                        background='transparent' 
                        speed='1' 
                        style='width: 80px; height: 80px; margin: 0 auto;' 
                        loop 
                        autoplay>
                    </lottie-player>
                    <div style='margin-top: 5px; font-size: 0.95em; color: #444;'>قيد التوصيل</div>
                </div>";
            }
            else if (status == "4")
            {
                return @"
                <div style='width: 100px; margin: auto; text-align: center; font-family: Cairo;'>
                    <lottie-player 
                        src='/assets/animations/delivered.json' 
                        background='transparent' 
                        speed='1' 
                        style='width: 80px; height: 80px; margin: 0 auto;' 
                        loop 
                        autoplay>
                    </lottie-player>
                    <div style='margin-top: 5px; font-size: 0.95em; color: #444;'>تم التسليم</div>
                </div>";
            }
            else if (status == "8")
            {
                return @"
                <div style='width: 100px; margin: auto; text-align: center; font-family: Cairo;'>
                    <lottie-player 
                        src='/assets/animations/canceled.json' 
                        background='transparent' 
                        speed='1' 
                        style='width: 110px; height: 110px; margin: 0 auto;' 
                        loop 
                        autoplay>
                    </lottie-player>
                    <div style='margin-top: 5px; font-size: 0.95em; color: #d9534f;'>ملغي من الإدارة</div>
                </div>";
            }
            else if (status == "7")
            {
                return @"
                <div style='width: 100px; margin: auto; text-align: center; font-family: Cairo;'>
                    <lottie-player 
                        src='/assets/animations/canceled.json' 
                        background='transparent' 
                        speed='1' 
                        style='width: 110px; height: 110px; margin: 0 auto;' 
                        loop 
                        autoplay>
                    </lottie-player>
                    <div style='margin-top: 5px; font-size: 0.95em; color: #888;'>ملغي من المستخدم</div>
                </div>";
            }
            else if (status == "6")
            {
                return @"
                <div style='width: 100px; margin: auto; text-align: center; font-family: Cairo;'>
                    <lottie-player 
                        src='/assets/animations/refund.json' 
                        background='transparent' 
                        speed='1' 
                        style='width: 110px; height: 110px; margin: 0 auto;' 
                        loop 
                        autoplay>
                    </lottie-player>
                    <div style='margin-top: 5px; font-size: 0.95em; color: #f0ad4e;'>إرجاع جزئي</div>
                </div>";
            }
            else if (status == "5")
            {
                return @"
                <div style='width: 100px; margin: auto; text-align: center; font-family: Cairo;'>
                    <lottie-player 
                        src='/assets/animations/refund.json' 
                        background='transparent' 
                        speed='1' 
                        style='width: 110px; height: 110px; margin: 0 auto;' 
                        loop 
                        autoplay>
                    </lottie-player>
                    <div style='margin-top: 5px; font-size: 0.95em; color: #ec971f;'>إرجاع كلي</div>
                </div>";
            }






            return $"<span class='order-badge badge-default'>{status}</span>";
        }
        protected void GridUsers_HtmlDataCellPrepared(object sender, ASPxGridViewTableDataCellEventArgs e)
        {
            if (e.DataColumn.FieldName == "isDeleted")
            {
                bool isDeleted = Convert.ToBoolean(e.GetValue("isDeleted"));
                if (isDeleted)
                {
                    e.Cell.BackColor = System.Drawing.Color.Red;
                    e.Cell.ForeColor = System.Drawing.Color.White;
                }
            }
            if (e.DataColumn.FieldName == "isActive")
            {
                bool isActive = Convert.ToBoolean(e.GetValue("isActive"));
                if (isActive)
                {
                    e.Cell.ForeColor = System.Drawing.Color.Green;
                    e.Cell.Font.Bold = true;
                }
                else
                {
                    e.Cell.ForeColor = System.Drawing.Color.Red;
                    e.Cell.Font.Bold = true;
                }
            }
        }


        // GridAppUsers filters and Privelages 
        protected void GridAppUsers_CustomCallback(object sender, ASPxGridViewCustomCallbackEventArgs e)
        {
            GridAppUsers.DataBind();
        }
        protected void GridAppUsers_BeforePerformDataSelect(object sender, EventArgs e)
        {
            int country = 0;
            var (CountryID, _) = GetUserPrivileges();
            if (CountryID != 1000)
            {
                country = CountryID;
            }
            else
            {
                country = Convert.ToInt32(CountryList1.Value ?? 0);
            }
            int option = Convert.ToInt32(Buyers.Value ?? 0);

            DateTime defaultFromDate = new DateTime(2025, 1, 1);
            DateTime defaultToDate = DateTime.Now.AddDays(1);

            DateTime sessionDateFrom = defaultFromDate;
            DateTime sessionDateTo = defaultToDate;
            // تحقق من صحة التاريخ لتفادي SqlDateTime overflow
            DateTime dateFrom = (DateFrom2 != null && DateFrom2.Date >= SqlDateTime.MinValue.Value)
                ? DateFrom2.Date
                : defaultFromDate;

            DateTime dateTo = (DateTo2 != null && DateTo2.Date >= SqlDateTime.MinValue.Value)
                ? DateTo2.Date
                : defaultToDate;

            db_AppUsers.SelectParameters["Country2"].DefaultValue = country.ToString();
            db_AppUsers.SelectParameters["Option2"].DefaultValue = option.ToString();
            db_AppUsers.SelectParameters["FromDate2"].DefaultValue = dateFrom.ToString("yyyy-MM-dd");
            db_AppUsers.SelectParameters["ToDate2"].DefaultValue = dateTo.AddDays(1).ToString("yyyy-MM-dd");

        }

        protected void GridBranches_CustomCallback(object sender, ASPxGridViewCustomCallbackEventArgs e)
        {
            GridBranches.DataBind();
        }

        protected void GridBranches_BeforePerformDataSelect(object sender, EventArgs e)
        {


            DateTime defaultFromDate = new DateTime(2025, 1, 1);
            DateTime defaultToDate = DateTime.Now.AddDays(1);

            DateTime sessionDateFrom = defaultFromDate;
            DateTime sessionDateTo = defaultToDate;
            // تحقق من صحة التاريخ لتفادي SqlDateTime overflow
            DateTime dateFrom = (DateFrom3 != null && DateFrom3.Date >= SqlDateTime.MinValue.Value)
                ? DateFrom3.Date
                : defaultFromDate;

            DateTime dateTo = (DateTo3 != null && DateTo3.Date >= SqlDateTime.MinValue.Value)
                ? DateTo3.Date
                : defaultToDate;
            

            db_Branches.SelectParameters["FromDate4"].DefaultValue = dateFrom.ToString("yyyy-MM-dd");
            db_Branches.SelectParameters["ToDate4"].DefaultValue = dateTo.AddDays(1).ToString("yyyy-MM-dd");
        }

    }
}