using DevExpress.Web;
using DevExpress.Web.Data;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.Common;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ShabAdmin
{
    public partial class Companies : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                GridCompanies.RowInserting += GridCompanies_RowInserting;
                GridCompanies.RowUpdating += GridCompanies_RowUpdating;
            }
        }       

        protected void GridCompanies_RowInserting(object sender, DevExpress.Web.Data.ASPxDataInsertingEventArgs e)
        {
            FormatTimeValue(e.NewValues, "startHour");
            FormatTimeValue(e.NewValues, "endHour");
        }

        protected void GridCompanies_RowUpdating(object sender, DevExpress.Web.Data.ASPxDataUpdatingEventArgs e)
        {
            FormatTimeValue(e.NewValues, "startHour");
            FormatTimeValue(e.NewValues, "endHour");
        }

        private void FormatTimeValue(System.Collections.Specialized.IOrderedDictionary values, string fieldName)
        {
            if (values[fieldName] != null && values[fieldName] != DBNull.Value)
            {
                string timeStr = values[fieldName].ToString().Replace(":", "").Trim();

                // If it's 4 digits (like "0610" or "0405"), format as "06:10" or "04:05"
                if (timeStr.Length == 4)
                {
                    values[fieldName] = timeStr.Substring(0, 2) + ":" + timeStr.Substring(2, 2);
                }
                // If it's 3 digits (like "610"), format as "06:10"
                else if (timeStr.Length == 3)
                {
                    values[fieldName] = "0" + timeStr.Substring(0, 1) + ":" + timeStr.Substring(1, 2);
                }
                // If it already has colon, ensure proper format
                else if (values[fieldName].ToString().Contains(":"))
                {
                    if (DateTime.TryParse(values[fieldName].ToString(), out DateTime dt))
                    {
                        values[fieldName] = dt.ToString("HH:mm");
                    }
                }
            }
        }



























        protected void Page_Init(object sender, EventArgs e)
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
                    SqlCommand cmd = new SqlCommand("SELECT privilegeCountryID,privilegeCompanyID FROM users WHERE username = @username", conn);
                    cmd.Parameters.AddWithValue("@username", username);

                    SqlDataReader reader = cmd.ExecuteReader();
                    if (reader.Read() && reader["privilegeCountryID"] != DBNull.Value)
                    {
                        privilegeCountryID = Convert.ToInt32(reader["privilegeCountryID"]);
                        privilegeCompanyID = Convert.ToInt32(reader["privilegeCompanyID"]);
                    }
                }
            }

            if (privilegeCountryID != 1000 && privilegeCompanyID != 1000)
            {
                db_Companies.SelectCommand = @"
                                    SELECT [id], [companyName], [countryID], [companyTax],[isVisible], [l_companyStatus], [minAmountOrder], [deliveryAmount], [minDeliveryTime], [maxDeliveryTime], [pointsOffer], [isPointsOffer], [startHour], [endHour]
                                    FROM [companies] 
                                    WHERE id = @companyID AND countryID = @countryID
                                    ORDER BY [companyName] ASC";

                db_Companies.SelectParameters.Clear();
                db_Companies.SelectParameters.Add("companyID", privilegeCompanyID.ToString());
                db_Companies.SelectParameters.Add("countryID", privilegeCountryID.ToString());

                dsCountries.SelectCommand = @"SELECT id, countryName FROM countries WHERE id = @countryID";
                dsCountries.SelectParameters.Clear();
                dsCountries.SelectParameters.Add("countryID", privilegeCountryID.ToString());
            }
            else if (privilegeCountryID != 1000)
            {
                db_Companies.SelectCommand = @"
                                    SELECT [id], [companyName], [countryID], [companyTax] ,[isVisible], [l_companyStatus], [minAmountOrder], [deliveryAmount], [minDeliveryTime], [maxDeliveryTime], [pointsOffer], [isPointsOffer], [startHour], [endHour]
                                    FROM [companies] 
                                    WHERE countryID = @countryID
                                    ORDER BY [companyName] ASC";

                db_Companies.SelectParameters.Add("countryID", privilegeCountryID.ToString());


                dsCountries.SelectCommand = @"SELECT id, countryName FROM countries WHERE id = @countryID";
                dsCountries.SelectParameters.Clear();
                dsCountries.SelectParameters.Add("countryID", privilegeCountryID.ToString());
            }
        }

        protected void GridCompanies_RowDeleting(object sender, DevExpress.Web.Data.ASPxDataDeletingEventArgs e)
        {
            int companyId = Convert.ToInt32(e.Keys["id"]);
            bool hasLinkedData = false;

            string connStr = ConfigurationManager.ConnectionStrings["ShabDB_connection"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                string query = @"
            SELECT 
                (SELECT COUNT(*) FROM Products WHERE CompanyID = @CompanyID) +
                (SELECT COUNT(*) FROM Branches WHERE CompanyID = @CompanyID) +
                (SELECT COUNT(*) FROM Categories WHERE CompanyID = @CompanyID)";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@CompanyID", companyId);
                    int count = Convert.ToInt32(cmd.ExecuteScalar());
                    if (count > 0)
                        hasLinkedData = true;
                }
            }

            if (hasLinkedData)
            {
                e.Cancel = true;
                ASPxGridView grid = sender as ASPxGridView;
                grid.JSProperties["cpShowDeletePopup"] = true;
            }
        }        
    }
}