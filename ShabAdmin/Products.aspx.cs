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
using DevExpress.Web;
using DevExpress.Web.Data;
using Microsoft.Ajax.Utilities;

namespace ShabAdmin
{
    public partial class Products : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        protected void Page_Init(object sender, EventArgs e)
        {
            string username = MainHelper.M_Check(Request.Cookies["M_Username"]?.Value);
            int privilegeCountryID = 0;
            int privilegeCompanyID = 0;

            if (!IsPostBack)
            {
                if (string.Equals(username, "admin", StringComparison.OrdinalIgnoreCase))
                {
                    GridProducts.Columns["priceInternational"].Visible = true;
                }
                else
                {
                    GridProducts.Columns["priceInternational"].Visible = false;
                }
            }

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
            if (!IsPostBack)
            {
                if (privilegeCountryID == 1000 && privilegeCompanyID == 1000)
                {
                    GridProducts.Columns["priceInternational"].Visible = true;
                }
                else
                {
                    GridProducts.Columns["priceInternational"].Visible = false;
                }
            }

            if (privilegeCountryID != 1000 && privilegeCompanyID != 1000)
            {
                db_Products.SelectCommand = @"
                 SELECT 
                     p.[id], 
                     p.[name], 
                     p.[description],
                     (select pi.imagePath from productsImages pi where p.id = pi.productId and pi.isDefault = 1) as Image,
                     p.[categoryID], 
                     cs.[subName],   
                     p.[subCategoryId], 
                     p.[price], 
                     p.[priceInternational], 
                     p.[isVisible], 
                     p.[isProductPrice], 
                     p.[isWeight], 
                     p.[barcode], 
                     p.[nameEn], 
                     p.[countryID], 
                     p.[companyID], 
                     c.[companyName],       
                     p.[isHasFlavors],
                     p.[isSpecial]
                 FROM [products] p
                 LEFT JOIN [companies] c ON p.companyID = c.id
                 LEFT JOIN [categoriesSub] cs ON p.subCategoryId = cs.id  
                 Where p.isvirtual = 0 AND p.companyID = @companyID AND p.countryID = @countryID
                 ORDER BY p.id ASC";

                db_Products.SelectParameters.Clear();
                db_Products.SelectParameters.Add("companyID", privilegeCompanyID.ToString());
                db_Products.SelectParameters.Add("countryID", privilegeCountryID.ToString());

                dsCountries.SelectCommand = @"SELECT id, countryName FROM countries where id = @countryID";
                dsCountries.SelectParameters.Clear();
                dsCountries.SelectParameters.Add("countryID", privilegeCountryID.ToString());

                db_Company.SelectCommand = @"SELECT p.id, p.companyName + ' <br> (' + (select c.countryName from countries c where c.id = p.countryId) + ')' as companyName FROM companies p where countryId=@countryID AND Id=@companyID";
                db_Company.SelectParameters.Clear();
                db_Company.SelectParameters.Add("countryID", privilegeCountryID.ToString());
                db_Company.SelectParameters.Add("companyID", privilegeCompanyID.ToString());

                db_Categories.SelectCommand = @"SELECT id, name FROM categories where countryId=@countryID AND companyId=@companyID";
                db_Categories.SelectParameters.Clear();
                db_Categories.SelectParameters.Add("countryID", privilegeCountryID.ToString());
                db_Categories.SelectParameters.Add("companyID", privilegeCompanyID.ToString());

            }
            else if (privilegeCountryID != 1000)
            {
                db_Products.SelectCommand = @"
                                SELECT 
                                    p.[id], 
                                    p.[name], 
                                    p.[description],
                                    (select pi.imagePath from productsImages pi where p.id = pi.productId and pi.isDefault = 1) as Image,
                                    p.[categoryID], 
                                    p.[subCategoryId], 
                                    cs.[subName],   
                                    p.[price], 
                                    p.[priceInternational],
                                    p.[isVisible], 
                                    p.[isProductPrice], 
                                    p.[isWeight], 
                                    p.[barcode], 
                                    p.[nameEn], 
                                    p.[countryID], 
                                    p.[companyID], 
                                    c.[companyName],       
                                    p.[isHasFlavors],
                                    p.[isSpecial]
                                FROM [products] p
                                LEFT JOIN [companies] c ON p.companyID = c.id
                                LEFT JOIN [categoriesSub] cs ON p.subCategoryId = cs.id  
                                Where p.isvirtual = 0 AND p.countryID = @countryID 
                                ORDER BY p.id ASC";

                db_Products.SelectParameters.Clear();
                db_Products.SelectParameters.Add("countryID", privilegeCountryID.ToString());

                dsCountries.SelectCommand = @"SELECT id, countryName FROM countries where id = @countryID";
                dsCountries.SelectParameters.Clear();
                dsCountries.SelectParameters.Add("countryID", privilegeCountryID.ToString());

                db_Company.SelectCommand = @"SELECT p.id, p.companyName + ' <br> (' + (select c.countryName from countries c where c.id = p.countryId) + ')' as companyName FROM companies p where countryId=@countryID";
                db_Company.SelectParameters.Clear();
                db_Company.SelectParameters.Add("countryID", privilegeCountryID.ToString());

                db_Categories.SelectCommand = @"SELECT id, name FROM categories where countryId=@countryID";
                db_Categories.SelectParameters.Clear();
                db_Categories.SelectParameters.Add("countryID", privilegeCountryID.ToString());
            }
        }

        protected void GridProducts_RowValidating(object sender, ASPxDataValidationEventArgs e)
        {
            List<string> missingFields = new List<string>();

            // --- Find Company ---
            ASPxCallbackPanel panel = GridProducts.FindEditRowCellTemplateControl(
                (GridViewDataColumn)GridProducts.Columns["companyID"],
                "callback_LoadCompanies"
            ) as ASPxCallbackPanel;

            ASPxComboBox comboCompany = panel?.FindControl("comboCompany") as ASPxComboBox;
            bool isCompanyMissing = (comboCompany == null || comboCompany.Value == null);
            if (isCompanyMissing)
            {
                missingFields.Add("الشركة");
            }

            // --- Find Branches ---
            string selectedBranches = SelectedBranchIds.Text;
            List<int> branchIDs = selectedBranches
                .Split(new[] { ',' }, StringSplitOptions.RemoveEmptyEntries)
                .Select(id => int.TryParse(id, out int result) ? result : (int?)null)
                .Where(id => id.HasValue)
                .Select(id => id.Value)
                .ToList();
            bool isBranchMissing = (branchIDs.Count == 0);
            if (isBranchMissing)
            {
                missingFields.Add("الفرع");
            }

            // --- Product Name Validation ---
            ASPxCheckBox chkUseText = GridProducts.FindEditRowCellTemplateControl(
                (GridViewDataColumn)GridProducts.Columns["name"], "chkUseText"
            ) as ASPxCheckBox;

            ASPxComboBox comboName = GridProducts.FindEditRowCellTemplateControl(
                (GridViewDataColumn)GridProducts.Columns["name"], "comboName"
            ) as ASPxComboBox;

            ASPxTextBox txtName = GridProducts.FindEditRowCellTemplateControl(
                (GridViewDataColumn)GridProducts.Columns["name"], "txtName"
            ) as ASPxTextBox;

            bool isManualNameChecked = chkUseText != null && chkUseText.Checked;
            bool isProductNameMissing = false;

            if (isManualNameChecked)
            {
                isProductNameMissing = (txtName == null || string.IsNullOrWhiteSpace(txtName.Text));
            }
            else
            {
                isProductNameMissing = (comboName == null || comboName.Value == null);
            }

            if (isProductNameMissing)
            {
                missingFields.Add("اسم المنتج");
            }

            // --- Final Validation Message ---
            if (missingFields.Count > 0)
            {
                string fieldsText = string.Join(" و", missingFields);
                string message = $"الرجاء إدخال {fieldsText}";

                e.RowError = message;

                string js = $@"
            if (typeof lblPopupMessage !== 'undefined') lblPopupMessage.SetText('{message.Replace("'", "\\'")}');
            if (typeof popupValidationError !== 'undefined') popupValidationError.Show();";

                ScriptManager.RegisterStartupScript(this, this.GetType(), "popupError", js, true);
            }
        }


        protected void callback_LoadSubCategory_Callback(object sender, CallbackEventArgsBase e)
        {

            // Parameter format: "countryID|companyID"

            int category = Convert.ToInt32(e.Parameter);



        }

        protected void callback_LoadCompanies_Callback(object sender, CallbackEventArgsBase e)
        {

            // Parameter format: "countryID|companyID"
            string[] parameters = e.Parameter.Split('|');
            if (parameters.Length < 1) return;

            int countryId = Convert.ToInt32(parameters[0]);
            int companyId = Convert.ToInt32(string.IsNullOrEmpty(parameters[1]) ? "0" : parameters[1]);

            if (countryId != 0)
            {
                ASPxCallbackPanel callbackPanel = sender as ASPxCallbackPanel;
                if (callbackPanel == null)
                    return;

                var combo = callbackPanel.FindControl("comboCompany") as ASPxComboBox;
                if (combo == null)
                    return;

                string username = MainHelper.M_Check(Request.Cookies["M_Username"]?.Value);
                int privilegeCompanyID = 0;

                if (!string.IsNullOrEmpty(username))
                {
                    string connStr = ConfigurationManager.ConnectionStrings["ShabDB_connection"].ConnectionString;
                    using (SqlConnection conn = new SqlConnection(connStr))
                    {
                        conn.Open();
                        SqlCommand cmd = new SqlCommand("SELECT privilegeCompanyID FROM users WHERE username = @username", conn);
                        cmd.Parameters.AddWithValue("@username", username);

                        SqlDataReader reader = cmd.ExecuteReader();
                        if (reader.Read() && reader["privilegeCompanyID"] != DBNull.Value)
                        {
                            privilegeCompanyID = Convert.ToInt32(reader["privilegeCompanyID"]);
                        }
                    }
                }

                if (privilegeCompanyID != 1000)
                {
                    using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ShabDB_connection"].ConnectionString))
                    using (SqlCommand cmd = new SqlCommand("SELECT id, companyName FROM companies WHERE countryID = @countryID AND id=@companyID", conn))
                    {
                        cmd.Parameters.AddWithValue("@companyID", privilegeCompanyID);
                        cmd.Parameters.AddWithValue("@countryID", countryId);
                        conn.Open();
                        SqlDataReader reader = cmd.ExecuteReader();

                        combo.DataSource = reader;
                        combo.ValueField = "id";
                        combo.TextField = "companyName";
                        combo.DataBindItems();
                        reader.Close();
                        conn.Close();
                    }



                }
                else
                {
                    using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ShabDB_connection"].ConnectionString))
                    using (SqlCommand cmd = new SqlCommand("SELECT id, companyName FROM companies WHERE countryID = @countryID", conn))
                    {
                        cmd.Parameters.AddWithValue("@countryID", countryId);
                        conn.Open();
                        SqlDataReader reader = cmd.ExecuteReader();

                        combo.DataSource = reader;
                        combo.ValueField = "id";
                        combo.TextField = "companyName";
                        combo.DataBindItems();
                        reader.Close();
                        conn.Close();
                    }
                }

                if (!GridProducts.IsNewRowEditing && l_GridUpdating.Text == "1")
                {
                    // Select the company in edit mode
                    if (companyId > 0)
                    {
                        combo.Value = companyId;
                    }
                }
                else
                    combo.SelectedIndex = -1;
            }
        }


        int newID;
        protected void listBoxBranches_Callback(object sender, CallbackEventArgsBase e)
        {

            string[] parameters = e.Parameter.Split('|');

            int productId = 0;
            int countryId = 0;
            int companyId = 0;

            if (!GridProducts.IsNewRowEditing)
                productId = Convert.ToInt32(parameters[0]);
            else
                productId = 0;

            int.TryParse(parameters[1], out countryId);
            int.TryParse(parameters[2], out companyId);

            string branchQuery = @"
                    SELECT id AS branchID, name AS groupName 
                    FROM branches 
                    WHERE countryID = @countryID AND companyID = @companyID";

            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ShabDB_connection"].ConnectionString))
            using (SqlCommand cmd = new SqlCommand(branchQuery, conn))
            {
                cmd.Parameters.AddWithValue("@countryID", countryId);
                cmd.Parameters.AddWithValue("@companyID", companyId);

                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();

                ASPxListBox listBox = sender as ASPxListBox;
                listBox.DataSource = reader;
                listBox.DataBind();
                reader.Close();


                if (parameters[0] != "undefined")
                    // Select existing product branch IDs (only in edit mode)
                    if (productId > 0)
                    {
                        SqlCommand selectCmd = new SqlCommand("SELECT branchID FROM branchproducts WHERE productID = @productID", conn);
                        selectCmd.Parameters.AddWithValue("@productID", productId);
                        SqlDataReader branchReader = selectCmd.ExecuteReader();

                        List<string> selected = new List<string>();
                        while (branchReader.Read())
                        {
                            selected.Add(branchReader["branchID"].ToString());
                        }

                        foreach (string val in selected)
                        {
                            ListEditItem item = listBox.Items.FindByValue(val);
                            if (item != null)
                                item.Selected = true;
                        }

                        branchReader.Close();
                    }
            }
        }





        string SavePostedFile_all(UploadedFile uploadedFile)
        {
            if (!uploadedFile.IsValid)
                return string.Empty;
            string UploadDirectory = "/assets/uploads/";
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

        protected void GridProducts_CancelRowEditing(object sender, DevExpress.Web.Data.ASPxStartRowEditingEventArgs e)
        {


            var images = GetSessionImages();
            foreach (var path in images)
            {
                var file = Path.GetFileName(path);
                var full = Server.MapPath("~/assets/uploads/" + file);
                if (File.Exists(full))
                    File.Delete(full);
            }

            ClearSessionImages();

            l_DefaultImage.Text = String.Empty;

        }
        protected void GridProducts_RowUpdating(object sender, ASPxDataUpdatingEventArgs e)
        {
            int companyId;
            if (int.TryParse(l_CompanyID.Text, out companyId))
            {
                e.NewValues["companyID"] = companyId;
            }
            else
            {
                e.NewValues["companyID"] = DBNull.Value;
            }

            // 🔹 التحقق من تغيّر السعر
            if (e.NewValues["price"] != null && e.OldValues["price"] != null)
            {
                decimal newPrice = Convert.ToDecimal(e.NewValues["price"]);
                decimal oldPrice = Convert.ToDecimal(e.OldValues["price"]);

                if (newPrice != oldPrice)
                {
                    // 🔻 تصفير العرض داخل القيم الجديدة
                    e.NewValues["offerPrice"] = 0;
                    e.NewValues["offerPercent"] = 0;

                    // 🔹 تنفيذ تحديث مباشر في قاعدة البيانات
                    int productId = Convert.ToInt32(e.Keys["id"]); // تأكد أن الـ KeyFieldName = "id" في الـ Grid

                    string connectionString = ConfigurationManager.ConnectionStrings["ShabDB_connection"].ConnectionString;

                    using (SqlConnection conn = new SqlConnection(connectionString))
                    {
                        conn.Open();
                        string query = @"
                    UPDATE products
                    SET offerPrice = 0,
                        offerPercent = 0
                    WHERE id = @productId";

                        using (SqlCommand cmd = new SqlCommand(query, conn))
                        {
                            cmd.Parameters.AddWithValue("@productId", productId);
                            cmd.ExecuteNonQuery();
                        }
                    }
                }
            }
        }

        protected void GridProducts_RowUpdated(object sender, DevExpress.Web.Data.ASPxDataUpdatedEventArgs e)
        {

            int productId = Convert.ToInt32(e.Keys["id"]);
            int countryid = Convert.ToInt32(e.NewValues["countryID"]);
            int companyid = Convert.ToInt32(e.NewValues["companyID"]);

            bool isProductPrice = Convert.ToBoolean(e.NewValues["isProductPrice"]);
            bool wasProductPrice = Convert.ToBoolean(e.OldValues["isProductPrice"]);

            string selectedBranches = SelectedBranchIds.Text;
            if (!string.IsNullOrWhiteSpace(selectedBranches))
            {
                List<int> branchIDs = selectedBranches
                    .Split(new[] { ',' }, StringSplitOptions.RemoveEmptyEntries)
                    .Select(id => int.TryParse(id, out int result) ? result : (int?)null)
                    .Where(id => id.HasValue)
                    .Select(id => id.Value)
                    .ToList();

                UpdateBranchesForProduct(productId, countryid, companyid, branchIDs);
            }

            var newImages = GetSessionImages();
            if (newImages != null && newImages.Count > 0)
            {
                string connStr = ConfigurationManager.ConnectionStrings["ShabDB_connection"].ConnectionString;
                using (var conn = new SqlConnection(connStr))
                {
                    conn.Open();

                    // Step 1: Check if there's already a default image
                    bool hasDefault = false;
                    using (var checkCmd = new SqlCommand("SELECT COUNT(*) FROM productsimages WHERE productId = @pid AND isDefault = 1", conn))
                    {
                        checkCmd.Parameters.AddWithValue("@pid", productId);
                        int count = (int)checkCmd.ExecuteScalar();
                        hasDefault = count > 0;
                    }

                    // Step 2: Insert images and set default if needed
                    for (int i = 0; i < newImages.Count; i++)
                    {
                        var imgPath = newImages[i];
                        bool isDefault = (!hasDefault && i == 0); // Set first image as default if none exist

                        using (var cmd = new SqlCommand(@"
                INSERT INTO productsimages (productId, imagePath, isDefault)
                VALUES (@pid, @path, @isDefault)", conn))
                        {
                            cmd.Parameters.AddWithValue("@pid", productId);
                            cmd.Parameters.AddWithValue("@path", imgPath);
                            cmd.Parameters.AddWithValue("@isDefault", isDefault ? 1 : 0);
                            cmd.ExecuteNonQuery();
                        }
                    }
                }
            }

            ClearSessionImages();

            string defaultImagePath = l_DefaultImage.Text;

            if (!string.IsNullOrWhiteSpace(defaultImagePath))
            {
                string connStr = ConfigurationManager
                    .ConnectionStrings["ShabDB_connection"].ConnectionString;

                using (var conn = new SqlConnection(connStr))
                {
                    conn.Open();
                    using (var reset = new SqlCommand("UPDATE productsimages SET isDefault = 0 WHERE productId = @pid", conn))
                    {
                        reset.Parameters.AddWithValue("@pid", productId);
                        reset.ExecuteNonQuery();
                    }
                    using (var setDef = new SqlCommand(
                        "UPDATE productsimages SET isDefault = 1 WHERE productId = @pid AND imagePath = @path", conn))
                    {
                        setDef.Parameters.AddWithValue("@pid", productId);
                        setDef.Parameters.AddWithValue("@path", defaultImagePath);
                        setDef.ExecuteNonQuery();
                    }
                }

                l_DefaultImage.Text = String.Empty;
            }

            // إذا تغير من True إلى False
            if (wasProductPrice && !isProductPrice)
            {
                string connStr = ConfigurationManager.ConnectionStrings["ShabDB_connection"].ConnectionString;
                using (var conn = new SqlConnection(connStr))
                {
                    conn.Open();

                    // 1) جلب كل الـ virtual products لهذا الـ parentId
                    List<int> virtualProductIds = new List<int>();
                    string getVirtualProductsQuery = "SELECT id FROM products WHERE parentId = @parentId";
                    using (var cmdGet = new SqlCommand(getVirtualProductsQuery, conn))
                    {
                        cmdGet.Parameters.AddWithValue("@parentId", productId);
                        using (var reader = cmdGet.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                virtualProductIds.Add(Convert.ToInt32(reader["id"]));
                            }
                        }
                    }

                    // ⚠️ لا نحذف الصور إطلاقاً

                    // 2) تحديث حالة الـ virtual products بدل حذفها
                    if (virtualProductIds.Count > 0)
                    {
                        string markAsDeletedQuery = "UPDATE products SET isVirtualDeleted = 1 WHERE parentId = @parentId";
                        using (var cmdMarkDeleted = new SqlCommand(markAsDeletedQuery, conn))
                        {
                            cmdMarkDeleted.Parameters.AddWithValue("@parentId", productId);
                            cmdMarkDeleted.ExecuteNonQuery();
                        }
                    }

                    // 3) تصفير الـ offerPrice و offerPercent لكل الخيارات المرتبطة
                    string updateOptionsQuery = @"
            UPDATE ProductsOptions 
            SET offerPrice = 0, offerPercent = 0 
            WHERE productId = @parentId";
                    using (var cmdUpdateOptions = new SqlCommand(updateOptionsQuery, conn))
                    {
                        cmdUpdateOptions.Parameters.AddWithValue("@parentId", productId);
                        cmdUpdateOptions.ExecuteNonQuery();
                    }
                }
            }
        }
        private void UpdateBranchesForProduct(int productID, int countryID, int companyID, List<int> branchIDs)
        {
            using (SqlConnection conn = new SqlConnection(
                       ConfigurationManager.ConnectionStrings["ShabDB_connection"].ConnectionString))
            {
                conn.Open();

                using (SqlCommand deleteCmd = new SqlCommand(
                           "DELETE FROM branchproducts WHERE productid = @productid", conn))
                {
                    deleteCmd.Parameters.AddWithValue("@productid", productID);
                    deleteCmd.ExecuteNonQuery();
                }

                foreach (int branchID in branchIDs)
                {
                    using (SqlCommand insertCmd = new SqlCommand(
                               "INSERT INTO branchproducts (productid, branchid,companyID ,countryid ) VALUES (@productid, @branchid,@companyID,  @countryid)", conn))
                    {
                        insertCmd.Parameters.AddWithValue("@productid", productID);
                        insertCmd.Parameters.AddWithValue("@branchid", branchID);
                        insertCmd.Parameters.AddWithValue("@countryid", countryID);
                        insertCmd.Parameters.AddWithValue("@companyID", companyID);
                        insertCmd.ExecuteNonQuery();
                    }
                }
                conn.Close();
            }
        }

        protected void GridProducts_RowDeleting(object sender, DevExpress.Web.Data.ASPxDataDeletingEventArgs e)
        {
            int productId = Convert.ToInt32(e.Keys["id"]);
            string connStr = ConfigurationManager.ConnectionStrings["ShabDB_connection"].ConnectionString;

            bool isUsed = false;

            using (var conn = new SqlConnection(connStr))
            {
                conn.Open();

                // تحقق إذا كان المنتج مستخدم في carts
                string checkCartQuery = @"
            SELECT COUNT(*) 
            FROM carts 
            WHERE 
                (
                    (productId = @productId AND orderId = 0 AND isDeleted = 0)
                    OR
                    (productId = @productId AND orderId > 0)
                )";

                using (var cmdCheck = new SqlCommand(checkCartQuery, conn))
                {
                    cmdCheck.Parameters.AddWithValue("@productId", productId);
                    int count = Convert.ToInt32(cmdCheck.ExecuteScalar());
                    if (count > 0)
                        isUsed = true;
                }

                if (isUsed)
                {
                    e.Cancel = true;
                    var grid = sender as ASPxGridView;
                    grid.JSProperties["cpShowUsedPopup"] = "true";
                    return;
                }

                // حذف الصور فقط إذا لم يكن المنتج مستخدم
                var paths = new List<string>();
                using (var cmd = new SqlCommand("SELECT imagePath FROM productsimages WHERE productId = @pid", conn))
                {
                    cmd.Parameters.AddWithValue("@pid", productId);
                    using (var rdr = cmd.ExecuteReader())
                        while (rdr.Read())
                            paths.Add(rdr.GetString(0));
                }

                using (var cmdDel = new SqlCommand("DELETE FROM productsimages WHERE productId = @pid", conn))
                {
                    cmdDel.Parameters.AddWithValue("@pid", productId);
                    cmdDel.ExecuteNonQuery();
                }

                foreach (var virtualPath in paths)
                {
                    var fileName = Path.GetFileName(virtualPath);
                    var fullPath = Server.MapPath("~/assets/uploads/" + fileName);
                    if (File.Exists(fullPath))
                        File.Delete(fullPath);
                }
            }
        }



        protected void GridProducts_HtmlRowCreated(object sender, ASPxGridViewTableRowEventArgs e)
        {
            if (e.RowType == GridViewRowType.Data)
            {
                ASPxLabel BranchNames = GridProducts.FindRowCellTemplateControl(e.VisibleIndex, null, "BranchNames") as ASPxLabel;
                int id = Convert.ToInt32(GridProducts.GetRowValues(e.VisibleIndex, "id"));
                BranchNames.Text = string.Empty;
                DataView dv = new DataView();
                DataTable dt = new DataTable();
                DB_BranchNames.SelectParameters["productID"].DefaultValue = id.ToString();
                dv = DB_BranchNames.Select(DataSourceSelectArguments.Empty) as DataView;
                if (dv != null && dv.Count != 0)
                {
                    dt = dv.ToTable();
                    foreach (DataRow dr in dt.Rows)
                    {
                        BranchNames.Text += $"<div style='border: 1px solid #cacaca; margin-bottom:1px; padding-top:0.1em;padding-right:0.3em;padding-bottom:0.1em;'>{dr["BranchName"]}</div>";
                    }
                }
            }
        }

        protected void subCategoryCombo_Callback(object sender, CallbackEventArgsBase e)
        {
            ASPxComboBox subCategoryCombo = sender as ASPxComboBox;
            if (subCategoryCombo == null) return;

            int categoryId;
            if (int.TryParse(e.Parameter, out categoryId))
            {
                subCategoryCombo.Items.Clear();
                using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ShabDB_connection"].ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand("SELECT id, subName FROM categoriesSub WHERE categoryId = @categoryId", conn))
                    {
                        cmd.Parameters.AddWithValue("@categoryId", categoryId);
                        conn.Open();
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                subCategoryCombo.Items.Add(reader["subName"].ToString(), reader["id"]);
                            }
                        }
                    }
                }
            }
        }

        public string GetSubCategoryName(object subCategoryIdObj)
        {
            if (subCategoryIdObj == null || subCategoryIdObj == DBNull.Value)
                return string.Empty;

            int subCategoryId = Convert.ToInt32(subCategoryIdObj);
            string name = string.Empty;
            string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["ShabDB_connection"].ConnectionString;
            using (var conn = new System.Data.SqlClient.SqlConnection(connStr))
            using (var cmd = new System.Data.SqlClient.SqlCommand("SELECT subName FROM categoriesSub WHERE id = @id", conn))
            {
                cmd.Parameters.AddWithValue("@id", subCategoryId);
                conn.Open();
                var result = cmd.ExecuteScalar();
                if (result != null && result != DBNull.Value)
                    name = result.ToString();
            }
            return name;
        }
        protected void comboName_Init(object sender, EventArgs e)
        {
            var combo = sender as ASPxComboBox;
            var container = combo.NamingContainer as GridViewEditItemTemplateContainer;
            if (!container.Grid.IsNewRowEditing)
                combo.ClientVisible = false;
        }

        protected void txtName_Init(object sender, EventArgs e)
        {
            var txt = sender as ASPxTextBox;
            var container = txt.NamingContainer as GridViewEditItemTemplateContainer;
            txt.ClientVisible = !container.Grid.IsNewRowEditing; // true in edit mode
        }

        protected void chkUseText_Init(object sender, EventArgs e)
        {
            var chk = sender as ASPxCheckBox;
            var container = chk.NamingContainer as GridViewEditItemTemplateContainer;
            chk.ClientVisible = container.Grid.IsNewRowEditing;
        }



        protected void GridProducts_RowInserting(object sender, ASPxDataInsertingEventArgs e)
        {
            int companyId;
            if (int.TryParse(l_CompanyID.Text, out companyId))
            {
                e.NewValues["companyID"] = companyId;
            }
            else
            {
                e.NewValues["companyID"] = DBNull.Value;
            }
        }

        protected void GridProducts_RowInserted(object sender, ASPxDataInsertedEventArgs e)
        {
            try
            {
                int productId = newID;
                int countryId = Convert.ToInt32(e.NewValues["countryID"]);
                int companyid = Convert.ToInt32(e.NewValues["companyID"]);

                string selectedBranches = SelectedBranchIds.Text;

                if (!string.IsNullOrEmpty(selectedBranches))
                {
                    string[] branchIds = selectedBranches.Split(new[] { ',' }, StringSplitOptions.RemoveEmptyEntries);

                    foreach (string branchIdStr in branchIds)
                    {
                        if (int.TryParse(branchIdStr, out int branchId))
                        {
                            InsertBranchForRecord(productId, branchId, companyid, countryId);
                        }
                    }
                }

                string connStr = ConfigurationManager.ConnectionStrings["ShabDB_connection"].ConnectionString;

                using (SqlConnection conn = new SqlConnection(connStr))
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.Parameters.AddWithValue("@productId", productId);

                    if (chkUseTextState.Text == "1")
                    {
                        cmd.CommandText = @"
                    UPDATE products 
                    SET uid = CAST(id AS NVARCHAR(500)) + 
                              CAST((CONVERT(NUMERIC(12, 0), RAND() * 899999999999) + 100000000000) AS NVARCHAR(100))
                    WHERE id = @productId";
                    }
                    else
                    {
                        ASPxComboBox comboName = GridProducts.FindEditRowCellTemplateControl(((GridViewDataColumn)GridProducts.Columns[2]), "comboName") as ASPxComboBox;

                        cmd.CommandText = "UPDATE products SET uid = @uid , name=@name WHERE id = @productId";
                        cmd.Parameters.AddWithValue("@uid", comboName.Value.ToString());
                        cmd.Parameters.AddWithValue("@name", comboName.Text.ToString());
                    }

                    conn.Open();
                    cmd.ExecuteNonQuery();
                }

                var images = GetSessionImages();
                if (images != null && images.Count > 0)
                {
                    using (var imgConn = new SqlConnection(connStr))
                    {
                        imgConn.Open();

                        bool first = true;
                        foreach (var imgPath in images)
                        {
                            using (var imgCmd = new SqlCommand(
                                @"INSERT INTO productsimages 
                                    (productId, imagePath, isDefault) 
                                VALUES 
                                    (@productId, @path, @isDefault)",
                                imgConn))
                            {
                                imgCmd.Parameters.AddWithValue("@productId", productId);
                                imgCmd.Parameters.AddWithValue("@path", imgPath);
                                imgCmd.Parameters.AddWithValue("@isDefault", first ? 1 : 0);
                                imgCmd.ExecuteNonQuery();
                            }
                            first = false;
                        }
                    }
                    ClearSessionImages();
                }
                string defaultImagePath = l_DefaultImage.Text;

                if (!string.IsNullOrWhiteSpace(defaultImagePath))
                {
                    string connString = ConfigurationManager
                        .ConnectionStrings["ShabDB_connection"].ConnectionString;

                    using (var conn = new SqlConnection(connString))
                    {
                        conn.Open();
                        using (var reset = new SqlCommand("UPDATE productsimages SET isDefault = 0 WHERE productId = @pid", conn))
                        {
                            reset.Parameters.AddWithValue("@pid", productId);
                            reset.ExecuteNonQuery();
                        }
                        using (var setDef = new SqlCommand(
                            "UPDATE productsimages SET isDefault = 1 WHERE productId = @pid AND imagePath = @path", conn))
                        {
                            setDef.Parameters.AddWithValue("@pid", productId);
                            setDef.Parameters.AddWithValue("@path", defaultImagePath);
                            setDef.ExecuteNonQuery();
                        }
                    }

                    l_DefaultImage.Text = String.Empty;
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error in RowInserted: " + ex.Message);
            }


        }

        private void InsertBranchForRecord(int productID, object branchID, int companyID, int countryID)
        {
            using (SqlConnection conn = new SqlConnection(
                       ConfigurationManager.ConnectionStrings["ShabDB_connection"].ConnectionString))
            {
                conn.Open();
                using (SqlCommand cmd = new SqlCommand(
                           @"INSERT INTO branchproducts (productid, branchid, countryid, companyID)
                     VALUES (@productid, @branchid, @countryid, @companyID)", conn))
                {
                    cmd.Parameters.AddWithValue("@productid", productID);
                    cmd.Parameters.AddWithValue("@branchid", branchID);
                    cmd.Parameters.AddWithValue("@countryid", countryID);
                    cmd.Parameters.AddWithValue("@companyID", companyID);
                    cmd.ExecuteNonQuery();
                }
                conn.Close();
            }
        }

        protected void db_Products_Inserted(object sender, SqlDataSourceStatusEventArgs e)
        {
            newID = Convert.ToInt32(e.Command.Parameters["@newID"].Value);
        }

        protected void hasOffer_Init(object sender, EventArgs e)
        {
            ASPxCheckBox cb = sender as ASPxCheckBox;
            GridViewDataItemTemplateContainer container = cb.NamingContainer as GridViewDataItemTemplateContainer;
            cb.JSProperties["cp_index"] = container.VisibleIndex;
        }

        private const string SESSION_KEY = "MultiUploadImages";

        List<string> GetSessionImages()
        {
            return Session[SESSION_KEY] as List<string> ?? new List<string>();
        }

        void AddSessionImage(string path)
        {
            var list = GetSessionImages();
            list.Add(path);
            Session[SESSION_KEY] = list;
        }

        void ClearSessionImages()
        {
            Session.Remove(SESSION_KEY);
        }

        protected void MultiImageUpload_FileUploadComplete(object sender, FileUploadCompleteEventArgs e)
        {
            var virtualPath = SavePostedFile_all(e.UploadedFile);
            e.CallbackData = virtualPath;

            AddSessionImage(virtualPath);
        }
        protected List<object> GetImagesForProduct(object id)
        {
            var list = new List<object>();
            string connStr = ConfigurationManager.ConnectionStrings["ShabDB_connection"].ConnectionString;
            using (var conn = new SqlConnection(connStr))
            using (var cmd = new SqlCommand(
                "SELECT imagePath AS ImagePath FROM productsimages WHERE productId = @pid", conn))
            {
                cmd.Parameters.AddWithValue("@pid", Convert.ToInt32(id));
                conn.Open();
                using (var rdr = cmd.ExecuteReader())
                    while (rdr.Read())
                        list.Add(new { ImagePath = rdr.GetString(0) });
            }

            int maxImages = 5;
            int allowed = Math.Max(0, maxImages - list.Count);

            return list;
        }

        protected void callbackRemoveImage_Callback(object sender, CallbackEventArgsBase e)
        {
            var parts = e.Parameter.Split('|');
            var imagePath = parts[0];
            var productId = int.Parse(parts[1]);

            string cs = ConfigurationManager
                          .ConnectionStrings["ShabDB_connection"]
                          .ConnectionString;

            string newDefaultUrl = null;

            using (var conn = new SqlConnection(cs))
            {
                conn.Open();

                using (var deleteCmd = new SqlCommand(
                    "DELETE FROM productsimages WHERE productId=@pid AND imagePath=@path", conn))
                {
                    deleteCmd.Parameters.AddWithValue("@pid", productId);
                    deleteCmd.Parameters.AddWithValue("@path", imagePath);
                    deleteCmd.ExecuteNonQuery();
                }

                using (var defCmd = new SqlCommand(
                    "SELECT TOP 1 imagePath FROM productsimages WHERE productId=@pid AND isDefault=1", conn))
                {
                    defCmd.Parameters.AddWithValue("@pid", productId);
                    newDefaultUrl = defCmd.ExecuteScalar() as string;
                }

                if (string.IsNullOrEmpty(newDefaultUrl))
                {
                    string firstImage = null;
                    using (var firstCmd = new SqlCommand(
                        "SELECT TOP 1 imagePath FROM productsimages WHERE productId=@pid ORDER BY id", conn))
                    {
                        firstCmd.Parameters.AddWithValue("@pid", productId);
                        firstImage = firstCmd.ExecuteScalar() as string;
                    }

                    if (!string.IsNullOrEmpty(firstImage))
                    {
                        // reset any defaults
                        using (var resetCmd = new SqlCommand(
                            "UPDATE productsimages SET isDefault=0 WHERE productId=@pid", conn))
                        {
                            resetCmd.Parameters.AddWithValue("@pid", productId);
                            resetCmd.ExecuteNonQuery();
                        }
                        // set the first image as default
                        using (var setCmd = new SqlCommand(
                            "UPDATE productsimages SET isDefault=1 WHERE productId=@pid AND imagePath=@path", conn))
                        {
                            setCmd.Parameters.AddWithValue("@pid", productId);
                            setCmd.Parameters.AddWithValue("@path", firstImage);
                            setCmd.ExecuteNonQuery();
                        }

                        newDefaultUrl = firstImage;
                    }
                }

                // 4) If still nothing, use your “nofile” placeholder
                if (string.IsNullOrEmpty(newDefaultUrl))
                {
                    // adjust the path & extension to match your actual placeholder
                    newDefaultUrl = ResolveUrl("~/assets/uploads/noFile.png");
                }
            }

            var list = GetSessionImages();
            if (list.Remove(imagePath))
                Session[SESSION_KEY] = list;

            var fileName = Path.GetFileName(imagePath);
            var fullPath = Server.MapPath("~/assets/uploads/" + fileName);
            if (File.Exists(fullPath))
                File.Delete(fullPath);

            var cb = (ASPxCallback)sender;
            cb.JSProperties["cp_deletedUrl"] = imagePath;
            cb.JSProperties["cp_newDefault"] = newDefaultUrl;
        }

        protected string GetFirstImagePath(object productIdObj)
        {
            var list = new List<object>();
            string connStr = ConfigurationManager.ConnectionStrings["ShabDB_connection"].ConnectionString;
            using (var conn = new SqlConnection(connStr))
            using (var cmd = new SqlCommand(
                "SELECT imagePath AS ImagePath FROM productsimages WHERE productId = @pid AND isDefault = 1", conn))
            {
                cmd.Parameters.AddWithValue("@pid", Convert.ToInt32(productIdObj));
                conn.Open();
                using (var rdr = cmd.ExecuteReader())
                    while (rdr.Read())
                        list.Add(new { ImagePath = rdr.GetString(0) });
            }

            if (list != null && list.Count > 0)
                return ((dynamic)list[0]).ImagePath;
            return "/assets/uploads/noFile.png";
        }

        protected void callbackImagePanel_Callback(object sender, CallbackEventArgsBase e)
        {
            if (!int.TryParse(e.Parameter, out int productId)) return;

            ImageSlider.Items.Clear();
            List<string> paths = new List<string>();

            var images = GetImagesForProduct(productId);
            foreach (var obj in images)
            {
                string relPath = (string)obj.GetType().GetProperty("ImagePath").GetValue(obj, null);
                if (!string.IsNullOrEmpty(relPath))
                {
                    string url = ResolveUrl(relPath) + "?v=" + DateTime.Now.Ticks;
                    ImageSlider.Items.Add(new DevExpress.Web.ImageSliderItem(url));
                    paths.Add(relPath.Replace("~", ""));
                }
            }

            string js = $"imagePaths = {Newtonsoft.Json.JsonConvert.SerializeObject(paths)};";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "setPaths", js, true);
        }



        protected void callbackSetDefault_Callback(object sender, CallbackEventArgsBase e)
        {
            var parts = e.Parameter.Split('|');
            int productId = int.Parse(parts[0]);
            string imagePath = parts[1];

            string cs = ConfigurationManager.ConnectionStrings["ShabDB_connection"].ConnectionString;

            using (var conn = new SqlConnection(cs))
            {
                conn.Open();

                var resetCmd = new SqlCommand("UPDATE productsimages SET isDefault = 0 WHERE productId = @pid", conn);
                resetCmd.Parameters.AddWithValue("@pid", productId);
                resetCmd.ExecuteNonQuery();

                var setCmd = new SqlCommand("UPDATE productsimages SET isDefault = 1 WHERE productId = @pid AND imagePath = @path", conn);
                setCmd.Parameters.AddWithValue("@pid", productId);
                setCmd.Parameters.AddWithValue("@path", imagePath);
                setCmd.ExecuteNonQuery();
            }

            // send it back to the client
            var cb = (ASPxCallback)sender;
            cb.JSProperties["cp_newDefault"] = imagePath;

        }


        string fileName = string.Empty;
        int checkError = 0;


        protected void ImageUpload_FileUploadComplete1(object sender, FileUploadCompleteEventArgs e)
        {
            e.CallbackData = SavePostedFile_all1(e.UploadedFile);

            if (l_item_file_check1.Text == "1")
            {
                int pos = l_item_file1.Text.LastIndexOf("/");
                string fileToDelete = l_item_file1.Text.Substring(pos + 1);
                string[] fileList = Directory.GetFiles(Server.MapPath("\\assets\\uploads\\options\\"), fileToDelete);
                foreach (string file in fileList)
                {
                    File.Delete(file);
                }
                l_item_file_check1.Text = "0";
            }

            if (checkError == 1)
            {
                checkError = 0;
                e.IsValid = false;
                e.ErrorText = "<div style='direction:rtl;padding-left: 10px;padding-right:10px;padding-top:0px;padding-buttom:0px'><strong>خطــأ:</strong> الصورة <strong>\"" + e.UploadedFile.FileName + "\"</strong> لم يتم تحميلها, الرجاء تحميل صورة جديدة بدلا منها.<br /><strong>لماذا:</strong> حقوق ملكية، تالفة، هيكلية الصورة...الخ.</div>";
            }
        }

        string SavePostedFile_all1(UploadedFile uploadedFile)
        {
            if (!uploadedFile.IsValid)
                return string.Empty;
            string UploadDirectory = "/assets/uploads/options/";
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

        protected void GridProductsOptions_CancelRowEditing(object sender, ASPxStartRowEditingEventArgs e)
        {
            if (l_item_file_check1.Text == "1")
            {
                int pos = l_item_file1.Text.LastIndexOf("/");
                string fileToDelete = l_item_file1.Text.Substring(pos + 1);
                string[] fileList = Directory.GetFiles(Server.MapPath("\\assets\\uploads\\options"), fileToDelete);
                foreach (string file in fileList)
                {
                    File.Delete(file);
                }
                l_item_file_check1.Text = "0";
            }
        }

        protected void GridProductsOptions_RowUpdated(object sender, ASPxDataUpdatedEventArgs e)
        {
            if (l_item_file_check1.Text == "1")
            {
                int pos = l_item_file_old1.Text.LastIndexOf("/");
                string fileToDelete = l_item_file_old1.Text.Substring(pos + 1);
                string[] fileList = Directory.GetFiles(Server.MapPath("\\assets\\uploads\\options"), fileToDelete);
                foreach (string file in fileList)
                {
                    File.Delete(file);
                }
                l_item_file_check1.Text = "0";
            }
        }

        protected void GridProductsOptions_RowDeleting(object sender, ASPxDataDeletingEventArgs e)
        {
            // أولاً تأكد أن الـ id صالح
            if (e.Keys["id"] == null || !int.TryParse(e.Keys["id"].ToString(), out int optionId))
            {
                e.Cancel = true;
                return;
            }
            bool isUsed = false;
            string connStr = ConfigurationManager.ConnectionStrings["ShabDB_connection"].ConnectionString;
            using (var conn = new SqlConnection(connStr))
            {
                conn.Open();
                // التحقق من وجود الخيار في carts
                string checkCartQuery = @"
    SELECT COUNT(*) 
    FROM carts 
    WHERE 
        (
            (options LIKE '%' + CAST(@optionId AS VARCHAR(10)) + '%' AND orderId = 0 AND isDeleted = 0)
            OR
            (options LIKE '%' + CAST(@optionId AS VARCHAR(10)) + '%' AND orderId > 0)
        )";
                using (var cmdCheckCart = new SqlCommand(checkCartQuery, conn))
                {
                    cmdCheckCart.Parameters.AddWithValue("@optionId", optionId);
                    int count = Convert.ToInt32(cmdCheckCart.ExecuteScalar());
                    if (count > 0)
                        isUsed = true;
                }

                // إذا الخيار مستخدم نمنع الحذف ونفتح نافذة توضح السبب
                if (isUsed)
                {
                    e.Cancel = true;
                    var grid = sender as ASPxGridView;
                    grid.JSProperties["cpShowUsedPopup"] = "true";
                    return;
                }

                // ✅ جلب معلومات المنتج الافتراضي المرتبط بهذا الخيار
                int virtualProductId = 0;
                string getVirtualProductQuery = "SELECT id FROM products WHERE parentOptionId = @optionId";
                using (var cmdGetProduct = new SqlCommand(getVirtualProductQuery, conn))
                {
                    cmdGetProduct.Parameters.AddWithValue("@optionId", optionId);
                    object result = cmdGetProduct.ExecuteScalar();
                    if (result != null)
                        virtualProductId = Convert.ToInt32(result);
                }

                // ✅ إذا كان هناك منتج افتراضي، احذف سجلات الصور من ProductsImages فقط
                if (virtualProductId > 0)
                {
                    // حذف السجلات من ProductsImages (بدون حذف الملفات الفعلية)
                    string deleteImagesQuery = "DELETE FROM ProductsImages WHERE productId = @productId";
                    using (var cmdDeleteImages = new SqlCommand(deleteImagesQuery, conn))
                    {
                        cmdDeleteImages.Parameters.AddWithValue("@productId", virtualProductId);
                        cmdDeleteImages.ExecuteNonQuery();
                    }

                    // حذف المنتج الافتراضي نفسه
                    string deleteProductQuery = "DELETE FROM products WHERE id = @productId";
                    using (var cmdDeleteProduct = new SqlCommand(deleteProductQuery, conn))
                    {
                        cmdDeleteProduct.Parameters.AddWithValue("@productId", virtualProductId);
                        cmdDeleteProduct.ExecuteNonQuery();
                    }
                }
            }

            // حذف صورة الخيار من ProductsOptions فقط إذا لم يكن الخيار مستخدم
            string fileToDelete = e.Values["imagePath"]?.ToString();
            if (!string.IsNullOrEmpty(fileToDelete))
            {
                try
                {
                    int pos = fileToDelete.LastIndexOf("/");
                    fileToDelete = fileToDelete.Substring(pos + 1);
                    string[] fileList = Directory.GetFiles(Server.MapPath("\\assets\\uploads\\options"), fileToDelete);
                    foreach (string file in fileList)
                    {
                        File.Delete(file);
                    }
                }
                catch { } // تجاهل الأخطاء في حذف الملفات
            }
        }

        protected void ImageUpload_FileUploadComplete2(object sender, FileUploadCompleteEventArgs e)
        {
            e.CallbackData = SavePostedFile_all2(e.UploadedFile);

            if (l_item_file_check2.Text == "1")
            {
                int pos = l_item_file2.Text.LastIndexOf("/");
                string fileToDelete = l_item_file2.Text.Substring(pos + 1);
                string[] fileList = Directory.GetFiles(Server.MapPath("\\assets\\uploads\\extras"), fileToDelete);
                foreach (string file in fileList)
                {
                    File.Delete(file);
                }
                l_item_file_check2.Text = "0";
            }

            if (checkError == 1)
            {
                checkError = 0;
                e.IsValid = false;
                e.ErrorText = "<div style='direction:rtl;padding-left: 10px;padding-right:10px;padding-top:0px;padding-buttom:0px'><strong>خطــأ:</strong> الصورة <strong>\"" + e.UploadedFile.FileName + "\"</strong> لم يتم تحميلها, الرجاء تحميل صورة جديدة بدلا منها.<br /><strong>لماذا:</strong> حقوق ملكية، تالفة، هيكلية الصورة...الخ.</div>";
            }
        }

        string SavePostedFile_all2(UploadedFile uploadedFile)
        {
            if (!uploadedFile.IsValid)
                return string.Empty;
            string UploadDirectory = "/assets/uploads/extras/";
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


        protected void GridProductsExtras_CancelRowEditing(object sender, ASPxStartRowEditingEventArgs e)
        {
            if (l_item_file_check2.Text == "1")
            {
                int pos = l_item_file2.Text.LastIndexOf("/");
                string fileToDelete = l_item_file2.Text.Substring(pos + 1);
                string[] fileList = Directory.GetFiles(Server.MapPath("\\assets\\uploads\\extras"), fileToDelete);
                foreach (string file in fileList)
                {
                    File.Delete(file);
                }
                l_item_file_check2.Text = "0";
            }
        }

        protected void GridProductsExtras_RowUpdated(object sender, ASPxDataUpdatedEventArgs e)
        {
            if (l_item_file_check2.Text == "1")
            {
                int pos = l_item_file_old2.Text.LastIndexOf("/");
                string fileToDelete = l_item_file_old2.Text.Substring(pos + 1);
                string[] fileList = Directory.GetFiles(Server.MapPath("\\assets\\uploads\\extras"), fileToDelete);
                foreach (string file in fileList)
                {
                    File.Delete(file);
                }
                l_item_file_check2.Text = "0";
            }
        }

        protected void GridProductsExtras_RowDeleting(object sender, ASPxDataDeletingEventArgs e)
        {
            string fileToDelete = e.Values["imagePath"].ToString();
            int pos = fileToDelete.LastIndexOf("/");
            fileToDelete = fileToDelete.Substring(pos + 1);
            string[] fileList = Directory.GetFiles(Server.MapPath("\\assets\\uploads\\extras"), fileToDelete);
            foreach (string file in fileList)
            {
                File.Delete(file);
            }
        }

        protected void FillCityCombo(ASPxComboBox cmb, string country, string company)
        {
            if (string.IsNullOrEmpty(country)) return;

            cmb.DataSourceID = null;
            db_Categories_Selected.SelectParameters["countryId"].DefaultValue = country;
            db_Categories_Selected.SelectParameters["companyId"].DefaultValue = company;
            cmb.DataSource = db_Categories_Selected;

            cmb.DataBindItems();
        }
        void cmbCountry_OnCallback(object source, CallbackEventArgsBase e)
        {
            string[] parameters = e.Parameter.Split('|');
            if (parameters.Length == 2)
            {
                FillCityCombo(source as ASPxComboBox, parameters[0], parameters[1]);
            }
        }


        protected void GridProducts_CellEditorInitialize(object sender, ASPxGridViewEditorEventArgs e)
        {
            if (GridProducts.IsEditing && e.Column.FieldName == "categoryID")
            {
                ASPxComboBox comboCountry = e.Editor as ASPxComboBox;
                comboCountry.Callback += cmbCountry_OnCallback;
                object countryObj = GridProducts.GetRowValues(e.VisibleIndex, "countryID");
                int countryId = countryObj != null ? Convert.ToInt32(countryObj) : 0;
                object companyObj = GridProducts.GetRowValues(e.VisibleIndex, "companyID");
                int companyId = companyObj != null ? Convert.ToInt32(companyObj) : 0;

                if (e.KeyValue != DBNull.Value && e.KeyValue != null)
                {
                    FillCityCombo(comboCountry, countryId.ToString(), companyId.ToString());
                }
                else
                {
                    comboCountry.DataSourceID = null;
                    comboCountry.Items.Clear();
                }
            }
            else if (e.Column.FieldName == "subCategoryId")
            {
                ASPxComboBox combo = e.Editor as ASPxComboBox;

                combo.ValueField = "id";
                combo.TextField = "subName";

                if (!GridProducts.IsNewRowEditing)
                {
                    object categoryObj = GridProducts.GetRowValues(e.VisibleIndex, "categoryID");
                    int categoryId = categoryObj != null ? Convert.ToInt32(categoryObj) : 0;

                    if (categoryId > 0)
                    {
                        db_SubCategories.SelectParameters["categoryId"].DefaultValue = categoryId.ToString();
                        combo.DataBind();
                    }
                    else
                    {
                        combo.Items.Clear();
                    }
                }

                combo.Callback += (s, args) =>
                {
                    if (int.TryParse(args.Parameter, out int categoryId))
                    {
                        db_SubCategories.SelectParameters["categoryId"].DefaultValue = categoryId.ToString();
                        combo.DataBind();
                    }
                };
            }
        }

        protected void GridProductsOptions_RowUpdating(object sender, DevExpress.Web.Data.ASPxDataUpdatingEventArgs e)
        {
            int optionId = Convert.ToInt32(e.Keys["id"]);
            decimal currentOfferPrice = 0;

            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ShabDB_connection"].ConnectionString))
            {
                conn.Open();
                string query = "SELECT ISNULL(offerPrice, 0) FROM ProductsOptions WHERE id = @id";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@id", optionId);
                    object result = cmd.ExecuteScalar();
                    if (result != null)
                        currentOfferPrice = Convert.ToDecimal(result);
                }
            }

            if (currentOfferPrice > 0 && Convert.ToDecimal(e.NewValues["productOptionPrice"] ?? 0) != Convert.ToDecimal(e.OldValues["productOptionPrice"] ?? 0))
            {
                var grid = sender as ASPxGridView;
                grid.JSProperties["cpShowCancelOfferPopup"] = "true";
                grid.JSProperties["cpOptionId"] = optionId;
                e.Cancel = true;
            }
        }



        protected void GridProductsOptions_CustomCallback(object sender, ASPxGridViewCustomCallbackEventArgs e)
        {
            if (string.IsNullOrEmpty(e.Parameters)) return;

            string[] parts = e.Parameters.Split('|');
            string command = parts[0];

            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ShabDB_connection"].ConnectionString))
            {
                conn.Open();

                if (command == "cancelOffer")
                {
                    int optionId = Convert.ToInt32(parts[1]);

                    int productId = 0;
                    string getProductIdQuery = "SELECT productId FROM ProductsOptions WHERE id = @optionId";
                    using (SqlCommand cmd = new SqlCommand(getProductIdQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@optionId", optionId);
                        object result = cmd.ExecuteScalar();
                        if (result != null)
                            productId = Convert.ToInt32(result);
                    }

                    string updateOption = @"UPDATE ProductsOptions 
                                    SET offerPrice = 0, offerPercent = 0 
                                    WHERE id = @optionId";
                    using (SqlCommand cmd = new SqlCommand(updateOption, conn))
                    {
                        cmd.Parameters.AddWithValue("@optionId", optionId);
                        cmd.ExecuteNonQuery();
                    }

                    string updateProduct = @"UPDATE products 
                                     SET isVirtualDeleted = 1 
                                     WHERE parentOptionId = @optionId";
                    using (SqlCommand cmd = new SqlCommand(updateProduct, conn))
                    {
                        cmd.Parameters.AddWithValue("@optionId", optionId);
                        cmd.ExecuteNonQuery();
                    }

                    var grid = sender as ASPxGridView;
                    if (productId > 0)
                    {
                        db_ProductsOptions.SelectParameters["productId"].DefaultValue = productId.ToString();
                    }

                    grid.JSProperties["cpCanceled"] = "true";

                    grid.DataBind();

                }
            }
        }
    }
}