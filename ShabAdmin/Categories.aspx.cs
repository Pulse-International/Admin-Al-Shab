using DevExpress.Web;
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web.UI;

namespace ShabAdmin
{
    public partial class Categories : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void GridCategories_CustomCallback(object sender, ASPxGridViewCustomCallbackEventArgs e)
        {
            var grid = (ASPxGridView)sender;

            if (!int.TryParse(e.Parameters, out int categoryID))
                return;
            bool hasProducts;
            using (var con = new SqlConnection(ConfigurationManager.ConnectionStrings["ShabDB_connection"].ConnectionString))
            using (var cmd = new SqlCommand("SELECT COUNT(*) FROM products WHERE categoryID=@id", con))
            {
                cmd.Parameters.AddWithValue("@id", categoryID);
                con.Open();
                hasProducts = (Convert.ToInt32(cmd.ExecuteScalar()) > 0);
            }

            grid.JSProperties["cpHasProducts"] = hasProducts ? 1 : 0;
            grid.JSProperties["cpGridNo"] = 2;
            grid.JSProperties["cpCategoryID"] = categoryID;
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
                string[] fileList = Directory.GetFiles(Server.MapPath("\\assets\\uploads\\categories"), fileToDelete);
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

            string UploadDirectory = "/assets/uploads/categories/";
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

        protected void GridCategories_CancelRowEditing(object sender, DevExpress.Web.Data.ASPxStartRowEditingEventArgs e)
        {
            if (l_item_file_check.Text == "1")
            {
                int pos = l_item_file.Text.LastIndexOf("/");
                string fileToDelete = l_item_file.Text.Substring(pos + 1);
                string[] fileList = Directory.GetFiles(Server.MapPath("\\assets\\uploads\\categories"), fileToDelete);
                foreach (string file in fileList)
                {
                    File.Delete(file);
                }
                l_item_file_check.Text = "0";
            }
        }

        protected void GridCategories_RowUpdated(object sender, DevExpress.Web.Data.ASPxDataUpdatedEventArgs e)
        {
            if (l_item_file_check.Text == "1")
            {
                int pos = l_item_file_old.Text.LastIndexOf("/");
                string fileToDelete = l_item_file_old.Text.Substring(pos + 1);
                string[] fileList = Directory.GetFiles(Server.MapPath("\\assets\\uploads\\categories"), fileToDelete);
                foreach (string file in fileList)
                {
                    File.Delete(file);
                }
                l_item_file_check.Text = "0";
            }
        }

        protected void GridCategories_RowDeleting(object sender, DevExpress.Web.Data.ASPxDataDeletingEventArgs e)
        {
            string fileToDelete = e.Values["image"].ToString();
            int pos = fileToDelete.LastIndexOf("/");
            fileToDelete = fileToDelete.Substring(pos + 1);
            string[] fileList = Directory.GetFiles(Server.MapPath("\\assets\\uploads\\categories"), fileToDelete);
            foreach (string file in fileList)
            {
                File.Delete(file);
            }
        }

        protected void GridCategories_HtmlRowCreated(object sender, ASPxGridViewTableRowEventArgs e)
        {
            if (e.RowType == GridViewRowType.Data)
            {
                ASPxLabel GroupName = GridCategories.FindRowCellTemplateControl(e.VisibleIndex, null, "GroupName") as ASPxLabel;
                string categoryId = GridCategories.GetRowValues(e.VisibleIndex, "id").ToString();
                GroupName.Text = string.Empty;

                DataView dv = new DataView();
                DataTable dt = new DataTable();
                DB_CategoriesSub.SelectParameters["categoryId"].DefaultValue = categoryId;
                dv = DB_CategoriesSub.Select(DataSourceSelectArguments.Empty) as DataView;
                if (dv != null && dv.Count != 0)
                {
                    dt = dv.ToTable();
                    foreach (DataRow dr in dt.Rows)
                    {
                        GroupName.Text = GroupName.Text + "<div style='border: 1px solid #e6e6e6; padding-top:0.01em;padding-left:0.3em;padding-right:0.3em;padding-bottom:0.01em; font-size:1.3em'>" + dr["subName"].ToString() + "</div>";
                    }
                }
            }
        }

        protected void detailGrid_BeforePerformDataSelect(object sender, EventArgs e)
        {
            Session["id"] = (sender as ASPxGridView).GetMasterRowKeyValue();
        }

        protected void GridCategories_CellEditorInitialize(object sender, ASPxGridViewEditorEventArgs e)
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

        protected void GridCategories_BeforePerformDataSelect(object sender, EventArgs e)
        {
            string username = MainHelper.M_Check(Request.Cookies["M_Username"]?.Value);
            int privilegeCountryID = 0;
            int privilegeCompanyID = 0;

            if (!string.IsNullOrEmpty(username))
            {
                string connStr = ConfigurationManager.ConnectionStrings["ShabDB_connection"].ConnectionString;
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();
                    SqlCommand cmd = new SqlCommand("SELECT privilegeCountryID,privilegeCompanyID FROM users WHERE username = @username", conn);
                    cmd.Parameters.AddWithValue("@username", username);

                    SqlDataReader reader = cmd.ExecuteReader();
                    if (reader.Read() && reader["privilegeCountryID"] != DBNull.Value)
                    {
                        privilegeCountryID = Convert.ToInt32(reader["privilegeCountryID"]);
                        privilegeCompanyID = Convert.ToInt32(reader["privilegeCompanyID"]);
                    }
                }
            }

            if (privilegeCompanyID != 1000 && privilegeCountryID != 1000)
            {
                db_Categories.SelectCommand = @"
                        SELECT [id], [name],[countryId],[companyId], [image], [itemCount], [nameEn] FROM [categories]
                        WHERE companyId = @companyID AND countryId = @countryID";

                db_Categories.SelectParameters.Clear();
                db_Categories.SelectParameters.Add("companyID", privilegeCompanyID.ToString());
                db_Categories.SelectParameters.Add("countryID", privilegeCountryID.ToString());

                DB_Companies_Selected.SelectCommand = @"
                        SELECT id,companyName FROM companies WHERE countryId = @countryID AND id = @companyId ";
                DB_Companies_Selected.SelectParameters.Clear();
                DB_Companies_Selected.SelectParameters.Add("countryID", privilegeCountryID.ToString());
                DB_Companies_Selected.SelectParameters.Add("companyID", privilegeCompanyID.ToString());


                DB_Companies.SelectParameters.Clear();
                DB_Companies.SelectCommand = @"SELECT id,companyName FROM companies WHERE countryId = @countryID AND id = @companyID";
                DB_Companies.SelectParameters.Add("countryID", privilegeCountryID.ToString());
                DB_Companies.SelectParameters.Add("companyID", privilegeCompanyID.ToString());

                DB_Countries.SelectParameters.Clear();
                DB_Countries.SelectCommand = @"SELECT * FROM countries WHERE id = @countryID";
                DB_Countries.SelectParameters.Add("countryID", privilegeCountryID.ToString());
            }
            else if (privilegeCountryID != 1000)
            {
                db_Categories.SelectCommand = @"
                        SELECT [id], [name],[countryId],[companyId], [image], [itemCount], [nameEn] FROM [categories]
                        WHERE countryId = @countryID";

                db_Categories.SelectParameters.Clear();
                db_Categories.SelectParameters.Add("countryID", privilegeCountryID.ToString());

                DB_Companies_Selected.SelectCommand = @"
                        SELECT id,companyName FROM companies WHERE countryId = @countryID";
                DB_Companies_Selected.SelectParameters.Clear();
                DB_Companies_Selected.SelectParameters.Add("countryID", privilegeCountryID.ToString());

                DB_Companies.SelectParameters.Clear();
                DB_Companies.SelectCommand = @"SELECT id,companyName FROM companies WHERE countryId = @countryID";
                DB_Companies.SelectParameters.Add("countryID", privilegeCountryID.ToString());

                DB_Countries.SelectParameters.Clear();
                DB_Countries.SelectCommand = @"SELECT * FROM countries WHERE id = @countryID";
                DB_Countries.SelectParameters.Add("countryID", privilegeCountryID.ToString());
            }
        }
    }
}