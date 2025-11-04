<%@ Page Title="Branches" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Categories.aspx.cs" Inherits="ShabAdmin.Categories" %>

<%@ Register Assembly="DevExpress.Web.v24.1, Version=24.1.6.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    
        <main>

            <script>
                var MyId;
                var MyIndex;
                var MyIndexDetail;

                function OnRowClick(s, e) {
                    MyIndex = e.visibleIndex;
                    GridCategories.GetRowValues(e.visibleIndex, 'id;image', OnGetRowValues);
                }

                function OnRowClickDetail(s, e) {
                    MyIndexDetail = e.visibleIndex;
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

                function onDeleteClick(visibleIndex, gridNo) {
                    MyIndex = visibleIndex;
                    var CategoryID = GridCategories.GetRowKey(visibleIndex);
                    GridCategories.PerformCallback(CategoryID);
                }

                function onGridEndCallback(s, e) {
                    if (s.cpGridNo !== undefined && s.cpDeleteConfirmed !== true) {
                        var confirmMessage = "";
                        var currentGridNo = s.cpGridNo;


                        var hasProducts = (s.cpHasProducts == 1);
                        delete s.cpHasProducts;
                        delete s.cpCategoryID;
                        confirmMessage = hasProducts
                            ? " هذا النوع مرتبط ببيانات أخرى.\nهل أنت متأكد أنك تريد حذف النوع مع البيانات المرتبطة؟"
                            : "هل أنت متأكد أنك تريد حذف هذا النوع؟";

                        delete s.cpGridNo;

                        labelCountries.SetText(confirmMessage);
                        Pop_Del_Grids.cpGridNo = currentGridNo;
                        Pop_Del_Grids.Show();
                    }
                }

                var isResetRequired = false;
                function onSelectedCountryChanged(s, e) {
                    isResetRequired = true;
                    GridCategories.GetEditor("companyId").PerformCallback(s.GetValue());
                }

                function onCityEndCallback(s, e) {
                    if (isResetRequired) {
                        isResetRequired = false;
                        s.SetSelectedIndex(0);
                    }
                }
            </script>

            <div class="w-100 text-center my-4">
                <h2 class="pageTitle d-inline-block" style="font-family: Cairo">المجموعـــات</h2>
            </div>

            <div class="navbar-main navbar-expand-lg px-0 mx-4 border-radius-xl bg-white shadow mt-3 mb-1">


                <dx:ASPxGridView ID="GridCategories" runat="server" DataSourceID="db_Categories" KeyFieldName="id" OnCustomCallback="GridCategories_CustomCallback" ClientInstanceName="GridCategories" Width="100%" AutoGenerateColumns="False" EnablePagingCallbackAnimation="True" Font-Names="cairo" Font-Size="1em" RightToLeft="True"
                    OnCancelRowEditing="GridCategories_CancelRowEditing" OnRowUpdated="GridCategories_RowUpdated" OnRowDeleting="GridCategories_RowDeleting" OnHtmlRowCreated="GridCategories_HtmlRowCreated" OnCellEditorInitialize="GridCategories_CellEditorInitialize" OnBeforePerformDataSelect="GridCategories_BeforePerformDataSelect">
                    <Settings ShowFilterRow="True" ShowFilterRowMenu="False" ShowHeaderFilterButton="False" AutoFilterCondition="Contains" />

                    <ClientSideEvents BeginCallback="OnGridBeginCallback" RowClick="OnRowClick" RowDblClick="function(s, e) {setTimeout(function(){GridCategories.StartEditRow(MyIndex);},100);}"
                        DetailRowExpanding="function(s, e) { MyIndex=e.visibleIndex; }" EndCallback="onGridEndCallback" />
                    <SettingsDetail ShowDetailRow="true" AllowOnlyOneMasterRowExpanded="True" />


                    <SettingsAdaptivity AdaptivityMode="HideDataCells">
                    </SettingsAdaptivity>


                    <Templates>
                        <DetailRow>
                            <div style="margin: 0 auto; font-size: 2em; text-align: center">
                                المجموعات الفرعية   
                            </div>

                            <dx:ASPxGridView ID="detailGrid" runat="server" DataSourceID="DB_DetailCategoriesSub" ClientInstanceName="detailGrid" KeyFieldName="id" Width="100%" AutoGenerateColumns="False" EnablePagingCallbackAnimation="True" OnBeforePerformDataSelect="detailGrid_BeforePerformDataSelect" Font-Names="cairo" Font-Size="1em">
                                <Settings ShowFooter="True" ShowFilterRow="True" />

                                <ClientSideEvents RowClick="OnRowClickDetail" />
                                <SettingsAdaptivity AdaptivityMode="HideDataCells">
                                </SettingsAdaptivity>
                                <Settings ShowFilterRow="True" ShowFilterRowMenu="False" ShowHeaderFilterButton="False" AutoFilterCondition="Contains" />

                                <SettingsCommandButton>
                                    <NewButton Text="جديد">
                                    </NewButton>
                                    <UpdateButton Text=" حفظ ">
                                        <Image Url="/assets/img/save.png" SpriteProperties-Left="50">
                                            <SpriteProperties Left="50px" />
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

                                <SettingsSearchPanel CustomEditorID="tbToolbarSearch2" />

                                <SettingsExport EnableClientSideExportAPI="true" ExcelExportMode="WYSIWYG" PaperKind="A4" RightToLeft="True" />
                                <SettingsLoadingPanel Text="الرجاء الانتظار &amp;hellip;" Mode="ShowAsPopup" />
                                <SettingsText SearchPanelEditorNullText="ابحث في كامل الجدول..." EmptyDataRow="لا يوجد" />
                                <Columns>
                                    <dx:GridViewDataColumn FieldName="id" Caption="الرقم" VisibleIndex="0" Width="5%">
                                        <EditFormSettings Visible="False" />
                                        <CellStyle VerticalAlign="Middle">
                                        </CellStyle>
                                    </dx:GridViewDataColumn>
                                    <dx:GridViewDataColumn FieldName="subName" Caption="المجموعة الفرعية" VisibleIndex="1">
                                        <CellStyle VerticalAlign="Middle">
                                        </CellStyle>
                                    </dx:GridViewDataColumn>
                                    <dx:GridViewDataTextColumn Caption="" ShowInCustomizationForm="True" Width="100px">
                                        <EditFormSettings Visible="False" />
                                        <DataItemTemplate>
                                            <div style="width: 50%; float: left; text-align: center">
                                                <img src="/assets/img/delete.png" width="32" height="32" title="حذف السجل" style="cursor: pointer" onclick="Pop_Del.Show();" />
                                            </div>
                                            <div style="width: 50%; float: left; text-align: center">
                                                <img src="/assets/img/update.png" width="32" height="32" title="تعديل السجل" style="cursor: pointer" onclick="setTimeout(function(){detailGrid.StartEditRow(MyIndexDetail);},100);" />
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
                                                    <dx:ASPxButtonEdit ID="tbToolbarSearch2" runat="server" NullText="بحث..." Width="140" Font-Names="cairo" />
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
                                <Border BorderColor="#53baff" BorderWidth="5px" BorderStyle="Solid" />
                                <Paddings Padding="1em" />
                            </dx:ASPxGridView>

                            <div style="margin: 0 auto; font-size: 2em; text-align: center">
                                <dx:ASPxButton ID="closeDetail" runat="server" Text="إغـــــلاق" AutoPostBack="False" CausesValidation="False" UseSubmitBehavior="False" Font-Size="Large" Font-Names="cairo">
                                    <ClientSideEvents Click="function(s, e){ GridCategories.CollapseDetailRow(MyIndex) }" />
                                </dx:ASPxButton>
                            </div>


                        </DetailRow>
                    </Templates>
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

                    <SettingsSearchPanel CustomEditorID="tbToolbarSearch1" />

                    <SettingsExport EnableClientSideExportAPI="true" ExcelExportMode="WYSIWYG" PaperKind="A4" RightToLeft="True" />
                    <SettingsLoadingPanel Text="Please Wait &amp;hellip;" Mode="ShowAsPopup" />
                    <SettingsText SearchPanelEditorNullText="ابحث في الجدول..." EmptyDataRow="لا يوجد" />
                    <Columns>
                        <dx:GridViewDataColumn Caption="الرقم" FieldName="id">
                            <EditFormSettings Visible="False" />
                            <CellStyle VerticalAlign="Middle" HorizontalAlign="Center">
                            </CellStyle>
                        </dx:GridViewDataColumn>

                        <dx:GridViewDataComboBoxColumn Caption="الدولة" FieldName="countryId">
                            <PropertiesComboBox DataSourceID="DB_Countries" TextField="countryName" ValueField="id" ValueType="System.Int32">
                                <ValidationSettings RequiredField-IsRequired="true" SetFocusOnError="True" ErrorText="required." Display="Dynamic">
                                    <RequiredField IsRequired="True"></RequiredField>
                                </ValidationSettings>
                                <ItemStyle Font-Size="1.5em" />
                                <ClientSideEvents SelectedIndexChanged="onSelectedCountryChanged" />
                            </PropertiesComboBox>
                            <CellStyle VerticalAlign="Middle" HorizontalAlign="Center">
                            </CellStyle>
                        </dx:GridViewDataComboBoxColumn>

                        <dx:GridViewDataComboBoxColumn Caption="الشركة" FieldName="companyId">
                            <PropertiesComboBox DataSourceID="DB_Companies" ValueField="id" TextField="companyName" ValueType="System.Int32">
                                <ClientSideEvents EndCallback="onCityEndCallback" />
                                <ValidationSettings RequiredField-IsRequired="true" SetFocusOnError="True" ErrorText="required." Display="Dynamic">
                                    <RequiredField IsRequired="True"></RequiredField>
                                </ValidationSettings>
                            </PropertiesComboBox>
                            <CellStyle VerticalAlign="Middle" HorizontalAlign="Center">
                            </CellStyle>
                        </dx:GridViewDataComboBoxColumn>

                        <dx:GridViewDataTextColumn Caption="المجموعة الرئيسية" FieldName="name">
                            <PropertiesTextEdit>
                                <ValidationSettings RequiredField-IsRequired="true" SetFocusOnError="True" ErrorText="Country name in arabic is required." Display="Dynamic">
                                    <RequiredField IsRequired="True"></RequiredField>
                                </ValidationSettings>
                            </PropertiesTextEdit>
                            <CellStyle VerticalAlign="Middle" HorizontalAlign="Center">
                            </CellStyle>
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn Caption="المجموعة الفرعية" Width="30%">
                             <EditFormSettings Visible="False" />
                            <DataItemTemplate>
                                <dx:ASPxLabel ID="GroupName" runat="server" Font-Names="cairo" Font-Size="Smaller" Text="" EncodeHtml="false"></dx:ASPxLabel>
                            </DataItemTemplate>
                            <CellStyle VerticalAlign="Middle" HorizontalAlign="Center">
                            </CellStyle>
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn Caption="الاسم بالانجليزي" FieldName="nameEn">
                            <PropertiesTextEdit>
                                <ValidationSettings RequiredField-IsRequired="true" SetFocusOnError="True" ErrorText="Country name in arabic is required." Display="Dynamic">
                                    <RequiredField IsRequired="True"></RequiredField>
                                </ValidationSettings>
                            </PropertiesTextEdit>
                            <EditFormSettings Visible="True" />
                            <CellStyle VerticalAlign="Middle" HorizontalAlign="Center" />
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn Caption="عدد المواد" FieldName="itemCount">
                            <PropertiesTextEdit>
                                <ValidationSettings SetFocusOnError="True" Display="Dynamic">
                                    <RequiredField IsRequired="true" ErrorText="item Count is required." />
                                    <RegularExpression ValidationExpression="^\d+$" ErrorText="item Count must be a number." />
                                </ValidationSettings>
                            </PropertiesTextEdit>
                            <EditFormSettings Visible="True" />
                            <CellStyle VerticalAlign="Middle" HorizontalAlign="Center" />
                        </dx:GridViewDataTextColumn>


                        <dx:GridViewDataColumn Caption="الصورة" FieldName="image" EditFormSettings-VisibleIndex="1" EditFormSettings-Caption=" ">
                            <EditFormSettings RowSpan="5" VisibleIndex="1" Caption=" "></EditFormSettings>
                            <DataItemTemplate>
                                <div style="text-align: center; width: 100%">
                                    <img id="<%# "DocsFile-" + Eval("id") %>" src="<%# (!string.IsNullOrEmpty(Eval("image").ToString()) ? Eval("image") : "/assets/uploads/noFile.png") + "?v=" + DateTime.Now.Ticks %>" style="width: 7em; border: 1px solid #c8c8c8; border-radius: 5px; margin-top: 10px;" />
                                </div>
                            </DataItemTemplate>
                            <CellStyle VerticalAlign="Middle">
                            </CellStyle>

                            <EditItemTemplate>
                                <div style="text-align: center; width: 90%">
                                    <img id="<%# "DocsFileLarge-" + Eval("id") %>" src="<%# (Eval("image") != null && Eval("image").ToString().Length > 1 ? Eval("image").ToString() : "/assets/uploads/noFile.png") + "?v=" + DateTime.Now.Ticks %>" style="width: 15em; border: 1px solid #c8c8c8; border-radius: 5px;" />
                                    <dx:ASPxUploadControl ID="poorImageUpload" runat="server" ClientInstanceName="poorImageUpload" FileUploadMode="OnPageLoad" Font-Names="Cairo" Font-Size="1em" OnFileUploadComplete="ImageUpload_FileUploadComplete" ShowProgressPanel="True" UploadMode="Auto" Width="100%" AutoStartUpload="True">
                                        <ValidationSettings AllowedFileExtensions=".jpg, .jpeg, .png, .bmp" GeneralErrorText="حدث خطأ أثناء تحميل الصور ، الرجاء المحاولة لاحقا" MaxFileSize="5048576" MaxFileSizeErrorText="حجم الصورة أكبر من 1 ميجابايت ، الرجاء اختيار صورة بحجم أقل" NotAllowedFileExtensionErrorText="امتداد الصورة غير مسموح به">
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

                        <dx:GridViewDataTextColumn Caption="" ShowInCustomizationForm="True" Width="100px">
                            <EditFormSettings Visible="False" />
                            <DataItemTemplate>
                                <div style="width: 100%; float: left; text-align: center">
                                    <img src="/assets/img/update.png" width="32" height="32" title="تعديل" style="cursor: pointer" onclick="setTimeout(function(){GridCategories.StartEditRow(MyIndex);},100);" />
                                    <img src="/assets/img/delete.png" width="32" height="32" title="حذف" style="cursor: pointer" onclick="onDeleteClick(<%# Container.VisibleIndex %>,'1');" />
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
                    <Images>
                        <DetailCollapsedButtonRtl ToolTip="إدخال المجموعات الفرعية" Url="~/assets/img/gridExpand.png" Width="35px">
                        </DetailCollapsedButtonRtl>
                        <DetailExpandedButtonRtl ToolTip="إغلاق وتحديث الجدول" Url="~/assets/img/gridCollapse.png" Width="35px">
                        </DetailExpandedButtonRtl>
                    </Images>
                    <Paddings Padding="2em" />
                </dx:ASPxGridView>

                <asp:SqlDataSource
                    ID="db_Categories"
                    runat="server"
                    ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>"
                    SelectCommand="SELECT [id], [name],[countryId],[companyId], [image], [itemCount], [nameEn] FROM [categories];"
                    InsertCommand="INSERT INTO [categories] ([name],[countryId],[companyId], [image], [itemCount], [nameEn], [userDate])
                   VALUES (@name,@countryId,@companyId, @image, @itemCount, @nameEn, getdate());"
                    UpdateCommand="UPDATE [categories]
                   SET [name]   = @name,
                       [image]  = @image,
                       [itemCount]  = @itemCount,
                       [countryId]  = @countryId,
                       [companyId]  = @companyId,
                       [nameEn] = @nameEn
                   WHERE [id] = @id;"
                    DeleteCommand="
                        DELETE FROM products WHERE categoryID = @id;
                        DELETE FROM categories WHERE id = @id;
                    ">
                    <InsertParameters>
                        <asp:Parameter Name="name" Type="String" />
                        <asp:Parameter Name="itemCount" Type="Int32" />
                        <asp:Parameter Name="nameEn" Type="String" />
                        <asp:Parameter Name="companyId" Type="String" />
                        <asp:Parameter Name="countryId" Type="String" />
                        <asp:ControlParameter ControlID="l_item_file" Name="image" PropertyName="Text" />
                    </InsertParameters>
                    <UpdateParameters>
                        <asp:Parameter Name="name" Type="String" />
                        <asp:Parameter Name="itemCount" Type="Int32" />
                        <asp:Parameter Name="nameEn" Type="String" />
                        <asp:Parameter Name="companyId" Type="String" />
                        <asp:Parameter Name="countryId" Type="String" />
                        <asp:Parameter Name="id" Type="Int32" />
                        <asp:ControlParameter ControlID="l_item_file" Name="image" PropertyName="Text" Type="String" />
                    </UpdateParameters>
                </asp:SqlDataSource>

                <asp:SqlDataSource ID="DB_CategoriesSub" runat="server" ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>" SelectCommand="select subName from categoriesSub where categoryId=@categoryId">
                    <SelectParameters>
                        <asp:Parameter Name="categoryId" />
                    </SelectParameters>
                </asp:SqlDataSource>

                <asp:SqlDataSource ID="DB_Countries" runat="server" ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>" SelectCommand="SELECT * FROM countries where id <> 1000"></asp:SqlDataSource>

                <asp:SqlDataSource ID="DB_Companies" runat="server" ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>"
                    SelectCommand="SELECT id,companyName FROM companies where id <> 1000"></asp:SqlDataSource>

                <asp:SqlDataSource ID="DB_Companies_Selected" runat="server" ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>"
                    SelectCommand="SELECT id,companyName FROM companies where id <> 1000 and countryId=@countryId">
                    <SelectParameters>
                        <asp:Parameter Name="countryId" />
                    </SelectParameters>
                </asp:SqlDataSource>


                <asp:SqlDataSource ID="DB_DetailCategoriesSub" runat="server" ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>"
                    SelectCommand="select id,subName from categoriesSub where categoryId=@categoryId"
                    DeleteCommand="delete from categoriesSub where id=@id"
                    InsertCommand="insert into categoriesSub (subName, categoryId) values (@subName, @categoryId)"
                    UpdateCommand="update categoriesSub set subName=@subName where id=@id">
                    <DeleteParameters>
                        <asp:Parameter Name="id" />
                    </DeleteParameters>
                    <InsertParameters>
                        <asp:Parameter Name="subName" />
                        <asp:SessionParameter Name="categoryId" SessionField="id" Type="Int32" />
                    </InsertParameters>
                    <SelectParameters>
                        <asp:SessionParameter Name="categoryId" SessionField="id" Type="Int32" />
                    </SelectParameters>
                    <UpdateParameters>
                        <asp:Parameter Name="subName" />
                        <asp:Parameter Name="id" />
                    </UpdateParameters>
                </asp:SqlDataSource>

                <dx:ASPxPopupControl runat="server" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter"
                    AutoUpdatePosition="True" Modal="True" ClientInstanceName="Pop_Del_Grids" CloseAnimationType="Slide"
                    FooterText="" HeaderText="" MinWidth="95%" MinHeight="95%" Width="350px" ID="Pop_Del_Grids">
                    <ContentCollection>
                        <dx:PopupControlContentControl runat="server">
                            <div style="padding: 20px; font-family: 'Cairo', sans-serif; text-align: right">

                                <div class="mb-3" style="width: 100%;">
                                    <dx:ASPxLabel runat="server" Text="تأكيد الحذف ؟" ClientInstanceName="labelCountries"
                                        Font-Names="Cairo" Font-Size="Medium" ForeColor="#333333" ID="labelCountries">
                                    </dx:ASPxLabel>
                                </div>
                                <div style="width: 50%; float: right; margin-top: 20px; text-align: right; font-family: 'Cairo', sans-serif;">
                                    <dx:ASPxButton ID="Btn_Del_Countries" runat="server" AutoPostBack="False" Text="حــــــــذف"
                                        UseSubmitBehavior="False" Font-Names="Cairo">
                                        <ClientSideEvents Click="function(s, e) { 
                                            var gridNum = Pop_Del_Grids.cpGridNo;
                                            delete Pop_Del_Grids.cpGridNo;
                                            GridCategories.DeleteRow(MyIndex); 
                                        Pop_Del_Grids.Hide();
                                    }" />
                                    </dx:ASPxButton>
                                </div>
                                <div style="width: 50%; float: left; margin-top: 20px; text-align: left; font-family: 'Cairo', sans-serif;">
                                    <dx:ASPxButton ID="Btn_Close_Countries" runat="server" AutoPostBack="False" Text="إغـــــــــــلاق"
                                        UseSubmitBehavior="False" Font-Names="Cairo">
                                        <ClientSideEvents Click="function(s, e) {Pop_Del_Grids.Hide();}" />
                                    </dx:ASPxButton>
                                </div>
                            </div>
                        </dx:PopupControlContentControl>
                    </ContentCollection>
                </dx:ASPxPopupControl>

                <dx:ASPxPopupControl runat="server" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" AutoUpdatePosition="True" Modal="True" ClientInstanceName="Pop_Del" CloseAnimationType="Slide" FooterText="" HeaderText="" MinWidth="95%" MinHeight="95%" Width="350px" ID="Pop_Del">
                    <ContentCollection>
                        <dx:PopupControlContentControl runat="server">

                            <div style="width: 100%;">
                                <dx:ASPxLabel runat="server" Text="تأكيد الحذف ؟" ClientInstanceName="TotalLabel" Font-Names="cairo" Font-Size="Medium" ForeColor="#333333" ID="labelSaved1"></dx:ASPxLabel>
                            </div>

                            <div style="width: 50%; float: right; margin-top: 20px; text-align: right">
                                <dx:ASPxButton ID="Btn_Del" runat="server" AutoPostBack="False" Text="حــــــــذف" UseSubmitBehavior="False" Font-Names="cairo">
                                    <ClientSideEvents Click="function(s, e) { setTimeout(function(){detailGrid.DeleteRow(MyIndexDetail);},100);Pop_Del.Hide();}" />
                                </dx:ASPxButton>
                            </div>

                            <div style="width: 50%; float: left; margin-top: 20px; text-align: left">
                                <dx:ASPxButton ID="Btn_Close" runat="server" AutoPostBack="False" Text="إغـــــــــــلاق" UseSubmitBehavior="False" Font-Names="cairo">
                                    <ClientSideEvents Click="function(s, e) {Pop_Del.Hide();}" />
                                </dx:ASPxButton>
                            </div>

                        </dx:PopupControlContentControl>
                    </ContentCollection>
                </dx:ASPxPopupControl>






                <dx:ASPxTextBox ID="l_item_file" runat="server" BackColor="Transparent" ClientInstanceName="l_item_file" Font-Size="0pt" ForeColor="Transparent" Text="" Width="0px" Theme="Default">
                    <Border BorderStyle="None" BorderWidth="0px" />
                </dx:ASPxTextBox>
                <dx:ASPxTextBox ID="l_item_file_old" runat="server" BackColor="Transparent" ClientInstanceName="l_item_file_old" Font-Size="0pt" ForeColor="Transparent" Text="" Width="0px" Theme="Default">
                    <Border BorderStyle="None" BorderWidth="0px" />
                </dx:ASPxTextBox>
                <dx:ASPxTextBox ID="l_item_file_check" runat="server" BackColor="Transparent" ClientInstanceName="l_item_file_check" Font-Size="0pt" ForeColor="Transparent" Text="0" Width="0px" Theme="Default">
                    <Border BorderStyle="None" BorderWidth="0px" />
                </dx:ASPxTextBox>
            </div>
        </main>

    

</asp:Content>
