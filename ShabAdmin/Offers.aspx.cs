using DevExpress.Web;
using DevExpress.Web.Data;
using System;
using System.Collections.Generic;
using System.ComponentModel.Design;
using System.Configuration;
using System.Data.SqlClient;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Net.NetworkInformation;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ShabAdmin
{
    public partial class Offers : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        protected void Page_Init(object sender, EventArgs e)
        {

            if (Session["ProductOptions_ProductId"] != null)
            {
                dsProductOptions.SelectParameters["productId"].DefaultValue = Session["ProductOptions_ProductId"].ToString();
            }

            string username = MainHelper.M_Check(Request.Cookies["M_Username"]?.Value);
            int privilegeCountryID = 0;
            int privilegeCompanyID = 0;

            if (!string.IsNullOrEmpty(username))
            {
                string connStr = ConfigurationManager.ConnectionStrings["ShabDB_connection"].ConnectionString;
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();
                    SqlCommand cmd = new SqlCommand(@"
                SELECT privilegeCountryID, privilegeCompanyID 
                FROM users 
                WHERE username = @username", conn);
                    cmd.Parameters.AddWithValue("@username", username);

                    SqlDataReader reader = cmd.ExecuteReader();
                    if (reader.Read())
                    {
                        if (reader["privilegeCountryID"] != DBNull.Value)
                            privilegeCountryID = Convert.ToInt32(reader["privilegeCountryID"]);
                        if (reader["privilegeCompanyID"] != DBNull.Value)
                            privilegeCompanyID = Convert.ToInt32(reader["privilegeCompanyID"]);
                    }
                }
            }

            if (privilegeCountryID != 1000 && privilegeCompanyID != 1000)
            {
                db_MainOffers.SelectCommand = @"
        SELECT p.[id], p.[countryId], p.[offerImage],p.[companyId], p.[l_offerId], 
               p.[itemId], p.[position], p.[l_offerType]
        FROM [mainOffers] p
        WHERE p.countryId = @countryId AND p.companyId = @companyId
        order by p.position asc, p.l_offerType desc";

                db_MainOffers.SelectParameters.Clear();
                db_MainOffers.SelectParameters.Add(new Parameter("countryId", TypeCode.Int32, privilegeCountryID.ToString()));
                db_MainOffers.SelectParameters.Add(new Parameter("companyId", TypeCode.Int32, privilegeCompanyID.ToString()));

                Products.SelectCommand = @" SELECT p.id, p.name, p.price
                FROM Products p
                WHERE p.isProductPrice = 1
                  AND EXISTS (SELECT 1 FROM ProductsOptions po WHERE po.productId = p.id) And countryId=@countryId And companyId=@companyId";
                Products.SelectParameters.Clear();
                Products.SelectParameters.Add(new Parameter("countryId", TypeCode.Int32, privilegeCountryID.ToString()));
                Products.SelectParameters.Add(new Parameter("companyId", TypeCode.Int32, privilegeCompanyID.ToString()));

                DB_L_countries.SelectCommand = @"SELECT id, countryName FROM [countries] where id = @countryId";
                DB_L_countries.SelectParameters.Add(new Parameter("countryId", TypeCode.Int32, privilegeCountryID.ToString()));
            }
            else if (privilegeCountryID != 1000)
            {
                db_MainOffers.SelectCommand = @"
        SELECT p.[id], p.[countryId], p.[offerImage],p.[companyId], p.[l_offerId], 
               p.[itemId], p.[position], p.[l_offerType]
        FROM [mainOffers] p
        WHERE p.countryId = @countryId
        order by p.position asc, p.l_offerType desc";

                db_MainOffers.SelectParameters.Clear();
                db_MainOffers.SelectParameters.Add(new Parameter("countryId", TypeCode.Int32, privilegeCountryID.ToString()));

                Products.SelectCommand = @" SELECT p.id, p.name, p.price
                FROM Products p
                WHERE p.isProductPrice = 1
                  AND EXISTS (SELECT 1 FROM ProductsOptions po WHERE po.productId = p.id) And countryId=@countryId";
                Products.SelectParameters.Clear();
                Products.SelectParameters.Add(new Parameter("countryId", TypeCode.Int32, privilegeCountryID.ToString()));

                DB_L_countries.SelectCommand = @"SELECT id, countryName FROM [countries] where id = @countryId";
                DB_L_countries.SelectParameters.Add(new Parameter("countryId", TypeCode.Int32, privilegeCountryID.ToString()));
            }



            ViewState["privilegeCountryID"] = privilegeCountryID;
            ViewState["privilegeCompanyID"] = privilegeCompanyID;
        }
        protected void GridOffers_BeforePerformDataSelect(object sender, EventArgs e)
        {
            int privilegeCountryID = ViewState["privilegeCountryID"] != null ? (int)ViewState["privilegeCountryID"] : 1000;
            int privilegeCompanyID = ViewState["privilegeCompanyID"] != null ? (int)ViewState["privilegeCompanyID"] : 1000;

            int country = countryList.Value != null ? Convert.ToInt32(countryList.Value) : 0;
            string search = !string.IsNullOrEmpty(searchGrid.Text) ? searchGrid.Text : "";
            bool showAll = showAllOffers.Text == "100";

            bool noFilter = (country == 0
                             && string.IsNullOrEmpty(search)
                             && !showAll);

            if (noFilter)
            {
                db_Offers.SelectCommand = @"
    SELECT p.id, p.name,
           ISNULL((SELECT TOP 1 imagePath 
                   FROM productsimages 
                   WHERE isDefault = 1 AND productId = p.id), 
                   '/assets/uploads/noFile.png') AS image,
           p.price, p.offerPrice, p.offerPercent, p.countryId, p.companyId
    FROM products p
    WHERE 1=0";
                return;
            }

            // ✅ استعلام أساسي
            string baseQuery = @"
    SELECT p.id, p.name,
           ISNULL((SELECT TOP 1 imagePath 
                   FROM productsimages 
                   WHERE isDefault = 1 AND productId = p.id), 
                   '/assets/uploads/noFile.png') AS image,
           p.price, p.offerPrice, p.offerPercent, p.countryId, p.companyId
    FROM products p
    WHERE 1=1";

            // (A) 🔒 الصلاحيات
            if (privilegeCountryID != 1000)
            {
                baseQuery += " AND p.countryId = " + privilegeCountryID;

                DB_L_countries.SelectCommand = @"SELECT id, countryName FROM [countries] where id = @countryId";
                DB_L_countries.SelectParameters.Add(new Parameter("countryId", TypeCode.Int32, privilegeCountryID.ToString()));
            }

            if (privilegeCompanyID != 1000)
                baseQuery += " AND p.companyId = " + privilegeCompanyID;

            if (country > 0)
                baseQuery += " AND p.countryId = " + country;

            if (!string.IsNullOrEmpty(search))
                baseQuery += " AND p.name LIKE '%" + search + "%'";

            if (showAll)
                baseQuery += " AND p.offerPrice > 0";

            db_Offers.SelectCommand = baseQuery;
        }

        protected void GridOffers_CustomCallback(object sender, ASPxGridViewCustomCallbackEventArgs e)
        {
            if (!string.IsNullOrEmpty(e.Parameters) && e.Parameters != "country")
            {
                int productId = Convert.ToInt32(e.Parameters);

                string connStrCancelation = ConfigurationManager.ConnectionStrings["ShabDB_connection"].ConnectionString;
                using (SqlConnection conn = new SqlConnection(connStrCancelation))
                {
                    conn.Open();

                    // 1) إلغاء العرض من المنتج الأساسي
                    string updateProductQuery = "UPDATE products SET offerPrice = 0, offerPercent = 0 WHERE id = @id";
                    using (SqlCommand cmd = new SqlCommand(updateProductQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@id", productId);
                        cmd.ExecuteNonQuery();
                    }

                    // 2) الحصول على جميع خيارات المنتج
                    string getOptionsQuery = "SELECT id FROM ProductsOptions WHERE productId = @productId";
                    List<int> optionIds = new List<int>();

                    using (SqlCommand cmdGetOptions = new SqlCommand(getOptionsQuery, conn))
                    {
                        cmdGetOptions.Parameters.AddWithValue("@productId", productId);
                        using (SqlDataReader reader = cmdGetOptions.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                optionIds.Add(Convert.ToInt32(reader["id"]));
                            }
                        }
                    }

                    // 3) إلغاء العروض من جميع الخيارات
                    if (optionIds.Count > 0)
                    {
                        foreach (int optionId in optionIds)
                        {
                            // إلغاء العرض من الخيار
                            string updateOptionQuery = "UPDATE ProductsOptions SET offerPrice = 0, offerPercent = 0 WHERE id = @optionId";
                            using (SqlCommand cmdUpdateOption = new SqlCommand(updateOptionQuery, conn))
                            {
                                cmdUpdateOption.Parameters.AddWithValue("@optionId", optionId);
                                cmdUpdateOption.ExecuteNonQuery();
                            }

                            // تحديث المنتجات الافتراضية المرتبطة بهذا الخيار
                            string updateVirtualProductsQuery = @"
                        UPDATE products 
                        SET offerPrice = 0, offerPercent = 0, isVirtualDeleted = 1 
                        WHERE parentOptionId = @optionId";

                            using (SqlCommand cmdUpdateVirtual = new SqlCommand(updateVirtualProductsQuery, conn))
                            {
                                cmdUpdateVirtual.Parameters.AddWithValue("@optionId", optionId);
                                cmdUpdateVirtual.ExecuteNonQuery();
                            }
                        }
                    }
                }
            }

            GridOffers.DataBind();
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
                string[] fileList = Directory.GetFiles(Server.MapPath("\\assets\\uploads\\offers"), fileToDelete);
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
            string UploadDirectory = "/assets/uploads/offers/";
            string Docs = Guid.NewGuid().ToString() + ".png";
            fileName = Docs;
            try
            {
                string fileName = Path.Combine(MapPath(UploadDirectory), Docs);
                using (System.Drawing.Image original = System.Drawing.Image.FromStream(uploadedFile.FileContent))
                using (System.Drawing.Image thumbnail = PhotoUtils.Inscribe(original, 800, 500))
                {
                    PhotoUtils.SaveToJpeg(thumbnail, fileName, 1);
                }
            }
            catch
            {
                checkError = 1;
            }

            return UploadDirectory + fileName;
        }
        protected void GridMainOffers_CancelRowEditing(object sender, DevExpress.Web.Data.ASPxStartRowEditingEventArgs e)
        {
            if (l_item_file_check.Text == "1")
            {
                int pos = l_item_file.Text.LastIndexOf("/");
                string fileToDelete = l_item_file.Text.Substring(pos + 1);
                string[] fileList = Directory.GetFiles(Server.MapPath("\\assets\\uploads\\offers"), fileToDelete);
                foreach (string file in fileList)
                {
                    File.Delete(file);
                }
                l_item_file_check.Text = "0";
            }
        }
        protected void GridMainOffers_RowUpdated(object sender, DevExpress.Web.Data.ASPxDataUpdatedEventArgs e)
        {
            if (l_item_file_check.Text == "1")
            {
                int pos = l_item_file_old.Text.LastIndexOf("/");
                string fileToDelete = l_item_file_old.Text.Substring(pos + 1);
                string[] fileList = Directory.GetFiles(Server.MapPath("\\assets\\uploads\\offers"), fileToDelete);
                foreach (string file in fileList)
                {
                    File.Delete(file);
                }
                l_item_file_check.Text = "0";
            }
        }
        protected void GridMainOffers_RowDeleting(object sender, DevExpress.Web.Data.ASPxDataDeletingEventArgs e)
        {
            string fileToDelete = e.Values["offerImage"].ToString();
            int pos = fileToDelete.LastIndexOf("/");
            fileToDelete = fileToDelete.Substring(pos + 1);
            string[] fileList = Directory.GetFiles(Server.MapPath("\\assets\\uploads\\offers"), fileToDelete);
            foreach (string file in fileList)
            {
                File.Delete(file);
            }
        }


        protected void Grid_Association_CellEditorInitialize(object sender, ASPxGridViewEditorEventArgs e)
        {
            if (e.Column.FieldName == "itemId")
            {
                var combo = (ASPxComboBox)e.Editor;
                combo.Callback += new CallbackEventHandlerBase(combo_Callback);

                var grid = e.Column.Grid;
                if (!combo.IsCallback)
                {
                    var countryId = -1;
                    var companyId = -1;
                    var l_offerId = 1;

                    if (!grid.IsNewRowEditing)
                    {
                        countryId = (int)grid.GetRowValues(e.VisibleIndex, "countryId");
                        companyId = (int)grid.GetRowValues(e.VisibleIndex, "companyId");
                        l_offerId = (int)grid.GetRowValues(e.VisibleIndex, "l_offerId");

                        if (l_offerId == 1)
                        {
                            FillProductsComboBox(combo, countryId, companyId);
                        }
                        else if (l_offerId == 2)
                        {
                            FillCategoriesComboBox(combo, countryId, companyId);
                        }
                    }

                }
            }

            if (e.Column.FieldName == "companyId")
            {
                var combo = (ASPxComboBox)e.Editor;
                combo.Callback += new CallbackEventHandlerBase(combo_Callback);

                var grid = e.Column.Grid;
                if (!combo.IsCallback)
                {
                    int countryId = -1;
                    if (!grid.IsNewRowEditing)
                    {
                        countryId = (int)grid.GetRowValues(e.VisibleIndex, "countryId");
                    }
                    FillCompaniesComboBox(combo, countryId);
                }
            }
        }

        protected void FillCompaniesComboBox(ASPxComboBox combo, int countryID)
        {
            combo.DataSourceID = "DB_Companies1";
            DB_Companies1.SelectParameters["countryId"].DefaultValue = countryID.ToString();
            combo.DataBindItems();
        }

        private void combo_Callback(object sender, CallbackEventArgsBase e)
        {
            var parts = e.Parameter.Split('|');
            int l_offerId = 0;
            int countryId = 0;
            int companyId = 0;

            if (parts.Length == 3)
            {
                Int32.TryParse(parts[0], out l_offerId);
                Int32.TryParse(parts[1], out countryId);
                Int32.TryParse(parts[2], out companyId);
            }
            if (parts.Length == 2)
            {
                Int32.TryParse(parts[0], out l_offerId);
                Int32.TryParse(parts[1], out countryId);
            }

            if (l_offerId == 1)
            {
                FillProductsComboBox(sender as ASPxComboBox, countryId, companyId);
            }
            else if (l_offerId == 2)
            {
                FillCategoriesComboBox(sender as ASPxComboBox, countryId, companyId);
            }
            if (l_offerId == 0)
            {
                FillCompaniesComboBox(sender as ASPxComboBox, countryId);
            }

        }

        protected void FillProductsComboBox(ASPxComboBox combo, int countryID, int companyID)
        {
            combo.DataSourceID = "DB_L_Item_selected1";
            DB_L_Item_selected1.SelectParameters["countryId"].DefaultValue = countryID.ToString();
            DB_L_Item_selected1.SelectParameters["companyId"].DefaultValue = companyID.ToString();
            combo.DataBindItems();
        }
        protected void FillCategoriesComboBox(ASPxComboBox combo, int countryID, int companyID)
        {
            combo.DataSourceID = "DB_L_Item_selected2";
            DB_L_Item_selected2.SelectParameters["countryId"].DefaultValue = countryID.ToString();
            DB_L_Item_selected2.SelectParameters["companyId"].DefaultValue = companyID.ToString();
            combo.DataBindItems();
        }
        protected void GridMainOffers_RowInserting(object sender, ASPxDataInsertingEventArgs e)
        {
            int countryId = Convert.ToInt32(e.NewValues["countryId"]);
            int offerType = Convert.ToInt32(e.NewValues["l_offerType"]);

            if (offerType == 2)
            {
                string connStr = ConfigurationManager.ConnectionStrings["ShabDB_connection"].ConnectionString;
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();
                    string query = "SELECT COUNT(*) FROM mainOffers WHERE countryId = @countryId AND l_offerType = 2";
                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@countryId", countryId);

                    int count = (int)cmd.ExecuteScalar();
                    if (count > 0)
                    {
                        GridMainOffers.JSProperties["cpShowPopup"] = "true";
                        e.Cancel = true;
                    }
                }
            }
        }

        protected void GridMainOffers_RowUpdating(object sender, ASPxDataUpdatingEventArgs e)
        {
            int countryId = Convert.ToInt32(e.NewValues["countryId"]);
            int offerType = Convert.ToInt32(e.NewValues["l_offerType"]);
            int id = Convert.ToInt32(e.Keys["id"]);

            if (offerType == 2)
            {
                string connStr = ConfigurationManager.ConnectionStrings["ShabDB_connection"].ConnectionString;
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();
                    string query = "SELECT COUNT(*) FROM mainOffers WHERE countryId = @countryId AND l_offerType = 2 AND id != @id";
                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@countryId", countryId);
                    cmd.Parameters.AddWithValue("@id", id);

                    int count = (int)cmd.ExecuteScalar();
                    if (count > 0)
                    {
                        GridMainOffers.JSProperties["cpShowPopup"] = "true";
                        e.Cancel = true;
                    }
                }
            }
        }

        protected void GridOffers_BatchUpdate(object sender, ASPxDataBatchUpdateEventArgs e)
        {
            string username = MainHelper.M_Check(Request.Cookies["M_Username"]?.Value);
            int privilegeCompanyId = 0;
            int privilegeCountryId = 0;
            string connStr = ConfigurationManager.ConnectionStrings["ShabDB_connection"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                // التحقق من الصلاحيات
                string sql = "SELECT privilegeCompanyId, privilegeCountryId FROM users WHERE username = @username";
                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@username", username);
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            privilegeCompanyId = reader["privilegeCompanyId"] != DBNull.Value ? Convert.ToInt32(reader["privilegeCompanyId"]) : 0;
                            privilegeCountryId = reader["privilegeCountryId"] != DBNull.Value ? Convert.ToInt32(reader["privilegeCountryId"]) : 0;
                        }
                    }
                }

                if (privilegeCountryId == 1000 || privilegeCompanyId == 1000)
                {
                    GridOffers.JSProperties["cpCancelUpdate"] = "true";
                    e.Handled = true;
                    return;
                }

                // جمع بيانات المنتجات المعدّلة وتحديثها يدوياً
                Dictionary<int, (decimal offerPrice, decimal offerPercent)> updatedProducts = new Dictionary<int, (decimal, decimal)>();

                foreach (var updateValue in e.UpdateValues)
                {
                    if (updateValue.Keys["id"] != null)
                    {
                        int productId = Convert.ToInt32(updateValue.Keys["id"]);
                        decimal offerPrice = updateValue.NewValues["offerPrice"] != null ? Convert.ToDecimal(updateValue.NewValues["offerPrice"]) : 0;
                        decimal offerPercent = updateValue.NewValues["offerPercent"] != null ? Convert.ToDecimal(updateValue.NewValues["offerPercent"]) : 0;

                        // تحديث المنتج الرئيسي
                        string updateProductQuery = "UPDATE products SET offerPrice = @offerPrice, offerPercent = @offerPercent WHERE id = @id";
                        using (SqlCommand cmdUpdate = new SqlCommand(updateProductQuery, conn))
                        {
                            cmdUpdate.Parameters.AddWithValue("@offerPrice", offerPrice);
                            cmdUpdate.Parameters.AddWithValue("@offerPercent", offerPercent);
                            cmdUpdate.Parameters.AddWithValue("@id", productId);
                            cmdUpdate.ExecuteNonQuery();
                        }

                        updatedProducts[productId] = (offerPrice, offerPercent);
                    }
                }

                // نمنع التحديث الافتراضي لأننا قمنا به يدوياً
                e.Handled = true;

                // بعد تحديث المنتجات، نعالج الخيارات
                List<int> specialProducts = new List<int>();
                int totalOptionsUpdated = 0;

                if (updatedProducts.Count > 0)
                {
                    string ids = string.Join(",", updatedProducts.Keys);
                    string checkSql = $"SELECT id FROM products WHERE id IN ({ids}) AND isProductPrice = 1";

                    using (SqlCommand checkCmd = new SqlCommand(checkSql, conn))
                    {
                        using (SqlDataReader reader = checkCmd.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                specialProducts.Add(Convert.ToInt32(reader["id"]));
                            }
                        }
                    }
                }

                // معالجة المنتجات التي لديها خيارات
                if (specialProducts.Count > 0)
                {
                    foreach (int productId in specialProducts)
                    {
                        // الحصول على قيم العرض من المنتج المحدث
                        decimal productOfferPrice = updatedProducts[productId].offerPrice;
                        decimal productOfferPercent = updatedProducts[productId].offerPercent;

                        // 1) جلب كل الخيارات الخاصة بالمنتج
                        string getOptionsQuery = "SELECT id, productOptionPrice, productOption FROM ProductsOptions WHERE productId = @productId";
                        List<(int optionId, decimal price, string name)> options = new List<(int, decimal, string)>();

                        using (SqlCommand cmd = new SqlCommand(getOptionsQuery, conn))
                        {
                            cmd.Parameters.AddWithValue("@productId", productId);
                            using (SqlDataReader r = cmd.ExecuteReader())
                            {
                                while (r.Read())
                                {
                                    options.Add((
                                        optionId: Convert.ToInt32(r["id"]),
                                        price: Convert.ToDecimal(r["productOptionPrice"]),
                                        name: r["productOption"].ToString()
                                    ));
                                }
                            }
                        }

                        // 2) تحديث كل خيار
                        foreach (var option in options)
                        {
                            decimal offerPrice = Math.Round(option.price - (option.price * productOfferPercent / 100), 2);

                            // تحقق إذا يوجد منتج افتراضي مرتبط بالخيار
                            string checkQuery = "SELECT COUNT(*) FROM products WHERE parentOptionId = @optionId";
                            int exists = 0;
                            using (SqlCommand cmdCheck = new SqlCommand(checkQuery, conn))
                            {
                                cmdCheck.Parameters.AddWithValue("@optionId", option.optionId);
                                exists = (int)cmdCheck.ExecuteScalar();
                            }

                            if (exists > 0)
                            {
                                // تحديث المنتج الحالي
                                string updateQuery = @"
                            UPDATE products
                            SET price = @price,
                                offerPrice = @offerPrice,
                                offerPercent = @offerPercent,
                                isVirtualDeleted = 0
                            WHERE parentOptionId = @optionId";

                                using (SqlCommand cmdUpdate = new SqlCommand(updateQuery, conn))
                                {
                                    cmdUpdate.Parameters.AddWithValue("@price", option.price);
                                    cmdUpdate.Parameters.AddWithValue("@offerPrice", offerPrice);
                                    cmdUpdate.Parameters.AddWithValue("@offerPercent", productOfferPercent);
                                    cmdUpdate.Parameters.AddWithValue("@optionId", option.optionId);
                                    cmdUpdate.ExecuteNonQuery();
                                }
                            }
                            else
                            {
                                // إنشاء منتج جديد مرتبط بالخيار
                                string insertQuery = @"
                            INSERT INTO products (
                                Name, NameEn, description, categoryId, subCategoryId,
                                Price, offerPrice, offerPercent,
                                isWeight, IsHasFlavors, isSpecial,
                                countryId, companyId, uid,
                                parentId, parentOptionId,
                                isProductPrice, isVirtual, isVirtualDeleted,
                                barcode, isVisible, rate, rateCount, userDate
                            )
                            OUTPUT INSERTED.id
                            SELECT 
                                Name + ' - ' + @optionName, 
                                NameEn, description, categoryId, subCategoryId,
                                @price, @offerPrice, @offerPercent,
                                isWeight, IsHasFlavors, isSpecial,
                                countryId, companyId, uid,
                                @parentId, @optionId,
                                isProductPrice, 1, 0,
                                barcode, isVisible, rate, rateCount, GETDATE()
                            FROM products
                            WHERE id = @parentId";

                                int newProductId = 0;
                                using (SqlCommand cmdInsert = new SqlCommand(insertQuery, conn))
                                {
                                    cmdInsert.Parameters.AddWithValue("@optionName", option.name);
                                    cmdInsert.Parameters.AddWithValue("@price", option.price);
                                    cmdInsert.Parameters.AddWithValue("@offerPrice", offerPrice);
                                    cmdInsert.Parameters.AddWithValue("@offerPercent", productOfferPercent);
                                    cmdInsert.Parameters.AddWithValue("@optionId", option.optionId);
                                    cmdInsert.Parameters.AddWithValue("@parentId", productId);
                                    newProductId = Convert.ToInt32(cmdInsert.ExecuteScalar());
                                }

                                // تحديث الصور
                                string imagePath = "";
                                string getImageQuery = "SELECT imagePath FROM ProductsOptions WHERE id = @optionId";
                                using (SqlCommand cmdImg = new SqlCommand(getImageQuery, conn))
                                {
                                    cmdImg.Parameters.AddWithValue("@optionId", option.optionId);
                                    object imgResult = cmdImg.ExecuteScalar();
                                    if (imgResult != null && imgResult != DBNull.Value)
                                        imagePath = imgResult.ToString();
                                }

                                if (string.IsNullOrEmpty(imagePath))
                                {
                                    string getParentImageQuery = @"
                                SELECT TOP 1 imagePath 
                                FROM ProductsImages 
                                WHERE productId = @parentId AND isDefault = 1
                                ORDER BY id";

                                    using (SqlCommand cmdParentImg = new SqlCommand(getParentImageQuery, conn))
                                    {
                                        cmdParentImg.Parameters.AddWithValue("@parentId", productId);
                                        object parentImgResult = cmdParentImg.ExecuteScalar();
                                        if (parentImgResult != null && parentImgResult != DBNull.Value)
                                            imagePath = parentImgResult.ToString();
                                    }
                                }

                                if (!string.IsNullOrEmpty(imagePath))
                                {
                                    string insertImageQuery = @"
                                INSERT INTO ProductsImages (imagePath, isDefault, productId, userDate)
                                VALUES (@imagePath, 1, @productId, GETDATE())";

                                    using (SqlCommand cmdImage = new SqlCommand(insertImageQuery, conn))
                                    {
                                        cmdImage.Parameters.AddWithValue("@imagePath", imagePath);
                                        cmdImage.Parameters.AddWithValue("@productId", newProductId);
                                        cmdImage.ExecuteNonQuery();
                                    }
                                }
                            }

                            // تحديث جدول الخيارات نفسه
                            string updateOptionQuery = "UPDATE ProductsOptions SET offerPrice = @offerPrice, offerPercent = @offerPercent WHERE id = @id";
                            using (SqlCommand cmdOption = new SqlCommand(updateOptionQuery, conn))
                            {
                                cmdOption.Parameters.AddWithValue("@offerPrice", offerPrice);
                                cmdOption.Parameters.AddWithValue("@offerPercent", productOfferPercent);
                                cmdOption.Parameters.AddWithValue("@id", option.optionId);
                                cmdOption.ExecuteNonQuery();
                            }

                            totalOptionsUpdated++;
                        }
                    }

                    // إرسال رسالة النجاح مع عدد الخيارات المحدثة
                    if (totalOptionsUpdated > 0)
                    {
                        GridOffers.JSProperties["cp_ShowResultPopup"] = "true";
                        GridOffers.JSProperties["cp_ResultMessage"] = $"تم تطبيق العروض بنجاح على {specialProducts.Count} منتج و {totalOptionsUpdated} خيار";
                    }
                }
            }
        }

        protected void cbCheckPrivileges_Callback(object sender, CallbackEventArgsBase e)
        {
            string username = MainHelper.M_Check(Request.Cookies["M_Username"]?.Value);
            int privilegeCompanyId = 0;
            int privilegeCountryId = 0;

            string connStr = ConfigurationManager.ConnectionStrings["ShabDB_connection"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                string sql = "SELECT privilegeCompanyId, privilegeCountryId FROM users WHERE username = @username";
                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@username", username);
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            privilegeCompanyId = reader["privilegeCompanyId"] != DBNull.Value ? Convert.ToInt32(reader["privilegeCompanyId"]) : 0;
                            privilegeCountryId = reader["privilegeCountryId"] != DBNull.Value ? Convert.ToInt32(reader["privilegeCountryId"]) : 0;
                        }
                    }
                }
            }

            if (privilegeCountryId == 1000 || privilegeCompanyId == 1000)
            {
                cbCheckPrivileges.JSProperties["cpShowPopup"] = "true";
            }
            else
            {
                cbCheckPrivileges.JSProperties["cpShowPopup"] = "false";
            }
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
        protected string GetOptionImagePath(object productOptionIdObj)
        {
            if (productOptionIdObj == null)
                return "/assets/uploads/noFile.png";

            string connStr = ConfigurationManager.ConnectionStrings["ShabDB_connection"].ConnectionString;
            string imagePath = "/assets/uploads/noFile.png";
            int productId = 0;

            using (var conn = new SqlConnection(connStr))
            using (var cmd = new SqlCommand(
                "SELECT imagePath, productId FROM productsOptions WHERE id = @optionId", conn))
            {
                cmd.Parameters.AddWithValue("@optionId", Convert.ToInt32(productOptionIdObj));
                conn.Open();

                using (var rdr = cmd.ExecuteReader())
                {
                    if (rdr.Read())
                    {
                        // نحفظ الصورة الخاصة بالـ option
                        if (!rdr.IsDBNull(0))
                            imagePath = rdr.GetString(0);
                        // ونحفظ رقم المنتج المرتبط
                        if (!rdr.IsDBNull(1))
                            productId = rdr.GetInt32(1);
                    }
                }
            }

            return imagePath;
        }


        protected void GridProductOptions_CustomCallback(object sender, ASPxGridViewCustomCallbackEventArgs e)
        {
            var grid = sender as ASPxGridView;
            if (string.IsNullOrEmpty(e.Parameters))
                return;

            string[] parts = e.Parameters.Split('|');
            string command = parts[0];

            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ShabDB_connection"].ConnectionString))
            {
                conn.Open();

                if (command == "cancel") // 🟥 حالة الإلغاء
                {
                    int optionId = Convert.ToInt32(parts[1]);
                    int productId = 0;

                    // 0) استرجاع productId من الـ option
                    string getProductIdQuery = "SELECT productId FROM ProductsOptions WHERE id = @optionId";
                    using (SqlCommand cmdGet = new SqlCommand(getProductIdQuery, conn))
                    {
                        cmdGet.Parameters.AddWithValue("@optionId", optionId);
                        object result = cmdGet.ExecuteScalar();
                        if (result != null)
                            productId = Convert.ToInt32(result);
                    }

                    // 1) تصفير العرض في ProductsOptions
                    string updateOption = @"
                UPDATE ProductsOptions 
                SET offerPrice = 0, offerPercent = 0 
                WHERE id = @optionId";
                    using (SqlCommand cmd = new SqlCommand(updateOption, conn))
                    {
                        cmd.Parameters.AddWithValue("@optionId", optionId);
                        cmd.ExecuteNonQuery();
                    }

                    // 2) تحديد الـ virtual products المرتبطة بالخيار
                    string getVirtualProductQuery = "SELECT id FROM products WHERE parentOptionId = @optionId";
                    List<int> virtualProductIds = new List<int>();
                    using (SqlCommand cmdGetVirtual = new SqlCommand(getVirtualProductQuery, conn))
                    {
                        cmdGetVirtual.Parameters.AddWithValue("@optionId", optionId);
                        using (SqlDataReader reader = cmdGetVirtual.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                virtualProductIds.Add(Convert.ToInt32(reader["id"]));
                            }
                        }
                    }

                    // 3) تحديث حالة الـ virtual products بدل حذفها
                    if (virtualProductIds.Count > 0)
                    {
                        string markDeletedQuery = "UPDATE products SET isVirtualDeleted = 1, offerPrice = 0, offerPercent = 0 WHERE parentOptionId = @optionId";
                        using (SqlCommand cmdMarkDeleted = new SqlCommand(markDeletedQuery, conn))
                        {
                            cmdMarkDeleted.Parameters.AddWithValue("@optionId", optionId);
                            cmdMarkDeleted.ExecuteNonQuery();
                        }
                    }

                    // 4) إعادة تحميل البيانات في الجدول
                    grid.DataSourceID = "dsProductOptions";
                    if (productId > 0)
                    {
                        dsProductOptions.SelectParameters["productId"].DefaultValue = productId.ToString();
                    }
                }
                else // 🟢 حالة تحميل الخيارات (productId عادي)
                {
                    string productId = parts[0];
                    Session["ProductOptions_ProductId"] = productId;
                    dsProductOptions.SelectParameters["productId"].DefaultValue = productId;
                    grid.JSProperties["cpProductId"] = productId;
                    grid.DataSourceID = "dsProductOptions";
                    grid.DataBind();
                }
            }

            grid.DataBind();
        }


        protected void GridProductOptions_BatchUpdate(object sender, DevExpress.Web.Data.ASPxDataBatchUpdateEventArgs e)
        {
            string connStr = ConfigurationManager.ConnectionStrings["ShabDB_connection"].ConnectionString;
            string currentProductId = "0";

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                foreach (var update in e.UpdateValues)
                {
                    int optionId = 0;
                    if (!int.TryParse(update.Keys["id"]?.ToString(), out optionId))
                        continue; // تخطي هذا الصف إذا لم يكن ID صالح

                    decimal offerPrice = 0;
                    decimal offerPercent = 0;

                    if (update.NewValues["offerPrice"] != null)
                        decimal.TryParse(update.NewValues["offerPrice"].ToString(), out offerPrice);

                    if (update.NewValues["offerPercent"] != null)
                        decimal.TryParse(update.NewValues["offerPercent"].ToString(), out offerPercent);

                    // 1) اجلب بيانات الخيار من ProductsOptions
                    string optionQuery = "SELECT productOptionPrice, productOption, productId FROM ProductsOptions WHERE id = @optionId";
                    decimal optionPrice = 0;
                    string optionName = "";
                    int parentId = 0;

                    using (SqlCommand cmd = new SqlCommand(optionQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@optionId", optionId);
                        using (SqlDataReader r = cmd.ExecuteReader())
                        {
                            if (r.Read())
                            {
                                optionPrice = Convert.ToDecimal(r["productOptionPrice"]);
                                optionName = r["productOption"].ToString();
                                parentId = Convert.ToInt32(r["productId"]);
                                currentProductId = parentId.ToString();
                            }
                        }
                    }

                    // 2) تحقق إذا فيه منتج افتراضي مربوط بهذا الخيار
                    string checkQuery = "SELECT COUNT(*) FROM products WHERE parentOptionId = @optionId";
                    using (SqlCommand cmdCheck = new SqlCommand(checkQuery, conn))
                    {
                        cmdCheck.Parameters.AddWithValue("@optionId", optionId);
                        int exists = (int)cmdCheck.ExecuteScalar();

                        if (exists > 0)
                        {
                            // ✅ تحديث المنتج الحالي
                            string updateQuery = @"
                        UPDATE products
                        SET price = @price,
                            offerPrice = @offerPrice,
                            offerPercent = @offerPercent,
                            isVirtualDeleted = 0
                        WHERE parentOptionId = @optionId";

                            using (SqlCommand cmdUpdate = new SqlCommand(updateQuery, conn))
                            {
                                cmdUpdate.Parameters.AddWithValue("@price", optionPrice);
                                cmdUpdate.Parameters.AddWithValue("@offerPrice", offerPrice);
                                cmdUpdate.Parameters.AddWithValue("@offerPercent", offerPercent);
                                cmdUpdate.Parameters.AddWithValue("@optionId", optionId);
                                cmdUpdate.ExecuteNonQuery();
                            }
                        }
                        else
                        {
                            // ✅ إدخال منتج جديد مرتبط بالخيار
                            string insertQuery = @"
        INSERT INTO products (
            Name, NameEn, description, categoryId, subCategoryId,
            Price, offerPrice, offerPercent,
            isWeight, IsHasFlavors, isSpecial,
            countryId, companyId, uid,
            parentId, parentOptionId,
            isProductPrice, isVirtual, isVirtualDeleted,
            barcode, isVisible, rate, rateCount, userDate
        )
        OUTPUT INSERTED.id
        SELECT 
            Name + ' - ' + @optionName, 
            NameEn, description, categoryId, subCategoryId,
            @price, @offerPrice, @offerPercent,
            isWeight, IsHasFlavors, isSpecial,
            countryId, companyId, uid,
            @parentId, @optionId,
            isProductPrice, 1, 0,
            barcode, isVisible, rate, rateCount, GETDATE()
        FROM products
        WHERE id = @parentId";

                            int newProductId = 0;
                            using (SqlCommand cmdInsert = new SqlCommand(insertQuery, conn))
                            {
                                cmdInsert.Parameters.AddWithValue("@optionName", optionName);
                                cmdInsert.Parameters.AddWithValue("@price", optionPrice);
                                cmdInsert.Parameters.AddWithValue("@offerPrice", offerPrice);
                                cmdInsert.Parameters.AddWithValue("@offerPercent", offerPercent);
                                cmdInsert.Parameters.AddWithValue("@optionId", optionId);
                                cmdInsert.Parameters.AddWithValue("@parentId", parentId);

                                newProductId = Convert.ToInt32(cmdInsert.ExecuteScalar());
                            }

                            // ✅ جلب صورة الخيار من ProductsOptions.imagePath
                            string imagePath = "";
                            string getImageQuery = "SELECT imagePath FROM ProductsOptions WHERE id = @optionId";
                            using (SqlCommand cmdImg = new SqlCommand(getImageQuery, conn))
                            {
                                cmdImg.Parameters.AddWithValue("@optionId", optionId);
                                object imgResult = cmdImg.ExecuteScalar();
                                if (imgResult != null && imgResult != DBNull.Value)
                                    imagePath = imgResult.ToString();
                            }

                            // ✅ إذا لم تكن هناك صورة في ProductsOptions، اجلب الصورة من المنتج الرئيسي
                            if (string.IsNullOrEmpty(imagePath))
                            {
                                string getParentImageQuery = @"
        SELECT TOP 1 imagePath 
        FROM ProductsImages 
        WHERE productId = @parentId AND isDefault = 1
        ORDER BY id";

                                using (SqlCommand cmdParentImg = new SqlCommand(getParentImageQuery, conn))
                                {
                                    cmdParentImg.Parameters.AddWithValue("@parentId", parentId);
                                    object parentImgResult = cmdParentImg.ExecuteScalar();
                                    if (parentImgResult != null && parentImgResult != DBNull.Value)
                                        imagePath = parentImgResult.ToString();
                                }
                            }

                            // ✅ إدراج الصورة في ProductsImages إذا كانت موجودة
                            if (!string.IsNullOrEmpty(imagePath))
                            {
                                string insertImageQuery = @"
INSERT INTO ProductsImages (imagePath, isDefault, productId, userDate)
VALUES (@imagePath, 1, @productId, GETDATE())";

                                using (SqlCommand cmdImage = new SqlCommand(insertImageQuery, conn))
                                {
                                    cmdImage.Parameters.AddWithValue("@imagePath", imagePath);
                                    cmdImage.Parameters.AddWithValue("@productId", newProductId);
                                    cmdImage.ExecuteNonQuery();
                                }
                            }
                        }
                    }

                    // ✅ تحديث جدول الخيارات نفسه (ProductsOptions)
                    string updateOptionQuery = "UPDATE ProductsOptions SET offerPrice = @offerPrice, offerPercent = @offerPercent WHERE id = @id";
                    using (SqlCommand cmdOption = new SqlCommand(updateOptionQuery, conn))
                    {
                        cmdOption.Parameters.AddWithValue("@offerPrice", offerPrice);
                        cmdOption.Parameters.AddWithValue("@offerPercent", offerPercent);
                        cmdOption.Parameters.AddWithValue("@id", optionId);
                        cmdOption.ExecuteNonQuery();
                    }
                }
            }
            var grid = sender as ASPxGridView;
            if (!string.IsNullOrEmpty(currentProductId))
            {
                dsProductOptions.SelectParameters["productId"].DefaultValue = currentProductId;
            }
            grid.DataBind();


            e.Handled = true; // منع المعالجة الافتراضية
        }

    }
}