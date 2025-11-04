using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DevExpress.Web;

namespace ShabAdmin
{
    public partial class Prohibited : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Response.Cookies["M_Username"].Value = string.Empty;
            Response.Cookies["M_Username"].Expires = DateTime.Now.AddDays(-1);
        }
    }
}