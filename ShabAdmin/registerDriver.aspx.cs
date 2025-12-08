using DevExpress.Web;
using DevExpress.Web.Internal;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Net.Http;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;
using System.Web;
using System.Web.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml.Linq;

namespace ShabAdmin
{
    public partial class lDriverRegisteration : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string encryptedId = Request.QueryString["id"];
                string realId = "";
                bool isEdit = !string.IsNullOrEmpty(encryptedId);
                if (!string.IsNullOrEmpty(encryptedId))
                {
                    realId = MainHelper.Decrypt_Me(encryptedId, true);
                }
                if (isEdit)
                {
                    LoadDriverData(realId);
                    divEditTitle.Visible = false;
                    userinfo.Visible = true;
                    editBadge.Visible = true;
                    note.Visible = true;
                    divAddTitle.Visible = false;
                    btnSubmit.Visible = false;
                    btnUpdate.Visible = true;
                    notePopup.ShowOnPageLoad = true;
                    nextbutton.Visible = false;
                    beforeAndAfter.Visible = false;

                    // --- التعديلات لوضع التحديث (Server Side Logic) ---
                    EditModeSidebar.Visible = true;
                    stepperContainer.Visible = false;
                    mainCardPanel.Attributes["class"] += " edit-layout";

                    string script = @"
                    <script type='text/javascript'>
                        setTimeout(function() {
                            // تفعيل التبويب الأول افتراضياً
                            var firstTab = document.querySelector('.sidebar-item');
                            if(firstTab) switchEditTab(1, firstTab);

                            // إظهار زر التحديث
                            var editNav = document.querySelector('.edit-mode-nav');
                            if (editNav) editNav.style.display = 'flex';
                        }, 100);
                    </script>";

                    Page.ClientScript.RegisterStartupScript(this.GetType(), "EditModeSetup", script, false);
                }
                else
                {
                    userinfo.Visible = false;
                    note.Visible = false;
                    divAddTitle.Visible = true;
                    divEditTitle.Visible = false;
                    btnSubmit.Visible = true;
                    btnUpdate.Visible = false;
                    EditModeSidebar.Visible = false;
                    editBadge.Visible = false;
                }
            }
        }

        public void LoadDriverData(string id)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["ShabDBConnectionString"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"select * from usersDelivery where id = @integerid";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@integerid", id);

                    conn.Open();
                    SqlDataReader rdr = cmd.ExecuteReader();

                    if (rdr.Read())
                    {
                        txtPhone.Text = rdr["username"].ToString();
                        txtFirstName.Text = rdr["firstName"].ToString();
                        txtLastName.Text = rdr["lastName"].ToString();
                        txtEmail.Text = rdr["email"].ToString();

                        // تحميل القيم في الـ DropDowns
                        // نستخدم Value لضمان التحديد الصحيح
                        documentType.Value = rdr["l_documentType"].ToString();
                        gender.Value = rdr["l_gender"].ToString();
                        systemKind.Value = rdr["userPlatform"].ToString();

                        documentnumber.Text = rdr["documentNo"].ToString();
                        carmarka.Text = rdr["vehicleModel"].ToString();
                        nerbyname.Text = rdr["referenceName"].ToString();
                        nerbynumber.Text = rdr["referenceMobile"].ToString();

                        int countryId = Convert.ToInt32(rdr["countryId"]);
                        if (countryId == 1)
                        {
                            ddlCity.Value = "الأردن";
                            string scriptMask = @"
                                setTimeout(function() {
                                    if (typeof coutryid !== 'undefined' && typeof changemask === 'function') {
                                        changemask(coutryid, null);
                                    }
                                }, 300);
                            ";
                            ClientScript.RegisterStartupScript(this.GetType(), "ActivateMask", scriptMask, true);
                        }

                        string vehicleNo = rdr["vehicleNo"].ToString();
                        if (countryId == 1 && vehicleNo.Length == 7)
                        {
                            vehicleNo = vehicleNo.Substring(0, 2) + "-" + vehicleNo.Substring(2);
                        }
                        Vehieclenumber.Text = vehicleNo;

                        vehieclevinn.Text = rdr["vehicleVin"].ToString();
                        userPic.ClientVisible = true;
                        nameatheader.Text = rdr["firstName"].ToString();
                        lastheader.Text = rdr["lastName"].ToString();
                        driverEmailAddress.Text = rdr["email"].ToString();
                        driverProfilePic.Src = rdr["userPicture"].ToString();

                        string noteStr = rdr["incompleteNote"].ToString();
                        if (!string.IsNullOrEmpty(noteStr))
                        {
                            string[] splitvalue = noteStr.Split('$');
                            foreach (var s in splitvalue)
                            {
                                unorder.InnerHtml += $"<li>{s}</li>";
                                unorderr.InnerHtml += $"<li>{s}</li>";
                            }
                        }

                        // تحميل نوع المركبة
                        if (rdr["l_vehicleType"] != DBNull.Value)
                        {
                            if (Convert.ToInt32(rdr["l_vehicleType"]) == 1)
                                carKind.Value = "سيارة";
                            else
                                carKind.Value = "دراجة";
                        }

                        // عرض الصور المحملة مسبقاً
                        LoadImagePreview("preview_userPic", userPic.ClientID, rdr["userPicture"].ToString(), "showUserPic");
                        LoadImagePreview("preview_idFront", ASPxUploadControl5.ClientID, rdr["idFrontPicture"].ToString(), "showIdFront");
                        LoadImagePreview("preview_idBack", ASPxUploadControl4.ClientID, rdr["idBackPicture"].ToString(), "showIdBack");
                        LoadImagePreview("preview_passport", passport.ClientID, rdr["passportPicture"].ToString(), "showPassport");
                        LoadImagePreview("preview_residence", resident.ClientID, rdr["residencePicture"].ToString(), "showResidence");
                        LoadImagePreview("preview_license", ASPxUploadControl3.ClientID, rdr["licensePicture"].ToString(), "showLicense");
                        LoadImagePreview("preview_carLicense", ASPxUploadControl2.ClientID, rdr["carLicensePicture"].ToString(), "showCarLicense");
                        LoadImagePreview("preview_car", ASPxUploadControl1.ClientID, rdr["carPicture"].ToString(), "showCar");
                    }
                }
            }
        }

        private void LoadImagePreview(string previewId, string uploadControlId, string imageUrl, string scriptKey)
        {
            if (!string.IsNullOrEmpty(imageUrl))
            {
                string script = $@"
                    var previewDiv = document.getElementById('{previewId}');
                    if(!previewDiv) {{
                        previewDiv = document.createElement('div');
                        previewDiv.id = '{previewId}';
                        previewDiv.style.cssText = 'margin-top:15px; text-align:center;';
                        document.getElementById('{uploadControlId}').parentNode.appendChild(previewDiv);
                    }}
                    var img = previewDiv.querySelector('img');
                    if(!img) {{
                        img = document.createElement('img');
                        img.style.width = '40%';
                        img.style.margin = '16px auto';
                        img.style.maxHeight = '300px';
                        img.style.borderRadius = '10px';
                        img.style.boxShadow = '0 4px 8px rgba(0,0,0,0.2)';
                        img.style.border = '3px solid #28a745';
                        previewDiv.innerHTML = '';
                        previewDiv.appendChild(img);
                    }}
                    img.src = '{ResolveUrl(imageUrl)}';
                    img.style.display = 'block';
                ";
                ClientScript.RegisterStartupScript(this.GetType(), scriptKey, script, true);
            }
        }

        public void btnSubmit_Update(object sender, EventArgs e)
        {
            string idvalue = Request.QueryString["id"];
            string encryptedId = MainHelper.Decrypt_Me(idvalue, true);

            string firstname = txtFirstName.Text;
            string lastname = txtLastName.Text;
            string email = txtEmail.Text;
            string carNumber = Vehieclenumber.Text.Replace("-", "");
            string vinCar = vehieclevinn.Text;
            string docnumber = documentnumber.Text;
            string phone = txtPhone.Text;
            string carmarkaa = carmarka.Text;
            string nerbynumberr = nerbynumber.Text;
            string nerbynamee = nerbyname.Text;
            string country = ddlCity.Value?.ToString();
            if (country == "الأردن") country = "1";

            string carkindStr = carKind.Value?.ToString();
            string carkind = (carkindStr == "سيارة" || carkindStr == "1") ? "1" : "0";

            string userPlatformm = systemKind.Value?.ToString(); // ✅ الحل لمشكلتك هنا

            int? genderr = null;
            if (gender.Value != null && int.TryParse(gender.Value.ToString(), out int g)) genderr = g;

            int? documenttype = null;
            if (documentType.Value != null && int.TryParse(documentType.Value.ToString(), out int d)) documenttype = d;

            bool ismobilee = false;

            string userPicPath = SaveUploadedFile(userPic, "user");
            string frontPicPath = SaveUploadedFile(ASPxUploadControl5, "front");
            string backPicPath = SaveUploadedFile(ASPxUploadControl4, "back");
            string licensePicPath = SaveUploadedFile(ASPxUploadControl3, "license");
            string carLicensePicPath = SaveUploadedFile(ASPxUploadControl2, "carlicense");
            string carPicPath = SaveUploadedFile(ASPxUploadControl1, "car");
            string passportt = SaveUploadedFile(passport, "passport");
            string residentt = SaveUploadedFile(resident, "resident");

            string connectionString = ConfigurationManager.ConnectionStrings["ShabDBConnectionString"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                // جملة التحديث الذكية: تستخدم COALESCE لتبقي القيمة القديمة إذا كانت الجديدة NULL
                string query = @"UPDATE usersDelivery SET 
                    firstName = COALESCE(NULLIF(@firstname, ''), firstName),
                    lastName = COALESCE(NULLIF(@lastname, ''), lastName),
                    email = COALESCE(NULLIF(@email, ''), email),
                    username = COALESCE(NULLIF(@phone, ''), username),
                    
                    l_gender = COALESCE(@genderr, l_gender),
                    l_documentType = COALESCE(@documenttype, l_documentType),
                    countryId = COALESCE(NULLIF(@country, ''), countryId),
                    userPlatform = COALESCE(NULLIF(@userPlatformm, ''), userPlatform),
                    l_vehicleType = COALESCE(@carkind, l_vehicleType),

                    referenceName = COALESCE(NULLIF(@nerbynamee, ''), referenceName),
                    referenceMobile = COALESCE(NULLIF(@nerbynumberr, ''), referenceMobile),
                    vehicleModel = COALESCE(NULLIF(@carmarkaa, ''), vehicleModel),
                    documentNo = COALESCE(NULLIF(@docnumber, ''), documentNo),
                    vehicleNo = COALESCE(NULLIF(@carNumber, ''), vehicleNo),
                    vehicleVin = COALESCE(NULLIF(@vinCar, ''), vehicleVin),
                    isMobile = @ismobilee,

                    userPicture = COALESCE(@userPicPath, userPicture),
                    idFrontPicture = COALESCE(@frontPicPath, idFrontPicture),
                    idBackPicture = COALESCE(@backPicPath, idBackPicture),
                    passportPicture = COALESCE(@passportt, passportPicture),
                    residencePicture = COALESCE(@residentt, residencePicture),
                    carLicensePicture = COALESCE(@carLicensePicPath, carLicensePicture),
                    licensePicture = COALESCE(@licensePicPath, licensePicture),
                    carPicture = COALESCE(@carPicPath, carPicture)

                    WHERE id = @encryptedId";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    // تمرير القيم مع معالجة الـ NULL
                    cmd.Parameters.AddWithValue("@encryptedId", encryptedId);

                    cmd.Parameters.AddWithValue("@firstname", (object)firstname ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@lastname", (object)lastname ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@email", (object)email ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@phone", (object)phone ?? DBNull.Value);

                    cmd.Parameters.AddWithValue("@genderr", (object)genderr ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@documenttype", (object)documenttype ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@country", (object)country ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@userPlatformm", (object)userPlatformm ?? DBNull.Value); // ✅ الآن يقبل Null
                    cmd.Parameters.AddWithValue("@carkind", (object)carkind ?? DBNull.Value);

                    cmd.Parameters.AddWithValue("@nerbynamee", (object)nerbynamee ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@nerbynumberr", (object)nerbynumberr ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@carmarkaa", (object)carmarka.Text ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@docnumber", (object)docnumber ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@carNumber", (object)carNumber ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@vinCar", (object)vinCar ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@ismobilee", ismobilee);

                    // الصور (تمرر null إذا لم ترفع جديد، و COALESCE في SQL يحفظ القديم)
                    cmd.Parameters.AddWithValue("@userPicPath", (object)userPicPath ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@frontPicPath", (object)frontPicPath ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@backPicPath", (object)backPicPath ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@passportt", (object)passportt ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@residentt", (object)residentt ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@carLicensePicPath", (object)carLicensePicPath ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@licensePicPath", (object)licensePicPath ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@carPicPath", (object)carPicPath ?? DBNull.Value);

                    conn.Open();
                    cmd.ExecuteNonQuery();

                    lblPopupMessage.Text = "تم التحديث بنجاح ✔";
                    popupSuccess.ShowOnPageLoad = true;
                    lblPopupMessage.ForeColor = System.Drawing.Color.Green;
                }
                MainHelper.SendSms(phone, "تم تحديث بياناتك مؤخرا");
            }
            // إعادة تحميل البيانات لعرض التعديلات الجديدة
            LoadDriverData(encryptedId);
        }

        public  void btnSubmit_Click(object sender, EventArgs e)
        {
            string firstname = txtFirstName.Text;
            string lastname = txtLastName.Text;
            string email = txtEmail.Text;
            string carkind = carKind.Text;
            string carNumber = Vehieclenumber.Text.Replace("-", "");
            string vinCar = vehieclevinn.Text;
            string country = ddlCity.Value?.ToString(); // Safe check
            int documenttype = Convert.ToInt32(documentType.Value);
            string docnumber = documentnumber.Text;
            string userPicPath = SaveUploadedFile(userPic, "user");
            string frontPicPath = SaveUploadedFile(ASPxUploadControl5, "front");
            string backPicPath = SaveUploadedFile(ASPxUploadControl4, "back");
            string licensePicPath = SaveUploadedFile(ASPxUploadControl3, "license");
            string carLicensePicPath = SaveUploadedFile(ASPxUploadControl2, "carlicense");
            string carPicPath = SaveUploadedFile(ASPxUploadControl1, "car");
            string passportt = SaveUploadedFile(passport, "passport");
            string residentt = SaveUploadedFile(resident, "resident");
            int deliveryStatus = 1;
            int genderr = Convert.ToInt32(gender.Value);
            bool ismobilee = false;
            string userPlatformm = systemKind.Value?.ToString(); // Safe check
            string carmarkaa = carmarka.Text;
            string nerbynumberr = nerbynumber.Text;
            string nerbynamee = nerbyname.Text;
            string phonen = txtPhone.Text;

            if (!userPic.HasFile) { lblMessage.Text = "❌ يرجى رفع الصورة الشخصية"; lblMessage.ForeColor = System.Drawing.Color.Red; return; }
            if (documenttype == 1)
            {
                if (!ASPxUploadControl5.HasFile || !ASPxUploadControl4.HasFile)
                {
                    lblMessage.Text = "❌ يرجى رفع صور الهوية"; lblMessage.ForeColor = System.Drawing.Color.Red; return;
                }
            }
            if (!ASPxUploadControl3.HasFile) { lblMessage.Text = "❌ يرجى رفع صورة الرخصة"; lblMessage.ForeColor = System.Drawing.Color.Red; return; }
            if (!ASPxUploadControl2.HasFile) { lblMessage.Text = "❌ يرجى رفع صورة رخصة السيارة"; lblMessage.ForeColor = System.Drawing.Color.Red; return; }
            if (!ASPxUploadControl1.HasFile) { lblMessage.Text = "❌ يرجى رفع صورة السيارة"; lblMessage.ForeColor = System.Drawing.Color.Red; return; }

            if (IsemailExists(email)) { lblMessage.Text = "❌ هذا الايميل مسجل مسبقاً!"; lblMessage.ForeColor = System.Drawing.Color.Red; return; }
            if (IsPhoneExists(txtPhone.Text)) { lblMessage.Text = "❌ هذا الرقم مسجل مسبقاً!"; lblMessage.ForeColor = System.Drawing.Color.Red; return; }

            if (country == "الأردن") country = "1";
            if (carkind == "سيارة") carkind = "1"; else carkind = "2";

            string connectionString = ConfigurationManager.ConnectionStrings["ShabDBConnectionString"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "";
                if (documenttype == 2)
                {
                    query = @"INSERT INTO usersDelivery (countryId,username,firstName,referenceMobile,referenceName,isMobile,vehicleModel,userPlatform,l_gender,lastName,email,userPicture,vehicleNo,vehicleVin,passportPicture,licensePicture,carLicensePicture,carPicture,l_vehicleType,l_deliveryStatusId,l_documentType,documentNo,userDate)
                              VALUES(@country,@phone,@firstname,@nerbynumberr,@nerbynamee,@ismobilee,@carmarkaa,@userPlatformm,@genderr,@lastname,@email,@userPicPath,@carNumber,@vinCar,@passportt,@licensePicPath,@carLicensePicPath,@carPicPath,@carkind,@deliveryStatus,@documenttype,@docnumber,getDate())";
                }
                else if (documenttype == 3)
                {
                    query = @"INSERT INTO usersDelivery (countryId,username,firstName,referenceMobile,referenceName,isMobile,vehicleModel,userPlatform,l_gender,lastName,email,userPicture,vehicleNo,vehicleVin,residencePicture,licensePicture,carLicensePicture,carPicture,l_vehicleType,l_deliveryStatusId,l_documentType,documentNo,userDate)
                              VALUES(@country,@phone,@firstname,@nerbynumberr,@nerbynamee,@ismobilee,@carmarkaa,@userPlatformm,@genderr,@lastname,@email,@userPicPath,@carNumber,@vinCar,@residentt,@licensePicPath,@carLicensePicPath,@carPicPath,@carkind,@deliveryStatus,@documenttype,@docnumber,getDate())";
                }
                else
                {
                    query = @"INSERT INTO usersDelivery (countryId,username,firstName,referenceMobile,referenceName,isMobile,vehicleModel,userPlatform,l_gender,lastName,email,userPicture,vehicleNo,vehicleVin,idFrontPicture,idBackPicture,licensePicture,carLicensePicture,carPicture,l_vehicleType,l_deliveryStatusId,l_documentType,documentNo,userDate)
                              VALUES(@country,@phone,@firstname,@nerbynumberr,@nerbynamee,@ismobilee,@carmarkaa,@userPlatformm,@genderr,@lastname,@email,@userPicPath,@carNumber,@vinCar,@frontPicPath,@backPicPath,@licensePicPath,@carLicensePicPath,@carPicPath,@carkind,@deliveryStatus,@documenttype,@docnumber,getDate())";
                }

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@country", country);
                    cmd.Parameters.AddWithValue("@phone", txtPhone.Text);
                    cmd.Parameters.AddWithValue("@firstname", firstname);
                    cmd.Parameters.AddWithValue("@nerbynumberr", nerbynumberr);
                    cmd.Parameters.AddWithValue("@nerbynamee", nerbynamee);
                    cmd.Parameters.AddWithValue("@ismobilee", ismobilee);
                    cmd.Parameters.AddWithValue("@carmarkaa", carmarkaa);
                    cmd.Parameters.AddWithValue("@userPlatformm", (object)userPlatformm ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@genderr", genderr);
                    cmd.Parameters.AddWithValue("@lastname", lastname);
                    cmd.Parameters.AddWithValue("@email", email);
                    cmd.Parameters.AddWithValue("@userPicPath", (object)userPicPath ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@carNumber", carNumber);
                    cmd.Parameters.AddWithValue("@vinCar", vinCar);

                    cmd.Parameters.AddWithValue("@passportt", (object)passportt ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@residentt", (object)residentt ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@frontPicPath", (object)frontPicPath ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@backPicPath", (object)backPicPath ?? DBNull.Value);

                    cmd.Parameters.AddWithValue("@licensePicPath", (object)licensePicPath ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@carLicensePicPath", (object)carLicensePicPath ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@carPicPath", (object)carPicPath ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@carkind", carkind);
                    cmd.Parameters.AddWithValue("@deliveryStatus", deliveryStatus);
                    cmd.Parameters.AddWithValue("@docnumber", docnumber);
                    cmd.Parameters.AddWithValue("@documenttype", documenttype);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                    lblPopupMessage.Text = "تم التسجيل بنجاح ✔";
                    popupSuccess.ShowOnPageLoad = true;
                    lblPopupMessage.ForeColor = System.Drawing.Color.Green;
                }
                 MainHelper.SendSms(phonen, "تم تسجيل طلبك بنجاح، الطلب قيد المراجعة");
            }
        }

        protected void phoneCallback_Callback(object source, CallbackEventArgs e)
        {
            e.Result = IsPhoneExists(e.Parameter) ? "exists" : "available";
        }
        protected void vnoCallback_Callback(object source, CallbackEventArgs e)
        {
            e.Result = IsVehicleNoExists(e.Parameter) ? "exists" : "available";
        }
        protected void numnbercallback(object source, CallbackEventArgs e)
        {
            e.Result = iDocumentExists(e.Parameter) ? "exists" : "available";
        }
        protected void emailCallback_Callback(object source, CallbackEventArgs e)
        {
            e.Result = IsemailExists(e.Parameter) ? "exists" : "available";
        }

        private bool IsVehicleNoExists(string val) { return CheckExists("vehicleNo", val); }
        private bool iDocumentExists(string val) { return CheckExists("documentNo", val); }
        private bool IsemailExists(string val) { return CheckExists("email", val); }
        private bool IsPhoneExists(string val) { return CheckExists("username", val); }

        private bool CheckExists(string column, string value)
        {
            if (string.IsNullOrWhiteSpace(value)) return false;
            string connection = ConfigurationManager.ConnectionStrings["ShabDBConnectionString"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connection))
            {
                string query = $"SELECT COUNT(*) FROM usersDelivery WHERE {column}=@val";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@val", value);
                    conn.Open();
                    return (int)cmd.ExecuteScalar() > 0;
                }
            }
        }

        private string SaveUploadedFile(ASPxUploadControl uploadControl, string prefix)
        {
            if (!uploadControl.HasFile) return null;
            var file = uploadControl.UploadedFiles[0];
            string uploadFolder = Server.MapPath("~/assets/uploads/delivery-users/");
            if (!Directory.Exists(uploadFolder)) Directory.CreateDirectory(uploadFolder);
            string extension = Path.GetExtension(file.FileName);
            string uniqueFileName = prefix + "_" + Guid.NewGuid().ToString() + extension;
            string fullPath = Path.Combine(uploadFolder, uniqueFileName);
            file.SaveAs(fullPath);
            return "/assets/uploads/delivery-users/" + uniqueFileName;
        }
    }
}