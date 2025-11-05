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
    public partial class mRefund : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        protected void Page_Init(object sender, EventArgs e)
        {
            var (countryId, companyId) = GetUserPrivileges();

            db_Refunds.SelectParameters.Clear();
            dsCompanies.SelectParameters.Clear();

            if (countryId != 1000 && companyId != 1000)
            {
                db_Refunds.SelectParameters.Add("companyId", companyId.ToString());
                db_Refunds.SelectParameters.Add("countryId", countryId.ToString());

                db_Refunds.SelectCommand = @"
            SELECT 
                o.id,
                o.username,
                o.companyId,
                o.countryId,
                c.[companyName] AS companyName, 
                co.[countryName] AS countryName,
                o.amount,
                o.deliveryAmount,
                o.taxAmount,
                o.totalAmount,
                o.refundedAmount,
                u.[firstName] + ' ' + u.[lastName] AS fullName,
                o.realTax,
                o.realTotalAmount,
                o.refundedUser,
                o.l_orderStatus
            FROM orders o
            LEFT JOIN [usersApp] u ON o.username = u.username
            JOIN [companies] c ON o.companyId = c.id
            LEFT JOIN countries co ON c.countryID = co.id
            WHERE (o.l_orderStatus = 5 OR o.l_orderStatus = 6)
              AND o.companyId = @companyId 
              AND o.countryId = @countryId
            ORDER BY o.id DESC";

                dsCompanies.SelectParameters.Add("companyId", companyId.ToString());
                dsCompanies.SelectCommand = "SELECT id, companyName FROM companies WHERE id = @companyId";
            }
            else if (countryId != 1000)
            {
                db_Refunds.SelectParameters.Add("countryId", countryId.ToString());

                db_Refunds.SelectCommand = @"
            SELECT 
                o.id,
                o.username,
                o.companyId,
                o.countryId,
                c.[companyName] AS companyName, 
                co.[countryName] AS countryName,
                o.amount,
                o.deliveryAmount,
                o.taxAmount,
                o.totalAmount,
                o.refundedAmount,
                u.[firstName] + ' ' + u.[lastName] AS fullName,
                o.realTax,
                o.realTotalAmount,
                o.refundedUser,
                o.l_orderStatus
            FROM orders o
            LEFT JOIN [usersApp] u ON o.username = u.username
            JOIN [companies] c ON o.companyId = c.id
            LEFT JOIN countries co ON c.countryID = co.id
            WHERE o.countryId = @countryId 
              AND (o.l_orderStatus = 5 OR o.l_orderStatus = 6)
            ORDER BY o.id DESC";

                dsCompanies.SelectParameters.Add("countryId", countryId.ToString());
                dsCompanies.SelectCommand = "SELECT id, companyName FROM companies WHERE countryID = @countryId";
            }
            else
            {
                db_Refunds.SelectCommand = @"
            SELECT 
                o.id,
                o.username,
                o.companyId,
                o.countryId,
                c.[companyName] AS companyName, 
                co.[countryName] AS countryName,
                o.amount,
                o.deliveryAmount,
                o.taxAmount,
                o.totalAmount,
                o.refundedAmount,
                u.[firstName] + ' ' + u.[lastName] AS fullName,
                o.realTax,
                o.realTotalAmount,
                o.refundedUser,
                o.l_orderStatus
            FROM orders o
            LEFT JOIN [usersApp] u ON o.username = u.username
            JOIN [companies] c ON o.companyId = c.id
            LEFT JOIN countries co ON c.countryID = co.id
            WHERE (o.l_orderStatus = 5 OR o.l_orderStatus = 6)
            ORDER BY o.id DESC";

                dsCompanies.SelectCommand = "SELECT id, companyName FROM companies WHERE id <> 1000";
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
    }
}