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
    public partial class SiteMaster : MasterPage
    {
        public string isActive0 = string.Empty;
        public string isActive1 = string.Empty;
        public string isActive2 = string.Empty;
        public string isActive3 = string.Empty;
        public string isActive4 = string.Empty;
        public string isActive5 = string.Empty;
        public string isActive6 = string.Empty;
        public string isActive7 = string.Empty;
        public string isActive8 = string.Empty;
        public string isActive9 = string.Empty;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request.QueryString["i"] != null)
            {
                string code = Request.QueryString["i"].ToString();

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

                            // إذا كان Deep Link
                            if (originalLink.StartsWith("alshaebdriver://", StringComparison.OrdinalIgnoreCase))
                            {
                                // استدعاء الدالة الجديدة
                                var userInfo = GetUserInfoFromDeepLink(originalLink);

                                string platform = userInfo.platform;

                                // تحديد fallback حسب المنصة
                                string fallbackUrl = (platform == "android")
                                    ? "https://play.google.com/store/apps/details?id=com.alshaeb.alshaeb"
                                    : "https://apps.apple.com/us/app/alshaeb-click/id6752823758";

                                string landingUrl =
                                    "landing.aspx?deep=" + Server.UrlEncode(originalLink) +
                                    "&fallback=" + Server.UrlEncode(fallbackUrl);

                                Response.Redirect(landingUrl, true);
                                return;
                            }

                            // الروابط العادية
                            Response.Redirect(originalLink, true);
                            return;
                        }
                        return;
                    }
                }
            }

            if (!Request.Url.AbsolutePath.Equals("/Default", StringComparison.OrdinalIgnoreCase))
            {
                cmbCountries.Visible = false;
                cmbCompanies.Visible = false;
            }

            if (Request.Cookies["M_Username"] != null && !string.IsNullOrEmpty(Request.Cookies["M_Username"].Value))
            {
                string fileName = Path.GetFileNameWithoutExtension(Page.AppRelativeVirtualPath).ToLower();
                DataView dv = new DataView();
                DataTable dt = new DataTable();
                DB_checkLogin.SelectParameters["Username"].DefaultValue = MainHelper.M_Check(Request.Cookies["M_Username"].Value.ToString());
                DB_checkLogin.SelectParameters["pageFileName"].DefaultValue = fileName;
                dv = DB_checkLogin.Select(DataSourceSelectArguments.Empty) as DataView;
                if (dv != null && dv.Count != 0)
                {
                    dt = dv.ToTable();
                    foreach (DataRow dr in dt.Rows)
                    {
                        mainFullName.Text = " أهلا " + dr["userFullName"].ToString();
                    }
                }
                else
                {
                    if (fileName != "noprivileges")
                    {
                        if (Page.IsCallback)
                            DevExpress.Web.ASPxWebControl.RedirectOnCallback("/NoPrivileges");
                        else
                            Response.Redirect("/NoPrivileges");
                    }
                }
            }
            else
            {
                Response.Cookies["M_Username"].Value = string.Empty;
                Response.Cookies["M_Username"].Expires = DateTime.Now.AddDays(-1);

                if (Page.IsCallback)
                    DevExpress.Web.ASPxWebControl.RedirectOnCallback("/Sign?Error=3");
                else
                    Response.Redirect("/Sign?Error=4");
            }

            string pageName = Request.Url.AbsolutePath.ToString();
            if (pageName.ToLower().Contains("/default"))
            {
                isActive1 = "active";
            }
            else if (pageName.ToLower().Contains("/countries"))
            {
                isActive0 = "active";
            }
            else if (pageName.ToLower().Contains("/branches"))
            {
                isActive2 = "active";
            }
            else if (pageName.ToLower().Contains("/categories"))
            {
                isActive3 = "active";
            }
            else if (pageName.ToLower().Contains("/products"))
            {
                isActive4 = "active";
            }
            else if (pageName.ToLower().Contains("/companies"))
            {
                isActive5 = "active";
            }
            else if (pageName.ToLower().Contains("/prices"))
            {
                isActive6 = "active";
            }
            else if (pageName.ToLower().Contains("/clones"))
            {
                isActive7 = "active";
            }
            else if (pageName.ToLower().Contains("/offers"))
            {
                isActive8 = "active";
            }
            else if (pageName.ToLower().Contains("/cities"))
            {
                isActive9 = "active";
            }

            if (!IsPostBack)
            {
                if (Request.Cookies["SelectedCountry"] != null && !string.IsNullOrEmpty(Request.Cookies["SelectedCountry"].Value))
                {
                    cmbCountries.Value = Convert.ToInt32(Request.Cookies["SelectedCountry"].Value);
                }
                else
                {
                    cmbCountries.Value = 1;


                    var cookie = new HttpCookie("SelectedCountry", "1")
                    {
                        Expires = DateTime.Now.AddDays(365),
                        Secure = true,
                        SameSite = SameSiteMode.Strict,
                        Path = "/"
                    };
                    Response.Cookies.Add(cookie);
                }


                if (Request.Cookies["SelectedCompany"] != null && !string.IsNullOrEmpty(Request.Cookies["SelectedCompany"].Value))
                {
                    cmbCompanies.Value = Convert.ToInt32(Request.Cookies["SelectedCompany"].Value);
                }
                else
                {
                    cmbCompanies.Value = 1000;


                    var cookie = new HttpCookie("SelectedCompany", "1000")
                    {
                        Expires = DateTime.Now.AddDays(365),
                        Secure = true,
                        SameSite = SameSiteMode.Strict,
                        Path = "/"
                    };
                    Response.Cookies.Add(cookie);
                }
            }

        }
        private (string userId, string platform) GetUserInfoFromDeepLink(string deepLink)
        {
            string userId = null;
            string username = null;
            string platform = "ios"; // الافتراضي

            // --- استخراج id أو username من الـ deep link ---
            try
            {
                Uri uri;
                if (Uri.TryCreate(deepLink.Replace("alshaebdriver://", "http://"), UriKind.Absolute, out uri))
                {
                    var parameters = System.Web.HttpUtility.ParseQueryString(uri.Query);

                    userId = parameters["id"];
                    username = parameters["phone"];
                }
            }
            catch
            {
                // تجاهل أي خطأ
            }

            // إذا لا id ولا username → نرجع الافتراضي
            if (string.IsNullOrEmpty(userId) && string.IsNullOrEmpty(username))
                return (null, platform);

            string connStr = ConfigurationManager.ConnectionStrings["ShabDB_connection"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                string sql;

                // --- الأولوية للبحث بالـ id ---
                if (!string.IsNullOrEmpty(userId))
                {
                    sql = "SELECT id, userPlatform FROM usersDelivery WHERE id = @value";
                }
                else
                {
                    sql = "SELECT id, userPlatform FROM usersDelivery WHERE username = @value";
                }

                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@value", !string.IsNullOrEmpty(userId) ? userId : username);

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            userId = reader["id"].ToString();
                            platform = reader["userPlatform"]?.ToString().ToLower() ?? platform;
                        }
                    }
                }
            }

            return (userId, platform);
        }


    }
}
