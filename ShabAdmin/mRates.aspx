<%@ Page Title="Rates" Language="C#" MasterPageFile="~/mSite.Master" AutoEventWireup="true" CodeBehind="mRates.aspx.cs" Inherits="ShabAdmin.mRates" %>

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


            var MyPrice;
            var MyPercent;

            function OnRowClick(e) {
                MyIndex = e.visibleIndex;
                GridProductRates.GetRowValues(MyIndex, 'id;rate;rateDesc', OnGetRowValues);
            }

            function OnGetRowValues(Value) {
                MyId = Value[0];

            }


            function OnRowClick1(e) {
                MyIndex = e.visibleIndex;
                GridDeliveryRates.GetRowValues(MyIndex, 'id;rate;rateDesc', OnGetRowValues);
            }

            function OnGetRowValues1(Value) {
                MyId = Value[0];
            }

        </script>

        <div class="w-100 text-center my-4">
            <h2 class="pageTitle d-inline-block" style="font-family: Cairo">التقييمات</h2>
        </div>
        <dx:ASPxPageControl ID="pageTab" runat="server" CssClass="divSTARProviders" ActiveTabIndex="0" ClientInstanceName="pageTab" Theme="Material" Width="100%" EnableCallbackAnimation="True">
            <TabPages>
                <dx:TabPage Text="تقييم المنتجات" TabStyle-Font-Bold="true" TabStyle-Font-Names="cairo" TabStyle-Font-Size="X-Large">
                    <TabStyle Font-Bold="True" Font-Names="cairo" Font-Size="X-Large"></TabStyle>
                    <ContentCollection>
                        <dx:ContentControl>
                            <div class="navbar-main navbar-expand-lg px-0 mx-4 border-radius-xl bg-white shadow mt-3 mb-1">

                                <dx:ASPxGridView ID="GridProductRates" runat="server" DataSourceID="db_ProductRates" KeyFieldName="id" ClientInstanceName="GridProductRates" Width="100%" AutoGenerateColumns="False" EnablePagingCallbackAnimation="True" Font-Names="cairo" Font-Size="1em" RightToLeft="True">
                                    <Settings ShowFooter="True" ShowFilterRow="True" />


                                    <ClientSideEvents RowClick="function(s, e) {OnRowClick(e);}" RowDblClick="function(s, e) {setTimeout(function(){GridProductRates.StartEditRow(MyIndex);},100);}" />
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
                                            <CellStyle VerticalAlign="Middle" Font-Size="Large" HorizontalAlign="Center" />
                                        </dx:GridViewDataColumn>

                                        <dx:GridViewDataColumn Caption="رقم الطلب" FieldName="orderId">
                                            <EditFormSettings Visible="False" />
                                            <CellStyle VerticalAlign="Middle" Font-Size="Large" HorizontalAlign="Center" />
                                        </dx:GridViewDataColumn>

                                        <dx:GridViewDataColumn Caption="صورة المنتج" FieldName="Images">

                                            <DataItemTemplate>
                                                <div class="preview-container" style="text-align: center; display: flex; justify-content: center;">

                                                    <img
                                                        id="defaultThumbImg"
                                                        src='<%# GetProductFirstImagePath(Eval("productId")) %>?v=<%# DateTime.Now.Ticks %>'
                                                        style="width: 7em; border: 1px solid #c8c8c8; border-radius: 5px; cursor: pointer;"
                                                        onclick="setTimeout(function () {onImageClick()}, 300);" />
                                                </div>
                                            </DataItemTemplate>
                                            <EditFormSettings Visible="False" />
                                        </dx:GridViewDataColumn>

                                        <dx:GridViewDataComboBoxColumn Caption="المنتج" FieldName="productId">
                                            <PropertiesComboBox DataSourceID="db_productName" TextField="name" ValueField="id" ValueType="System.Int32">
                                                <ItemStyle Font-Size="1.5em" />
                                            </PropertiesComboBox>
                                            <EditFormSettings Visible="False" />
                                            <CellStyle VerticalAlign="Middle" Font-Size="Large" HorizontalAlign="Center">
                                            </CellStyle>
                                        </dx:GridViewDataComboBoxColumn>

                                        <dx:GridViewDataComboBoxColumn Caption="البلد" FieldName="countryId">
                                            <PropertiesComboBox ClientInstanceName="cmbCountry"
                                                DataSourceID="db_countryName"
                                                TextField="countryName"
                                                ValueField="id"
                                                ValueType="System.Int32"
                                                EnableCallbackMode="false">
                                                <ValidationSettings RequiredField-IsRequired="true" ErrorText="اختر الدولة" Display="Dynamic">
                                                    <RequiredField IsRequired="True"></RequiredField>
                                                </ValidationSettings>
                                            </PropertiesComboBox>
                                            <EditFormSettings Visible="False" />
                                            <CellStyle VerticalAlign="Middle" Font-Size="Large" HorizontalAlign="Center" />
                                        </dx:GridViewDataComboBoxColumn>

                                        <dx:GridViewDataComboBoxColumn Caption="البلد" FieldName="companyId">
                                            <PropertiesComboBox ClientInstanceName="cmbCountry"
                                                DataSourceID="db_companyName"
                                                TextField="companyName"
                                                ValueField="id"
                                                ValueType="System.Int32"
                                                EnableCallbackMode="false">
                                                <ValidationSettings RequiredField-IsRequired="true" ErrorText="اختر الدولة" Display="Dynamic">
                                                    <RequiredField IsRequired="True"></RequiredField>
                                                </ValidationSettings>
                                            </PropertiesComboBox>
                                            <EditFormSettings Visible="False" />
                                            <CellStyle VerticalAlign="Middle" Font-Size="Large" HorizontalAlign="Center" />
                                        </dx:GridViewDataComboBoxColumn>


                                        <dx:GridViewDataColumn Caption="رقم المستخدم" FieldName="username">
                                            <EditFormSettings Visible="False" />
                                            <CellStyle VerticalAlign="Middle" Font-Size="Large" HorizontalAlign="Center" />
                                        </dx:GridViewDataColumn>

                                        <dx:GridViewDataTextColumn FieldName="rateDesc" Caption="وصف التقييم">
                                            <PropertiesTextEdit>
                                                <ValidationSettings RequiredField-IsRequired="true" ErrorText="ادخل وصف التقييم" Display="Dynamic">
                                                    <RequiredField IsRequired="True"></RequiredField>
                                                </ValidationSettings>
                                            </PropertiesTextEdit>
                                            <CellStyle VerticalAlign="Middle" Font-Size="Large" HorizontalAlign="Center" />
                                        </dx:GridViewDataTextColumn>


                                        <dx:GridViewDataDateColumn FieldName="userDate" Caption="تاريخ التقييم">
                                            <PropertiesDateEdit DisplayFormatString="dd/MM/yyyy" />
                                            <EditFormSettings Visible="False" />
                                            <CellStyle VerticalAlign="Middle" Font-Size="Large" HorizontalAlign="Center" />
                                        </dx:GridViewDataDateColumn>

                                        <dx:GridViewDataColumn Caption="التقييم" FieldName="rate">
                                            <DataItemTemplate>
                                                <dx:ASPxRatingControl ID="RatingStars" runat="server"
                                                    ReadOnly="true"
                                                    Value='<%# Convert.ToDouble(Eval("rate")) %>'
                                                    CssClass="stars"
                                                    ItemCount="5"
                                                    AllowHalf="true" />
                                            </DataItemTemplate>
                                            <EditFormSettings Visible="False" />
                                            <CellStyle VerticalAlign="Middle" HorizontalAlign="Center" />
                                        </dx:GridViewDataColumn>


                                        <dx:GridViewDataColumn Caption="الموافقة" FieldName="rateApproved">
                                            <DataItemTemplate>
                                                <%# 
                                                        Convert.ToBoolean(Eval("rateApproved")) 
                                                        ? "<span class='status-label approved-text'>تمت الموافقة</span>" 
                                                        : $"<button type='button' class='status-label approve-btn' onclick=\"callbackApprove.PerformCallback('{Convert.ToString(Eval("id"))}')\">أوافق</button>" 
                                                %>
                                            </DataItemTemplate>
                                            <EditFormSettings Visible="False" />
                                            <CellStyle VerticalAlign="Middle" HorizontalAlign="Center" />
                                        </dx:GridViewDataColumn>

                                        <dx:GridViewDataTextColumn Caption="" ShowInCustomizationForm="True" Width="100px">
                                            <EditFormSettings Visible="False" />
                                            <DataItemTemplate>
                                                <div style="width: 100%; float: left; text-align: center">
                                                    <img src="/assets/img/update.png" width="32" height="32" title="تعديل" style="cursor: pointer" onclick="setTimeout(function(){GridProductRates.StartEditRow(MyIndex);},100);" />
                                                </div>
                                            </DataItemTemplate>
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

                            <%--------------------------------------------------%>

                            <div class="w-100 text-center my-4">
                                <h2 class="pageTitle d-inline-block" style="font-family: Cairo">المنتجات</h2>
                            </div>
                            <div class="navbar-main navbar-expand-lg px-0 mx-4 border-radius-xl bg-white shadow mt-3 mb-1">

                                <dx:ASPxGridView ID="GridProducts" runat="server" DataSourceID="db_Products" KeyFieldName="id" ClientInstanceName="GridProducts" Width="100%" AutoGenerateColumns="False" EnablePagingCallbackAnimation="True" Font-Names="cairo" Font-Size="1em" RightToLeft="True">
                                    <Settings ShowFooter="True" ShowFilterRow="True" />


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
                                            <CellStyle VerticalAlign="Middle" Font-Size="Large" HorizontalAlign="Center" />
                                        </dx:GridViewDataColumn>

                                        <dx:GridViewDataColumn Caption="صورة المنتج" VisibleIndex="1" FieldName="Images">

                                            <DataItemTemplate>
                                                <div class="preview-container" style="text-align: center; display: flex; justify-content: center;">

                                                    <img
                                                        id="defaultThumbImg"
                                                        src='<%# GetProductFirstImagePath(Eval("id")) %>?v=<%# DateTime.Now.Ticks %>'
                                                        style="width: 7em; border: 1px solid #c8c8c8; border-radius: 5px; cursor: pointer;"
                                                        onclick="setTimeout(function () {onImageClick()}, 300);" />
                                                </div>
                                            </DataItemTemplate>
                                        </dx:GridViewDataColumn>

                                        <dx:GridViewDataComboBoxColumn Caption="المنتج" FieldName="name">
                                            <PropertiesComboBox DataSourceID="db_productName" TextField="name" ValueField="id" ValueType="System.Int32">
                                                <ItemStyle Font-Size="1.5em" />
                                            </PropertiesComboBox>
                                            <EditFormSettings Visible="False" />
                                            <CellStyle VerticalAlign="Middle" Font-Size="Large" HorizontalAlign="Center">
                                            </CellStyle>
                                        </dx:GridViewDataComboBoxColumn>

                                        <dx:GridViewDataComboBoxColumn Caption="البلد" FieldName="countryId">
                                            <PropertiesComboBox DataSourceID="db_countryName" TextField="countryName" ValueField="id" ValueType="System.Int32">
                                                <ItemStyle Font-Size="1.5em" />
                                            </PropertiesComboBox>
                                            <EditFormSettings Visible="False" />
                                            <CellStyle VerticalAlign="Middle" Font-Size="Large" HorizontalAlign="Center">
                                            </CellStyle>
                                        </dx:GridViewDataComboBoxColumn>

                                        <dx:GridViewDataComboBoxColumn Caption="الشركة" FieldName="companyId">
                                            <PropertiesComboBox DataSourceID="db_companyName" TextField="companyName" ValueField="id" ValueType="System.Int32">
                                                <ItemStyle Font-Size="1.5em" />
                                            </PropertiesComboBox>
                                            <EditFormSettings Visible="False" />
                                            <CellStyle VerticalAlign="Middle" Font-Size="Large" HorizontalAlign="Center">
                                            </CellStyle>
                                        </dx:GridViewDataComboBoxColumn>

                                        <dx:GridViewDataColumn Caption="التقييم" FieldName="rate">
                                            <DataItemTemplate>
                                                <dx:ASPxRatingControl ID="RatingStars" runat="server"
                                                    ReadOnly="true"
                                                    ReadOnlyPrecisionMode="Exact"
                                                    Value='<%# Convert.ToDouble(Eval("rate")) %>'
                                                    CssClass="stars"
                                                    ItemCount="5"
                                                    FillPrecision="Exact"
                                                    ToolTip='<%# Eval("rate").ToString() + " / 5" %>' />
                                            </DataItemTemplate>
                                            <EditFormSettings Visible="False" />
                                            <CellStyle VerticalAlign="Middle" HorizontalAlign="Center" />
                                        </dx:GridViewDataColumn>

                                        <dx:GridViewDataColumn Caption="عدد التقييمات" FieldName="rateCount">
                                            <EditFormSettings Visible="False" />
                                            <CellStyle VerticalAlign="Middle" Font-Size="Large" HorizontalAlign="Center" />
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
                                    ID="db_ProductRates"
                                    runat="server"
                                    ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>"
                                    SelectCommand="SELECT id,rate,countryId,companyId,rateDesc,userDate,rateApproved,productId,orderId FROM [productsRates] order by id desc"
                                    UpdateCommand="UPDATE [productsRates] SET [rateDesc] = @rateDesc WHERE [id] = @id;">
                                    <UpdateParameters>
                                        <asp:Parameter Name="rateDesc" Type="String" />
                                        <asp:Parameter Name="id" Type="Int32" />
                                    </UpdateParameters>

                                </asp:SqlDataSource>

                                <asp:SqlDataSource
                                    ID="db_Products"
                                    runat="server"
                                    ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>"
                                    SelectCommand="SELECT id,name,countryId,companyId,rate,rateCount FROM [products] order by id desc"></asp:SqlDataSource>


                                <asp:SqlDataSource
                                    ID="db_productName"
                                    runat="server"
                                    ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>"
                                    SelectCommand="SELECT id, name FROM [products]" />
                                <asp:SqlDataSource
                                    ID="db_countryName"
                                    runat="server"
                                    ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>"
                                    SelectCommand="SELECT id, countryName FROM [countries] where id <> 1000" />
                                <asp:SqlDataSource
                                    ID="db_companyName"
                                    runat="server"
                                    ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>"
                                    SelectCommand="SELECT id, companyName FROM [companies] where id <> 1000" />


                                <dx:ASPxCallback ID="callbackApprove" runat="server" ClientInstanceName="callbackApprove"
                                    OnCallback="callbackApprove_Callback"
                                    ClientSideEvents-EndCallback="function(){GridProductRates.Refresh();
                                        GridProducts.Refresh();
                                        }" />

                            </div>
                        </dx:ContentControl>
                    </ContentCollection>
                </dx:TabPage>

                <%---------------------------------------------------------------------------%>

                <dx:TabPage Text="تقييم طلبات الشركات" TabStyle-Font-Bold="true" TabStyle-Font-Names="cairo" TabStyle-Font-Size="X-Large">
                    <TabStyle Font-Bold="True" Font-Names="cairo" Font-Size="X-Large"></TabStyle>
                    <ContentCollection>
                        <dx:ContentControl runat="server">
                            <dx:ContentControl>
                                <div class="navbar-main navbar-expand-lg px-0 mx-4 border-radius-xl bg-white shadow mt-3 mb-1">

                                    <dx:ASPxGridView ID="GridOrdersRates" runat="server" DataSourceID="db_OrderRates" KeyFieldName="id" ClientInstanceName="GridOrdersRates" Width="100%" AutoGenerateColumns="False" EnablePagingCallbackAnimation="True" Font-Names="cairo" Font-Size="1em" RightToLeft="True">
                                        <Settings ShowFooter="True" ShowFilterRow="True" />


                                        <ClientSideEvents RowClick="function(s, e) {OnRowClick(e);}" RowDblClick="function(s, e) {setTimeout(function(){GridOrdersRates.StartEditRow(MyIndex);},100);}" />
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
                                            <dx:GridViewDataColumn Caption="رقم الطلب" FieldName="id">
                                                <EditFormSettings Visible="False" />
                                                <CellStyle VerticalAlign="Middle" Font-Size="Large" HorizontalAlign="Center" />
                                            </dx:GridViewDataColumn>

                                            <dx:GridViewDataComboBoxColumn Caption="البلد" FieldName="countryId">
                                                <PropertiesComboBox DataSourceID="db_countryName" TextField="countryName" ValueField="id" ValueType="System.Int32">
                                                    <ItemStyle Font-Size="1.5em" />
                                                </PropertiesComboBox>
                                                <EditFormSettings Visible="False" />
                                                <CellStyle VerticalAlign="Middle" Font-Size="Large" HorizontalAlign="Center">
                                                </CellStyle>
                                            </dx:GridViewDataComboBoxColumn>

                                            <dx:GridViewDataComboBoxColumn Caption="الشركة" FieldName="companyId">
                                                <PropertiesComboBox DataSourceID="db_companyName" TextField="companyName" ValueField="id" ValueType="System.Int32">
                                                    <ItemStyle Font-Size="1.5em" />
                                                </PropertiesComboBox>
                                                <EditFormSettings Visible="False" />
                                                <CellStyle VerticalAlign="Middle" Font-Size="Large" HorizontalAlign="Center">
                                                </CellStyle>
                                            </dx:GridViewDataComboBoxColumn>

                                            <dx:GridViewDataTextColumn FieldName="rateDesc" Caption="وصف التقييم">
                                                <PropertiesTextEdit EncodeHtml="false">
                                                    <ValidationSettings Display="Dynamic">
                                                        <RequiredField IsRequired="true" ErrorText="هذا الحقل مطلوب" />
                                                    </ValidationSettings>
                                                </PropertiesTextEdit>
                                                <CellStyle VerticalAlign="Middle" Font-Size="Large" HorizontalAlign="Center" />
                                            </dx:GridViewDataTextColumn>

                                            <dx:GridViewDataDateColumn FieldName="rateDate" Caption="تاريخ التقييم">
                                                <PropertiesDateEdit DisplayFormatString="dd/MM/yyyy" />
                                                <EditFormSettings Visible="False" />
                                                <CellStyle VerticalAlign="Middle" Font-Size="Large" HorizontalAlign="Center" />
                                            </dx:GridViewDataDateColumn>

                                            <dx:GridViewDataColumn Caption="المبلغ" FieldName="totalAmount">
                                                <EditFormSettings Visible="False" />
                                                <CellStyle VerticalAlign="Middle" Font-Size="Large" HorizontalAlign="Center">
                                                </CellStyle>
                                            </dx:GridViewDataColumn>

                                            <dx:GridViewDataColumn Caption="التقييم" FieldName="rate">
                                                <DataItemTemplate>
                                                    <dx:ASPxRatingControl ID="RatingStars" runat="server"
                                                        ReadOnly="true"
                                                        Value='<%# Convert.ToDouble(Eval("rate")) %>'
                                                        CssClass="stars"
                                                        ItemCount="5"
                                                        AllowHalf="true" />
                                                </DataItemTemplate>
                                                <EditFormSettings Visible="False" />
                                                <CellStyle VerticalAlign="Middle" HorizontalAlign="Center" />
                                            </dx:GridViewDataColumn>

                                            <dx:GridViewDataColumn Caption="الموافقة" FieldName="rateApproved">
                                                <DataItemTemplate>
                                                    <%# 
    Convert.ToBoolean(Eval("rateApproved")) 
    ? "<span class='status-label approved-text'>تمت الموافقة</span>" 
    : $"<button type='button' class='status-label approve-btn' onclick=\"ApproveOrderRate.PerformCallback('{Convert.ToString(Eval("id"))}')\">أوافق</button>" 
                                                    %>
                                                </DataItemTemplate>
                                                <EditFormSettings Visible="False" />
                                                <CellStyle VerticalAlign="Middle" HorizontalAlign="Center" />
                                            </dx:GridViewDataColumn>


                                            <dx:GridViewDataTextColumn Caption="" ShowInCustomizationForm="True" Width="100px">
                                                <EditFormSettings Visible="False" />
                                                <DataItemTemplate>
                                                    <div style="width: 100%; float: left; text-align: center">
                                                        <img src="/assets/img/update.png" width="32" height="32" title="تعديل" style="cursor: pointer" onclick="setTimeout(function(){GridOrdersRates.StartEditRow(MyIndex);},100);" />
                                                    </div>
                                                </DataItemTemplate>
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

                                <%----------------------------------------------------%>
                                <div class="w-100 text-center my-4">
                                    <h2 class="pageTitle d-inline-block" style="font-family: Cairo">الشركات</h2>
                                </div>

                                <div class="navbar-main navbar-expand-lg px-0 mx-4 border-radius-xl bg-white shadow mt-3 mb-1">

                                    <dx:ASPxGridView ID="GridCompanies" runat="server" DataSourceID="db_Companies" KeyFieldName="id" ClientInstanceName="GridCompanies" Width="100%" AutoGenerateColumns="False" EnablePagingCallbackAnimation="True" Font-Names="cairo" Font-Size="1em" RightToLeft="True">
                                        <Settings ShowFooter="True" ShowFilterRow="True" />


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
                                                <CellStyle VerticalAlign="Middle" Font-Size="Large" HorizontalAlign="Center" />
                                            </dx:GridViewDataColumn>

                                            <dx:GridViewDataColumn Caption="اسم الشركة" FieldName="companyName">

                                                <EditFormSettings Visible="False" />
                                                <CellStyle VerticalAlign="Middle" Font-Size="Large" HorizontalAlign="Center">
                                                </CellStyle>
                                            </dx:GridViewDataColumn>

                                            <dx:GridViewDataComboBoxColumn Caption="البلد" FieldName="countryId">
                                                <PropertiesComboBox DataSourceID="db_countryName" TextField="countryName" ValueField="id" ValueType="System.Int32">
                                                    <ItemStyle Font-Size="1.5em" />
                                                </PropertiesComboBox>
                                                <EditFormSettings Visible="False" />
                                                <CellStyle VerticalAlign="Middle" Font-Size="Large" HorizontalAlign="Center">
                                                </CellStyle>
                                            </dx:GridViewDataComboBoxColumn>

                                            <dx:GridViewDataColumn Caption="التقييم" FieldName="rate">
                                                <DataItemTemplate>
                                                    <dx:ASPxRatingControl ID="RatingStars" runat="server"
                                                        ReadOnly="true"
                                                        ReadOnlyPrecisionMode="Exact"
                                                        Value='<%# Convert.ToDouble(Eval("rate")) %>'
                                                        CssClass="stars"
                                                        ItemCount="5"
                                                        FillPrecision="Exact"
                                                        ToolTip='<%# Eval("rate").ToString() + " / 5" %>' />
                                                </DataItemTemplate>
                                                <EditFormSettings Visible="False" />
                                                <CellStyle VerticalAlign="Middle" HorizontalAlign="Center" />
                                            </dx:GridViewDataColumn>

                                            <dx:GridViewDataColumn Caption="عدد التقييمات" FieldName="rateCount">
                                                <EditFormSettings Visible="False" />
                                                <CellStyle VerticalAlign="Middle" Font-Size="Large" HorizontalAlign="Center" />
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
                                        ID="db_OrderRates"
                                        runat="server"
                                        ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>"
                                        SelectCommand="SELECT id,companyId,countryId,rate,rateDesc,rateDate,rateApproved,totalAmount FROM [orders] where rate > 0  order by id desc"
                                        UpdateCommand="UPDATE [orders] SET [rateDesc] = @rateDesc WHERE [id] = @id;">
                                        <UpdateParameters>
                                            <asp:Parameter Name="rateDesc" Type="String" />
                                            <asp:Parameter Name="id" Type="Int32" />
                                        </UpdateParameters>

                                    </asp:SqlDataSource>

                                    <asp:SqlDataSource
                                        ID="db_Companies"
                                        runat="server"
                                        ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>"
                                        SelectCommand="SELECT id,companyName,countryId,rate,rateCount FROM [companies] where id <> 1000 order by id desc"></asp:SqlDataSource>




                                    <dx:ASPxCallback ID="ApproveOrderRate" runat="server" ClientInstanceName="ApproveOrderRate"
                                        OnCallback="ApproveOrderRate_Callback"
                                        ClientSideEvents-EndCallback="function(){GridOrdersRates.Refresh();
                                                GridCompanies.Refresh();
                                                }" />

                                </div>
                            </dx:ContentControl>
                        </dx:ContentControl>
                    </ContentCollection>
                </dx:TabPage>

                <%---------------------------------------------------------------------------%>

                <dx:TabPage Text="تقييم السائقين" TabStyle-Font-Bold="true" TabStyle-Font-Names="cairo" TabStyle-Font-Size="X-Large">
                    <TabStyle Font-Bold="True" Font-Names="cairo" Font-Size="X-Large"></TabStyle>
                    <ContentCollection>
                        <dx:ContentControl runat="server">
                            <dx:ContentControl>
                                <div class="navbar-main navbar-expand-lg px-0 mx-4 border-radius-xl bg-white shadow mt-3 mb-1">

                                    <dx:ASPxGridView ID="GridDeliveryRates" runat="server" DataSourceID="db_DeliveryRates" KeyFieldName="id" ClientInstanceName="GridDeliveryRates" Width="100%" AutoGenerateColumns="False" EnablePagingCallbackAnimation="True" Font-Names="cairo" Font-Size="1em" RightToLeft="True">
                                        <Settings ShowFooter="True" ShowFilterRow="True" />


                                        <ClientSideEvents RowClick="function(s, e) {OnRowClick1(e);}" RowDblClick="function(s, e) {setTimeout(function(){GridDeliveryRates.StartEditRow(MyIndex);},100);}" />
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
                                                <CellStyle VerticalAlign="Middle" Font-Size="Large" HorizontalAlign="Center" />
                                            </dx:GridViewDataColumn>

                                            <dx:GridViewDataColumn Caption="رقم الطلب" FieldName="orderId">
                                                <EditFormSettings Visible="False" />
                                                <CellStyle VerticalAlign="Middle" Font-Size="Large" HorizontalAlign="Center" />
                                            </dx:GridViewDataColumn>

                                            <dx:GridViewDataColumn Caption="صورة السائق" FieldName="userPicture">

                                                <DataItemTemplate>
                                                    <div class="preview-container" style="text-align: center; display: flex; justify-content: center;">
                                                        <img
                                                            src='<%# GetFirstImagePath(Eval("id")) %>?v=<%# DateTime.Now.Ticks %>'
                                                            style="width: 7em; border: 1px solid #c8c8c8; border-radius: 5px; cursor: pointer;"
                                                            onclick="window.open(this.src, '_blank');" />
                                                    </div>
                                                </DataItemTemplate>
                                                <EditFormSettings Visible="False" />
                                            </dx:GridViewDataColumn>

                                            <dx:GridViewDataComboBoxColumn Caption="السائق" FieldName="userDeliveryId">
                                                <PropertiesComboBox DataSourceID="db_DeliveryUsers" TextField="fullName" ValueField="id" ValueType="System.Int32">
                                                    <ItemStyle Font-Size="1.5em" />
                                                </PropertiesComboBox>
                                                <EditFormSettings Visible="False" />
                                                <CellStyle VerticalAlign="Middle" Font-Size="Large" HorizontalAlign="Center">
                                                </CellStyle>
                                            </dx:GridViewDataComboBoxColumn>

                                            <dx:GridViewDataComboBoxColumn Caption="البلد" FieldName="countryId">
                                                <PropertiesComboBox DataSourceID="db_countryName" TextField="countryName" ValueField="id" ValueType="System.Int32">
                                                    <ItemStyle Font-Size="1.5em" />
                                                </PropertiesComboBox>
                                                <EditFormSettings Visible="False" />
                                                <CellStyle VerticalAlign="Middle" Font-Size="Large" HorizontalAlign="Center">
                                                </CellStyle>
                                            </dx:GridViewDataComboBoxColumn>

                                            <dx:GridViewDataComboBoxColumn Caption="الشركة" FieldName="companyId">
                                                <PropertiesComboBox DataSourceID="db_companyName" TextField="companyName" ValueField="id" ValueType="System.Int32">
                                                    <ItemStyle Font-Size="1.5em" />
                                                </PropertiesComboBox>
                                                <EditFormSettings Visible="False" />
                                                <CellStyle VerticalAlign="Middle" Font-Size="Large" HorizontalAlign="Center">
                                                </CellStyle>
                                            </dx:GridViewDataComboBoxColumn>


                                            <dx:GridViewDataComboBoxColumn Caption="رقم السائق" FieldName="username">
                                                <PropertiesComboBox DataSourceID="db_DeliveryUsers" TextField="username" ValueField="id" ValueType="System.Int32">
                                                    <ItemStyle Font-Size="1.5em" />
                                                </PropertiesComboBox>
                                                <EditFormSettings Visible="False" />
                                                <CellStyle VerticalAlign="Middle" Font-Size="Large" HorizontalAlign="Center">
                                                </CellStyle>
                                            </dx:GridViewDataComboBoxColumn>

                                            <dx:GridViewDataTextColumn FieldName="rateDesc" Caption="وصف التقييم">
                                                <PropertiesTextEdit EncodeHtml="false">
                                                    <ValidationSettings Display="Dynamic">
                                                        <RequiredField IsRequired="true" ErrorText="هذا الحقل مطلوب" />
                                                    </ValidationSettings>
                                                </PropertiesTextEdit>
                                                <CellStyle VerticalAlign="Middle" Font-Size="Large" HorizontalAlign="Center" />
                                            </dx:GridViewDataTextColumn>

                                            <dx:GridViewDataDateColumn FieldName="userDate" Caption="تاريخ التقييم">
                                                <PropertiesDateEdit DisplayFormatString="dd/MM/yyyy" />
                                                <EditFormSettings Visible="False" />
                                                <CellStyle VerticalAlign="Middle" Font-Size="Large" HorizontalAlign="Center" />
                                            </dx:GridViewDataDateColumn>

                                            <dx:GridViewDataColumn Caption="التقييم" FieldName="rate">
                                                <DataItemTemplate>
                                                    <dx:ASPxRatingControl ID="RatingStars" runat="server"
                                                        ReadOnly="true"
                                                        Value='<%# Convert.ToDouble(Eval("rate")) %>'
                                                        CssClass="stars"
                                                        ItemCount="5"
                                                        AllowHalf="true" />
                                                </DataItemTemplate>
                                                <EditFormSettings Visible="False" />
                                                <CellStyle VerticalAlign="Middle" HorizontalAlign="Center" />
                                            </dx:GridViewDataColumn>

                                            <dx:GridViewDataTextColumn Caption="" ShowInCustomizationForm="True" Width="100px">
                                                <EditFormSettings Visible="False" />
                                                <DataItemTemplate>
                                                    <div style="width: 100%; float: left; text-align: center">
                                                        <img src="/assets/img/update.png" width="32" height="32" title="تعديل" style="cursor: pointer" onclick="setTimeout(function(){GridDeliveryRates.StartEditRow(MyIndex);},100);" />
                                                    </div>
                                                </DataItemTemplate>
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

                                <%----------------------------------------------------%>
                                <div class="w-100 text-center my-4">
                                    <h2 class="pageTitle d-inline-block" style="font-family: Cairo">السائقين</h2>
                                </div>

                                <div class="navbar-main navbar-expand-lg px-0 mx-4 border-radius-xl bg-white shadow mt-3 mb-1">

                                    <dx:ASPxGridView ID="GridUsersDelivery" runat="server" DataSourceID="db_DeliveryUsers" KeyFieldName="id" ClientInstanceName="GridUsersDelivery" Width="100%" AutoGenerateColumns="False" EnablePagingCallbackAnimation="True" Font-Names="cairo" Font-Size="1em" RightToLeft="True">
                                        <Settings ShowFooter="True" ShowFilterRow="True" />


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
                                                <CellStyle VerticalAlign="Middle" Font-Size="Large" HorizontalAlign="Center" />
                                            </dx:GridViewDataColumn>

                                            
                                            <dx:GridViewDataColumn Caption="صورة السائق" FieldName="userPicture">

                                                <DataItemTemplate>
                                                    <div class="preview-container" style="text-align: center; display: flex; justify-content: center;">
                                                        <img
                                                            src='<%# GetFirstImagePath(Eval("id")) %>?v=<%# DateTime.Now.Ticks %>'
                                                            style="width: 7em; border: 1px solid #c8c8c8; border-radius: 5px; cursor: pointer;"
                                                            onclick="window.open(this.src, '_blank');" />
                                                    </div>
                                                </DataItemTemplate>
                                                <EditFormSettings Visible="False" />
                                            </dx:GridViewDataColumn>

                                            <dx:GridViewDataColumn Caption="اسم السائق" FieldName="fullName">

                                                <EditFormSettings Visible="False" />
                                                <CellStyle VerticalAlign="Middle" Font-Size="Large" HorizontalAlign="Center">
                                                </CellStyle>
                                            </dx:GridViewDataColumn>

                                            <dx:GridViewDataComboBoxColumn Caption="البلد" FieldName="countryId">
                                                <PropertiesComboBox DataSourceID="db_countryName" TextField="countryName" ValueField="id" ValueType="System.Int32">
                                                    <ItemStyle Font-Size="1.5em" />
                                                </PropertiesComboBox>
                                                <EditFormSettings Visible="False" />
                                                <CellStyle VerticalAlign="Middle" Font-Size="Large" HorizontalAlign="Center">
                                                </CellStyle>
                                            </dx:GridViewDataComboBoxColumn>

                                            <dx:GridViewDataColumn Caption="رقم السائق" FieldName="username">
                                                <EditFormSettings Visible="False" />
                                                <CellStyle VerticalAlign="Middle" Font-Size="Large" HorizontalAlign="Center">
                                                </CellStyle>
                                            </dx:GridViewDataColumn>

                                            <dx:GridViewDataColumn Caption="التقييم" FieldName="rate">
                                                <DataItemTemplate>
                                                    <dx:ASPxRatingControl ID="RatingStars" runat="server"
                                                        ReadOnly="true"
                                                        ReadOnlyPrecisionMode="Exact"
                                                        Value='<%# Convert.ToDouble(Eval("rate")) %>'
                                                        CssClass="stars"
                                                        ItemCount="5"
                                                        FillPrecision="Exact"
                                                        ToolTip='<%# Eval("rate").ToString() + " / 5" %>' />
                                                </DataItemTemplate>
                                                <EditFormSettings Visible="False" />
                                                <CellStyle VerticalAlign="Middle" HorizontalAlign="Center" />
                                            </dx:GridViewDataColumn>

                                            <dx:GridViewDataColumn Caption="عدد التقييمات" FieldName="rateCount">
                                                <EditFormSettings Visible="False" />
                                                <CellStyle VerticalAlign="Middle" Font-Size="Large" HorizontalAlign="Center" />
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
                                        ID="db_DeliveryRates"
                                        runat="server"
                                        ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>"
                                        SelectCommand="SELECT r.id, r.userDeliveryId, (u.firstName + ' ' + u.lastName) AS fullName, u.username,o.countryId,o.companyId, r.rate, r.rateDesc, r.userDate, r.rateApproved,  u.userPicture AS userPicture, r.orderId FROM usersDeliveryRates r INNER JOIN usersDelivery u ON r.userDeliveryId = u.id INNER JOIN orders o ON o.id = r.orderId WHERE r.rate > 0 order by r.id desc"
                                        UpdateCommand="UPDATE usersDeliveryRates SET rateDesc = @rateDesc WHERE id = @id">
                                        <UpdateParameters>
                                            <asp:Parameter Name="rateDesc" Type="String" />
                                            <asp:Parameter Name="id" Type="Int32" />
                                        </UpdateParameters>
                                    </asp:SqlDataSource>




                                    <asp:SqlDataSource
                                        ID="db_DeliveryUsers"
                                        runat="server"
                                        ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>"
                                        SelectCommand="SELECT id,(firstName + ' ' + lastName) AS fullName,countryId,username,rate,rateCount FROM [usersDelivery] where rate > 0 order by id desc"></asp:SqlDataSource>
                                </div>
                            </dx:ContentControl>
                        </dx:ContentControl>
                    </ContentCollection>
                </dx:TabPage>

            </TabPages>
        </dx:ASPxPageControl>
    </main>



</asp:Content>
