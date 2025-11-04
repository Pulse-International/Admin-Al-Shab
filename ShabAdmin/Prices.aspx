<%@ Page Title="Prices" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Prices.aspx.cs" Inherits="ShabAdmin.Prices" %>

<%@ Register Assembly="DevExpress.Web.v24.1, Version=24.1.6.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    
        <main>
            <script>
                var MyIndex;
                var gridNo;

                function OnRowClick(e) {
                    MyIndex = e.visibleIndex;
                }

                function onDeleteClick(visibleIndex, gridNo) {
                    MyIndex = visibleIndex;

                    Pop_Del_Grids.Show();
                }
                function OnGridPricesEndCallback(s, e) {
                    if (s.cp_CancelUpdate === "true") {
                        delete s.cp_CancelUpdate;
                        popupWarning.Show(); // Make sure popupWarning is your DevExpress PopupControl
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
            </script>
            <script src="https://cdnjs.cloudflare.com/ajax/libs/lottie-web/5.12.0/lottie.min.js"></script>

            <div class="w-100 text-center my-4">
                <h2 class="pageTitle d-inline-block" style="font-family: Cairo">أسعار المنتجات لكل دولة</h2>
            </div>

            <div class="navbar-main navbar-expand-lg px-0 mx-4 border-radius-xl bg-white shadow mt-3 mb-1">

                <dx:ASPxGridView ID="GridPrices" runat="server" DataSourceID="db_ProductPrices"
                    KeyFieldName="uid" ClientInstanceName="GridPrices" Width="100%"
                    AutoGenerateColumns="False" Font-Names="cairo" Font-Size="1em" RightToLeft="True"
                    OnBatchUpdate="GridPrices_BatchUpdate">

                    <ClientSideEvents EndCallback="OnGridPricesEndCallback" />
                    <Settings ShowFooter="True" ShowFilterRow="True" />
                    <SettingsEditing Mode="Batch">
                        <BatchEditSettings EditMode="Cell" StartEditAction="Click" />
                    </SettingsEditing>
                    <SettingsAdaptivity AdaptivityMode="HideDataCells" />
                    <Settings ShowFilterRow="True" ShowFilterRowMenu="False" ShowHeaderFilterButton="False" AutoFilterCondition="Contains" />



                    <SettingsPopup>
                        <FilterControl AutoUpdatePosition="False" />
                    </SettingsPopup>

                    <SettingsSearchPanel CustomEditorID="tbToolbarSearch1" />
                    <SettingsExport EnableClientSideExportAPI="true" ExcelExportMode="WYSIWYG" PaperKind="A4" RightToLeft="True" />
                    <SettingsLoadingPanel Text="Please Wait &amp;hellip;" Mode="ShowAsPopup" />
                    <SettingsText SearchPanelEditorNullText="ابحث في الجدول..." EmptyDataRow="لا يوجد" CommandBatchEditCancel="الغاء التعديلات" CommandBatchEditHidePreview="اخفاء عرض التعديلات" CommandBatchEditPreviewChanges="عرض التعديلات" CommandBatchEditUpdate="حفظ التعديلات" />

                    <Columns>


                        <dx:GridViewDataTextColumn Caption="الاسم" FieldName="ProductName" ReadOnly="True">
                            <CellStyle VerticalAlign="Middle" HorizontalAlign="Center" />
                        </dx:GridViewDataTextColumn>

                        <dx:GridViewDataTextColumn Caption="سعر الاردن" FieldName="JordanPrice">
                            <CellStyle VerticalAlign="Middle" HorizontalAlign="Center" />
                        </dx:GridViewDataTextColumn>

                        <dx:GridViewDataTextColumn Caption="سعر العقبة" FieldName="AqabaPrice">
                            <CellStyle VerticalAlign="Middle" HorizontalAlign="Center" />
                        </dx:GridViewDataTextColumn>

                        <dx:GridViewDataTextColumn Caption="سعر قطر" FieldName="QatarPrice">
                            <CellStyle VerticalAlign="Middle" HorizontalAlign="Center" />
                        </dx:GridViewDataTextColumn>

                        <dx:GridViewDataTextColumn Caption="سعر البحرين" FieldName="BahrinPrice">
                            <CellStyle VerticalAlign="Middle" HorizontalAlign="Center" />
                        </dx:GridViewDataTextColumn>

                        <dx:GridViewDataTextColumn Caption="سعر الامارات" FieldName="UAEPrice">
                            <CellStyle VerticalAlign="Middle" HorizontalAlign="Center" />
                        </dx:GridViewDataTextColumn>

                        <dx:GridViewDataTextColumn Caption="سعر الكويت" FieldName="KuwaitPrice">
                            <CellStyle VerticalAlign="Middle" HorizontalAlign="Center" />
                        </dx:GridViewDataTextColumn>

                    </Columns>

                    <Toolbars>
                        <dx:GridViewToolbar ItemAlign="left">
                            <SettingsAdaptivity Enabled="true" EnableCollapseRootItemsToIcons="true" />
                            <Items>

                                <dx:GridViewToolbarItem Command="Refresh" Text="تحديث الجدول" />
                                <dx:GridViewToolbarItem Command="ExportToXlsx" Text="تصدير Excel" />
                                <dx:GridViewToolbarItem Command="ExportToPdf" Text="تصدير PDF" />
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
                        <AlternatingRow BackColor="#F0F0F0" />
                        <Footer Font-Names="cairo" />
                    </Styles>
                    <Paddings Padding="2em" />
                </dx:ASPxGridView>


                <asp:SqlDataSource
                    ID="db_ProductPrices"
                    runat="server"
                    ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>"
                    SelectCommand="
        SELECT 
            uid,
            MAX(name) AS ProductName,
            MAX(CASE WHEN countryID = 1 THEN price ELSE 0 END) AS [JordanPrice],
            MAX(CASE WHEN countryID = 2 THEN price ELSE 0 END) AS [AqabaPrice],
            MAX(CASE WHEN countryID = 3 THEN price ELSE 0 END) AS [QatarPrice],
            MAX(CASE WHEN countryID = 4 THEN price ELSE 0 END) AS [BahrinPrice],
            MAX(CASE WHEN countryID = 5 THEN price ELSE 0 END) AS [UAEPrice],
            MAX(CASE WHEN countryID = 6 THEN price ELSE 0 END) AS [KuwaitPrice]
        FROM products
        GROUP BY uid"></asp:SqlDataSource>

            </div>
            <asp:SqlDataSource ID="DB_Countries" runat="server" ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>" SelectCommand="SELECT * FROM countries"></asp:SqlDataSource>
            <asp:SqlDataSource ID="DB_Companies" runat="server" ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>" SelectCommand="SELECT * FROM companies"></asp:SqlDataSource>


            <dx:ASPxPopupControl ID="popupWarning" runat="server" ClientInstanceName="popupWarning"
                Width="400px" HeaderText="تحذير" ShowCloseButton="true"
                PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" Modal="true"
                HeaderStyle-Font-Names="Cairo" Font-Names="Cairo" ClientSideEvents-Init="InitDangerAnimation">

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


        </main>

    

</asp:Content>
