using DevExpress.Web;
using DevExpress.Web.Data;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ShabAdmin
{
    public partial class Prices : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void Page_Init(object sender, EventArgs e)
        {

            if (!IsPostBack)
            {
                ClientScript.RegisterStartupScript(this.GetType(), "showPopup", "setTimeout(function() { popupWarning.Show(); }, 300);", true);
            }


            string username = MainHelper.M_Check(Request.Cookies["M_Username"].Value.ToString());
            var (userCountryID, userCompanyID) = GetUserPrivileges(username);

            Dictionary<string, int> countryColumnMap = new Dictionary<string, int>()
{
    { "JordanPrice", 1 },
    { "AqabaPrice", 2 },
    { "QatarPrice", 3 },
    { "BahrinPrice", 4 },
    { "UAEPrice", 5 },
    { "KuwaitPrice", 6 }
};

            if (userCountryID != 1000 && userCompanyID != 1000)
            {
                // Filter data in SqlDataSource
                db_ProductPrices.SelectCommand = @"
        SELECT 
            uid,
            MAX(name) AS ProductName,
            MAX(CASE WHEN countryID = 1 THEN price ELSE 0 END) AS [JordanPrice],
            MAX(CASE WHEN countryID = 2 THEN price ELSE 0 END) AS [AqabaPrice],
            MAX(CASE WHEN countryID = 3 THEN price ELSE 0 END) AS [QatarPrice],
            MAX(CASE WHEN countryID = 4 THEN price ELSE 0 END) AS [BahrinPrice],
            MAX(CASE WHEN countryID = 5 THEN price ELSE 0 END) AS [UAEPrice],
            MAX(CASE WHEN countryID = 6 THEN price ELSE 0 END) AS [KuwaitPrice]
        FROM products
        WHERE countryID = @countryID AND companyID = @companyID
        GROUP BY uid";

                db_ProductPrices.SelectParameters.Clear();
                db_ProductPrices.SelectParameters.Add("countryID", TypeCode.Int32, userCountryID.ToString());
                db_ProductPrices.SelectParameters.Add("companyID", TypeCode.Int32, userCompanyID.ToString());

                // Show only the user's country column
                foreach (var entry in countryColumnMap)
                {
                    var column = GridPrices.Columns[entry.Key] as GridViewDataColumn;
                    if (column != null)
                    {
                        column.Visible = (entry.Value == userCountryID);
                    }
                }
            }
            else if (userCountryID != 1000)
            {
                // Filter data in SqlDataSource
                db_ProductPrices.SelectCommand = @"
        SELECT 
            uid,
            MAX(name) AS ProductName,
            MAX(CASE WHEN countryID = 1 THEN price ELSE 0 END) AS [JordanPrice],
            MAX(CASE WHEN countryID = 2 THEN price ELSE 0 END) AS [AqabaPrice],
            MAX(CASE WHEN countryID = 3 THEN price ELSE 0 END) AS [QatarPrice],
            MAX(CASE WHEN countryID = 4 THEN price ELSE 0 END) AS [BahrinPrice],
            MAX(CASE WHEN countryID = 5 THEN price ELSE 0 END) AS [UAEPrice],
            MAX(CASE WHEN countryID = 6 THEN price ELSE 0 END) AS [KuwaitPrice]
        FROM products
        WHERE countryID = @countryID
        GROUP BY uid";

                db_ProductPrices.SelectParameters.Clear();
                db_ProductPrices.SelectParameters.Add("countryID", TypeCode.Int32, userCountryID.ToString());

                // Show only the user's country column
                foreach (var entry in countryColumnMap)
                {
                    var column = GridPrices.Columns[entry.Key] as GridViewDataColumn;
                    if (column != null)
                    {
                        column.Visible = (entry.Value == userCountryID);
                    }
                }
            }
            else
            {
                // Apply visibility logic
                foreach (var entry in countryColumnMap)
                {
                    ToggleColumnVisibility(entry.Key, entry.Value);
                }
            }
        }

        private (int countryID, int companyID) GetUserPrivileges(string username)
        {
            string connStr = ConfigurationManager.ConnectionStrings["ShabDB_connection"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                string query = "SELECT privilegeCountryID, privilegeCompanyID FROM users WHERE username = @username";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@username", username);

                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        int countryID = reader["privilegeCountryID"] != DBNull.Value ? Convert.ToInt32(reader["privilegeCountryID"]) : 0;
                        int companyID = reader["privilegeCompanyID"] != DBNull.Value ? Convert.ToInt32(reader["privilegeCompanyID"]) : 0;
                        return (countryID, companyID);
                    }
                }
            }

            return (0, 0);
        }

        private void ToggleColumnVisibility(string columnFieldName, int countryID)
        {
            if (!HasCompanyAndBranch(countryID))
            {
                var column = GridPrices.Columns[columnFieldName] as GridViewDataColumn;
                if (column != null)
                {
                    column.Visible = false;
                }
            }
        }

        private bool HasCompanyAndBranch(int countryId)
        {
            string connStr = ConfigurationManager.ConnectionStrings["ShabDB_connection"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                string companyQuery = "SELECT COUNT(*) FROM companies WHERE countryID = @countryID";
                SqlCommand companyCmd = new SqlCommand(companyQuery, conn);
                companyCmd.Parameters.AddWithValue("@countryID", countryId);
                int companyCount = (int)companyCmd.ExecuteScalar();

                string branchQuery = "SELECT COUNT(*) FROM branches WHERE countryID = @countryID";
                SqlCommand branchCmd = new SqlCommand(branchQuery, conn);
                branchCmd.Parameters.AddWithValue("@countryID", countryId);
                int branchCount = (int)branchCmd.ExecuteScalar();

                return (companyCount > 0 && branchCount > 0);
            }
        }



        protected void GridPrices_BatchUpdate(object sender, DevExpress.Web.Data.ASPxDataBatchUpdateEventArgs e)
        {
            string username = MainHelper.M_Check(Request.Cookies["M_Username"].Value.ToString());
            var (userCountryID, userCompanyID) = GetUserPrivileges(username);

            Dictionary<string, int> countryColumnMap = new Dictionary<string, int>()
        {
            { "JordanPrice", 1 },
            { "AqabaPrice", 2 },
            { "QatarPrice", 3 },
            { "BahrinPrice", 4 },
            { "UAEPrice", 5 },
            { "KuwaitPrice", 6 }
        };

            if (userCountryID == 1000 || userCompanyID == 1000)
            {
                GridPrices.JSProperties["cp_CancelUpdate"] = "true";
                e.Handled = true;
                return;
            }

            string connectionString = ConfigurationManager.ConnectionStrings["ShabDB_connection"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                SqlTransaction transaction = conn.BeginTransaction();

                try
                {
                    foreach (var args in e.UpdateValues)
                    {
                        if (!long.TryParse(Convert.ToString(args.Keys["uid"]), out long uid))
                            throw new Exception("Missing or invalid UID in batch update.");

                        if (args.NewValues.Contains("JordanPrice") &&
                            args.NewValues["JordanPrice"] != null &&
                            !Equals(args.NewValues["JordanPrice"], args.OldValues["JordanPrice"]))
                        {
                            CallCloneProcedureIfNeeded(conn, transaction, uid, 1);
                            UpdatePrice(conn, transaction, uid, 1, Convert.ToDecimal(args.NewValues["JordanPrice"]));
                        }

                        if (args.NewValues.Contains("AqabaPrice") &&
                            args.NewValues["AqabaPrice"] != null &&
                            !Equals(args.NewValues["AqabaPrice"], args.OldValues["AqabaPrice"]))
                        {
                            CallCloneProcedureIfNeeded(conn, transaction, uid, 2);
                            UpdatePrice(conn, transaction, uid, 2, Convert.ToDecimal(args.NewValues["AqabaPrice"]));
                        }

                        if (args.NewValues.Contains("QatarPrice") &&
                            args.NewValues["QatarPrice"] != null &&
                            !Equals(args.NewValues["QatarPrice"], args.OldValues["QatarPrice"]))
                        {
                            CallCloneProcedureIfNeeded(conn, transaction, uid, 3);
                            UpdatePrice(conn, transaction, uid, 3, Convert.ToDecimal(args.NewValues["QatarPrice"]));
                        }

                        if (args.NewValues.Contains("BahrinPrice") &&
                            args.NewValues["BahrinPrice"] != null &&
                            !Equals(args.NewValues["BahrinPrice"], args.OldValues["BahrinPrice"]))
                        {
                            CallCloneProcedureIfNeeded(conn, transaction, uid, 4);
                            UpdatePrice(conn, transaction, uid, 4, Convert.ToDecimal(args.NewValues["BahrinPrice"]));
                        }

                        if (args.NewValues.Contains("UAEPrice") &&
                            args.NewValues["UAEPrice"] != null &&
                            !Equals(args.NewValues["UAEPrice"], args.OldValues["UAEPrice"]))
                        {
                            CallCloneProcedureIfNeeded(conn, transaction, uid, 5);
                            UpdatePrice(conn, transaction, uid, 5, Convert.ToDecimal(args.NewValues["UAEPrice"]));
                        }

                        if (args.NewValues.Contains("KuwaitPrice") &&
                            args.NewValues["KuwaitPrice"] != null &&
                            !Equals(args.NewValues["KuwaitPrice"], args.OldValues["KuwaitPrice"]))
                        {
                            CallCloneProcedureIfNeeded(conn, transaction, uid, 6);
                            UpdatePrice(conn, transaction, uid, 6, Convert.ToDecimal(args.NewValues["KuwaitPrice"]));
                        }
                    }
                    transaction.Commit();
                }
                catch (Exception ex)
                {
                    transaction.Rollback();
                    throw new Exception("Batch update failed: " + ex.Message, ex);
                }
            }

            e.Handled = true;
        }

        private void CallCloneProcedureIfNeeded(SqlConnection conn, SqlTransaction transaction, long uid, int countryID)
        {
            using (SqlCommand cmd = new SqlCommand("CloneProductIfMissing", conn, transaction))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@uid", uid);
                cmd.Parameters.AddWithValue("@countryID", countryID);
                cmd.ExecuteNonQuery();
            }
        }

        private void UpdatePrice(SqlConnection conn, SqlTransaction transaction, long uid, int countryID, decimal price)
        {
            string username = MainHelper.M_Check(Request.Cookies["M_Username"].Value.ToString());
            var (userCountryID, userCompanyID) = GetUserPrivileges(username);
            if (userCompanyID != 1000)
            {
                using (SqlCommand cmd = new SqlCommand("UPDATE products SET price = @price WHERE uid = @uid AND countryID = @countryID AND companyID = @companyID", conn, transaction))
                {
                    cmd.Parameters.AddWithValue("@uid", uid);
                    cmd.Parameters.AddWithValue("@countryID", countryID);
                    cmd.Parameters.AddWithValue("@companyID", userCompanyID);
                    cmd.Parameters.AddWithValue("@price", price);
                    cmd.ExecuteNonQuery();
                }
            }
            //else {
            //    using (SqlCommand cmd = new SqlCommand("UPDATE products SET price = @price WHERE uid = @uid AND countryID = @countryID", conn, transaction))
            //    {
            //        cmd.Parameters.AddWithValue("@uid", uid);
            //        cmd.Parameters.AddWithValue("@countryID", countryID);
            //        cmd.Parameters.AddWithValue("@price", price);
            //        cmd.ExecuteNonQuery();
            //    }
            //}
        }


    }
}