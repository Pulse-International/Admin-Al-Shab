using Google.Apis.Auth.OAuth2;
using Newtonsoft.Json;
using System.Collections.Generic;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Text;
using System.Web.UI;

public class FcmSender : Page
{
    private GoogleCredential _googleCredential;

    public FcmSender()
    {
        string serviceAccountFilePath = Server.MapPath("~/alshaeb-click-firebase-adminsdk-fbsvc-1c66124f5a.json");
        _googleCredential = GoogleCredential.FromFile(serviceAccountFilePath).CreateScoped("https://www.googleapis.com/auth/firebase.messaging");
    }

    public string Send(string usersGroup, string actionType, string token, string title, string body, string imagePath = "", string companyId = "", string productId = "")
    {
        string projectId = "alshaeb-click";
        var _httpClient = new HttpClient();

        var task = _googleCredential.UnderlyingCredential.GetAccessTokenForRequestAsync();
        //task.Wait();
        string accessToken = task.Result;

        _httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", accessToken);

        var obj = new Dictionary<string, int>();
        obj["mutable-content"] = 1;

        var messageDevice = new
        {
            message = new
            {
                token = token,
                notification = new
                {
                    title = title,
                    body = body,
                    image = imagePath
                },
                apns = new
                {
                    payload = new
                    {
                        aps = new Dictionary<string, int>
                        {
                            ["mutable-content"] = 1
                        }
                    }
                },
                data = new
                {
                    action = actionType,
                    company_id = companyId,
                    product_id = productId,
                    image = imagePath
                }
            }
        };

        var messageAllDevices = new
        {
            message = new
            {
                topic = usersGroup,
                notification = new
                {
                    title = title,
                    body = body,
                    image = imagePath
                },
                apns = new
                {
                    payload = new
                    {
                        aps = new Dictionary<string, int>
                        {
                            ["mutable-content"] = 1
                        }
                    }
                },
                data = new
                {
                    action = actionType,
                    company_id = companyId,
                    product_id = productId,
                    image = imagePath
                }
            }
        };

        var message = string.IsNullOrEmpty(usersGroup) ? (object)messageDevice : (object)messageAllDevices;
        var jsonMessage = JsonConvert.SerializeObject(message);
        var content = new StringContent(jsonMessage, Encoding.UTF8, "application/json");
        var url = "https://fcm.googleapis.com/v1/projects/" + projectId + "/messages:send";

        var response = _httpClient.PostAsync(url, content).Result;
        var responseString = response.Content.ReadAsStringAsync().Result;

        return responseString;
    }
}
