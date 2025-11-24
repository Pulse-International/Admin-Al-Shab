using DevExpress.Web;
using DevExpress.Web.Data;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.IO;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web;
using System.Web.Configuration;
using System.Web.Services.Description;
using System.Web.UI;
using System.Web.UI.WebControls;
using static MainHelper;



namespace ShabAdmin
{
    public partial class mUsers : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        protected void Page_Init(object sender, EventArgs e)
        {
            var (countryId, companyId) = GetUserPrivileges();

            // Clear all parameters before assigning new ones
            db_DeliveryUsers.SelectParameters.Clear();
            db_MachineUsers.SelectParameters.Clear();
            db_Products.SelectParameters.Clear();
            db_AppUsers.SelectParameters.Clear();
            db_countryName.SelectParameters.Clear();
            db_companyName.SelectParameters.Clear();

            if (countryId != 1000 && companyId != 1000)
            {
                db_DeliveryUsers.SelectCommand = @"
            SELECT id, username,email,firstName + ' ' + lastName AS fullName,  userPicture AS image, carPicture, carLicensePicture, idFrontPicture, idBackPicture, 
                   licensePicture, password, firstName, lastName, l_vehicleType, isActive, vehicleVin,l_DeliveryStatusId,incompleteNote,rejectNote,isUpdated vehicleNo, 
                   isOnline, countryId, userDate
            FROM [usersDelivery]
            WHERE countryId = @countryId";

                db_DeliveryUsers.SelectParameters.Add("countryId", countryId.ToString());

                db_MachineUsers.SelectCommand = @"
            SELECT id, username, password, firstName, lastName, isActive, countryId, companyId, branchId,userDate
            FROM [usersMachine]
            WHERE countryId = @countryId AND companyId = @companyId";

                db_MachineUsers.SelectParameters.Add("countryId", countryId.ToString());
                db_MachineUsers.SelectParameters.Add("companyId", companyId.ToString());

                db_Products.SelectCommand = @"
            SELECT id, name, countryId, companyId, rate, rateCount
            FROM [products]
            WHERE countryId = @countryId AND companyId = @companyId";

                db_Products.SelectParameters.Add("countryId", countryId.ToString());
                db_Products.SelectParameters.Add("companyId", companyId.ToString());

                db_AppUsers.SelectCommand = @"
            SELECT id, countryCode, firstName, LEFT(FCMToken, 5) AS FCMToken, userPlatform, lastName, username, isActive, balance, 
                   l_userLevelId, twoAuthenticationEnabled, userPoints, isDeleted, freeDeliveryCount,userDate
            FROM [usersApp]
            WHERE countryCode = (SELECT countryCode FROM countries WHERE id = @countryId)
            ORDER BY isDeleted ASC, id desc";

                db_AppUsers.SelectParameters.Add("countryId", countryId.ToString());

                db_countryName.SelectCommand = "SELECT id, countryName FROM countries WHERE id = @countryId";
                db_countryName.SelectParameters.Add("countryId", countryId.ToString());

                db_companyName.SelectCommand = "SELECT id, companyName FROM companies WHERE id = @companyId";
                db_companyName.SelectParameters.Add("companyId", companyId.ToString());

                db_branchName.SelectCommand = @"
    SELECT id, name 
    FROM [branches] 
    WHERE countryId = @countryId AND companyId = @companyId";

                db_branchName.SelectParameters.Add("countryId", countryId.ToString());
                db_branchName.SelectParameters.Add("companyId", companyId.ToString());

                db_productName.SelectCommand = @"
    SELECT id, name 
    FROM [products] 
    WHERE countryId = @countryId AND companyId = @companyId";

                db_productName.SelectParameters.Add("countryId", countryId.ToString());
                db_productName.SelectParameters.Add("companyId", companyId.ToString());
            }
            else if (countryId != 1000)
            {
                db_DeliveryUsers.SelectCommand = @"
            SELECT id, username,email,firstName + ' ' + lastName AS fullName,  userPicture AS image, carPicture, carLicensePicture, idFrontPicture, idBackPicture, 
                   licensePicture, password, firstName, lastName, l_vehicleType, isActive,l_DeliveryStatusId,incompleteNote,rejectNote,isUpdated, vehicleVin, vehicleNo, 
                   isOnline, countryId,userDate
            FROM [usersDelivery]
            WHERE countryId = @countryId";

                db_DeliveryUsers.SelectParameters.Add("countryId", countryId.ToString());

                db_MachineUsers.SelectCommand = @"
            SELECT id, username, password, firstName, lastName, isActive, countryId, companyId, branchId, userDate
            FROM [usersMachine]
            WHERE countryId = @countryId";

                db_MachineUsers.SelectParameters.Add("countryId", countryId.ToString());

                db_Products.SelectCommand = @"
            SELECT id, name, countryId, companyId, rate, rateCount
            FROM [products]
            WHERE countryId = @countryId";

                db_Products.SelectParameters.Add("countryId", countryId.ToString());

                db_AppUsers.SelectCommand = @"
            SELECT id, countryCode, firstName, LEFT(FCMToken, 5) AS FCMToken, userPlatform, lastName, username, isActive, balance, 
                   l_userLevelId, twoAuthenticationEnabled, userPoints, isDeleted, freeDeliveryCount, userDate
            FROM [usersApp]
            WHERE countryCode = (SELECT countryCode FROM countries WHERE id = @countryId)
            ORDER BY isDeleted ASC, id desc";

                db_AppUsers.SelectParameters.Add("countryId", countryId.ToString());

                db_countryName.SelectCommand = "SELECT id, countryName FROM countries WHERE id = @countryId";
                db_countryName.SelectParameters.Add("countryId", countryId.ToString());

                db_companyName.SelectCommand = "SELECT id, companyName FROM companies WHERE countryId = @countryId";
                db_companyName.SelectParameters.Add("countryId", countryId.ToString());

                db_branchName.SelectCommand = @"
    SELECT id, name 
    FROM [branches] 
    WHERE countryId = @countryId";

                db_branchName.SelectParameters.Add("countryId", countryId.ToString());

                db_productName.SelectCommand = @"
    SELECT id, name 
    FROM [products] 
    WHERE countryId = @countryId";

                db_productName.SelectParameters.Add("countryId", countryId.ToString());
            }
            else
            {
                // No filtering
                db_DeliveryUsers.SelectCommand = @"
            SELECT id, username,email,firstName + ' ' + lastName AS fullName,  userPicture AS image, carPicture, carLicensePicture, idFrontPicture, idBackPicture, 
                   licensePicture, password, firstName, lastName, l_vehicleType,l_DeliveryStatusId,incompleteNote,rejectNote,isUpdated, isActive, vehicleVin, vehicleNo, 
                   isOnline, countryId, userDate
            FROM [usersDelivery]";

                db_MachineUsers.SelectCommand = @"
            SELECT id, username, password, firstName, lastName, isActive, countryId, companyId, branchId, userDate
            FROM [usersMachine]";

                db_Products.SelectCommand = @"
            SELECT id, name, countryId, companyId, rate, rateCount
            FROM [products]";

                db_AppUsers.SelectCommand = @"
            SELECT id, countryCode, firstName, lastName, LEFT(FCMToken, 5) AS FCMToken, userPlatform, username, isActive, balance, 
                   l_userLevelId, twoAuthenticationEnabled, userPoints, isDeleted, freeDeliveryCount, userDate
            FROM [usersApp]
            ORDER BY isDeleted ASC, id desc";

                db_countryName.SelectCommand = "SELECT id, countryName FROM countries WHERE id <> 1000";
                db_companyName.SelectCommand = "SELECT id, companyName FROM companies WHERE id <> 1000";

                db_branchName.SelectCommand = "SELECT id, name FROM [branches]";
                db_productName.SelectCommand = "SELECT id, name FROM [products]";
            }
        }


        private (int countryId, int companyId) GetUserPrivileges()
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
                    string query = "SELECT privilegeCountryID, privilegeCompanyID FROM users WHERE username = @username";
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@username", username);
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                if (reader["privilegeCountryID"] != DBNull.Value)
                                    privilegeCountryID = Convert.ToInt32(reader["privilegeCountryID"]);
                                if (reader["privilegeCompanyID"] != DBNull.Value)
                                    privilegeCompanyID = Convert.ToInt32(reader["privilegeCompanyID"]);
                            }
                        }
                    }
                }
            }

            return (privilegeCountryID, privilegeCompanyID);
        }
        protected void GridMachineUsers_RowValidating(object sender, DevExpress.Web.Data.ASPxDataValidationEventArgs e)
        {
            string plainPassword = e.NewValues["password"]?.ToString();
            string oldPassword = e.OldValues.Contains("password") ? e.OldValues["password"]?.ToString() : null;

            bool isNewRow = e.IsNewRow;

            if (isNewRow)
            {
                if (string.IsNullOrWhiteSpace(plainPassword))
                {
                    e.RowError = "كلمة المرور مطلوبة";
                    return;
                }
            }

            int id = e.Keys["id"] != null ? Convert.ToInt32(e.Keys["id"]) : 0;
            string newUsername = e.NewValues["username"]?.ToString();
            string oldUsername = e.OldValues["username"]?.ToString();
            var grid = GridMachineUsers;

            if (string.IsNullOrWhiteSpace(newUsername))
            {
                e.RowError = "اسم المستخدم مطلوب";
                grid.JSProperties["cpUsernameError"] = e.RowError;
                return;
            }

            using (SqlConnection conn = new SqlConnection(WebConfigurationManager.ConnectionStrings["ShabDB_connection"].ConnectionString))
            {
                conn.Open();
                if (id == 0 || !string.Equals(newUsername, oldUsername, StringComparison.OrdinalIgnoreCase))
                {
                    using (SqlCommand cmd = new SqlCommand(
                        "SELECT COUNT(*) FROM usersMachine WHERE username = @username AND id <> @id", conn))
                    {
                        cmd.Parameters.AddWithValue("@username", newUsername ?? string.Empty);
                        cmd.Parameters.AddWithValue("@id", id);

                        int found = (int)cmd.ExecuteScalar();
                        if (found > 0)
                        {
                            string errorMsg = "اسم المستخدم موجود مسبقاً.";
                            e.RowError = errorMsg;
                            grid.JSProperties["cpUsernameError"] = errorMsg;
                        }
                    }
                }
            }
        }
        protected void GridMachineUsers_RowInserting(object sender, DevExpress.Web.Data.ASPxDataInsertingEventArgs e)
        {
            string plainPassword = e.NewValues["password"]?.ToString();
            HashSalt hashed = MainHelper.HashPassword(plainPassword);
            e.NewValues["password"] = hashed.Hash;
            e.NewValues["storedsalt"] = Convert.FromBase64String(hashed.Salt);
        }

        protected void GridMachineUsers_RowUpdating(object sender, DevExpress.Web.Data.ASPxDataUpdatingEventArgs e)
        {


            int id = (int)e.Keys["id"];
            string username = e.NewValues["username"]?.ToString();
            string plainPassword = e.NewValues["password"]?.ToString();
            string firstName = e.NewValues["firstName"]?.ToString();
            string lastName = e.NewValues["lastName"]?.ToString();
            bool isActive = Convert.ToBoolean(e.NewValues["isActive"]);
            int countryId = Convert.ToInt32(e.NewValues["countryId"]);
            int companyId = Convert.ToInt32(e.NewValues["companyId"]);
            int branchId = Convert.ToInt32(e.NewValues["branchId"]);

            string sql;
            List<SqlParameter> parameters = new List<SqlParameter>
    {
        new SqlParameter("@username", username),
        new SqlParameter("@firstName", firstName),
        new SqlParameter("@lastName", lastName),
        new SqlParameter("@isActive", isActive),
        new SqlParameter("@countryId", countryId),
        new SqlParameter("@companyId", companyId),
        new SqlParameter("@branchId", branchId),
        new SqlParameter("@id", id)
    };

            if (e.NewValues["password"] != e.OldValues["password"])
            {
                HashSalt hashed = MainHelper.HashPassword(plainPassword);
                sql = @"UPDATE [usersMachine]
                SET username = @username,
                    password = @password,
                    storedsalt = @storedsalt,
                    firstName = @firstName,
                    lastName = @lastName,
                    isActive = @isActive,
                    countryId = @countryId,
                    companyId = @companyId,
                    branchId = @branchId
                WHERE id = @id";
                parameters.Insert(1, new SqlParameter("@password", hashed.Hash));
                parameters.Insert(2, new SqlParameter("@storedsalt", Convert.FromBase64String(hashed.Salt)));
            }
            else
            {
                sql = @"UPDATE [usersMachine]
                SET username = @username,
                    firstName = @firstName,
                    lastName = @lastName,
                    isActive = @isActive,
                    countryId = @countryId,
                    companyId = @companyId,
                    branchId = @branchId
                WHERE id = @id";
            }

            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ShabDB_connection"].ConnectionString))
            using (SqlCommand cmd = new SqlCommand(sql, conn))
            {
                cmd.Parameters.AddRange(parameters.ToArray());
                conn.Open();
                cmd.ExecuteNonQuery();
            }

            e.Cancel = true;
            GridMachineUsers.CancelEdit();
            GridMachineUsers.DataBind();
        }


        protected void callbackApprove_Callback(object sender, DevExpress.Web.CallbackEventArgs e)
        {
            if (int.TryParse(e.Parameter, out int id))
            {
                string connStr = ConfigurationManager.ConnectionStrings["ShabDB_connection"].ConnectionString;
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();

                    SqlCommand cmd1 = new SqlCommand(@"
                UPDATE productsRates
                SET rateApproved = 1
                WHERE id = @id", conn);
                    cmd1.Parameters.AddWithValue("@id", id);
                    cmd1.ExecuteNonQuery();

                    SqlCommand getProductIdCmd = new SqlCommand("SELECT productId FROM productsRates WHERE id = @id", conn);
                    getProductIdCmd.Parameters.AddWithValue("@id", id);
                    int productId = Convert.ToInt32(getProductIdCmd.ExecuteScalar());

                    SqlCommand callProcedure = new SqlCommand("UpdateProductRates", conn);
                    callProcedure.CommandType = System.Data.CommandType.StoredProcedure;
                    callProcedure.Parameters.AddWithValue("@ProductId", productId);
                    callProcedure.ExecuteNonQuery();
                }

            }
        }
        protected void ApproveOrderRate_Callback(object sender, DevExpress.Web.CallbackEventArgs e)
        {
            if (int.TryParse(e.Parameter, out int id))
            {
                string connStr = ConfigurationManager.ConnectionStrings["ShabDB_connection"].ConnectionString;
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();

                    SqlCommand cmd1 = new SqlCommand(@"
                UPDATE orders
                SET rateApproved = 1
                WHERE id = @id", conn);
                    cmd1.Parameters.AddWithValue("@id", id);
                    cmd1.ExecuteNonQuery();

                    SqlCommand getCompanyIdCmd = new SqlCommand("SELECT companyId FROM orders WHERE id = @id", conn);
                    getCompanyIdCmd.Parameters.AddWithValue("@id", id);
                    int companyId = Convert.ToInt32(getCompanyIdCmd.ExecuteScalar());

                    SqlCommand callProcedure = new SqlCommand("UpdateCompanyRates", conn);
                    callProcedure.CommandType = System.Data.CommandType.StoredProcedure;
                    callProcedure.Parameters.AddWithValue("@CompanyId", companyId);
                    callProcedure.ExecuteNonQuery();
                }

            }
        }

        protected void GridMachineUsers_CellEditorInitialize(object sender, ASPxGridViewEditorEventArgs e)
        {
            if ((e.Column.FieldName == "password") && (!GridMachineUsers.IsNewRowEditing))
            {
                ASPxTextBox Password = e.Editor as ASPxTextBox;
                Password.Password = false;
            }
            if (e.Column.FieldName == "companyId")
            {
                ASPxComboBox combo = e.Editor as ASPxComboBox;

                if (GridMachineUsers.IsNewRowEditing)
                {
                    // New row: empty combo
                    combo.Items.Clear();
                }
                else
                {
                    // Edit row: filter companies by the row's countryId
                    object countryObj = GridMachineUsers.GetRowValues(e.VisibleIndex, "countryId");
                    int countryId = countryObj != null ? Convert.ToInt32(countryObj) : 0;
                    if (countryId > 0)
                    {
                        db_companyName.SelectCommand = "SELECT id, companyName FROM companies WHERE countryId = @countryId";
                        db_companyName.SelectParameters.Clear();
                        db_companyName.SelectParameters.Add("countryId", countryId.ToString());
                        combo.DataBind();
                    }
                    else
                    {
                        combo.Items.Clear(); // fallback: empty if no country
                    }
                }

                combo.Callback += (s, args) =>
                {
                    int countryId;
                    if (int.TryParse(args.Parameter, out countryId))
                    {
                        var (countryId1, companyId1) = GetUserPrivileges();
                        if (companyId1 != 1000)
                        {
                            db_companyName.SelectCommand = "SELECT id, companyName FROM companies WHERE countryId = @countryId AND id =@companyId ";
                            db_companyName.SelectParameters.Clear();
                            db_companyName.SelectParameters.Add("countryId", countryId.ToString());
                            db_companyName.SelectParameters.Add("companyId", companyId1.ToString());
                        }
                        else
                        {
                            db_companyName.SelectCommand = "SELECT id, companyName FROM companies WHERE countryId = @countryId";
                            db_companyName.SelectParameters.Clear();
                            db_companyName.SelectParameters.Add("countryId", countryId.ToString());
                        }
                        combo.DataBind();
                    }
                };
            }
            else if (e.Column.FieldName == "branchId")
            {
                ASPxComboBox combo = e.Editor as ASPxComboBox;

                if (GridMachineUsers.IsNewRowEditing)
                {
                    // New row: empty combo
                    combo.Items.Clear();
                }
                else
                {
                    // Edit row: filter branches by countryId and companyId
                    object countryObj = GridMachineUsers.GetRowValues(e.VisibleIndex, "countryId");
                    object companyObj = GridMachineUsers.GetRowValues(e.VisibleIndex, "companyId");
                    int countryId = countryObj != null ? Convert.ToInt32(countryObj) : 0;
                    int companyId = companyObj != null ? Convert.ToInt32(companyObj) : 0;
                    if (countryId > 0 && companyId > 0)
                    {
                        db_branchName.SelectCommand = "SELECT id, name FROM branches WHERE countryId = @countryId AND companyId = @companyId";
                        db_branchName.SelectParameters.Clear();
                        db_branchName.SelectParameters.Add("countryId", countryId.ToString());
                        db_branchName.SelectParameters.Add("companyId", companyId.ToString());
                        combo.DataBind();
                    }
                    else
                    {
                        combo.Items.Clear(); // fallback: empty if no country/company
                    }
                }

                combo.Callback += (s, args) =>
                {
                    string[] parts = args.Parameter.Split('|');
                    if (parts.Length == 2 && int.TryParse(parts[0], out int countryId) && int.TryParse(parts[1], out int companyId))
                    {
                        db_branchName.SelectCommand = "SELECT id, name FROM branches WHERE countryId = @countryId AND companyId = @companyId";
                        db_branchName.SelectParameters.Clear();
                        db_branchName.SelectParameters.Add("countryId", countryId.ToString());
                        db_branchName.SelectParameters.Add("companyId", companyId.ToString());
                        combo.DataBind();
                    }
                };
            }
        }


        protected void GridDeliveryUsers_RowValidating(object sender, DevExpress.Web.Data.ASPxDataValidationEventArgs e)
        {
            string plainPassword = e.NewValues["password"]?.ToString();
            string oldPassword = e.OldValues.Contains("password") ? e.OldValues["password"]?.ToString() : null;

            bool isNewRow = e.IsNewRow;

            if (isNewRow)
            {
                if (string.IsNullOrWhiteSpace(plainPassword))
                {
                    e.RowError = "كلمة المرور مطلوبة";
                    return;
                }
            }

            int id = e.Keys["id"] != null ? Convert.ToInt32(e.Keys["id"]) : 0;

            string newUsername = e.NewValues["username"]?.ToString();
            string newEmail = e.NewValues["email"]?.ToString();

            string oldUsername = e.OldValues["username"]?.ToString();
            string oldEmail = e.OldValues["email"]?.ToString();

            var grid = GridDeliveryUsers;

            using (SqlConnection conn = new SqlConnection(WebConfigurationManager.ConnectionStrings["ShabDB_connection"].ConnectionString))
            {
                conn.Open();

                if (id == 0 || !string.Equals(newUsername, oldUsername, StringComparison.OrdinalIgnoreCase))
                {
                    using (SqlCommand cmd = new SqlCommand(
                        "SELECT COUNT(*) FROM usersDelivery WHERE username = @username AND id <> @id", conn))
                    {
                        cmd.Parameters.AddWithValue("@username", newUsername ?? string.Empty);
                        cmd.Parameters.AddWithValue("@id", id);

                        int found = (int)cmd.ExecuteScalar();
                        if (found > 0)
                        {
                            var col = grid.Columns["username"] as DevExpress.Web.GridViewDataColumn;
                            string errorMsg = "اسم المستخدم موجود مسبقاً.";
                            if (col != null)
                                e.Errors[col] = errorMsg;
                            else
                                e.RowError = errorMsg;
                        }
                    }
                }

                if (id == 0 || !string.Equals(newEmail, oldEmail, StringComparison.OrdinalIgnoreCase))
                {
                    using (SqlCommand cmd = new SqlCommand(
                        "SELECT COUNT(*) FROM usersDelivery WHERE email = @Email AND id <> @id", conn))
                    {
                        cmd.Parameters.AddWithValue("@Email", newEmail ?? string.Empty);
                        cmd.Parameters.AddWithValue("@id", id);

                        int found = (int)cmd.ExecuteScalar();
                        if (found > 0)
                        {
                            var col = grid.Columns["email"] as DevExpress.Web.GridViewDataColumn;
                            string errorMsg = "البريد الإلكتروني مستخدم مسبقاً.";
                            if (col != null)
                                e.Errors[col] = errorMsg;
                            else
                                e.RowError = errorMsg;
                        }
                    }
                }

                
            }

            if (e.Errors.Count > 0 || !string.IsNullOrEmpty(e.RowError))
            {
                string message = e.RowError ?? "";
                foreach (var error in e.Errors.Values)
                {
                    message += "\n" + error.ToString();
                }

                GridDeliveryUsers.JSProperties["cpErrorMessage"] = message;
            }
        }

        protected void GridDeliveryUsers_RowInserting(object sender, DevExpress.Web.Data.ASPxDataInsertingEventArgs e)
        {
            string plainPassword = e.NewValues["password"]?.ToString();
            HashSalt hashed = MainHelper.HashPassword(plainPassword);
            e.NewValues["password"] = hashed.Hash;
            e.NewValues["storedsalt"] = Convert.FromBase64String(hashed.Salt);
        }

        protected void GridDeliveryUsers_RowUpdating(object sender, DevExpress.Web.Data.ASPxDataUpdatingEventArgs e)
        {

            string path = l_car_file.Text;
            int id = (int)e.Keys["id"];
            string username = e.NewValues["username"]?.ToString();
            string plainPassword = e.NewValues["password"]?.ToString();
            string firstName = e.NewValues["firstName"]?.ToString();
            string vehicleVin = e.NewValues["vehicleVin"]?.ToString();
            string vehicleNo = e.NewValues["vehicleNo"]?.ToString();
            string image = l_item_file.Text.ToString();
            string carPicture = l_car_file.Text.ToString();
            string carLicensePicture = l_carLicense_file.Text.ToString();
            string idFrontPicture = l_idFront_file.Text.ToString();
            string idBackPicture = l_idBack_file.Text.ToString();
            string licensePicture = l_license_file.Text.ToString();
            string lastName = e.NewValues["lastName"]?.ToString();
            string l_vehicleType = e.NewValues["l_vehicleType"]?.ToString();
            bool isActive = Convert.ToBoolean(e.NewValues["isActive"]);

            /////////////
            DeleteOldFileIfChanged(l_item_file_check.Text, l_item_file_old.Text);
            DeleteOldFileIfChanged(l_idFront_file_check.Text, l_idFront_file_old.Text);
            DeleteOldFileIfChanged(l_idBack_file_check.Text, l_idBack_file_old.Text);
            DeleteOldFileIfChanged(l_car_file_check.Text, l_car_file_old.Text);
            DeleteOldFileIfChanged(l_carLicense_file_check.Text, l_carLicense_file_old.Text);
            DeleteOldFileIfChanged(l_license_file_check.Text, l_license_file_old.Text);

            // reset checks
            l_item_file_check.Text = "0";
            l_idFront_file_check.Text = "0";
            l_idBack_file_check.Text = "0";
            l_car_file_check.Text = "0";
            l_carLicense_file_check.Text = "0";
            l_license_file_check.Text = "0";
            /////////////

            string sql;
            var parameters = new List<SqlParameter>
    {
        new SqlParameter("@username", username),
        new SqlParameter("@firstName", firstName),
        new SqlParameter("@lastName", lastName),
        new SqlParameter("@l_vehicleType", l_vehicleType),
        new SqlParameter("@isActive", isActive),
        new SqlParameter("@vehicleVin", vehicleVin),
        new SqlParameter("@vehicleNo", vehicleNo),
        new SqlParameter("@image", image),
        new SqlParameter("@carPicture", carPicture),
        new SqlParameter("@carLicensePicture", carLicensePicture),
        new SqlParameter("@idFrontPicture", idFrontPicture),
        new SqlParameter("@idBackPicture", idBackPicture),
        new SqlParameter("@licensePicture", licensePicture),
        new SqlParameter("@id", id)
    };

            if (e.NewValues["password"] != e.OldValues["password"])
            {
                HashSalt hashed = MainHelper.HashPassword(plainPassword);
                sql = @"UPDATE [usersDelivery]
                SET username = @username,
                    password = @password,
                    storedsalt = @storedsalt,
                    firstName = @firstName,
                    lastName = @lastName,
                    vehicleNo = @vehicleNo,
                    vehicleVin = @vehicleVin,
                    isActive = @isActive,
                    userPicture = @image,
                    l_vehicleType = @l_vehicleType,
                    carLicensePicture = @carLicensePicture,
                    idFrontPicture = @idFrontPicture,
                    idBackPicture = @idBackPicture,
                    licensePicture = @licensePicture,
                    carPicture = @carPicture
                WHERE id = @id";
                parameters.Add(new SqlParameter("@password", hashed.Hash));
                parameters.Add(new SqlParameter("@storedsalt", Convert.FromBase64String(hashed.Salt)));
            }
            else
            {
                sql = @"UPDATE [usersDelivery]
                SET username = @username,
                    firstName = @firstName,
                    lastName = @lastName,
                    vehicleNo = @vehicleNo,
                    vehicleVin = @vehicleVin,
                    isActive = @isActive,
                    userPicture = @image,
                    l_vehicleType = @l_vehicleType,
                    carLicensePicture = @carLicensePicture,
                    idFrontPicture = @idFrontPicture,
                    idBackPicture = @idBackPicture,
                    licensePicture = @licensePicture,
                    carPicture = @carPicture
                    WHERE id = @id";
            }

            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ShabDB_connection"].ConnectionString))
            using (SqlCommand cmd = new SqlCommand(sql, conn))
            {
                cmd.Parameters.AddRange(parameters.ToArray());
                conn.Open();
                cmd.ExecuteNonQuery();
            }

            e.Cancel = true;
            GridDeliveryUsers.CancelEdit();
            GridDeliveryUsers.DataBind();
        }
        void DeleteOldFileIfChanged(string fileCheck, string fileOld)
        {
            if (fileCheck == "1")
            {
                int pos = fileOld.LastIndexOf("/");
                if (pos > -1)
                {
                    string fileToDelete = fileOld.Substring(pos + 1);
                    string[] fileList = Directory.GetFiles(Server.MapPath("~/assets/uploads/delivery-users"), fileToDelete);
                    foreach (string file in fileList)
                        System.IO.File.Delete(file);
                }
            }
        }

        string fileName = string.Empty;
        int checkError = 0;

        protected void ImageUpload_FileUploadComplete(object sender, FileUploadCompleteEventArgs e)
        {
            e.CallbackData = SavePostedFile_all(e.UploadedFile);

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
            string UploadDirectory = "/assets/uploads/delivery-users/";
            string Docs = Guid.NewGuid().ToString() + ".jpg";
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

        protected void GridDeliveryUsers_CancelRowEditing(object sender, ASPxStartRowEditingEventArgs e)
        {
            if (l_item_file_check.Text == "1")
            {
                DeleteUploadedFile(l_item_file.Text);
                l_item_file_check.Text = "0";
            }
            if (l_car_file_check.Text == "1")
            {
                DeleteUploadedFile(l_car_file.Text);
                l_car_file_check.Text = "0";
            }

            if (l_carLicense_file_check.Text == "1")
            {
                DeleteUploadedFile(l_carLicense_file.Text);
                l_carLicense_file_check.Text = "0";
            }

            if (l_idFront_file_check.Text == "1")
            {
                DeleteUploadedFile(l_idFront_file.Text);
                l_idFront_file_check.Text = "0";
            }

            if (l_idBack_file_check.Text == "1")
            {
                DeleteUploadedFile(l_idBack_file.Text);
                l_idBack_file_check.Text = "0";
            }
            if (l_license_file_check.Text == "1")
            {
                DeleteUploadedFile(l_license_file.Text);
                l_license_file_check.Text = "0";
            }

        }

        protected void GridDeliveryUsers_RowDeleting(object sender, ASPxDataDeletingEventArgs e)
        {
            DeleteUploadedFile(e.Values["image"]?.ToString());
            DeleteUploadedFile(e.Values["carPicture"]?.ToString());
            DeleteUploadedFile(e.Values["carLicensePicture"]?.ToString());
            DeleteUploadedFile(e.Values["idFrontPicture"]?.ToString());
            DeleteUploadedFile(e.Values["idBackPicture"]?.ToString());
            DeleteUploadedFile(e.Values["licensePicture"]?.ToString());
        }
        private void DeleteUploadedFile(string filePath)
        {
            if (string.IsNullOrWhiteSpace(filePath))
                return;


            int pos = filePath.LastIndexOf("/");
            if (pos < 0) return;

            string fileToDelete = filePath.Substring(pos + 1);
            string[] fileList = Directory.GetFiles(Server.MapPath("~/assets/uploads/delivery-users"), fileToDelete);
            foreach (string file in fileList)
            {
                File.Delete(file);
            }

        }

        protected void GridDeliveryUsers_HtmlDataCellPrepared(object sender, ASPxGridViewTableDataCellEventArgs e)
        {
            if (e.DataColumn.FieldName == "password")
            {
                e.Cell.Text = "***********";
            }
        }
        protected void GridMachineUsers_HtmlDataCellPrepared(object sender, ASPxGridViewTableDataCellEventArgs e)
        {
            if (e.DataColumn.FieldName == "password")
            {
                e.Cell.Text = "***********";
            }
        }

        protected void GridDeliveryUsers_CellEditorInitialize(object sender, ASPxGridViewEditorEventArgs e)
        {
            if ((e.Column.FieldName == "password") && (!GridDeliveryUsers.IsNewRowEditing))
            {
                ASPxTextBox Password = e.Editor as ASPxTextBox;
                Password.Password = false;
            }
        }

        protected void GridUsers_HtmlDataCellPrepared(object sender, ASPxGridViewTableDataCellEventArgs e)
        {
            if (e.DataColumn.FieldName == "isDeleted")
            {
                bool isDeleted = Convert.ToBoolean(e.GetValue("isDeleted"));
                if (isDeleted)
                {
                    e.Cell.BackColor = System.Drawing.Color.Red;
                    e.Cell.ForeColor = System.Drawing.Color.White;
                }
            }
            if (e.DataColumn.FieldName == "isActive")
            {
                bool isActive = Convert.ToBoolean(e.GetValue("isActive"));
                if (isActive)
                {
                    e.Cell.ForeColor = System.Drawing.Color.Green;
                    e.Cell.Font.Bold = true;
                }
                else
                {
                    e.Cell.ForeColor = System.Drawing.Color.Red;
                    e.Cell.Font.Bold = true;
                }
            }
        }

        protected string GetLottieMarkup(object l_vehicleType)
        {
            string type = l_vehicleType?.ToString();
            string markup = "";

            if (type == "1")
            {
                // Car - Use image
                markup = "<img src='/assets/animations/car.png' style='width: 80px; height: 80px;' />";
            }
            else if (type == "2")
            {
                // Bike - Use Lottie animation
                markup = @"
                <lottie-player 
                    src='/assets/animations/bike.json' 
                    background='transparent'  
                    speed='1'  
                    style='width: 80px; height: 80px;'  
                    loop autoplay>
                </lottie-player>";
            }
            else
            {
                // Default - Use fallback animation
                markup = @"
                <lottie-player 
                    src='/assets/animations/default.json' 
                    background='transparent'  
                    speed='1'  
                    style='width: 80px; height: 80px;'  
                    loop autoplay>
                </lottie-player>";
            }

            return markup;
        }

        protected void GridDeliveryUsers_CustomCallback(object sender, ASPxGridViewCustomCallbackEventArgs e)
        {
            string[] parts = e.Parameters.Split(':');

            string action = parts[0];
            int userId = int.Parse(parts[1]);
            string note = parts.Length > 2 ? parts[2] : "";

            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ShabDB_connection"].ConnectionString))
            {
                conn.Open();
                SqlCommand cmd = null;

                switch (action)
                {
                    case "approve":
                        cmd = new SqlCommand(
                            "UPDATE usersDelivery SET l_deliveryStatusId=3,isActive=1 WHERE id=@id", conn);

                        SendSmsBackground("962798579769", "تم الموافقة عليك اخي");

                        break;

                    case "reject":
                        cmd = new SqlCommand(
                            "UPDATE usersDelivery SET l_deliveryStatusId=4, rejectNote=@note WHERE id=@id", conn);

                        SendSmsBackground("962798579769", "مرفوضة يمعلم");

                        cmd.Parameters.AddWithValue("@note", note);
                        break;

                    case "incomplete":
                        cmd = new SqlCommand(
                            "UPDATE usersDelivery SET l_deliveryStatusId=@status, incompleteNote=@note WHERE id=@id", conn);
                        cmd.Parameters.AddWithValue("@status", 2);
                        cmd.Parameters.AddWithValue("@note", note);

                        // توليد الرابط المشفر
                        string encryptedUserId = MainHelper.Encrypt_Me(userId.ToString(), true);
                        string baseUrl = $"https://www.alshaeb.net";
                        string longUrl = $"{baseUrl}/registerDriver/{encryptedUserId}";

                        // صياغة رسالة SMS
                        string smsMessage = $"طلبك غير مكتمل اضغط الرابط لاستكمال الطلب: {longUrl}";

                        string isGdApi = $"https://is.gd/create.php?format=simple&url={longUrl}";

                        // إرسال SMS في الخلفية مع اختصار الرابط
                        Task.Run(async () =>
                        {
                            try
                            {
                                string shortUrl = longUrl; // افتراضي
                                isGdApi = $"https://is.gd/create.php?format=simple&url={longUrl}";

                                using (var client = new WebClient())
                                {
                                    shortUrl = await client.DownloadStringTaskAsync(isGdApi);
                                }

                                string shortMessage = $"طلبك غير مكتمل اضغط الرابط لاستكمال الطلب: {shortUrl}";
                                await MainHelper.SendSms("962798579769", shortMessage);
                            }
                            catch
                            {
                                // لو فشل الاختصار، نرسل الرابط الطويل
                                await MainHelper.SendSms("962798579769", smsMessage);
                            }
                        });

                        break;


                }

                cmd.Parameters.AddWithValue("@id", userId);
                cmd.ExecuteNonQuery();
            }

            GridDeliveryUsers.DataBind();
        }

        protected void GridDeliveryUsers_HtmlRowPrepared(object sender, ASPxGridViewTableRowEventArgs e)
        {
            if (e.RowType != DevExpress.Web.GridViewRowType.Data) return;

            int statusId = Convert.ToInt32(GridDeliveryUsers.GetRowValues(e.VisibleIndex, "l_DeliveryStatusId"));
            int recordId = Convert.ToInt32(GridDeliveryUsers.GetRowValues(e.VisibleIndex, "id"));
            int isUpdated = Convert.ToInt32(GridDeliveryUsers.GetRowValues(e.VisibleIndex, "isUpdated"));

            ASPxButton btnApprove = (ASPxButton)GridDeliveryUsers.FindRowCellTemplateControl(e.VisibleIndex, null, "btnApprove");
            ASPxButton btnReject = (ASPxButton)GridDeliveryUsers.FindRowCellTemplateControl(e.VisibleIndex, null, "btnReject");
            ASPxButton btnIncomplete = (ASPxButton)GridDeliveryUsers.FindRowCellTemplateControl(e.VisibleIndex, null, "btnIncomplete");
            ASPxButton btnIncompleteBulb = (ASPxButton)GridDeliveryUsers.FindRowCellTemplateControl(e.VisibleIndex, null, "btnIncompleteBulb");
            ASPxLabel lblStatus = (ASPxLabel)GridDeliveryUsers.FindRowCellTemplateControl(e.VisibleIndex, null, "lblStatus");

            // إعدادات الأزرار حسب الحالة
            if (statusId == 3)
            {
                lblStatus.Text = "تم الموافقة";
                lblStatus.ForeColor = System.Drawing.Color.FromArgb(0x28, 0xa7, 0x45);
                lblStatus.Font.Bold = true;
                lblStatus.Font.Size = 15;
                lblStatus.Font.Name = "Cairo";

                btnApprove.Visible = btnReject.Visible = btnIncomplete.Visible = btnIncompleteBulb.ClientVisible = false;
            }
            else if (statusId == 4)
            {
                lblStatus.Text = "مرفوض";
                lblStatus.ForeColor = System.Drawing.Color.FromArgb(0xdc, 0x35, 0x45);
                lblStatus.Font.Bold = true;
                lblStatus.Font.Size = 15;
                lblStatus.Font.Name = "Cairo";

                btnApprove.Visible = btnReject.Visible = btnIncomplete.Visible = btnIncompleteBulb.ClientVisible = false;
            }
            else
            {
                lblStatus.Text = "";

                btnApprove.ClientSideEvents.Click = $"function(s,e){{ ShowASPXPopup('approve',{recordId}); }}";
                btnReject.ClientSideEvents.Click = $"function(s,e){{ ShowASPXPopup('reject',{recordId}); }}";

                // إذا المستخدم حدث بياناته
                if (statusId == 2 && isUpdated == 1)
                {
                    btnIncomplete.Visible = false;
                    btnIncompleteBulb.ClientVisible = true;
                    btnIncompleteBulb.Text = HttpUtility.HtmlEncode("غير مكتمل") + "<br/>" + HttpUtility.HtmlEncode("تم التحديث");
                    btnIncompleteBulb.ClientSideEvents.Init = "function(s, e) { s.GetMainElement().innerHTML = 'غير مكتمل<br/>تم التحديث'; }";
                    btnIncompleteBulb.ClientSideEvents.Click = $"function(s,e){{ ShowASPXPopup('incomplete',{recordId}); }}";
                }
                else
                {
                    btnIncomplete.Visible = true;
                    btnIncompleteBulb.ClientVisible = false;
                    btnApprove.Enabled = false;
                    btnReject.Enabled = false;
                    btnIncomplete.ClientSideEvents.Click = $"function(s,e){{ ShowASPXPopup('incomplete',{recordId}); }}";
                }
            }
        }



    }
}