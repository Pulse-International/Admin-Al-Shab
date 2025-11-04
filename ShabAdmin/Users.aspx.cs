using DevExpress.Web;
using DevExpress.Web.Data;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Runtime.Remoting.Messaging;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using static System.Net.Mime.MediaTypeNames;

namespace ShabAdmin
{
    public partial class Users : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        protected void Grid_members_HtmlRowCreated(object sender, ASPxGridViewTableRowEventArgs e)
        {
            if (e.RowType == GridViewRowType.Data)
            {
                ASPxLabel GroupName = Grid_members.FindRowCellTemplateControl(e.VisibleIndex, null, "GroupName") as ASPxLabel;
                string id = Grid_members.GetRowValues(e.VisibleIndex, "id").ToString();
                GroupName.Text = string.Empty;

                DataView dv = new DataView();
                DataTable dt = new DataTable();
                DB_SelectedPagesList.SelectParameters["id"].DefaultValue = id;
                dv = DB_SelectedPagesList.Select(DataSourceSelectArguments.Empty) as DataView;
                if (dv != null && dv.Count != 0)
                {
                    dt = dv.ToTable();
                    foreach (DataRow dr in dt.Rows)
                    {
                        GroupName.Text = GroupName.Text + "<div style='border: 1px solid #cacaca; padding-top:0.01em;padding-left:0.3em;padding-right:0.3em;padding-bottom:0.01em; font-size:0.9em'>" + dr["pageName"].ToString() + "</div>";
                    }
                }
            }
        }
        protected void Page_Init(object sender, EventArgs e)
        {
            //Grid_members.CellEditorInitialize += (s, eArgs) =>
            //{
            //    if (eArgs.Column.FieldName == "privilegeCompanyID")
            //    {
            //        var combo = eArgs.Editor as ASPxComboBox;
            //        combo.Callback += combo_Callback;
            //    }
            //};
        }
        protected void Grid_members_HtmlDataCellPrepared(object sender, ASPxGridViewTableDataCellEventArgs e)
        {
            if (e.DataColumn.FieldName == "privilegeCountryID")
            {
                object idObj = e.CellValue;
                string countryName = Grid_members.GetRowValues(e.VisibleIndex, "countryName")?.ToString();

                if (idObj == null || idObj.ToString() == "1000" || string.IsNullOrEmpty(countryName))
                    e.Cell.Text = "لا يوجد";
                else
                    e.Cell.Text = countryName;
            }

            if (e.DataColumn.FieldName == "privilegeCompanyID")
            {
                object idObj = e.CellValue;
                string companyName = Grid_members.GetRowValues(e.VisibleIndex, "companyName")?.ToString();

                if (idObj == null || idObj.ToString() == "1000" || string.IsNullOrEmpty(companyName))
                    e.Cell.Text = "لا يوجد";
                else
                    e.Cell.Text = companyName;
            }

            if (e.DataColumn.FieldName == "password")
            {
                e.Cell.Text = "***********";
            }
        }
        protected void Grid_members_CellEditorInitialize(object sender, ASPxGridViewEditorEventArgs e)
        {
            if ((e.Column.FieldName == "password") && (!Grid_members.IsNewRowEditing))
            {
                ASPxTextBox Password = e.Editor as ASPxTextBox;
                Password.Password = false;
            }
            if (e.Column.FieldName == "privilegeCompanyID")
            {
                var combo = (ASPxComboBox)e.Editor;
                combo.Callback += combo_Callback;
                object rawCountry = Grid_members.GetRowValues(e.VisibleIndex, "privilegeCountryID");
                int countryID = rawCountry != null ? Convert.ToInt32(rawCountry) : 0;

                FillCitiesComboBox(combo, countryID);

                object rawCompany = Grid_members.GetRowValues(e.VisibleIndex, "privilegeCompanyID");
                if (rawCompany != null) combo.Value = rawCompany;
            }
        }

        protected void combo_Callback(object sender, CallbackEventArgsBase e)
        {
            int countryID = 0;
            if (!Int32.TryParse(e.Parameter, out countryID)) countryID = 0;
            FillCitiesComboBox((ASPxComboBox)sender, countryID);
        }

        protected void FillCitiesComboBox(ASPxComboBox combo, int countryID)
        {
            DB_companies.SelectParameters["countryID"].DefaultValue = countryID.ToString();
            combo.DataSourceID = "DB_companies";
            combo.DataBindItems();
        }

        protected void Grid_members_RowInserting(object sender, ASPxDataInsertingEventArgs e)
        {
            string password = e.NewValues["password"].ToString();
            e.NewValues["password"] = MainHelper.Encrypt_User(password);

            // Manually retrieve the company combo value
            ASPxCallbackPanel panel = Grid_members.FindEditRowCellTemplateControl(
                (GridViewDataColumn)Grid_members.Columns[6], "LoadCompanies") as ASPxCallbackPanel;

            if (panel != null)
            {
                ASPxComboBox comboCompany = panel.FindControl("comboCompany") as ASPxComboBox;

                if (comboCompany != null)
                {
                    e.NewValues["privilegeCompanyID"] = comboCompany.Value;
                }
            }
        }



        protected void Grid_members_RowInserted(object sender, ASPxDataInsertedEventArgs e)
        {
            ASPxListBox listBoxPages = Grid_members.FindEditRowCellTemplateControl(((GridViewDataColumn)Grid_members.Columns[4]), "listBoxPages") as ASPxListBox;
            int userId = newID;

            List<int> pagesList = new List<int>();
            foreach (ListEditItem li in listBoxPages.SelectedItems)
            {
                pagesList.Add(Convert.ToInt32(li.Value));
            }

            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ShabDB_connection"].ConnectionString))
            {
                conn.Open();
                foreach (int PageID in pagesList)
                {
                    using (SqlCommand insertCmd = new SqlCommand("INSERT INTO usersPrivileges (userId, pageId) VALUES (@userId, @pageId)", conn))
                    {
                        insertCmd.Parameters.AddWithValue("@userId", userId);
                        insertCmd.Parameters.AddWithValue("@pageId", PageID);
                        insertCmd.ExecuteNonQuery();
                    }
                }
                conn.Close();
            }
        }

        int newID;
        protected void DB_members_Inserted(object sender, SqlDataSourceStatusEventArgs e)
        {
            newID = Convert.ToInt32(e.Command.Parameters["@newID"].Value);
        }

        protected void Grid_members_RowUpdating(object sender, ASPxDataUpdatingEventArgs e)
        {
            if (e.NewValues["password"].ToString() != e.OldValues["password"].ToString())
            {
                string password = e.NewValues["password"].ToString();
                e.NewValues["password"] = MainHelper.Encrypt_User(password);
            }
            // Manually retrieve the company combo value
            // First, get the callback panel from the edit row
            ASPxCallbackPanel panel = Grid_members.FindEditRowCellTemplateControl(
                (GridViewDataColumn)Grid_members.Columns[6], "LoadCompanies") as ASPxCallbackPanel;

            if (panel != null)
            {
                // Now get the combo box inside the callback panel
                ASPxComboBox comboCompany = panel.FindControl("comboCompany") as ASPxComboBox;

                if (comboCompany != null)
                {
                    e.NewValues["privilegeCompanyID"] = comboCompany.Value;
                }
            }

        }

        protected void Grid_members_RowUpdated(object sender, ASPxDataUpdatedEventArgs e)
        {
            ASPxListBox listBoxPages = Grid_members.FindEditRowCellTemplateControl(((GridViewDataColumn)Grid_members.Columns[4]), "listBoxPages") as ASPxListBox;
            int userId = Convert.ToInt32(e.Keys["id"]);

            List<int> pagesList = new List<int>();
            foreach (ListEditItem li in listBoxPages.SelectedItems)
            {
                pagesList.Add(Convert.ToInt32(li.Value));
            }

            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ShabDB_connection"].ConnectionString))
            {
                conn.Open();
                using (SqlCommand deleteCmd = new SqlCommand("DELETE FROM usersPrivileges WHERE userId = @userId", conn))
                {
                    deleteCmd.Parameters.AddWithValue("@userId", userId);
                    deleteCmd.ExecuteNonQuery();
                }

                foreach (int PageID in pagesList)
                {
                    using (SqlCommand insertCmd = new SqlCommand("INSERT INTO usersPrivileges (userId, pageId) VALUES (@userId, @pageId)", conn))
                    {
                        insertCmd.Parameters.AddWithValue("@userId", userId);
                        insertCmd.Parameters.AddWithValue("@pageId", PageID);
                        insertCmd.ExecuteNonQuery();
                    }
                }
                conn.Close();
            }
        }

        protected void listBoxPages_Callback(object sender, CallbackEventArgsBase e)
        {
            List<string> selectedPages = new List<string>();

            DataView dv = new DataView();
            DataTable dt = new DataTable();
            DB_SelectedPagesList.SelectParameters["id"].DefaultValue = l_item_userId.Text;
            dv = DB_SelectedPagesList.Select(DataSourceSelectArguments.Empty) as DataView;
            if (dv != null && dv.Count != 0)
            {
                dt = dv.ToTable();
                foreach (DataRow dr in dt.Rows)
                {
                    selectedPages.Add(dr["id"].ToString());
                }
            }

            ASPxListBox listBox = sender as ASPxListBox;
            listBox.DataBind();

            foreach (string val in selectedPages)
            {
                ListEditItem item = listBox.Items.FindByValue(val);
                if (item != null)
                {
                    item.Selected = true;
                }
            }
        }

        protected void GridPages_RowUpdating(object sender, ASPxDataUpdatingEventArgs e)
        {
            if (e.NewValues["pageFileName"]?.ToString() != e.OldValues["pageFileName"]?.ToString())
            {
                e.Cancel = true;
                GridPages.JSProperties["cpPageExist"] = true;
                return;
            }
        }

        protected void GridPages_RowDeleting(object sender, ASPxDataDeletingEventArgs e)
        {
            int pageId = Convert.ToInt32(e.Keys["id"]);

            if (CheckIfPageInUse(pageId))
            {
                e.Cancel = true;
                GridPages.JSProperties["cpPageExist"] = true;
                return;
            }


        }

        private bool CheckIfPageInUse(int pageId)
        {

            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ShabDB_connection"].ConnectionString))
            {
                conn.Open();
                SqlCommand cmd = new SqlCommand("SELECT COUNT(*) FROM usersPrivileges WHERE pageId = @pageId", conn);
                cmd.Parameters.AddWithValue("@pageId", pageId);

                int count = Convert.ToInt32(cmd.ExecuteScalar());
                return count > 0;
            }
        }
    }
}