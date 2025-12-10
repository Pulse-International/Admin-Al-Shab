using DevExpress.Web;
using Microsoft.Ajax.Utilities;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Runtime.InteropServices.ComTypes;
using System.Security.Cryptography;
using System.Text;
using System.Web;
using System.Web.Services.Description;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml.Linq;
using static MainHelper;

namespace ShabAdmin
{
    public partial class ldeliveryCompleted : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string encryptedId = Request.QueryString["id"];
                string realId = "";
                if (!string.IsNullOrEmpty(encryptedId))
                {

                    realId = MainHelper.Decrypt_Me(encryptedId,true);
                }
                LoadDriverData(realId);
            }
        }
        public void LoadDriverData(string id)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["ShabDB_connection"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                //int integerid = Convert.ToInt32(id);
                string query = @"select * from usersDelivery where id = @integerid";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@integerid", id);

                    conn.Open();
                    SqlDataReader rdr = cmd.ExecuteReader();

                    if (rdr.Read())
                    {
                        nameatheader.Text = rdr["firstName"].ToString();
                        lastheader.Text = rdr["lastName"].ToString();
                        driverProfilePic.Src = rdr["userPicture"].ToString();
                        Session["phone"] = rdr["username"].ToString();
                        Session["userplatform"] = rdr["userPlatform"];
                    }
                }
            }
        }
        public async void btnSubmit_change(object sender, EventArgs e)
        {
            string userplatform = Session["userplatform"].ToString(); 
            string phone = Session["phone"].ToString();
            string idvalue = Request.QueryString["id"];
            string encryptedId = MainHelper.Decrypt_Me(idvalue, true);
            string firstinput = txtPassword.Text;
            string confirmpass = txtConfirm.Text;
            bool isactivee = true;
            HashSalt hashed = MainHelper.HashPassword(firstinput);
            if (firstinput != confirmpass)
            {
                confirm.Text = "لا يوجد تطابق بين القيم المدخلة";
                return;
            }
            else
            {
                confirm.Text = " ";
                string connectionString = ConfigurationManager.ConnectionStrings["ShabDB_connection"].ConnectionString;
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"update usersDelivery set password = @hashed,storedSalt=@hashedd,isactive=@isactivee
                                    where id = @encryptedId";
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@hashed",hashed.Hash);
                        cmd.Parameters.Add(new SqlParameter("@hashedd", Convert.FromBase64String(hashed.Salt)));
                        cmd.Parameters.AddWithValue("@isactivee", isactivee);
                        cmd.Parameters.AddWithValue("@encryptedId", encryptedId);
                        conn.Open();
                        cmd.ExecuteNonQuery();
                    }
                }
                await MainHelper.SendSms(phone, "تم تعيين كلمة المرور بنجاح. يمكنك الآن تسجيل الدخول إلى تطبيق الشعب كليك");
            }

            string storeUrl = "";
            if (userplatform == "ANDROID")
            {
                storeUrl = "https://play.google.com/store/apps/details?id=com.alshaeb.alshaeb";
            }
            else  
            {
                storeUrl = "https://apps.apple.com/us/app/alshaeb-click/id6752823758";
            }
            //else
            //{
            //    storeUrl = "https://www.google.com";
            //}

            string script = $"setTimeout(function() {{ ShowRedirectPopup('{storeUrl}'); }}, 100);";

            ClientScript.RegisterStartupScript(this.GetType(), "RedirectScript", script, true);
        }
    }
}