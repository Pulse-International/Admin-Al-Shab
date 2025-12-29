using DevExpress.Web;
using DevExpress.Web.Data;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ShabAdmin
{
    public partial class mRates : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void Page_Init(object sender, EventArgs e)
        {
            var (countryId, companyId) = GetUserPrivileges();

            db_Products.SelectParameters.Clear();
            db_Companies.SelectParameters.Clear();
            db_ProductRates.SelectParameters.Clear();
            db_OrderRates.SelectParameters.Clear();
            db_DeliveryRates.SelectParameters.Clear();
            db_DeliveryUsers.SelectParameters.Clear();
            db_productName.SelectParameters.Clear();
            db_companyName.SelectParameters.Clear();
            db_countryName.SelectParameters.Clear();

            if (countryId != 1000 && companyId != 1000)
            {
                db_Products.SelectCommand =
                    "SELECT id,name,countryId,companyId,rate,rateCount " +
                    "FROM products WHERE rate > 0 AND countryId = @countryId AND companyId = @companyId ORDER BY id DESC";
                db_Products.SelectParameters.Add("countryId", countryId.ToString());
                db_Products.SelectParameters.Add("companyId", companyId.ToString());

                db_Companies.SelectCommand =
                    "SELECT id,companyName,countryId,rate,rateCount " +
                    "FROM companies WHERE rate > 0 AND countryId = @countryId AND id = @companyId ORDER BY id DESC";
                db_Companies.SelectParameters.Add("countryId", countryId.ToString());
                db_Companies.SelectParameters.Add("companyId", companyId.ToString());

                db_ProductRates.SelectCommand = @"
SELECT 
    pr.id,
    pr.rate,
    pr.rateDesc,
    pr.userDate,
    pr.rateApproved,
    pr.orderId,
    o.username,
    ua.firstName + ' ' + ua.lastName AS fullName,  
    pr.productId,
    p.countryId,
    p.companyId
FROM productsRates AS pr
INNER JOIN products AS p ON pr.productId = p.id
INNER JOIN orders AS o ON o.id = pr.orderId
LEFT JOIN usersApp AS ua ON ua.username = o.username  
WHERE p.countryId = @countryId
  AND p.companyId = @companyId
ORDER BY pr.id DESC";

                db_ProductRates.SelectParameters.Add("countryId", countryId.ToString());
                db_ProductRates.SelectParameters.Add("companyId", companyId.ToString());

                db_OrderRates.SelectCommand = @"
SELECT 
    o.id,
    o.companyId,
    o.countryId,
    o.rate,
    o.rateDesc,
    o.rateDate,
    o.rateApproved,
    o.totalAmount,
    o.username,                                    
    ua.firstName + ' ' + ua.lastName AS fullName     
FROM orders AS o
LEFT JOIN usersApp AS ua ON ua.username = o.username
WHERE o.rate > 0 
  AND o.companyId = @companyId
  AND o.countryId = @countryId
ORDER BY o.id DESC";

                db_OrderRates.SelectParameters.Add("companyId", companyId.ToString());
                db_OrderRates.SelectParameters.Add("countryId", countryId.ToString());


                db_DeliveryRates.SelectCommand = @"
SELECT 
    r.id, 
    r.userDeliveryId, 
    (u.firstName + ' ' + u.lastName) AS deliveryFullName,
    u.username AS deliveryUsername,
    ua.username AS appUsername,
    (ua.firstName + ' ' + ua.lastName) AS appFullName,
    r.rate, 
    r.rateDesc,
    o.countryId,
    o.companyId,
    r.userDate, 
    r.rateApproved,
    r.orderId
FROM usersDeliveryRates AS r
JOIN orders AS o ON o.id = r.orderId
INNER JOIN usersDelivery AS u ON r.userDeliveryId = u.id
LEFT JOIN usersApp AS ua ON ua.username = o.username 
WHERE r.rate > 0 
  AND u.countryId = @countryId 
  AND o.companyId = @companyId
ORDER BY r.id DESC";

                db_DeliveryRates.SelectParameters.Add("countryId", countryId.ToString());
                db_DeliveryRates.SelectParameters.Add("companyId", companyId.ToString());


                db_DeliveryUsers.SelectCommand = @"
SELECT id, (firstName + ' ' + lastName) AS fullName, countryId, username, rate, rateCount
FROM usersDelivery
WHERE rate > 0 AND countryId = @countryId
ORDER BY id DESC";
                db_DeliveryUsers.SelectParameters.Add("countryId", countryId.ToString());

                db_productName.SelectCommand =
                    "SELECT id, name FROM products WHERE countryId = @countryId AND companyId = @companyId";
                db_productName.SelectParameters.Add("countryId", countryId.ToString());
                db_productName.SelectParameters.Add("companyId", companyId.ToString());

                db_companyName.SelectCommand =
                    "SELECT id, companyName FROM companies WHERE id = @companyId AND countryId = @countryId";
                db_companyName.SelectParameters.Add("companyId", companyId.ToString());
                db_companyName.SelectParameters.Add("countryId", countryId.ToString());

                db_countryName.SelectCommand =
                    "SELECT id, countryName FROM countries WHERE id = @countryId AND id <> 1000";
                db_countryName.SelectParameters.Add("countryId", countryId.ToString());
            }
            else if (countryId != 1000)
            {
                db_Products.SelectCommand =
                    "SELECT id,name,countryId,companyId,rate,rateCount FROM products WHERE rate > 0 AND countryId = @countryId ORDER BY id DESC";
                db_Products.SelectParameters.Add("countryId", countryId.ToString());

                db_Companies.SelectCommand =
                    "SELECT id,companyName,countryId,rate,rateCount FROM companies WHERE rate > 0 AND countryId = @countryId ORDER BY id DESC";
                db_Companies.SelectParameters.Add("countryId", countryId.ToString());

                db_ProductRates.SelectCommand = @"
SELECT 
    pr.id,
    pr.rate,
    pr.rateDesc,
    pr.userDate,
    pr.rateApproved,
    pr.orderId,
    o.username,
    ua.firstName + ' ' + ua.lastName AS fullName,  
    pr.productId,
    p.countryId,
    p.companyId
FROM productsRates AS pr
INNER JOIN products AS p ON pr.productId = p.id
INNER JOIN orders AS o ON o.id = pr.orderId
LEFT JOIN usersApp AS ua ON ua.username = o.username  
WHERE p.countryId = @countryId
ORDER BY pr.id DESC";
                db_ProductRates.SelectParameters.Add("countryId", countryId.ToString());

                db_OrderRates.SelectCommand = @"
SELECT 
    o.id,
    o.companyId,
    o.countryId,
    o.rate,
    o.rateDesc,
    o.rateDate,
    o.rateApproved,
    o.totalAmount,
    o.username,                                    
    ua.firstName + ' ' + ua.lastName AS fullName     
FROM orders AS o
LEFT JOIN usersApp AS ua ON ua.username = o.username
WHERE o.rate > 0 
  AND o.countryId = @countryId
ORDER BY o.id DESC";

                db_OrderRates.SelectParameters.Add("countryId", countryId.ToString());

                db_DeliveryRates.SelectCommand = @"
SELECT 
    r.id, 
    r.userDeliveryId, 
    (u.firstName + ' ' + u.lastName) AS deliveryFullName,
    u.username AS deliveryUsername,
    ua.username AS appUsername,
    (ua.firstName + ' ' + ua.lastName) AS appFullName,
    r.rate, 
    r.rateDesc,
    o.countryId,
    o.companyId,
    r.userDate, 
    r.rateApproved,
    r.orderId
FROM usersDeliveryRates AS r
JOIN orders AS o ON o.id = r.orderId
INNER JOIN usersDelivery AS u ON r.userDeliveryId = u.id
LEFT JOIN usersApp AS ua ON ua.username = o.username 
WHERE r.rate > 0 AND o.countryId = @countryId
ORDER BY r.id DESC";
                db_DeliveryRates.SelectParameters.Add("countryId", countryId.ToString());

                db_DeliveryUsers.SelectCommand = @"
SELECT id, (firstName + ' ' + lastName) AS fullName, countryId, username, rate, rateCount
FROM usersDelivery 
WHERE rate > 0 AND countryId = @countryId
ORDER BY id DESC";
                db_DeliveryUsers.SelectParameters.Add("countryId", countryId.ToString());

                db_productName.SelectCommand = "SELECT id, name FROM products WHERE countryId = @countryId";
                db_productName.SelectParameters.Add("countryId", countryId.ToString());

                db_companyName.SelectCommand =
                    "SELECT id, companyName FROM companies WHERE countryId = @countryId AND id <> 1000";
                db_companyName.SelectParameters.Add("countryId", countryId.ToString());

                db_countryName.SelectCommand =
                    "SELECT id, countryName FROM countries WHERE id = @countryId AND id <> 1000";
                db_countryName.SelectParameters.Add("countryId", countryId.ToString());
            }
            else
            {
                db_Products.SelectCommand =
                    "SELECT id,name,countryId,companyId,rate,rateCount FROM products WHERE rate > 0 ORDER BY id DESC";
                db_Companies.SelectCommand =
                    "SELECT id,companyName,countryId,rate,rateCount FROM companies WHERE rate > 0 AND id <> 1000 ORDER BY id DESC";

                db_ProductRates.SelectCommand = @"
SELECT 
    pr.id,
    pr.rate,
    pr.rateDesc,
    pr.userDate,
    pr.rateApproved,
    pr.orderId,
    o.username ,
    ua.firstName + ' ' + ua.lastName AS fullName,  
    pr.productId,
    p.countryId,
    p.companyId
FROM productsRates AS pr
INNER JOIN products AS p ON pr.productId = p.id
INNER JOIN orders AS o ON o.id = pr.orderId
LEFT JOIN usersApp AS ua ON ua.username = o.username  
ORDER BY pr.id DESC";

                db_OrderRates.SelectCommand = @"
SELECT 
    o.id,
    o.companyId,
    o.countryId,
    o.rate,
    o.rateDesc,
    o.rateDate,
    o.rateApproved,
    o.totalAmount,
    o.username,                                    
    ua.firstName + ' ' + ua.lastName AS fullName     
FROM orders AS o
LEFT JOIN usersApp AS ua ON ua.username = o.username
WHERE o.rate > 0 
ORDER BY o.id DESC";

                db_DeliveryRates.SelectCommand = @"
SELECT 
    r.id, 
    r.userDeliveryId, 
    (u.firstName + ' ' + u.lastName) AS deliveryFullName,
    u.username AS deliveryUsername,
    ua.username AS appUsername,
    (ua.firstName + ' ' + ua.lastName) AS appFullName,
    r.rate, 
    r.rateDesc,
    o.countryId,
    o.companyId,
    r.userDate, 
    r.rateApproved,
    r.orderId
FROM usersDeliveryRates AS r
JOIN orders AS o ON o.id = r.orderId
INNER JOIN usersDelivery AS u ON r.userDeliveryId = u.id
LEFT JOIN usersApp AS ua ON ua.username = o.username 
WHERE r.rate > 0
ORDER BY r.id DESC";

                db_DeliveryUsers.SelectCommand = @"
SELECT id, (firstName + ' ' + lastName) AS fullName, countryId, username, rate, rateCount
FROM usersDelivery
WHERE rate > 0
ORDER BY id DESC";

                db_productName.SelectCommand = "SELECT id, name FROM products";
                db_countryName.SelectCommand = "SELECT id, countryName FROM countries WHERE id <> 1000";
                db_companyName.SelectCommand = "SELECT id, companyName FROM companies WHERE id <> 1000";
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

                GridProductRates.DataBind();
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

                GridProductRates.DataBind();
            }
        }
        protected string GetFirstImagePath(object deliveryRateIdObj)
        {
            if (deliveryRateIdObj == null)
                return "/assets/uploads/noFile.png";

            int deliveryRateId;
            if (!int.TryParse(deliveryRateIdObj.ToString(), out deliveryRateId))
                return "/assets/uploads/noFile.png";

            string connStr = ConfigurationManager.ConnectionStrings["ShabDB_connection"].ConnectionString;
            string imagePath = string.Empty;

            using (var conn = new SqlConnection(connStr))
            {
                conn.Open();

                // نجيب الـ userPicture بناءً على الـ userDeliveryId الموجود في usersDeliveryRates
                string sql = @"
            SELECT TOP 1 u.userPicture
            FROM usersDeliveryRates r
            INNER JOIN usersDelivery u ON r.userDeliveryId = u.id
            WHERE r.id = @RateId";

                using (var cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@RateId", deliveryRateId);

                    var result = cmd.ExecuteScalar();
                    if (result != null && result != DBNull.Value)
                        imagePath = result.ToString();
                }
            }

            if (string.IsNullOrEmpty(imagePath))
                return "/assets/uploads/noFile.png"; // صورة افتراضية إذا ما لقى

            return imagePath;
        }
        protected string GetProductFirstImagePath(object productIdObj)
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
    }
}