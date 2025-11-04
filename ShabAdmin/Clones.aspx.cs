using DevExpress.Web;
using DevExpress.Web.Data;
using System;
using System.Collections;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ShabAdmin
{
    public partial class Clones : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        protected void cloneCallback_Callback(object sender, CallbackEventArgsBase e)
        {
            string webRoot = HttpRuntime.AppDomainAppPath;

            try
            {
                using (var con = new SqlConnection(ConfigurationManager.ConnectionStrings["ShabDB_connection"].ToString()))
                {
                    con.Open();

                    // Get product mappings and images to delete
                    var map = new List<(int OldId, int NewId)>();
                    var imagesToDelete = new List<string>();

                    using (var cmd = new SqlCommand("InsertProductRecords", con))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.Add("@SourceCountryId", SqlDbType.Int).Value = Convert.ToInt32(SourceCountry.Value);
                        cmd.Parameters.Add("@TargetCountryId", SqlDbType.Int).Value = Convert.ToInt32(TargetCountry.Value);
                        if (SourceCompany.Value != null)
                            cmd.Parameters.Add("@SourceCompanyId", SqlDbType.Int).Value = Convert.ToInt32(SourceCompany.Value);
                        if (TargetCompany.Value != null)
                            cmd.Parameters.Add("@TargetCompanyId", SqlDbType.Int).Value = Convert.ToInt32(TargetCompany.Value);

                        using (var rdr = cmd.ExecuteReader())
                        {
                            // First result set: mappings
                            while (rdr.Read())
                            {
                                string entity = rdr.GetString(0);
                                if (entity == "Product")
                                {
                                    map.Add((rdr.GetInt32(1), rdr.GetInt32(2)));
                                }
                            }

                            // Second result set: images to delete
                            if (rdr.NextResult())
                            {
                                while (rdr.Read())
                                {
                                    string imagePath = rdr.GetString(0);
                                    if (!string.IsNullOrWhiteSpace(imagePath))
                                    {
                                        imagesToDelete.Add(imagePath);
                                    }
                                }
                            }
                        }
                    }

                    if (map.Count == 0) return;

                    // Extract old product IDs for bulk queries
                    var oldProductIds = map.Select(m => m.OldId).ToArray();
                    var oldIdsParam = string.Join(",", oldProductIds);

                    // BULK COPY IMAGES
                    var imageInsertSql = new StringBuilder();
                    var imageParams = new List<SqlParameter>();
                    int imageParamIndex = 0;

                    using (var imgCmd = new SqlCommand($@"
                SELECT productId, imagePath, isDefault 
                FROM productsImages 
                WHERE productId IN ({oldIdsParam})", con))
                    {
                        using (var imgRdr = imgCmd.ExecuteReader())
                        {
                            var imagesToProcess = new List<(int OldProductId, int NewProductId, string ImagePath, bool IsDefault)>();

                            while (imgRdr.Read())
                            {
                                int oldProductId = imgRdr.GetInt32(0);
                                string oldDbPath = imgRdr.IsDBNull(1) ? null : imgRdr.GetString(1);
                                bool isDefault = !imgRdr.IsDBNull(2) && imgRdr.GetBoolean(2);

                                if (!string.IsNullOrWhiteSpace(oldDbPath))
                                {
                                    int newProductId = map.First(m => m.OldId == oldProductId).NewId;
                                    imagesToProcess.Add((oldProductId, newProductId, oldDbPath, isDefault));
                                }
                            }

                            imgRdr.Close();

                            // Process images in parallel
                            var processedImages = new ConcurrentBag<(int NewProductId, string NewPath, bool IsDefault)>();

                            Parallel.ForEach(imagesToProcess, imageInfo =>
                            {
                                try
                                {
                                    string physicalOld = GetPhysicalPath(imageInfo.ImagePath, webRoot);
                                    if (File.Exists(physicalOld))
                                    {
                                        string newPath = CopyImageFile(physicalOld, webRoot);
                                        if (!string.IsNullOrEmpty(newPath))
                                        {
                                            processedImages.Add((imageInfo.NewProductId, newPath, imageInfo.IsDefault));
                                        }
                                    }
                                }
                                catch { /* Skip failed image copies */ }
                            });

                            // Build bulk insert for images
                            foreach (var img in processedImages)
                            {
                                if (imageInsertSql.Length > 0) imageInsertSql.Append(" UNION ALL ");
                                imageInsertSql.Append($"SELECT @pid{imageParamIndex}, @path{imageParamIndex}, @def{imageParamIndex}, GETDATE()");

                                imageParams.Add(new SqlParameter($"@pid{imageParamIndex}", SqlDbType.Int) { Value = img.NewProductId });
                                imageParams.Add(new SqlParameter($"@path{imageParamIndex}", SqlDbType.NVarChar, 500) { Value = img.NewPath });
                                imageParams.Add(new SqlParameter($"@def{imageParamIndex}", SqlDbType.Bit) { Value = img.IsDefault });
                                imageParamIndex++;
                            }
                        }
                    }

                    // Execute bulk image insert
                    if (imageInsertSql.Length > 0)
                    {
                        using (var bulkImgCmd = new SqlCommand($@"
                    INSERT INTO productsImages (productId, imagePath, isDefault, userDate)
                    {imageInsertSql}", con))
                        {
                            bulkImgCmd.Parameters.AddRange(imageParams.ToArray());
                            bulkImgCmd.ExecuteNonQuery();
                        }
                    }

                    // BULK COPY EXTRAS
                    BulkCopyExtrasOrOptions("productsExtra", "productExtra", "productExtraPrice", oldIdsParam, map, con, webRoot);

                    // BULK COPY OPTIONS  
                    BulkCopyExtrasOrOptions("productsOptions", "productOption", "productOptionPrice", oldIdsParam, map, con, webRoot);

                    // DELETE PHYSICAL IMAGES
                    DeletePhysicalImages(imagesToDelete, webRoot);
                }

                cloneCallback.JSProperties["cpResult"] = 1;
            }
            catch (Exception ex)
            {
                // Log the exception for debugging
                System.Diagnostics.Debug.WriteLine($"Clone error: {ex.Message}");
                cloneCallback.JSProperties["cpResult"] = 0;
            }
        }

        private void DeletePhysicalImages(List<string> imagePaths, string webRoot)
        {
            if (imagePaths == null || imagePaths.Count == 0)
                return;

            int deletedCount = 0;
            int failedCount = 0;

            Parallel.ForEach(imagePaths, imagePath =>
            {
                try
                {
                    string physicalPath = GetPhysicalPath(imagePath, webRoot);

                    if (File.Exists(physicalPath))
                    {
                        File.Delete(physicalPath);
                        Interlocked.Increment(ref deletedCount);
                    }
                }
                catch (Exception ex)
                {
                    // Log individual file deletion errors
                    System.Diagnostics.Debug.WriteLine($"Failed to delete image {imagePath}: {ex.Message}");
                    Interlocked.Increment(ref failedCount);
                }
            });

            // Log summary
            System.Diagnostics.Debug.WriteLine($"Image deletion complete. Deleted: {deletedCount}, Failed: {failedCount}");
        }

        private void BulkCopyExtrasOrOptions(string tableName, string textColumn, string priceColumn,
            string oldIdsParam, List<(int OldId, int NewId)> map, SqlConnection con, string webRoot)
        {
            var insertSql = new StringBuilder();
            var parameters = new List<SqlParameter>();
            int paramIndex = 0;

            using (var cmd = new SqlCommand($@"
        SELECT productId, {textColumn}, {priceColumn}, imagePath, barcode
        FROM {tableName}
        WHERE productId IN ({oldIdsParam})", con))
            {
                using (var rdr = cmd.ExecuteReader())
                {
                    var itemsToProcess = new List<(int OldProductId, int NewProductId, string Text, decimal? Price, string ImagePath, string Barcode)>();

                    while (rdr.Read())
                    {
                        int oldProductId = rdr.GetInt32(0);
                        string text = rdr.IsDBNull(1) ? null : rdr.GetString(1);
                        decimal? price = rdr.IsDBNull(2) ? (decimal?)null : Convert.ToDecimal(rdr.GetValue(2));
                        string imagePath = rdr.IsDBNull(3) ? null : rdr.GetString(3);
                        string barcode = rdr.IsDBNull(4) ? null : rdr.GetString(4);

                        int newProductId = map.First(m => m.OldId == oldProductId).NewId;
                        itemsToProcess.Add((oldProductId, newProductId, text, price, imagePath, barcode));
                    }

                    rdr.Close();

                    // Process images in parallel if needed
                    var processedItems = new ConcurrentBag<(int NewProductId, string Text, decimal? Price, string NewImagePath, string Barcode)>();

                    Parallel.ForEach(itemsToProcess, item =>
                    {
                        string newImagePath = null;
                        if (!string.IsNullOrWhiteSpace(item.ImagePath))
                        {
                            try
                            {
                                string physicalOld = GetPhysicalPath(item.ImagePath, webRoot);
                                if (File.Exists(physicalOld))
                                {
                                    newImagePath = CopyImageFile(physicalOld, webRoot);
                                }
                            }
                            catch { /* Skip failed image copies */ }
                        }

                        processedItems.Add((item.NewProductId, item.Text, item.Price, newImagePath, item.Barcode));
                    });

                    // Build bulk insert
                    foreach (var item in processedItems)
                    {
                        if (insertSql.Length > 0) insertSql.Append(" UNION ALL ");
                        insertSql.Append($"SELECT @text{paramIndex}, @price{paramIndex}, @img{paramIndex}, @pid{paramIndex}, @barcode{paramIndex}, GETDATE()");

                        parameters.Add(new SqlParameter($"@text{paramIndex}", SqlDbType.NVarChar, -1) { Value = (object)item.Text ?? DBNull.Value });
                        var priceParam = new SqlParameter($"@price{paramIndex}", SqlDbType.Decimal) { Value = (object)item.Price ?? DBNull.Value };
                        priceParam.Precision = 18; priceParam.Scale = 3;
                        parameters.Add(priceParam);
                        parameters.Add(new SqlParameter($"@img{paramIndex}", SqlDbType.NVarChar, 500) { Value = (object)item.NewImagePath ?? DBNull.Value });
                        parameters.Add(new SqlParameter($"@pid{paramIndex}", SqlDbType.Int) { Value = item.NewProductId });
                        parameters.Add(new SqlParameter($"@barcode{paramIndex}", SqlDbType.NVarChar, 100) { Value = (object)item.Barcode ?? DBNull.Value });
                        paramIndex++;
                    }
                }
            }

            // Execute bulk insert
            if (insertSql.Length > 0)
            {
                string insertColumns = tableName == "productsExtra"
                    ? "productExtra, productExtraPrice, imagePath, productId, barcode, userDate"
                    : "productOption, productOptionPrice, imagePath, productId, barcode, userDate";

                using (var bulkCmd = new SqlCommand($@"
            INSERT INTO {tableName} ({insertColumns})
            {insertSql}", con))
                {
                    bulkCmd.Parameters.AddRange(parameters.ToArray());
                    bulkCmd.ExecuteNonQuery();
                }
            }
        }
        private string GetPhysicalPath(string dbPath, string webRoot)
        {
            if (dbPath.StartsWith("~"))
                return Server.MapPath(dbPath);

            if (dbPath.StartsWith("/"))
                return Path.Combine(webRoot, dbPath.TrimStart('/').Replace('/', Path.DirectorySeparatorChar));

            if (Path.IsPathRooted(dbPath))
                return dbPath;

            return Path.Combine(webRoot, dbPath.Replace('/', Path.DirectorySeparatorChar));
        }

        private string CopyImageFile(string physicalOld, string webRoot)
        {
            string dir = Path.GetDirectoryName(physicalOld);
            string ext = Path.GetExtension(physicalOld);
            string newFileName = $"{Guid.NewGuid():N}{ext}";
            string physicalNew = Path.Combine(dir ?? webRoot, newFileName);

            File.Copy(physicalOld, physicalNew, false);

            string appRelativeDir = dir != null && dir.StartsWith(webRoot, StringComparison.OrdinalIgnoreCase)
                ? dir.Substring(webRoot.Length).TrimStart(Path.DirectorySeparatorChar).Replace(Path.DirectorySeparatorChar, '/')
                : string.Empty;

            return $"/{appRelativeDir}/{newFileName}".Replace("//", "/");
        }


        protected void checkClone_Callback(object sender, CallbackEventArgsBase e)
        {
            string[] para = e.Parameter.Split('|');
            DataView dv = new DataView();
            DataTable dt = new DataTable();
            DB_CheckCountries.SelectParameters["countryID"].DefaultValue = para[0];
            dv = DB_CheckCountries.Select(DataSourceSelectArguments.Empty) as DataView;
            if (dv != null && dv.Count != 0)
            {
                dt = dv.ToTable();
                if (dt.Rows[0][0].ToString() == "1") // compnay and branch are exist
                {
                    Btn_Del_Branches.Enabled = true;
                    checkClone.JSProperties["cpResultCheck"] = 1;
                }
                else
                {
                    Btn_Del_Branches.Enabled = false;
                    checkClone.JSProperties["cpResultCheck"] = 0;
                }
            }

            if (para[1] == "source")
                checkClone.JSProperties["cpResultControl"] = 1;
            else
                checkClone.JSProperties["cpResultControl"] = 2;
        }

        protected void SourceCompany_Callback(object sender, CallbackEventArgsBase e)
        {
            DataView dv = new DataView();
            DataTable dt = new DataTable();
            DB_GetCompanies.SelectParameters["countryId"].DefaultValue = e.Parameter;
            dv = DB_GetCompanies.Select(DataSourceSelectArguments.Empty) as DataView;
            if (dv != null && dv.Count != 0)
            {
                SourceCompany.DataBind();
            }
            else
            {
                DB_GetCompanies.SelectParameters["countryId"].DefaultValue = "0";
                SourceCompany.DataBind();
            }
        }

        protected void TargetCompany_Callback(object sender, CallbackEventArgsBase e)
        {
            DataView dv = new DataView();
            DataTable dt = new DataTable();
            DB_GetCompanies.SelectParameters["countryId"].DefaultValue = e.Parameter;
            dv = DB_GetCompanies.Select(DataSourceSelectArguments.Empty) as DataView;
            if (dv != null && dv.Count != 0)
            {
                TargetCompany.DataBind();
            }
            else
            {
                DB_GetCompanies.SelectParameters["countryId"].DefaultValue = "0";
                TargetCompany.DataBind();
            }
        }
    }
}