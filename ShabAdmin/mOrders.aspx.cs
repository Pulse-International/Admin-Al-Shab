using DevExpress.Web;
using DevExpress.Web.Data;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ShabAdmin
{
    public partial class mOrders : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void Page_Init(object sender, EventArgs e)
        {

            var (countryId, companyId) = GetUserPrivileges();

            db_Orders.SelectParameters.Clear();
            dsCountries.SelectParameters.Clear();
            dsCompanies.SelectParameters.Clear();

            if (countryId != 1000 && companyId != 1000)
            {
                db_Orders.SelectCommand = @"
                    SELECT 
                        o.[id], 
                        o.[companyId], 
                        c.[countryID] AS countryId, 
 c.[companyName] AS companyName, 
 co.[countryName] AS countryName,
                        o.[username], 
                        u.[firstName] + ' ' + u.[lastName] AS fullName,
                        o.[addressId], 
                        o.[amount], 
                        o.[deliveryAmount], 
                        o.[taxAmount], 
                        o.[totalAmount], 
                        o.[couponId], 
o.pointId,
                        o.[pointsUsed],
 po.[points],
 po.[discountAmount],
                        o.[l_paymentMethodId],
 o.[l_paymentMethodId2],
                    o.[l_paymentMethodId2Amount],
                        br.[name] AS branchName, 
                        o.[l_RefundType],
                        pm.[description] AS paymentMethod, 
                        o.[transactionId], 
                        o.[invoiceNo], 
                        o.[notes], 
                        o.[l_orderStatus], 
                        os.[description] AS orderStatus,  
                        o.[refundedAmount], 
                        o.[realTotalAmount], 
                        o.[realTax], 
                        o.[userDate]
                    FROM 
                        [Orders] o
                    JOIN 
                        [companies] c ON o.companyId = c.id
                    LEFT JOIN 
                        l_paymentMethod pm ON o.l_paymentMethodId = pm.id
                    LEFT JOIN 
                        branches br ON o.branchId = br.id
                    LEFT JOIN 
                          countries co ON c.countryID = co.id
                    LEFT JOIN 
                        l_orderStatus os ON o.l_orderStatus = os.id
                    LEFT JOIN 
                        [usersApp] u ON o.username = u.username
LEFT JOIN 
    [pointsOffers] po ON o.pointId = po.id
                    WHERE o.companyId = @companyId AND c.countryID = @countryId order by o.id desc";

                db_Orders.SelectParameters.Add("companyId", companyId.ToString());
                db_Orders.SelectParameters.Add("countryId", countryId.ToString());

                dsCountries.SelectCommand = "SELECT id, countryName FROM countries WHERE id = @countryId";
                dsCountries.SelectParameters.Add("countryId", countryId.ToString());

                dsCompanies.SelectCommand = "SELECT id, companyName FROM companies WHERE id = @companyId";
                dsCompanies.SelectParameters.Add("companyId", companyId.ToString());
            }
            else if (countryId != 1000)
            {
                db_Orders.SelectCommand = @"
                    SELECT 
                        o.[id], 
                        o.[companyId], 
                        c.[countryID] AS countryId, 
 c.[companyName] AS companyName, 
 co.[countryName] AS countryName,
                        o.[username], 
                        u.[firstName] + ' ' + u.[lastName] AS fullName,
                        o.[addressId], 
                        o.[amount], 
                        o.[deliveryAmount], 
                        o.[taxAmount], 
                        o.[totalAmount], 
                        o.[couponId], 
                        o.[pointsUsed],
o.pointId,
 po.[points],
 po.[discountAmount],
                        o.[l_paymentMethodId],
 o.[l_paymentMethodId2],
                    o.[l_paymentMethodId2Amount],
                        br.[name] AS branchName, 
                        o.[l_RefundType],
                        pm.[description] AS paymentMethod, 
                        o.[transactionId], 
                        o.[invoiceNo], 
                        o.[notes], 
                        o.[l_orderStatus], 
                        os.[description] AS orderStatus,  
                        o.[refundedAmount], 
                        o.[realTotalAmount], 
                        o.[realTax], 
                        o.[userDate]
                    FROM 
                        [Orders] o
                    JOIN 
                        [companies] c ON o.companyId = c.id
                    LEFT JOIN 
                        l_paymentMethod pm ON o.l_paymentMethodId = pm.id
                    LEFT JOIN 
                        branches br ON o.branchId = br.id
                    LEFT JOIN 
                          countries co ON c.countryID = co.id
                    LEFT JOIN 
                        l_orderStatus os ON o.l_orderStatus = os.id
                    LEFT JOIN 
                        [usersApp] u ON o.username = u.username
LEFT JOIN 
    [pointsOffers] po ON o.pointId = po.id
                    WHERE c.countryID = @countryId order by o.id desc";

                db_Orders.SelectParameters.Add("countryId", countryId.ToString());

                dsCountries.SelectCommand = "SELECT id, countryName FROM countries WHERE id = @countryId";
                dsCountries.SelectParameters.Add("countryId", countryId.ToString());

                dsCompanies.SelectCommand = "SELECT id, companyName FROM companies WHERE countryID = @countryId";
                dsCompanies.SelectParameters.Add("countryId", countryId.ToString());
            }
            else
            {
                db_Orders.SelectCommand = @"
                    SELECT 
                        o.[id], 
                        o.[companyId], 
                        c.[countryID] AS countryId,
 c.[companyName] AS companyName, 
 co.[countryName] AS countryName,
                        o.[username], 
                        u.[firstName] + ' ' + u.[lastName] AS fullName,
                        o.[addressId], 
                        o.[amount], 
                        o.[deliveryAmount], 
                        o.[taxAmount], 
                        o.[totalAmount], 
                        o.[couponId], 
                        o.[pointsUsed],
o.pointId,
 po.[points],
 po.[discountAmount],
                        o.[l_paymentMethodId],
 o.[l_paymentMethodId2],
                    o.[l_paymentMethodId2Amount],
                        o.[l_RefundType],
                        pm.[description] AS paymentMethod, 
                        br.[name] AS branchName, 
                        o.[transactionId], 
                        o.[invoiceNo], 
                        o.[notes], 
                        o.[l_orderStatus], 
                        os.[description] AS orderStatus,  
                        o.[refundedAmount], 
                        o.[realTotalAmount], 
                        o.[realTax], 
                        o.[userDate]
                    FROM 
                        [Orders] o
                    JOIN 
                        [companies] c ON o.companyId = c.id
                    LEFT JOIN 
                        l_paymentMethod pm ON o.l_paymentMethodId = pm.id
                    LEFT JOIN 
                        branches br ON o.branchId = br.id
                    LEFT JOIN 
                          countries co ON c.countryID = co.id
                    LEFT JOIN 
                        l_orderStatus os ON o.l_orderStatus = os.id
                    LEFT JOIN 
                        [usersApp] u ON o.username = u.username
LEFT JOIN 
    [pointsOffers] po ON o.pointId = po.id
                    order by o.id desc";

                dsCountries.SelectCommand = "SELECT id, countryName FROM countries where id <> 1000";
                dsCompanies.SelectCommand = "SELECT id, companyName FROM companies where id <> 1000";
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

        // 2. Update your callback method to store map data in JavaScript variables:
        protected void callbackAddress_Callback(object sender, DevExpress.Web.CallbackEventArgsBase e)
        {
            int addressId;
            if (int.TryParse(e.Parameter, out addressId))
            {
                string connStr = ConfigurationManager.ConnectionStrings["ShabDB_connection"].ConnectionString;
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();
                    SqlCommand cmd = new SqlCommand(@"
                        SELECT 
                            a.username,
                            t.description AS addressType,
                            a.countrycode,
                            a.city,
                            a.area,
                            a.addressnickname,
                            a.apartmentno,
                            a.floorno,
                            a.[buildingno],
                            a.[latitude],
                            a.[longitude],
                            a.street,
                            a.addressnotes,
                            a.isStored
                        FROM Addresses a
                        LEFT JOIN l_addressType t ON a.l_addressTypeId = t.id
                        WHERE a.id = @id", conn);

                    cmd.Parameters.AddWithValue("@id", addressId);

                    SqlDataReader reader = cmd.ExecuteReader();
                    if (reader.Read())
                    {
                        string latitude = reader["latitude"].ToString();
                        string longitude = reader["longitude"].ToString();
                        string isStored = Convert.ToBoolean(reader["isStored"]) ? "عنوان محفوظ" : "عنوان مؤقت";
                        string mapDivId = $"map_{addressId}";

                        // ضع بيانات الخريطة هنا كـ JSON String
                        var mapData = new
                        {
                            lat = latitude,
                            lng = longitude,
                            mapId = mapDivId,
                            title = reader["addressnickname"],
                            area = reader["area"],
                            city = reader["city"]
                        };
                        string json = new System.Web.Script.Serialization.JavaScriptSerializer().Serialize(mapData);

                        // أرسلها عبر JSProperties
                        callbackAddress.JSProperties["cpMapData"] = json;

                        lblAddressInfo.Text = $@"
                        <div style='font-family: Cairo; direction: rtl; font-size: 1.1em; line-height: 2; padding: 20px; background-color: #f9f9f9; border-radius: 10px; border: 1px solid #ddd; max-width: 100%;'>
                            <h3 style='margin-top: 0;font-family: Cairo; margin-bottom:1em; color: #333;'>📍 تفاصيل العنوان</h3>
                            <div style='display: flex; flex-direction: row; flex-wrap: nowrap; gap: 20px; max-width: 100%;'>
                                <div style='width: 50%;'>
                                    <div style='margin-bottom: 10px;'><b style='color:#555;'>📱 الهاتف:</b> {reader["username"]}</div>
                                    <div style='margin-bottom: 10px;'><b style='color:#555;'>🏠 نوع العنوان:</b> {reader["addressType"]}</div>
                                    <div style='margin-bottom: 10px;'><b style='color:#555;'>🌍 الدولة:</b> {reader["countrycode"]}</div>
                                    <div style='margin-bottom: 10px;'><b style='color:#555;'>🏙️ المدينة:</b> {reader["city"]}</div>
                                    <div style='margin-bottom: 10px;'><b style='color:#555;'>📍 المنطقة:</b> {reader["area"]}</div>
                                    <div style='margin-bottom: 10px;'><b style='color:#555;'>🏷️ الاسم المستعار:</b> {reader["addressnickname"]}</div>
                                    <hr style='margin: 15px 0; border-top: 1px dashed #ccc;' />
                                    <div style='margin-bottom: 10px;'><b style='color:#555;'>🛣️ الشارع:</b> {reader["street"]}</div>
                                    <div style='margin-bottom: 10px;'><b style='color:#555;'>🏢 رقم المبنى:</b> {reader["buildingno"]}</div>
                                    <div style='margin-bottom: 10px;'><b style='color:#555;'>🪜 الطابق:</b> {reader["floorno"]}</div>
                                    <div style='margin-bottom: 10px;'><b style='color:#555;'>🚪 رقم الشقة:</b> {reader["apartmentno"]}</div>
                                    <div style='margin-bottom: 10px;'><b style='color:#555;'>📝 ملاحظات:</b> {reader["addressnotes"]}</div>
                                    <div style='margin-top: 20px; color: #888; font-style: Cairo;'>{isStored}</div>
                                </div>
                                <div style='width: 50%;'>
                                    <div id='{mapDivId}' style='width: 100%; height: 400px; border: 1px solid #ccc; border-radius: 8px;'></div>
                                </div>
                            </div>
                        </div>";

                    }
                    else
                    {
                        lblAddressInfo.Text = "لم يتم العثور على العنوان.";
                    }
                }
            }
            else
            {
                lblAddressInfo.Text = "رقم العنوان غير صالح.";
            }
        }

        protected void callbackCoupon_Callback(object sender, DevExpress.Web.CallbackEventArgsBase e)
        {
            int couponId;
            if (int.TryParse(e.Parameter, out couponId))
            {
                if (couponId == 1)
                {
                    lblCouponInfo.Text = @"
                        <div style='
                            font-family: Cairo;
                            direction: rtl;
                            font-size: 1.2em;
                            padding: 25px;
                            background: linear-gradient(to bottom, #fdfdfd, #f7f7f7);
                            border: 1px solid #ddd;
                            border-radius: 12px;
                            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
                            text-align: center;
                        '>
                            <div style='color: #888; font-size: 1.1em; font-family: Cairo;'>لا توجد قسيمة مرتبطة بهذا الطلب.</div>
                        </div>";
                    return;
                }

                string connStr = ConfigurationManager.ConnectionStrings["ShabDB_connection"].ConnectionString;
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();
                    SqlCommand cmd = new SqlCommand(@"
                SELECT 
                    c.username,
                    c.description,
                    c.couponCode,
                    c.discountAmount,
                    c.isUsed,
                    dt.description AS discountTypeDescription
                FROM Coupons c
                LEFT JOIN l_discountType dt ON c.l_discountType = dt.id
                WHERE c.id = @id", conn);

                    cmd.Parameters.AddWithValue("@id", couponId);

                    SqlDataReader reader = cmd.ExecuteReader();
                    if (reader.Read())
                    {
                        string type = reader["discountTypeDescription"]?.ToString() ?? "غير معروف";
                        string used = Convert.ToBoolean(reader["isUsed"]) ? "تم استخدامه" : "غير مستخدم";

                        lblCouponInfo.Text = $@"
<div style='
    font-family: Cairo;
    direction: rtl;
    font-size: 1.2em;
    padding: 25px;
    background: linear-gradient(to bottom, #fdfdfd, #f7f7f7);
    border: 1px solid #ddd;
    border-radius: 12px;
    box-shadow: 0 2px 8px rgba(0,0,0,0.05);
'>
    <h3 style='color: #333; margin-bottom: 1em; font-size: 1.4em; font-family: Cairo;'>🎫 تفاصيل القسيمة</h3>

    <div style='margin-bottom: 12px; font-family: Cairo;'><span style='color: #555;'>👤 <b>المستخدم:</b></span> {reader["username"]}</div>
    <div style='margin-bottom: 12px; font-family: Cairo;'><span style='color: #555;'>📝 <b>الوصف:</b></span> {reader["description"]}</div>
    <div style='margin-bottom: 12px; font-family: Cairo;'><span style='color: #555;'>📄 <b>رمز القسيمة:</b></span> <span style='color: #0275d8; font-weight: bold;'>{reader["couponCode"]}</span></div>
    <div style='margin-bottom: 12px; font-family: Cairo;'><span style='color: #555;'>💸 <b>قيمة الخصم:</b></span> {reader["discountAmount"]}</div>
    <div style='margin-bottom: 12px; font-family: Cairo;'><span style='color: #555;'>🔢 <b>نوع الخصم:</b></span> {type}</div>
    <div style='margin-bottom: 12px; font-family: Cairo;'><span style='color: #555;'>⚠️ <b>الحالة:</b></span> {used}</div>
</div>";
                    }
                    else
                    {
                        lblCouponInfo.Text = "<div style='font-family: Cairo;'>❌ القسيمة غير موجودة.</div>";
                    }
                }
            }
            else
            {
                lblCouponInfo.Text = "<div style='font-family: Cairo;'>❌ معرّف القسيمة غير صالح.</div>";
            }
        }


        public string GetOrderStatusLottie(string status, string id)
        {
            if (status == "1")
            {
                return @"
                <div style='width: 100px; margin: auto; text-align: center; font-family: Cairo;'>
                    <lottie-player 
                        src='/assets/animations/pending.json' 
                        background='transparent' 
                        speed='1' 
                        style='width: 80px; height: 80px; margin: 0 auto;' 
                        loop 
                        autoplay>
                    </lottie-player>
                    <div style='margin-top: 5px; font-size: 0.95em; color: #444;'>بانتظار الموافقة</div>
                </div>";
            }
            else if (status == "2")
            {
                return @"
                <div style='width: 100px; margin: auto; text-align: center; font-family: Cairo;'>
                    <lottie-player 
                        src='/assets/animations/preparing.json' 
                        background='transparent' 
                        speed='1' 
                        style='width: 80px; height: 80px; margin: 0 auto;' 
                        loop 
                        autoplay>
                    </lottie-player>
                    <div style='margin-top: 5px; font-size: 0.95em; color: #444;'>قيد التحضير</div>
                </div>";
            }
            else if (status == "3")
            {
                return @"
                <div style='width: 100px; margin: auto; text-align: center; font-family: Cairo;'>
                    <lottie-player 
                        src='/assets/animations/delivery.json' 
                        background='transparent' 
                        speed='1' 
                        style='width: 80px; height: 80px; margin: 0 auto;' 
                        loop 
                        autoplay>
                    </lottie-player>
                    <div style='margin-top: 5px; font-size: 0.95em; color: #444;'>قيد التوصيل</div>
                </div>";
            }
            else if (status == "4")
            {
                return @"
                <div style='width: 100px; margin: auto; text-align: center; font-family: Cairo;'>
                    <lottie-player 
                        src='/assets/animations/delivered.json' 
                        background='transparent' 
                        speed='1' 
                        style='width: 80px; height: 80px; margin: 0 auto;' 
                        loop 
                        autoplay>
                    </lottie-player>
                    <div style='margin-top: 5px; font-size: 0.95em; color: #444;'>تم التسليم</div>
                </div>";
            }
            else if (status == "8")
            {
                return @"
                <div style='width: 100px; margin: auto; text-align: center; font-family: Cairo;'>
                    <lottie-player 
                        src='/assets/animations/BranchCancel.json' 
                        background='transparent' 
                        speed='1' 
                        style='width: 110px; height: 110px; margin: 0 auto;' 
                        loop 
                        autoplay>
                    </lottie-player>
                    <div style='margin-top: 5px; font-size: 0.95em; color: #d9534f;'>ملغي من الفرع</div>
                </div>";
            }
            else if (status == "9")
            {
                string orderId = id;

                // اجلب ملاحظة الرفض من قاعدة البيانات
                string rejectNote = "";
                using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ShabDB_connection"].ConnectionString))
                {
                    conn.Open();
                    SqlCommand cmd = new SqlCommand("SELECT rejectNote FROM orders WHERE id=@id", conn);
                    cmd.Parameters.AddWithValue("@id", orderId);

                    var result = cmd.ExecuteScalar();
                    rejectNote = result != DBNull.Value ? result.ToString() : "";
                }

                // لو ما في ملاحظة خليها فراغ
                if (string.IsNullOrWhiteSpace(rejectNote))
                    rejectNote = "—";

                return $@"
                <div style='width: 100px; margin: auto; text-align: center; font-family: Cairo;'>
                    <lottie-player 
                        src='/assets/animations/canceled.json' 
                        background='transparent' 
                        speed='1' 
                        style='width: 110px; height: 110px; margin: 0 auto;'
                        loop 
                        autoplay>
                    </lottie-player>

                    <div style='margin-top: 5px; font-size: 0.95em; color: #d9534f;'>ملغي من الإدارة</div>

                    <div style='margin-top: 5px; font-size: 0.85em;font-weight:bold; color: #555;'>
                        ملاحظة الرفض: 
<br/>
                        {rejectNote}
                    </div>
                </div>";
            }
            else if (status == "7")
            {
                return @"
                <div style='width: 100px; margin: auto; text-align: center; font-family: Cairo;'>
                    <lottie-player 
                        src='/assets/animations/canceled.json' 
                        background='transparent' 
                        speed='1' 
                        style='width: 110px; height: 110px; margin: 0 auto;' 
                        loop 
                        autoplay>
                    </lottie-player>
                    <div style='margin-top: 5px; font-size: 0.95em; color: #888;'>ملغي من المستخدم</div>
                </div>";
            }
            else if (status == "6")
            {
                return @"
                <div style='width: 100px; margin: auto; text-align: center; font-family: Cairo;'>
                    <lottie-player 
                        src='/assets/animations/refund.json' 
                        background='transparent' 
                        speed='1' 
                        style='width: 110px; height: 110px; margin: 0 auto;' 
                        loop 
                        autoplay>
                    </lottie-player>
                    <div style='margin-top: 5px; font-size: 0.95em; color: #f0ad4e;'>إرجاع جزئي</div>
                </div>";
            }
            else if (status == "5")
            {
                return @"
                <div style='width: 100px; margin: auto; text-align: center; font-family: Cairo;'>
                    <lottie-player 
                        src='/assets/animations/refund.json' 
                        background='transparent' 
                        speed='1' 
                        style='width: 110px; height: 110px; margin: 0 auto;' 
                        loop 
                        autoplay>
                    </lottie-player>
                    <div style='margin-top: 5px; font-size: 0.95em; color: #ec971f;'>إرجاع كلي</div>
                </div>";
            }






            return $"<span class='order-badge badge-default'>{status}</span>";
        }

        protected void callbackRefundDetails_Callback(object sender, DevExpress.Web.CallbackEventArgsBase e)
        {
            int orderId;
            if (int.TryParse(e.Parameter, out orderId))
            {
                string connStr = ConfigurationManager.ConnectionStrings["ShabDB_connection"].ConnectionString;
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();
                    SqlCommand cmd = new SqlCommand(@"
                    SELECT 
                        refundedAmount, 
                        realTotalAmount, 
                        realTax,   
                        [amount], 
                        [deliveryAmount], 
                        [taxAmount], 
                        [totalAmount]
                    FROM Orders
                    WHERE id = @id", conn);

                    cmd.Parameters.AddWithValue("@id", orderId);

                    SqlDataReader reader = cmd.ExecuteReader();
                    if (reader.Read())
                    {
                        lblRefundDetails.Text = $@"
                        <div style='font-family: Cairo; direction: rtl; font-size: 1em; padding: 10px;'>

                            <div style='border: 2px solid #ccc; border-radius: 10px; padding: 15px; margin-bottom: 20px; background-color: #f9f9f9; box-shadow: 0 2px 5px rgba(0,0,0,0.05);'>
                                <h4 style='margin-top: 0; text-align:center; color: #333;'>تفاصيل المبلغ الأصلي</h4>
                                <div style='display: flex; border-top: 1px solid #ccc; margin-top: 10px;'>
                                    <div style='flex: 1; padding: 10px; text-align: left; border-left: 1px solid #ccc; color: #444;'>
                                        💵 السعر<br />
                                        🚚 التوصيل<br />
                                        🧾 الضريبة<br />
                                        <strong style='font-size: 1.4em;'>💳 المجموع</strong>
                                    </div>
                                    <div style='flex: 1; padding: 10px; text-align: right;'>
                                        {reader["amount"]}<br />
                                        {reader["deliveryAmount"]}<br />
                                        {reader["taxAmount"]}<br />
                                        <strong style='font-size: 1.4em;'>{reader["totalAmount"]}</strong>
                                    </div>
                                </div>
                            </div>

                            <div style='border: 2px solid #8bc34a; border-radius: 10px; padding: 15px; background-color: #f1fff0; box-shadow: 0 2px 5px rgba(0,0,0,0.05);'>
                                <h4 style='margin-top: 0; text-align:center; color: #4caf50;'>تفاصيل المبلغ المسترجع</h4>
                                <div style='display: flex; border-top: 1px solid #b2df8a; margin-top: 10px;'>
                                    <div style='flex: 1; padding: 10px; text-align: left; border-left: 1px solid #8bc34a; color: #33691e;'>
                                        💰 المبلغ الفعلي<br />
                                        🧾 الضريبة الفعلية<br />
                                        <strong style='font-size: 1.4em;'>💸 المبلغ المرتجع</strong>
                                    </div>
                                    <div style='flex: 1; padding: 10px; text-align: right;'>
                                        {reader["realTotalAmount"]}<br />
                                        {reader["realTax"]}<br />
                                        <strong style='font-size: 1.4em;'>{reader["refundedAmount"]}</strong>
                                    </div>
                                </div>
                            </div>

                        </div>";



                    }
                    else
                    {
                        lblRefundDetails.Text = "لا توجد بيانات لهذا الطلب.";
                    }
                }
            }
            else
            {
                lblRefundDetails.Text = "رقم الطلب غير صالح.";
            }
        }

        protected void gridOrderProducts_CustomCallback(object sender, DevExpress.Web.ASPxGridViewCustomCallbackEventArgs e)
        {
            if (int.TryParse(e.Parameters, out int orderId))
            {
                dsOrderProducts.SelectParameters["orderId"].DefaultValue = orderId.ToString();
                gridOrderProducts.DataBind();
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

        // ==================== Refund to Wallet ====================
        protected void callbackRefund_Callback(object sender, DevExpress.Web.CallbackEventArgsBase e)
        {
            if (string.IsNullOrWhiteSpace(e.Parameter)) return;

            string[] parts = e.Parameter.Split(':');
            if (parts.Length != 3 || parts[0] != "refund") return;

            int orderId;
            if (!int.TryParse(parts[1], out orderId)) return;

            decimal requestedRefund;
            if (!decimal.TryParse(parts[2], NumberStyles.Any, CultureInfo.InvariantCulture, out requestedRefund))
                return;

            if (requestedRefund <= 0) return;

            using (var conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ShabDB_connection"].ConnectionString))
            {
                conn.Open();
                using (var tx = conn.BeginTransaction(IsolationLevel.ReadCommitted))
                {
                    try
                    {
                        string getOrderSql = @"
SELECT o.id, o.username, o.totalAmount, o.refundedAmount, 
       o.realTotalAmount, o.realTax,o.taxAmount, o.l_orderStatus
FROM Orders o
WHERE o.id = @orderId";

                        string username = "";
                        decimal totalAmount = 0m, refundedAmount = 0m, realTotalAmount = 0m, realTax = 0m, Tax = 0m;
                        string currentStatus = "";

                        using (var cmd = new SqlCommand(getOrderSql, conn, tx))
                        {
                            cmd.Parameters.Add("@orderId", SqlDbType.Int).Value = orderId;
                            using (var r = cmd.ExecuteReader())
                            {
                                if (!r.Read())
                                {
                                    tx.Rollback();
                                    (sender as ASPxCallbackPanel).JSProperties["cpMessage"] = "الطلب غير موجود";
                                    return;
                                }

                                username = r["username"]?.ToString() ?? "";
                                totalAmount = r["totalAmount"] == DBNull.Value ? 0m : Convert.ToDecimal(r["totalAmount"]);
                                refundedAmount = r["refundedAmount"] == DBNull.Value ? 0m : Convert.ToDecimal(r["refundedAmount"]);
                                realTotalAmount = r["realTotalAmount"] == DBNull.Value ? 0m : Convert.ToDecimal(r["realTotalAmount"]);
                                realTax = r["realTax"] == DBNull.Value ? 0m : Convert.ToDecimal(r["realTax"]);
                                Tax = r["taxAmount"] == DBNull.Value ? 0m : Convert.ToDecimal(r["taxAmount"]);
                                currentStatus = r["l_orderStatus"]?.ToString() ?? "";
                            }
                        }

                        decimal availableToRefund = totalAmount - refundedAmount;
                        if (requestedRefund > availableToRefund)
                        {
                            tx.Rollback();
                            (sender as ASPxCallbackPanel).JSProperties["cpMessage"] = "المبلغ المطلوب أكبر من المتاح للإرجاع";
                            return;
                        }

                        // ==============================
                        //   استرجاع نقاط العرض
                        // ==============================
                        string getOfferPointsSql = @"
                    SELECT points 
                    FROM pointsOffers 
                    WHERE id = (SELECT pointId FROM orders WHERE id = @orderId)
                ";

                        int offerPoints = 0;
                        using (SqlCommand cmd = new SqlCommand(getOfferPointsSql, conn, tx))
                        {
                            cmd.Parameters.AddWithValue("@orderId", orderId);
                            var val = cmd.ExecuteScalar();
                            if (val != null && val != DBNull.Value)
                                offerPoints = Convert.ToInt32(val);
                        }

                        if (offerPoints > 0)
                        {
                            string returnOfferPointsSql = @"
                        UPDATE usersApp
                        SET userPoints = userPoints + @offerPoints
                        WHERE username = @username
                    ";

                            using (SqlCommand cmd = new SqlCommand(returnOfferPointsSql, conn, tx))
                            {
                                cmd.Parameters.AddWithValue("@offerPoints", offerPoints);
                                cmd.Parameters.AddWithValue("@username", username);
                                cmd.ExecuteNonQuery();
                            }
                        }

                        // ==============================
                        //   استرجاع النقاط المستخدمة
                        // ==============================
                        string getUsedPointsSql = @"
                    SELECT pointsUsed 
                    FROM orders 
                    WHERE id = @orderId
                ";

                        int usedPoints = 0;
                        using (SqlCommand cmd = new SqlCommand(getUsedPointsSql, conn, tx))
                        {
                            cmd.Parameters.AddWithValue("@orderId", orderId);
                            var val = cmd.ExecuteScalar();
                            if (val != null && val != DBNull.Value)
                                usedPoints = Convert.ToInt32(val);
                        }

                        if (usedPoints > 0)
                        {
                            string returnUsedPointsSql = @"
                        UPDATE usersApp
                        SET userPoints = userPoints + @used
                        WHERE username = @username
                    ";

                            using (SqlCommand cmd = new SqlCommand(returnUsedPointsSql, conn, tx))
                            {
                                cmd.Parameters.AddWithValue("@used", usedPoints);
                                cmd.Parameters.AddWithValue("@username", username);
                                cmd.ExecuteNonQuery();
                            }
                        }

                        // ==============================
                        //   خصم النقاط المكتسبة (amount * 100)
                        // ==============================
                        string getAmountSql = @"SELECT totalAmount FROM orders WHERE id = @orderId";

                        decimal amount = 0;
                        using (SqlCommand cmd = new SqlCommand(getAmountSql, conn, tx))
                        {
                            cmd.Parameters.AddWithValue("@orderId", orderId);
                            var val = cmd.ExecuteScalar();
                            if (val != null && val != DBNull.Value)
                                amount = Convert.ToDecimal(val);
                        }

                        int earnedPoints = Convert.ToInt32(amount * 100);

                        if (earnedPoints > 0)
                        {
                            string deductEarnedPointsSql = @"
                        UPDATE usersApp
                        SET userPoints = userPoints - @earned
                        WHERE username = @username
                    ";

                            using (SqlCommand cmd = new SqlCommand(deductEarnedPointsSql, conn, tx))
                            {
                                cmd.Parameters.AddWithValue("@earned", earnedPoints);
                                cmd.Parameters.AddWithValue("@username", username);
                                cmd.ExecuteNonQuery();
                            }
                        }

                        // ==============================
                        //   بقية العملية كما هي
                        // ==============================

                        decimal refundValue = requestedRefund;
                        decimal newRefundedAmount = refundedAmount + refundValue;
                        decimal newRealTotalAmount = totalAmount - newRefundedAmount;
                        if (newRealTotalAmount < 0m) newRealTotalAmount = 0m;

                        decimal newRealTax = Math.Round(newRealTotalAmount * 0.16m, 3);
                        string newStatus = (newRefundedAmount >= totalAmount && totalAmount > 0m) ? "5" : "6";

                        if (Tax == 0)
                            newRealTax = 0;

                        string updateOrderSql = @"
        UPDATE Orders
        SET refundedAmount   = @refundedAmount,
            realTotalAmount  = @realTotalAmount,
            realTax          = @realTax,
            l_orderStatus    = @status,
            l_refundType     = 3,
            refundedUser     = @username
        WHERE id = @orderId";

                        string user = MainHelper.M_Check(Request.Cookies["M_Username"]?.Value);

                        using (var cmd = new SqlCommand(updateOrderSql, conn, tx))
                        {
                            cmd.Parameters.Add("@refundedAmount", SqlDbType.Decimal).Value = newRefundedAmount;
                            cmd.Parameters.Add("@realTotalAmount", SqlDbType.Decimal).Value = newRealTotalAmount;
                            cmd.Parameters.Add("@realTax", SqlDbType.Decimal).Value = newRealTax;
                            cmd.Parameters.Add("@status", SqlDbType.NVarChar, 50).Value = newStatus;
                            cmd.Parameters.Add("@orderId", SqlDbType.Int).Value = orderId;
                            cmd.Parameters.Add("@username", SqlDbType.NVarChar).Value = user;
                            cmd.ExecuteNonQuery();
                        }

                        string updateUserSql = @"
        UPDATE usersApp
        SET balance = balance + @refundValue
        WHERE username = @username";

                        using (var cmd = new SqlCommand(updateUserSql, conn, tx))
                        {
                            cmd.Parameters.Add("@refundValue", SqlDbType.Decimal).Value = refundValue;
                            cmd.Parameters.Add("@username", SqlDbType.NVarChar, 100).Value = username;
                            cmd.ExecuteNonQuery();
                        }

                        tx.Commit();
                        (sender as ASPxCallbackPanel).JSProperties["cpMessage"] = "تمت عملية الإرجاع للمحفظة بنجاح";
                    }
                    catch (Exception ex)
                    {
                        tx.Rollback();
                        (sender as ASPxCallbackPanel).JSProperties["cpMessage"] = "حدث خطأ: " + ex.Message;
                    }
                }
            }
        }

        // ==================== Refund to Card ====================
        protected void callbackRefundCard_Callback(object sender, DevExpress.Web.CallbackEventArgsBase e)
        {
            if (string.IsNullOrWhiteSpace(e.Parameter)) return;

            // نتوقع format: "refund:orderId:requestedRefund:secondAmount"
            string[] parts = e.Parameter.Split(':');
            if (parts.Length < 3 || parts[0] != "refund") return;

            int orderId;
            if (!int.TryParse(parts[1], out orderId)) return;

            decimal requestedRefund;
            if (!decimal.TryParse(parts[2], NumberStyles.Any, CultureInfo.InvariantCulture, out requestedRefund))
                return;

            decimal secondAmount = 0m;
            if (parts.Length >= 4)
                decimal.TryParse(parts[3], NumberStyles.Any, CultureInfo.InvariantCulture, out secondAmount);

            if (requestedRefund <= 0) return;

            using (var conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ShabDB_connection"].ConnectionString))
            {
                conn.Open();
                using (var tx = conn.BeginTransaction(IsolationLevel.ReadCommitted))
                {
                    try
                    {
                        string getOrderSql = @"
                    SELECT o.username, o.totalAmount, o.refundedAmount, 
                           o.realTotalAmount, o.realTax, pa.transactionRef AS paymentTR,
                           o.VerifiedTransactionRef, o.l_refundType,
                           o.paymentMethodId, o.paymentMethodId2
                    FROM Orders o
                    LEFT JOIN [payments] pa ON o.id = pa.orderId
                    WHERE o.id = @orderId";

                        string username = "", transactionRef = "";
                        decimal totalAmount = 0m, refundedAmount = 0m;
                        int refundType = 0, paymentMethod1 = 0, paymentMethod2 = 0;

                        using (var cmd = new SqlCommand(getOrderSql, conn, tx))
                        {
                            cmd.Parameters.Add("@orderId", SqlDbType.Int).Value = orderId;
                            using (var r = cmd.ExecuteReader())
                            {
                                if (!r.Read())
                                {
                                    tx.Rollback();
                                    (sender as ASPxCallbackPanel).JSProperties["cpMessage"] = "الطلب غير موجود";
                                    return;
                                }

                                username = r["username"]?.ToString() ?? "";
                                totalAmount = r["totalAmount"] == DBNull.Value ? 0m : Convert.ToDecimal(r["totalAmount"]);
                                refundedAmount = r["refundedAmount"] == DBNull.Value ? 0m : Convert.ToDecimal(r["refundedAmount"]);
                                transactionRef = r["paymentTR"]?.ToString() ?? "";
                                refundType = r["l_refundType"] == DBNull.Value ? 0 : Convert.ToInt32(r["l_refundType"]);
                                paymentMethod1 = r["paymentMethodId"] == DBNull.Value ? 0 : Convert.ToInt32(r["paymentMethodId"]);
                                paymentMethod2 = r["paymentMethodId2"] == DBNull.Value ? 0 : Convert.ToInt32(r["paymentMethodId2"]);
                            }
                        }

                        if (string.IsNullOrWhiteSpace(transactionRef))
                        {
                            tx.Rollback();
                            (sender as ASPxCallbackPanel).JSProperties["cpMessage"] = "لا يوجد رقم معاملة للإرجاع";
                            return;
                        }

                        // تحديد المبلغ للإرجاع حسب طريقة الدفع
                        decimal refundToProcess = 0m;

                        if (paymentMethod2 == 2) // البطاقة هي الطريقة الثانية
                        {
                            refundToProcess = secondAmount;
                            if (refundToProcess > 0)
                            {
                                // نقص الرصيد من المستخدم
                                string decreaseUserSql = @"
                            UPDATE usersApp
                            SET balance = balance - @refundValue
                            WHERE username = @username";

                                using (var cmd = new SqlCommand(decreaseUserSql, conn, tx))
                                {
                                    cmd.Parameters.Add("@refundValue", SqlDbType.Decimal).Value = refundToProcess;
                                    cmd.Parameters.Add("@username", SqlDbType.NVarChar, 100).Value = username;
                                    cmd.ExecuteNonQuery();
                                }
                            }
                        }
                        else if (paymentMethod1 == 2) // البطاقة هي الطريقة الأولى
                        {
                            refundToProcess = totalAmount;
                        }
                        else
                        {
                            tx.Rollback();
                            (sender as ASPxCallbackPanel).JSProperties["cpMessage"] = "لا توجد بطاقة صالحة للإرجاع";
                            return;
                        }

                        // استدعاء API بوابة Telr
                        var result = MainHelper.TelrPaymentRefund(
                            amount: refundToProcess,
                            transactionRef: transactionRef,
                            description: "Refund to card - Order #" + orderId,
                            test: "0"
                        );

                        if (result == null || result.Status != "A")
                        {
                            tx.Rollback();
                            (sender as ASPxCallbackPanel).JSProperties["cpMessage"] = "فشل الإرجاع من البوابة: " + (result?.Message ?? "خطأ غير معروف");
                            return;
                        }

                        // ==============================
                        //   استرجاع نقاط العرض
                        // ==============================
                        string getOfferPointsSql = @"
                    SELECT points 
                    FROM pointsOffers 
                    WHERE id = (SELECT pointId FROM orders WHERE id = @orderId)
                ";

                        int offerPoints = 0;
                        using (SqlCommand cmd = new SqlCommand(getOfferPointsSql, conn, tx))
                        {
                            cmd.Parameters.AddWithValue("@orderId", orderId);
                            var val = cmd.ExecuteScalar();
                            if (val != null && val != DBNull.Value)
                                offerPoints = Convert.ToInt32(val);
                        }

                        if (offerPoints > 0)
                        {
                            string returnOfferPointsSql = @"
                        UPDATE usersApp
                        SET userPoints = userPoints + @offerPoints
                        WHERE username = @username
                    ";

                            using (SqlCommand cmd = new SqlCommand(returnOfferPointsSql, conn, tx))
                            {
                                cmd.Parameters.AddWithValue("@offerPoints", offerPoints);
                                cmd.Parameters.AddWithValue("@username", username);
                                cmd.ExecuteNonQuery();
                            }
                        }

                        // ==============================
                        //   استرجاع النقاط المستخدمة
                        // ==============================
                        string getUsedPointsSql = @"
                    SELECT pointsUsed 
                    FROM orders 
                    WHERE id = @orderId
                ";

                        int usedPoints = 0;
                        using (SqlCommand cmd = new SqlCommand(getUsedPointsSql, conn, tx))
                        {
                            cmd.Parameters.AddWithValue("@orderId", orderId);
                            var val = cmd.ExecuteScalar();
                            if (val != null && val != DBNull.Value)
                                usedPoints = Convert.ToInt32(val);
                        }

                        if (usedPoints > 0)
                        {
                            string returnUsedPointsSql = @"
                        UPDATE usersApp
                        SET userPoints = userPoints + @used
                        WHERE username = @username
                    ";

                            using (SqlCommand cmd = new SqlCommand(returnUsedPointsSql, conn, tx))
                            {
                                cmd.Parameters.AddWithValue("@used", usedPoints);
                                cmd.Parameters.AddWithValue("@username", username);
                                cmd.ExecuteNonQuery();
                            }
                        }

                        // ==============================
                        //   خصم النقاط المكتسبة (amount * 100)
                        // ==============================
                        string getAmountSql = @"SELECT totalAmount FROM orders WHERE id = @orderId";

                        decimal amount = 0;
                        using (SqlCommand cmd = new SqlCommand(getAmountSql, conn, tx))
                        {
                            cmd.Parameters.AddWithValue("@orderId", orderId);
                            var val = cmd.ExecuteScalar();
                            if (val != null && val != DBNull.Value)
                                amount = Convert.ToDecimal(val);
                        }

                        int earnedPoints = Convert.ToInt32(amount * 100);

                        if (earnedPoints > 0)
                        {
                            string deductEarnedPointsSql = @"
                        UPDATE usersApp
                        SET userPoints = userPoints - @earned
                        WHERE username = @username
                    ";

                            using (SqlCommand cmd = new SqlCommand(deductEarnedPointsSql, conn, tx))
                            {
                                cmd.Parameters.AddWithValue("@earned", earnedPoints);
                                cmd.Parameters.AddWithValue("@username", username);
                                cmd.ExecuteNonQuery();
                            }
                        }

                        // ==============================
                        //   تحديث بيانات الطلب
                        // ==============================
                        decimal newRefundedAmount = requestedRefund;
                        decimal newRealTotalAmount = totalAmount - newRefundedAmount;
                        if (newRealTotalAmount < 0m) newRealTotalAmount = 0m;

                        decimal newRealTax = Math.Round(newRealTotalAmount * 0.16m, 3);
                        string newStatus = (newRefundedAmount >= totalAmount) ? "5" : "6";

                        string updateOrderSql = @"
                    UPDATE Orders
                    SET refundedAmount = @refundedAmount,
                        realTotalAmount = @realTotalAmount,
                        realTax = @realTax,
                        l_orderStatus = @status,
                        l_refundType  = 2
                    WHERE id = @orderId";

                        using (var cmd = new SqlCommand(updateOrderSql, conn, tx))
                        {
                            cmd.Parameters.Add("@refundedAmount", SqlDbType.Decimal).Value = newRefundedAmount;
                            cmd.Parameters.Add("@realTotalAmount", SqlDbType.Decimal).Value = newRealTotalAmount;
                            cmd.Parameters.Add("@realTax", SqlDbType.Decimal).Value = newRealTax;
                            cmd.Parameters.Add("@status", SqlDbType.NVarChar, 50).Value = newStatus;
                            cmd.Parameters.Add("@orderId", SqlDbType.Int).Value = orderId;
                            cmd.ExecuteNonQuery();
                        }

                        tx.Commit();
                        (sender as ASPxCallbackPanel).JSProperties["cpMessage"] = "تمت عملية الإرجاع للبطاقة بنجاح";
                    }
                    catch (Exception ex)
                    {
                        tx.Rollback();
                        (sender as ASPxCallbackPanel).JSProperties["cpMessage"] = "حدث خطأ: " + ex.Message;
                    }
                }
            }
        }

        protected string GetOptionDisplayText(object optionNameObj, object optionPriceObj, object offerPriceObj)
        {
            string optionName = optionNameObj?.ToString();
            string optionPrice = optionPriceObj?.ToString();
            string offerPrice = offerPriceObj?.ToString();

            if (string.IsNullOrEmpty(optionName) || optionName == "لا يوجد")
                return "<span style='color:gray;'>لا يوجد</span>";

            string html = $"<div><strong>{optionName}</strong></div>";

            //if (!string.IsNullOrEmpty(optionPrice) && decimal.TryParse(optionPrice, out decimal priceVal) && priceVal > 0)
            //    html += $"<div>السعر: {priceVal}</div>";

            //if (!string.IsNullOrEmpty(offerPrice) && decimal.TryParse(offerPrice, out decimal offerVal) && offerVal > 0)
            //    html += $"<div><span style='color:red;'>سعر العرض: {offerVal}</span></div>";

            return html;
        }
        protected string GetPriceDisplayText(object priceObj, object offerObj)
        {
            string price = priceObj?.ToString();
            string offer = offerObj?.ToString();

            if (string.IsNullOrEmpty(price))
                return "<span style='color:gray;'>لا يوجد</span>";

            string html = $"<div>{price}</div>";

            if (!string.IsNullOrEmpty(offer) && decimal.TryParse(offer, out decimal offerVal) && offerVal > 0)
                html += $"<div><span style='color:red;'>سعر العرض: {offer}</span></div>";

            return html;
        }

        protected string GetTotalPaidAmount(object productPrice, object quantityObj, object weightObj)
        {
            decimal price = 0, quantity = 0, weight = 0;

            decimal.TryParse(productPrice?.ToString(), out price);

            decimal.TryParse(quantityObj?.ToString(), out quantity);
            decimal.TryParse(weightObj?.ToString(), out weight);

            decimal basePrice = price;

            decimal multiplier = quantity > 0 ? quantity : weight;

            decimal total = basePrice * multiplier;

            if (total <= 0)
                return "<span style='color:gray;'>لا يوجد</span>";

            return $"{total:F3}";
        }
        public string GetRefundStatus(
            int status,
            decimal total,
            decimal refunded,
            int paymentId,
            int id,
            int paymentMethodId2,
            int refundType,
            decimal l_paymentMethodId2Amount
        )
        {
            // ==================== تحقق من الشروط لإخفاء الزر ====================
            bool hideButton = false;

            if ((refundType == 2 && (status == 5 || status == 6)) || status >= 7 || status < 4)
                hideButton = true;

            if (hideButton)
            {
                // حالة تم الإرجاع بالكامل
                if ((status == 5 || status == 6) && (refundType == 2))
                    return "<span style='color:green;font-weight:bold;'>تم الإرجاع بالكامل</span>";

                return "يمكن الارجاع فقط في حالة تم التسليم";
            }

            // ==================== الزر يظهر دائماً في باقي الحالات ====================
            return string.Format(@"
    <a href='javascript:void(0);' 
       onclick='ShowRefundPopup({0}, {1}, {2}, {3}, {4}, {5}, {6})' 
       title='طلب إرجاع'>
        <img src='/assets/img/refund.png' style='width:40px;height:40px;' />
    </a>",
     id, total, refunded, paymentId, paymentMethodId2, refundType, l_paymentMethodId2Amount // المعطى السابع
 );

        }


    }
}