using Microsoft.AspNetCore.Cryptography.KeyDerivation;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Drawing;
using System.Drawing.Imaging;
using System.IO;
using System.Net;
using System.Net.Http;
using System.Security.Cryptography;
using System.Text;
using System.Text.Json;
using System.Threading.Tasks;
using System.Web;
using System.Xml.Linq;
using static Google.Apis.Requests.BatchRequest;

public class MainHelper
{
    public static string GetCurrency(object countryIdObj)
    {
        int countryId = countryIdObj != DBNull.Value ? Convert.ToInt32(countryIdObj) : 0;
        string currencyText;

        switch (countryId)
        {
            case 1:
            case 2:
                currencyText = "دينار أردني";
                break;
            case 3:
                currencyText = "ريال قطري";
                break;
            case 4:
                currencyText = "دينار بحريني";
                break;
            case 5:
                currencyText = "درهم إماراتي";
                break;
            case 6:
                currencyText = "دينار كويتي";
                break;
            default:
                currencyText = "دولار";
                break;
        }

        return currencyText;
    }

    public static string M_Check(string username)
    {
        try
        {
            return Decrypt_User(username);
        }
        catch
        {
            return "-";
        }
    }
    public static string Encrypt_User(string Username)
    {
        string EncryptString = Encrypt_Me(Encrypt_Me(Encrypt_Me(Username, true), true), true);
        return EncryptString;
    }
    public static string Decrypt_User(string Username)
    {
        string PreCode = Decrypt_Me(Decrypt_Me(Decrypt_Me(Username, true), true), true);
        return PreCode;
    }
    public static string Encrypt_Me(string toEncrypt, bool useHashing) // this is public for poll_admin
    {
        try
        {
            byte[] keyArray;
            byte[] toEncryptArray = UTF8Encoding.UTF8.GetBytes(toEncrypt);

            System.Configuration.AppSettingsReader settingsReader = new AppSettingsReader();
            string key = (string)settingsReader.GetValue("SecurityKey", typeof(String));
            if (useHashing)
            {
                MD5CryptoServiceProvider hashmd5 = new MD5CryptoServiceProvider();
                keyArray = hashmd5.ComputeHash(UTF8Encoding.UTF8.GetBytes(key));
                hashmd5.Clear();
            }
            else
                keyArray = UTF8Encoding.UTF8.GetBytes(key);

            TripleDESCryptoServiceProvider tdes = new TripleDESCryptoServiceProvider();
            tdes.Key = keyArray;
            tdes.Mode = CipherMode.ECB;
            tdes.Padding = PaddingMode.PKCS7;

            ICryptoTransform cTransform = tdes.CreateEncryptor();
            byte[] resultArray = cTransform.TransformFinalBlock(toEncryptArray, 0, toEncryptArray.Length);
            tdes.Clear();
            return Convert.ToBase64String(resultArray, 0, resultArray.Length);
        }
        catch
        {
            return "-";
        }
    }

    private static string Decrypt_Me(string cipherString, bool useHashing)
    {
        try
        {
            byte[] keyArray;
            byte[] toEncryptArray = Convert.FromBase64String(cipherString);

            System.Configuration.AppSettingsReader settingsReader = new AppSettingsReader();
            string key = (string)settingsReader.GetValue("SecurityKey", typeof(String));

            if (useHashing)
            {
                MD5CryptoServiceProvider hashmd5 = new MD5CryptoServiceProvider();
                keyArray = hashmd5.ComputeHash(UTF8Encoding.UTF8.GetBytes(key));
                hashmd5.Clear();
            }
            else
                keyArray = UTF8Encoding.UTF8.GetBytes(key);

            TripleDESCryptoServiceProvider tdes = new TripleDESCryptoServiceProvider();
            tdes.Key = keyArray;
            tdes.Mode = CipherMode.ECB;
            tdes.Padding = PaddingMode.PKCS7;

            ICryptoTransform cTransform = tdes.CreateDecryptor();
            byte[] resultArray = cTransform.TransformFinalBlock(toEncryptArray, 0, toEncryptArray.Length);

            tdes.Clear();
            return UTF8Encoding.UTF8.GetString(resultArray);
        }
        catch
        {
            return "-";
        }
    }
    public class HashSalt
    {
        public string Hash { get; set; }
        public string Salt { get; set; }
    }

    public static HashSalt HashPassword(string password)
    {
        byte[] salt = new byte[128 / 8];
        using (var rng = RandomNumberGenerator.Create())
        {
            rng.GetBytes(salt);
        }

        string hashed = Convert.ToBase64String(KeyDerivation.Pbkdf2(
            password: password,
            salt: salt,
            prf: KeyDerivationPrf.HMACSHA1,
            iterationCount: 10000,
            numBytesRequested: 256 / 8));

        return new HashSalt
        {
            Hash = hashed,
            Salt = Convert.ToBase64String(salt)
        };
    }

    public static void CompressAndSaveImage(System.Drawing.Image original, string outputPath, int maxWidth, int maxHeight, long quality)
    {
        // تحديد الأبعاد الجديدة مع الحفاظ على النسبة
        int newWidth = original.Width;
        int newHeight = original.Height;

        // حساب الأبعاد الجديدة إذا كانت الصورة أكبر من الحد الأقصى
        if (original.Width > maxWidth || original.Height > maxHeight)
        {
            double ratioX = (double)maxWidth / original.Width;
            double ratioY = (double)maxHeight / original.Height;
            double ratio = Math.Min(ratioX, ratioY);

            newWidth = (int)(original.Width * ratio);
            newHeight = (int)(original.Height * ratio);
        }

        // إنشاء صورة جديدة بالأبعاد المحسوبة
        using (Bitmap resized = new Bitmap(newWidth, newHeight, PixelFormat.Format24bppRgb))
        {
            using (Graphics g = Graphics.FromImage(resized))
            {
                // ملء الخلفية باللون الأبيض (للصور الشفافة)
                g.Clear(Color.White);

                // إعدادات الجودة العالية
                g.CompositingMode = System.Drawing.Drawing2D.CompositingMode.SourceOver;
                g.CompositingQuality = System.Drawing.Drawing2D.CompositingQuality.HighQuality;
                g.InterpolationMode = System.Drawing.Drawing2D.InterpolationMode.HighQualityBicubic;
                g.SmoothingMode = System.Drawing.Drawing2D.SmoothingMode.HighQuality;
                g.PixelOffsetMode = System.Drawing.Drawing2D.PixelOffsetMode.HighQuality;

                // رسم الصورة
                g.DrawImage(original, 0, 0, newWidth, newHeight);
            }

            // حفظ بصيغة JPG مع ضغط عالي
            ImageCodecInfo jpgEncoder = GetEncoder(ImageFormat.Jpeg);
            EncoderParameters encoderParams = new EncoderParameters(1);
            encoderParams.Param[0] = new EncoderParameter(System.Drawing.Imaging.Encoder.Quality, quality);

            resized.Save(outputPath, jpgEncoder, encoderParams);
        }
    }

    private static ImageCodecInfo GetEncoder(ImageFormat format)
    {
        ImageCodecInfo[] codecs = ImageCodecInfo.GetImageDecoders();
        foreach (ImageCodecInfo codec in codecs)
        {
            if (codec.FormatID == format.Guid)
                return codec;
        }
        return null;
    }

    public static TelrResponse TelrPaymentRefund(decimal amount = 0, string transactionRef = "", string description = "", string test = "1")
    {
        string StoreID = System.Configuration.ConfigurationManager.AppSettings["StoreID"];
        string StoreKey = System.Configuration.ConfigurationManager.AppSettings["StoreKey"];

        var xmlRequest = new XDocument(
             new XDeclaration("1.0", "UTF-8", null),
             new XElement("remote",
                 new XElement("store", StoreID),
                 new XElement("key", StoreKey),
                 new XElement("tran",
                     new XElement("type", "refund"),
                     new XElement("class", "ecom"),
                     new XElement("currency", "JOD"),
                     new XElement("amount", amount.ToString("0.##")),
                     new XElement("ref", transactionRef),
                     new XElement("test", test)
                 )
             )
         );

        using (var webClient = new WebClient())
        {
            webClient.Encoding = Encoding.UTF8;
            webClient.Headers[HttpRequestHeader.ContentType] = "application/xml";

            var xmlString = xmlRequest.Declaration + Environment.NewLine + xmlRequest.ToString(SaveOptions.DisableFormatting);

            string responseContent = string.Empty;
            try
            {
                responseContent = webClient.UploadString("https://secure.telr.com/gateway/remote.xml", xmlString);
            }
            catch (WebException ex)
            {
                return new TelrResponse
                {
                    Status = "error",
                    Message = ex.Message,
                    AllResult = ex.ToString()
                };
            }

            // Parse response
            var xml = XDocument.Parse(responseContent);
            var auth = xml.Root != null ? xml.Root.Element("auth") : null;
            var payment = xml.Root != null ? xml.Root.Element("payment") : null;

            var result = new TelrResponse
            {
                Status = auth != null && auth.Element("status") != null ? auth.Element("status").Value : null,
                Code = auth != null && auth.Element("code") != null ? auth.Element("code").Value : null,
                Message = auth != null && auth.Element("message") != null ? auth.Element("message").Value : null,
                TranRef = auth != null && auth.Element("tranref") != null ? auth.Element("tranref").Value : null,
                CVV = auth != null && auth.Element("cvv") != null ? auth.Element("cvv").Value : null,
                AVS = auth != null && auth.Element("avs") != null ? auth.Element("avs").Value : null,
                CartId = auth != null && auth.Element("cartid") != null ? auth.Element("cartid").Value : null,
                Trace = auth != null && auth.Element("trace") != null ? auth.Element("trace").Value : null,
                PaymentCode = payment != null && payment.Element("code") != null ? payment.Element("code").Value : null,
                PaymentDescription = payment != null && payment.Element("description") != null ? payment.Element("description").Value : null,
                CardEnd = payment != null && payment.Element("card_end") != null ? payment.Element("card_end").Value : null,
                CardBin = payment != null && payment.Element("card_bin") != null ? payment.Element("card_bin").Value : null,
                CardCountry = payment != null && payment.Element("card_country") != null ? payment.Element("card_country").Value : null,
                AllResult = responseContent
            };

            return result;
        }
    }

    public class TelrResponse
    {
        public string Status { get; set; }
        public string Code { get; set; }
        public string Message { get; set; }
        public string TranRef { get; set; }
        public string CVV { get; set; }
        public string AVS { get; set; }
        public string CartId { get; set; }
        public string Trace { get; set; }
        public string PaymentCode { get; set; }
        public string PaymentDescription { get; set; }
        public string CardEnd { get; set; }
        public string CardBin { get; set; }
        public string CardCountry { get; set; }
        public object AllResult { get; set; }
    }

    public static async Task<string> GenerateSMSToken()
    {
        using (var client = new HttpClient())
        {
            var request = new HttpRequestMessage(HttpMethod.Post,
                "https://zsms.jo.zain.com/core/user/rest/user/generateintegrationtoken");

            request.Headers.Add("username", "962791448258");
            request.Headers.Add("password", "Salah@2025");

            var response = await client.SendAsync(request);
            var content = await response.Content.ReadAsStringAsync();
            var jsonDoc = JsonDocument.Parse(content);

            return jsonDoc.RootElement
                .GetProperty("result")
                .GetProperty("integration_token")
                .GetString() ?? "";
        }
    }


    public static async Task<bool> SendSmsNowAsync(string token, string phone, string message)
    {
        using (var client = new HttpClient())
        {
            var request = new HttpRequestMessage(HttpMethod.Post,
                "https://zsms.jo.zain.com/core/corpsms/sendOTP");

            request.Headers.Add("integration_token", token);

            var body = new
            {
                service_type = "bulk_sms",
                recipient_numbers_type = "single_numbers",
                phone_numbers = new[] { phone },
                content = message,
                sender_id = "Shaeb_Click"
            };

            request.Content = new StringContent(
                JsonSerializer.Serialize(body),
                Encoding.UTF8,
                "application/json"
            );

            var response = await client.SendAsync(request);
            var content = await response.Content.ReadAsStringAsync();
            var jsonDoc = JsonDocument.Parse(content);

            return jsonDoc.RootElement
                .GetProperty("result")
                .GetProperty("valid_numbers_count")
                .GetInt32() == 1;
        }
    }

}
