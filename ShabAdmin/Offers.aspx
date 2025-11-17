<%@ Page Title="Branches" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Offers.aspx.cs" Inherits="ShabAdmin.Offers" %>

<%@ Register Assembly="DevExpress.Web.v24.1, Version=24.1.6.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">


    <main>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/lottie-web/5.12.0/lottie.min.js"></script>

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

            .cancel-offer-btn {
                background-color: #e74c3c;
                color: white;
                border: none;
                border-radius: 6px;
                padding: 6px 12px;
                font-family: 'Cairo', sans-serif;
                cursor: pointer;
            }

                .cancel-offer-btn:hover {
                    background-color: #c0392b;
                }

            .no-offer-label {
                color: gray;
                font-weight: bold;
                font-family: 'Cairo', sans-serif;
            }
        </style>
        <script>
            var MyId;
            var MyIndex;
            var MyIndexDetail;
            var selectedCompanyId;
            var selectedCountryId;
            var checkBoxValue;

            var MyPrice;
            var MyPercent;

            function OnRowClick(e) {
                MyIndex = e.visibleIndex;
                GridOffers.GetRowValues(MyIndex, 'id;price;offerPercent', OnGetRowValues);
            }

            function OnGetRowValues(Value) {
                MyId = Value[0];
                MyPrice = Value[1];
                MyPercent = Value[2];
            }

            function OnRowClickOffers(e) {
                MyIndex = e.visibleIndex;
                GridMainOffers.GetRowValues(e.visibleIndex, 'id;offerImage', OnGetRowValuesOffers);
            }

            function OnGetRowValuesOffers(Value) {
                MyId = Value[0];
                l_item_file.SetText(Value[1]);
                l_item_file_old.SetText(Value[1]);
            }

            function calcPercent(s, e) {
                var editCell = GridOffers.batchEditApi.GetEditCellInfo();
                if (!editCell) return;

                var rowIndex = editCell.rowVisibleIndex;

                var basePrice = parseFloat(MyPrice) || 0;
                var offerPrice = parseFloat(s.GetValue()) || 0;

                if (basePrice <= 0) return;

                if (offerPrice > basePrice) {
                    offerPrice = basePrice;
                    s.SetValue(basePrice);
                }

                var percent = ((basePrice - offerPrice) / basePrice) * 100;
                percent = Math.round(percent); // رقم صحيح دائمًا

                GridOffers.batchEditApi.SetCellValue(rowIndex, "offerPercent", percent);
            }

            function calcPrices(s, e) {
                var editCell = GridOffers.batchEditApi.GetEditCellInfo();
                if (!editCell) return;

                var rowIndex = editCell.rowVisibleIndex;

                var basePrice = parseFloat(MyPrice) || 0;
                var percent = parseFloat(s.GetValue()) || 0;

                if (basePrice <= 0) return;

                if (percent < 0) percent = 0;
                if (percent > 100) percent = 100;

                var offerPrice = basePrice - (basePrice * percent / 100);
                offerPrice = Math.round(offerPrice * 100) / 100;

                if (offerPrice > basePrice) offerPrice = basePrice;

                GridOffers.batchEditApi.SetCellValue(rowIndex, "offerPrice", offerPrice);
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
            }

            function typeCombo_SelectedIndexChanged(s, e) {
                var countryEditor = GridMainOffers.GetEditor("countryId");
                var companyEditor = GridMainOffers.GetEditor("companyId");
                var offerEditor = GridMainOffers.GetEditor("l_offerId");
                var itemEditor = GridMainOffers.GetEditor("itemId");

                if (countryEditor && offerEditor && itemEditor) {
                    var countryId = countryEditor.GetValue();
                    var companyId = companyEditor.GetValue();
                    var offerId = offerEditor.GetValue();
                    itemEditor.PerformCallback(offerId + "|" + countryId + "|" + companyId);
                    if (offerId == 3)
                        ItemCombo.SetVisible(false);
                    else
                        ItemCombo.SetVisible(true);
                }

            }

            function OnCountryChanged(s, e) {
                if (typeof L_OfferCombo !== 'undefined') {
                    L_OfferCombo.SetSelectedIndex(-1);
                }
                if (typeof ItemCombo !== 'undefined') {
                    ItemCombo.SetSelectedIndex(-1);
                }

                var countryEditor = GridMainOffers.GetEditor("countryId");
                var companyEditor = GridMainOffers.GetEditor("companyId");

                if (countryEditor && companyEditor) {
                    var countryId = countryEditor.GetValue();
                    companyEditor.PerformCallback(0 + "|" + countryId)
                }
            }

            function OnCompanyChanged(s, e) {

            }

            function onDeleteClick(visibleIndex) {
                Pop_Del_Grids.Show();
            }
            function OnGridBeginCallback(s, e) {
                s.cpShowPopup = null;

                if (e.command == 'STARTEDIT') {

                    setTimeout(function () {
                        var offerEditor = GridMainOffers.GetEditor("l_offerId");
                        var offerId = offerEditor.GetValue();
                        if (offerId == 3)
                            ItemCombo.SetVisible(false);
                        else
                            ItemCombo.SetVisible(true);
                    }, 700);

                    l_item_file_check.SetText('0');
                }
                if (e.command == 'ADDNEWROW') {
                    MyId = 0;
                    l_item_file.SetText('');
                    l_item_file_old.SetText('');
                }
                if (e.command == 'UPDATEEDIT') {
                    var offerId = GridMainOffers.GetEditor("l_offerId").GetValue();
                    if (offerId == 3)
                        ItemCombo.SetVisible(false);
                    else
                        ItemCombo.SetVisible(true);
                    //Your code here when the Update button is clicked  
                }
                if (e.command == 'DELETEROW') {
                    //Your code here when the Delete button is clicked  
                }
                //and so on...  
            }
            function OnGridBeginCallback1(s, e) {
            }

            function GridMainOffers_EndCallback1(s, e) {
                if (s.cpShowPopup === "true") {
                    popupOfferTypeExists.Show();
                }
            }
            function OnGridOffersEndCallback(s, e) {
                if (s.cp_CancelUpdate === "true") {
                    delete s.cp_CancelUpdate;
                    popupWarning.Show(); // Make sure popupWarning is your DevExpress PopupControl
                }
                // Check if we need to show the result popup
                if (s.cp_ShowResultPopup) {
                    // Update the message text if provided
                    if (s.cp_ResultMessage) {
                        document.getElementById('resultMessageText').innerText = s.cp_ResultMessage;
                    }

                    // Show the result popup
                    popupResult.Show();

                    // Clear the properties
                    s.cp_ShowResultPopup = null;
                    s.cp_ResultMessage = null;

                    // Refresh the grid to show updated data
                    setTimeout(function () {
                        GridOffers.Refresh();
                    }, 500);
                }
            }
            function InitDangerAnimation(s, e) {
                lottie.loadAnimation({
                    container: document.getElementById('dangerAnimation'),
                    renderer: 'svg',
                    loop: true,
                    autoplay: true,
                    path: '/assets/animations/danger.json' // تأكد أن هذا المسار صحيح
                });
            }
            function onTabChanged(s) {
                var idx = s.GetActiveTabIndex(); // 0-based
                if (idx === 1 || idx === 2) {
                    cbCheckPrivileges.PerformCallback();
                }
            }

            function onSaveCustomClick(s, e) {
                // Check if there are any pending changes
                if (GridOffers.batchEditApi.HasChanges()) {
                    popupConfirmSave.Show();
                }
            }

            // إلغاء التعديلات
            function onCancelCustomClick(s, e) {
                if (GridOffers.batchEditApi.HasChanges()) {
                    GridOffers.CancelEdit();
                }

                document.querySelector('.statusbar-buttons').style.display = 'none';
            }

            var selectedProductId = 0;

            function showCancelOfferPopup(productId) {
                selectedProductId = productId;
                document.getElementById('<%= hfSelectedProductId.ClientID %>').value = productId;
                PopupCancelOffer.Show();
            }

            function confirmCancelOffer() {
                if (selectedProductId > 0) {
                    PopupCancelOffer.Hide();
                    GridOffers.PerformCallback(selectedProductId);
                }
            }

            function onBatchEditStart(s, e) {
                document.querySelector('.statusbar-buttons').style.display = 'flex';
            }

            function onBatchEditEnd(s, e) {
                document.querySelector('.statusbar-buttons').style.display = 'none';
            }

            window.addEventListener('DOMContentLoaded', function () {
                const bar = document.querySelector('.statusbar-buttons');
                if (bar) bar.style.display = 'none';
            });

        </script>

        <div class="w-100 text-center my-4">
            <h2 class="pageTitle d-inline-block" style="font-family: Cairo">العـــــروض</h2>
        </div>
        <dx:ASPxPageControl ID="pageTab" runat="server" CssClass="divSTARProviders" ActiveTabIndex="0" ClientInstanceName="pageTab" Theme="Material" Width="100%" EnableCallbackAnimation="True">
            <ClientSideEvents ActiveTabChanged="onTabChanged" />
            <TabPages>
                <dx:TabPage Text="العروض الرئيسية" TabStyle-Font-Bold="true" TabStyle-Font-Names="cairo" TabStyle-Font-Size="X-Large">
                    <TabStyle Font-Bold="True" Font-Names="cairo" Font-Size="X-Large"></TabStyle>
                    <ContentCollection>
                        <dx:ContentControl runat="server">

                            <div style="margin: 0 auto; font-size: 1.3em; font-family: cairo; color: #c78d65; margin-bottom: 1em">هذه العروض تظهر على الصفحة الرئيسية للتطبيق (مستطيل كبير أعلى الصفحة)</div>

                            <dx:ASPxGridView ID="GridMainOffers" runat="server" DataSourceID="db_MainOffers" KeyFieldName="id" ClientInstanceName="GridMainOffers" Width="100%" AutoGenerateColumns="False" EnablePagingCallbackAnimation="True" OnCellEditorInitialize="Grid_Association_CellEditorInitialize"
                                Font-Names="cairo" RightToLeft="True"
                                OnCancelRowEditing="GridMainOffers_CancelRowEditing" OnRowUpdated="GridMainOffers_RowUpdated" OnRowDeleting="GridMainOffers_RowDeleting" Font-Size="Large" OnRowUpdating="GridMainOffers_RowUpdating">
                                <Settings ShowFooter="True" ShowFilterRow="True" />


                                <ClientSideEvents BeginCallback="OnGridBeginCallback" EndCallback="GridMainOffers_EndCallback1" RowClick="function(s, e) {OnRowClickOffers(e);}" RowDblClick="function(s, e) {setTimeout(function(){GridMainOffers.StartEditRow(MyIndex);},100);}" />

                                <SettingsAdaptivity AdaptivityMode="HideDataCells">
                                </SettingsAdaptivity>
                                <Settings ShowFilterRow="True" ShowFilterRowMenu="False" ShowHeaderFilterButton="False" AutoFilterCondition="Contains" />

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
                                <SettingsText SearchPanelEditorNullText="ابحث في الجدول..." EmptyDataRow="لا يوجد" CommandBatchEditPreviewChanges="التغييرات" />
                                <Columns>

                                    <dx:GridViewDataColumn Caption="الرقم" FieldName="id" VisibleIndex="0" Width="1%">
                                        <EditFormSettings Visible="False" />
                                        <CellStyle VerticalAlign="Middle" HorizontalAlign="Center">
                                        </CellStyle>
                                    </dx:GridViewDataColumn>


                                    <dx:GridViewDataComboBoxColumn Caption="الدولة" FieldName="countryId">
                                        <PropertiesComboBox
                                            DataSourceID="dsCountries"
                                            TextField="countryName"
                                            ValueField="id"
                                            ValueType="System.Int32"
                                            ClientInstanceName="CountryComboo">
                                            <ClientSideEvents SelectedIndexChanged="OnCountryChanged" />
                                            <ItemStyle Font-Size="1.5em" />
                                            <ValidationSettings
                                                RequiredField-IsRequired="true"
                                                ErrorText="يجب اختيار الدولة"
                                                SetFocusOnError="True"
                                                Display="Dynamic">
                                                <RequiredField IsRequired="True" />
                                            </ValidationSettings>
                                        </PropertiesComboBox>
                                        <CellStyle VerticalAlign="Middle" HorizontalAlign="Center" />
                                    </dx:GridViewDataComboBoxColumn>


                                    <dx:GridViewDataComboBoxColumn Caption="الشركة" FieldName="companyId">
                                        <PropertiesComboBox
                                            DataSourceID="dsCompanies"
                                            TextField="companyName"
                                            ValueField="id"
                                            ValueType="System.Int32"
                                            ClientInstanceName="CompanyComboo">
                                            <ClientSideEvents SelectedIndexChanged="OnCompanyChanged" />
                                            <ItemStyle Font-Size="1.5em" />
                                            <ValidationSettings
                                                RequiredField-IsRequired="true"
                                                ErrorText="يجب اختيار الدولة"
                                                SetFocusOnError="True"
                                                Display="Dynamic">
                                                <RequiredField IsRequired="True" />
                                            </ValidationSettings>
                                        </PropertiesComboBox>
                                        <CellStyle VerticalAlign="Middle" HorizontalAlign="Center" />
                                    </dx:GridViewDataComboBoxColumn>


                                    <dx:GridViewDataComboBoxColumn Caption="النوع" FieldName="l_offerId">
                                        <PropertiesComboBox
                                            DataSourceID="ds_L_Offers"
                                            TextField="description"
                                            ValueField="id"
                                            ClientInstanceName="L_OfferCombo"
                                            ValueType="System.Int32">
                                            <ClientSideEvents SelectedIndexChanged="typeCombo_SelectedIndexChanged" />
                                            <ItemStyle Font-Size="1.5em" />
                                            <ValidationSettings
                                                RequiredField-IsRequired="true"
                                                ErrorText="يجب اختيار النوع"
                                                SetFocusOnError="True"
                                                Display="Dynamic">
                                                <RequiredField IsRequired="True" />
                                            </ValidationSettings>
                                        </PropertiesComboBox>
                                        <CellStyle VerticalAlign="Middle" HorizontalAlign="Center" />
                                    </dx:GridViewDataComboBoxColumn>


                                    <dx:GridViewDataComboBoxColumn Caption="اسم البند" FieldName="itemId">
                                        <PropertiesComboBox
                                            DataSourceID="dsItems"
                                            TextField="itemName"
                                            ValueField="id"
                                            ClientInstanceName="ItemCombo"
                                            ValueType="System.Int32">
                                            <ItemStyle Font-Size="1.5em" />
                                        </PropertiesComboBox>
                                        <CellStyle VerticalAlign="Middle" HorizontalAlign="Center" />
                                    </dx:GridViewDataComboBoxColumn>


                                    <dx:GridViewDataComboBoxColumn Caption="طريقة العرض" FieldName="l_offerType" Name="gridCategoryColumn">
                                        <PropertiesComboBox
                                            DataSourceID="db_OfferType"
                                            ValueField="id"
                                            TextField="description"
                                            ValueType="System.Int32">
                                            <ValidationSettings
                                                RequiredField-IsRequired="true"
                                                SetFocusOnError="True"
                                                ErrorText="يجب اختيار الطريقة"
                                                Display="Dynamic">
                                                <RequiredField IsRequired="True" />
                                            </ValidationSettings>
                                        </PropertiesComboBox>

                                        <DataItemTemplate>
                                            <div style="text-align: center; width: 100%">
                                                <img src="<%# Eval("l_offerType").ToString() == "1" ? "/assets/img/productSlider.png" :"/assets/img/productPopup.png" %>" style="width: 9em;" />
                                                <br />
                                                <%# Eval("l_offerType").ToString() == "1" ? "شريط متزحلق" : "نافذة منبثقة" %>
                                            </div>
                                        </DataItemTemplate>

                                        <EditFormSettings Visible="True" />
                                        <CellStyle VerticalAlign="Middle" HorizontalAlign="Center" />
                                    </dx:GridViewDataComboBoxColumn>

                                    <dx:GridViewDataSpinEditColumn Caption="الترتيب" FieldName="position">
                                        <PropertiesSpinEdit DisplayFormatString="g" Increment="1" LargeIncrement="1" MinValue="1" MaxValue="100">
                                            <ValidationSettings
                                                RequiredField-IsRequired="true"
                                                ErrorText="الرجاء إدخال الترتيب"
                                                Display="Dynamic">
                                                <RequiredField IsRequired="true" />
                                            </ValidationSettings>
                                        </PropertiesSpinEdit>
                                        <DataItemTemplate>
                                            <div style="text-align: center; width: 100%">
                                                <%# Convert.ToInt32(Eval("position")) == 0 ? "--" : Eval("position") %>
                                            </div>
                                        </DataItemTemplate>
                                        <CellStyle VerticalAlign="Middle" HorizontalAlign="Center" Font-Bold="true"
                                            Font-Size="7em" ForeColor="#009933" />
                                    </dx:GridViewDataSpinEditColumn>

                                    <dx:GridViewDataColumn Caption="الصورة" FieldName="offerImage" EditFormSettings-VisibleIndex="1" EditFormSettings-Caption=" ">
                                        <EditFormSettings RowSpan="12" VisibleIndex="1" Caption=" "></EditFormSettings>
                                        <DataItemTemplate>
                                            <div style="text-align: center; width: 100%">
                                                <img id="<%# "DocsFile-" + Eval("id") %>" src="<%# (!string.IsNullOrEmpty(Eval("offerImage").ToString()) ? Eval("offerImage") : "/assets/uploads/noFile.png") + "?v=" + DateTime.Now.Ticks %>" style="width: 20em; border: 1px solid #c8c8c8; border-radius: 5px;" />
                                            </div>
                                        </DataItemTemplate>
                                        <CellStyle VerticalAlign="Middle">
                                        </CellStyle>
                                        <EditItemTemplate>
                                            <div style="text-align: center; width: 90%">
                                                <img id="<%# "DocsFileLarge-" + Eval("id") %>" src="<%# (Eval("offerImage") != null && Eval("offerImage").ToString().Length > 1 ? Eval("offerImage").ToString() : "/assets/uploads/noFile.png") + "?v=" + DateTime.Now.Ticks %>" style="width: 15em; border: 1px solid #c8c8c8; border-radius: 5px;" />
                                                <dx:ASPxUploadControl ID="poorImageUpload" runat="server" ClientInstanceName="poorImageUpload" FileUploadMode="OnPageLoad" Font-Names="Cairo" Font-Size="1em" OnFileUploadComplete="ImageUpload_FileUploadComplete" ShowProgressPanel="True" UploadMode="Auto" Width="100%" AutoStartUpload="True">
                                                    <ValidationSettings AllowedFileExtensions=".jpg, .jpeg, .png, .bmp" GeneralErrorText="حدث خطأ أثناء تحميل الصور ، الرجاء المحاولة لاحقا" MaxFileSize="5048576" MaxFileSizeErrorText="حجم الصورة أكبر من 1 ميجابايت ، الرجاء اختيار صورة بحجم أقل" NotAllowedFileExtensionErrorText="امتداد الصورة غير مسموح به">
                                                    </ValidationSettings>
                                                    <ClientSideEvents FileUploadComplete="onFileUploadComplete" />
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
                                                <img src="/assets/img/update.png" width="32" height="32" title="تعديل"
                                                    style="cursor: pointer"
                                                    onclick="setTimeout(function(){GridMainOffers.StartEditRow(MyIndex);},100);" />
                                                <img src="/assets/img/delete.png" width="32" height="32" title="حذف" style="cursor: pointer" onclick="setTimeout(function(){onDeleteClick(<%# Container.VisibleIndex %>);},100);" />
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
                                <Paddings Padding="2em" />
                            </dx:ASPxGridView>

                            <asp:SqlDataSource
                                ID="db_MainOffers"
                                runat="server"
                                ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>"
                                SelectCommand="
                                            SELECT 
                                                p.[id], 
                                                p.[countryId], 
                                                p.[offerImage], 
                                                p.[l_offerId], 
                                                p.[companyId], 
                                                p.[itemId],
                                                p.[position],
                                                p.[l_offerType]
                                            FROM [mainOffers] p order by p.position asc, p.l_offerType desc"
                                InsertCommand="insert into mainOffers (countryId,companyId,offerImage,l_offerId,itemId,l_offerType,position,userDate) VALUES (@countryId,@companyId,@offerImage,@l_offerId,@itemId,@l_offerType,@position,getdate())"
                                UpdateCommand="UPDATE mainOffers set countryId=@countryId,companyId=@companyId,offerImage=@offerImage,l_offerId=@l_offerId,itemId=@itemId,l_offerType=@l_offerType,position=@position where id=@id"
                                DeleteCommand="delete from mainOffers where id=@id">
                                <InsertParameters>
                                    <asp:Parameter Name="l_offerType" Type="String" />
                                    <asp:Parameter Name="l_offerId" Type="String" />
                                    <asp:Parameter Name="companyId" Type="String" />
                                    <asp:ControlParameter ControlID="l_item_file" Name="offerImage" PropertyName="Text" />
                                    <asp:Parameter Name="countryID" Type="String" />
                                    <asp:Parameter Name="position" Type="String" />
                                    <asp:Parameter Name="itemId" Type="String" />
                                </InsertParameters>
                                <UpdateParameters>
                                    <asp:Parameter Name="l_offerType" Type="String" />
                                    <asp:Parameter Name="l_offerId" Type="String" />
                                    <asp:Parameter Name="companyId" Type="String" />
                                    <asp:ControlParameter ControlID="l_item_file" Name="offerImage" PropertyName="Text" />
                                    <asp:Parameter Name="countryID" Type="String" />
                                    <asp:Parameter Name="position" Type="String" />
                                    <asp:Parameter Name="itemId" Type="String" />
                                    <asp:Parameter Name="id" Type="Int32" />
                                </UpdateParameters>
                                <DeleteParameters>
                                    <asp:Parameter Name="id" Type="Int32" />
                                </DeleteParameters>
                            </asp:SqlDataSource>

                            <asp:SqlDataSource
                                ID="dsCountries"
                                runat="server"
                                ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>"
                                SelectCommand="SELECT id, countryName FROM countries where id <> 1000"></asp:SqlDataSource>

                            <asp:SqlDataSource
                                ID="dsCompanies"
                                runat="server"
                                ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>"
                                SelectCommand="SELECT id, companyName FROM companies WHERE id <> 1000"></asp:SqlDataSource>


                            <asp:SqlDataSource
                                ID="db_OfferType"
                                runat="server"
                                ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>"
                                SelectCommand="SELECT id, description FROM L_OffersType"></asp:SqlDataSource>

                            <asp:SqlDataSource
                                ID="ds_L_Offers"
                                runat="server"
                                ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>"
                                SelectCommand="SELECT id, description FROM L_Offers"></asp:SqlDataSource>
                            <asp:SqlDataSource
                                ID="dsItems"
                                runat="server"
                                ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>"
                                SelectCommand="SELECT id, Name AS itemName FROM products
                                                       UNION
                                                       SELECT id, Name AS itemName FROM categories"></asp:SqlDataSource>



                            <asp:SqlDataSource
                                ID="DB_Companies1"
                                runat="server"
                                ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>"
                                SelectCommand="SELECT id, companyName FROM companies WHERE countryId=@countryId">
                                <SelectParameters>
                                    <asp:Parameter Name="countryId" />
                                </SelectParameters>
                            </asp:SqlDataSource>

                            <asp:SqlDataSource ID="DB_L_Item_selected1" runat="server" ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>" SelectCommand="SELECT id ,name as itemName FROM products where countryId=@countryId AND companyId=@companyId">
                                <SelectParameters>
                                    <asp:Parameter Name="countryId" />
                                    <asp:Parameter Name="companyId" />
                                </SelectParameters>
                            </asp:SqlDataSource>

                            <asp:SqlDataSource ID="DB_L_Item_selected2" runat="server" ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>" SelectCommand="SELECT id ,name as itemName FROM categories where countryId=@countryId AND companyId=@companyId">
                                <SelectParameters>
                                    <asp:Parameter Name="countryId" />
                                    <asp:Parameter Name="companyId" />
                                </SelectParameters>
                            </asp:SqlDataSource>

                            <dx:ASPxTextBox ID="l_item_file" runat="server" BackColor="Transparent" ClientInstanceName="l_item_file" Font-Size="0pt" ForeColor="Transparent" Text="" Width="0px" Theme="Default">
                                <Border BorderStyle="None" BorderWidth="0px" />
                            </dx:ASPxTextBox>
                            <dx:ASPxTextBox ID="l_item_file_old" runat="server" BackColor="Transparent" ClientInstanceName="l_item_file_old" Font-Size="0pt" ForeColor="Transparent" Text="" Width="0px" Theme="Default">
                                <Border BorderStyle="None" BorderWidth="0px" />
                            </dx:ASPxTextBox>
                            <dx:ASPxTextBox ID="l_item_file_check" runat="server" BackColor="Transparent" ClientInstanceName="l_item_file_check" Font-Size="0pt" ForeColor="Transparent" Text="0" Width="0px" Theme="Default">
                                <Border BorderStyle="None" BorderWidth="0px" />
                            </dx:ASPxTextBox>

                            <dx:ASPxPopupControl runat="server" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter"
                                AutoUpdatePosition="True" Modal="True" ClientInstanceName="Pop_Del_Grids" CloseAnimationType="Slide"
                                FooterText="" HeaderText="حذف فرع" Font-Names="Cairo" MinWidth="350px" MinHeight="150px" Width="350px" Height="150px" ID="Pop_Del_Grids">
                                <ContentCollection>
                                    <dx:PopupControlContentControl runat="server">
                                        <div style="padding: 20px; font-family: 'Cairo', sans-serif; text-align: right">
                                            <div class="mb-3" style="width: 100%;">
                                                <dx:ASPxLabel runat="server" Text="هل أنت متأكد من حذف العرض؟" ClientInstanceName="labelBranches"
                                                    Font-Names="Cairo" Font-Size="Medium" ForeColor="#333333" ID="labelBranches">
                                                </dx:ASPxLabel>
                                            </div>
                                            <div style="width: 100%; margin-top: 20px; text-align: center;">
                                                <dx:ASPxButton ID="Btn_Del_Branches" runat="server" AutoPostBack="False" Text="حــــــــذف"
                                                    UseSubmitBehavior="False" Font-Names="Cairo" HorizontalAlign="Center" VerticalAlign="Middle">
                                                    <ClientSideEvents Click="function(s, e) { 
                                                              GridMainOffers.DeleteRow(MyIndex); 
                                                              setTimeout(function() { GridMainOffers.Refresh(); }, 200);
                                                              Pop_Del_Grids.Hide();
                                                          }" />
                                                </dx:ASPxButton>

                                                <dx:ASPxButton ID="Btn_Close_Branches" runat="server" AutoPostBack="False" Text="إغـــــــــــلاق"
                                                    UseSubmitBehavior="False" Font-Names="Cairo" HorizontalAlign="Center" VerticalAlign="Middle"
                                                    Style="margin-right: 20px;">
                                                    <ClientSideEvents Click="function(s, e) {Pop_Del_Grids.Hide();}" />
                                                </dx:ASPxButton>
                                            </div>
                                        </div>
                                    </dx:PopupControlContentControl>
                                </ContentCollection>
                            </dx:ASPxPopupControl>

                            <dx:ASPxPopupControl ID="popupOfferTypeExists" runat="server"
                                ClientInstanceName="popupOfferTypeExists"
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
                                                لا يمكن الحفظ لأن هناك عرضاً آخر في نفس الدولة تم تعيينه كـ <b>نافذة منبثقة</b>.<br />
                                                <br />
                                                يُسمح بعرض واحد فقط كنافذة منبثقة لكل دولة.
               
                                            </div>
                                        </div>
                                    </dx:PopupControlContentControl>
                                </ContentCollection>
                            </dx:ASPxPopupControl>



                        </dx:ContentControl>
                    </ContentCollection>
                </dx:TabPage>

                <dx:TabPage Text="عروض المنتجات" TabStyle-Font-Bold="true" TabStyle-Font-Names="cairo" TabStyle-Font-Size="X-Large">
                    <TabStyle Font-Bold="True" Font-Names="cairo" Font-Size="X-Large"></TabStyle>
                    <ContentCollection>
                        <dx:ContentControl runat="server">
                            <div class="navbar-main navbar-expand-lg px-0 mx-4 border-radius-xl bg-white shadow mt-3 mb-1">
                                <div style="margin: 0 auto; text-align: center; width: 100%; padding: 1em">

                                    <div style="float: left; width: 30%; padding: 1em">

                                        <dx:ASPxButton ID="AllOffers" Width="100%" CssClass="top" Height="74px" runat="server" Text="إظهار كامل العروض" AutoPostBack="False" CausesValidation="False" UseSubmitBehavior="False" Font-Bold="True" Font-Size="XX-Large" Font-Names="cairo">
                                            <ClientSideEvents Click="function(s, e){ showAllOffers.SetText('100'); GridOffers.PerformCallback(); }" />
                                            <Border BorderColor="Silver" BorderStyle="Solid" BorderWidth="2px" />
                                        </dx:ASPxButton>

                                        <dx:ASPxHint ID="hintTop" runat="server" TargetSelector=".top" Position="Top" Content="إظهار كامل العروض لجميع المنتجات لكامل الدول، ويمكن فلترة النتائج حسب حقل البحث والدولة أيضا" AppearAfter="1" CssClass="hintClass" Title="تعليمات" TriggerAction="HoverAndFocus" Width="400px" />
                                    </div>
                                    <div style="float: left; width: 30%; padding: 1em">

                                        <dx:ASPxComboBox ID="countryList" runat="server" Font-Names="cairo" Width="100%" TextField="countryName" ValueField="id" Font-Bold="True" Font-Size="XX-Large" ClientInstanceName="countryList" DataSourceID="DB_L_countries" NullText="اختار الدولة">
                                            <ClientSideEvents ValueChanged="function(s, e) {
                                                    GridOffers.PerformCallback('country');
                                                }" />
                                        </dx:ASPxComboBox>

                                    </div>
                                    <div style="float: left; width: 30%; padding: 1em">

                                        <dx:ASPxTextBox ID="searchGrid" ClientInstanceName="searchGrid" NullText="ابحث عن المنتجات..." runat="server" Width="100%" Font-Bold="True" Font-Names="cairo" Font-Size="XX-Large">
                                            <ClientSideEvents KeyUp="function(s, e) { 
                                                setTimeout(function () {
                                                    GridOffers.Refresh();
                                                }, 500); }" />
                                        </dx:ASPxTextBox>

                                    </div>

                                    <div style="float: right; width: 10%; padding: 1em">

                                        <dx:ASPxButton ID="cleatAll" Width="100%" Height="74px" runat="server" Text="مسح" AutoPostBack="False" CausesValidation="False" UseSubmitBehavior="False" Font-Bold="True" Font-Size="Large" Font-Names="cairo" ImagePosition="Top">
                                            <ClientSideEvents Click="function(s, e){ showAllOffers.SetText(''); countryList.SetSelectedIndex(-1); searchGrid.SetText(''); GridOffers.Refresh();  }" />
                                            <Image Url="~/assets/img/cancel.png">
                                            </Image>
                                            <BackgroundImage ImageUrl="~/assets/img/back.png" />
                                        </dx:ASPxButton>

                                    </div>

                                </div>


                                <dx:ASPxGridView ID="GridOffers" runat="server" DataSourceID="db_Offers" KeyFieldName="id" ClientInstanceName="GridOffers" Width="100%" AutoGenerateColumns="False" EnablePagingCallbackAnimation="True" Font-Names="cairo" RightToLeft="True" OnCustomCallback="GridOffers_CustomCallback" Font-Size="Large" OnBatchUpdate="GridOffers_BatchUpdate" OnBeforePerformDataSelect="GridOffers_BeforePerformDataSelect">
                                    <SettingsEditing Mode="Batch">
                                    </SettingsEditing>
                                    <Settings ShowFooter="True" ShowFilterRow="True" />

                                    <ClientSideEvents EndCallback="OnGridOffersEndCallback" RowClick="function(s, e) {OnRowClick(e);}"
                                        RowDblClick="function(s, e) {setTimeout(function(){GridOffers.StartEditRow(MyIndex);},100);}"
                                        BatchEditStartEditing="onBatchEditStart"/>

                                    <SettingsAdaptivity AdaptivityMode="HideDataCells">
                                    </SettingsAdaptivity>
                                    <Settings ShowFilterRow="True" ShowFilterRowMenu="False" ShowHeaderFilterButton="False" AutoFilterCondition="Contains" />

                                    <Templates>
                                        <StatusBar>
                                            <div class="statusbar-buttons" style="display: none; gap: 10px; align-items: center; justify-content: center;">
                                                <dx:ASPxButton ID="btnSaveCustom" runat="server" Text="حفظ"
                                                    ClientInstanceName="btnSaveCustom" Font-Names="Cairo" AutoPostBack="False"
                                                    Theme="Moderno">
                                                    <ClientSideEvents Click="onSaveCustomClick" />
                                                    <Image Url="~/assets/img/save.png" />
                                                </dx:ASPxButton>

                                                <dx:ASPxButton ID="btnCancelCustom" runat="server" Text="إلغاء"
                                                    ClientInstanceName="btnCancelCustom" Font-Names="Cairo" AutoPostBack="False"
                                                    Theme="Moderno">
                                                    <ClientSideEvents Click="onCancelCustomClick" />
                                                    <Image Url="~/assets/img/cancel.png" />
                                                </dx:ASPxButton>
                                            </div>
                                        </StatusBar>
                                    </Templates>


                                    <SettingsPopup>
                                        <FilterControl AutoUpdatePosition="False"></FilterControl>
                                    </SettingsPopup>

                                    <SettingsSearchPanel CustomEditorID="tbToolbarSearch1" />

                                    <SettingsExport EnableClientSideExportAPI="true" ExcelExportMode="WYSIWYG" PaperKind="A4" RightToLeft="True" />
                                    <SettingsLoadingPanel Text="Please Wait &amp;hellip;" Mode="ShowAsPopup" />
                                    <SettingsText SearchPanelEditorNullText="ابحث في الجدول..." EmptyDataRow="لا يوجد" CommandBatchEditPreviewChanges="التغييرات" />
                                    <Columns>
                                        <dx:GridViewDataColumn Caption="الرقم" FieldName="id" Width="1%">
                                            <EditFormSettings Visible="False" />
                                            <CellStyle VerticalAlign="Middle" HorizontalAlign="Center">
                                            </CellStyle>
                                        </dx:GridViewDataColumn>

                                        <dx:GridViewDataComboBoxColumn Caption="الدولة" FieldName="countryId" Width="7%">
                                            <PropertiesComboBox DataSourceID="DB_L_countries" TextField="countryName" ValueField="id" ValueType="System.Int32">
                                            </PropertiesComboBox>
                                            <EditFormSettings Visible="False" />
                                            <CellStyle VerticalAlign="Middle">
                                            </CellStyle>
                                        </dx:GridViewDataComboBoxColumn>

                                        <dx:GridViewDataTextColumn Caption="الصورة" FieldName="image">
                                            <DataItemTemplate>
                                                <div style="text-align: center; width: 100%">
                                                    <img src="<%# Eval("image") + "?v=" + DateTime.Now.Ticks %>" style="width: 7em; border: 1px solid #c8c8c8; border-radius: 5px; margin-top: 10px;" />
                                                </div>
                                            </DataItemTemplate>
                                            <EditFormSettings Visible="False" />
                                            <CellStyle VerticalAlign="Middle" HorizontalAlign="Center">
                                            </CellStyle>
                                        </dx:GridViewDataTextColumn>

                                        <dx:GridViewDataTextColumn Caption="الإسم" FieldName="name">
                                            <EditFormSettings Visible="False" />
                                            <CellStyle VerticalAlign="Middle" HorizontalAlign="Center">
                                            </CellStyle>
                                        </dx:GridViewDataTextColumn>

                                        <dx:GridViewDataTextColumn Caption="السعر" FieldName="price">
                                            <EditFormSettings Visible="False" />
                                            <CellStyle VerticalAlign="Middle" HorizontalAlign="Center" Font-Size="XX-Large">
                                            </CellStyle>
                                        </dx:GridViewDataTextColumn>

                                        <dx:GridViewDataSpinEditColumn Caption="سعر العرض" FieldName="offerPrice">
                                            <PropertiesSpinEdit DisplayFormatString="g" Increment="0.1" LargeIncrement="1">
                                                <ClientSideEvents ValueChanged="function(s, e) {
                         calcPercent(s, e);
                     }" />
                                            </PropertiesSpinEdit>
                                            <CellStyle Font-Size="XX-Large" HorizontalAlign="Center" VerticalAlign="Middle" Font-Bold="true">
                                                <BackgroundImage ImageUrl="~/assets/img/back.png" />
                                                <Border BorderColor="#999999" BorderStyle="Solid" BorderWidth="1px" />
                                            </CellStyle>
                                        </dx:GridViewDataSpinEditColumn>

                                        <dx:GridViewDataSpinEditColumn Caption="نسبة الخصم" FieldName="offerPercent">
                                            <PropertiesSpinEdit DecimalPlaces="2" DisplayFormatString="{0:f0} %" LargeIncrement="1" MaxValue="100" NullText="0" NumberFormat="Custom">
                                                <ClientSideEvents ValueChanged="function(s, e) {
                         calcPrices(s, e);
                     }" />
                                            </PropertiesSpinEdit>
                                            <CellStyle HorizontalAlign="Center" VerticalAlign="Middle" Font-Size="XX-Large" Font-Bold="true">
                                            </CellStyle>
                                        </dx:GridViewDataSpinEditColumn>

                                        <dx:GridViewDataTextColumn Caption="إلغاء العرض" UnboundType="String" Width="14%">
                                            <EditFormSettings Visible="False" />
                                            <DataItemTemplate>
                                                <%# 
            Convert.ToDecimal(Eval("offerPrice")) > 0 || Convert.ToDecimal(Eval("offerPercent")) > 0
            ? "<span class='cancel-offer-btn' onclick=\"showCancelOfferPopup(" + Eval("id") + ");\">إلغاء العرض</span>"
            : "<span class='no-offer-label'>لا يوجد</span>"
        %>
                                            </DataItemTemplate>
                                            <CellStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                        </dx:GridViewDataTextColumn>

                                    </Columns>
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
                                    ID="db_Offers" runat="server" ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>"
                                    SelectCommand="select p.id, p.name,isNull((SELECT TOP 1 imagePath FROM productsimages WHERE isDefault = 1 AND productId = p.id), '/assets/uploads/noFile.png') AS image, p.price, p.offerPrice, p.offerPercent, p.countryId  from products p where ((countryId = @countryId) or (@countryId=0)) and name like '%' + @name +'%'"
                                    UpdateCommand="UPDATE products SET offerPrice = @offerPrice, offerPercent= @offerPercent WHERE [id] = @id;">
                                    <UpdateParameters>
                                        <asp:Parameter Name="id" Type="Int32" />
                                        <asp:Parameter Name="offerPrice" Type="Decimal" />
                                        <asp:Parameter Name="offerPercent" Type="Decimal" />
                                    </UpdateParameters>
                                </asp:SqlDataSource>

                                <asp:SqlDataSource ID="DB_L_countries" runat="server" ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>" SelectCommand="SELECT id, countryName FROM [countries] where id <> 1000"></asp:SqlDataSource>

                                <dx:ASPxPopupControl ID="PopupConfirmSave" runat="server"
                                    ClientInstanceName="popupConfirmSave"
                                    HeaderText="تأكيد الحفظ"
                                    PopupHorizontalAlign="WindowCenter"
                                    PopupVerticalAlign="WindowCenter"
                                    CloseAction="CloseButton"
                                    Width="450px"
                                    Modal="True"
                                    ShowFooter="False"
                                    PopupAnimationType="Fade"
                                    AllowDragging="False"
                                    PopupStyle-BackColor="#fff"
                                    HeaderStyle-HorizontalAlign="Center"
                                    HeaderStyle-Font-Names="Cairo"
                                    HeaderStyle-Font-Size="17px"
                                    HeaderStyle-ForeColor="#444">

                                    <ContentCollection>
                                        <dx:PopupControlContentControl runat="server">
                                            <div style="text-align: center; padding: 35px 25px; font-family: 'Cairo',sans-serif; direction: rtl; background-color: #fff; border-radius: 18px;">

                                                <div style="font-size: 19px; color: #222; font-weight: 600; margin-bottom: 35px; line-height: 42px;">
                                                    هل تريد حفظ التعديلات على العروض؟
                    
                                                    <br />
                                                    <span style="font-size: 16px; color: #666; font-weight: normal;">سيتم تطبيق العروض على المنتجات (التي نوعها سعر) وجميع خياراتها تلقائياً
                     </span>
                                                </div>

                                                <div style="display: flex; justify-content: center; gap: 25px;">
                                                    <dx:ASPxButton ID="btnConfirmSave" runat="server"
                                                        Text="نعم، احفظ"
                                                        AutoPostBack="False"
                                                        Width="130px"
                                                        Height="45px"
                                                        Font-Names="Cairo"
                                                        Font-Size="16px">
                                                        <ClientSideEvents Click="function(s,e){ popupConfirmSave.Hide(); GridOffers.UpdateEdit(); }" />
                                                    </dx:ASPxButton>

                                                    <dx:ASPxButton ID="btnCancelSave" runat="server"
                                                        Text="إلغاء"
                                                        AutoPostBack="False"
                                                        Width="130px"
                                                        Height="45px"
                                                        Font-Names="Cairo"
                                                        Font-Size="16px">
                                                        <ClientSideEvents Click="function(s,e){ popupConfirmSave.Hide(); GridOffers.CancelEdit(); }" />
                                                    </dx:ASPxButton>
                                                </div>
                                            </div>
                                        </dx:PopupControlContentControl>
                                    </ContentCollection>
                                </dx:ASPxPopupControl>

                                <dx:ASPxPopupControl ID="PopupResult" runat="server"
                                    ClientInstanceName="popupResult"
                                    HeaderText="النتيجة"
                                    PopupHorizontalAlign="WindowCenter"
                                    PopupVerticalAlign="WindowCenter"
                                    CloseAction="CloseButton"
                                    Width="400px"
                                    Modal="True"
                                    ShowFooter="False"
                                    PopupAnimationType="Fade"
                                    AllowDragging="False"
                                    PopupStyle-BackColor="#fff"
                                    HeaderStyle-HorizontalAlign="Center"
                                    HeaderStyle-Font-Names="Cairo"
                                    HeaderStyle-Font-Size="17px"
                                    HeaderStyle-ForeColor="#444">

                                    <ContentCollection>
                                        <dx:PopupControlContentControl runat="server">
                                            <div id="resultMessage" style="text-align: center; padding: 35px 25px; font-family: 'Cairo', sans-serif; direction: rtl;">
                                                <div id="resultMessageText" style="font-size: 18px; color: #222; font-weight: 600; line-height: 36px;">
                                                    تم تطبيق العروض بنجاح
                
                                                </div>

                                                <div style="margin-top: 30px;">
                                                    <dx:ASPxButton ID="btnCloseResult" runat="server"
                                                        Text="إغلاق"
                                                        AutoPostBack="False"
                                                        Width="120px"
                                                        Height="45px"
                                                        Font-Names="Cairo"
                                                        Font-Size="16px">
                                                        <ClientSideEvents Click="function(s,e){ popupResult.Hide(); GridOffers.Refresh(); }" />
                                                    </dx:ASPxButton>
                                                </div>
                                            </div>
                                        </dx:PopupControlContentControl>
                                    </ContentCollection>
                                </dx:ASPxPopupControl>



                                <dx:ASPxPopupControl ID="PopupCancelOffer" runat="server"
                                    ClientInstanceName="PopupCancelOffer"
                                    HeaderText="تأكيد إلغاء العرض"
                                    Width="400px"
                                    Height="200px"
                                    Modal="true"
                                    PopupHorizontalAlign="WindowCenter"
                                    PopupVerticalAlign="WindowCenter"
                                    AllowDragging="true"
                                    ShowCloseButton="true"
                                    CloseAction="CloseButton">
                                    <HeaderStyle BackColor="#2196F3" ForeColor="Black" Font-Names="Cairo" Font-Bold="true" HorizontalAlign="Center" />
                                    <ContentCollection>
                                        <dx:PopupControlContentControl>
                                            <div style="padding: 20px; text-align: center;">
                                                <div style="margin-bottom: 20px; font-size: 16px;">
                                                    <i class="fa fa-exclamation-triangle" style="color: #ff9800; font-size: 48px; margin-bottom: 15px;"></i>
                                                    <p style="margin-top: 15px; font-family: Cairo; font-weight: bold;">هل أنت متأكد من إلغاء العرض على هذا المنتج وخياراته؟</p>
                                                </div>
                                                <div style="margin-top: 30px;">
                                                    <dx:ASPxButton ID="ASPxButton1" runat="server"
                                                        Text="نعم، إلغاء العرض"
                                                        AutoPostBack="false"
                                                        Theme="MaterialCompact"
                                                        BackColor="#f44336"
                                                        ForeColor="White"
                                                        Font-Names="Cairo"
                                                        Width="150px"
                                                        Style="margin-left: 10px;">
                                                        <ClientSideEvents Click="function(s, e) { confirmCancelOffer(); }" />
                                                    </dx:ASPxButton>

                                                    <dx:ASPxButton ID="btnCancelAction" runat="server"
                                                        Text="لا، إلغاء"
                                                        AutoPostBack="false"
                                                        Theme="MaterialCompact"
                                                        Font-Names="Cairo"
                                                        Width="100px">
                                                        <ClientSideEvents Click="function(s, e) { PopupCancelOffer.Hide(); }" />
                                                    </dx:ASPxButton>
                                                </div>
                                            </div>
                                        </dx:PopupControlContentControl>
                                    </ContentCollection>
                                </dx:ASPxPopupControl>

                                <asp:HiddenField ID="hfSelectedProductId" runat="server" />

                            </div>
                        </dx:ContentControl>
                    </ContentCollection>
                </dx:TabPage>


                <dx:TabPage Text="عروض الخيارات" TabStyle-Font-Bold="true" TabStyle-Font-Names="cairo" TabStyle-Font-Size="X-Large">
                    <TabStyle Font-Bold="True" Font-Names="cairo" Font-Size="X-Large"></TabStyle>
                    <ContentCollection>
                        <dx:ContentControl runat="server">
                            <style>
                                #Pop_Product * {
                                    font-family: 'Cairo', sans-serif !important;
                                }
                            </style>
                            <script type="text/javascript">
                                var MyOptionId = 0;
                                var MyOptionPrice = 0;
                                var CancelOptionId = 0;

                                function OnRowClickOption(e) {
                                    var rowIndex = e.visibleIndex;
                                    GridProductOptions.GetRowValues(rowIndex, 'id;productOptionPrice', function (values) {
                                        if (values && values.length === 2) {
                                            MyOptionId = parseInt(values[0]) || 0;
                                            MyOptionPrice = parseFloat(values[1]) || 0;
                                        } else {
                                            MyOptionId = 0;
                                            MyOptionPrice = 0;
                                        }
                                    });
                                }

                                function ShowProductOptions(productId) {
                                    if (!productId) return;
                                    GridProductOptions.PerformCallback(productId);
                                    Pop_Product.Show();
                                }

                                function CancelOption(optionId) {
                                    CancelOptionId = parseInt(optionId) || 0;
                                    Pop_CancelOption.Show();
                                }

                                function optionCalcPercent(s, e) {
                                    var editCell = GridProductOptions.batchEditApi.GetEditCellInfo();
                                    if (!editCell) return;

                                    var rowIndex = editCell.rowVisibleIndex;

                                    var basePrice = parseFloat(MyOptionPrice) || 0;
                                    var offerPrice = parseFloat(s.GetValue()) || 0;

                                    if (basePrice <= 0) return;

                                    if (offerPrice > basePrice) {
                                        offerPrice = basePrice;
                                        s.SetValue(basePrice);
                                    }

                                    var percent = ((basePrice - offerPrice) / basePrice) * 100;

                                    // ✅ اجعلها رقم صحيح دائمًا (بدون فواصل)
                                    percent = Math.round(percent);

                                    GridProductOptions.batchEditApi.SetCellValue(rowIndex, "offerPercent", percent);
                                }


                                function optionCalcPrice(s, e) {
                                    var editCell = GridProductOptions.batchEditApi.GetEditCellInfo();
                                    if (!editCell) return;
                                    var rowIndex = editCell.rowVisibleIndex;

                                    var basePrice = parseFloat(MyOptionPrice) || 0;
                                    var percent = parseFloat(s.GetValue()) || 0;

                                    if (basePrice <= 0) return;

                                    if (percent < 0) percent = 0;
                                    if (percent > 100) percent = 100;

                                    var offerPrice = basePrice - (basePrice * percent / 100);
                                    offerPrice = Math.round(offerPrice * 100) / 100;

                                    if (offerPrice > basePrice) offerPrice = basePrice;

                                    GridProductOptions.batchEditApi.SetCellValue(rowIndex, "offerPrice", offerPrice);
                                }
                            </script>


                            <div style="margin: 0 auto; font-size: 1.3em; font-family: cairo; color: #c78d65; margin-bottom: 1em">
                                يتم عرض المنتجات التي تحتوي على خيارات ونوعها سعر
                            </div>


                            <div class="navbar-main navbar-expand-lg px-0 mx-4 border-radius-xl bg-white shadow mt-3 mb-1">
                                <dx:ASPxGridView ID="gridProducts" runat="server"
                                    DataSourceID="Products"
                                    KeyFieldName="id" ClientInstanceName="gridProducts"
                                    Width="100%" AutoGenerateColumns="False"
                                    Font-Names="Cairo" Font-Size="0.9em" RightToLeft="True"
                                    EnablePagingCallbackAnimation="True">


                                    <Settings ShowFooter="True" ShowFilterRow="True" ShowFilterRowMenu="False" ShowHeaderFilterButton="False" AutoFilterCondition="Contains" />
                                    <SettingsLoadingPanel Text="يرجى الانتظار..." Mode="ShowAsPopup" />
                                    <SettingsText SearchPanelEditorNullText="ابحث في المنتجات..." EmptyDataRow="لا يوجد منتجات مرتبطة بهذا الطلب." CommandBatchEditPreviewChanges="التغييرات" />

                                    <SettingsExport EnableClientSideExportAPI="true" ExcelExportMode="WYSIWYG" PaperKind="A4" RightToLeft="True" />

                                    <SettingsPopup>
                                        <FilterControl AutoUpdatePosition="False"></FilterControl>
                                    </SettingsPopup>

                                    <SettingsSearchPanel CustomEditorID="tbToolbarSearchProducts" />
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


                                    <Toolbars>
                                        <dx:GridViewToolbar ItemAlign="left">
                                            <SettingsAdaptivity Enabled="true" EnableCollapseRootItemsToIcons="true" />
                                            <Items>

                                                <dx:GridViewToolbarItem Command="Refresh" BeginGroup="true" AdaptivePriority="1" Text="تحديث" />
                                                <dx:GridViewToolbarItem Command="ExportToXlsx" BeginGroup="true" />
                                                <dx:GridViewToolbarItem Command="ExportToPdf" />
                                                <dx:GridViewToolbarItem Alignment="Right" Name="toolbarSearchProducts" BeginGroup="true" AdaptivePriority="2">
                                                    <Template>
                                                        <dx:ASPxTextBox ID="tbToolbarSearchProducts" runat="server"
                                                            NullText="البحث..." Width="140" Font-Names="Cairo" />
                                                    </Template>
                                                </dx:GridViewToolbarItem>
                                            </Items>
                                        </dx:GridViewToolbar>
                                    </Toolbars>

                                    <Styles>
                                        <AlternatingRow BackColor="#F0F0F0" />
                                        <Footer Font-Names="Cairo" />
                                    </Styles>

                                    <Paddings Padding="2em" />

                                    <Columns>
                                        <dx:GridViewDataColumn FieldName="id" Caption="الرقم">
                                            <CellStyle VerticalAlign="Middle" HorizontalAlign="Center" Font-Size="Large">
                                            </CellStyle>
                                        </dx:GridViewDataColumn>
                                        <dx:GridViewDataColumn Caption="الصور" VisibleIndex="1" FieldName="Images">

                                            <DataItemTemplate>
                                                <div class="preview-container" style="text-align: center; display: flex; justify-content: center;">

                                                    <img
                                                        id="defaultThumbImg"
                                                        src='<%# GetFirstImagePath(Eval("id")) %>?v=<%# DateTime.Now.Ticks %>'
                                                        style="width: 7em; border: 1px solid #c8c8c8; border-radius: 5px; cursor: pointer;" />
                                                </div>
                                            </DataItemTemplate>
                                        </dx:GridViewDataColumn>

                                        <dx:GridViewDataColumn FieldName="name" Caption="المنتج">
                                            <CellStyle VerticalAlign="Middle" HorizontalAlign="Center" Font-Size="Large">
                                            </CellStyle>
                                        </dx:GridViewDataColumn>

                                        <dx:GridViewDataColumn FieldName="price" Caption="السعر">
                                            <CellStyle VerticalAlign="Middle" HorizontalAlign="Center" Font-Size="Large">
                                            </CellStyle>
                                        </dx:GridViewDataColumn>

                                        <dx:GridViewDataTextColumn Caption="تفاصيل" Width="120px">
                                            <DataItemTemplate>
                                                <button type="button"
                                                    onclick="ShowProductOptions('<%# Eval("id") %>');"
                                                    style="background-color: #3498db; color: white; border: none; padding: 6px 14px; border-radius: 6px; font-family: 'Cairo'; cursor: pointer;">
                                                    عرض
       
                                                </button>
                                            </DataItemTemplate>
                                            <CellStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                        </dx:GridViewDataTextColumn>

                                    </Columns>

                                    <TotalSummary>
                                        <dx:ASPxSummaryItem FieldName="id" SummaryType="Count" DisplayFormat="العدد = {0}" />
                                    </TotalSummary>

                                </dx:ASPxGridView>
                                <asp:SqlDataSource
                                    ID="Products"
                                    runat="server"
                                    ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>"
                                    SelectCommand="
        SELECT p.id, p.name, p.price
        FROM Products p
        WHERE p.isProductPrice = 1
          AND EXISTS (SELECT 1 FROM ProductsOptions po WHERE po.productId = p.id)"></asp:SqlDataSource>



                            </div>
                        </dx:ContentControl>
                    </ContentCollection>
                </dx:TabPage>
            </TabPages>

        </dx:ASPxPageControl>

        <dx:ASPxPopupControl ID="Pop_Product" runat="server"
            ClientInstanceName="Pop_Product"
            HeaderText="خيارات المنتج"
            PopupHorizontalAlign="WindowCenter"
            PopupVerticalAlign="WindowCenter"
            Width="1000px"
            Height="600px"
            Font-Names="Cairo"
            ShowCloseButton="true"
            Modal="true">
            <ClientSideEvents Shown="function(s, e) { 
                setTimeout(function()
                    {
                        s.UpdatePosition();
                    },500);
                } " />

            <ContentCollection>
                <dx:PopupControlContentControl runat="server">

                    <dx:ASPxGridView ID="GridProductOptions"
                        runat="server"
                        DataSourceID="dsProductOptions"
                        KeyFieldName="id"
                        ClientInstanceName="GridProductOptions"
                        Width="100%"
                        AutoGenerateColumns="False"
                        OnCustomCallback="GridProductOptions_CustomCallback"
                        OnBatchUpdate="GridProductOptions_BatchUpdate"
                        EnablePagingCallbackAnimation="True"
                        Font-Names="cairo"
                        Font-Size="1em"
                        RightToLeft="True">
                        <ClientSideEvents RowClick="function(s, e) {OnRowClickOption(e);}" />

                        <SettingsPager NumericButtonCount="3" PageSize="3">
                        </SettingsPager>

                        <SettingsEditing Mode="Batch" BatchEditSettings-EditMode="Cell" />

                        <Settings ShowFooter="True" ShowFilterRow="True" />


                        <SettingsAdaptivity AdaptivityMode="HideDataCells" />

                        <SettingsCommandButton>
                            <UpdateButton Text=" حفظ ">
                                <Image Url="~/assets/img/save.png" />
                            </UpdateButton>
                            <CancelButton Text=" الغاء ">
                                <Image Url="~/assets/img/cancel.png" />
                            </CancelButton>
                        </SettingsCommandButton>

                        <SettingsPopup>
                            <FilterControl AutoUpdatePosition="False"></FilterControl>
                        </SettingsPopup>

                        <SettingsText CommandBatchEditPreviewChanges="التغييرات" />
                        <Columns>
                            <dx:GridViewDataTextColumn FieldName="id" Caption="الرقم" VisibleIndex="0" Width="5%" ReadOnly="true">
                                <EditFormSettings Visible="False" />
                            </dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn FieldName="productOption" Caption="الخيار" VisibleIndex="1" ReadOnly="true">
                                <EditFormSettings Visible="False" />
                            </dx:GridViewDataTextColumn>

                            <dx:GridViewDataColumn Caption="الصور" VisibleIndex="1" FieldName="Images">
                                <DataItemTemplate>
                                    <div class="preview-container" style="text-align: center; display: flex; justify-content: center;">

                                        <img
                                            id="defaultThumbImg"
                                            src='<%# GetOptionImagePath(Eval("id")) %>?v=<%# DateTime.Now.Ticks %>'
                                            style="width: 7em; border: 1px solid #c8c8c8; border-radius: 5px; cursor: pointer;" />
                                    </div>
                                </DataItemTemplate>
                                <EditFormSettings Visible="False" />
                            </dx:GridViewDataColumn>

                            <dx:GridViewDataTextColumn FieldName="productOptionPrice" Caption="سعر الخيار الاساسي" ReadOnly="true">
                                <EditFormSettings Visible="False" />
                            </dx:GridViewDataTextColumn>

                            <dx:GridViewDataSpinEditColumn FieldName="offerPrice" Caption="سعر العرض">
                                <PropertiesSpinEdit DisplayFormatString="n2">
                                    <ClientSideEvents ValueChanged="optionCalcPercent" />
                                </PropertiesSpinEdit>
                                <CellStyle Font-Bold="true" HorizontalAlign="Center" VerticalAlign="Middle" />
                            </dx:GridViewDataSpinEditColumn>

                            <dx:GridViewDataSpinEditColumn FieldName="offerPercent" Caption="نسبة العرض %">
                                <PropertiesSpinEdit DecimalPlaces="2" DisplayFormatString="{0:f0} %" LargeIncrement="1" MaxValue="100" NullText="0" NumberFormat="Custom">
                                    <ClientSideEvents ValueChanged="optionCalcPrice" />
                                </PropertiesSpinEdit>
                                <CellStyle Font-Bold="true" HorizontalAlign="Center" VerticalAlign="Middle" />
                            </dx:GridViewDataSpinEditColumn>



                            <dx:GridViewDataTextColumn Caption="إلغاء العرض" Width="120px">
                                <DataItemTemplate>
                                    <%# Convert.ToDecimal(Eval("offerPrice")) > 0 
            ? "<button type='button' style=\"background-color:#e74c3c;color:white;border:none;padding:6px 12px;border-radius:6px;font-family:Cairo;cursor:pointer;\" onclick=\"CancelOption(" + Eval("id") + ");\">إلغاء</button>" 
            : "<span style='color:gray;font-family:Cairo;font-weight:bold;'>لا يوجد عرض</span>" %>
                                </DataItemTemplate>
                                <EditFormSettings Visible="False" />
                                <CellStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                            </dx:GridViewDataTextColumn>



                        </Columns>

                        <Toolbars>
                            <dx:GridViewToolbar ItemAlign="left">
                                <Items>
                                    <dx:GridViewToolbarItem Command="Refresh" BeginGroup="true" Text="تحديث الجدول" />
                                    <dx:GridViewToolbarItem Command="ExportToXlsx" BeginGroup="true" />
                                    <dx:GridViewToolbarItem Command="ExportToPdf" />
                                </Items>
                            </dx:GridViewToolbar>
                        </Toolbars>

                        <Styles>
                            <AlternatingRow BackColor="#F0F0F0">
                            </AlternatingRow>
                            <Footer Font-Names="cairo">
                            </Footer>
                        </Styles>
                        <TotalSummary>
                            <dx:ASPxSummaryItem FieldName="id" SummaryType="Count" DisplayFormat="العدد = {0}" />
                        </TotalSummary>
                    </dx:ASPxGridView>


                    <asp:SqlDataSource ID="dsProductOptions" runat="server"
                        ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>"
                        SelectCommand="SELECT id, productOption, productOptionPrice, offerPrice, offerPercent 
                   FROM ProductsOptions 
                   WHERE productId=@productId"
                        UpdateCommand="UPDATE ProductsOptions 
                   SET offerPrice = @offerPrice, 
                       offerPercent = @offerPercent 
                   WHERE id = @id">
                        <SelectParameters>
                            <asp:Parameter Name="productId" Type="Int32" />
                        </SelectParameters>
                        <UpdateParameters>
                            <asp:Parameter Name="offerPrice" Type="Decimal" />
                            <asp:Parameter Name="offerPercent" Type="Decimal" />
                            <asp:Parameter Name="id" Type="Int32" />
                        </UpdateParameters>
                    </asp:SqlDataSource>

                </dx:PopupControlContentControl>
            </ContentCollection>
        </dx:ASPxPopupControl>


        <dx:ASPxPopupControl ID="Pop_CancelOption" runat="server"
            ClientInstanceName="Pop_CancelOption"
            PopupHorizontalAlign="WindowCenter"
            PopupVerticalAlign="WindowCenter"
            Modal="true"
            Width="350px"
            Font-Names="Cairo"
            HeaderText="تأكيد إلغاء العرض"
            ShowCloseButton="true">
            <ContentCollection>
                <dx:PopupControlContentControl runat="server">
                    <div style="padding: 20px; font-family: 'Cairo'; text-align: center;">
                        <dx:ASPxLabel ID="lblConfirmCancel" runat="server" Font-Names="Cairo"
                            Text="هل أنت متأكد من إلغاء العرض لهذا الخيار؟"
                            Font-Size="Large" />
                        <br />
                        <br />
                        <dx:ASPxButton ID="btnConfirmCancel" runat="server"
                            AutoPostBack="false" Text="نعم، إلغاء" Font-Names="Cairo"
                            ClientSideEvents-Click="function(s, e) {
                        GridProductOptions.PerformCallback('cancel|' + CancelOptionId);
                        Pop_CancelOption.Hide();
                    }"
                            Style="margin: 5px;" />
                        <dx:ASPxButton ID="btnCancelClose" runat="server"
                            AutoPostBack="false" Text="إغلاق" Font-Names="Cairo"
                            ClientSideEvents-Click="function(s, e) { Pop_CancelOption.Hide(); }"
                            Style="margin: 5px;" />
                    </div>
                </dx:PopupControlContentControl>
            </ContentCollection>
        </dx:ASPxPopupControl>


        <dx:ASPxPopupControl ID="popupWarning" runat="server" ClientInstanceName="popupWarning"
            Width="400px" HeaderText="تحذير" ShowCloseButton="true"
            PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" Modal="true"
            HeaderStyle-Font-Names="Cairo" Font-Names="Cairo" ClientSideEvents-Init="InitDangerAnimation">

            <ClientSideEvents Init="InitDangerAnimation" Shown="function(s, e) { s.UpdatePosition(); }"></ClientSideEvents>

            <HeaderStyle Font-Names="Cairo"></HeaderStyle>

            <ContentCollection>
                <dx:PopupControlContentControl>
                    <div style="padding: 15px; font-family: Cairo; font-size: 1.2em; line-height: 1.8; text-align: center">
                        <div id="dangerAnimation" style="width: 150px; height: 150px; margin: 0 auto;"></div>
                        <strong>لا تملك الصلاحية لتحديث الأسعار.</strong><br />
                        يرجى الدخول بمستخدم تابع لشركة للتعديل.
                    </div>
                </dx:PopupControlContentControl>
            </ContentCollection>
        </dx:ASPxPopupControl>

        <dx:ASPxCallback ID="cbCheckPrivileges" runat="server" ClientInstanceName="cbCheckPrivileges"
            OnCallback="cbCheckPrivileges_Callback">
            <ClientSideEvents EndCallback="function(s, e) {
        if (s.cpShowPopup === 'true') {
            popupWarning.Show();
        }
    }" />
        </dx:ASPxCallback>

        <dx:ASPxTextBox ID="showAllOffers" runat="server" BackColor="Transparent" ClientInstanceName="showAllOffers" Font-Size="0pt" ForeColor="Transparent" Text="" Width="0px" Theme="Default">
            <Border BorderStyle="None" BorderWidth="0px" />
        </dx:ASPxTextBox>


    </main>



</asp:Content>
