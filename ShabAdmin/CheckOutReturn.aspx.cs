using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Net;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;
using System.Web.Script.Serialization;
using System.Web.UI;

namespace ShabAdmin
{
    public partial class CheckOutReturn : Page
    {
        string checkoutID = string.Empty;

        protected void Page_Load(object sender, EventArgs e)
        {
            checkoutID = Request.QueryString["resourcePath"];

            if (string.IsNullOrEmpty(checkoutID))
            {
                Response.Write("Error: Missing checkout ID");
                return;
            }

            try
            {
                var response = CheckPayment(checkoutID);

                if (response.ContainsKey("result") && response["result"] != null)
                {
                    string code = response["result"]["code"].ToString();
                    string description = response["result"]["description"].ToString();

                    if (code.Substring(0, 3) == "000")
                    {
                        // Payment successful logic
                        Response.Write("Success: " + description);
                    }
                    else
                    {
                        // Payment failed
                        Response.Write("Failed: " + description + " (Code: " + code + ")");
                    }
                }
                else
                {
                    Response.Write("Error: Invalid response from payment gateway");
                }
            }
            catch (WebException ex)
            {
                Response.Write("Network Error: " + ex.Message);
            }
            catch (Exception ex)
            {
                Response.Write("Error: " + ex.Message);
            }
        }


        public Dictionary<string, dynamic> CheckPayment(string checkoutID)
        {
            Dictionary<string, dynamic> responseData;
            string data = "entityId=8ac7a4c798efa08c0198efe15bba007c";
            string url = "https://eu-test.oppwa.com" + checkoutID + "?" + data;
            HttpWebRequest request = (HttpWebRequest)HttpWebRequest.Create(url);
            request.Method = "GET";
            request.Headers["Authorization"] = "Bearer OGFjN2E0Yzc5OGVmYTA4YzAxOThlZmUwYTk2NzAwNzZ8c25hM21OdURmZ3NpQHFlNDZVaiE=";
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




        //public Dictionary<string, dynamic> CheckPayment(string checkoutID)
        //{
        //    Dictionary<string, dynamic> responseData;

        //    try
        //    {
        //        string entityId = "8ac7a4c798efa08c0198efe15bba007c";
        //        string url = $"https://eu-test.oppwa.com/v1/checkouts/{checkoutID}/payment?entityId={entityId}";

        //        Console.WriteLine("DEBUG URL: " + url);

        //        HttpWebRequest request = (HttpWebRequest)WebRequest.Create(url);
        //        request.Method = "GET";
        //        request.Headers["Authorization"] = "Bearer OGFjN2E0Yzc5OGVmYTA4YzAxOThlZmUwYTk2NzAwNzZ8c25hM21OdURmZ3NpQHFlNDZVaiE=";

        //        using (HttpWebResponse response = (HttpWebResponse)request.GetResponse())
        //        using (Stream dataStream = response.GetResponseStream())
        //        using (StreamReader reader = new StreamReader(dataStream))
        //        {
        //            var s = new JavaScriptSerializer();
        //            responseData = s.Deserialize<Dictionary<string, dynamic>>(reader.ReadToEnd());
        //        }
        //    }
        //    catch (WebException ex)
        //    {
        //        string errorResponse = "";
        //        if (ex.Response != null)
        //        {
        //            using (var stream = ex.Response.GetResponseStream())
        //            using (var reader = new StreamReader(stream))
        //            {
        //                errorResponse = reader.ReadToEnd();
        //            }
        //        }

        //        responseData = new Dictionary<string, dynamic>
        //{
        //    { "error", ex.Message },
        //    { "response", errorResponse }
        //};
        //    }

        //    return responseData;
        //}



       





    }
}