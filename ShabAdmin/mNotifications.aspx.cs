using DevExpress.Web;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.IO;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ShabAdmin
{
    public partial class mNotifications : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }     

        string fileName = string.Empty;
        int checkError = 0;

        protected void ImageUpload_FileUploadComplete(object sender, FileUploadCompleteEventArgs e)
        {
            e.CallbackData = SavePostedFile_all(e.UploadedFile);

            if (l_item_file_check.Text == "1")
            {
                int pos = l_item_file.Text.LastIndexOf("/");
                string fileToDelete = l_item_file.Text.Substring(pos + 1);
                string[] fileList = Directory.GetFiles(Server.MapPath("\\assets\\uploads\\notifications"), fileToDelete);
                foreach (string file in fileList)
                {
                    File.Delete(file);
                }
                l_item_file_check.Text = "0";
            }

            if (checkError == 1)
            {
                checkError = 0;
                e.IsValid = false;
                e.ErrorText = "<div style='direction:rtl;padding-left: 10px;padding-right:10px;padding-top:0px;padding-buttom:0px'><strong>خطــأ:</strong> الصورة <strong>\"" + e.UploadedFile.FileName + "\"</strong> لم يتم تحميلها, الرجاء تحميل صورة جديدة بدلا منها.<br /><strong>لماذا:</strong> حقوق ملكية، تالفة، هيكلية الصورة...الخ.</div>";
            }
        }

        string SavePostedFile_all(UploadedFile uploadedFile)
        {
            if (!uploadedFile.IsValid)
                return string.Empty;
            string UploadDirectory = "/assets/uploads/notifications/";
            string Docs = Guid.NewGuid().ToString() + ".png";
            fileName = Docs;
            try
            {
                string filePath = Path.Combine(MapPath(UploadDirectory), Docs);
                using (System.Drawing.Image original = System.Drawing.Image.FromStream(uploadedFile.FileContent))
                {
                    MainHelper.CompressAndSaveImage(original, filePath, 500, 500, 65);
                }
            }
            catch
            {
                checkError = 1;
            }

            return UploadDirectory + fileName;
        }

        protected void GridNotifications_CancelRowEditing(object sender, DevExpress.Web.Data.ASPxStartRowEditingEventArgs e)
        {
            if (l_item_file_check.Text == "1")
            {
                int pos = l_item_file.Text.LastIndexOf("/");
                string fileToDelete = l_item_file.Text.Substring(pos + 1);
                string[] fileList = Directory.GetFiles(Server.MapPath("\\assets\\uploads\\notifications"), fileToDelete);
                foreach (string file in fileList)
                {
                    File.Delete(file);
                }
                l_item_file_check.Text = "0";
            }
        }

        protected void GridNotifications_RowUpdated(object sender, DevExpress.Web.Data.ASPxDataUpdatedEventArgs e)
        {
            if (l_item_file_check.Text == "1")
            {
                int pos = l_item_file_old.Text.LastIndexOf("/");
                string fileToDelete = l_item_file_old.Text.Substring(pos + 1);
                string[] fileList = Directory.GetFiles(Server.MapPath("\\assets\\uploads\\notifications"), fileToDelete);
                foreach (string file in fileList)
                {
                    File.Delete(file);
                }
                l_item_file_check.Text = "0";
            }
        }

        protected void GridNotifications_RowDeleting(object sender, DevExpress.Web.Data.ASPxDataDeletingEventArgs e)
        {
            if (e.Values["image"] != null)
            {
                string fileToDelete = e.Values["image"].ToString();
                int pos = fileToDelete.LastIndexOf("/");
                fileToDelete = fileToDelete.Substring(pos + 1);
                string[] fileList = Directory.GetFiles(Server.MapPath("\\assets\\uploads\\notifications"), fileToDelete);
                foreach (string file in fileList)
                {
                    File.Delete(file);
                }
            }
        }

        protected void notificationList_Callback(object sender, CallbackEventArgsBase e)
        {
            notificationList.DataBind();
        }

        protected void companies_Callback(object sender, CallbackEventArgsBase e)
        {
            DB_Companies.SelectParameters["countryID"].DefaultValue = e.Parameter;
            companies.DataBind();
            companiesProducts.DataBind();
        }

        protected void products_Callback(object sender, CallbackEventArgsBase e)
        {
            DB_Products.SelectParameters["companyID"].DefaultValue = e.Parameter;
            products.DataBind();
        }

        protected void GridUsersApp_CustomCallback(object sender, ASPxGridViewCustomCallbackEventArgs e)
        {
            if (e.Parameters == "filterCountry")
                GridUsersApp.DataBind();
            else
            {
                List<string> fieldNames = new List<string>();
                fieldNames.Add("FCMToken");
                List<Object> selectedValues = GridUsersApp.GetSelectedFieldValues(fieldNames.ToArray());

                if (selectedValues.Count > 0 || checkAll.Checked)
                {
                    // 0=update, 1=points, 2=order, 3=order history, 4=offers, 5=product
                    string usersGroup = string.Empty;
                    string actionType = string.Empty;
                    string title = string.Empty;
                    string body = string.Empty;
                    string imagePath = string.Empty;
                    string orderId = string.Empty;
                    string companyId = string.Empty;
                    string productId = string.Empty;

                    System.Configuration.AppSettingsReader settingsReader = new AppSettingsReader();
                    string URL = (string)settingsReader.GetValue("SourceURL", typeof(String));

                    string connStr = ConfigurationManager.ConnectionStrings["ShabDB_connection"].ConnectionString;
                    using (SqlConnection conn = new SqlConnection(connStr))
                    {
                        conn.Open();
                        SqlCommand cmd = new SqlCommand("SELECT actionType, title, body, imagePath, usersGroup FROM L_Notification WHERE id = @notificationId", conn);
                        cmd.Parameters.AddWithValue("@notificationId", Convert.ToInt32(notificationList.Value));

                        SqlDataReader reader = cmd.ExecuteReader();
                        if (reader.Read())
                        {
                            if (checkAll.Checked)
                                usersGroup = reader["usersGroup"].ToString();
                            actionType = reader["actionType"].ToString();
                            title = reader["title"].ToString();
                            body = reader["body"].ToString();
                            imagePath = URL + reader["imagePath"].ToString();
                        }
                    }

                    if (Convert.ToInt32(notificationList.Value) == 3)
                        productId = products.Value.ToString();
                    else if (Convert.ToInt32(notificationList.Value) == 4)
                        companyId = companies.Value.ToString();

                    var senderObj = new FcmSender();
                    string resultFCM = string.Empty;

                    if (checkAll.Checked)
                    {
                        resultFCM = senderObj.Send(usersGroup, actionType, "", title, body, imagePath, companyId, productId);
                    }
                    else
                    {
                        foreach (object[] item in selectedValues)
                        {
                            resultFCM = senderObj.Send(usersGroup, actionType, item[0].ToString(), title, body, imagePath, companyId, productId);
                        }
                    }

                    GridUsersApp.JSProperties["cpResult"] = "100";
                }
                else
                    GridUsersApp.JSProperties["cpResult"] = "1";

                GridUsersApp.Selection.UnselectAll();
            }
        }

        protected void GridUsersApp_BeforePerformDataSelect(object sender, EventArgs e)
        {
            if (Convert.ToInt32(notificationList.Value) > 0)
            {
                System.Configuration.AppSettingsReader settingsReader = new AppSettingsReader();
                string URL = (string)settingsReader.GetValue("SourceURL", typeof(String));

                string connStr = ConfigurationManager.ConnectionStrings["ShabDB_connection"].ConnectionString;
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();
                    SqlCommand cmd = new SqlCommand("SELECT countryId FROM L_Notification WHERE id = @notificationId", conn);
                    cmd.Parameters.AddWithValue("@notificationId", Convert.ToInt32(notificationList.Value));

                    SqlDataReader reader = cmd.ExecuteReader();
                    if (reader.Read())
                    {
                        db_UsersApp.SelectParameters["countryId"].DefaultValue = reader["countryId"].ToString();
                    }
                }               
            }
        }
    }
}