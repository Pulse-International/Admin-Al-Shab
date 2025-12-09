using DevExpress.Web;
using DevExpress.Web.Data;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ShabAdmin
{
    public partial class mPoints : Page
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
                string[] fileList = Directory.GetFiles(Server.MapPath("\\assets\\uploads\\points"), fileToDelete);
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
            string UploadDirectory = "/assets/uploads/points/";
            string Docs = Guid.NewGuid().ToString() + ".jpg";
            fileName = Docs;
            try
            {
                string filePath = Path.Combine(MapPath(UploadDirectory), Docs);
                using (System.Drawing.Image original = System.Drawing.Image.FromStream(uploadedFile.FileContent))
                {
                    MainHelper.CompressAndSaveImage(original, filePath, 500, 500, 85);
                }
            }
            catch
            {
                checkError = 1;
            }

            return UploadDirectory + fileName;
        }

        protected void GridPoints_CancelRowEditing(object sender, DevExpress.Web.Data.ASPxStartRowEditingEventArgs e)
        {
            if (l_item_file_check.Text == "1")
            {
                int pos = l_item_file.Text.LastIndexOf("/");
                string fileToDelete = l_item_file.Text.Substring(pos + 1);
                string[] fileList = Directory.GetFiles(Server.MapPath("\\assets\\uploads\\points"), fileToDelete);
                foreach (string file in fileList)
                {
                    File.Delete(file);
                }
                l_item_file_check.Text = "0";
            }
        }

        protected void GridPoints_RowUpdated(object sender, DevExpress.Web.Data.ASPxDataUpdatedEventArgs e)
        {
            if (l_item_file_check.Text == "1")
            {
                int pos = l_item_file_old.Text.LastIndexOf("/");
                string fileToDelete = l_item_file_old.Text.Substring(pos + 1);
                string[] fileList = Directory.GetFiles(Server.MapPath("\\assets\\uploads\\points"), fileToDelete);
                foreach (string file in fileList)
                {
                    File.Delete(file);
                }
                l_item_file_check.Text = "0";
            }
        }

        protected void GridPoints_RowDeleting(object sender, DevExpress.Web.Data.ASPxDataDeletingEventArgs e)
        {
            string fileToDelete = e.Values["image"].ToString();
            int pos = fileToDelete.LastIndexOf("/");
            fileToDelete = fileToDelete.Substring(pos + 1);
            string[] fileList = Directory.GetFiles(Server.MapPath("\\assets\\uploads\\points"), fileToDelete);
            foreach (string file in fileList)
            {
                File.Delete(file);
            }
        }

        protected void GridPoints_CellEditorInitialize(object sender, ASPxGridViewEditorEventArgs e)
        {
            ASPxGridView gridView = sender as ASPxGridView;
            if (gridView.IsEditing && e.Column.FieldName == "companyId")
            {
                ASPxComboBox comboCountry = e.Editor as ASPxComboBox;
                comboCountry.Callback += cmbCountry_OnCallback;
                var currentCountry = gridView.GetRowValues(e.VisibleIndex, "countryId");

                if (e.KeyValue != DBNull.Value && e.KeyValue != null && currentCountry != null && currentCountry != DBNull.Value)
                {
                    FillCityCombo(comboCountry, currentCountry.ToString());
                }
                else
                {
                    comboCountry.DataSourceID = null;
                    comboCountry.Items.Clear();
                }
            }
        }

        protected void FillCityCombo(ASPxComboBox cmb, string country)
        {
            if (string.IsNullOrEmpty(country)) return;

            cmb.DataSourceID = null;
            DB_Companies_Selected.SelectParameters["countryId"].DefaultValue = country;
            cmb.DataSource = DB_Companies_Selected;
            cmb.DataBindItems();
        }
        void cmbCountry_OnCallback(object source, CallbackEventArgsBase e)
        {
            FillCityCombo(source as ASPxComboBox, e.Parameter);
        }

        protected void GridPoints_RowValidating(object sender, DevExpress.Web.Data.ASPxDataValidationEventArgs e)
        {
            int newCompanyId = Convert.ToInt32(e.NewValues["companyId"]);
            bool newIsActive = Convert.ToBoolean(e.NewValues["isActive"]);
            bool isNewRow = e.IsNewRow;
            int currentId = isNewRow ? 0 : Convert.ToInt32(e.Keys["id"]);

            // لا تحقق إذا لم يتم تفعيل السجل الجديد
            if (!newIsActive) return;

            string query = "SELECT COUNT(*) FROM pointsOffers WHERE companyId = @companyId AND isActive = 1";
            if (!isNewRow)
                query += " AND id <> @id";

            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ShabDB_connection"].ConnectionString))
            using (SqlCommand cmd = new SqlCommand(query, conn))
            {
                cmd.Parameters.AddWithValue("@companyId", newCompanyId);
                if (!isNewRow)
                    cmd.Parameters.AddWithValue("@id", currentId);

                conn.Open();
                int count = Convert.ToInt32(cmd.ExecuteScalar());
                conn.Close();

                if (count > 0)
                {
                    // نرسل رسالة للجانب العميل لإظهار البوب أب
                    GridPoints.JSProperties["cpShowActivePopup"] = true;
                    e.RowError = "يوجد عرض نقاط لنفس الشركة , الرجاء الغاء تفعيل عرض النقاط لاكمال العملية.";
                }
            }
        }

        protected void GridPoints_CustomCallback(object sender, ASPxGridViewCustomCallbackEventArgs e)
        {
            string[] parts = e.Parameters.Split('|');

            if (parts.Length < 3) return; // حماية من undefined

            string command = parts[0];
            int pointId = Convert.ToInt32(parts[1]);
            int visibleIndex = Convert.ToInt32(parts[2]);

            if (command == "CheckOrders")
            {
                string exists = "0";

                using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ShabDB_connection"].ConnectionString))
                using (SqlCommand cmd = new SqlCommand("SELECT COUNT(*) FROM orders WHERE pointId=@pointId", conn))
                {
                    cmd.Parameters.AddWithValue("@pointId", pointId);
                    conn.Open();
                    int count = Convert.ToInt32(cmd.ExecuteScalar());
                    if (count > 0)
                    {
                        exists = "1";
                    }
                    else { exists = "2"; }
                }

                ASPxGridView grid = sender as ASPxGridView;
                grid.JSProperties["cpOrdersExist"] = exists;
                grid.JSProperties["cpPointId"] = pointId;
                grid.JSProperties["cpRowIndex"] = visibleIndex;
            }
        }
    }
}