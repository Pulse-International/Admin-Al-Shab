using DevExpress.Web;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.Script.Serialization;
using System.Web.UI;

namespace ShabAdmin
{
    public partial class mRealOrders : Page
    {
        public String Key;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string googleKey = System.Configuration.ConfigurationManager.AppSettings["GoogleMapsApiKey"];
                string scriptUrl = $"https://maps.googleapis.com/maps/api/js?key={googleKey}";
                Key = scriptUrl;
            }
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
                    o.[l_orderStatus],
                    o.[companyId], 
                    c.[countryID] AS countryId,
                    o.[usersDeliveryId],
                    ud.[username]   AS deliveryUserName,
                    ud.[firstName]  AS deliveryFirstName,
                    ud.[lastName]   AS deliveryLastName,
                    o.[username], 
                    b.[name]  AS branchName, 
                    b.[phone] AS branchPhone,
                    ua.[firstName], 
                    ua.[lastName],                      
                    o.[addressId], 
                    o.[userDate]
                FROM [Orders] o
                JOIN [companies] c ON o.companyId = c.id
                JOIN [usersApp] ua ON o.username = ua.username
                JOIN [branches] b ON o.branchId = b.id
                LEFT JOIN [usersDelivery] ud ON o.usersDeliveryId = ud.id
                WHERE 
                    ((o.[l_orderStatus] = 1) or (o.[l_orderStatus] = 2) or (o.[l_orderStatus] = 3))
                    AND o.companyId = @companyId 
                    AND c.countryID = @countryId order by o.id desc";

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
                    o.[l_orderStatus],
                    o.[companyId],
                    c.[countryID] AS countryId,
                    o.[usersDeliveryId],
                    ud.[username]   AS deliveryUserName,
                    ud.[firstName]  AS deliveryFirstName,
                    ud.[lastName]   AS deliveryLastName,
                    o.[username],
                    b.[name]  AS branchName,
                    b.[phone] AS branchPhone,
                    ua.[firstName],
                    ua.[lastName],
                    o.[addressId],
                    o.[userDate]
                FROM [Orders] o
                JOIN [companies] c ON o.companyId = c.id
                JOIN [usersApp] ua ON o.[username] = ua.[username]
                JOIN [branches] b ON o.[branchId] = b.[id]
                LEFT JOIN [usersDelivery] ud ON o.[usersDeliveryId] = ud.[id]
                WHERE 
                    ((o.[l_orderStatus] = 1) or (o.[l_orderStatus] = 2) or (o.[l_orderStatus] = 3))
                    AND c.[countryID] = @countryId order by o.id desc";

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
                    o.[l_orderStatus],
                    o.[companyId], 
                    c.[countryID] AS countryId,
                    o.usersDeliveryId,
                    ud.username AS deliveryUserName,
                    ud.firstName AS deliveryFirstName,
                    ud.lastName AS deliveryLastName,
                    o.[username], 
                    b.[name] AS branchName, 
                    b.[phone] AS branchPhone,
                    ua.[firstName], 
                    ua.[lastName],                      
                    o.[addressId], 
                    o.[userDate]
                FROM [Orders] o
                JOIN [companies] c ON o.companyId = c.id
                JOIN [usersApp] ua ON o.username = ua.username
                JOIN [branches] b ON o.branchId = b.id
                LEFT JOIN [usersDelivery] ud ON o.usersDeliveryId = ud.id
                WHERE 
                ((o.[l_orderStatus] = 1) or (o.[l_orderStatus] = 2) or (o.[l_orderStatus] = 3))
                order by o.id desc";


                dsCountries.SelectCommand = "SELECT id, countryName FROM countries WHERE id <> 1000";
                dsCompanies.SelectCommand = "SELECT id, companyName FROM companies WHERE id <> 1000";
            }
        }

        public string GetOrderStatusLottie(string status)
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
                        src='/assets/animations/canceled.json' 
                        background='transparent' 
                        speed='1' 
                        style='width: 110px; height: 110px; margin: 0 auto;' 
                        loop 
                        autoplay>
                    </lottie-player>
                    <div style='margin-top: 5px; font-size: 0.95em; color: #d9534f;'>ملغي من الإدارة</div>
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
                        ol.[latitude],
                        ol.[longitude]
                    FROM orders o
                    INNER JOIN ordersLocation ol ON o.id = ol.orderId
                    WHERE o.id = @id", conn);

                    cmd.Parameters.AddWithValue("@id", addressId);



                    SqlDataReader reader = cmd.ExecuteReader();
                    if (reader.Read())
                    {
                        string latitude = reader["latitude"].ToString();
                        string longitude = reader["longitude"].ToString();
                        string mapDivId = $"map_{addressId}";

                        // ضع بيانات الخريطة هنا كـ JSON String
                        var mapData = new
                        {
                            lat = latitude,
                            lng = longitude,
                            mapId = mapDivId,
                        };
                        string json = new System.Web.Script.Serialization.JavaScriptSerializer().Serialize(mapData);

                        // أرسلها عبر JSProperties
                        callbackAddress.JSProperties["cpMapData"] = json;

                        lblAddressInfo.Text = $@"
                        <div style='font-family: Cairo; direction: rtl; font-size: 1.1em; line-height: 2; padding: 20px; background-color: #f9f9f9; border-radius: 10px; border: 1px solid #ddd; max-width: 100%;'>
                            <div style='display: flex; flex-direction: row; flex-wrap: nowrap; gap: 20px; max-width: 100%;'>
                                <div style='width: 100%;'>
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

        protected void callbackLocation_Callback(object sender, CallbackEventArgsBase e)
        {
            int locationId;
            if (int.TryParse(e.Parameter, out locationId))
            {
                System.Diagnostics.Debug.WriteLine("📍 Received locationId: " + locationId);

                string connStr = ConfigurationManager.ConnectionStrings["ShabDB_connection"].ConnectionString;
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();
                    SqlCommand cmd = new SqlCommand(@"
                    SELECT ol.latitude, ol.longitude, u.l_vehicleType
                        FROM ordersLocation ol
                        JOIN Orders o ON ol.orderId = o.id
                        JOIN usersDelivery u ON o.usersDeliveryId = u.id
                        WHERE ol.orderId = @id
                        ", conn);

                    cmd.Parameters.AddWithValue("@id", locationId);

                    SqlDataReader reader = cmd.ExecuteReader();
                    if (reader.Read())
                    {
                        var mapData = new
                        {
                            lat = Convert.ToString(reader["latitude"]),
                            lng = Convert.ToString(reader["longitude"]),
                            l_vehicleType = Convert.ToString(reader["l_vehicleType"]),
                            mapId = "map_" + locationId,
                            title = "عنوان الطلب",
                            city = "عمّان",
                            area = "الدوار السابع"
                        };

                        string json = new System.Web.Script.Serialization.JavaScriptSerializer().Serialize(mapData);
                        callbackLocation.JSProperties["cpMapData"] = json;
                        System.Diagnostics.Debug.WriteLine("✅ Returned JSON: " + json);
                        return;
                    }
                    else
                    {
                        System.Diagnostics.Debug.WriteLine("❌ No location found for id: " + locationId);
                    }
                }

                callbackLocation.JSProperties["cpMapData"] = "null";
            }
            else
            {
                System.Diagnostics.Debug.WriteLine("❌ Invalid parameter: " + e.Parameter);
                callbackLocation.JSProperties["cpMapData"] = "invalid";
            }
        }



        protected void callbackDriversMap_Callback(object sender, CallbackEventArgsBase e)
        {
            List<object> locations = new List<object>();
            string connStr = ConfigurationManager.ConnectionStrings["ShabDB_connection"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                SqlCommand cmd = new SqlCommand(@"
            SELECT 
                ol.latitude, 
                ol.longitude, 
                ol.orderId,
                u.firstName,
                u.lastName,
                u.l_vehicleType
            FROM ordersLocation ol
            JOIN Orders o ON ol.orderId = o.id
            JOIN usersDelivery u ON o.usersDeliveryId = u.id
            WHERE o.l_orderStatus = 3", conn);

                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        locations.Add(new
                        {
                            latitude = reader["latitude"].ToString(),
                            longitude = reader["longitude"].ToString(),
                            orderId = reader["orderId"].ToString(),
                            firstName = reader["firstName"].ToString(),
                            l_vehicleType = reader["l_vehicleType"].ToString(),
                            lastName = reader["lastName"].ToString()
                        });
                    }
                }
            }

            var json = new JavaScriptSerializer().Serialize(locations);
            callbackDriversMap.JSProperties["cpMapData"] = json;
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
        protected string GetOptionDisplayText(object optionNameObj, object optionPriceObj, object offerPriceObj)
        {
            string optionName = optionNameObj?.ToString();
            string optionPrice = optionPriceObj?.ToString();
            string offerPrice = offerPriceObj?.ToString();

            // إذا ما في خيار أو القيمة "لا يوجد"
            if (string.IsNullOrEmpty(optionName) || optionName == "لا يوجد")
                return "<span style='color:gray;'>لا يوجد</span>";

            // إنشاء النص
            string html = $"<div><strong>{optionName}</strong></div>";

            //if (!string.IsNullOrEmpty(optionPrice))
            //    html += $"<div>السعر:{optionPrice}</div>";

            //// عرض السعر المخفض فقط إذا أكبر من 0
            //if (!string.IsNullOrEmpty(offerPrice) && decimal.TryParse(offerPrice, out decimal offerVal) && offerVal > 0)
            //    html += $"<div><span style='color:red;'>سعر العرض: {offerPrice}</span></div>";

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
                return "<span style='color:gray;'>0</span>";

            return $"{total:F3}";
        }

        protected void GridOrders_CustomCallback(object sender, ASPxGridViewCustomCallbackEventArgs e)
        {
            string[] parts = e.Parameters.Split(':');

            if (parts[0] == "reject")
            {
                int orderId = Convert.ToInt32(parts[1]);
                string rejectNote = parts[2];

                using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ShabDB_connection"].ConnectionString))
                {
                    conn.Open();
                    using (var tx = conn.BeginTransaction())
                    {
                        try
                        {
                            string getOrderSql = @"
                        SELECT id, username, totalAmount, l_paymentMethodId, l_paymentMethodId2, l_paymentMethodId2Amount, refundedAmount
                        FROM orders
                        WHERE id = @orderId
                    ";

                            string username = "";
                            decimal totalAmount = 0;
                            int l_paymentMethodId = 0, l_paymentMethodId2 = 0;
                            decimal l_paymentMethodId2Amount = 0;
                            decimal existingRefundedAmount = 0;

                            using (SqlCommand cmd = new SqlCommand(getOrderSql, conn, tx))
                            {
                                cmd.Parameters.AddWithValue("@orderId", orderId);
                                using (SqlDataReader r = cmd.ExecuteReader())
                                {
                                    if (!r.Read())
                                    {
                                        tx.Rollback();
                                        (sender as ASPxGridView).JSProperties["cpMessage"] = "الطلب غير موجود";
                                        return;
                                    }

                                    username = r["username"]?.ToString();
                                    totalAmount = r["totalAmount"] == DBNull.Value ? 0 : Convert.ToDecimal(r["totalAmount"]);
                                    l_paymentMethodId = r["l_paymentMethodId"] == DBNull.Value ? 0 : Convert.ToInt32(r["l_paymentMethodId"]);
                                    l_paymentMethodId2 = r["l_paymentMethodId2"] == DBNull.Value ? 0 : Convert.ToInt32(r["l_paymentMethodId2"]);
                                    l_paymentMethodId2Amount = r["l_paymentMethodId2Amount"] == DBNull.Value ? 0 : Convert.ToDecimal(r["l_paymentMethodId2Amount"]);
                                    existingRefundedAmount = r["refundedAmount"] == DBNull.Value ? 0 : Convert.ToDecimal(r["refundedAmount"]);
                                }
                            }

                            decimal refundToBalance = 0;

                            if (l_paymentMethodId > 0 && l_paymentMethodId2 == 0)
                            {
                                if (l_paymentMethodId == 2 || l_paymentMethodId == 3)
                                    refundToBalance = totalAmount;
                                else
                                    refundToBalance = 0; 
                            }
                            else if (l_paymentMethodId > 0 && l_paymentMethodId2 > 0)
                            {
                                if (l_paymentMethodId == 1)
                                {
                                    refundToBalance = l_paymentMethodId2Amount;
                                }
                                else if ((l_paymentMethodId == 2 || l_paymentMethodId == 3) && l_paymentMethodId2 == 1)
                                {
                                    refundToBalance = totalAmount - l_paymentMethodId2Amount;
                                }
                                else if ((l_paymentMethodId == 2 || l_paymentMethodId == 3) && (l_paymentMethodId == 2 || l_paymentMethodId == 3))
                                {
                                    refundToBalance = totalAmount;
                                }
                                else
                                {
                                    refundToBalance = 0;
                                }
                            }
                            else
                            {
                                refundToBalance = 0;
                            }

                            string user = MainHelper.M_Check(Request.Cookies["M_Username"]?.Value);

                            string updateOrderSql = @"
                        UPDATE orders
                        SET l_orderStatus = 9,
                            rejectNote = @note,
                            l_refundType = 3,
                            refundedAmount = @refundedAmount,
                            refundedUser = @refundedUser
                        WHERE id = @id
                    ";

                            using (SqlCommand cmd = new SqlCommand(updateOrderSql, conn, tx))
                            {
                                cmd.Parameters.AddWithValue("@id", orderId);
                                cmd.Parameters.AddWithValue("@note", rejectNote);
                                cmd.Parameters.AddWithValue("@refundedAmount", refundToBalance > 0 ? refundToBalance : 0);
                                cmd.Parameters.AddWithValue("@refundedUser", user);
                                cmd.ExecuteNonQuery();
                            }

\                            if (refundToBalance > 0)
                            {
                                string updateUserBalanceSql = @"
                            UPDATE usersApp
                            SET balance = balance + @refund
                            WHERE username = @username
                        ";

                                using (SqlCommand cmd = new SqlCommand(updateUserBalanceSql, conn, tx))
                                {
                                    cmd.Parameters.AddWithValue("@refund", refundToBalance);
                                    cmd.Parameters.AddWithValue("@username", username);
                                    cmd.ExecuteNonQuery();
                                }
                            }

                            tx.Commit();
                            GridOrders.DataBind();
                            (sender as ASPxGridView).JSProperties["cpMessage"] = "تم رفض الطلب وتحديث المحفظة بنجاح";
                        }
                        catch (Exception ex)
                        {
                            tx.Rollback();
                            (sender as ASPxGridView).JSProperties["cpMessage"] = "حدث خطأ: " + ex.Message;
                        }
                    }
                }
            }
        }

    }
}