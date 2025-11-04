using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Net;
using System.Text;
using System.Web.Script.Serialization;
using System.Web.UI;
using RestSharp;

namespace ShabAdmin
{
    public partial class CheckOut : Page
    {
        public string CheckPaymentId = string.Empty;
        public string responseData = string.Empty;
        public string ActionURL = "https://localhost:44349/checkOutReturn";
        string merchantTransactionId = string.Empty;
        string email = string.Empty;
        string givenName = string.Empty;
        string surname = string.Empty;

        protected void Page_Load(object sender, EventArgs e)
        {
            CheckPaymentId = RequestMe()["id"];            
        }
       
        public Dictionary<string, dynamic> RequestMe()
        {
            Random rnd = new Random();
            int num = rnd.Next(100000000, 999999999);

            Dictionary<string, dynamic> responseData;

            string data = "entityId=8ac7a4c798efa08c0198efe15bba007c" +
                "&amount=7" +
                "&currency=JOD" +
                "&paymentType=DB" +
                "&merchantTransactionId=100000007" +
                "&customer.email=aaymann@yahoo.com" +
                "&billing.street1=ST." +
                "&billing.city=Amman" +
                "&billing.state=Amman" +
                "&billing.country=JO" +
                "&billing.postcode=11185" +
                "&customer.givenName=AYMAN" +
                "&customer.surname=SALAH" +
           // "&testMode=EXTERNAL" +
            "&createRegistration=true" +
            "&customParameters[3DS2_enrolled]=true";

            string url = "https://eu-test.oppwa.com/v1/checkouts"; //TEST
            byte[] buffer = Encoding.ASCII.GetBytes(data);
            HttpWebRequest request = (HttpWebRequest)HttpWebRequest.Create(url);
            request.Method = "POST";
            request.Headers["Authorization"] = "Bearer OGFjN2E0Yzc5OGVmYTA4YzAxOThlZmUwYTk2NzAwNzZ8c25hM21OdURmZ3NpQHFlNDZVaiE=";//TEST
            request.ContentType = "application/x-www-form-urlencoded";
            Stream PostData = request.GetRequestStream();
            PostData.Write(buffer, 0, buffer.Length);
            PostData.Close();
            using (HttpWebResponse response = (HttpWebResponse)request.GetResponse())
            {
                Stream dataStream = response.GetResponseStream();
                StreamReader reader = new StreamReader(dataStream);
                var s = new JavaScriptSerializer();
                responseData = s.Deserialize<Dictionary<string, dynamic>>(reader.ReadToEnd());
                reader.Close();
                dataStream.Close();
            }
            return responseData;
        }
    }
}