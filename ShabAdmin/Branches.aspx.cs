using DevExpress.Web;
using DevExpress.Web.Data;
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ShabAdmin
{
    public partial class Branches : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void Page_Init(object sender, EventArgs e)
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

            if (privilegeCompanyID !=1000 && privilegeCountryID != 1000)
            {
                db_Branches.SelectCommand = @"
                        SELECT 
                            b.[id], 
                            b.[name], 
                            b.[l_branchStatus],
                            b.[cityId], 
                            b.[countryId], 
                            b.[companyId], 
                            c.[companyName], 
                            b.[latitude], 
                            b.[longitude], 
                            b.[zone],
                            b.[phone], 
                            b.[extensionNumber],
                            b.[isMain]
                        FROM branches b
                        LEFT JOIN companies c ON b.companyId = c.id
                        WHERE b.companyId = @companyID AND b.countryId = @countryID
                        ORDER BY b.id ASC";

                db_Branches.SelectParameters.Clear();
                db_Branches.SelectParameters.Add("companyID", privilegeCompanyID.ToString());
                db_Branches.SelectParameters.Add("countryID", privilegeCountryID.ToString());

                DB_Cities.SelectParameters.Clear();
                DB_Cities.SelectCommand = @"SELECT id, cityName FROM cities WHERE countryId = @countryID";
                DB_Cities.SelectParameters.Add("countryID", privilegeCountryID.ToString());


                DB_Companies.SelectParameters.Clear();
                DB_Companies.SelectCommand = @"SELECT id,companyName FROM companies WHERE countryId = @countryID AND id = @companyID";
                DB_Companies.SelectParameters.Add("countryID", privilegeCountryID.ToString());
                DB_Companies.SelectParameters.Add("companyID", privilegeCompanyID.ToString());

                DB_Countries.SelectParameters.Clear();
                DB_Countries.SelectCommand = @"SELECT * FROM countries WHERE id = @countryID";
                DB_Countries.SelectParameters.Add("countryID", privilegeCountryID.ToString());
            }
            else if (privilegeCountryID != 1000)
            {
                db_Branches.SelectCommand = @"
                        SELECT 
                            b.[id], 
                            b.[name], 
                            b.[l_branchStatus],
                            b.[cityId], 
                            b.[countryId], 
                            b.[companyId], 
                            c.[companyName], 
                            b.[latitude], 
                            b.[longitude], 
                            b.[zone],
                            b.[phone], 
                            b.[extensionNumber],
                            b.[isMain]
                        FROM branches b
                        LEFT JOIN companies c ON b.companyId = c.id
                        WHERE b.countryId = @countryID
                        ORDER BY b.id ASC";

                db_Branches.SelectParameters.Clear();
                db_Branches.SelectParameters.Add("countryID", privilegeCountryID.ToString());

                DB_Cities.SelectParameters.Clear();
                DB_Cities.SelectCommand = @"SELECT id, cityName FROM cities WHERE countryId = @countryID";
                DB_Cities.SelectParameters.Add("countryID", privilegeCountryID.ToString());
                
                DB_Companies.SelectParameters.Clear();
                DB_Companies.SelectCommand = @"SELECT id,companyName FROM companies WHERE countryId = @countryID";
                DB_Companies.SelectParameters.Add("countryID", privilegeCountryID.ToString());

                DB_Countries.SelectParameters.Clear();
                DB_Countries.SelectCommand = @"SELECT * FROM countries WHERE id = @countryID";
                DB_Countries.SelectParameters.Add("countryID", privilegeCountryID.ToString());
            }
        }


        protected void cpCompany_Callback(object sender, DevExpress.Web.CallbackEventArgsBase e)
        {
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
                int countryId;
                if (int.TryParse(e.Parameter, out countryId))
                {
                    string query = "SELECT id, companyName FROM companies WHERE countryID = @countryID AND id = @companyID";
                    SqlDataSource ds = new SqlDataSource(ConfigurationManager.ConnectionStrings["ShabDB_connection"].ConnectionString, query);
                    ds.SelectParameters.Add("countryID", countryId.ToString());
                    ds.SelectParameters.Add("companyID", privilegeCompanyID.ToString());

                    ASPxCallbackPanel panel = sender as ASPxCallbackPanel;
                    ASPxComboBox combo = panel.FindControl("comboCompany") as ASPxComboBox;
                    combo.DataSource = ds;
                    combo.DataBind();
                }
            }
            else {
                int countryId;
                if (int.TryParse(e.Parameter, out countryId))
                {
                    string query = "SELECT id, companyName FROM companies WHERE countryID = @countryID";
                    SqlDataSource ds = new SqlDataSource(ConfigurationManager.ConnectionStrings["ShabDB_connection"].ConnectionString, query);
                    ds.SelectParameters.Add("countryID", countryId.ToString());

                    ASPxCallbackPanel panel = sender as ASPxCallbackPanel;
                    ASPxComboBox combo = panel.FindControl("comboCompany") as ASPxComboBox;
                    combo.DataSource = ds;
                    combo.DataBind();
                }
            }
            
        }

        protected void GridBranches_RowInserting(object sender, ASPxDataInsertingEventArgs e)
        {
            ASPxCallbackPanel companyPanel = GridBranches.FindEditRowCellTemplateControl(
                (GridViewDataColumn)GridBranches.Columns["companyId"],
                "cpCompany"
            ) as ASPxCallbackPanel;

            ASPxComboBox comboCompany = companyPanel?.FindControl("comboCompany") as ASPxComboBox;

            if (comboCompany != null && comboCompany.Value != null)
            {
                int companyId = Convert.ToInt32(comboCompany.Value);
                e.NewValues["companyId"] = companyId;
            }
        }

        protected void GridBranches_RowUpdating(object sender, ASPxDataUpdatingEventArgs e)
        {
            ASPxCallbackPanel companyPanel = GridBranches.FindEditRowCellTemplateControl(
               (GridViewDataColumn)GridBranches.Columns["companyId"],
               "cpCompany"
           ) as ASPxCallbackPanel;

            ASPxComboBox comboCompany = companyPanel?.FindControl("comboCompany") as ASPxComboBox;

            if (comboCompany != null && comboCompany.Value != null)
            {
                int companyId = Convert.ToInt32(comboCompany.Value);
                e.NewValues["companyId"] = companyId;
            }
        }

        protected void GridBranches_CustomCallback(object sender, ASPxGridViewCustomCallbackEventArgs e)
        {
            try
            {
                SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ShabDB_connection"].ToString());
                SqlCommand cmd = new SqlCommand("InsertBranchProducts", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@BranchId", SqlDbType.NVarChar).Value = e.Parameters;
                con.Open();
                bool Result = Convert.ToBoolean(cmd.ExecuteScalar() != null ? cmd.ExecuteScalar() : 0);
                con.Close();
                GridBranches.JSProperties["cpResult"] = 1;
            }
            catch (Exception)
            {
                GridBranches.JSProperties["cpResult"] = 0;
            }
        }
        protected void Grid_Association_CellEditorInitialize(object sender, ASPxGridViewEditorEventArgs e)
        {
            if (e.Column.FieldName == "companyId")
            {
                var combo = (ASPxComboBox)e.Editor;
                combo.Callback += new CallbackEventHandlerBase(combo_Callback);

                var grid = e.Column.Grid;
                if (!combo.IsCallback)
                {
                    var countryId = -1;
                    if (!grid.IsNewRowEditing)
                        countryId = (int)grid.GetRowValues(e.VisibleIndex, "countryId");
                    FillCompaniesComboBox(combo, countryId);
                }
            }
            if (e.Column.FieldName == "cityId")
            {
                var combo = (ASPxComboBox)e.Editor;
                combo.Callback += new CallbackEventHandlerBase(combo_Callback);

                var grid = e.Column.Grid;
                if (!combo.IsCallback)
                {
                    var countryId = -1;
                    if (!grid.IsNewRowEditing)
                        countryId = (int)grid.GetRowValues(e.VisibleIndex, "countryId");
                    FillCitiesComboBox(combo, countryId);
                }
            }
        }

        private void combo_Callback(object sender, CallbackEventArgsBase e)
        {
            var combo = sender as ASPxComboBox;

            if (e.Parameter.StartsWith("cityChanged|"))
            {
                // city changed → reload company combo
                var cityIdStr = e.Parameter.Split('|')[1];
                if (Int32.TryParse(cityIdStr, out int cityId))
                {
                    FillCompaniesComboBox(combo, cityId);
                }
            }
            else
            {
                // This callback is for city combo itself (e.g., fill cities based on country or other logic)
                if (Int32.TryParse(e.Parameter, out int countryId))
                {
                    FillCitiesComboBox(combo, countryId);
                }
            }
        }

        protected void FillCompaniesComboBox(ASPxComboBox combo, int countryId)
        {
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
                if (privilegeCompanyID != 1000) {
                    combo.DataSourceID = "DB_L_Companies_selected";
                    DB_L_Companies_selected.SelectParameters["id"].DefaultValue = countryId.ToString();
                    DB_L_Companies_selected.SelectParameters["companyID"].DefaultValue = privilegeCompanyID.ToString();
                    combo.DataBindItems();
                }
                else
                {
                    combo.DataSourceID = "DB_L_Companies_selected";
                    DB_L_Companies_selected.SelectParameters["id"].DefaultValue = countryId.ToString();
                    combo.DataBindItems();
                }
                
            }
            else {
                combo.DataSourceID = "DB_L_Companies_selected";
                DB_L_Companies_selected.SelectParameters["id"].DefaultValue = countryId.ToString();
                combo.DataBindItems();
            }

           
            //combo.SelectedIndex = 0;
        }
        protected void FillCitiesComboBox(ASPxComboBox combo, int countryId)
        {
            combo.DataSourceID = "DB_L_Cities_selected";
            DB_L_Cities_selected.SelectParameters["id"].DefaultValue = countryId.ToString();
            combo.DataBindItems();
            //combo.SelectedIndex = 0;
        }


        protected void checkBrackCallback_Callback(object sender, CallbackEventArgsBase e)
        {
            DataView dv = new DataView();
            DataTable dt = new DataTable();
            DB_CheckMainBranch.SelectParameters["id"].DefaultValue = e.Parameter;
            dv = DB_CheckMainBranch.Select(DataSourceSelectArguments.Empty) as DataView;
            if (dv != null && dv.Count != 0)
                checkBrackCallback.JSProperties["cpResultCheck"] = 1;
            else
                checkBrackCallback.JSProperties["cpResultCheck"] = 0;
        }
    }
}