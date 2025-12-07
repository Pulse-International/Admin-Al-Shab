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

                    realId = Decrypt_Me(encryptedId);
                }
                LoadDriverData(realId);
            }
        }
        public void LoadDriverData(string id)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["ShabDBConnectionString"].ConnectionString;
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
        public void btnSubmit_change(object sender, EventArgs e)
        {
            string userplatform = Session["userplatform"].ToString(); 
            string phone = Session["phone"].ToString();
            string idvalue = Request.QueryString["id"];
            string encryptedId = Decrypt_Me(idvalue);
            string firstinput = txtPassword.Text;
            string confirmpass = txtConfirm.Text;
            HashSalt hashed = MainHelper.HashPassword(firstinput);
            if (firstinput != confirmpass)
            {
                confirm.Text = "لا يوجد تطابق بين القيم المدخلة";
            }
            else
            {
                string connectionString = ConfigurationManager.ConnectionStrings["ShabDBConnectionString"].ConnectionString;
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"update usersDelivery set password = @hashed 
                                    where id = @encryptedId";
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@hashed",hashed.Hash);
                        cmd.Parameters.AddWithValue("@encryptedId", encryptedId);
                        conn.Open();
                        cmd.ExecuteNonQuery();
                    }
                }
                MainHelper.SendSms(phone, "تم تعيين كلمة المرور بنجاح. يمكنك الآن تسجيل الدخول إلى تطبيق الشعب كليك");
            }

            string storeUrl = "";

            if (userplatform == "ANDROID")
            {
                storeUrl = "https://play.google.com/store/apps/details?id=com.yourcompany.shabclick";
            }
            else  
            {
                storeUrl = "https://apps.apple.com/jo/app/shab-click/id123456789";
            }
            //else
            //{
            //    storeUrl = "https://www.google.com";
            //}

            string script = $"setTimeout(function() {{ ShowRedirectPopup('{storeUrl}'); }}, 100);";

            ClientScript.RegisterStartupScript(this.GetType(), "RedirectScript", script, true);
        }
        private static string Decrypt_Me(string cipherString)
        {
            try
            {
                // اطبع القيمة قبل أي تعديل لمعرفة أين الخطأ
                System.Diagnostics.Debug.WriteLine("cipherString BEFORE ANY FIX = [" + cipherString + "]");

                // تأمين القيمة
                cipherString = (cipherString ?? "").Trim();

                // أولاً: فك الـ URL (لأنه يحوّل + إلى %2B وخلافه)
                cipherString = HttpUtility.UrlDecode(cipherString);

                // ثانياً: إصلاح المسافات التي استبدلت مكان +
                cipherString = cipherString.Replace(' ', '+');

                // اطبع بعد الإصلاح
                System.Diagnostics.Debug.WriteLine("cipherString AFTER FIX = [" + cipherString + "]");

                // الآن فك Base64
                byte[] data = Convert.FromBase64String(cipherString);

                // جلب المفتاح من Web.config
                string key = ConfigurationManager.AppSettings["SecurityKey"];

                // فك التشفير TripleDES
                using (var md5 = MD5.Create())
                using (var tdes = new TripleDESCryptoServiceProvider())
                {
                    tdes.Key = md5.ComputeHash(Encoding.UTF8.GetBytes(key));
                    tdes.Mode = CipherMode.ECB;
                    tdes.Padding = PaddingMode.PKCS7;

                    using (var decryptor = tdes.CreateDecryptor())
                    {
                        byte[] result = decryptor.TransformFinalBlock(data, 0, data.Length);
                        return Encoding.UTF8.GetString(result);
                    }
                }
            }
            catch (Exception ex)
            {
                // اطبع الخطأ لنعرف السبب الحقيقي
                System.Diagnostics.Debug.WriteLine("DECRYPT ERROR: " + ex.Message);
                return "-";
            }
        }
    }
}