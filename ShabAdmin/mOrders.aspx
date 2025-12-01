<%@ Page Title="Branches" Language="C#" MasterPageFile="~/mSite.Master" AutoEventWireup="true" CodeBehind="mOrders.aspx.cs" Inherits="ShabAdmin.mOrders" %>

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


        </script>
        <!-- Google Maps API -->
        <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyDse2PDyMsk1P9u8nq8BsFvv6fWz0cLgiU"></script>

        <!-- دالة رسم الخريطة -->
        <script>
            function initCurrentMap() {
                if (!window.currentMapData || typeof google === 'undefined' || !google.maps) {
                    console.error('Google Maps API not loaded or no map data');
                    return;
                }
                var data = window.currentMapData;
                console.log(data);
                var position = { lat: parseFloat(data.lat), lng: parseFloat(data.lng) };
                console.log(position)

                var map = new google.maps.Map(document.getElementById(data.mapId), {
                    center: position,
                    zoom: 17,
                    mapTypeId: 'roadmap'
                });

                var customIcon = {
                    url: '/assets/animations/location map.gif',
                    scaledSize: new google.maps.Size(120, 120),
                    origin: new google.maps.Point(0, 0),
                    anchor: new google.maps.Point(60, 120)
                };


                var marker = new google.maps.Marker({
                    position: position,
                    map: map,
                    icon: customIcon,
                    title: 'موقع العنوان',
                    animation: google.maps.Animation.DROP
                });

                var infoWindow = new google.maps.InfoWindow({
                    content: '<div style="font-family: Cairo; direction: rtl; text-align: center;"><h4>' + data.title + '</h4><p>' + data.area + ', ' + data.city + '</p></div>'
                });

                marker.addListener('click', function () {
                    infoWindow.open(map, marker);
                });

                var img = new Image();
                img.onerror = function () {
                    console.warn('Custom marker icon failed to load, using default marker');
                    marker.setIcon(null);
                };
                img.src = customIcon.url;
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
            // ==================== Open Popup (Both Tabs) ====================
            function ShowRefundPopup(orderId, totalAmount, refundedAmount, paymentMethod1, paymentMethod2, refundType, secondAmount) {
                popupRefund.cpId = orderId;

                var t = parseFloat(totalAmount) || 0;
                var r = parseFloat(refundedAmount) || 0;
                var sec = parseFloat(secondAmount) || 0;

                // ==================== Wallet Tab ====================
                var availableWallet = parseFloat((t - r).toFixed(3));
                if (availableWallet < 0) availableWallet = 0;

                spinRefundQty.SetMaxValue(availableWallet);
                spinRefundQty.SetValue(availableWallet > 0 ? 1 : 0);
                spinRefundQty.SetEnabled(true);

                var txtWallet = document.getElementById("maxRefundText");
                if (txtWallet) {
                    txtWallet.innerText = "الحد الأقصى الممكن إرجاعه: " + availableWallet.toFixed(3) + " دينار";
                    txtWallet.style.color = "#d9534f";
                }

                // ==================== Credit Card Tab ====================
                var creditMax = 0;

                // إظهار تبويب البطاقة إذا فيه أي طريقة دفع = بطاقة
                if (paymentMethod1 == 2 || paymentMethod2 == 2) {
                    pageTab.GetTab(1).SetVisible(true);
                } else {
                    pageTab.GetTab(1).SetVisible(false);
                }

                if (refundType == 0 || refundType == 1) {

                    creditMax = sec > 0 ? sec : totalAmount; // كامل المبلغs
                }
                else if (refundType == 3) {

                    creditMax = r; // فقط المبلغ المُرجع
                }
                else if (refundType == 2) {

                    creditMax = 0; // لا يوجد إرجاع بطاقة
                }


                // ========== شرط الدفع الثاني = بطاقة ==========
                if (paymentMethod2 == 2 && refundType == 3) {

                    // البطاقة الثانية لها حد خاص
                    creditMax = Math.min(r, sec);
                }


                creditMax = parseFloat(creditMax.toFixed(3));

                // ========== تعيين القيم ==========
                spinRefundCardQty.SetMaxValue(creditMax);
                spinRefundCardQty.SetValue(creditMax > 0 ? creditMax : 0);

                var txtCard = document.getElementById("maxRefundTextCard");
                if (txtCard) {
                    txtCard.innerText = "الحد الأقصى لإرجاع البطاقة: " + creditMax.toFixed(3) + " دينار";
                }

                var chkCard = document.getElementById("chkMaxRefundCard");
                if (chkCard) chkCard.disabled = (creditMax <= 0);

                var btnCard = document.getElementById("btnConfirmRefundCard");
                if (btnCard) {
                    btnCard.disabled = (creditMax <= 0);
                    btnCard.style.opacity = creditMax > 0 ? "1" : "0.5";
                }

                pageTab.SetActiveTabIndex(0);
                popupRefund.Show();
            }



            // ==================== Show Refund Message Popup ====================
            function ShowRefundPopupMessage(title, message, type) {
                var container = document.getElementById("refundMessageContainer");
                var titleEl = document.getElementById("refundMessageTitle");
                var textEl = document.getElementById("refundMessageText");

                if (!container || !titleEl || !textEl) return;

                // تخصيص الألوان حسب نوع الرسالة
                if (type === "error") {
                    container.style.background = "linear-gradient(135deg, #fbe9e7, #ffebee)";
                    titleEl.style.color = "#c62828";
                } else {
                    container.style.background = "linear-gradient(135deg, #e8f5e9, #f1f8e9)";
                    titleEl.style.color = "#2e7d32";
                }

                // تعيين النصوص
                titleEl.innerText = title || "إشعار";
                textEl.innerText = message || "";

                popupRefundMessage.Show();
            }


            // ==================== Tab 1: Wallet Refund ====================
            function ConfirmRefund() {
                var amount = spinRefundQty.GetValue();
                if (!amount || amount <= 0) {
                    alert("يرجى إدخال مبلغ صحيح للإرجاع");
                    return;
                }
                callbackRefund.PerformCallback("refund:" + popupRefund.cpId + ":" + amount);
            }

            function OnRefundEndCallback(s, e) {
                popupRefund.Hide();
                GridOrders.Refresh();

                if (s.cpMessage) {
                    var isError = s.cpMessage.includes("خطأ") || s.cpMessage.includes("فشل");
                    ShowRefundPopupMessage(
                        isError ? "فشل الإرجاع" : "تم الإرجاع بنجاح",
                        s.cpMessage,
                        isError ? "error" : "success"
                    );
                }
            }


            function ToggleMaxRefund() {
                var chk = document.getElementById("chkMaxRefund");
                if (chk && chk.checked) {
                    spinRefundQty.SetValue(spinRefundQty.GetMaxValue());
                } else {
                    spinRefundQty.SetValue(1);
                }
            }

            // ==================== Tab 2: Card Refund ====================
            function ConfirmRefundCard() {
                var btnCard = document.querySelector("#popupRefund button[onclick='ConfirmRefundCard()']");
                if (btnCard && btnCard.disabled) {
                    alert("تم الإرجاع مسبقاً، لا يمكن تنفيذ العملية مرة أخرى.");
                    return;
                }

                var amount = spinRefundCardQty.GetValue();
                if (!amount || amount <= 0) {
                    alert("يرجى إدخال مبلغ صحيح للإرجاع");
                    return;
                }
                callbackRefundCard.PerformCallback("refund:" + popupRefund.cpId + ":" + amount);
            }

            function OnRefundCardEndCallback(s, e) {
                popupRefund.Hide();
                GridOrders.Refresh();

                if (s.cpMessage) {
                    var isError = s.cpMessage.includes("خطأ") || s.cpMessage.includes("فشل");
                    ShowRefundPopupMessage(
                        isError ? "فشل الإرجاع للبطاقة" : "تم الإرجاع للبطاقة بنجاح",
                        s.cpMessage,
                        isError ? "error" : "success"
                    );
                }
            }



            function ToggleMaxRefundCard() {
                var chk = document.getElementById("chkMaxRefundCard");
                if (chk && chk.checked) {
                    spinRefundCardQty.SetValue(spinRefundCardQty.GetMaxValue());
                } else {
                    spinRefundCardQty.SetValue(1);
                }
            }

        </script>

        <div class="w-100 text-center my-4">
            <h2 class="pageTitle d-inline-block" style="font-family: Cairo">الطلبيـــات</h2>
        </div>

        <div class="navbar-main navbar-expand-lg px-0 mx-4 border-radius-xl bg-white shadow mt-3 mb-1">

            <dx:ASPxGridView ID="GridOrders" runat="server" DataSourceID="db_Orders" KeyFieldName="id" ClientInstanceName="GridOrders" Width="100%" AutoGenerateColumns="False" EnablePagingCallbackAnimation="True" Font-Names="cairo" Font-Size="0.67em" RightToLeft="True">
                <Settings ShowFooter="True" ShowFilterRow="True" />
                <StylesPager>
                    <PageNumber Font-Size="16px" Font-Names="Cairo" />
                    <CurrentPageNumber Font-Size="17px" Font-Bold="true" Font-Names="Cairo" />
                    <Summary Font-Size="16px" Font-Names="Cairo" />
                    <PageSizeItem Font-Size="16px" Font-Names="Cairo" />
                </StylesPager>

                <SettingsPager PageSize="20"></SettingsPager>
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

                    <dx:GridViewDataComboBoxColumn Caption="حالة الطلب" FieldName="l_orderStatus">
                        <PropertiesComboBox
                            DataSourceID="db_orderStatus"
                            ValueField="id"
                            TextField="description"
                            ValueType="System.Int32">
                            <ValidationSettings RequiredField-IsRequired="True" ErrorText="يجب تحديد حالة الطلب" />
                        </PropertiesComboBox>
                        <DataItemTemplate>
                            <%# GetOrderStatusLottie(Eval("l_orderStatus").ToString(),Eval("id").ToString()) %>
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


                    <dx:GridViewDataColumn Caption="الموقع" FieldName="addressId">
                        <DataItemTemplate>
                            <a href="javascript:void(0);"
                                onclick="callbackAddress.PerformCallback('<%# Eval("addressId") %>'); popupAddress.Show();"
                                style="text-decoration: underline; color: #007bff; font-family: Cairo;">عرض الموفع
                            </a>
                        </DataItemTemplate>
                        <EditFormSettings Visible="False" />
                        <CellStyle VerticalAlign="Middle" HorizontalAlign="Center" />
                    </dx:GridViewDataColumn>

                    <dx:GridViewDataColumn Caption="المبلغ" FieldName="amount">
                        <DataItemTemplate>
                            <%# Eval("amount") + "</br>" + MainHelper.GetCurrency(Eval("countryId")) %>
                        </DataItemTemplate>
                        <EditFormSettings Visible="False" />
                        <CellStyle VerticalAlign="Middle" HorizontalAlign="Center">
                        </CellStyle>
                    </dx:GridViewDataColumn>

                    <dx:GridViewDataColumn Caption="مبلغ التوصيل" FieldName="deliveryAmount">
                        <DataItemTemplate>
                            <%# Eval("deliveryAmount") + "</br>" + MainHelper.GetCurrency(Eval("countryId")) %>
                        </DataItemTemplate>
                        <EditFormSettings Visible="False" />
                        <CellStyle VerticalAlign="Middle" HorizontalAlign="Center">
                        </CellStyle>
                    </dx:GridViewDataColumn>

                    <dx:GridViewDataColumn Caption="الضريبة" FieldName="taxAmount">
                        <DataItemTemplate>
                            <%# Eval("taxAmount") + "</br>" + MainHelper.GetCurrency(Eval("countryId")) %>
                        </DataItemTemplate>
                        <EditFormSettings Visible="False" />
                        <CellStyle VerticalAlign="Middle" HorizontalAlign="Center">
                        </CellStyle>
                    </dx:GridViewDataColumn>

                    <dx:GridViewDataColumn Caption="المبلغ الكلي" FieldName="totalAmount">
                        <DataItemTemplate>
                            <%# Eval("totalAmount") + "</br>" + MainHelper.GetCurrency(Eval("countryId")) %>
                        </DataItemTemplate>
                        <EditFormSettings Visible="False" />
                        <CellStyle VerticalAlign="Middle" Font-Bold="true" HorizontalAlign="Center">
                        </CellStyle>
                    </dx:GridViewDataColumn>

                    <dx:GridViewDataColumn Caption="القسيمة" FieldName="couponId">
                        <DataItemTemplate>
                            <%# 
                                Eval("couponId") != DBNull.Value && Convert.ToInt32(Eval("couponId")) > 0 
                                ? $"<a href='javascript:void(0);' onclick=\"callbackCoupon.PerformCallback('{Eval("couponId")}'); popupCoupon.Show();\" style='text-decoration: underline; color: #007bff; font-family: Cairo;'>عرض القسيمة</a>" 
                                : "" 
                            %>
                        </DataItemTemplate>
                        <EditFormSettings Visible="False" />
                        <CellStyle VerticalAlign="Middle" HorizontalAlign="Center" />
                    </dx:GridViewDataColumn>

                    <dx:GridViewDataColumn Caption="نقاط الشركة" FieldName="pointId">
                        <DataItemTemplate>
                            <%# 
                                Convert.ToInt32(Eval("pointId")) > 0 
                                ? Eval("points") + " نقطة - خصم " + Eval("discountAmount") + " " + MainHelper.GetCurrency(Eval("countryId")) 
                                : "لا يوجد" 
                            %>
                        </DataItemTemplate>
                        <EditFormSettings Visible="False" />
                        <CellStyle VerticalAlign="Middle" HorizontalAlign="Center" />
                    </dx:GridViewDataColumn>

                    <dx:GridViewDataColumn Caption="النقاط" FieldName="pointsUsed">
                        <EditFormSettings Visible="False" />
                        <CellStyle VerticalAlign="Middle" HorizontalAlign="Center">
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

                    <dx:GridViewDataColumn Caption="إرجاع" Width="80px">
                        <DataItemTemplate>
                            <%# GetRefundStatus(
    Eval("l_orderStatus") != DBNull.Value ? Convert.ToInt32(Eval("l_orderStatus")) : 0,
    Eval("totalAmount") != DBNull.Value ? Convert.ToDecimal(Eval("totalAmount")) : 0m,
    Eval("refundedAmount") != DBNull.Value ? Convert.ToDecimal(Eval("refundedAmount")) : 0m,
    Eval("l_paymentMethodId") != DBNull.Value ? Convert.ToInt32(Eval("l_paymentMethodId")) : 0,
    Eval("id") != DBNull.Value ? Convert.ToInt32(Eval("id")) : 0,
    Eval("l_paymentMethodId2") != DBNull.Value ? Convert.ToInt32(Eval("l_paymentMethodId2")) : 0,
    Eval("l_RefundType") != DBNull.Value ? Convert.ToInt32(Eval("l_RefundType")) : 0,
    Eval("l_paymentMethodId2Amount") != DBNull.Value ? Convert.ToDecimal(Eval("l_paymentMethodId2Amount")) : 0m
) %>
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
                </TotalSummary>
                <Styles>
                    <AlternatingRow BackColor="#F0F0F0">
                    </AlternatingRow>
                    <Footer Font-Names="cairo" Font-Size="16px">
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
                SelectCommand="SELECT id, countryName FROM countries"></asp:SqlDataSource>
            <asp:SqlDataSource
                ID="dsCompanies"
                runat="server"
                ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>"
                SelectCommand="SELECT id, companyName FROM companies"></asp:SqlDataSource>

            <asp:SqlDataSource
                ID="db_Orders"
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
                    o.[pointsUsed],
                    o.[pointId],
                    po.[points],
                    po.[discountAmount],
                    o.[l_paymentMethodId],
                    o.[l_paymentMethodId2],
                    o.[l_paymentMethodId2Amount],
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
                LEFT JOIN 
                    [pointsOffers] po ON o.pointId = po.id
                ORDER BY o.id DESC"></asp:SqlDataSource>

        </div>

        <dx:ASPxPopupControl ID="popupRefund" runat="server"
            ClientInstanceName="popupRefund"
            HeaderText="طلب إرجاع"
            PopupHorizontalAlign="WindowCenter"
            PopupVerticalAlign="WindowCenter"
            Width="450px"
            ShowCloseButton="true"
            Modal="true"
            Font-Names="Cairo" Font-Size="14px">

            <ContentCollection>
                <dx:PopupControlContentControl runat="server">

                    <dx:ASPxPageControl ID="pageTab" runat="server"
                        CssClass="divSTARProviders"
                        ActiveTabIndex="0"
                        ClientInstanceName="pageTab"
                        Theme="Material"
                        Width="100%"
                        EnableCallbackAnimation="True">

                        <TabPages>

                            <dx:TabPage Text="ارجاع الى المحفظة"
                                TabStyle-Font-Bold="true"
                                TabStyle-Font-Names="cairo"
                                TabStyle-Font-Size="X-Large">

                                <ContentCollection>
                                    <dx:ContentControl>

                                        <dx:ASPxCallbackPanel ID="callbackRefund" runat="server"
                                            ClientInstanceName="callbackRefund"
                                            OnCallback="callbackRefund_Callback">
                                            <ClientSideEvents EndCallback="OnRefundEndCallback" />

                                            <PanelCollection>
                                                <dx:PanelContent runat="server">

                                                    <div style="padding: 25px; text-align: center; font-family: Cairo;">

                                                        <div style="font-size: 20px; font-weight: bold; margin-bottom: 20px; color: #333;">
                                                            الرجاء إدخال مبلغ الإرجاع
                                               
                                                        </div>

                                                        <div style="width: 100%; max-width: 320px; margin: 0 auto; background: #f9f9f9; padding: 15px; border-radius: 8px; box-shadow: 0 1px 4px rgba(0,0,0,0.1);">
                                                            <dx:ASPxSpinEdit ID="spinRefundQty" runat="server"
                                                                ClientInstanceName="spinRefundQty"
                                                                NumberType="Float"
                                                                MinValue="0"
                                                                MaxValue="9999999"
                                                                Increment="0.01"
                                                                DecimalPlaces="3"
                                                                Width="100%"
                                                                Font-Names="Cairo" Font-Size="21px">
                                                            </dx:ASPxSpinEdit>
                                                        </div>

                                                        <div id="maxRefundText"
                                                            style="margin-top: 10px; color: #d9534f; font-family: Cairo; font-size: 14px; font-weight: bold;">
                                                        </div>

                                                        <div style="margin-top: 15px; font-family: Cairo; font-size: 14px; display: flex; align-items: center; justify-content: center; gap: 8px;">
                                                            <input type="checkbox" id="chkMaxRefund" onclick="ToggleMaxRefund()" style="cursor: pointer;" />
                                                            <label for="chkMaxRefund" style="cursor: pointer;">إرجاع كامل المبلغ</label>
                                                        </div>
                                                        <div style="margin-top: 25px;">
                                                            <button type="button"
                                                                id="btnConfirmRefund"
                                                                onclick="ConfirmRefund()"
                                                                style="width: 100%; height: 45px; background: linear-gradient(90deg, #e53935, #d32f2f); color: white; font-family: Cairo; font-size: 15px; font-weight: bold; border: none; border-radius: 8px; cursor: pointer; box-shadow: 0 3px 6px rgba(0,0,0,0.15); transition: background 0.3s;">
                                                                تأكيد الإرجاع
   
                                                            </button>
                                                        </div>


                                                    </div>

                                                </dx:PanelContent>
                                            </PanelCollection>
                                        </dx:ASPxCallbackPanel>

                                    </dx:ContentControl>
                                </ContentCollection>
                            </dx:TabPage>

                            <dx:TabPage Text="ارجاع الى البطاقة"
                                TabStyle-Font-Bold="true"
                                TabStyle-Font-Names="cairo"
                                TabStyle-Font-Size="X-Large">

                                <ContentCollection>
                                    <dx:ContentControl>

                                        <dx:ASPxCallbackPanel ID="callbackRefundCard" runat="server"
                                            ClientInstanceName="callbackRefundCard"
                                            OnCallback="callbackRefundCard_Callback">
                                            <ClientSideEvents EndCallback="OnRefundCardEndCallback" />

                                            <PanelCollection>
                                                <dx:PanelContent runat="server">

                                                    <div style="padding: 25px; text-align: center; font-family: Cairo;">

                                                        <div style="font-size: 20px; font-weight: bold; margin-bottom: 20px; color: #333;">
                                                            الرجاء إدخال مبلغ الإرجاع
                                               
                                                        </div>

                                                        <div style="width: 100%; max-width: 320px; margin: 0 auto; background: #f9f9f9; padding: 15px; border-radius: 8px; box-shadow: 0 1px 4px rgba(0,0,0,0.1);">
                                                            <dx:ASPxSpinEdit ID="spinRefundCardQty" runat="server"
                                                                ClientInstanceName="spinRefundCardQty"
                                                                NumberType="Float"
                                                                MinValue="0.01"
                                                                MaxValue="9999999"
                                                                Increment="0.01"
                                                                DecimalPlaces="3"
                                                                Width="100%"
                                                                Font-Names="Cairo" Font-Size="21px">
                                                            </dx:ASPxSpinEdit>
                                                        </div>

                                                        <div id="maxRefundTextCard"
                                                            style="margin-top: 10px; color: #d9534f; font-family: Cairo; font-size: 14px; font-weight: bold;">
                                                        </div>

                                                        <div style="margin-top: 15px; font-family: Cairo; font-size: 14px; display: flex; align-items: center; justify-content: center; gap: 8px;">
                                                            <input type="checkbox" id="chkMaxRefundCard" onclick="ToggleMaxRefundCard()" style="cursor: pointer;" />
                                                            <label for="chkMaxRefundCard" style="cursor: pointer;">إرجاع كامل المبلغ</label>
                                                        </div>

                                                        <div style="margin-top: 25px;">
                                                            <button type="button"
                                                                onclick="ConfirmRefundCard()"
                                                                style="width: 100%; height: 45px; background: linear-gradient(90deg, #1976d2, #1565c0); color: white; font-family: Cairo; font-size: 15px; font-weight: bold; border: none; border-radius: 8px; cursor: pointer; box-shadow: 0 3px 6px rgba(0,0,0,0.15); transition: background 0.3s;">
                                                                تأكيد الإرجاع للبطاقة
                                                   
                                                            </button>
                                                        </div>

                                                    </div>

                                                </dx:PanelContent>
                                            </PanelCollection>
                                        </dx:ASPxCallbackPanel>

                                    </dx:ContentControl>
                                </ContentCollection>
                            </dx:TabPage>

                        </TabPages>
                    </dx:ASPxPageControl>

                </dx:PopupControlContentControl>
            </ContentCollection>
        </dx:ASPxPopupControl>


        <dx:ASPxTextBox ID="l_Order_Id" runat="server" BackColor="Transparent" ClientInstanceName="l_Order_Id" Font-Size="0pt" ForeColor="Transparent" Text="" Width="0px" Theme="Default">
            <Border BorderStyle="None" BorderWidth="0px" />
        </dx:ASPxTextBox>


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
                                ) + "</br>" + MainHelper.GetCurrency(Eval("countryId"))
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
            p.id AS PID,
            c.productPrice,
            p.countryId,
            c.quantity,
            c.price,
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


    <dx:ASPxPopupControl runat="server" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter"
        AutoUpdatePosition="True" Modal="True" ClientInstanceName="Pop_Del_Grids" CloseAnimationType="Slide"
        FooterText="" HeaderText="حذف شركة" Font-Names="Cairo" Width="350px" Height="150px" ID="Pop_Del_Compnies">
        <ContentCollection>
            <dx:PopupControlContentControl runat="server">
                <div style="padding: 10px; font-family: 'Cairo', sans-serif; height: 230px; z-index: 3; text-align: center">
                    <div class="mb-3" style="width: 100%;">
                        <div style="text-align: center">
                            <img src="assets/img/danger.png" height="60px" alt="danger" />
                        </div>
                        <dx:ASPxLabel runat="server" Text="هل أنت متأكد من حذف الشركة وافرعها ومنتجاتها بشكل كامل؟" ClientInstanceName="labelCompnies"
                            Font-Names="Cairo" Font-Size="Medium" ForeColor="#333333" ID="labelCompnies">
                        </dx:ASPxLabel>
                    </div>
                    <div style="width: 100%; margin-top: 20px; text-align: center;">
                        <dx:ASPxButton ID="Btn_Del_Compnies" runat="server" AutoPostBack="False" Text="حــــــــذف"
                            UseSubmitBehavior="False" Font-Names="Cairo" HorizontalAlign="Center" VerticalAlign="Middle">
                            <ClientSideEvents Click="function(s, e) { 
                 GridCompanies.DeleteRow(MyIndex); 
                 setTimeout(function() { GridCompanies.Refresh(); }, 200);
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
    <dx:ASPxPopupControl ID="popupAddress" runat="server" ClientInstanceName="popupAddress"
        Width="750px" Font-Names="Cairo" HeaderText="تفاصيل العنوان" ShowCloseButton="true"
        PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" Modal="true">
        <ClientSideEvents Shown="function(s, e) { s.UpdatePosition(); }" />
        <ContentCollection>
            <dx:PopupControlContentControl>
                <dx:ASPxCallbackPanel ID="callbackAddress" runat="server" ClientInstanceName="callbackAddress"
                    OnCallback="callbackAddress_Callback">
                    <ClientSideEvents EndCallback="function(s, e) { 
        var json = s.cpMapData; // أو s.GetJSProperty('cpMapData') حسب النسخة
        if (json) {
            window.currentMapData = JSON.parse(json);
            if (window.initCurrentMap && window.currentMapData) { 
                window.initCurrentMap(); 
            }
        } else {
            console.error('No map data from JSProperties!');
        }
    }" />
                    <PanelCollection>
                        <dx:PanelContent>
                            <asp:Label ID="lblAddressInfo" runat="server" Font-Names="Cairo" Text="جارٍ تحميل التفاصيل..." />
                        </dx:PanelContent>
                    </PanelCollection>
                </dx:ASPxCallbackPanel>
            </dx:PopupControlContentControl>
        </ContentCollection>
    </dx:ASPxPopupControl>

    <dx:ASPxPopupControl ID="popupCoupon" runat="server" ClientInstanceName="popupCoupon"
        Width="500px" HeaderText="تفاصيل القسيمة" Font-Names="Cairo" ShowCloseButton="true"
        PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" Modal="true">
        <ClientSideEvents Shown="function(s,e){ s.UpdatePosition()}" />
        <ContentCollection>
            <dx:PopupControlContentControl>
                <dx:ASPxCallbackPanel ID="callbackCoupon" runat="server" ClientInstanceName="callbackCoupon"
                    OnCallback="callbackCoupon_Callback">
                    <PanelCollection>
                        <dx:PanelContent>
                            <asp:Label ID="lblCouponInfo" runat="server" Text="جارٍ تحميل التفاصيل..." />
                        </dx:PanelContent>
                    </PanelCollection>
                </dx:ASPxCallbackPanel>
            </dx:PopupControlContentControl>
        </ContentCollection>
    </dx:ASPxPopupControl>

    <dx:ASPxPopupControl ID="popupRefundMessage" runat="server"
        ClientInstanceName="popupRefundMessage"
        Width="400px"
        HeaderText="إشعار"
        ShowCloseButton="true"
        PopupHorizontalAlign="WindowCenter"
        PopupVerticalAlign="WindowCenter"
        Modal="true"
        HeaderStyle-Font-Names="Cairo"
        Font-Names="Cairo"
        PopupAnimationType="Fade">

        <ContentCollection>
            <dx:PopupControlContentControl>
                <div id="refundMessageContainer"
                    style="padding: 25px; font-family: Cairo; font-size: 1.2em; line-height: 1.8; text-align: center;">
                    <strong id="refundMessageTitle" style="display: block; font-size: 1.3em; margin-bottom: 10px;"></strong>
                    <span id="refundMessageText"></span>
                </div>
            </dx:PopupControlContentControl>
        </ContentCollection>
    </dx:ASPxPopupControl>




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





</asp:Content>
