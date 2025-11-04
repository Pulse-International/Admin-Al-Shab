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
    public partial class Cities : Page
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
                    SqlCommand cmd = new SqlCommand("SELECT privilegeCountryID FROM users WHERE username = @username", conn);
                    cmd.Parameters.AddWithValue("@username", username);

                    SqlDataReader reader = cmd.ExecuteReader();
                    if (reader.Read() && reader["privilegeCountryID"] != DBNull.Value)
                        privilegeCountryID = Convert.ToInt32(reader["privilegeCountryID"]);
                }
            }

            if (privilegeCountryID != 1000)
            {
                if (DB_Countries.SelectParameters["id"] != null)
                    DB_Countries.SelectParameters["id"].DefaultValue = privilegeCountryID.ToString();
                
                if (db_Cities.SelectParameters["id"] != null)
                    db_Cities.SelectParameters["id"].DefaultValue = privilegeCountryID.ToString();
            }
        }
    }
}