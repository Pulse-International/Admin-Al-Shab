<%@ Page Title="Branches" Language="C#" MasterPageFile="~/mSite.Master" AutoEventWireup="true" CodeBehind="mReports.aspx.cs" Inherits="ShabAdmin.Reports" %>

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
                //if (idx === 1 || idx === 2) {
                //    cbCheckPrivileges.PerformCallback();
                //}
            }
            function CitiesCombo_SelectedIndexChanged(s, e) {
                var cityId = s.GetValue();
                var editorCity = GridBranches.GetEditor("cityId");
                if (editorCity != null)
                    editorCity.PerformCallback(cityId);

                var editorCompany = GridBranches.GetEditor("companyId");
                if (editorCompany != null)
                    editorCompany.PerformCallback("cityChanged|" + cityId);
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

            function ShowOrderProducts(orderId) {
                l_Order_Id.SetText(orderId);

                setTimeout(function () {
                    popupOrderProducts.Show();
                    setTimeout(function () {
                        gridOrderProducts.Refresh();
                    }, 300); // wait for popup layout, then refresh
                }, 100);
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


            function ShowXML(link) {
                var xmlId = link.getAttribute('data-xml-id');
                if (xmlId) {
                    callbackXML.PerformCallback(xmlId); // يرسل الطلب للسيرفر
                    popupXML.Show();
                }
            }

        </script>


        <dx:ASPxTextBox ID="l_Order_Id" runat="server" BackColor="Transparent" ClientInstanceName="l_Order_Id" Font-Size="0pt" ForeColor="Transparent" Text="" Width="0px" Theme="Default">
            <Border BorderStyle="None" BorderWidth="0px" />
        </dx:ASPxTextBox>

        <div class="w-100 text-center my-4">
            <h2 class="pageTitle d-inline-block" style="font-family: Cairo">التقارير</h2>
        </div>
        <dx:ASPxPageControl ID="pageTab" runat="server" CssClass="divSTARProviders" ActiveTabIndex="0" ClientInstanceName="pageTab" Theme="Material" Width="100%" EnableCallbackAnimation="True">
            <ClientSideEvents ActiveTabChanged="onTabChanged" />
            <TabPages>
                <dx:TabPage Text="المالية" TabStyle-Font-Bold="true" TabStyle-Font-Names="cairo" TabStyle-Font-Size="X-Large">
                    <TabStyle Font-Bold="True" Font-Names="cairo" Font-Size="X-Large"></TabStyle>
                    <ContentCollection>
                        <dx:ContentControl runat="server">
                            <div class="navbar-main navbar-expand-lg px-0 mx-4 border-radius-xl bg-white shadow mt-3 mb-1">

                                <div style="display: flex; flex-wrap: wrap; gap: 15px; align-items: center; justify-content: center; padding-top: 25px;">

                                    <dx:ASPxComboBox
                                        ID="CountryList"
                                        runat="server"
                                        Font-Names="Cairo"
                                        Width="240px"
                                        TextField="countryName"
                                        ValueField="id"
                                        DataSourceID="dsCountries"
                                        NullText="اختر الدولة"
                                        Font-Bold="True"
                                        Font-Size="Medium"
                                        ClientInstanceName="cmbCountry">
                                        <ClientSideEvents SelectedIndexChanged="function(s,e){ cbpCompany.PerformCallback(s.GetValue()); }" />
                                    </dx:ASPxComboBox>

                                    <dx:ASPxCallbackPanel ID="cbpCompany" runat="server" ClientInstanceName="cbpCompany" OnCallback="cbpCompany_Callback">
                                        <PanelCollection>
                                            <dx:PanelContent>
                                                <dx:ASPxComboBox
                                                    ID="CompanyList"
                                                    runat="server"
                                                    Font-Names="Cairo"
                                                    Width="240px"
                                                    TextField="companyName"
                                                    ValueField="id"
                                                    DataSourceID="dsCompanies"
                                                    NullText="اختر الشركة"
                                                    Font-Bold="True"
                                                    Font-Size="Medium"
                                                    ClientInstanceName="cmbCompany">
                                                    <ClientSideEvents SelectedIndexChanged="function(s,e){ cbpBranch.PerformCallback(s.GetValue()); }" />
                                                </dx:ASPxComboBox>
                                            </dx:PanelContent>
                                        </PanelCollection>
                                    </dx:ASPxCallbackPanel>

                                    <dx:ASPxCallbackPanel ID="cbpBranch" runat="server" ClientInstanceName="cbpBranch" OnCallback="cbpBranch_Callback">
                                        <PanelCollection>
                                            <dx:PanelContent>
                                                <dx:ASPxComboBox
                                                    ID="BranchList"
                                                    runat="server"
                                                    Font-Names="Cairo"
                                                    Width="240px"
                                                    TextField="name"
                                                    ValueField="id"
                                                    DataSourceID="dsBranches"
                                                    NullText="اختر الفرع"
                                                    Font-Bold="True"
                                                    Font-Size="Medium"
                                                    ClientInstanceName="cmbBranch">
                                                </dx:ASPxComboBox>
                                            </dx:PanelContent>
                                        </PanelCollection>
                                    </dx:ASPxCallbackPanel>


                                </div>

                                <div style="display: flex; flex-wrap: wrap; gap: 15px; align-items: center; justify-content: center; margin-top: 15px;">

                                    <dx:ASPxDateEdit
                                        ID="DateFrom"
                                        runat="server"
                                        Width="200px"
                                        NullText="من تاريخ"
                                        Font-Names="Cairo"
                                        Font-Bold="True"
                                        Font-Size="Medium"
                                        ClientInstanceName="dateFrom"
                                        EditFormat="Date"
                                        DisplayFormatString="yyyy-MM-dd">
                                        <ClientSideEvents ValueChanged="function(s, e) {
                                            var fromDate = s.GetDate();
                                            if (fromDate) {
                                                dateTo.SetMinDate(fromDate);
                                            }
                                        }" />
                                    </dx:ASPxDateEdit>

                                    <dx:ASPxDateEdit
                                        ID="DateTo"
                                        runat="server"
                                        Width="200px"
                                        NullText="إلى تاريخ"
                                        Font-Names="Cairo"
                                        Font-Bold="True"
                                        Font-Size="Medium"
                                        ClientInstanceName="dateTo"
                                        EditFormat="Date"
                                        DisplayFormatString="yyyy-MM-dd">
                                    </dx:ASPxDateEdit>


                                    <dx:ASPxButton
                                        ID="btnSearch"
                                        runat="server"
                                        Text="بحث"
                                        AutoPostBack="False"
                                        Width="140px"
                                        Font-Names="Cairo"
                                        Font-Size="Medium"
                                        CssClass="rounded-xl"
                                        Font-Bold="true"
                                        ClientInstanceName="btnSearch"
                                        Theme="Moderno">
                                        <Image Url="~/assets/img/search.png" />
                                        <ClientSideEvents Click="function(s,e){
                                            GridOrders.PerformCallback();
                                        }" />
                                    </dx:ASPxButton>

                                    <dx:ASPxButton
                                        ID="btnReset"
                                        runat="server"
                                        Text="مسح"
                                        AutoPostBack="False"
                                        Width="140px"
                                        Font-Names="Cairo"
                                        Font-Size="Medium"
                                        CssClass="rounded-xl"
                                        ClientInstanceName="btnReset"
                                        Theme="Moderno">
                                        <Image Url="~/assets/img/reset.png" />
                                        <ClientSideEvents Click="function(s,e){
                                            cmbCountry.SetValue(null);
                                            cmbCompany.SetValue(null);
                                            cmbBranch.SetValue(null);
                                            dateFrom.SetValue(null);
                                            dateTo.SetValue(null);

                                            GridOrders.PerformCallback('Cancel');
                                        }" />
                                    </dx:ASPxButton>
                                </div>

                                <dx:ASPxGridView ID="GridOrders" runat="server" DataSourceID="dsOrders" KeyFieldName="id" ClientInstanceName="GridOrders" Width="100%" AutoGenerateColumns="False" EnablePagingCallbackAnimation="True" Font-Names="cairo" Font-Bold="True"
                                    Font-Size="0.77em" RightToLeft="True" OnCustomCallback="GridOrders_CustomCallback" OnBeforePerformDataSelect="GridOrders_BeforePerformDataSelect">
                                    <Settings ShowFooter="True" ShowFilterRow="True" />

                                    <Styles>
                                        <PagerBottomPanel Font-Names="Cairo" Font-Size="Large" Font-Bold="true"></PagerBottomPanel>
                                    </Styles>


                                    <ClientSideEvents RowClick="function(s, e) {OnRowClick(e);}" />
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
                                    <SettingsText SearchPanelEditorNullText="ابحث في الجدول..." EmptyDataRow="لا يوجد" />
                                    <Columns>
                                        <dx:GridViewDataColumn Caption="الرقم" FieldName="id">
                                            <EditFormSettings Visible="False" />
                                            <CellStyle VerticalAlign="Middle" HorizontalAlign="Center">
                                            </CellStyle>
                                        </dx:GridViewDataColumn>

                                        <dx:GridViewDataColumn Caption="المستخدم" FieldName="username">
                                            <DataItemTemplate>
                                                <div style="font-family: Cairo; text-align: center;">
                                                    <div style="font-weight: bold;"><%# Eval("fullName") %></div>
                                                    <div style="color: #888; font-size: 12px;"><%# Eval("username") %></div>
                                                </div>
                                            </DataItemTemplate>
                                            <CellStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                        </dx:GridViewDataColumn>

                                        <dx:GridViewDataComboBoxColumn Caption="الشركة / الدولة" FieldName="companyId">
                                            <PropertiesComboBox
                                                DataSourceID="dsCompanies"
                                                TextField="companyName"
                                                ValueField="id"
                                                DropDownStyle="DropDownList"
                                                EnableCallbackMode="false">
                                            </PropertiesComboBox>

                                            <DataItemTemplate>
                                                <%# Eval("countryName") + " - " + Eval("companyName")  %>
                                            </DataItemTemplate>

                                            <CellStyle VerticalAlign="Middle" HorizontalAlign="Center" />
                                        </dx:GridViewDataComboBoxColumn>

                                        <dx:GridViewDataColumn Caption="الفرع" FieldName="branchName">
                                            <EditFormSettings Visible="False" />
                                            <CellStyle VerticalAlign="Middle" HorizontalAlign="Center">
                                            </CellStyle>
                                        </dx:GridViewDataColumn>

                                        <dx:GridViewDataColumn Caption="المبلغ" FieldName="amount">
                                            <DataItemTemplate>
                                                <%# Eval("amount") + "</br>" + GetCurrency(Eval("countryId")) %>
                                            </DataItemTemplate>
                                            <EditFormSettings Visible="False" />
                                            <CellStyle VerticalAlign="Middle" HorizontalAlign="Center">
                                            </CellStyle>
                                        </dx:GridViewDataColumn>

                                        <dx:GridViewDataColumn Caption="مبلغ التوصيل" FieldName="deliveryAmount">
                                            <DataItemTemplate>
                                                <%# Eval("deliveryAmount") + "</br>" + GetCurrency(Eval("countryId")) %>
                                            </DataItemTemplate>
                                            <EditFormSettings Visible="False" />
                                            <CellStyle VerticalAlign="Middle" HorizontalAlign="Center">
                                            </CellStyle>
                                        </dx:GridViewDataColumn>

                                        <dx:GridViewDataColumn Caption="الضريبة" FieldName="taxAmount">
                                            <DataItemTemplate>
                                                <%# Eval("taxAmount") + "</br>" + GetCurrency(Eval("countryId")) %>
                                            </DataItemTemplate>
                                            <EditFormSettings Visible="False" />
                                            <CellStyle VerticalAlign="Middle" HorizontalAlign="Center">
                                            </CellStyle>
                                        </dx:GridViewDataColumn>

                                        <dx:GridViewDataColumn Caption="المبلغ الكلي" FieldName="totalAmount">
                                            <DataItemTemplate>
                                                <%# Eval("totalAmount") + "</br>" + GetCurrency(Eval("countryId")) %>
                                            </DataItemTemplate>
                                            <EditFormSettings Visible="False" />
                                            <CellStyle VerticalAlign="Middle" Font-Bold="true" HorizontalAlign="Center">
                                            </CellStyle>
                                        </dx:GridViewDataColumn>

                                        <dx:GridViewDataColumn Caption="طريقة الدفع" FieldName="paymentMethod">
                                            <EditFormSettings Visible="False" />
                                            <CellStyle VerticalAlign="Middle" HorizontalAlign="Center">
                                            </CellStyle>
                                        </dx:GridViewDataColumn>

                                        <dx:GridViewDataColumn Caption="رقم المعاملة" FieldName="transactionId">
                                            <EditFormSettings Visible="False" />
                                            <CellStyle VerticalAlign="Middle" HorizontalAlign="Center">
                                            </CellStyle>
                                        </dx:GridViewDataColumn>

                                        <dx:GridViewDataColumn Caption="رقم الفاتورة" FieldName="invoiceNo">
                                            <EditFormSettings Visible="False" />
                                            <CellStyle VerticalAlign="Middle" HorizontalAlign="Center">
                                            </CellStyle>
                                        </dx:GridViewDataColumn>

                                        <dx:GridViewDataColumn Caption="ملاحظات" FieldName="notes">
                                            <EditFormSettings Visible="False" />
                                            <CellStyle VerticalAlign="Middle" HorizontalAlign="Center">
                                            </CellStyle>
                                        </dx:GridViewDataColumn>

                                        <dx:GridViewDataDateColumn FieldName="userDate" Caption="التاريخ">
                                            <PropertiesDateEdit DisplayFormatString="yyyy/MM/dd hh:mm tt" />
                                            <EditFormSettings Visible="False" />
                                            <CellStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                        </dx:GridViewDataDateColumn>

                                        <dx:GridViewDataColumn Caption="المنتجات">
                                            <DataItemTemplate>
                                                <a href="javascript:void(0);" onclick="ShowOrderProducts(<%# Eval("id") %>)"
                                                    title="عرض المنتجات">
                                                    <img src="/assets/img/details.png" alt="عرض المنتجات" style="width: 24px; height: 24px;" />
                                                </a>
                                            </DataItemTemplate>
                                            <EditFormSettings Visible="False" />
                                            <CellStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                        </dx:GridViewDataColumn>


                                        <dx:GridViewDataColumn Caption="الاسترجاع" FieldName="refundedAmount">
                                            <DataItemTemplate>
                                                <%# 
                    Convert.ToDecimal(Eval("refundedAmount")) > 0
                    ? $"<a href='javascript:void(0);' onclick=\"callbackRefundDetails.PerformCallback('{Eval("id")}'); popupRefundDetails.Show();\" style='color: #d9534f; font-family: Cairo; text-decoration: underline;'>عرض المبلغ المرتجع</a>"
                    : "<span style='color: #888; font-family: Cairo;'>لا يوجد</span>"
                                                %>
                                            </DataItemTemplate>
                                            <EditFormSettings Visible="False" />
                                            <CellStyle VerticalAlign="Middle" HorizontalAlign="Center" />
                                        </dx:GridViewDataColumn>





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

                                <asp:SqlDataSource
                                    ID="db_orderStatus"
                                    runat="server"
                                    ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>"
                                    SelectCommand="SELECT id, description FROM L_OrderStatus" />

                                <asp:SqlDataSource
                                    ID="dsCountries"
                                    runat="server"
                                    ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>"
                                    SelectCommand="SELECT id, countryName,countryCode FROM countries where id <>100"></asp:SqlDataSource>
                                <asp:SqlDataSource
                                    ID="dsCompanies"
                                    runat="server"
                                    ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>"
                                    SelectCommand="SELECT id, companyName FROM companies"></asp:SqlDataSource>

                                <asp:SqlDataSource
                                    ID="dsBranches"
                                    runat="server"
                                    ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>"
                                    SelectCommand="SELECT id, name, companyId FROM branches"></asp:SqlDataSource>

                                <asp:SqlDataSource
                                    ID="dsOrders"
                                    runat="server"
                                    ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>"
                                    SelectCommand="
SELECT 
    o.[id], 
    o.[companyId], 
    c.[countryID] AS countryId, 
    c.[companyName] AS companyName, 
    co.[countryName] AS countryName,
    o.[username], 
    u.[firstName] + ' ' + u.[lastName] AS fullName,
    o.[addressId], 
    o.[amount], 
    o.[deliveryAmount], 
    o.[taxAmount], 
    o.[totalAmount], 
    o.[couponId], 
    o.[l_paymentMethodId],
    o.[l_RefundType],
    pm.[description] AS paymentMethod, 
    br.[name] AS branchName, 
    o.[transactionId], 
    o.[invoiceNo], 
    o.[notes], 
    o.[l_orderStatus], 
    os.[description] AS orderStatus,  
    o.[refundedAmount], 
    o.[realTotalAmount], 
    o.[realTax], 
    o.[userDate]
FROM 
    [Orders] o
JOIN 
    [companies] c ON o.companyId = c.id
LEFT JOIN 
    l_paymentMethod pm ON o.l_paymentMethodId = pm.id
LEFT JOIN 
    branches br ON o.branchId = br.id
LEFT JOIN 
    countries co ON c.countryID = co.id
LEFT JOIN 
    l_orderStatus os ON o.l_orderStatus = os.id
LEFT JOIN 
    [usersApp] u ON o.username = u.username
WHERE 
    o.l_orderStatus = 4
    AND (co.id = @countryId OR @countryId = 0 )
    AND (c.id = @companyId OR @companyId = 0 )
    AND (br.id = @branchId OR @branchId = 0 )
    AND o.userDate BETWEEN @dateFrom AND @dateTo
ORDER BY o.id DESC">
                                    <SelectParameters>
                                        <asp:Parameter Name="countryId" DefaultValue="0" />
                                        <asp:Parameter Name="companyId" DefaultValue="0" />
                                        <asp:Parameter Name="branchId" DefaultValue="0" />
                                        <asp:Parameter Name="dateFrom" Type="DateTime" />
                                        <asp:Parameter Name="dateTo" Type="DateTime" />
                                    </SelectParameters>
                                </asp:SqlDataSource>



                                <dx:ASPxPopupControl ID="popupRefundDetails" runat="server"
                                    ClientInstanceName="popupRefundDetails"
                                    Width="500px" HeaderText="تفاصيل الاسترجاع"
                                    ShowCloseButton="true" Font-Names="Cairo" PopupHorizontalAlign="WindowCenter"
                                    PopupVerticalAlign="WindowCenter" Modal="true">
                                    <ClientSideEvents Shown="function(s,e){ s.UpdatePosition()}" />
                                    <ContentCollection>
                                        <dx:PopupControlContentControl>
                                            <dx:ASPxCallbackPanel ID="callbackRefundDetails" runat="server"
                                                ClientInstanceName="callbackRefundDetails"
                                                OnCallback="callbackRefundDetails_Callback">
                                                <PanelCollection>
                                                    <dx:PanelContent>
                                                        <asp:Label ID="lblRefundDetails" runat="server" Font-Names="Cairo" Font-Size="Medium" />
                                                    </dx:PanelContent>
                                                </PanelCollection>
                                            </dx:ASPxCallbackPanel>
                                        </dx:PopupControlContentControl>
                                    </ContentCollection>
                                </dx:ASPxPopupControl>
                            </div>




                        </dx:ContentControl>
                    </ContentCollection>
                </dx:TabPage>
                <dx:TabPage Text="دفعات المستخدمين" TabStyle-Font-Bold="true" TabStyle-Font-Names="cairo" TabStyle-Font-Size="X-Large">
                    <TabStyle Font-Bold="True" Font-Names="cairo" Font-Size="X-Large"></TabStyle>
                    <ContentCollection>
                        <dx:ContentControl runat="server">
                            <div class="navbar-main navbar-expand-lg px-0 mx-4 border-radius-xl bg-white shadow mt-3 mb-1">

                                <div style="display: flex; flex-wrap: wrap; gap: 15px; align-items: center; justify-content: center; padding-top: 25px;">

                                    <dx:ASPxComboBox
                                        ID="CountryList5"
                                        runat="server"
                                        Font-Names="Cairo"
                                        Width="240px"
                                        TextField="countryName"
                                        ValueField="id"
                                        DataSourceID="dsCountries"
                                        NullText="اختر الدولة"
                                        Font-Bold="True"
                                        Font-Size="Medium"
                                        ClientInstanceName="cmbCountry5">
                                        <ClientSideEvents SelectedIndexChanged="function(s,e){ cbpCompany5.PerformCallback(s.GetValue()); }" />
                                    </dx:ASPxComboBox>

                                    <dx:ASPxCallbackPanel ID="cbpCompany5" runat="server" ClientInstanceName="cbpCompany5" OnCallback="cbpCompany_Callback">
                                        <PanelCollection>
                                            <dx:PanelContent>
                                                <dx:ASPxComboBox
                                                    ID="CompanyList5"
                                                    runat="server"
                                                    Font-Names="Cairo"
                                                    Width="240px"
                                                    TextField="companyName"
                                                    ValueField="id"
                                                    DataSourceID="dsCompanies"
                                                    NullText="اختر الشركة"
                                                    Font-Bold="True"
                                                    Font-Size="Medium"
                                                    ClientInstanceName="cmbCompany5">
                                                </dx:ASPxComboBox>
                                            </dx:PanelContent>
                                        </PanelCollection>
                                    </dx:ASPxCallbackPanel>
                                </div>

                                <div style="display: flex; flex-wrap: wrap; gap: 15px; align-items: center; justify-content: center; margin-top: 15px;">

                                    <dx:ASPxDateEdit
                                        ID="DateFrom5"
                                        runat="server"
                                        Width="200px"
                                        NullText="من تاريخ"
                                        Font-Names="Cairo"
                                        Font-Bold="True"
                                        Font-Size="Medium"
                                        ClientInstanceName="dateFrom5"
                                        EditFormat="Date"
                                        DisplayFormatString="yyyy-MM-dd">
                                        <ClientSideEvents ValueChanged="function(s, e) {
                                            var fromDate = s.GetDate();
                                            if (fromDate) {
                                                dateTo.SetMinDate(fromDate);
                                            }
                                        }" />
                                    </dx:ASPxDateEdit>

                                    <dx:ASPxDateEdit
                                        ID="DateTo5"
                                        runat="server"
                                        Width="200px"
                                        NullText="إلى تاريخ"
                                        Font-Names="Cairo"
                                        Font-Bold="True"
                                        Font-Size="Medium"
                                        ClientInstanceName="dateTo5"
                                        EditFormat="Date"
                                        DisplayFormatString="yyyy-MM-dd">
                                    </dx:ASPxDateEdit>


                                    <dx:ASPxButton
                                        ID="btnSearch5"
                                        runat="server"
                                        Text="بحث"
                                        AutoPostBack="False"
                                        Width="140px"
                                        Font-Names="Cairo"
                                        Font-Size="Medium"
                                        CssClass="rounded-xl"
                                        Font-Bold="true"
                                        ClientInstanceName="btnSearch5"
                                        Theme="Moderno">
                                        <Image Url="~/assets/img/search.png" />
                                        <ClientSideEvents Click="function(s,e){
                                            GridPayments.PerformCallback();
                                        }" />
                                    </dx:ASPxButton>

                                    <dx:ASPxButton
                                        ID="btnReset5"
                                        runat="server"
                                        Text="مسح"
                                        AutoPostBack="False"
                                        Width="140px"
                                        Font-Names="Cairo"
                                        Font-Size="Medium"
                                        CssClass="rounded-xl"
                                        ClientInstanceName="btnReset"
                                        Theme="Moderno">
                                        <Image Url="~/assets/img/reset.png" />
                                        <ClientSideEvents Click="function(s,e){
                                            cmbCountry5.SetValue(null);
                                            cmbCompany5.SetValue(null);
                                            dateFrom5.SetValue(null);
                                            dateTo5.SetValue(null);

                                            GridPayments.PerformCallback('Cancel');
                                        }" />
                                    </dx:ASPxButton>
                                </div>

                                <dx:ASPxGridView ID="GridPayments" runat="server" DataSourceID="dsPayments" KeyFieldName="id" ClientInstanceName="GridPayments" Width="100%" AutoGenerateColumns="False" EnablePagingCallbackAnimation="True" Font-Names="cairo" Font-Bold="True"
                                    Font-Size="0.77em" RightToLeft="True" OnCustomCallback="GridPayments_CustomCallback" OnBeforePerformDataSelect="GridPayments_BeforePerformDataSelect">
                                    <Settings ShowFooter="True" ShowFilterRow="True" />

                                    <Styles>
                                        <PagerBottomPanel Font-Names="Cairo" Font-Size="Large" Font-Bold="true"></PagerBottomPanel>
                                    </Styles>


                                    <ClientSideEvents RowClick="function(s, e) {OnRowClick(e);}" />
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
                                    <SettingsText SearchPanelEditorNullText="ابحث في الجدول..." EmptyDataRow="لا يوجد" />
                                    <Columns>
                                        <dx:GridViewDataColumn Caption="الرقم" FieldName="id">
                                            <EditFormSettings Visible="False" />
                                            <CellStyle VerticalAlign="Middle" HorizontalAlign="Center" />
                                        </dx:GridViewDataColumn>

                                        <dx:GridViewDataColumn Caption="المستخدم" FieldName="username">
                                            <DataItemTemplate>
                                                <div style="font-family: Cairo; text-align: center;">
                                                    <div style="font-weight: bold;"><%# Eval("fullName") %></div>
                                                    <div style="color: #888; font-size: 12px;"><%# Eval("username") %></div>
                                                </div>
                                            </DataItemTemplate>
                                            <CellStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                        </dx:GridViewDataColumn>

                                        <dx:GridViewDataComboBoxColumn Caption="الشركة / الدولة" FieldName="companyId">
                                            <PropertiesComboBox
                                                DataSourceID="dsCompanies"
                                                TextField="companyName"
                                                ValueField="id"
                                                DropDownStyle="DropDownList"
                                                EnableCallbackMode="false">
                                            </PropertiesComboBox>

                                            <DataItemTemplate>
                                                <%# Eval("countryName") + " - " + Eval("companyName")  %>
                                            </DataItemTemplate>

                                            <CellStyle VerticalAlign="Middle" HorizontalAlign="Center" />
                                        </dx:GridViewDataComboBoxColumn>

                                        <dx:GridViewDataColumn Caption="المبلغ" FieldName="amount">
                                            <DataItemTemplate>
                                                <%# Eval("amount") + "</br>" + GetCurrency(Eval("countryId")) %>
                                            </DataItemTemplate>
                                            <EditFormSettings Visible="False" />
                                            <CellStyle VerticalAlign="Middle" HorizontalAlign="Center" />
                                        </dx:GridViewDataColumn>

                                        <dx:GridViewDataColumn Caption="العملة" FieldName="currency">
                                            <EditFormSettings Visible="False" />
                                            <CellStyle VerticalAlign="Middle" HorizontalAlign="Center" />
                                        </dx:GridViewDataColumn>

                                        <dx:GridViewDataColumn Caption="رقم العملية" FieldName="creditId">
                                            <EditFormSettings Visible="False" />
                                            <CellStyle VerticalAlign="Middle" HorizontalAlign="Center" />
                                        </dx:GridViewDataColumn>

                                        <dx:GridViewDataColumn Caption="رقم الطلب" FieldName="orderId">
                                            <EditFormSettings Visible="False" />
                                            <CellStyle VerticalAlign="Middle" HorizontalAlign="Center" />
                                        </dx:GridViewDataColumn>

                                        <dx:GridViewDataColumn Caption="النوع" FieldName="type">
                                            <EditFormSettings Visible="False" />
                                            <CellStyle VerticalAlign="Middle" HorizontalAlign="Center" />
                                        </dx:GridViewDataColumn>

                                        <dx:GridViewDataColumn Caption="الحالة" FieldName="status">
                                            <EditFormSettings Visible="False" />
                                            <CellStyle VerticalAlign="Middle" HorizontalAlign="Center" />
                                        </dx:GridViewDataColumn>

                                        <dx:GridViewDataColumn Caption="الرسالة" FieldName="message">
                                            <EditFormSettings Visible="False" />
                                            <CellStyle VerticalAlign="Middle" HorizontalAlign="Center" />
                                        </dx:GridViewDataColumn>

                                        <dx:GridViewDataColumn Caption="رقم الحركة" FieldName="transactionRef">
                                            <EditFormSettings Visible="False" />
                                            <CellStyle VerticalAlign="Middle" HorizontalAlign="Center" />
                                        </dx:GridViewDataColumn>

                                        <dx:GridViewDataColumn Caption="Live?" FieldName="isLive">
                                            <EditFormSettings Visible="False" />
                                            <CellStyle VerticalAlign="Middle" HorizontalAlign="Center" />
                                        </dx:GridViewDataColumn>

                                        <dx:GridViewDataColumn Caption="XML">
                                            <DataItemTemplate>
                                                <%# !string.IsNullOrEmpty(Eval("XMLResult")?.ToString()) 
                                                ? $"<a href='javascript:void(0);' data-xml-id='{Eval("id")}' onclick='ShowXML(this)' style='color: #337ab7; text-decoration: underline; font-family:Cairo;'>عرض</a>"
                                                : "<span style='color:#999; font-family:Cairo;'>لا يوجد</span>" %>
                                            </DataItemTemplate>
                                            <CellStyle VerticalAlign="Middle" HorizontalAlign="Center" />
                                        </dx:GridViewDataColumn>



                                        <dx:GridViewDataDateColumn FieldName="userDate" Caption="التاريخ">
                                            <PropertiesDateEdit DisplayFormatString="yyyy/MM/dd hh:mm tt" />
                                            <EditFormSettings Visible="False" />
                                            <CellStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                        </dx:GridViewDataDateColumn>

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



                                <asp:SqlDataSource
                                    ID="dsPayments"
                                    runat="server"
                                    ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>"
                                    SelectCommand="
                                    SELECT 
                                        p.[id],
                                        p.[username],
                                        ISNULL(u.[firstName],'') + ' ' + ISNULL(u.[lastName],'') AS fullName,
                                        o.[companyId],
                                        c.[countryID] AS countryId,
                                        co.[countryName] AS countryName,
                                        c.[companyName] AS companyName,
                                        p.[amount],
                                        p.[currency],
                                        p.[creditId],
                                        p.[orderId],
                                        p.[type],
                                        p.[status],
                                        p.[message],
                                        p.[transactionRef],
                                        p.[isLive],
                                        p.[XMLResult],
                                        p.[userDate]
                                    FROM [payments] p
                                    LEFT JOIN Orders o ON p.orderId = o.id
                                    LEFT JOIN companies c ON o.companyId = c.id
                                    LEFT JOIN countries co ON c.countryID = co.id
                                    LEFT JOIN usersApp u ON p.username = u.username  
                                    WHERE
                                        (co.id = @countryId OR @countryId = 0)
                                        AND (c.id = @companyId OR @companyId = 0)
                                        AND p.userDate BETWEEN @dateFrom AND @dateTo
                                    ORDER BY p.id DESC
                                    ">
                                    <SelectParameters>
                                        <asp:Parameter Name="countryId5" DefaultValue="0" />
                                        <asp:Parameter Name="companyId5" DefaultValue="0" />
                                        <asp:Parameter Name="dateFrom5" Type="DateTime" />
                                        <asp:Parameter Name="dateTo5" Type="DateTime" />
                                    </SelectParameters>
                                </asp:SqlDataSource>
                            </div>

                            <dx:ASPxPopupControl ID="popupXML" runat="server"
                                ClientInstanceName="popupXML"
                                HeaderText="عرض XML"
                                PopupHorizontalAlign="WindowCenter"
                                PopupVerticalAlign="WindowCenter"
                                Width="850px"
                                Height="480px"
                                ShowCloseButton="true"
                                Modal="true"
                                Font-Names="Cairo" Font-Size="14px">

                                <ClientSideEvents
                                    CloseUp="function(s,e){
            resetXMLViewer();
        }" />

                                <ContentCollection>
                                    <dx:PopupControlContentControl runat="server">
                                        <dx:ASPxCallbackPanel ID="callbackXML" runat="server" ClientInstanceName="callbackXML" OnCallback="callbackXML_Callback">
                                            <PanelCollection>
                                                <dx:PanelContent runat="server"
                                                    Style="padding: 10px; background: #1e1e1e; height: 100%; box-sizing: border-box;">
                                                    <textarea id="xmlContent" runat="server"
                                                        style="width: 100%; height: 550px; font-family: 'Cairo', monospace; text-align: left;"></textarea>
                                                </dx:PanelContent>
                                            </PanelCollection>
                                        </dx:ASPxCallbackPanel>
                                    </dx:PopupControlContentControl>
                                </ContentCollection>
                            </dx:ASPxPopupControl>


                            <!-- CodeMirror CSS & JS -->
                            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.12/codemirror.min.css">
                            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.12/theme/dracula.min.css">
                            <!-- ثيم داكن جميل -->
                            <script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.12/codemirror.min.js"></script>
                            <script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.12/mode/xml/xml.min.js"></script>

                            <style>
                                /* تحسين مظهر CodeMirror */
                                .CodeMirror {
                                    height: 100% !important;
                                    width: 100% !important;
                                    font-size: 16px;
                                    direction: ltr; /* لمحاذاة النص لليسار */
                                    text-align: left;
                                    border-radius: 8px;
                                    overflow: auto;
                                }
                            </style>

                            <script>
                                function initCodeMirror() {
                                    if (!window.editor) {
                                        window.editor = CodeMirror.fromTextArea(document.getElementById('<%= xmlContent.ClientID %>'), {
                                            mode: "application/xml",
                                            lineNumbers: true,
                                            readOnly: true,
                                            theme: "dracula", // ثيم داكن جميل
                                            lineWrapping: true,
                                            matchBrackets: true, // تمييز الأقواس
                                            autoCloseTags: true
                                        });
                                    } else {
                                        window.editor.refresh();
                                    }
                                }
                                function resetXMLViewer() {
                                    // مسح محتوى الـtextarea
                                    document.getElementById('<%= xmlContent.ClientID %>').value = '';

                                    // مسح محتوى CodeMirror إذا تم تهيئته
                                    if (window.editor) {
                                        window.editor.setValue('');
                                        window.editor.refresh();
                                    }

                                    // إعادة تعيين أي علامات مخصصة للـCallback
                                    callbackXML.cp_refreshEditor = null;
                                }
                                callbackXML.EndCallback.AddHandler(function (s, e) {
                                    if (s.cp_refreshEditor) {
                                        var textarea = document.getElementById('<%= xmlContent.ClientID %>');
                                        if (textarea) {
                                            // إذا كان هناك محرر سابق، نعيده إلى textarea الأصلي
                                            if (window.editor) {
                                                try {
                                                    window.editor.toTextArea();
                                                } catch { }
                                                window.editor = null;
                                            }

                                            // إنشاء محرر جديد مرتبط بالـtextarea الحالي في DOM
                                            window.editor = CodeMirror.fromTextArea(textarea, {
                                                mode: "application/xml",
                                                lineNumbers: true,
                                                readOnly: true,
                                                theme: "dracula",
                                                lineWrapping: true,
                                                matchBrackets: true,
                                                autoCloseTags: true
                                            });

                                            // تعيين القيمة
                                            window.editor.setValue(textarea.value);
                                        }

                                        s.cp_refreshEditor = null;
                                    }
                                });


                            </script>


                        </dx:ContentControl>
                    </ContentCollection>
                </dx:TabPage>
                <dx:TabPage Text="الطلبات" TabStyle-Font-Bold="true" TabStyle-Font-Names="cairo" TabStyle-Font-Size="X-Large">
                    <TabStyle Font-Bold="True" Font-Names="cairo" Font-Size="X-Large"></TabStyle>
                    <ContentCollection>
                        <dx:ContentControl runat="server">
                            <div class="navbar-main navbar-expand-lg px-0 mx-4 border-radius-xl bg-white shadow mt-3 mb-1">

                                <div style="display: flex; flex-wrap: wrap; gap: 15px; align-items: center; justify-content: center; padding-top: 25px;">
                                    <dx:ASPxComboBox
                                        ID="StatusList"
                                        runat="server"
                                        Font-Names="Cairo"
                                        Width="240px"
                                        TextField="description"
                                        ValueField="id"
                                        DataSourceID="dsStatus"
                                        NullText="اختر الحالة"
                                        Font-Bold="True"
                                        Font-Size="Medium"
                                        ClientInstanceName="StatusList">
                                        <ClientSideEvents SelectedIndexChanged="function(s,e){ cbpCompany.PerformCallback(s.GetValue()); }" />
                                    </dx:ASPxComboBox>

                                    <dx:ASPxComboBox
                                        ID="PaymentMethodList"
                                        runat="server"
                                        Font-Names="Cairo"
                                        Width="240px"
                                        TextField="description"
                                        ValueField="id"
                                        DataSourceID="dsPaymentMethod"
                                        NullText="اختر وسيلة الدفع"
                                        Font-Bold="True"
                                        Font-Size="Medium"
                                        ClientInstanceName="PaymentMethodList">
                                        <ClientSideEvents SelectedIndexChanged="function(s,e){ cbpCompany.PerformCallback(s.GetValue()); }" />
                                    </dx:ASPxComboBox>
                                </div>

                                <div style="display: flex; flex-wrap: wrap; gap: 15px; align-items: center; justify-content: center; padding-top: 10px;">

                                    <dx:ASPxDateEdit
                                        ID="DateFrom1"
                                        runat="server"
                                        Width="200px"
                                        NullText="من تاريخ"
                                        Font-Names="Cairo"
                                        Font-Bold="True"
                                        Font-Size="Medium"
                                        ClientInstanceName="dateFrom1">
                                        <ClientSideEvents ValueChanged="function(s, e) {
                                            var fromDate = s.GetDate();
                                            if (fromDate) {
                                                dateTo1.SetMinDate(fromDate);
                                            }
                                        }" />
                                    </dx:ASPxDateEdit>

                                    <dx:ASPxDateEdit
                                        ID="DateTo1"
                                        runat="server"
                                        Width="200px"
                                        NullText="إلى تاريخ"
                                        Font-Names="Cairo"
                                        Font-Bold="True"
                                        Font-Size="Medium"
                                        ClientInstanceName="dateTo1">
                                    </dx:ASPxDateEdit>


                                    <dx:ASPxButton
                                        ID="ButtonSearch1"
                                        runat="server"
                                        Text="بحث"
                                        AutoPostBack="False"
                                        Width="140px"
                                        Font-Names="Cairo"
                                        Font-Size="Medium"
                                        CssClass="rounded-xl"
                                        ClientInstanceName="btnSearch"
                                        Font-Bold="true"
                                        Theme="Moderno">
                                        <Image Url="~/assets/img/search.png" />
                                        <ClientSideEvents Click="function(s,e){
                                            GridOrdersInfo.PerformCallback();
                                        }" />
                                    </dx:ASPxButton>

                                    <dx:ASPxButton
                                        ID="ButtonReset1"
                                        runat="server"
                                        Text="مسح"
                                        AutoPostBack="False"
                                        Width="140px"
                                        Font-Names="Cairo"
                                        Font-Size="Medium"
                                        CssClass="rounded-xl"
                                        ClientInstanceName="btnReset"
                                        Theme="Moderno">
                                        <Image Url="~/assets/img/reset.png" />
                                        <ClientSideEvents Click="function(s,e){
                                            StatusList.SetValue(null);
                                            PaymentMethodList.SetValue(null);
                                            dateFrom1.SetValue(null);
                                            dateTo1.SetValue(null);

                                            GridOrdersInfo.PerformCallback('0|0||');
                                        }" />
                                    </dx:ASPxButton>
                                </div>

                                <dx:ASPxGridView ID="GridOrdersInfo" runat="server" DataSourceID="dsOrdersInfo" KeyFieldName="id" ClientInstanceName="GridOrdersInfo" Width="100%" AutoGenerateColumns="False" EnablePagingCallbackAnimation="True" Font-Names="cairo" Font-Bold="True"
                                    Font-Size="0.77em" RightToLeft="True" OnCustomCallback="GridOrdersInfo_CustomCallback" OnBeforePerformDataSelect="GridOrdersInfo_BeforePerformDataSelect">
                                    <Settings ShowFooter="True" ShowFilterRow="True" />

                                    <Styles>
                                        <PagerBottomPanel Font-Names="Cairo" Font-Size="Large" Font-Bold="true"></PagerBottomPanel>
                                    </Styles>

                                    <ClientSideEvents RowClick="function(s, e) {OnRowClick(e);}" />
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

                                        <dx:GridViewDataComboBoxColumn Caption="حالة الطلب" FieldName="l_orderStatus">
                                            <PropertiesComboBox
                                                DataSourceID="db_orderStatus"
                                                ValueField="id"
                                                TextField="description"
                                                ValueType="System.Int32">
                                                <ValidationSettings RequiredField-IsRequired="True" ErrorText="يجب تحديد حالة الطلب" />
                                            </PropertiesComboBox>
                                            <DataItemTemplate>
                                                <%# GetOrderStatusLottie(Eval("l_orderStatus").ToString()) %>
                                            </DataItemTemplate>
                                            <CellStyle VerticalAlign="Middle" HorizontalAlign="Center" />
                                        </dx:GridViewDataComboBoxColumn>

                                        <dx:GridViewDataColumn Caption="المستخدم" FieldName="username">
                                            <DataItemTemplate>
                                                <div style="font-family: Cairo; text-align: center;">
                                                    <div style="font-weight: bold;"><%# Eval("fullName") %></div>
                                                    <div style="color: #888; font-size: 12px;"><%# Eval("username") %></div>
                                                </div>
                                            </DataItemTemplate>
                                            <CellStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                        </dx:GridViewDataColumn>

                                        <dx:GridViewDataComboBoxColumn Caption="الشركة / الدولة" FieldName="companyId">
                                            <PropertiesComboBox
                                                DataSourceID="dsCompanies"
                                                TextField="companyName"
                                                ValueField="id"
                                                DropDownStyle="DropDownList"
                                                EnableCallbackMode="false">
                                            </PropertiesComboBox>

                                            <DataItemTemplate>
                                                <%# Eval("countryName") + " - " + Eval("companyName")  %>
                                            </DataItemTemplate>

                                            <CellStyle VerticalAlign="Middle" HorizontalAlign="Center" />
                                        </dx:GridViewDataComboBoxColumn>

                                        <dx:GridViewDataColumn Caption="الفرع" FieldName="branchName">
                                            <EditFormSettings Visible="False" />
                                            <CellStyle VerticalAlign="Middle" HorizontalAlign="Center">
                                            </CellStyle>
                                        </dx:GridViewDataColumn>

                                        <dx:GridViewDataColumn Caption="زمن الوصول" FieldName="maxDeliveryTime">
                                            <DataItemTemplate>
                                                <%#"من " + Eval("minDeliveryTime") + " الى " + Eval("maxDeliveryTime") + " دقيقة" %>
                                            </DataItemTemplate>
                                            <EditFormSettings Visible="False" />
                                            <CellStyle VerticalAlign="Middle" HorizontalAlign="Center">
                                            </CellStyle>
                                        </dx:GridViewDataColumn>

                                        <dx:GridViewDataColumn Caption="طريقة الدفع" FieldName="paymentMethod">
                                            <EditFormSettings Visible="False" />
                                            <CellStyle VerticalAlign="Middle" HorizontalAlign="Center">
                                            </CellStyle>
                                        </dx:GridViewDataColumn>

                                        <dx:GridViewDataColumn Caption="ملاحظات" FieldName="notes">
                                            <EditFormSettings Visible="False" />
                                            <CellStyle VerticalAlign="Middle" HorizontalAlign="Center">
                                            </CellStyle>
                                        </dx:GridViewDataColumn>

                                        <dx:GridViewDataColumn Caption="المنتجات">
                                            <DataItemTemplate>
                                                <a href="javascript:void(0);" onclick="ShowOrderProducts(<%# Eval("id") %>)"
                                                    title="عرض المنتجات">
                                                    <img src="/assets/img/details.png" alt="عرض المنتجات" style="width: 24px; height: 24px;" />
                                                </a>
                                            </DataItemTemplate>
                                            <EditFormSettings Visible="False" />
                                            <CellStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                        </dx:GridViewDataColumn>

                                        <dx:GridViewDataDateColumn FieldName="userDate" Caption="التاريخ">
                                            <PropertiesDateEdit DisplayFormatString="yyyy/MM/dd hh:mm tt" />
                                            <EditFormSettings Visible="False" />
                                            <CellStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                        </dx:GridViewDataDateColumn>

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
                                    ID="dsStatus"
                                    runat="server"
                                    ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>"
                                    SelectCommand="SELECT id, description FROM L_OrderStatus"></asp:SqlDataSource>

                                <asp:SqlDataSource
                                    ID="dsPaymentMethod"
                                    runat="server"
                                    ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>"
                                    SelectCommand="SELECT id, description FROM L_PaymentMethod"></asp:SqlDataSource>

                                <asp:SqlDataSource
                                    ID="dsOrdersInfo"
                                    runat="server"
                                    ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>"
                                    SelectCommand="
SELECT 
    o.[id], 
    o.[companyId], 
    c.[countryID] AS countryId, 
    c.[companyName] AS companyName, 
    co.[countryName] AS countryName,
    o.[username], 
    u.[firstName] + ' ' + u.[lastName] AS fullName,
    o.[addressId], 
    o.[amount], 
    o.[deliveryAmount], 
    o.[taxAmount], 
    o.[totalAmount], 
    o.[couponId], 
    o.[l_paymentMethodId],
    o.[l_RefundType],
    pm.[description] AS paymentMethod, 
    br.[name] AS branchName, 
    o.[transactionId], 
    o.[invoiceNo], 
    o.[notes], 
    o.[l_orderStatus], 
    os.[description] AS orderStatus,  
    o.[refundedAmount], 
    o.[realTotalAmount], 
    c.[maxDeliveryTime],
    c.[minDeliveryTime],
    o.[realTax], 
    o.[userDate]
FROM 
    [Orders] o
JOIN 
    [companies] c ON o.companyId = c.id
LEFT JOIN 
    l_paymentMethod pm ON o.l_paymentMethodId = pm.id
LEFT JOIN 
    branches br ON o.branchId = br.id
LEFT JOIN 
    countries co ON c.countryID = co.id
LEFT JOIN 
    l_orderStatus os ON o.l_orderStatus = os.id
LEFT JOIN 
    [usersApp] u ON o.username = u.username
WHERE 
    (o.l_orderStatus = @StatusId OR @StatusId = 0 )
    AND (o.l_paymentMethodId = @PaymentMethodId OR @PaymentMethodId = 0 )
    AND o.userDate BETWEEN @dateFrom1 AND @dateTo1
ORDER BY o.id DESC">
                                    <SelectParameters>
                                        <asp:Parameter Name="StatusId" DefaultValue="0" />
                                        <asp:Parameter Name="PaymentMethodId" DefaultValue="0" />
                                        <asp:Parameter Name="dateFrom1" Type="DateTime" />
                                        <asp:Parameter Name="dateTo1" Type="DateTime" />
                                    </SelectParameters>
                                </asp:SqlDataSource>

                            </div>
                        </dx:ContentControl>
                    </ContentCollection>
                </dx:TabPage>

                <dx:TabPage Text="مصروفات المستخدمين" TabStyle-Font-Bold="true" TabStyle-Font-Names="cairo" TabStyle-Font-Size="X-Large">
                    <TabStyle Font-Bold="True" Font-Names="cairo" Font-Size="X-Large"></TabStyle>
                    <ContentCollection>
                        <dx:ContentControl>

                            <div class="navbar-main navbar-expand-lg px-0 mx-4 border-radius-xl bg-white shadow mt-3 mb-1">
                                <div style="display: flex; flex-wrap: wrap; gap: 15px; align-items: center; justify-content: center; padding-top: 25px;">
                                    <dx:ASPxComboBox
                                        ID="CountryList1"
                                        runat="server"
                                        Font-Names="Cairo"
                                        Width="240px"
                                        TextField="countryName"
                                        ValueField="countryCode"
                                        DataSourceID="dsCountries"
                                        AutoPostBack="false"
                                        NullText="اختر الدولة"
                                        Font-Bold="True"
                                        Font-Size="Medium"
                                        ClientInstanceName="cmbCountry1">
                                    </dx:ASPxComboBox>

                                    <dx:ASPxComboBox
                                        ID="Buyers"
                                        runat="server"
                                        Font-Names="Cairo"
                                        Width="240px"
                                        NullText="اختر الخيار"
                                        Font-Bold="True"
                                        Font-Size="Medium"
                                        ClientInstanceName="buyers">
                                        <Items>
                                            <dx:ListEditItem Text="أعلى المشتريين" Value="1" />
                                            <dx:ListEditItem Text="الذين ليس لديهم طلبات" Value="2" />
                                        </Items>
                                    </dx:ASPxComboBox>


                                    <dx:ASPxDateEdit
                                        ID="DateFrom2"
                                        runat="server"
                                        Width="200px"
                                        NullText="من تاريخ"
                                        Font-Names="Cairo"
                                        Font-Bold="True"
                                        Font-Size="Medium"
                                        ClientInstanceName="dateFrom2">
                                        <ClientSideEvents ValueChanged="function(s, e) {
                                            var fromDate = s.GetDate();
                                            if (fromDate) {
                                                dateTo2.SetMinDate(fromDate);
                                            }
                                        }" />
                                    </dx:ASPxDateEdit>

                                    <dx:ASPxDateEdit
                                        ID="DateTo2"
                                        runat="server"
                                        Width="200px"
                                        NullText="إلى تاريخ"
                                        Font-Names="Cairo"
                                        Font-Bold="True"
                                        Font-Size="Medium"
                                        ClientInstanceName="dateTo2">
                                    </dx:ASPxDateEdit>

                                </div>

                                <div style="display: flex; flex-wrap: wrap; gap: 15px; align-items: center; justify-content: center; margin-top: 15px;">

                                    <dx:ASPxButton
                                        ID="ButtonSearchUsers"
                                        runat="server"
                                        Text="بحث"
                                        AutoPostBack="False"
                                        Width="140px"
                                        Font-Names="Cairo"
                                        Font-Size="Medium"
                                        CssClass="rounded-xl"
                                        Font-Bold="true"
                                        ClientInstanceName="btnSearchUsers"
                                        Theme="Moderno">
                                        <Image Url="~/assets/img/search.png" />
                                        <ClientSideEvents Click="function(s,e){
    var option = buyers.GetValue() || '0';
    var country = cmbCountry1.GetValue() || '0';
    
    var fromDate = dateFrom2.GetDate();
    var toDate = dateTo2.GetDate();

    if(!fromDate) fromDate = new Date(2025, 0, 1);
    if(!toDate) toDate = new Date();

    var from = fromDate.toISOString().split('T')[0];
    var to = toDate.toISOString().split('T')[0];

    GridAppUsers.PerformCallback(option + '|' + country + '|' + from + '|' + to);
}" />

                                    </dx:ASPxButton>

                                    <dx:ASPxButton
                                        ID="ButtonResetUsers"
                                        runat="server"
                                        Text="مسح"
                                        AutoPostBack="False"
                                        Width="140px"
                                        Font-Names="Cairo"
                                        Font-Size="Medium"
                                        CssClass="rounded-xl"
                                        ClientInstanceName="btnResetUsers"
                                        Theme="Moderno">
                                        <Image Url="~/assets/img/reset.png" />
                                        <ClientSideEvents Click="function(s,e){
        buyers.SetValue(null);
        cmbCountry1.SetValue(null);
        dateFrom2.SetValue(null);
        dateTo2.SetValue(null);
        
        // إعادة تحميل الكل بالافتراضي من 1/1/2025 لليوم
        var fromDate = new Date(2025, 0, 1);
        var toDate = new Date();
        var from = fromDate.toISOString().split('T')[0];
        var to = toDate.toISOString().split('T')[0];

        GridAppUsers.PerformCallback('All|0|' + from + '|' + to);
    }" />
                                    </dx:ASPxButton>


                                </div>
                                <dx:ASPxGridView ID="GridAppUsers" runat="server" DataSourceID="db_AppUsers" KeyFieldName="id" ClientInstanceName="GridAppUsers" Width="100%" AutoGenerateColumns="False" EnablePagingCallbackAnimation="True" Font-Names="cairo" Font-Size="1em" RightToLeft="True" OnHtmlDataCellPrepared="GridUsers_HtmlDataCellPrepared" OnBeforePerformDataSelect="GridAppUsers_BeforePerformDataSelect" OnCustomCallback="GridAppUsers_CustomCallback">
                                    <Settings ShowFooter="True" ShowFilterRow="True" />

                                    <Styles>
                                        <PagerBottomPanel Font-Names="Cairo" Font-Size="Large" Font-Bold="true"></PagerBottomPanel>
                                    </Styles>

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

                                    <SettingsSearchPanel CustomEditorID="tbToolbarSearch3" />

                                    <SettingsExport EnableClientSideExportAPI="true" ExcelExportMode="WYSIWYG" PaperKind="A4" RightToLeft="True" />
                                    <SettingsLoadingPanel Text="Please Wait &amp;hellip;" Mode="ShowAsPopup" />
                                    <SettingsText SearchPanelEditorNullText="ابحث في الجدول..." EmptyDataRow="لا يوجد" />
                                    <Columns>
                                        <dx:GridViewDataColumn Caption="الرقم" FieldName="id">
                                            <EditFormSettings Visible="False" />
                                            <CellStyle VerticalAlign="Middle" Font-Size="Large" HorizontalAlign="Center" />
                                        </dx:GridViewDataColumn>

                                        <dx:GridViewDataTextColumn Caption="رمز الدولة" FieldName="countryCode">

                                            <EditFormSettings Visible="False" />
                                            <CellStyle VerticalAlign="Middle" Font-Size="Large" HorizontalAlign="Center" />

                                        </dx:GridViewDataTextColumn>

                                        <dx:GridViewDataTextColumn Caption="الاسم الأول" FieldName="firstName">

                                            <EditFormSettings Visible="False" />
                                            <CellStyle VerticalAlign="Middle" Font-Size="Large" HorizontalAlign="Center" />

                                        </dx:GridViewDataTextColumn>

                                        <dx:GridViewDataTextColumn Caption="الاسم الأخير" FieldName="lastName">

                                            <EditFormSettings Visible="False" />
                                            <CellStyle VerticalAlign="Middle" Font-Size="Large" HorizontalAlign="Center" />

                                        </dx:GridViewDataTextColumn>

                                        <dx:GridViewDataTextColumn Caption="اسم المستخدم" FieldName="username">

                                            <EditFormSettings Visible="False" />
                                            <CellStyle VerticalAlign="Middle" Font-Size="Large" HorizontalAlign="Center" />

                                        </dx:GridViewDataTextColumn>

                                        <dx:GridViewDataComboBoxColumn Caption="مفعل؟" FieldName="isActive">
                                            <PropertiesComboBox ValueType="System.Boolean">
                                                <Items>
                                                    <dx:ListEditItem Text="فعال" Value="True" />
                                                    <dx:ListEditItem Text="موقوف" Value="False" />
                                                </Items>
                                                <ValidationSettings RequiredField-IsRequired="true" ErrorText="هذا الحقل مطلوب">
                                                    <RequiredField IsRequired="True"></RequiredField>
                                                </ValidationSettings>
                                            </PropertiesComboBox>
                                            <CellStyle VerticalAlign="Middle" Font-Size="Large" HorizontalAlign="Center" />

                                        </dx:GridViewDataComboBoxColumn>

                                        <dx:GridViewDataSpinEditColumn Caption="الرصيد" FieldName="balance">
                                            <DataItemTemplate>
                                                <%# Eval("balance") + "</br>" + MainHelper.GetCurrency(Eval("countryId")) %>
                                            </DataItemTemplate>
                                            <PropertiesSpinEdit
                                                MinValue="0"
                                                MaxValue="9999.99"
                                                NumberType="Float"
                                                Increment="0.01"
                                                DecimalPlaces="2"
                                                DisplayFormatString="N2" />
                                            <EditCellStyle HorizontalAlign="Center" />
                                            <CellStyle VerticalAlign="Middle" Font-Size="Large" HorizontalAlign="Center" />

                                            <EditFormSettings ColumnSpan="1" />
                                        </dx:GridViewDataSpinEditColumn>

                                        <dx:GridViewDataColumn Caption="توصيل مجاني" FieldName="freeDeliveryCount">
                                            <EditFormSettings Visible="False" />
                                            <CellStyle VerticalAlign="Middle" Font-Size="Large" HorizontalAlign="Center" />
                                        </dx:GridViewDataColumn>

                                        <dx:GridViewDataColumn Caption="المبلغ الاجمالي" FieldName="TotalAmount">
                                            <DataItemTemplate>
                                                <%# Eval("TotalAmount") + "</br>" + MainHelper.GetCurrency(Eval("countryId")) %>
                                            </DataItemTemplate>
                                            <EditFormSettings Visible="False" />
                                            <CellStyle VerticalAlign="Middle" Font-Size="Large" Font-Bold="true" HorizontalAlign="Center" />
                                        </dx:GridViewDataColumn>

                                        <dx:GridViewDataColumn Caption="عدد الطلبات" FieldName="OrderCount">
                                            <EditFormSettings Visible="False" />
                                            <CellStyle VerticalAlign="Middle" Font-Size="Large" HorizontalAlign="Center" />
                                        </dx:GridViewDataColumn>


                                        <dx:GridViewDataComboBoxColumn Caption="المستوى" FieldName="l_userLevelId">
                                            <PropertiesComboBox
                                                DataSourceID="db_UserLevel"
                                                TextField="description"
                                                ValueField="id">
                                                <ValidationSettings RequiredField-IsRequired="true" ErrorText="هذا الحقل مطلوب">
                                                    <RequiredField IsRequired="True"></RequiredField>
                                                </ValidationSettings>
                                            </PropertiesComboBox>
                                        </dx:GridViewDataComboBoxColumn>

                                        <dx:GridViewDataComboBoxColumn Caption="توثيق ثنائي؟" FieldName="twoAuthenticationEnabled">
                                            <PropertiesComboBox ValueType="System.Boolean">
                                                <Items>
                                                    <dx:ListEditItem Text="نعم" Value="True" />
                                                    <dx:ListEditItem Text="لا" Value="False" />
                                                </Items>
                                                <ValidationSettings RequiredField-IsRequired="true" ErrorText="هذا الحقل مطلوب">
                                                    <RequiredField IsRequired="True"></RequiredField>
                                                </ValidationSettings>
                                            </PropertiesComboBox>
                                            <EditFormSettings Visible="False" />
                                            <CellStyle VerticalAlign="Middle" Font-Size="Large" HorizontalAlign="Center" />

                                        </dx:GridViewDataComboBoxColumn>


                                        <dx:GridViewDataSpinEditColumn Caption="نقاط المستخدم" FieldName="userPoints">
                                            <PropertiesSpinEdit
                                                MinValue="0"
                                                MaxValue="99999"
                                                NumberType="Integer"
                                                Increment="1"
                                                DisplayFormatString="N0" />

                                            <EditCellStyle HorizontalAlign="Center" />
                                            <CellStyle VerticalAlign="Middle" Font-Size="Large" HorizontalAlign="Center" />
                                        </dx:GridViewDataSpinEditColumn>


                                        <dx:GridViewDataTextColumn Caption="المنصة" FieldName="userPlatform">
                                            <PropertiesTextEdit>
                                                <ValidationSettings RequiredField-IsRequired="true" ErrorText="هذا الحقل مطلوب">
                                                    <RequiredField IsRequired="True"></RequiredField>
                                                </ValidationSettings>
                                            </PropertiesTextEdit>
                                            <EditFormSettings Visible="False" />
                                            <CellStyle VerticalAlign="Middle" Font-Size="Large" HorizontalAlign="Center" />

                                        </dx:GridViewDataTextColumn>

                                        <dx:GridViewDataComboBoxColumn Caption="محذوف؟" FieldName="isDeleted">
                                            <PropertiesComboBox ValueType="System.Boolean">
                                                <Items>
                                                    <dx:ListEditItem Text="نعم" Value="True" />
                                                    <dx:ListEditItem Text="لا" Value="False" />
                                                </Items>
                                                <ValidationSettings RequiredField-IsRequired="true" ErrorText="هذا الحقل مطلوب">
                                                    <RequiredField IsRequired="True"></RequiredField>
                                                </ValidationSettings>
                                            </PropertiesComboBox>
                                            <EditFormSettings Visible="False" />
                                            <CellStyle VerticalAlign="Middle" Font-Size="Large" HorizontalAlign="Center" />

                                        </dx:GridViewDataComboBoxColumn>
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
                                                        <dx:ASPxButtonEdit ID="tbToolbarSearch3" runat="server" NullText="البحث..." Width="140" Font-Names="cairo" />
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


                            <asp:SqlDataSource
                                ID="db_AppUsers"
                                runat="server"
                                ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>"
                                SelectCommand="SELECT 
                                    u.id,
                                    u.username,
                                    u.firstName,
                                    u.lastName,
                                    COUNT(CASE WHEN o.id IS NOT NULL 
                                          AND CAST(o.userDate AS DATE) BETWEEN @FromDate2 AND @ToDate2 
                                          THEN o.id END) AS OrderCount,
                                    ISNULL(SUM(CASE WHEN CAST(o.userDate AS DATE) BETWEEN @FromDate2 AND @ToDate2 
                                               THEN o.totalAmount ELSE 0 END), 0) AS TotalAmount,
                                    u.isActive,
                                    u.balance,
                                    u.freeDeliveryCount,
                                    u.l_userLevelId,
                                    u.twoAuthenticationEnabled,
                                    u.userPoints,
                                    u.isDeleted,
                                    LEFT(u.FCMToken, 5) AS FCMToken,
                                    u.userPlatform,
                                    c.countryCode,
                                    c.id AS countryId
                                FROM usersApp u
                                LEFT JOIN orders o ON u.username = o.username
                                LEFT JOIN countries c ON u.countryCode = c.countryCode
                                WHERE (@Country2 = '0' OR u.countryCode = CONVERT(NVARCHAR(50), @Country2))
                                GROUP BY 
                                    u.id, u.username, u.firstName, u.lastName, 
                                    u.isActive, u.balance, u.freeDeliveryCount, u.l_userLevelId,
                                    u.twoAuthenticationEnabled, u.userPoints, u.isDeleted,
                                    u.FCMToken, u.userPlatform, c.countryCode,c.id
                                HAVING 
                                    (
                                        @Option2 = 0 AND SUM(CASE WHEN CAST(o.userDate AS DATE) BETWEEN @FromDate2 AND @ToDate2 THEN o.totalAmount ELSE 0 END) &gt; 0
                                    )
                                    OR (@Option2 = 1 AND COUNT(CASE WHEN o.id IS NOT NULL 
                                        AND CAST(o.userDate AS DATE) BETWEEN @FromDate2 AND @ToDate2 
                                        THEN o.id END) &gt; 0)
                                    OR (@Option2 = 2 AND COUNT(CASE WHEN o.id IS NOT NULL 
                                        AND CAST(o.userDate AS DATE) BETWEEN @FromDate2 AND @ToDate2 
                                        THEN o.id END) = 0)
            
                                ORDER BY  TotalAmount DESC, OrderCount DESC;">
                                <SelectParameters>
                                    <asp:Parameter Name="FromDate2" Type="DateTime" />
                                    <asp:Parameter Name="ToDate2" Type="DateTime" />
                                    <asp:Parameter Name="Country2" Type="String" />
                                    <asp:Parameter Name="Option2" Type="Int32" DefaultValue="0" />
                                </SelectParameters>
                            </asp:SqlDataSource>




                            <asp:SqlDataSource
                                ID="db_UserLevel"
                                runat="server"
                                ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>"
                                SelectCommand="SELECT id, description FROM [L_UserLevel]" />



                        </dx:ContentControl>
                    </ContentCollection>
                </dx:TabPage>
                <dx:TabPage Text="مبيعات الفروع" TabStyle-Font-Bold="true" TabStyle-Font-Names="cairo" TabStyle-Font-Size="X-Large">
                    <TabStyle Font-Bold="True" Font-Names="cairo" Font-Size="X-Large"></TabStyle>
                    <ContentCollection>
                        <dx:ContentControl>

                            <div class="navbar-main navbar-expand-lg px-0 mx-4 border-radius-xl bg-white shadow mt-3 mb-1">

                                <div style="display: flex; flex-wrap: wrap; gap: 15px; align-items: center; justify-content: center; padding-top: 25px;">
                                    <dx:ASPxDateEdit
                                        ID="DateFrom3"
                                        runat="server"
                                        Width="200px"
                                        NullText="من تاريخ"
                                        Font-Names="Cairo"
                                        Font-Bold="True"
                                        Font-Size="Medium"
                                        ClientInstanceName="dateFrom3">
                                        <ClientSideEvents ValueChanged="function(s, e) {
                                            var fromDate = s.GetDate();
                                            if (fromDate) {
                                                dateTo3.SetMinDate(fromDate);
                                            }
                                        }" />
                                    </dx:ASPxDateEdit>

                                    <dx:ASPxDateEdit
                                        ID="DateTo3"
                                        runat="server"
                                        Width="200px"
                                        NullText="إلى تاريخ"
                                        Font-Names="Cairo"
                                        Font-Bold="True"
                                        Font-Size="Medium"
                                        ClientInstanceName="dateTo3">
                                    </dx:ASPxDateEdit>

                                </div>

                                <div style="display: flex; flex-wrap: wrap; gap: 15px; align-items: center; justify-content: center; margin-top: 15px;">

                                    <dx:ASPxButton
                                        ID="ASPxButton1"
                                        runat="server"
                                        Text="بحث"
                                        AutoPostBack="False"
                                        Width="140px"
                                        Font-Names="Cairo"
                                        Font-Size="Medium"
                                        CssClass="rounded-xl"
                                        Font-Bold="true"
                                        ClientInstanceName="btnSearchUsers"
                                        Theme="Moderno">
                                        <Image Url="~/assets/img/search.png" />
                                        <ClientSideEvents Click="function(s,e){
                                        var fromDate = dateFrom3.GetDate();
                                        var toDate = dateTo3.GetDate();

                                        if(!fromDate) fromDate = new Date(2025, 0, 1);
                                        if(!toDate) toDate = new Date();

                                        var from = fromDate.toISOString().split('T')[0];
                                        var to = toDate.toISOString().split('T')[0];

                                        GridBranches.PerformCallback(from + '|' + to);
                                    }" />

                                    </dx:ASPxButton>

                                    <dx:ASPxButton
                                        ID="ASPxButton2"
                                        runat="server"
                                        Text="مسح"
                                        AutoPostBack="False"
                                        Width="140px"
                                        Font-Names="Cairo"
                                        Font-Size="Medium"
                                        CssClass="rounded-xl"
                                        ClientInstanceName="btnResetUsers"
                                        Theme="Moderno">
                                        <Image Url="~/assets/img/reset.png" />
                                        <ClientSideEvents Click="function(s,e){
                                        dateFrom3.SetValue(null);
                                        dateTo3.SetValue(null);

                                        var from = new Date(2025, 0, 1).toISOString().split('T')[0];
                                        var to = new Date().toISOString().split('T')[0];

                                        GridBranches.PerformCallback(from + '|' + to);
                                    }" />

                                    </dx:ASPxButton>


                                </div>

                                <dx:ASPxGridView ID="GridBranches" runat="server" DataSourceID="db_Branches" KeyFieldName="id" ClientInstanceName="GridBranches" Width="100%" AutoGenerateColumns="False" EnablePagingCallbackAnimation="True" Font-Names="cairo" Font-Size="1em" RightToLeft="True" OnCustomCallback="GridBranches_CustomCallback" OnBeforePerformDataSelect="GridBranches_BeforePerformDataSelect">
                                    <Settings ShowFooter="True" ShowFilterRow="True" />

                                    <Styles>
                                        <PagerBottomPanel Font-Names="Cairo" Font-Size="Large" Font-Bold="true"></PagerBottomPanel>
                                    </Styles>

                                    <ClientSideEvents RowClick="function(s, e) {OnRowClick(e);}" RowDblClick="function(s, e) {setTimeout(function(){GridBranches.StartEditRow(MyIndex);},100);}" />
                                    <SettingsAdaptivity AdaptivityMode="HideDataCells">
                                    </SettingsAdaptivity>
                                    <Settings ShowFilterRow="True" ShowFilterRowMenu="False" ShowHeaderFilterButton="False" AutoFilterCondition="Contains" />

                                    <SettingsCommandButton>

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

                                    <SettingsSearchPanel CustomEditorID="tbToolbarSearchBranch" />

                                    <SettingsExport EnableClientSideExportAPI="true" ExcelExportMode="WYSIWYG" PaperKind="A4" RightToLeft="True" />
                                    <SettingsLoadingPanel Text="Please Wait &amp;hellip;" Mode="ShowAsPopup" />
                                    <SettingsText SearchPanelEditorNullText="ابحث في الجدول..." EmptyDataRow="لا يوجد" />
                                    <Columns>
                                        <dx:GridViewDataColumn Caption="الرقم" FieldName="id">
                                            <EditFormSettings Visible="False" />
                                            <CellStyle VerticalAlign="Middle" HorizontalAlign="Center">
                                            </CellStyle>
                                        </dx:GridViewDataColumn>

                                        <dx:GridViewDataTextColumn Caption="الاسم" FieldName="name" Width="13%">
                                            <PropertiesTextEdit>
                                                <ValidationSettings RequiredField-IsRequired="true" SetFocusOnError="True" ErrorText="Country name in arabic is required." Display="Dynamic">
                                                    <RequiredField IsRequired="True"></RequiredField>
                                                </ValidationSettings>
                                            </PropertiesTextEdit>
                                            <CellStyle VerticalAlign="Middle" HorizontalAlign="Center">
                                            </CellStyle>
                                        </dx:GridViewDataTextColumn>
                                        <dx:GridViewDataComboBoxColumn Caption="الدولة" FieldName="countryId">
                                            <PropertiesComboBox DataSourceID="DB_Countries" TextField="countryName" ValueField="id" ValueType="System.Int32">
                                                <ValidationSettings RequiredField-IsRequired="true" SetFocusOnError="True" ErrorText="Country name in arabic is required." Display="Dynamic">
                                                    <RequiredField IsRequired="True"></RequiredField>
                                                </ValidationSettings>
                                                <ClientSideEvents SelectedIndexChanged="CitiesCombo_SelectedIndexChanged" />
                                                <ItemStyle Font-Size="1.5em" />
                                            </PropertiesComboBox>
                                            <CellStyle VerticalAlign="Middle" HorizontalAlign="Center">
                                            </CellStyle>
                                        </dx:GridViewDataComboBoxColumn>

                                        <dx:GridViewDataComboBoxColumn Caption="الحالة" FieldName="l_branchStatus">
                                            <PropertiesComboBox DataSourceID="DB_BranchesList" TextField="description" ValueField="id" ValueType="System.Int32">
                                                <ValidationSettings RequiredField-IsRequired="true" SetFocusOnError="True" ErrorText="name in arabic is required." Display="Dynamic">
                                                    <RequiredField IsRequired="True"></RequiredField>
                                                </ValidationSettings>
                                                <ItemStyle Font-Size="1.5em" />
                                            </PropertiesComboBox>
                                            <CellStyle VerticalAlign="Middle" HorizontalAlign="Center">
                                            </CellStyle>
                                        </dx:GridViewDataComboBoxColumn>

                                        <dx:GridViewDataCheckColumn Caption="فرع رئيسي" FieldName="isMain" Width="5%">
                                            <EditFormSettings Visible="True" />
                                            <CellStyle HorizontalAlign="Center" VerticalAlign="Middle">
                                            </CellStyle>
                                        </dx:GridViewDataCheckColumn>

                                        <dx:GridViewDataComboBoxColumn Caption="المدينة" FieldName="cityId">
                                            <PropertiesComboBox DataSourceID="DB_Cities" TextField="cityName" ValueField="id" ValueType="System.Int32">
                                                <ValidationSettings RequiredField-IsRequired="true" SetFocusOnError="True" ErrorText="Country name in arabic is required." Display="Dynamic">
                                                    <RequiredField IsRequired="True"></RequiredField>
                                                </ValidationSettings>
                                                <ItemStyle Font-Size="1.5em" />
                                            </PropertiesComboBox>
                                            <CellStyle VerticalAlign="Middle" HorizontalAlign="Center">
                                            </CellStyle>
                                        </dx:GridViewDataComboBoxColumn>

                                        <dx:GridViewDataComboBoxColumn Caption="الشركة" FieldName="companyId">
                                            <PropertiesComboBox DataSourceID="DB_Companies" TextField="companyName" ValueField="id" ValueType="System.Int32">
                                                <ValidationSettings RequiredField-IsRequired="true" SetFocusOnError="True" ErrorText="required." Display="Dynamic">
                                                    <RequiredField IsRequired="True"></RequiredField>
                                                </ValidationSettings>
                                                <ItemStyle Font-Size="1.5em" />
                                            </PropertiesComboBox>
                                            <CellStyle VerticalAlign="Middle" HorizontalAlign="Center">
                                            </CellStyle>
                                        </dx:GridViewDataComboBoxColumn>

                                        <dx:GridViewDataTextColumn Caption="خطوط الطول" FieldName="latitude">
                                            <PropertiesTextEdit>
                                                <ValidationSettings RequiredField-IsRequired="true" SetFocusOnError="True" ErrorText="Country name in arabic is required." Display="Dynamic">
                                                    <RequiredField IsRequired="True"></RequiredField>
                                                </ValidationSettings>
                                            </PropertiesTextEdit>
                                            <EditFormSettings Visible="True" />
                                            <CellStyle VerticalAlign="Middle" HorizontalAlign="Center" />
                                            <DataItemTemplate>
                                                <a href='<%# "https://maps.google.com/?q=" 
                                     + Eval("latitude") + "," + Eval("longitude") %>'
                                                    target="_blank">
                                                    <%# Eval("latitude") %>
                                                </a>
                                            </DataItemTemplate>
                                        </dx:GridViewDataTextColumn>

                                        <dx:GridViewDataTextColumn Caption="خطوط العرض" FieldName="longitude">
                                            <PropertiesTextEdit>
                                                <ValidationSettings RequiredField-IsRequired="true" SetFocusOnError="True" ErrorText="Country name in arabic is required." Display="Dynamic">
                                                    <RequiredField IsRequired="True"></RequiredField>
                                                </ValidationSettings>
                                            </PropertiesTextEdit>
                                            <EditFormSettings Visible="True" />
                                            <CellStyle VerticalAlign="Middle" HorizontalAlign="Center" />
                                            <DataItemTemplate>
                                                <a href='<%# "https://maps.google.com/?q=" 
                                     + Eval("latitude") + "," + Eval("longitude") %>'
                                                    target="_blank">
                                                    <%# Eval("longitude") %>
                                                </a>
                                            </DataItemTemplate>
                                        </dx:GridViewDataTextColumn>
                                        <dx:GridViewDataTextColumn Caption="الهاتف" FieldName="phone">
                                            <PropertiesTextEdit>
                                                <ValidationSettings RequiredField-IsRequired="true" SetFocusOnError="True" ErrorText="Country name in arabic is required." Display="Dynamic">
                                                    <RequiredField IsRequired="True"></RequiredField>
                                                </ValidationSettings>
                                            </PropertiesTextEdit>
                                            <EditFormSettings Visible="True" />
                                            <CellStyle VerticalAlign="Middle" HorizontalAlign="Center" />
                                        </dx:GridViewDataTextColumn>
                                        <dx:GridViewDataTextColumn Caption="الهاتف الفرعي" FieldName="extensionNumber">
                                            <PropertiesTextEdit>
                                                <ValidationSettings RequiredField-IsRequired="true" SetFocusOnError="True" ErrorText="Country name in arabic is required." Display="Dynamic">
                                                    <RequiredField IsRequired="True"></RequiredField>
                                                </ValidationSettings>
                                            </PropertiesTextEdit>
                                            <EditFormSettings Visible="True" />
                                            <CellStyle VerticalAlign="Middle" HorizontalAlign="Center" />
                                        </dx:GridViewDataTextColumn>

                                        <dx:GridViewDataColumn Caption="المبلغ الاجمالي" FieldName="TotalSales" Width="5%">
                                            <DataItemTemplate>
                                                <%# Eval("TotalSales") + "</br>" + MainHelper.GetCurrency(Eval("countryId")) %>
                                            </DataItemTemplate>
                                            <EditFormSettings Visible="True" />
                                            <CellStyle HorizontalAlign="Center" Font-Bold="true" VerticalAlign="Middle">
                                            </CellStyle>
                                        </dx:GridViewDataColumn>

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
                                                        <dx:ASPxButtonEdit ID="tbToolbarSearchBranch" runat="server" NullText="البحث..." Width="140" Font-Names="cairo" />
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
                                    ID="db_Branches"
                                    runat="server"
                                    ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>"
                                    SelectCommand="
    SELECT 
        b.[id], 
        b.[name], 
        b.[l_branchStatus],
        b.[countryId], 
        b.[companyId], 
        c.[companyName],
        b.[cityId],
        b.[latitude], 
        b.[longitude], 
        b.[phone], 
        b.[extensionNumber],
        b.[isMain],
        ISNULL(SUM(o.totalAmount), 0) AS TotalSales
    FROM branches b
    LEFT JOIN companies c ON b.companyId = c.id
    LEFT JOIN orders o ON o.branchId = b.id AND CAST(o.userDate AS DATE) BETWEEN @FromDate4 AND @ToDate4
    GROUP BY 
        b.[id], 
        b.[name], 
        b.[l_branchStatus],
        b.[countryId], 
        b.[companyId], 
        c.[companyName],
        b.[cityId],
        b.[latitude], 
        b.[longitude], 
        b.[phone], 
        b.[extensionNumber],
        b.[isMain]
    ORDER BY TotalSales DESC
">
                                    <SelectParameters>
                                        <asp:Parameter Name="FromDate4" Type="DateTime" />
                                        <asp:Parameter Name="ToDate4" Type="DateTime" />
                                    </SelectParameters>
                                </asp:SqlDataSource>


                                <asp:SqlDataSource ID="DB_Companies" runat="server" ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>" SelectCommand="SELECT id,companyName FROM companies where id <> 1000"></asp:SqlDataSource>

                                <asp:SqlDataSource ID="DB_BranchesList" runat="server" ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>" SelectCommand="SELECT id, description FROM L_BranchStatus"></asp:SqlDataSource>

                                <asp:SqlDataSource ID="DB_Countries" runat="server" ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>" SelectCommand="SELECT * FROM countries where id <> 1000"></asp:SqlDataSource>

                                <asp:SqlDataSource ID="DB_Cities" runat="server" ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>" SelectCommand="SELECT id,cityName FROM cities"></asp:SqlDataSource>
                            </div>

                        </dx:ContentControl>
                    </ContentCollection>
                </dx:TabPage>
            </TabPages>

        </dx:ASPxPageControl>

        <dx:ASPxPopupControl ID="popupOrderProducts" runat="server"
            ClientInstanceName="popupOrderProducts"
            Width="1100px" HeaderText="المنتجات في الطلب"
            PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter"
            Modal="true" Font-Names="Cairo">
            <ClientSideEvents Shown="function(s,e){ s.UpdatePosition(); }" />
            <ContentCollection>
                <dx:PopupControlContentControl>

                    <dx:ASPxGridView ID="gridOrderProducts" runat="server"
                        DataSourceID="dsOrderProducts"
                        OnCustomCallback="gridOrderProducts_CustomCallback"
                        KeyFieldName="id" ClientInstanceName="gridOrderProducts"
                        Width="100%" AutoGenerateColumns="False"
                        Font-Names="Cairo" Font-Size="1em" RightToLeft="True"
                        EnablePagingCallbackAnimation="True">

                        <Settings ShowFooter="True" ShowFilterRow="True" ShowFilterRowMenu="False" ShowHeaderFilterButton="False" AutoFilterCondition="Contains" />
                        <SettingsLoadingPanel Text="يرجى الانتظار..." Mode="ShowAsPopup" />
                        <SettingsText SearchPanelEditorNullText="ابحث في المنتجات..." EmptyDataRow="لا يوجد منتجات مرتبطة بهذا الطلب." />

                        <SettingsExport EnableClientSideExportAPI="true" ExcelExportMode="WYSIWYG" PaperKind="A4" RightToLeft="True" />

                        <SettingsPopup>
                            <FilterControl AutoUpdatePosition="False"></FilterControl>
                        </SettingsPopup>

                        <SettingsSearchPanel CustomEditorID="tbToolbarSearchProducts" />

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
                                <CellStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                            </dx:GridViewDataColumn>
                            <dx:GridViewDataColumn Caption="الصور" VisibleIndex="1" FieldName="Images">

                                <DataItemTemplate>
                                    <div class="preview-container" style="text-align: center; display: flex; justify-content: center;">

                                        <img
                                            id="defaultThumbImg"
                                            src='<%# GetFirstImagePath(Eval("PID")) %>?v=<%# DateTime.Now.Ticks %>'
                                            style="width: 7em; border: 1px solid #c8c8c8; border-radius: 5px; cursor: pointer;"
                                            onclick="setTimeout(function () {onImageClick()}, 300);" />
                                    </div>
                                </DataItemTemplate>
                            </dx:GridViewDataColumn>

                            <dx:GridViewDataColumn FieldName="productName" Caption="المنتج" Width="50%">
                                <CellStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                            </dx:GridViewDataColumn>

                            <%-- <dx:GridViewDataTextColumn Caption="السعر" FieldName="productPrice" Width="15%">
                            <DataItemTemplate>
                                <%# GetPriceDisplayText(Eval("productPrice"), Eval("productOfferPrice")) %>
                            </DataItemTemplate>
                            <CellStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                        </dx:GridViewDataTextColumn>--%>

                            <dx:GridViewDataTextColumn Caption="الخيار" FieldName="optionName" Width="15%">
                                <DataItemTemplate>
                                    <%# GetOptionDisplayText(Eval("optionName"), Eval("productOptionPrice"), Eval("productOptionOfferPrice")) %>
                                </DataItemTemplate>
                                <CellStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                            </dx:GridViewDataTextColumn>

                            <dx:GridViewDataTextColumn Caption="الإضافات" FieldName="extras" ShowInCustomizationForm="True">
                                <PropertiesTextEdit EncodeHtml="False">
                                </PropertiesTextEdit>
                                <CellStyle HorizontalAlign="Center" VerticalAlign="Middle">
                                </CellStyle>
                            </dx:GridViewDataTextColumn>

                            <dx:GridViewDataTextColumn Caption="الكمية / الوزن" Width="15%">
                                <DataItemTemplate>
                                    <%# 
        (Convert.ToDecimal(Eval("quantity")) > 0) ? 
            $"{Eval("quantity")}" : 
            $"{Eval("weight")} كغ"
                                    %>
                                </DataItemTemplate>
                                <CellStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                            </dx:GridViewDataTextColumn>


                            <dx:GridViewDataTextColumn Caption="السعر" Width="15%">
                                <DataItemTemplate>
                                    <%# GetTotalPaidAmount(
    Eval("price"), 
    Eval("quantity"), 
    Eval("weight")
) + "</br>" + GetCurrency(Eval("countryId"))
                                    %>
                                </DataItemTemplate>
                                <CellStyle HorizontalAlign="Center" VerticalAlign="Middle" Font-Size="Large" Font-Bold="true" />
                            </dx:GridViewDataTextColumn>



                            <dx:GridViewDataColumn FieldName="note" Caption="ملاحظات">
                                <CellStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                            </dx:GridViewDataColumn>

                        </Columns>

                        <TotalSummary>
                            <dx:ASPxSummaryItem FieldName="id" SummaryType="Count" DisplayFormat="العدد = {0}" />
                        </TotalSummary>

                    </dx:ASPxGridView>

                </dx:PopupControlContentControl>
            </ContentCollection>
        </dx:ASPxPopupControl>
        <asp:SqlDataSource
            ID="dsOrderProducts"
            runat="server"
            ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>"
            SelectCommand="
SELECT 
    c.id, 
    p.name AS productName,
    c.productOptionOfferPrice,
    c.productOptionPrice,
    c.productOfferPrice,
    c.price,
    p.id AS PID,
    c.productPrice,
    p.countryId,
    c.quantity,
    c.weight, 
    ISNULL(po.productOption, N'لا يوجد') AS optionName,
    ISNULL(
        (SELECT STRING_AGG(pe.productExtra, N' &lt;br&gt; ') 
         FROM productsExtra pe 
         WHERE pe.id IN (SELECT TRY_CAST([value] AS INT) 
                         FROM STRING_SPLIT(c.extras, ',')))
    , N'لا يوجد') AS extras,
    c.note 
FROM carts c 
LEFT JOIN products p ON c.productId = p.id 
LEFT JOIN productsOptions po ON c.options = po.id 
WHERE c.orderId = @orderId">
            <SelectParameters>
                <asp:ControlParameter ControlID="l_Order_Id" Name="orderId" PropertyName="Text" />
            </SelectParameters>
        </asp:SqlDataSource>


    </main>



</asp:Content>
