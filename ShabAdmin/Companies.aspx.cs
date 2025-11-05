using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DevExpress.Web;
using DevExpress.Web.Data;

namespace ShabAdmin
{
    public partial class Companies : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

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
                                    SELECT [id], [companyName], [countryID], [companyTax],[isVisible], [l_companyStatus], [minAmountOrder], [deliveryAmount], [minDeliveryTime], [maxDeliveryTime], [pointsOffer], [isPointsOffer] 
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
                                    SELECT [id], [companyName], [countryID], [companyTax] ,[isVisible], [l_companyStatus], [minAmountOrder], [deliveryAmount], [minDeliveryTime], [maxDeliveryTime], [pointsOffer], [isPointsOffer] 
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