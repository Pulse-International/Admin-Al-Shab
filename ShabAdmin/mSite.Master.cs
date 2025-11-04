using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ShabAdmin
{
    public partial class mSiteMaster : MasterPage
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
        public string isActive10 = string.Empty;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Request.Url.AbsolutePath.Equals("/mDefault", StringComparison.OrdinalIgnoreCase))
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
            if (pageName.ToLower().Contains("/mdefault"))
            {
                isActive0 = "active";
            }
            else if (pageName.ToLower().Contains("/morders"))
            {
                isActive1 = "active";
            }
            else if (pageName.ToLower().Contains("/mrealorders"))
            {
                isActive3 = "active";
            }
            else if (pageName.ToLower().Contains("/mrates"))
            {
                isActive2 = "active";
            }
            else if (pageName.ToLower().Contains("/mpoints"))
            {
                isActive4 = "active";
            }
            else if (pageName.ToLower().Contains("/mcoupons"))
            {
                isActive5 = "active";
            }
            else if (pageName.ToLower().Contains("/motp"))
            {
                isActive6 = "active";
            }
            else if (pageName.ToLower().Contains("/mlookups"))
            {
                isActive7 = "active";
            }
            else if (pageName.ToLower().Contains("/mnotifications"))
            {
                isActive8 = "active";
            }
            else if (pageName.ToLower().Contains("/mrefund"))
            {
                isActive9 = "active";
            }
            else if (pageName.ToLower().Contains("/mreports"))
            {
                isActive10 = "active";
            }

            if (!IsPostBack)
            {
                if (Request.Cookies["mSelectedCountry"] != null && !string.IsNullOrEmpty(Request.Cookies["mSelectedCountry"].Value))
                {
                    cmbCountries.Value = Convert.ToInt32(Request.Cookies["mSelectedCountry"].Value);
                }
                else
                {
                    cmbCountries.Value = 1;


                    var cookie = new HttpCookie("mSelectedCountry", "1")
                    {
                        Expires = DateTime.Now.AddDays(365),
                        Secure = true,
                        SameSite = SameSiteMode.Strict,
                        Path = "/"
                    };
                    Response.Cookies.Add(cookie);
                }


                if (Request.Cookies["mSelectedCompany"] != null && !string.IsNullOrEmpty(Request.Cookies["mSelectedCompany"].Value))
                {
                    cmbCompanies.Value = Convert.ToInt32(Request.Cookies["mSelectedCompany"].Value);
                }
                else
                {
                    cmbCompanies.Value = 1000;


                    var cookie = new HttpCookie("mSelectedCompany", "1000")
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


    }

}
