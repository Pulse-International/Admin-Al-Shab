<%@ Page Title="Refund
    "
    Language="C#" MasterPageFile="~/mSite.Master" AutoEventWireup="true" CodeBehind="mRefund.aspx.cs" Inherits="ShabAdmin.mRefund" %>

<%@ Register Assembly="DevExpress.Web.v24.1, Version=24.1.6.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">


    <main>
        <script>
            var MyId;
            var MyIndex;
            var MyIndexDetail;

            function OnRowClick(s, e) {
                MyIndex = e.visibleIndex;
                GridPoints.GetRowValues(e.visibleIndex, 'id', OnGetRowValues);
            }

            function OnGetRowValues(Value) {
                MyId = Value[0];

            }


            function OnGridBeginCallback(s, e) {
                if (e.command == 'STARTEDIT') {
                }
                if (e.command == 'ADDNEWROW') {
                    MyId = 0;

                }
                if (e.command == 'UPDATEEDIT') {
                    //Your code here when the Update button is clicked  
                }
                if (e.command == 'DELETEROW') {
                    //Your code here when the Delete button is clicked  
                }
                //and so on...  
            }

            function ShowOrderProducts(orderId) {
                l_Order_Id.SetText(orderId);

                setTimeout(function () {
                    popupOrderProducts.Show();
                    setTimeout(function () {
                        gridOrderProducts.Refresh();
                    }, 300); // wait for popup layout, then refresh
                }, 100);
            }


        </script>

        <div class="w-100 text-center my-4">
            <h2 class="pageTitle d-inline-block" style="font-family: Cairo">المرتجعات</h2>
        </div>

        <div class="navbar-main navbar-expand-lg px-0 mx-4 border-radius-xl bg-white shadow mt-3 mb-1">


            <dx:ASPxGridView ID="GridRefunds" runat="server" DataSourceID="db_Refunds" KeyFieldName="id" ClientInstanceName="GridRefunds" Width="100%" AutoGenerateColumns="False" EnablePagingCallbackAnimation="True" Font-Names="cairo" Font-Size="1em" RightToLeft="True">
                <Settings ShowFilterRow="True" ShowFilterRowMenu="False" ShowHeaderFilterButton="False" AutoFilterCondition="Contains" />

                <ClientSideEvents RowClick="OnRowClick" />
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

                    <dx:GridViewDataColumn Caption="اسم المُرجع" FieldName="refundedUser">
                        <EditFormSettings Visible="False" />
                        <CellStyle VerticalAlign="Middle" HorizontalAlign="Center">
                        </CellStyle>
                        <FooterCellStyle HorizontalAlign="Center" Font-Bold="true" />
                    </dx:GridViewDataColumn>

                    <dx:GridViewDataColumn Caption="السعر" FieldName="amount">
                        <DataItemTemplate>
                            <%# Eval("amount") + "</br>" + MainHelper.GetCurrency(Eval("countryId")) %>
                        </DataItemTemplate>
                        <EditFormSettings Visible="False" />
                        <CellStyle VerticalAlign="Middle" HorizontalAlign="Center">
                        </CellStyle>
                        <FooterCellStyle HorizontalAlign="Center" Font-Bold="true" />
                    </dx:GridViewDataColumn>

                    <dx:GridViewDataColumn Caption="سعر التوصيل" FieldName="deliveryAmount">
                        <DataItemTemplate>
                            <%# Eval("deliveryAmount") + "</br>" + MainHelper.GetCurrency(Eval("countryId")) %>
                        </DataItemTemplate>
                        <EditFormSettings Visible="False" />
                        <CellStyle VerticalAlign="Middle" HorizontalAlign="Center">
                        </CellStyle>
                        <FooterCellStyle HorizontalAlign="Center" Font-Bold="true" />
                    </dx:GridViewDataColumn>

                    <dx:GridViewDataColumn Caption="الضريبة" FieldName="taxAmount">
                        <DataItemTemplate>
                            <%# Eval("taxAmount") + "</br>" + MainHelper.GetCurrency(Eval("countryId")) %>
                        </DataItemTemplate>
                        <EditFormSettings Visible="False" />
                        <CellStyle VerticalAlign="Middle" HorizontalAlign="Center">
                        </CellStyle>
                        <FooterCellStyle HorizontalAlign="Center" Font-Bold="true" />
                    </dx:GridViewDataColumn>

                    <dx:GridViewDataColumn Caption="السعر الكلي" FieldName="totalAmount">
                        <DataItemTemplate>
                            <%# Eval("totalAmount") + "</br>" + MainHelper.GetCurrency(Eval("countryId")) %>
                        </DataItemTemplate>
                        <EditFormSettings Visible="False" />
                        <CellStyle VerticalAlign="Middle" Font-Bold="true" HorizontalAlign="Center">
                        </CellStyle>
                        <FooterCellStyle HorizontalAlign="Center" Font-Bold="true" />
                    </dx:GridViewDataColumn>


                    <dx:GridViewDataColumn Caption="المبلغ المرتجع" FieldName="refundedAmount">
                        <DataItemTemplate>
                            <%# Eval("refundedAmount") + "</br>" + MainHelper.GetCurrency(Eval("countryId")) %>
                        </DataItemTemplate>
                        <EditFormSettings Visible="False" />
                        <CellStyle VerticalAlign="Middle" HorizontalAlign="Center">
                        </CellStyle>
                        <FooterCellStyle HorizontalAlign="Center" Font-Bold="true" />
                    </dx:GridViewDataColumn>

                    <dx:GridViewDataColumn Caption="الضريبة بعد الارجاع" FieldName="realTax">
                        <DataItemTemplate>
                            <%# Eval("realTax") + "</br>" + MainHelper.GetCurrency(Eval("countryId")) %>
                        </DataItemTemplate>
                        <EditFormSettings Visible="False" />
                        <CellStyle VerticalAlign="Middle" HorizontalAlign="Center">
                        </CellStyle>
                        <FooterCellStyle HorizontalAlign="Center" Font-Bold="true" />
                    </dx:GridViewDataColumn>

                    <dx:GridViewDataColumn Caption="السعر الكلي بعد الارجاع" FieldName="realTotalAmount">
                        <DataItemTemplate>
                            <%# Eval("realTotalAmount") + "</br>" + MainHelper.GetCurrency(Eval("countryId")) %>
                        </DataItemTemplate>
                        <EditFormSettings Visible="False" />
                        <CellStyle VerticalAlign="Middle" Font-Bold="true" HorizontalAlign="Center">
                        </CellStyle>
                        <FooterCellStyle HorizontalAlign="Center" Font-Bold="true" />
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

                    <dx:GridViewDataDateColumn FieldName="refundedDate" Caption="التاريخ">
                        <PropertiesDateEdit DisplayFormatString="yyyy/MM/dd hh:mm tt">
                        </PropertiesDateEdit>
                        <CellStyle HorizontalAlign="Center" VerticalAlign="Middle"  />
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

                    <dx:ASPxSummaryItem FieldName="amount" SummaryType="Sum" DisplayFormat="{0:N3}" />
                    <dx:ASPxSummaryItem FieldName="deliveryAmount" SummaryType="Sum" DisplayFormat="{0:N3}" />
                    <dx:ASPxSummaryItem FieldName="taxAmount" SummaryType="Sum" DisplayFormat="{0:N3}" />
                    <dx:ASPxSummaryItem FieldName="totalAmount" SummaryType="Sum" DisplayFormat="{0:N3}" />
                    <dx:ASPxSummaryItem FieldName="refundedAmount" SummaryType="Sum" DisplayFormat="{0:N3}" />
                    <dx:ASPxSummaryItem FieldName="realTax" SummaryType="Sum" DisplayFormat="{0:N3}" />
                    <dx:ASPxSummaryItem FieldName="realTotalAmount" SummaryType="Sum" DisplayFormat="{0:N3}" />
                </TotalSummary>
                <Styles>
                    <AlternatingRow BackColor="#F0F0F0">
                    </AlternatingRow>
                    <Footer Font-Names="cairo">
                    </Footer>
                </Styles>
                <Paddings Padding="2em" />
            </dx:ASPxGridView>

            <dx:ASPxTextBox ID="l_Order_Id" runat="server" BackColor="Transparent" ClientInstanceName="l_Order_Id" Font-Size="0pt" ForeColor="Transparent" Text="" Width="0px" Theme="Default">
                <Border BorderStyle="None" BorderWidth="0px" />
            </dx:ASPxTextBox>

            <dx:ASPxPopupControl ID="popupOrderProducts" runat="server"
                ClientInstanceName="popupOrderProducts"
                Width="900px" HeaderText="المنتجات في الطلب"
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
                            Font-Names="Cairo" Font-Size="0.9em" RightToLeft="True"
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

                                <dx:GridViewDataColumn FieldName="productName" Caption="المنتج">
                                    <CellStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                </dx:GridViewDataColumn>

                                <%--<dx:GridViewDataTextColumn Caption="السعر" FieldName="productPrice" Width="15%">
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
) + "</br>" + MainHelper.GetCurrency(Eval("countryId"))
                                        %>
                                    </DataItemTemplate>
                                    <CellStyle HorizontalAlign="Center" VerticalAlign="Middle" />
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

            <asp:SqlDataSource
                ID="db_Refunds"
                runat="server"
                ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>"
                SelectCommand="
       SELECT 
    o.id,
    o.username,
    o.companyId,
    o.countryId,
    c.[companyName] AS companyName, 
    co.[countryName] AS countryName,
    o.amount,
    o.deliveryAmount,
    o.taxAmount,
    o.totalAmount,
    o.refundedAmount,
    u.[firstName] + ' ' + u.[lastName] AS fullName,
    o.realTax,
    o.realTotalAmount,
    o.refundedUser,
    o.refundedDate,
    o.l_orderStatus
FROM orders o
LEFT JOIN [usersApp] u ON o.username = u.username
JOIN [companies] c ON o.companyId = c.id
LEFT JOIN countries co ON c.countryID = co.id
WHERE o.l_orderStatus = 5 OR o.l_orderStatus = 6
ORDER BY o.refundedDate DESC;

    "></asp:SqlDataSource>

            <asp:SqlDataSource
                ID="dsCompanies"
                runat="server"
                ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>"
                SelectCommand="SELECT id, companyName FROM companies"></asp:SqlDataSource>

            <asp:SqlDataSource
                ID="db_orderStatus"
                runat="server"
                ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>"
                SelectCommand="SELECT id, description FROM L_OrderStatus" />


        </div>
    </main>



</asp:Content>
