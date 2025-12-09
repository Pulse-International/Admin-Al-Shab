<%@ Page Title="Points" Language="C#" MasterPageFile="~/mSite.Master" AutoEventWireup="true" CodeBehind="mNotifications.aspx.cs" Inherits="ShabAdmin.mNotifications" %>

<%@ Register Assembly="DevExpress.Web.v24.1, Version=24.1.6.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    
        <main>
            <style>
                .hintClass {
                    background-color: #f7f7f7;
                    color: #000000;
                    font-family: cairo;
                    border: 3px solid #c6bbff;
                    border-radius: 1em;
                }

                .divSTARProviders {
                    text-align: center;
                    margin-left: auto;
                    margin-right: auto;
                }

                .dxtcLite_Material.dxtc-top > .dxtc-stripContainer {
                    display: inline-block;
                }

                .status-label {
                    font-family: 'Cairo', sans-serif;
                    font-size: 1em;
                    padding: 6px 14px;
                    border-radius: 6px;
                    display: inline-block;
                    text-align: center;
                }

                .approve-btn {
                    background-color: #2196F3;
                    color: white;
                    border: none;
                    cursor: pointer;
                }

                    .approve-btn:hover {
                        background-color: #1976D2;
                    }

                .approved-text {
                    background-color: #e0e0e0;
                    color: #555;
                    cursor: default;
                }
            </style>
            <script>
                var MyId;
                var MyIndex;

                function OnRowClick(s, e) {
                    MyIndex = e.visibleIndex;
                    GridNotifications.GetRowValues(e.visibleIndex, 'id;imagePath', OnGetRowValues);
                }

                function OnGetRowValues(Value) {
                    MyId = Value[0];
                    l_item_file.SetText(Value[1]);
                    l_item_file_old.SetText(Value[1]);
                }

                function onFileUploadStart(s, e) {
                    l_item_file_check.SetText('0');
                }

                function onFileUploadComplete(s, e) {
                    var fileData = e.callbackData.split('|');
                    var fileName = fileData[0];
                    if (document.getElementById("DocsFile-" + MyId) != null) {
                        document.getElementById("DocsFile-" + MyId).src = fileName;
                        document.getElementById("DocsFileLarge-" + MyId).src = fileName;
                    }
                    else {
                        document.getElementById("DocsFileLarge-").src = fileName;
                    }
                    l_item_file.SetText(fileName);
                    l_item_file_check.SetText('1');
                    MyId = 0;
                }

                function OnGridBeginCallback(s, e) {
                    if (e.command == 'STARTEDIT') {
                        l_item_file_check.SetText('0');
                    }
                    if (e.command == 'ADDNEWROW') {
                        MyId = 0;
                        l_item_file.SetText('');
                        l_item_file_old.SetText('');
                    }
                    if (e.command == 'UPDATEEDIT') {
                        //Your code here when the Update button is clicked  
                    }
                    if (e.command == 'DELETEROW') {
                        //Your code here when the Delete button is clicked  
                    }
                    //and so on...  
                }



            </script>

            <div class="w-100 text-center my-4">
                <h2 class="pageTitle d-inline-block" style="font-family: Cairo">الإشـــعارات</h2>
            </div>

            <dx:ASPxPageControl ID="pageTab" runat="server" CssClass="divSTARProviders" ActiveTabIndex="0" ClientInstanceName="pageTab" Theme="Material" Width="100%" EnableCallbackAnimation="True">
                <TabPages>
                    <dx:TabPage Text="المستخدمين" TabStyle-Font-Bold="true" TabStyle-Font-Names="cairo" TabStyle-Font-Size="X-Large">
                        <TabStyle Font-Bold="True" Font-Names="cairo" Font-Size="X-Large"></TabStyle>
                        <ContentCollection>
                            <dx:ContentControl>
                                <div class="navbar-main navbar-expand-lg px-0 mx-4 border-radius-xl bg-white shadow mt-3 mb-1">

                                    <div style="margin: 0 auto; text-align: center; width: 70%; padding: 1em; overflow: auto;">

                                        <div style="float: left; width: 49%; padding: 1em">
                                            <dx:ASPxButton ID="sendNotifications" ClientInstanceName="sendNotifications" Width="100%" CssClass="top" Height="74px" runat="server" Text="إرســــــال" AutoPostBack="False" CausesValidation="False" UseSubmitBehavior="False" Font-Bold="True" Font-Size="XX-Large" Font-Names="cairo">
                                                <ClientSideEvents Click="function(s, e){ 
                                                    if (ASPxClientEdit.ValidateGroup('notificationGroup')) {     
                                                        s.SetText('الرجاء الانتظاء...');
                                                        setTimeout(function () { s.SetEnabled(false); }, 1);
                                                        GridUsersApp.PerformCallback(); 
                                                    }
                                                    
                                                }" />
                                                <Border BorderColor="Silver" BorderStyle="Solid" BorderWidth="2px" />
                                            </dx:ASPxButton>
                                        </div>
                                        <div style="float: right; width: 49%; padding: 1em">
                                            <dx:ASPxComboBox ID="notificationList" runat="server" Font-Names="cairo" Width="100%" TextField="type" ValueField="id" EncodeHtml="false" Font-Bold="True" Font-Size="XX-Large" ClientInstanceName="notificationList" DataSourceID="DB_L_NotificationList" NullText="نوع الإشعار" HorizontalAlign="Center" DropDownRows="4" OnCallback="notificationList_Callback">
                                                <ClientSideEvents ValueChanged="function(s, e) {
                                                        if(s.GetText().search('منتج') == 0) {
                                                            $('#divCompany').hide(300);
                                                            $('#divProduct').show(500);                                                            
                                                        }
                                                        else if(s.GetText().search('شركة') == 0) {
                                                            $('#divProduct').hide(300);
                                                            $('#divCompany').show(500);                                                            
                                                        }
                                                        else {
                                                            $('#divCompany').hide(500);
                                                            $('#divProduct').hide(500);
                                                        }
                                                        
                                                        GridUsersApp.PerformCallback('filterCountry');
                                                    
                                                    }" />
                                                <ItemStyle>
                                                    <BorderBottom BorderColor="#CCCCCC" BorderStyle="Dashed" BorderWidth="1px" />
                                                </ItemStyle>
                                                <ListBoxStyle Font-Size="Medium">
                                                </ListBoxStyle>
                                                <ValidationSettings Display="Dynamic" SetFocusOnError="True" ValidationGroup="notificationGroup">
                                                    <RequiredField IsRequired="True" />
                                                </ValidationSettings>
                                            </dx:ASPxComboBox>
                                            <dx:ASPxCheckBox ID="checkAll" runat="server" ClientInstanceName="checkAll" Font-Names="cairo" Font-Size="X-Large" ForeColor="#009900" Text="كامل المستخدمين التابعين لدولة الإشعار" Layout="Flow" TextSpacing="10px">
                                                <ClientSideEvents ValueChanged="function(s, e) { 
                                                    if (s.GetChecked()) {
                                                        $('#showGridDisabled').show(700);                                                      
                                                    } else {
                                                         $('#showGridDisabled').hide(300);    
                                                    }                                                    
                                                }" />
                                            </dx:ASPxCheckBox>
                                            <asp:SqlDataSource ID="DB_L_NotificationList" runat="server" ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>" SelectCommand="SELECT n.id,'<span style=''font-size:1.3em; color:#009933''>' +  n.type + ' (' + c.countryName + ')</span><br> - العنوان: ' + n.title + '<br> - المحتوى : ' + n.body as type FROM L_Notification n, countries c where n.countryId=c.id"></asp:SqlDataSource>
                                        </div>

                                    </div>


                                    <div id="divCompany" style="display: none; margin: 0 auto; text-align: center; width: 50%; padding: 0em; margin-top: 0em">

                                        <div style="padding: 1em">
                                            <dx:ASPxComboBox ID="Countries" runat="server" Font-Names="cairo" Width="100%" TextField="countryName" ValueField="id" EncodeHtml="false" Font-Bold="True" Font-Size="XX-Large" ClientInstanceName="Countries" DataSourceID="DB_Countries" NullText="الدولة" HorizontalAlign="Center" DropDownRows="4">
                                                <ClientSideEvents ValueChanged="function(s, e) { companies.PerformCallback(s.GetValue()); }" />
                                                <ItemStyle>
                                                    <BorderBottom BorderColor="#CCCCCC" BorderStyle="Dashed" BorderWidth="1px" />
                                                </ItemStyle>
                                                <ListBoxStyle Font-Size="Medium">
                                                </ListBoxStyle>
                                                <ValidationSettings Display="Dynamic" SetFocusOnError="True" ValidationGroup="notificationGroup">
                                                    <RequiredField IsRequired="True" />
                                                </ValidationSettings>
                                            </dx:ASPxComboBox>
                                        </div>

                                        <div style="padding: 1em">
                                            <dx:ASPxComboBox ID="companies" runat="server" Font-Names="cairo" Width="100%" TextField="companyName" ValueField="id" EncodeHtml="false" Font-Bold="True" Font-Size="XX-Large" ClientInstanceName="companies" DataSourceID="DB_Companies" NullText="الشركة" HorizontalAlign="Center" DropDownRows="4" OnCallback="companies_Callback">
                                                <ItemStyle>
                                                    <BorderBottom BorderColor="#CCCCCC" BorderStyle="Dashed" BorderWidth="1px" />
                                                </ItemStyle>
                                                <ListBoxStyle Font-Size="Medium">
                                                </ListBoxStyle>
                                                <ValidationSettings Display="Dynamic" SetFocusOnError="True" ValidationGroup="notificationGroup">
                                                    <RequiredField IsRequired="True" />
                                                </ValidationSettings>
                                            </dx:ASPxComboBox>
                                        </div>

                                    </div>


                                    <div id="divProduct" style="display: none; margin: 0 auto; text-align: center; width: 50%; padding: 0em; margin-top: 0em">

                                        <div style="padding: 1em">
                                            <dx:ASPxComboBox ID="CountriesProducts" runat="server" Font-Names="cairo" Width="100%" TextField="countryName" ValueField="id" EncodeHtml="false" Font-Bold="True" Font-Size="XX-Large" ClientInstanceName="CountriesProducts" DataSourceID="DB_Countries" NullText="الدولة" HorizontalAlign="Center" DropDownRows="4">
                                                <ClientSideEvents ValueChanged="function(s, e) { companiesProducts.PerformCallback(s.GetValue()); }" />
                                                <ItemStyle>
                                                    <BorderBottom BorderColor="#CCCCCC" BorderStyle="Dashed" BorderWidth="1px" />
                                                </ItemStyle>
                                                <ListBoxStyle Font-Size="Medium">
                                                </ListBoxStyle>
                                                <ValidationSettings Display="Dynamic" SetFocusOnError="True" ValidationGroup="notificationGroup">
                                                    <RequiredField IsRequired="True" />
                                                </ValidationSettings>
                                            </dx:ASPxComboBox>
                                        </div>

                                        <div style="padding: 1em">
                                            <dx:ASPxComboBox ID="companiesProducts" runat="server" Font-Names="cairo" Width="100%" TextField="companyName" ValueField="id" EncodeHtml="false" Font-Bold="True" Font-Size="XX-Large" ClientInstanceName="companiesProducts" DataSourceID="DB_Companies" NullText="الشركة" HorizontalAlign="Center" DropDownRows="4" OnCallback="companies_Callback">
                                                <ClientSideEvents ValueChanged="function(s, e) { products.PerformCallback(s.GetValue()); }" />
                                                <ItemStyle>
                                                    <BorderBottom BorderColor="#CCCCCC" BorderStyle="Dashed" BorderWidth="1px" />
                                                </ItemStyle>
                                                <ListBoxStyle Font-Size="Medium">
                                                </ListBoxStyle>
                                                <ValidationSettings Display="Dynamic" SetFocusOnError="True" ValidationGroup="notificationGroup">
                                                    <RequiredField IsRequired="True" />
                                                </ValidationSettings>
                                            </dx:ASPxComboBox>
                                        </div>

                                        <div style="padding: 1em">
                                            <dx:ASPxComboBox ID="products" runat="server" Font-Names="cairo" Width="100%" TextField="Name" ValueField="id" EncodeHtml="false" Font-Bold="True" Font-Size="XX-Large" ClientInstanceName="products" DataSourceID="DB_Products" NullText="المنتج" HorizontalAlign="Center" DropDownRows="4" OnCallback="products_Callback" ImageUrlField="imagePath">
                                                <ItemImage Height="100px" Width="100px">
                                                </ItemImage>
                                                <ItemStyle ImageSpacing="15px">
                                                    <BorderBottom BorderColor="#CCCCCC" BorderStyle="Dashed" BorderWidth="1px" />
                                                </ItemStyle>
                                                <ListBoxStyle Font-Size="Medium">
                                                </ListBoxStyle>
                                                <ValidationSettings Display="Dynamic" SetFocusOnError="True" ValidationGroup="notificationGroup">
                                                    <RequiredField IsRequired="True" />
                                                </ValidationSettings>
                                            </dx:ASPxComboBox>
                                        </div>

                                    </div>
                                    <asp:SqlDataSource ID="DB_Countries" runat="server" ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>" SelectCommand="SELECT id, countryName FROM countries"></asp:SqlDataSource>
                                    <asp:SqlDataSource ID="DB_Companies" runat="server" ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>" SelectCommand="SELECT id, companyName FROM companies where countryID = @countryID">
                                        <SelectParameters>
                                            <asp:Parameter Name="countryID" />
                                        </SelectParameters>
                                    </asp:SqlDataSource>
                                    <asp:SqlDataSource ID="DB_Products" runat="server" ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>" SelectCommand="SELECT p.id, p.Name, pi.imagePath FROM products p, productsImages pi where p.id = pi.productId and pi.isDefault=1 and p.companyID = @companyID">
                                        <SelectParameters>
                                            <asp:Parameter Name="companyID" />
                                        </SelectParameters>
                                    </asp:SqlDataSource>
                                    <asp:SqlDataSource ID="DB_UserLevel" runat="server" ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>" SelectCommand="SELECT id, description FROM L_UserLevel"></asp:SqlDataSource>



                                    <div style="margin: 0 auto; width: 100%;">
                                        <style>
                                            .parent-container {
                                                position: relative; /* Essential for positioning child elements */
                                            }

                                            .overlay-div {
                                                position: absolute; /* Positions the overlay relative to the parent */
                                                top: 0;
                                                left: 0;
                                                width: 100%;
                                                height: 100%;
                                                display: none;
                                                color: white;
                                                border: 3px solid #484848;
                                                border-radius: 0.5em;
                                                vertical-align: top;
                                                padding-top: 2.1em;
                                                font-family: cairo;
                                                font-size: 2.5em;
                                                background-color: rgba(81, 81, 81, 0.8); /* Semi-transparent black overlay */
                                                z-index: 10; /* Ensures the overlay appears above the content-div */
                                                justify-content: center;
                                                align-items: center;
                                            }
                                        </style>

                                        <div class="parent-container">
                                            <div class="content-div">

                                                <dx:ASPxGridView ID="GridUsersApp" runat="server" DataSourceID="db_UsersApp" KeyFieldName="id" ClientInstanceName="GridUsersApp" Width="100%" AutoGenerateColumns="False" EnablePagingCallbackAnimation="True" Font-Names="cairo" Font-Size="1em" RightToLeft="True" OnCustomCallback="GridUsersApp_CustomCallback" OnBeforePerformDataSelect="GridUsersApp_BeforePerformDataSelect">
                                                    <ClientSideEvents EndCallback="function(s, e) { 
                                                          if (s.cpResult == '10') {
                                                              labelContent.SetText('حدث خطأ أثناء إرسال الإشعارات');
                                                              Pop_DetailsNote.Show();
                                                          }
                                                          else if (s.cpResult == '100') {
                                                              labelContent.SetText('تم إرسال الإشعارات إلى المستخدمين بنجاح');
                                                              Pop_DetailsNote.Show();
                                                          }
                                                          s.cpResult = 0;

                                                          //Countries.SetValue('');
                                                          //companies.SetValue('');
 
                                                          //CountriesProducts.SetValue('');
                                                          //companiesProducts.SetValue('');
                                                          //products.SetValue('');

                                                          //notificationList.SetValue('');                                             

                                                          sendNotifications.SetText('إرســــــال');
                                                          sendNotifications.SetEnabled(true);
                                                      }" />
                                                    <Settings ShowFilterRow="True" ShowFilterRowMenu="True" ShowHeaderFilterButton="False" AutoFilterCondition="Contains" />
                                                    <SettingsAdaptivity AdaptivityMode="HideDataCells">
                                                    </SettingsAdaptivity>
                                                    <Settings ShowFooter="True" ShowFilterRow="True" />
                                                    <SettingsBehavior AllowSelectByRowClick="True" />
                                                    <SettingsCommandButton>
                                                        <NewButton Text="جديد">
                                                        </NewButton>
                                                        <UpdateButton Text=" حفظ ">
                                                            <Image Url="~/assets/img/save.png" SpriteProperties-Left="50">
                                                                <SpriteProperties Left="50px"></SpriteProperties>
                                                            </Image>
                                                        </UpdateButton>
                                                        <CancelButton Text=" الغاء ">
                                                            <Image Url="~/assets/img/cancel.png">
                                                            </Image>
                                                        </CancelButton>
                                                    </SettingsCommandButton>

                                                    <SettingsPopup>
                                                        <FilterControl AutoUpdatePosition="False"></FilterControl>
                                                    </SettingsPopup>

                                                    <SettingsSearchPanel CustomEditorID="tbToolbarSearch1" />

                                                    <SettingsExport EnableClientSideExportAPI="true" ExcelExportMode="WYSIWYG" PaperKind="A4" RightToLeft="True" />
                                                    <SettingsLoadingPanel Text="Please Wait &amp;hellip;" Mode="ShowAsPopup" />
                                                    <SettingsText SearchPanelEditorNullText="ابحث في الجدول..." EmptyDataRow="لا يوجد" />
                                                    <Columns>
                                                        <dx:GridViewCommandColumn ShowSelectCheckbox="True" ShowClearFilterButton="true" SelectAllCheckboxMode="AllPages" />

                                                        <dx:GridViewDataColumn Caption="الرقم" FieldName="id">
                                                            <EditFormSettings Visible="False" />
                                                            <CellStyle VerticalAlign="Middle" HorizontalAlign="Center">
                                                            </CellStyle>
                                                        </dx:GridViewDataColumn>

                                                        <dx:GridViewDataColumn Caption="Token" FieldName="FCMToken" Visible="False">
                                                            <EditFormSettings Visible="False" />
                                                            <CellStyle VerticalAlign="Middle" HorizontalAlign="Center">
                                                            </CellStyle>
                                                        </dx:GridViewDataColumn>

                                                        <dx:GridViewDataComboBoxColumn Caption="الدولة" FieldName="countryId">
                                                            <PropertiesComboBox DataSourceID="DB_Countries" TextField="countryName" ValueField="id" ValueType="System.Int32">
                                                            </PropertiesComboBox>
                                                            <CellStyle VerticalAlign="Middle" HorizontalAlign="Center" />
                                                        </dx:GridViewDataComboBoxColumn>

                                                        <dx:GridViewDataSpinEditColumn Caption="الرصيد" FieldName="balance">
                                                            <PropertiesSpinEdit DisplayFormatString="g"></PropertiesSpinEdit>

                                                            <CellStyle HorizontalAlign="Center" VerticalAlign="Middle" Font-Bold="True" Font-Size="Larger">
                                                            </CellStyle>
                                                        </dx:GridViewDataSpinEditColumn>

                                                        <dx:GridViewDataComboBoxColumn Caption="المستوى" FieldName="l_userLevelId">
                                                            <PropertiesComboBox DataSourceID="DB_UserLevel" TextField="description" ValueField="id" ValueType="System.Int32">
                                                            </PropertiesComboBox>
                                                            <CellStyle HorizontalAlign="Center" VerticalAlign="Middle" Font-Bold="True" Font-Size="Larger">
                                                            </CellStyle>
                                                        </dx:GridViewDataComboBoxColumn>

                                                        <dx:GridViewDataSpinEditColumn Caption="النقاط" FieldName="userPoints">
                                                            <PropertiesSpinEdit DisplayFormatString="g"></PropertiesSpinEdit>

                                                            <CellStyle HorizontalAlign="Center" VerticalAlign="Middle" Font-Bold="True" Font-Size="Larger">
                                                            </CellStyle>
                                                        </dx:GridViewDataSpinEditColumn>

                                                        <dx:GridViewDataColumn Caption="المنصة" FieldName="userPlatform">
                                                            <CellStyle HorizontalAlign="Center" VerticalAlign="Middle">
                                                            </CellStyle>
                                                        </dx:GridViewDataColumn>

                                                        <dx:GridViewDataDateColumn Caption="التاريخ" FieldName="userDate" Width="7%">
                                                            <EditFormSettings Visible="False" />
                                                            <PropertiesDateEdit DisplayFormatString="dd/MM/yyyy"></PropertiesDateEdit>
                                                            <CellStyle VerticalAlign="Middle"></CellStyle>
                                                        </dx:GridViewDataDateColumn>

                                                        <dx:GridViewDataTextColumn Caption="إسم المستخدم" FieldName="userFullName" ShowInCustomizationForm="True" VisibleIndex="2">
                                                            <PropertiesTextEdit EncodeHtml="False">
                                                            </PropertiesTextEdit>
                                                            <CellStyle HorizontalAlign="Center" VerticalAlign="Middle">
                                                            </CellStyle>
                                                        </dx:GridViewDataTextColumn>

                                                    </Columns>
                                                    <Toolbars>
                                                        <dx:GridViewToolbar ItemAlign="left">
                                                            <SettingsAdaptivity Enabled="true" EnableCollapseRootItemsToIcons="true" />
                                                            <Items>
                                                                <dx:GridViewToolbarItem Command="Refresh" BeginGroup="true" AdaptivePriority="1" Text="تحديث الجدول" />
                                                                <dx:GridViewToolbarItem Command="ExportToXlsx" BeginGroup="true" />
                                                                <dx:GridViewToolbarItem Command="ExportToPdf" />

                                                                <dx:GridViewToolbarItem Alignment="Right" Name="toolbarItemSearch" BeginGroup="true" AdaptivePriority="2">
                                                                    <Template>
                                                                        <dx:ASPxButtonEdit ID="tbToolbarSearch1" runat="server" NullText="البحث..." Width="140" Font-Names="cairo" />
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
                                                    <Paddings Padding="2em" />
                                                </dx:ASPxGridView>

                                            </div>
                                            <div id="showGridDisabled" class="overlay-div">
                                                تم اختيار إرسال الإشعار إلى جميع المستخدمين التابعين لدولة الإشعار
                                            </div>
                                        </div>
                                    </div>


                                    <asp:SqlDataSource ID="db_UsersApp" runat="server" ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>"
                                        SelectCommand="select c.id as countryId, u.id, '<b>' + u.firstName + ' ' + u.lastName + '</b> <br>( ' + u.username + ' ) ' as userFullName, u.balance, l_userLevelId, u.userPoints, u.userPlatform , FCMToken,  u.userDate from usersApp u, countries c where u.countryCode = c.countryCode and (c.id=@countryId or @countryId=1000) and u.isActive = 1 and u.isDeleted = 0 order by id desc">
                                        <SelectParameters>
                                            <asp:Parameter Name="countryId" Type="Int32" DefaultValue="1000" />
                                        </SelectParameters>
                                    </asp:SqlDataSource>


                                    <dx:ASPxPopupControl runat="server" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter"
                                        AutoUpdatePosition="True" Modal="True" ClientInstanceName="Pop_DetailsNote" CloseAnimationType="Slide"
                                        FooterText="" HeaderText="الإشعارات" Font-Names="Cairo" MinWidth="350px" MinHeight="150px" Width="550px" Height="150px" ID="Pop_DetailsNote">
                                        <ContentCollection>
                                            <dx:PopupControlContentControl runat="server">
                                                <div style="padding: 20px; font-family: 'Cairo', sans-serif; text-align: center">
                                                    <div class="mb-3" style="width: 100%;">

                                                        <dx:ASPxLabel runat="server" Text="الرجاء اختيار مستخدمين حتى يتم إرسال الإشعارات" ClientInstanceName="labelContent"
                                                            Font-Names="Cairo" Font-Size="X-Large" ForeColor="#333333" ID="ASPxLabel2">
                                                        </dx:ASPxLabel>
                                                        <br />
                                                        <br />
                                                    </div>
                                                    <div style="width: 100%; margin-top: 20px; text-align: center;">
                                                        <dx:ASPxButton ID="ASPxButton4" runat="server" AutoPostBack="False" Text="إغـــــــــــلاق"
                                                            UseSubmitBehavior="False" Font-Names="Cairo" HorizontalAlign="Center" VerticalAlign="Middle"
                                                            Style="margin-right: 20px;" Height="70px">
                                                            <ClientSideEvents Click="function(s, e) {Pop_DetailsNote.Hide();}" />
                                                        </dx:ASPxButton>
                                                    </div>
                                                </div>
                                            </dx:PopupControlContentControl>
                                        </ContentCollection>
                                    </dx:ASPxPopupControl>


                                </div>

                            </dx:ContentControl>
                        </ContentCollection>
                    </dx:TabPage>
                    <dx:TabPage Text="إعداد الإشعارات" TabStyle-Font-Bold="true" TabStyle-Font-Names="cairo" TabStyle-Font-Size="X-Large">
                        <TabStyle Font-Bold="True" Font-Names="cairo" Font-Size="X-Large"></TabStyle>
                        <ContentCollection>
                            <dx:ContentControl>
                                <div class="navbar-main navbar-expand-lg px-0 mx-4 border-radius-xl bg-white shadow mt-3 mb-1">

                                    <dx:ASPxGridView ID="GridNotifications" runat="server" DataSourceID="db_Points" KeyFieldName="id" ClientInstanceName="GridNotifications" Width="100%" AutoGenerateColumns="False" EnablePagingCallbackAnimation="True" Font-Names="cairo" Font-Size="1.1em" RightToLeft="True"
                                        OnCancelRowEditing="GridNotifications_CancelRowEditing" OnRowUpdated="GridNotifications_RowUpdated" OnRowDeleting="GridNotifications_RowDeleting">
                                        <Settings ShowFilterRow="True" ShowFilterRowMenu="False" ShowHeaderFilterButton="False" AutoFilterCondition="Contains" />

                                        <ClientSideEvents BeginCallback="OnGridBeginCallback" RowClick="OnRowClick" RowDblClick="function(s, e) {setTimeout(function(){GridNotifications.StartEditRow(MyIndex);},100);}"
                                            EndCallback="function(s, e) { notificationList.PerformCallback(); }" />
                                        <SettingsAdaptivity AdaptivityMode="HideDataCells">
                                        </SettingsAdaptivity>
                                        <Settings ShowFooter="True" ShowFilterRow="True" />
                                        <SettingsCommandButton>
                                            <NewButton Text="جديد">
                                            </NewButton>
                                            <UpdateButton Text=" حفظ ">
                                                <Image Url="~/assets/img/save.png" SpriteProperties-Left="50">
                                                    <SpriteProperties Left="50px"></SpriteProperties>
                                                </Image>
                                            </UpdateButton>
                                            <CancelButton Text=" الغاء ">
                                                <Image Url="~/assets/img/cancel.png">
                                                </Image>
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
                                                <CellStyle VerticalAlign="Middle" HorizontalAlign="Center">
                                                </CellStyle>
                                            </dx:GridViewDataColumn>

                                            <dx:GridViewDataColumn Caption="الصورة" FieldName="imagePath" EditFormSettings-VisibleIndex="1" EditFormSettings-Caption=" ">
                                                <EditFormSettings RowSpan="6" VisibleIndex="1" Caption=" "></EditFormSettings>
                                                <DataItemTemplate>
                                                    <div style="text-align: center; width: 100%">
                                                        <img id="<%# "DocsFile-" + Eval("id") %>" src="<%# (!string.IsNullOrEmpty(Eval("imagePath").ToString()) ? Eval("imagePath") : "/assets/uploads/noFile.png") + "?v=" + DateTime.Now.Ticks %>" style="width: 7em; border: 1px solid #c8c8c8; border-radius: 5px; margin-top: 10px;" />
                                                    </div>
                                                </DataItemTemplate>
                                                <CellStyle VerticalAlign="Middle">
                                                </CellStyle>

                                                <EditItemTemplate>
                                                    <div style="text-align: center; width: 90%">
                                                        <img id="<%# "DocsFileLarge-" + Eval("id") %>" src="<%# (Eval("imagePath") != null && Eval("imagePath").ToString().Length > 1 ? Eval("imagePath").ToString() : "/assets/uploads/noFile.png") + "?v=" + DateTime.Now.Ticks %>" style="width: 15em; border: 1px solid #c8c8c8; border-radius: 5px;" />
                                                        <dx:ASPxUploadControl ID="poorImageUpload" runat="server" ClientInstanceName="poorImageUpload" FileUploadMode="OnPageLoad" Font-Names="Cairo" Font-Size="1em" OnFileUploadComplete="ImageUpload_FileUploadComplete" ShowProgressPanel="True" UploadMode="Auto" Width="100%" AutoStartUpload="True">
                                                            <ValidationSettings AllowedFileExtensions=".jpg, .jpeg, .png, .bmp" GeneralErrorText="حدث خطأ أثناء تحميل الصور ، الرجاء المحاولة لاحقا" MaxFileSize="10000000" MaxFileSizeErrorText="حجم الصورة أكبر من 10 ميجابايت ، الرجاء اختيار صورة بحجم أقل" NotAllowedFileExtensionErrorText="امتداد الصورة غير مسموح به">
                                                            </ValidationSettings>
                                                            <ClientSideEvents FilesUploadStart="onFileUploadStart" FileUploadComplete="onFileUploadComplete" />
                                                            <BrowseButton Text="اختيــــــــار">
                                                            </BrowseButton>
                                                            <CancelButton Text="إلغاء التحميل">
                                                            </CancelButton>
                                                            <NullTextStyle Font-Names="Cairo">
                                                            </NullTextStyle>
                                                        </dx:ASPxUploadControl>
                                                    </div>
                                                </EditItemTemplate>

                                            </dx:GridViewDataColumn>


                                            <dx:GridViewDataTextColumn Caption="نوع الإشعار" FieldName="type">
                                                <PropertiesTextEdit>
                                                    <ValidationSettings RequiredField-IsRequired="true" SetFocusOnError="True" ErrorText="required." Display="Dynamic">
                                                        <RequiredField IsRequired="True"></RequiredField>
                                                    </ValidationSettings>
                                                </PropertiesTextEdit>
                                                <CellStyle HorizontalAlign="Center" VerticalAlign="Middle">
                                                </CellStyle>
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn Caption="عنوان الإشعار" FieldName="title" Width="15%">
                                                <PropertiesTextEdit>
                                                    <ValidationSettings RequiredField-IsRequired="true" SetFocusOnError="True" ErrorText="required." Display="Dynamic">
                                                        <RequiredField IsRequired="True"></RequiredField>
                                                    </ValidationSettings>
                                                </PropertiesTextEdit>
                                                <CellStyle HorizontalAlign="Center" VerticalAlign="Middle" Font-Bold="True" Font-Size="Larger">
                                                </CellStyle>
                                            </dx:GridViewDataTextColumn>

                                            <dx:GridViewDataTextColumn Caption="محتوى الرسالة" FieldName="body" Width="30%">
                                                <PropertiesTextEdit>
                                                    <ValidationSettings RequiredField-IsRequired="true" SetFocusOnError="True" ErrorText="required." Display="Dynamic">
                                                        <RequiredField IsRequired="True"></RequiredField>
                                                    </ValidationSettings>
                                                </PropertiesTextEdit>
                                                <CellStyle HorizontalAlign="Center" VerticalAlign="Middle" Font-Bold="True" Font-Size="Larger">
                                                </CellStyle>
                                            </dx:GridViewDataTextColumn>

                                            <dx:GridViewDataComboBoxColumn Caption="الدولة" FieldName="countryId">
                                                <PropertiesComboBox DataSourceID="DB_Countries" TextField="countryName" ValueField="id" ValueType="System.Int32" ClientInstanceName="countryAll">
                                                    <ValidationSettings RequiredField-IsRequired="true" SetFocusOnError="True" ErrorText="required." Display="Dynamic">
                                                        <RequiredField IsRequired="True"></RequiredField>
                                                    </ValidationSettings>
                                                </PropertiesComboBox>
                                                <CellStyle VerticalAlign="Middle" HorizontalAlign="Center" />
                                            </dx:GridViewDataComboBoxColumn>

                                            <dx:GridViewDataTextColumn Caption="الإجراء البرمجي" FieldName="actionType">
                                                <PropertiesTextEdit>
                                                    <ValidationSettings RequiredField-IsRequired="true" SetFocusOnError="True" ErrorText="required." Display="Dynamic">
                                                        <RequiredField IsRequired="True"></RequiredField>
                                                    </ValidationSettings>
                                                </PropertiesTextEdit>
                                                <CellStyle HorizontalAlign="Center" VerticalAlign="Middle">
                                                </CellStyle>
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn Caption="رمز المجموعة" FieldName="usersGroup">
                                                <PropertiesTextEdit>
                                                    <ValidationSettings RequiredField-IsRequired="true" SetFocusOnError="True" ErrorText="required." Display="Dynamic">
                                                        <RequiredField IsRequired="True"></RequiredField>
                                                    </ValidationSettings>
                                                </PropertiesTextEdit>
                                                <CellStyle HorizontalAlign="Center" VerticalAlign="Middle">
                                                </CellStyle>
                                            </dx:GridViewDataTextColumn>

                                            <dx:GridViewDataDateColumn Caption="التاريخ" FieldName="userDate" Width="7%">
                                                <EditFormSettings Visible="False" />
                                                <PropertiesDateEdit DisplayFormatString="dd/MM/yyyy"></PropertiesDateEdit>
                                                <CellStyle VerticalAlign="Middle"></CellStyle>
                                            </dx:GridViewDataDateColumn>

                                            <dx:GridViewDataTextColumn Caption="" ShowInCustomizationForm="True" Width="110px">
                                                <EditFormSettings Visible="False" />
                                                <DataItemTemplate>
                                                    <div style="width: 100%; float: left; text-align: center">
                                                        <img src="/assets/img/update.png" width="32" height="32" title="تعديل" style="cursor: pointer" onclick="setTimeout(function(){GridNotifications.StartEditRow(MyIndex);},100);" />
                                                        <img src="/assets/img/delete.png" width="32" height="32" title="حذف" style="cursor: pointer" onclick="Pop_DetailsDel.Show();" />
                                                    </div>
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
                                            <AlternatingRow BackColor="#F0F0F0">
                                            </AlternatingRow>
                                            <Footer Font-Names="cairo">
                                            </Footer>
                                        </Styles>
                                        <Paddings Padding="2em" />
                                    </dx:ASPxGridView>

                                    <asp:SqlDataSource
                                        ID="db_Points"
                                        runat="server"
                                        ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>"
                                        SelectCommand="SELECT [id], [countryId], [type], [actionType], [title], [body], [imagePath], [usersGroup], [userDate] FROM L_Notification;"
                                        InsertCommand="INSERT INTO [L_Notification] ([countryId], [type], [actionType], [title], [body], [imagePath], [usersGroup], [userDate])
                                                       VALUES (@countryId, @type, @actionType, @title, @body, @imagePath, @usersGroup, getdate());"
                                        UpdateCommand="UPDATE [L_Notification]
                                           SET [countryId] = @countryId,
                                               [type]   = @type,
                                               [actionType]  = @actionType,
                                               [title]  = @title,
                                               [body]  = @body,
                                               [imagePath] = @imagePath,
                                               [usersGroup] = @usersGroup
                                           WHERE [id] = @id;"
                                        DeleteCommand="
                                           DELETE FROM L_Notification WHERE id = @id">
                                        <InsertParameters>
                                            <asp:Parameter Name="countryId" Type="String" />
                                            <asp:Parameter Name="type" Type="String" />
                                            <asp:Parameter Name="actionType" Type="String" />
                                            <asp:Parameter Name="title" Type="String" />
                                            <asp:Parameter Name="body" Type="String" />
                                            <asp:Parameter Name="usersGroup" Type="String" />
                                            <asp:ControlParameter ControlID="l_item_file" Name="imagePath" PropertyName="Text" />
                                        </InsertParameters>
                                        <UpdateParameters>
                                            <asp:Parameter Name="countryId" Type="String" />
                                            <asp:Parameter Name="type" Type="String" />
                                            <asp:Parameter Name="actionType" Type="String" />
                                            <asp:Parameter Name="title" Type="String" />
                                            <asp:Parameter Name="body" Type="String" />
                                            <asp:Parameter Name="usersGroup" Type="String" />
                                            <asp:ControlParameter ControlID="l_item_file" Name="imagePath" PropertyName="Text" Type="String" />
                                        </UpdateParameters>
                                    </asp:SqlDataSource>

                                    <dx:ASPxPopupControl runat="server" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter"
                                        AutoUpdatePosition="True" Modal="True" ClientInstanceName="Pop_DetailsDel" CloseAnimationType="Slide"
                                        FooterText="" HeaderText="حذف إشعار" Font-Names="Cairo" MinWidth="350px" MinHeight="150px" Width="350px" Height="150px" ID="Pop_DetailsDel">
                                        <ContentCollection>
                                            <dx:PopupControlContentControl runat="server">
                                                <div style="padding: 20px; font-family: 'Cairo', sans-serif; text-align: right">
                                                    <div class="mb-3" style="width: 100%;">
                                                        <dx:ASPxLabel runat="server" Text="هل أنت متأكد من حذف الإشعار؟" ClientInstanceName="labelProducts"
                                                            Font-Names="Cairo" Font-Size="Medium" ForeColor="#333333" ID="ASPxLabel1">
                                                        </dx:ASPxLabel>
                                                    </div>
                                                    <div style="width: 100%; margin-top: 20px; text-align: center;">
                                                        <dx:ASPxButton ID="ASPxButton1" runat="server" AutoPostBack="False" Text="حــــــــذف"
                                                            UseSubmitBehavior="False" Font-Names="Cairo" HorizontalAlign="Center" VerticalAlign="Middle">
                                                            <ClientSideEvents Click="function(s, e) { 
                                                                 GridNotifications.DeleteRow(MyIndex); 
                                                                 Pop_DetailsDel.Hide();
                                                             }" />
                                                        </dx:ASPxButton>

                                                        <dx:ASPxButton ID="ASPxButton2" runat="server" AutoPostBack="False" Text="إغـــــــــــلاق"
                                                            UseSubmitBehavior="False" Font-Names="Cairo" HorizontalAlign="Center" VerticalAlign="Middle"
                                                            Style="margin-right: 20px;">
                                                            <ClientSideEvents Click="function(s, e) {Pop_DetailsDel.Hide();}" />
                                                        </dx:ASPxButton>
                                                    </div>
                                                </div>
                                            </dx:PopupControlContentControl>
                                        </ContentCollection>
                                    </dx:ASPxPopupControl>

                                </div>

                            </dx:ContentControl>
                        </ContentCollection>
                    </dx:TabPage>


                </TabPages>
            </dx:ASPxPageControl>








            <dx:ASPxTextBox ID="l_item_file" runat="server" BackColor="Transparent" ClientInstanceName="l_item_file" Font-Size="0pt" ForeColor="Transparent" Text="" Width="0px" Theme="Default">
                <Border BorderStyle="None" BorderWidth="0px" />
            </dx:ASPxTextBox>
            <dx:ASPxTextBox ID="l_item_file_old" runat="server" BackColor="Transparent" ClientInstanceName="l_item_file_old" Font-Size="0pt" ForeColor="Transparent" Text="" Width="0px" Theme="Default">
                <Border BorderStyle="None" BorderWidth="0px" />
            </dx:ASPxTextBox>
            <dx:ASPxTextBox ID="l_item_file_check" runat="server" BackColor="Transparent" ClientInstanceName="l_item_file_check" Font-Size="0pt" ForeColor="Transparent" Text="0" Width="0px" Theme="Default">
                <Border BorderStyle="None" BorderWidth="0px" />
            </dx:ASPxTextBox>
        </main>

    

</asp:Content>
