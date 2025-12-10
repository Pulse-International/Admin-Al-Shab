using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web.UI;

namespace ShabAdmin
{
    public partial class Sign : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string code = Request.QueryString["i"];

                if (!string.IsNullOrEmpty(code))
                {
                    if (code == "I")
                    {
                        Response.Redirect("https://apps.apple.com/us/app/alshaeb-click/id6752823758", true);
                        return;
                    }
                    if (code == "A")
                    {
                        Response.Redirect("https://play.google.com/store/apps/details?id=com.alshaeb.alshaeb", true);
                        return;
                    }
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
            }
                //DB_Login.InsertParameters["username"].DefaultValue = "mohammad";
                //DB_Login.InsertParameters["password"].DefaultValue = MainHelper.Encrypt_User("power");
                //DB_Login.InsertParameters["isActive"].DefaultValue = "1";
                //DB_Login.Insert();
                Response.Cookies["M_Username"].Value = string.Empty;
            Response.Cookies["M_Username"].Expires = DateTime.Now.AddDays(-1);
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {            
            btnLogin.ClientEnabled = false;

            DataView dv = new DataView();
            DataTable dt = new DataTable();
            DB_Login.SelectParameters["Username"].DefaultValue = username.Text;            
            dv = DB_Login.Select(DataSourceSelectArguments.Empty) as DataView;
            if (dv != null && dv.Count != 0)
            {
                dt = dv.ToTable();
                foreach (DataRow dr in dt.Rows)
                {
                    if (MainHelper.Decrypt_User(dr["password"].ToString()) == cPassword.Text)
                    {
                        if (Convert.ToInt32(dr["isActive"]) == 0)
                        {
                            Response.Cookies["cUsername"].Value = string.Empty;
                            Response.Cookies["cUsername"].Expires = DateTime.Now.AddDays(-1);
                            Response.Redirect("/prohibited");
                        }
                        else
                        {
                            if (Captche_Check.IsValid)
                            {
                                string E_Cook = MainHelper.Encrypt_User(dr["username"].ToString());
                                Response.Cookies["M_Username"].Value = E_Cook;
                                Response.Cookies["M_Username"].HttpOnly = true;
                                Response.Cookies["M_Username"].Expires = DateTime.Now.AddDays(365);

                                Response.Redirect("/Default");
                            }
                            else
                            {
                                Response.Cookies["M_Username"].Value = string.Empty;
                                Response.Cookies["cUsername"].Expires = DateTime.Now.AddDays(-1);
                                Response.Redirect("/Sign?error=2");
                            }                            
                        }
                    }
                    else
                        Response.Redirect("/Sign?error=1");
                }
            }
            else
            {
                username.Text = string.Empty;
                cPassword.Text = string.Empty;
                Response.Cookies["M_Username"].Value = string.Empty;
                Response.Cookies["M_Username"].Expires = DateTime.Now.AddDays(-1);
                Response.Redirect("/Sign?error=2");
            }
        }

    }
}