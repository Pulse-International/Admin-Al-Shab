using DevExpress.Web;
using DevExpress.Web.Data;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Drawing;
using System.Drawing.Imaging;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ShabAdmin
{
    public partial class Cities : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            //string inputFolder = Server.MapPath("~/assets/uploads/");
            //string outputFolder = Server.MapPath("~/assets/uploads/compressed/");
            //if (!Directory.Exists(outputFolder))
            //    Directory.CreateDirectory(outputFolder);

            //string[] allowedExtensions = { ".jpg", ".jpeg", ".png" };

            //foreach (string filePath in Directory.GetFiles(inputFolder))
            //{
            //    string extension = Path.GetExtension(filePath).ToLower();
            //    if (!allowedExtensions.Contains(extension))
            //        continue;

            //    string fileName = Path.GetFileNameWithoutExtension(filePath);
            //    string outputPath = Path.Combine(outputFolder, fileName + ".jpg");

            //    try
            //    {
            //        ConvertToCompressedJpg(filePath, outputPath);

            //        // عرض الحجم القديم والجديد
            //        long oldSize = new FileInfo(filePath).Length;
            //        long newSize = new FileInfo(outputPath).Length;
            //        double reduction = ((oldSize - newSize) / (double)oldSize) * 100;

            //        Response.Write($"<br/>{Path.GetFileName(filePath)}: {FormatBytes(oldSize)} → {FormatBytes(newSize)} (تقليل {reduction:F1}%)");
            //    }
            //    catch (Exception ex)
            //    {
            //        Response.Write($"<br/>خطأ في ضغط الصورة {Path.GetFileName(filePath)}: {ex.Message}");
            //    }
            //}
        }

        private void ConvertToCompressedJpg(string inputPath, string outputPath)
        {
            using (Bitmap original = new Bitmap(inputPath))
            {
                // إنشاء صورة جديدة بخلفية بيضاء
                using (Bitmap newBitmap = new Bitmap(original.Width, original.Height, PixelFormat.Format24bppRgb))
                {
                    using (Graphics g = Graphics.FromImage(newBitmap))
                    {
                        // ملء الخلفية باللون الأبيض
                        g.Clear(Color.White);

                        // إعدادات الجودة العالية للرسم
                        g.CompositingMode = System.Drawing.Drawing2D.CompositingMode.SourceOver;
                        g.CompositingQuality = System.Drawing.Drawing2D.CompositingQuality.HighQuality;
                        g.InterpolationMode = System.Drawing.Drawing2D.InterpolationMode.HighQualityBicubic;
                        g.SmoothingMode = System.Drawing.Drawing2D.SmoothingMode.HighQuality;
                        g.PixelOffsetMode = System.Drawing.Drawing2D.PixelOffsetMode.HighQuality;

                        // رسم الصورة الأصلية فوق الخلفية البيضاء
                        g.DrawImage(original, 0, 0, original.Width, original.Height);
                    }

                    // حفظ بصيغة JPG مع ضغط عالي
                    ImageCodecInfo jpgEncoder = GetEncoder(ImageFormat.Jpeg);
                    EncoderParameters encoderParams = new EncoderParameters(1);

                    // جودة 60-70 للحصول على حجم صغير جداً (يمكنك التقليل إلى 50 للمزيد من الضغط)
                    long quality = 65L;
                    encoderParams.Param[0] = new EncoderParameter(System.Drawing.Imaging.Encoder.Quality, quality);

                    newBitmap.Save(outputPath, jpgEncoder, encoderParams);
                }
            }
        }

        private ImageCodecInfo GetEncoder(ImageFormat format)
        {
            ImageCodecInfo[] codecs = ImageCodecInfo.GetImageDecoders();
            foreach (ImageCodecInfo codec in codecs)
            {
                if (codec.FormatID == format.Guid)
                    return codec;
            }
            return null;
        }

        private string FormatBytes(long bytes)
        {
            if (bytes < 1024) return bytes + " B";
            if (bytes < 1024 * 1024) return (bytes / 1024.0).ToString("F2") + " KB";
            return (bytes / (1024.0 * 1024.0)).ToString("F2") + " MB";
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