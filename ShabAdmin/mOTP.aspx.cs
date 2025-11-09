using DevExpress.Web;
using DevExpress.Web.Data;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using static System.Net.Mime.MediaTypeNames;

namespace ShabAdmin
{
    public partial class mOTP : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }


        protected string GetOtpSquares(object otpObj)
        {
            if (otpObj == null)
                return "";

            // لو بدك الاتجاه الصحيح بدون عكس، احذف السطر الجاي
            string otp = new string(otpObj.ToString().Reverse().ToArray());

            string html = "<div style=' display:inline-block;'>";

            foreach (char c in otp)
            {
                html += $@"
        <span style='
            display:inline-block;
            width:40px;
            height:40px;
            margin:4px;
            border-radius:8px;
            background: linear-gradient(145deg, #00b26f, #00995e);
            color:#fff;
            font-weight:bold;
            font-family:monospace;
            text-align:center;
            font-size:30px;
            line-height:40px;
            box-shadow: 3px 3px 6px rgba(0,0,0,0.3), -2px -2px 4px rgba(255,255,255,0.2);
            transition: all 0.2s ease-in-out;
        '>{c}</span>";
            }

            html += "</div>";
            return html;
        }



    }
}