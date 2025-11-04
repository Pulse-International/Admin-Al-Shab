<%@ Page Title="Branches" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Users.aspx.cs" Inherits="ShabAdmin.Users" %>

<%@ Register Assembly="DevExpress.Web.v24.1, Version=24.1.6.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">


    <main>
        <script>
            var MyIndex;
            var MyIndexSettings;
            var isUpdating = 0;
            function OnRowClick(e) {
                MyIndex = e.visibleIndex;
                Grid_members.GetRowValues(MyIndex, 'id', OnGetRowValues);
            }
            function OnGetRowValues(Value) {
                l_item_userId.SetText(Value);
            }

            function OnRowClickSettings(e) {
                MyIndexSettings = e.visibleIndex;
            }

            function updateGrid() {
                isUpdating = 1;
                setTimeout(function () { Grid_members.StartEditRow(MyIndex); }, 100);
            }
            function OnCountryChanged(s, e) {
                var countryID = s.GetValue() || 0;
                var grid = ASPxClientControl.GetControlCollection()
                    .GetByName("Grid_members");
                var combo = grid.GetEditor("privilegeCompanyID");
                if (combo) combo.PerformCallback(countryID.toString());
            }


            function onDeleteClick(visibleIndex, gridNo) {
                MyIndex = visibleIndex;

                Pop_Del_Grids.Show();
            }

            function OnGridEndCallback(s, e) {
                if (s.cpPageExist) {
                    pageExist.Show();

                    delete s.cpPageExist;
                }
            }


        </script>

        <div class="w-100 text-center my-4">
            <h2 class="pageTitle d-inline-block" style="font-family: Cairo">إدارة المستخدمين</h2>
        </div>

        <div class="navbar-main navbar-expand-lg px-0 mx-4 border-radius-xl bg-white shadow mt-3 mb-1 px-3">

            <dx:ASPxGridView ID="Grid_members" runat="server" CssClass="myCenteredGrid" DataSourceID="DB_members" KeyFieldName="id" ClientInstanceName="Grid_members" Width="100%" AutoGenerateColumns="False" EnablePagingCallbackAnimation="True" Font-Names="cairo" Font-Size="1em" OnHtmlDataCellPrepared="Grid_members_HtmlDataCellPrepared" OnHtmlRowCreated="Grid_members_HtmlRowCreated" OnRowInserting="Grid_members_RowInserting" OnRowUpdating="Grid_members_RowUpdating" OnCellEditorInitialize="Grid_members_CellEditorInitialize" OnRowUpdated="Grid_members_RowUpdated" OnRowInserted="Grid_members_RowInserted">
                <ClientSideEvents ToolbarItemClick="function(s, e) { setTimeout(function () { aaa.SetSelectedIndex(0); }, 500); }" RowClick="function(s, e) {OnRowClick(e);}" EndCallback="function(s, e) { 
    setTimeout(function() {
        if (typeof listBoxPages !== 'undefined' && listBoxPages) {
            listBoxPages.PerformCallback(MyIndex);
            l_item_userId.SetText('');
            isUpdating = 0;
        }
    }, 100);
}" />
                <Settings ShowFooter="True" ShowFilterRow="True" />
                <SettingsAdaptivity AdaptivityMode="HideDataCells">
                </SettingsAdaptivity>
                <Settings ShowFilterRow="True" ShowFilterRowMenu="False" ShowHeaderFilterButton="False" AutoFilterCondition="Contains" />

                <SettingsCommandButton>
                    <NewButton Text="جديد">
                    </NewButton>
                    <UpdateButton Text=" حفظ ">
                        <Image Url="/assets/img/save.png" SpriteProperties-Left="50">
                            <SpriteProperties Left="50px"></SpriteProperties>
                        </Image>
                    </UpdateButton>
                    <CancelButton Text=" إلغاء ">
                        <Image Url="/assets/img/cancel.png">
                        </Image>
                    </CancelButton>
                </SettingsCommandButton>

                <SettingsPopup>
                    <FilterControl AutoUpdatePosition="False"></FilterControl>
                </SettingsPopup>

                <SettingsSearchPanel CustomEditorID="tbToolbarSearch" />

                <SettingsExport EnableClientSideExportAPI="true" ExcelExportMode="WYSIWYG" PaperKind="A4" RightToLeft="True" />
                <SettingsLoadingPanel Text="الرجاء الانتظار &amp;hellip;" Mode="ShowAsPopup" />
                <SettingsText SearchPanelEditorNullText="ابحث في كامل الجدول..." EmptyDataRow="لا يوجد" />
                <Columns>
                    <dx:GridViewDataTextColumn Caption="الرقم" FieldName="id" ReadOnly="True" VisibleIndex="0" Width="5%">
                        <EditFormSettings Visible="False" />
                        <CellStyle VerticalAlign="Middle"></CellStyle>
                    </dx:GridViewDataTextColumn>
                    <dx:GridViewDataTextColumn Caption="الاسم" FieldName="userFullName" VisibleIndex="1">
                        <CellStyle VerticalAlign="Middle"></CellStyle>
                        <PropertiesTextEdit>
                            <ValidationSettings RequiredField-IsRequired="true" SetFocusOnError="True" ErrorText="حقل اجباري" Display="Dynamic">
                                <RequiredField IsRequired="True"></RequiredField>
                            </ValidationSettings>
                        </PropertiesTextEdit>
                    </dx:GridViewDataTextColumn>
                    <dx:GridViewDataTextColumn Caption="اسم المستخدم" FieldName="username" VisibleIndex="2" Width="13%">
                        <CellStyle VerticalAlign="Middle"></CellStyle>
                        <PropertiesTextEdit>
                            <ValidationSettings RequiredField-IsRequired="true" SetFocusOnError="True" ErrorText="حقل اجباري" Display="Dynamic">
                                <RequiredField IsRequired="True"></RequiredField>
                            </ValidationSettings>
                        </PropertiesTextEdit>
                    </dx:GridViewDataTextColumn>

                    <dx:GridViewDataTextColumn Caption="كلمة السر" FieldName="password" VisibleIndex="3" Width="7%">
                        <PropertiesTextEdit Password="True" HelpText="لتغيير كلمة السر الرجاء أدخل قيمة جديدة، أو اترك الحقل لبقاء نفس كلمة السر القديمة" Native="True">
                            <NullTextStyle ForeColor="Red">
                            </NullTextStyle>
                            <Style ForeColor="Red">
                                </Style>
                            <ValidationSettings RequiredField-IsRequired="true" SetFocusOnError="True" ErrorText="حقل اجباري" Display="Dynamic">
                                <RequiredField IsRequired="True"></RequiredField>
                            </ValidationSettings>
                        </PropertiesTextEdit>
                        <CellStyle VerticalAlign="Middle"></CellStyle>
                    </dx:GridViewDataTextColumn>

                    <dx:GridViewDataTextColumn Caption="صلاحيات الصفحات" VisibleIndex="4">
                        <DataItemTemplate>
                            <dx:ASPxLabel ID="GroupName" runat="server" Font-Names="cairo" Font-Size="Smaller" Text="" EncodeHtml="false"></dx:ASPxLabel>
                        </DataItemTemplate>
                        <EditFormSettings RowSpan="6" VisibleIndex="1"></EditFormSettings>
                        <EditItemTemplate>
                            <dx:ASPxListBox
                                ID="listBoxPages"
                                runat="server"
                                ClientInstanceName="listBoxPages"
                                EnableCallbackMode="true"
                                TextField="pageName"
                                ValueField="id"
                                Width="100%"
                                ValueType="System.String"
                                SelectionMode="CheckColumn"
                                Font-Names="Cairo"
                                EnableMultiSelection="True"
                                Height="300px"
                                EnableSelectAll="True"
                                DataSourceID="DB_PagesList"
                                OnCallback="listBoxPages_Callback">
                            </dx:ASPxListBox>

                        </EditItemTemplate>
                        <CellStyle VerticalAlign="Middle">
                        </CellStyle>
                    </dx:GridViewDataTextColumn>

                    <dx:GridViewDataComboBoxColumn Caption="صلاحية البلد"
                        FieldName="privilegeCountryID"
                        VisibleIndex="5" Width="7%">
                        <PropertiesComboBox ClientInstanceName="comboCountry"
                            DataSourceID="DB_countries"
                            TextField="countryName"
                            ValueField="id"
                            ValueType="System.Int32">

                            <ClientSideEvents
                                SelectedIndexChanged="OnCountryChanged" />
                            <ItemStyle Font-Size="1.5em" />
                        </PropertiesComboBox>
                    </dx:GridViewDataComboBoxColumn>

                    <dx:GridViewDataComboBoxColumn Caption="صلاحية الشركة"
                        FieldName="privilegeCompanyID"
                        VisibleIndex="6">
                        <PropertiesComboBox ClientInstanceName="comboCompany"
                            EnableCallbackMode="true"
                            TextField="companyName"
                            ValueField="id"
                            ValueType="System.Int32">


                            <ItemStyle Font-Size="1.5em" />
                        </PropertiesComboBox>
                        <CellStyle VerticalAlign="Middle" />
                    </dx:GridViewDataComboBoxColumn>


                    <dx:GridViewDataCheckColumn Caption="فعال" FieldName="isActive" VisibleIndex="7" Width="50px">
                        <PropertiesCheckEdit DisplayFormatString="g"></PropertiesCheckEdit>
                        <CellStyle VerticalAlign="Middle"></CellStyle>
                    </dx:GridViewDataCheckColumn>
                    <dx:GridViewDataDateColumn Caption="التاريخ" FieldName="userDate" VisibleIndex="8" Width="7%">
                        <EditFormSettings Visible="False" />
                        <PropertiesDateEdit DisplayFormatString="dd/MM/yyyy"></PropertiesDateEdit>
                        <CellStyle VerticalAlign="Middle"></CellStyle>
                    </dx:GridViewDataDateColumn>

                    <dx:GridViewDataTextColumn Caption="" ShowInCustomizationForm="True" VisibleIndex="9">
                        <EditFormSettings Visible="False" />
                        <DataItemTemplate>
                            <img src="/assets/img/update.png" width="32" height="32" title="تعديل" style="cursor: pointer" onclick="updateGrid();" />
                        </DataItemTemplate>
                    </dx:GridViewDataTextColumn>

                </Columns>
                <Toolbars>
                    <dx:GridViewToolbar ItemAlign="left">
                        <SettingsAdaptivity Enabled="true" EnableCollapseRootItemsToIcons="true" />
                        <Items>
                            <dx:GridViewToolbarItem Command="New" Text="جديد" />
                            <dx:GridViewToolbarItem Command="Refresh" BeginGroup="true" AdaptivePriority="1" Text="تحديث الجدول" />
                            <dx:GridViewToolbarItem Command="ExportToXlsx" BeginGroup="true" />
                            <dx:GridViewToolbarItem Command="ExportToPdf" />

                            <dx:GridViewToolbarItem Alignment="Right" Name="toolbarItemSearch" BeginGroup="true" AdaptivePriority="2">
                                <Template>
                                    <dx:ASPxButtonEdit ID="tbToolbarSearch" runat="server" NullText="بحث..." Width="140" Font-Names="cairo" />
                                </Template>
                            </dx:GridViewToolbarItem>

                        </Items>
                    </dx:GridViewToolbar>
                </Toolbars>
                <TotalSummary>
                    <dx:ASPxSummaryItem FieldName="id" SummaryType="Count" DisplayFormat="العدد = {0}" />
                </TotalSummary>
                <Styles>
                    <AlternatingRow BackColor="#F0F0F0">
                    </AlternatingRow>
                    <Footer Font-Names="cairo">
                    </Footer>
                </Styles>
            </dx:ASPxGridView>



            <asp:SqlDataSource ID="DB_members" runat="server" ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>"
                SelectCommand=" SELECT 
                        users.id, users.username, users.password, users.userFullName, 
                        users.isActive, users.userDate, users.privilegeCompanyID, users.privilegeCountryID,
                        companies.companyName, countries.countryName
                    FROM users
                    LEFT JOIN companies ON users.privilegeCompanyID = companies.id
                    LEFT JOIN countries ON users.privilegeCountryID = countries.id
                    --WHERE users.id != 9
                    ORDER BY id asc"
                UpdateCommand="UPDATE [users] SET [userFullName] = @userFullName,privilegeCompanyID=@privilegeCompanyID,privilegeCountryID=@privilegeCountryID, [username] = @username, [password] = @password, [isActive] = @isActive WHERE [id] = @id"
                InsertCommand="INSERT into [users] (username,password,userFullName,isActive,privilegeCompanyID,privilegeCountryID,userDate) values (@username,@password,@userFullName,@isActive, @privilegeCompanyID, @privilegeCountryID, getdate()); SELECT @newID = SCOPE_IDENTITY()" OnInserted="DB_members_Inserted">
                <UpdateParameters>
                    <asp:Parameter Name="userFullName" Type="String" />
                    <asp:Parameter Name="username" Type="String" />
                    <asp:Parameter Name="password" Type="String" />
                    <asp:Parameter Name="isActive" Type="Int32" />
                    <asp:Parameter Name="privilegeCompanyID" Type="Int32" DefaultValue="1000" />
                    <asp:Parameter Name="privilegeCountryID" Type="Int32" DefaultValue="1000" />
                    <asp:Parameter Name="id" Type="Int32" />
                </UpdateParameters>
                <InsertParameters>
                    <asp:Parameter Name="userFullName" Type="String" />
                    <asp:Parameter Name="username" Type="String" />
                    <asp:Parameter Name="password" Type="String" />
                    <asp:Parameter Name="isActive" Type="Int32" />
                    <asp:Parameter Name="privilegeCompanyID" Type="Int32" DefaultValue="1000" />
                    <asp:Parameter Name="privilegeCountryID" Type="Int32" DefaultValue="1000" />
                    <asp:Parameter Direction="Output" Name="newID" Type="Int32" />
                </InsertParameters>
            </asp:SqlDataSource>


            <asp:SqlDataSource ID="DB_countries" runat="server"
                ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>"
                SelectCommand="SELECT id, countryName FROM countries ORDER BY ID ASC" />


            <asp:SqlDataSource ID="DB_companies" runat="server"
                ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>"
                SelectCommand="
      SELECT id, companyName
      FROM companies
      WHERE countryID = @countryID or countryID=1000
      ORDER BY ID ASC">
                <SelectParameters>
                    <asp:Parameter Name="countryID" Type="Int32" DefaultValue="1000" />
                </SelectParameters>
            </asp:SqlDataSource>

            <asp:SqlDataSource ID="DB_PagesList" runat="server" ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>" SelectCommand="select id, pageName from usersPages"></asp:SqlDataSource>

            <asp:SqlDataSource ID="DB_SelectedPagesList" runat="server" ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>" SelectCommand="select p.id, p.pageName from users u, usersPrivileges v, usersPages p where u.id = v.userId and v.pageId = p.id and u.id=@id">
                <SelectParameters>
                    <asp:Parameter Name="id" />
                </SelectParameters>
            </asp:SqlDataSource>

            <dx:ASPxTextBox ID="l_item_userId" runat="server" BackColor="Transparent" ClientInstanceName="l_item_userId" Font-Size="0pt" ForeColor="Transparent" Text="" Width="0px" Theme="Default">
                <Border BorderStyle="None" BorderWidth="0px" />
            </dx:ASPxTextBox>


        </div>







        <br />
        <br />
        <div class="w-100 text-center my-4">
            <h2 class="pageTitle d-inline-block" style="font-family: Cairo">إدارة مزايا التطبيق</h2>
        </div>

        <div class="" style="margin: 0 auto; width: 70%; border: 1px solid rgba(198, 26, 84, 0.5); box-shadow: 0 0 0 0.2rem rgba(198, 26, 84, 0.5);">
            <dx:ASPxGridView ID="Grid_UsersSettings" runat="server" DataSourceID="db_Grid_UsersSettings" KeyFieldName="id"
                ClientInstanceName="Grid_UsersSettings" Width="100%" AutoGenerateColumns="False"
                EnablePagingCallbackAnimation="True" Font-Names="cairo" Font-Size="1em" RightToLeft="True">
                <ClientSideEvents RowClick="function(s,e){ OnRowClickSettings(e); }" />
                <SettingsAdaptivity AdaptivityMode="HideDataCells"></SettingsAdaptivity>
                <Settings ShowFooter="True" />
                <SettingsCommandButton>
                    <NewButton Text="جديد"></NewButton>
                    <UpdateButton Text=" حفظ ">
                        <Image Url="~/assets/img/save.png" SpriteProperties-Left="50">
                            <SpriteProperties Left="50px"></SpriteProperties>
                        </Image>
                    </UpdateButton>
                    <CancelButton Text=" الغاء ">
                        <Image Url="~/assets/img/cancel.png"></Image>
                    </CancelButton>
                </SettingsCommandButton>
                <SettingsPopup>
                    <FilterControl AutoUpdatePosition="False"></FilterControl>
                </SettingsPopup>
                <SettingsSearchPanel CustomEditorID="tbToolbarSearch2" />
                <SettingsExport EnableClientSideExportAPI="true" ExcelExportMode="WYSIWYG" PaperKind="A4" RightToLeft="True" />
                <SettingsLoadingPanel Text="Please Wait &amp;hellip;" Mode="ShowAsPopup" />
                <SettingsText SearchPanelEditorNullText="ابحث في الجدول..." EmptyDataRow="لا يوجد" />

                <Columns>

                    <dx:GridViewDataColumn Caption="الرقم" FieldName="id">
                        <EditFormSettings Visible="False" />
                        <CellStyle VerticalAlign="Middle" HorizontalAlign="Center"></CellStyle>
                    </dx:GridViewDataColumn>

                    <dx:GridViewDataColumn Caption="الوصف" FieldName="description">
                        <EditFormSettings />
                        <CellStyle VerticalAlign="Middle" HorizontalAlign="Center"></CellStyle>
                    </dx:GridViewDataColumn>

                    <dx:GridViewDataColumn Caption="الرمز" FieldName="code">
                        <EditFormSettings />
                        <CellStyle VerticalAlign="Middle" HorizontalAlign="Center"></CellStyle>
                    </dx:GridViewDataColumn>

                    <dx:GridViewDataSpinEditColumn Caption="العدد" FieldName="count">
                        <PropertiesSpinEdit DisplayFormatString="g" MaxLength="4" MaxValue="9999" NumberType="Integer" DecimalPlaces="0">
                            <ValidationSettings Display="Dynamic" ErrorText="required." SetFocusOnError="True">
                                <RequiredField IsRequired="True" />
                            </ValidationSettings>
                        </PropertiesSpinEdit>
                        <CellStyle HorizontalAlign="Center" VerticalAlign="Middle">
                        </CellStyle>
                    </dx:GridViewDataSpinEditColumn>

                    <dx:GridViewDataCheckColumn Caption="فعال" FieldName="isActive" ShowInCustomizationForm="True">
                        <CellStyle HorizontalAlign="Center" VerticalAlign="Middle">
                        </CellStyle>
                    </dx:GridViewDataCheckColumn>

                    <dx:GridViewDataDateColumn Caption="التاريخ" FieldName="userDate" Width="7%">
                        <EditFormSettings Visible="False" />
                        <PropertiesDateEdit DisplayFormatString="dd/MM/yyyy"></PropertiesDateEdit>
                        <CellStyle VerticalAlign="Middle"></CellStyle>
                    </dx:GridViewDataDateColumn>

                    <dx:GridViewDataTextColumn Caption="" Width="100px">
                        <DataItemTemplate>
                            <dataitemtemplate>
                                <img src="/assets/img/update.png" width="32" height="32" title="تعديل" style="cursor: pointer" onclick="setTimeout(function(){Grid_UsersSettings.StartEditRow(MyIndexSettings);},100);" />
                                <img src="/assets/img/delete.png" width="32" height="32" title="حذف" style="cursor: pointer" onclick="setTimeout(function(){Grid_UsersSettings.DeleteRow(MyIndexSettings);},100);" />
                            </dataitemtemplate>
                        </DataItemTemplate>
                        <EditFormSettings Visible="False" />
                    </dx:GridViewDataTextColumn>


                </Columns>

                <Toolbars>
                    <dx:GridViewToolbar ItemAlign="left">
                        <SettingsAdaptivity Enabled="true" EnableCollapseRootItemsToIcons="true" />
                        <Items>
                            <dx:GridViewToolbarItem Command="New" Text="جديد" />
                            <dx:GridViewToolbarItem Command="Refresh" BeginGroup="true" AdaptivePriority="1" Text="تحديث الجدول" />
                            <dx:GridViewToolbarItem Command="ExportToXlsx" BeginGroup="true" />
                            <dx:GridViewToolbarItem Command="ExportToPdf" />
                            <dx:GridViewToolbarItem Alignment="Right" Name="toolbarItemSearch" BeginGroup="true" AdaptivePriority="2">
                                <Template>
                                    <dx:ASPxButtonEdit ID="tbToolbarSearch2" runat="server" NullText="البحث..." Width="140" Font-Names="cairo" />
                                </Template>
                            </dx:GridViewToolbarItem>
                        </Items>
                    </dx:GridViewToolbar>
                </Toolbars>

                <TotalSummary>
                    <dx:ASPxSummaryItem FieldName="id" SummaryType="Count" DisplayFormat="العدد = {0}" />
                </TotalSummary>

                <Styles>
                    <AlternatingRow BackColor="#F0F0F0"></AlternatingRow>
                    <Footer Font-Names="cairo"></Footer>
                </Styles>
                <Paddings Padding="2em" />
            </dx:ASPxGridView>

            <asp:SqlDataSource
                ID="db_Grid_UsersSettings"
                runat="server"
                ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>"
                CancelSelectOnNullParameter="false"
                SelectCommand="
                                     SELECT id, description, isActive, count, code, userDate
                                     FROM usersAppSettings"
                InsertCommand="
                                     INSERT INTO usersAppSettings (description, isActive, count, code, userdate)
                                     VALUES (@description, @isActive, @count, @code, getdate())"
                UpdateCommand="
                                     UPDATE usersAppSettings
                                     SET description = @description,
                                     isActive = @isActive,
                                     count = @count,
                                     code = @code
                                     WHERE id = @id"
                DeleteCommand="
                                     DELETE FROM usersAppSettings
                                     WHERE id = @id">

                <InsertParameters>
                    <asp:Parameter Name="description" Type="String" />
                    <asp:Parameter Name="isActive" Type="String" />
                    <asp:Parameter Name="count" Type="String" />
                    <asp:Parameter Name="code" Type="String" />
                </InsertParameters>

                <UpdateParameters>
                    <asp:Parameter Name="description" Type="String" />
                    <asp:Parameter Name="isActive" Type="String" />
                    <asp:Parameter Name="count" Type="String" />
                    <asp:Parameter Name="code" Type="String" />
                    <asp:Parameter Name="id" Type="Int32" />
                </UpdateParameters>

                <DeleteParameters>
                    <asp:Parameter Name="id" Type="Int32" />
                </DeleteParameters>
            </asp:SqlDataSource>
        </div>


        <br />
        <br />
        <div class="w-100 text-center my-4">
            <h2 class="pageTitle d-inline-block" style="font-family: Cairo">إدارة الصفحات - هذا الجدول خاص بالمبرمجين</h2>
        </div>

        <div class="navbar-main navbar-expand-lg px-0 mx-4 border-radius-xl bg-white shadow mt-3 mb-1 px-3">


            <dx:ASPxGridView ID="GridPages" runat="server" CssClass="myCenteredGrid" DataSourceID="db_userPages" KeyFieldName="id" ClientInstanceName="GridPages" Width="100%" AutoGenerateColumns="False" EnablePagingCallbackAnimation="True" Font-Names="cairo" Font-Size="1em" OnRowDeleting="GridPages_RowDeleting" OnRowUpdating="GridPages_RowUpdating">
                <ClientSideEvents RowClick="function(s, e) {OnRowClick(e);}" />
                <Settings ShowFooter="True" ShowFilterRow="True" />
                <SettingsAdaptivity AdaptivityMode="HideDataCells">
                </SettingsAdaptivity>
                <Settings ShowFilterRow="True" ShowFilterRowMenu="False" ShowHeaderFilterButton="False" AutoFilterCondition="Contains" />

                <ClientSideEvents EndCallback="OnGridEndCallback" />
                <SettingsCommandButton>
                    <NewButton Text="جديد">
                    </NewButton>
                    <UpdateButton Text=" حفظ ">
                        <Image Url="/assets/img/save.png" SpriteProperties-Left="50">
                            <SpriteProperties Left="50px"></SpriteProperties>
                        </Image>
                    </UpdateButton>
                    <CancelButton Text=" إلغاء ">
                        <Image Url="/assets/img/cancel.png">
                        </Image>
                    </CancelButton>
                </SettingsCommandButton>

                <SettingsPopup>
                    <FilterControl AutoUpdatePosition="False"></FilterControl>
                </SettingsPopup>

                <SettingsSearchPanel CustomEditorID="tbToolbarSearch3" />

                <SettingsExport EnableClientSideExportAPI="true" ExcelExportMode="WYSIWYG" PaperKind="A4" RightToLeft="True" />
                <SettingsLoadingPanel Text="الرجاء الانتظار &amp;hellip;" Mode="ShowAsPopup" />
                <SettingsText SearchPanelEditorNullText="ابحث في كامل الجدول..." EmptyDataRow="لا يوجد" />
                <Columns>
                    <dx:GridViewDataTextColumn FieldName="id" ReadOnly="True" VisibleIndex="0" Width="5%">
                        <EditFormSettings Visible="False" />
                        <CellStyle VerticalAlign="Middle"></CellStyle>
                    </dx:GridViewDataTextColumn>

                    <dx:GridViewDataTextColumn Caption="اسم الشاشة" FieldName="pageName" VisibleIndex="1">
                        <CellStyle VerticalAlign="Middle"></CellStyle>
                        <PropertiesTextEdit>
                            <ValidationSettings RequiredField-IsRequired="true" SetFocusOnError="True" ErrorText="حقل اجباري" Display="Dynamic">
                                <RequiredField IsRequired="True"></RequiredField>
                            </ValidationSettings>
                        </PropertiesTextEdit>
                    </dx:GridViewDataTextColumn>

                    <dx:GridViewDataTextColumn Caption="اسم الملف" FieldName="pageFileName" VisibleIndex="2">
                        <CellStyle VerticalAlign="Middle"></CellStyle>
                        <PropertiesTextEdit>
                            <ValidationSettings RequiredField-IsRequired="true" SetFocusOnError="True" ErrorText="حقل اجباري" Display="Dynamic">
                                <RequiredField IsRequired="True"></RequiredField>
                            </ValidationSettings>
                        </PropertiesTextEdit>
                    </dx:GridViewDataTextColumn>



                    <dx:GridViewDataTextColumn Caption="" ShowInCustomizationForm="True" VisibleIndex="9">
                        <EditFormSettings Visible="False" />
                        <DataItemTemplate>
                            <img src="/assets/img/update.png" width="32" height="32" title="تعديل" style="cursor: pointer" onclick="setTimeout(function(){GridPages.StartEditRow(MyIndex);},100);" />
                            <img src="/assets/img/delete.png" width="32" height="32" title="حذف" style="cursor: pointer" onclick="onDeleteClick(<%# Container.VisibleIndex %>);" />
                        </DataItemTemplate>
                    </dx:GridViewDataTextColumn>

                </Columns>
                <Toolbars>
                    <dx:GridViewToolbar ItemAlign="left">
                        <SettingsAdaptivity Enabled="true" EnableCollapseRootItemsToIcons="true" />
                        <Items>
                            <dx:GridViewToolbarItem Command="New" Text="جديد" />
                            <dx:GridViewToolbarItem Command="Refresh" BeginGroup="true" AdaptivePriority="1" Text="تحديث الجدول" />
                            <dx:GridViewToolbarItem Command="ExportToXlsx" BeginGroup="true" />
                            <dx:GridViewToolbarItem Command="ExportToPdf" />

                            <dx:GridViewToolbarItem Alignment="Right" Name="toolbarItemSearch" BeginGroup="true" AdaptivePriority="2">
                                <Template>
                                    <dx:ASPxButtonEdit ID="tbToolbarSearch3" runat="server" NullText="بحث..." Width="140" Font-Names="cairo" />
                                </Template>
                            </dx:GridViewToolbarItem>

                        </Items>
                    </dx:GridViewToolbar>
                </Toolbars>
                <TotalSummary>
                    <dx:ASPxSummaryItem FieldName="id" SummaryType="Count" DisplayFormat="العدد = {0}" />
                </TotalSummary>
                <Styles>
                    <AlternatingRow BackColor="#F0F0F0">
                    </AlternatingRow>
                    <Footer Font-Names="cairo">
                    </Footer>
                </Styles>
            </dx:ASPxGridView>

            <asp:SqlDataSource ID="db_userPages" runat="server" ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>"
                SelectCommand="SELECT id ,pageName,pageFileName FROM usersPages"
                UpdateCommand="UPDATE [usersPages] SET [pageName] = @pageName, [pageFileName] = @pageFileName WHERE [id] = @id"
                InsertCommand="INSERT into [usersPages] (pageName,pageFileName,userDate) values (@pageName,@pageFileName,getdate());"
                DeleteCommand="Delete from usersPages where id=@id">
                <UpdateParameters>
                    <asp:Parameter Name="pageName" Type="String" />
                    <asp:Parameter Name="pageFileName" Type="String" />
                    <asp:Parameter Name="id" Type="Int32" />
                </UpdateParameters>
                <InsertParameters>
                    <asp:Parameter Name="pageName" Type="String" />
                    <asp:Parameter Name="pageFileName" Type="String" />
                </InsertParameters>
                <DeleteParameters>
                    <asp:Parameter Name="id" />
                </DeleteParameters>
            </asp:SqlDataSource>

            <dx:ASPxPopupControl ID="pageExist" runat="server" Font-Names="cairo"
                ClientInstanceName="pageExist"
                ShowCloseButton="true"
                PopupHorizontalAlign="WindowCenter"
                PopupVerticalAlign="WindowCenter"
                HeaderText="تنبيه"
                Width="400px">
                <ContentCollection>
                    <dx:PopupControlContentControl>
                        <div style="font-family: Cairo; font-size: 1.2em; direction: rtl; padding: 1em; line-height: 1.7;">
                            <img src="assets/img/error-icon.png"
                                alt="Warning"
                                style="width: 150px; height: 150px; display: block; margin: 0 auto 1rem auto;" />

                            <div style="text-align: right;">
                                <b>تنبيه:</b><br />
                                <br />
                                لا يمكن تعديل أو حذف هذه الصفحة لأنها مستخدمة من قبل بعض المستخدمين ضمن الصلاحيات الخاصة بهم.<br />
                                <br />
                                الرجاء إزالة ارتباط الصفحة من صلاحيات المستخدمين أولاً قبل المتابعة.
                            </div>
                        </div>
                    </dx:PopupControlContentControl>
                </ContentCollection>
            </dx:ASPxPopupControl>


            <dx:ASPxPopupControl runat="server" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter"
                AutoUpdatePosition="True" Modal="True" ClientInstanceName="Pop_Del_Grids" CloseAnimationType="Slide"
                FooterText="" HeaderText="حذف صفحة" Font-Names="Cairo" Width="350px" Height="150px" ID="Pop_Del_Compnies">
                <ContentCollection>
                    <dx:PopupControlContentControl runat="server">
                        <div style="padding: 10px; font-family: 'Cairo', sans-serif; height: 230px; z-index: 3; text-align: center">
                            <div class="mb-3" style="width: 100%;">
                                <div style="text-align: center">
                                    <img src="assets/img/danger.png" height="60px" alt="danger" />
                                </div>
                                <dx:ASPxLabel runat="server" Text="هل أنت متأكد من حذف الصفحة؟" ClientInstanceName="labelPages"
                                    Font-Names="Cairo" Font-Size="Medium" ForeColor="#333333" ID="labelPages">
                                </dx:ASPxLabel>
                            </div>
                            <div style="width: 100%; margin-top: 20px; text-align: center;">
                                <dx:ASPxButton ID="Btn_Del_Pages" runat="server" AutoPostBack="False" Text="حــــــــذف"
                                    UseSubmitBehavior="False" Font-Names="Cairo" HorizontalAlign="Center" VerticalAlign="Middle">
                                    <ClientSideEvents Click="function(s, e) { 
                                             GridPages.DeleteRow(MyIndex); 
                                             setTimeout(function() { GridPages.Refresh(); }, 200);
                                             Pop_Del_Grids.Hide();
                                         }" />
                                </dx:ASPxButton>

                                <dx:ASPxButton ID="Btn_Close_Compnies" runat="server" AutoPostBack="False" Text="إغـــــــــــلاق"
                                    UseSubmitBehavior="False" Font-Names="Cairo" HorizontalAlign="Center" VerticalAlign="Middle"
                                    Style="margin-right: 20px;">
                                    <ClientSideEvents Click="function(s, e) {Pop_Del_Grids.Hide();}" />
                                </dx:ASPxButton>
                            </div>
                        </div>
                    </dx:PopupControlContentControl>
                </ContentCollection>
            </dx:ASPxPopupControl>
        </div>

    </main>



</asp:Content>
