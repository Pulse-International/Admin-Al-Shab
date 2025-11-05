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
    public partial class Reports : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // عرض كل الطلبات عند التحميل
                dsOrders.SelectParameters["countryId"].DefaultValue = "0";
                dsOrders.SelectParameters["companyId"].DefaultValue = "0";
                dsOrders.SelectParameters["branchId"].DefaultValue = "0";

                dsOrders.SelectParameters["dateFrom"].DefaultValue = new DateTime(2025, 1, 1).ToString("yyyy-MM-dd");
                dsOrders.SelectParameters["dateTo"].DefaultValue = DateTime.Now.AddDays(1).ToString("yyyy-MM-dd");

                GridOrders.DataBind();
                
                

                dsOrdersInfo.SelectParameters["StatusId"].DefaultValue = "0";
                dsOrdersInfo.SelectParameters["PaymentMethodId"].DefaultValue = "0";

                dsOrdersInfo.SelectParameters["dateFrom1"].DefaultValue = new DateTime(2025, 1, 1).ToString("yyyy-MM-dd");
                dsOrdersInfo.SelectParameters["dateTo1"].DefaultValue = DateTime.Now.AddDays(1).ToString("yyyy-MM-dd");

                dsOrdersInfo.DataBind();
            }
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
        protected void cbpCompany_Callback(object sender, DevExpress.Web.CallbackEventArgsBase e)
        {
            string countryId = e.Parameter;
            if (!string.IsNullOrEmpty(countryId))
            {
                dsCompanies.SelectCommand = $"SELECT id, companyName FROM companies WHERE countryId = {countryId}";
            }
            else
            {
                dsCompanies.SelectCommand = "SELECT id, companyName FROM companies";
            }
            CompanyList.DataBind();
        }

        protected void cbpBranch_Callback(object sender, DevExpress.Web.CallbackEventArgsBase e)
        {
            string companyId = e.Parameter;
            if (!string.IsNullOrEmpty(companyId))
            {
                dsBranches.SelectCommand = $"SELECT id, name, companyId FROM branches WHERE companyId = {companyId}";
            }
            else
            {
                dsBranches.SelectCommand = "SELECT id, name, companyId FROM branches";
            }
            BranchList.DataBind();
        }
        protected void GridOrders_CustomCallback(object sender, DevExpress.Web.ASPxGridViewCustomCallbackEventArgs e)
        {
            string[] parts = e.Parameters.Split('|');
            int countryId = Convert.ToInt32(parts[0]);
            int companyId = Convert.ToInt32(parts[1]);
            int branchId = Convert.ToInt32(parts[2]);
            string dateFromStr = parts[3];
            string dateToStr = parts[4];

            DateTime dateFrom;
            DateTime dateTo;

            // إذا لم يُدخل التاريخ، استخدم 1/1/2025
            if (!DateTime.TryParse(dateFromStr, out dateFrom))
                dateFrom = new DateTime(2025, 1, 1);

            // إذا لم يُدخل تاريخ النهاية، استخدم الغد
            if (!DateTime.TryParse(dateToStr, out dateTo))
                dateTo = DateTime.Now.AddDays(1);

            dsOrders.SelectParameters["countryId"].DefaultValue = countryId.ToString();
            dsOrders.SelectParameters["companyId"].DefaultValue = companyId.ToString();
            dsOrders.SelectParameters["branchId"].DefaultValue = branchId.ToString();
            dsOrders.SelectParameters["dateFrom"].DefaultValue = dateFrom.ToString("yyyy-MM-dd");
            dsOrders.SelectParameters["dateTo"].DefaultValue = dateTo.ToString("yyyy-MM-dd");

            GridOrders.DataBind();
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
        protected void gridOrderProducts_CustomCallback(object sender, DevExpress.Web.ASPxGridViewCustomCallbackEventArgs e)
        {
            if (int.TryParse(e.Parameters, out int orderId))
            {
                dsOrderProducts.SelectParameters["orderId"].DefaultValue = orderId.ToString();
                gridOrderProducts.DataBind();
            }
        }

        protected void GridOrdersInfo_CustomCallback(object sender, ASPxGridViewCustomCallbackEventArgs e)
        {
            string[] parts = e.Parameters.Split('|');
            int status = Convert.ToInt32(parts[0]);
            int paymentMethod = Convert.ToInt32(parts[1]);
            string dateFromStr = parts[2];
            string dateToStr = parts[3];

            DateTime dateFrom;
            DateTime dateTo;

            // إذا لم يُدخل التاريخ، استخدم 1/1/2025
            if (!DateTime.TryParse(dateFromStr, out dateFrom))
                dateFrom = new DateTime(2025, 1, 1);

            // إذا لم يُدخل تاريخ النهاية، استخدم الغد
            if (!DateTime.TryParse(dateToStr, out dateTo))
                dateTo = DateTime.Now.AddDays(1);


            dsOrdersInfo.SelectParameters["StatusId"].DefaultValue = status.ToString();
            dsOrdersInfo.SelectParameters["PaymentMethodId"].DefaultValue = paymentMethod.ToString();
            dsOrdersInfo.SelectParameters["dateFrom1"].DefaultValue = dateFrom.ToString("yyyy-MM-dd");
            dsOrdersInfo.SelectParameters["dateTo1"].DefaultValue = dateTo.ToString("yyyy-MM-dd");

            GridOrdersInfo.DataBind();
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

    }
}