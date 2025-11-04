using DevExpress.Web;
using System;
using System.Collections.Generic;
using System.ComponentModel.Design;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Security.Policy;
using System.Web.UI;

namespace ShabAdmin
{
    public partial class mCoupons : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void notificationList_Callback(object sender, DevExpress.Web.CallbackEventArgsBase e)
        {
            var combo = sender as DevExpress.Web.ASPxComboBox;
            if (combo == null) return;

            // أعد تحميل البيانات
            combo.DataBind();

            // إذا تم إرسال ID جديد (مثلاً بعد إدخال قسيمة جديدة)
            if (!string.IsNullOrEmpty(e.Parameter))
            {
                int couponId;
                if (int.TryParse(e.Parameter, out couponId) && couponId > 0)
                {
                    combo.Value = couponId;
                }
            }
        }


        protected void GridUsersApp_CustomCallback(object sender, DevExpress.Web.ASPxGridViewCustomCallbackEventArgs e)
        {
            var grid = (DevExpress.Web.ASPxGridView)sender;
            var param = e.Parameters ?? string.Empty;

            // === (A) FILTER ONLY ===
            if (param.StartsWith("filter|", StringComparison.OrdinalIgnoreCase))
            {
                var parts = param.Split('|');
                int couponId;
                if (parts.Length < 2 || !int.TryParse(parts[1], out couponId) || couponId <= 0)
                {
                    var p0 = db_UsersApp1.SelectParameters["countryCode"];
                    if (p0 == null) db_UsersApp1.SelectParameters.Add("countryCode", "");
                    else p0.DefaultValue = "";

                    grid.Selection.UnselectAll();
                    grid.DataBind();
                    return;
                }

                string countryCode = "";
                var cs = System.Configuration.ConfigurationManager.ConnectionStrings["ShabDB_connection"].ToString();
                using (var con = new System.Data.SqlClient.SqlConnection(cs))
                using (var cmd = new System.Data.SqlClient.SqlCommand(@"
                    SELECT TOP 1 c.countryCode
                    FROM coupons n
                    INNER JOIN countries c ON c.id = n.countryId
                    WHERE n.id = @id;", con))
                {
                    cmd.Parameters.Add("@id", System.Data.SqlDbType.Int).Value = couponId;
                    con.Open();
                    var obj = cmd.ExecuteScalar();
                    if (obj != null && obj != DBNull.Value)
                        countryCode = obj.ToString();
                }

                var p = db_UsersApp1.SelectParameters["countryCode"];
                if (p == null) db_UsersApp1.SelectParameters.Add("countryCode", countryCode ?? "");
                else p.DefaultValue = countryCode ?? "";

                grid.Selection.UnselectAll();
                grid.DataBind();
                return;
            }

            // ===== (B) INSERT =====
            if (param.StartsWith("insert|", StringComparison.OrdinalIgnoreCase))
            {
                var parts = param.Split('|');
                if (parts.Length < 2 || !int.TryParse(parts[1], out int sourceCouponId) || sourceCouponId <= 0)
                {
                    grid.JSProperties["cpResult"] = "0";
                    grid.JSProperties["cpMsg"] = "لم يتم اختيار قسيمة.";
                    return;
                }

                bool insertAll = parts.Length >= 3 && parts[2].Equals("all", StringComparison.OrdinalIgnoreCase);

                int insertedCount = 0;

                try
                {
                    string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["ShabDB_connection"].ConnectionString;


                    using (var conn = new SqlConnection(connStr))
                    {
                        conn.Open();

                        using (var tx = conn.BeginTransaction())
                        {
                            try
                            {
                                using (var cmd = new SqlCommand("InsertCouponForUser", conn, tx))
                                {
                                    cmd.CommandType = CommandType.StoredProcedure;
                                    cmd.CommandTimeout = 300;
                                    cmd.Parameters.Add("@SourceId", SqlDbType.Int).Value = sourceCouponId;

                                    List<string> fieldNames = new List<string>();
                                    fieldNames.Add("FCMToken");
                                    fieldNames.Add("userPlatform");
                                    List<Object> selectedValues = GridUsersApp.GetSelectedFieldValues(fieldNames.ToArray());

                                    string usersGroup = string.Empty;
                                    string actionType = string.Empty;
                                    string title = string.Empty;
                                    string body = string.Empty;
                                    string imagePath = string.Empty;
                                    string companyId = string.Empty;
                                    string productId = string.Empty;

                                    System.Configuration.AppSettingsReader settingsReader = new AppSettingsReader();
                                    string URL = (string)settingsReader.GetValue("SourceURL", typeof(String));

                                    var senderObj = new FcmSender();
                                    var usernames = grid.GetSelectedFieldValues("username");

                                    cmd.Parameters.Add("@InsertAll", SqlDbType.Bit).Value = checkAll.Checked ? 1 : (GridUsersApp.VisibleRowCount == usernames.Count ? 1 : 0);

                                    if (!checkAll.Checked)
                                    {
                                        if (usernames == null || usernames.Count == 0)
                                        {
                                            grid.JSProperties["cpResult"] = "0";
                                            grid.JSProperties["cpMsg"] = "لم يتم اختيار أي مستخدم.";
                                            tx.Rollback();
                                            return;
                                        }

                                        var usernameList = string.Join(",",
                                            usernames.Where(u => !string.IsNullOrWhiteSpace(u?.ToString()))
                                                     .Select(u => u.ToString().Trim()));

                                        cmd.Parameters.Add("@UsernameList", SqlDbType.NVarChar, -1).Value = usernameList;
                                        insertedCount = cmd.ExecuteNonQuery();

                                        // Fixed: Added transaction (tx) to the SqlCommand constructor
                                        using (SqlCommand cmd2 = new SqlCommand("SELECT top 1 n.actionType, n.title, n.body, n.imagePath, n.usersGroup FROM L_Notification n, coupons c WHERE n.actionType = 'FLUTTER_COUPONS' and n.countryId = c.countryId and c.id = @notificationId", conn, tx))
                                        {
                                            cmd2.Parameters.AddWithValue("@notificationId", Convert.ToInt32(notificationList.Value));

                                            using (SqlDataReader reader = cmd2.ExecuteReader())
                                            {
                                                if (reader.Read())
                                                {
                                                    usersGroup = reader["usersGroup"].ToString();
                                                    actionType = reader["actionType"].ToString();
                                                    title = reader["title"].ToString();
                                                    body = reader["body"].ToString();
                                                    imagePath = URL + reader["imagePath"].ToString();
                                                }
                                            }
                                        }

                                        foreach (object[] item in selectedValues)
                                        {
                                            string resultFCM = senderObj.Send(usersGroup, actionType, item[0].ToString(), title, body, imagePath, companyId, productId);
                                        }
                                    }
                                    else
                                    {
                                        // Fixed: Added transaction (tx) to the SqlCommand constructor
                                        using (SqlCommand cmd2 = new SqlCommand("SELECT top 1 n.actionType, n.title, n.body, n.imagePath, n.usersGroup FROM L_Notification n, coupons c WHERE n.actionType = 'FLUTTER_COUPONS' and n.countryId = c.countryId and c.id = @notificationId", conn, tx))
                                        {
                                            cmd2.Parameters.AddWithValue("@notificationId", Convert.ToInt32(notificationList.Value));

                                            using (SqlDataReader reader = cmd2.ExecuteReader())
                                            {
                                                if (reader.Read())
                                                {
                                                    usersGroup = reader["usersGroup"].ToString();
                                                    actionType = reader["actionType"].ToString();
                                                    title = reader["title"].ToString();
                                                    body = reader["body"].ToString();
                                                    imagePath = URL + reader["imagePath"].ToString();
                                                }
                                            }
                                        }

                                        insertedCount = cmd.ExecuteNonQuery();
                                        string resultFCM = senderObj.Send(usersGroup, actionType, "", title, body, imagePath, companyId, productId);
                                    }

                                }

                                tx.Commit();
                            }
                            catch
                            {
                                tx.Rollback();
                                throw;
                            }
                        }
                    }

                    grid.JSProperties["cpResult"] = "1";
                    grid.JSProperties["cpMsg"] = insertAll
                        ? $"تم إنشاء القسائم لجميع مستخدمي الدولة. عدد السجلات المُضافة: {insertedCount}."
                        : $"تم إنشاء {insertedCount} قسيمة بنجاح.";
                }
                catch (Exception ex)
                {
                    grid.JSProperties["cpResult"] = "0";
                    grid.JSProperties["cpMsg"] = "خطأ: " + ex.Message;
                }
                finally
                {
                    grid.Selection.UnselectAll();
                    grid.DataBind();

                    grid.JSProperties["cpRefreshCoupons"] = "1";
                }

                return;
            }
        }

        protected void GridUsersApp_BeforePerformDataSelect(object sender, EventArgs e)
        {
            if (notificationList.Value != null && Convert.ToInt32(notificationList.Value) > 0)
            {
                int couponId = Convert.ToInt32(notificationList.Value);

                string connStr = ConfigurationManager.ConnectionStrings["ShabDB_connection"].ConnectionString;
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();

                    string sql = @"
                SELECT TOP 1 n.couponCode, c.countryCode
                FROM coupons n
                INNER JOIN countries c ON c.id = n.countryId
                WHERE n.id = @couponId";

                    using (SqlCommand cmd = new SqlCommand(sql, conn))
                    {
                        cmd.Parameters.AddWithValue("@couponId", couponId);

                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                string countryCode = reader["countryCode"].ToString();
                                string couponCode = reader["couponCode"].ToString();

                                // countryCode
                                if (db_UsersApp1.SelectParameters["countryCode"] == null)
                                    db_UsersApp1.SelectParameters.Add("countryCode", countryCode);
                                else
                                    db_UsersApp1.SelectParameters["countryCode"].DefaultValue = countryCode;

                                // couponCode
                                if (db_UsersApp1.SelectParameters["couponCode"] == null)
                                    db_UsersApp1.SelectParameters.Add("couponCode", couponCode);
                                else
                                    db_UsersApp1.SelectParameters["couponCode"].DefaultValue = couponCode;
                            }
                        }
                    }
                }
            }
            else
            {
                // إذا ما في كوبون، فضي البراميتر عشان ما يفلتر
                if (db_UsersApp1.SelectParameters["couponCode"] != null)
                    db_UsersApp1.SelectParameters["couponCode"].DefaultValue = "";
            }
        }


        protected void GridSpecialCoupons_RowInserted(object sender, DevExpress.Web.Data.ASPxDataInsertedEventArgs e)
        {
            // لو عرفت الـ ID للقسيمة الجديدة (مثلاً من Identity أو e.Keys)
            // ممكن تمرره للكومبو عشان يختاره
            int newCouponId = Convert.ToInt32(e.NewValues["id"] ?? 0);

            var grid = sender as DevExpress.Web.ASPxGridView;
            if (grid != null)
            {
                grid.JSProperties["cpRefreshCombo"] = newCouponId > 0 ? newCouponId.ToString() : "1";
            }
        }

        protected void cbCheckCoupon_Callback(object source, DevExpress.Web.CallbackEventArgs e)
        {
            var code = e.Parameter?.Trim();
            if (string.IsNullOrEmpty(code))
            {
                e.Result = "empty";
                return;
            }

            bool exists = false;
            string cs = System.Configuration.ConfigurationManager.ConnectionStrings["ShabDB_connection"].ToString();
            using (var con = new SqlConnection(cs))
            using (var cmd = new SqlCommand(@"
        SELECT 1 
        FROM coupons 
        WHERE couponCode = @code", con))
            {
                cmd.Parameters.Add("@code", SqlDbType.NVarChar).Value = code;
                con.Open();
                exists = (cmd.ExecuteScalar() != null);
            }

            e.Result = exists ? "exists" : "ok";
        }




    }
}