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
    public partial class Countries : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        protected void Page_Init(object sender, EventArgs e)
        {
            string username = MainHelper.M_Check(Request.Cookies["M_Username"]?.Value);
            int privilegeCountryID = 0;

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
                    }
                }
            }

            if (privilegeCountryID != 1000)
            {
                db_Countries.SelectCommand = "SELECT id, countryName FROM countries WHERE id = @countryID";
                db_Countries.SelectParameters.Add("countryID", privilegeCountryID.ToString());
            }
            else
            {
                db_Countries.SelectCommand = "SELECT id, countryName FROM countries where id != 1000";
            }
        }
        protected void GridCountries_BeforePerformDataSelect(object sender, EventArgs e)
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

            db_Countries.SelectParameters.Clear();

            if (privilegeCountryID != 1000)
            {
                db_Countries.SelectCommand = "SELECT id, countryName FROM countries WHERE id = @countryID";
                db_Countries.SelectParameters.Add("countryID", privilegeCountryID.ToString());
            }
            else
            {
                db_Countries.SelectCommand = "SELECT id, countryName FROM countries where id != 1000";
            }
        }


    }
}