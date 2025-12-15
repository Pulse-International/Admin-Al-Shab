<%@ Page Title="Branches" Language="C#" MasterPageFile="~/mSite.Master" AutoEventWireup="true" CodeBehind="mRealOrders.aspx.cs" Inherits="ShabAdmin.mRealOrders" %>

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

            .red-text {
                color: red !important;
            }

            .divSTARProviders {
                text-align: center;
                margin-left: auto;
                margin-right: auto;
            }

            .dxtcLite_Material.dxtc-top > .dxtc-stripContainer {
                display: inline-block;
            }
        </style>

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
        <script src="<%= Key %>"></script>

        <script>
            let maps = {};
            let markers = {};
            let mapIntervals = {};
            let lastPositions = {};
            let overlays = {};

            class RotatingGifOverlay extends google.maps.OverlayView {
                constructor(position, map, imageUrl) {
                    super();
                    this.position = position;
                    this.map = map;
                    this.imageUrl = imageUrl;
                    this.div = null;
                    this.rotation = 0;
                    this.setMap(map);
                }

                onAdd() {
                    const div = document.createElement("div");
                    div.style.position = "absolute";
                    div.style.transition = "transform 0.3s ease-out";
                    div.innerHTML = `<img src="${this.imageUrl}" style="width: 70px; height: 110px;" />`;
                    this.div = div;

                    const panes = this.getPanes();
                    panes.overlayImage.appendChild(div);
                }

                draw() {
                    const overlayProjection = this.getProjection();
                    const pixel = overlayProjection.fromLatLngToDivPixel(new google.maps.LatLng(this.position.lat, this.position.lng));
                    if (this.div) {
                        this.div.style.left = pixel.x - 30 + "px";
                        this.div.style.top = pixel.y - 50 + "px";

                        this.div.style.transition = "none";
                        this.div.style.transform = `rotate(${this.rotation}deg)`;
                    }
                }

                update(position, bearing) {
                    this.position = position;
                    this.rotation = bearing;
                    this.draw();
                }

                onRemove() {
                    if (this.div) {
                        this.div.parentNode.removeChild(this.div);
                        this.div = null;
                    }
                }
            }


            function calculateBearing(start, end) {
                const lat1 = start.lat * Math.PI / 180;
                const lng1 = start.lng * Math.PI / 180;
                const lat2 = end.lat * Math.PI / 180;
                const lng2 = end.lng * Math.PI / 180;

                const dLng = lng2 - lng1;

                const y = Math.sin(dLng) * Math.cos(lat2);
                const x = Math.cos(lat1) * Math.sin(lat2) -
                    Math.sin(lat1) * Math.cos(lat2) * Math.cos(dLng);

                const brng = Math.atan2(y, x) * 180 / Math.PI;
                return (brng + 360) % 360; // Normalize to [0,360]
            }

            function initCurrentMap() {
                if (!window.currentMapData || typeof google === 'undefined' || !google.maps) {
                    console.error('Google Maps API not loaded or no map data');
                    return;
                }

                const data = window.currentMapData;
                const divId = data.mapId;
                const position = {
                    lat: parseFloat(data.lat),
                    lng: parseFloat(data.lng)
                };

                if (!divId) {
                    console.warn("No mapId specified in currentMapData");
                    return;
                }

                maps[divId] = new google.maps.Map(document.getElementById(divId), {
                    center: position,
                    zoom: 15,
                    mapTypeId: 'roadmap'
                });

                const trafficLayer = new google.maps.TrafficLayer();
                trafficLayer.setMap(maps[divId]);

                google.maps.event.trigger(maps[divId], 'resize');
                maps[divId].setCenter(position);

                const customIcon = {
                    url: '/assets/animations/car.gif',
                    scaledSize: new google.maps.Size(1, 1),
                    origin: new google.maps.Point(0, 0),
                    anchor: new google.maps.Point(60, 60)
                };


                markers[divId] = new google.maps.Marker({
                    position: position,
                    map: maps[divId],
                    icon: customIcon,
                    title: 'موقع العنوان',
                    animation: google.maps.Animation.DROP
                });

                const infoWindow = new google.maps.InfoWindow({
                    content: `<div style="font-family: Cairo; direction: rtl; text-align: center;">
                        <h4>${data.title}</h4>
                        <p>${data.area}, ${data.city}</p>
                      </div>`
                });

                markers[divId].addListener('click', () => {
                    infoWindow.open(maps[divId], markers[divId]);
                });

                const img = new Image();
                img.onerror = () => {
                    console.warn('Fallback to default marker');
                    markers[divId].setIcon(null);
                };
                img.src = customIcon.url;
            }

            function startTracking(locationId, mapDivId) {
                if (!mapDivId || !locationId) return;

                resetMap(mapDivId);

                window.currentMapDivId = mapDivId;

                if (mapIntervals[mapDivId]) clearInterval(mapIntervals[mapDivId]);

                function fetchLocation() {
                    callbackLocation.PerformCallback(locationId);
                }

                fetchLocation();
                mapIntervals[mapDivId] = setInterval(fetchLocation, 3000);
            }
            function resetMap(divId) {


                if (overlays[divId]) {
                    overlays[divId].onRemove();
                    delete overlays[divId];
                }

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


            function ShowRejectPopup(orderId) {
                document.getElementById("lblRejectOrderId").value = orderId;
                document.getElementById("txtRejectNote").value = "";
                document.getElementById("rejectNoteError").style.display = "none"; // إخفاء رسالة الخطأ عند فتح البوب أب
                popupReject.Show();
            }

            // تأكيد الرفض وإرسال callback
            function ConfirmReject() {
                var id = document.getElementById("lblRejectOrderId").value;
                var note = document.getElementById("txtRejectNote").value;
                var errorDiv = document.getElementById("rejectNoteError");

                if (!note || note.trim() === "") {
                    errorDiv.style.display = "block"; // عرض رسالة الخطأ باللون الأحمر
                    return;
                }

                errorDiv.style.display = "none"; // إخفاء الرسالة إذا كل شيء صحيح

                // إرسال الكول باك للـ ASPxGridView
                GridOrders.PerformCallback("reject:" + id + ":" + note);

                // إغلاق البوب أب
                popupReject.Hide();
            }
            var approveOrderId = 0;

            function ShowApprovePopup(orderId) {
                approveOrderId = orderId;
                popupApprove1.Show();
            }

            function ConfirmApproveNow() {
                popupApprove1.Hide();
                callbackApprove.PerformCallback(approveOrderId);
                setTimeout(function () {
                    GridOrders.Refresh();
                }, 300);
            }

            function copyMapLink(link, iconId) {
                navigator.clipboard.writeText(link).then(function () {
                    var icon = document.getElementById(iconId);
                    icon.style.display = 'inline';

                    setTimeout(function () {
                        icon.style.display = 'none';
                    }, 2500);
                });
            }

            setInterval(function () {
                if (typeof GridOrders !== "undefined") {
                    GridOrders.Refresh();
                }
            }, 30000);

        </script>

        <dx:ASPxCallback ID="callbackLocation" runat="server" ClientInstanceName="callbackLocation"
            OnCallback="callbackLocation_Callback">
            <ClientSideEvents EndCallback="function(s, e) {
           var data = s.cpMapData;

           if (!data || data === 'null' || data === 'invalid') {
               console.warn('No location returned.');
               return;
           }

           var result = JSON.parse(data);
           var pos = {
               lat: parseFloat(result.lat),
               lng: parseFloat(result.lng)
           };

           var divId = window.currentMapDivId;
           if (!divId) {
               console.warn('No mapDivId set.');
               return;
           }

           // ✅ اختر صورة الدراجة أو السيارة حسب نوع المركبة
           var imageUrl = result.l_vehicleType === '2'
               ? '/assets/animations/bike.png'
               : '/assets/animations/WhiteCar.png';

           if (!maps[divId]) {
               maps[divId] = new google.maps.Map(document.getElementById(divId), {
                   center: pos,
                   zoom: 17
               });

               google.maps.event.trigger(maps[divId], 'resize');
               maps[divId].setCenter(pos);

               var customIcon = {
                   url: imageUrl, // ✅ استخدم الصورة الديناميكية هنا
                   scaledSize: new google.maps.Size(160, 160),
                   origin: new google.maps.Point(0, 0),
                   anchor: new google.maps.Point(60, 120)
               };

               markers[divId] = new google.maps.Marker({
                   position: pos,
                   map: maps[divId],
                   icon: customIcon,
                   animation: google.maps.Animation.DROP
               });
           } else {
               if (!window.overlays) window.overlays = {};

               if (!overlays[divId]) {
                   overlays[divId] = new RotatingGifOverlay(pos, maps[divId], imageUrl); 
               } else {
                   const last = lastPositions[divId];

                   const bearing = (!last || last.lat !== pos.lat)
                       ? calculateBearing(last || pos, pos)
                       : overlays[divId].rotation;

                   overlays[divId].imageUrl = imageUrl; 
                   overlays[divId].update(pos, bearing);
               }

               lastPositions[divId] = pos;
               maps[divId].setCenter(pos);
           }
       }" />
        </dx:ASPxCallback>


        <div class="w-100 text-center my-4">
            <h2 class="pageTitle d-inline-block" style="font-family: Cairo">الطلبيـــات</h2>
        </div>
        <dx:ASPxPageControl ID="pageTab" runat="server" CssClass="divSTARProviders" ActiveTabIndex="0" ClientInstanceName="pageTab" Theme="Material" Width="100%" EnableCallbackAnimation="True">
            <TabPages>
                <dx:TabPage Text="تتبع الطلبيات" TabStyle-Font-Bold="true" TabStyle-Font-Names="cairo" TabStyle-Font-Size="X-Large">
                    <TabStyle Font-Bold="True" Font-Names="cairo" Font-Size="X-Large"></TabStyle>
                    <ContentCollection>
                        <dx:ContentControl>
                            <span style="color: #000000; font-family: Cairo; font-size: 1.2em; font-weight: bold">سيتم تحديث الطلبات كل 30 ثانية
                            </span>
                            <div class="navbar-main navbar-expand-lg px-0 mx-4 border-radius-xl bg-white shadow mt-3 mb-1">


                                <dx:ASPxGridView ID="GridOrders" runat="server" DataSourceID="db_Orders" KeyFieldName="id" ClientInstanceName="GridOrders" Width="100%" AutoGenerateColumns="False" EnablePagingCallbackAnimation="True" Font-Names="cairo" Font-Size="1em" OnCustomCallback="GridOrders_CustomCallback" RightToLeft="True">
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
                                                <ValidationSettings RequiredField-IsRequired="True" ErrorText="يجب تحديد حالة الطلب" >
<RequiredField IsRequired="True"></RequiredField>
                                                </ValidationSettings>
                                            </PropertiesComboBox>
                                            <DataItemTemplate>
                                                <%# GetOrderStatusLottie(Eval("l_orderStatus").ToString()) %>
                                            </DataItemTemplate>
                                            <CellStyle VerticalAlign="Middle" HorizontalAlign="Center" />
                                        </dx:GridViewDataComboBoxColumn>

                                        <dx:GridViewDataComboBoxColumn Caption="البلد" FieldName="countryId">
                                            <PropertiesComboBox
                                                DataSourceID="dsCountries"
                                                TextField="countryName"
                                                ValueField="id"
                                                DropDownStyle="DropDownList"
                                                EnableCallbackMode="false">
                                                <ValidationSettings
                                                    RequiredField-IsRequired="true"
                                                    SetFocusOnError="True"
                                                    ErrorText="الرجاء اختيار البلد"
                                                    Display="Dynamic">
                                                    <RequiredField IsRequired="True" />
                                                </ValidationSettings>
                                            </PropertiesComboBox>
                                            <EditFormSettings Visible="True" />
                                            <CellStyle VerticalAlign="Middle" HorizontalAlign="Center" />
                                        </dx:GridViewDataComboBoxColumn>



                                        <dx:GridViewDataComboBoxColumn Caption="الشركة" FieldName="companyId">
                                            <PropertiesComboBox
                                                ClientInstanceName="comboCountry"
                                                DataSourceID="dsCompanies"
                                                TextField="companyName"
                                                ValueField="id"
                                                DropDownStyle="DropDownList"
                                                EnableCallbackMode="false">
                                                <ValidationSettings
                                                    RequiredField-IsRequired="true"
                                                    SetFocusOnError="True"
                                                    ErrorText="الرجاء اختيار البلد"
                                                    Display="Dynamic">
                                                    <RequiredField IsRequired="True" />
                                                </ValidationSettings>
                                            </PropertiesComboBox>
                                            <EditFormSettings Visible="True" />
                                            <CellStyle VerticalAlign="Middle" HorizontalAlign="Center" />
                                        </dx:GridViewDataComboBoxColumn>

                                        <dx:GridViewDataColumn Caption="مستخدم التطبيق" FieldName="username">
                                            <DataItemTemplate>
                                                <div style="text-align: center; font-family: 'Cairo'; direction: rtl;">
                                                    <div style="font-weight: bold;">
                                                        <%# Eval("firstName") + " " + Eval("lastName") %>
                                                    </div>
                                                    <div style="color: gray; font-size: smaller;">
                                                        <%# Eval("username") %>
                                                    </div>
                                                </div>
                                            </DataItemTemplate>
                                            <CellStyle VerticalAlign="Middle" HorizontalAlign="Center" />
                                        </dx:GridViewDataColumn>


                                        <dx:GridViewDataColumn Caption="الفرع" FieldName="branchId">
                                            <DataItemTemplate>
                                                <div style="text-align: center; font-family: 'Cairo'; direction: rtl;">
                                                    <div style="font-weight: bold;">
                                                        <%# Eval("branchName") %>
                                                    </div>
                                                    <div style="color: gray; font-size: smaller;">
                                                        <%# Eval("branchPhone") %>
                                                    </div>
                                                </div>
                                            </DataItemTemplate>
                                            <CellStyle VerticalAlign="Middle" HorizontalAlign="Center" />
                                        </dx:GridViewDataColumn>

                                        <dx:GridViewDataColumn Caption="موقع الزبون" FieldName="addressId">
                                            <DataItemTemplate>
                                                <a href="javascript:void(0);"
                                                    onclick="callbackAddress1.PerformCallback('<%# Eval("addressId") %>'); popupAddress1.Show();"
                                                    style="text-decoration: underline; color: #007bff; font-family: Cairo;">موقع الزبون
                                                </a>
                                            </DataItemTemplate>
                                            <EditFormSettings Visible="False" />
                                            <CellStyle VerticalAlign="Middle" HorizontalAlign="Center" />
                                        </dx:GridViewDataColumn>

                                        <dx:GridViewDataColumn Caption="تتبع السائق" FieldName="addressId">
                                            <DataItemTemplate>
                                                <%# 
            (Eval("usersDeliveryId") == null || Convert.ToInt32(Eval("usersDeliveryId")) == 0)

            ? "لا يوجد سائق"

            : string.Format(
                "<div style='text-align:center; font-family:Cairo;'>" +

                    "<div style='font-weight:bold; margin-bottom:2px;'>{0}</div>" +

                    "<div style='font-size:12px; color:#666; direction:ltr; margin-bottom:6px;'>{1}</div>" +

                    "<a href=\"javascript:void(0);\" onclick=\"callbackAddress.PerformCallback('{2}'); popupAddress.Show();\" " +
                    "style=\"text-decoration: underline; color: #007bff;\">تتبع السائق</a>" +

                "</div>",
                Eval("deliveryFirstName") + " " + Eval("deliveryLastName"),
                Eval("deliveryUserName"),
                Eval("id")
              )
                                                %>
                                            </DataItemTemplate>

                                            <EditFormSettings Visible="False" />
                                            <CellStyle VerticalAlign="Middle" HorizontalAlign="Center" />
                                        </dx:GridViewDataColumn>

                                        <dx:GridViewDataColumn Caption="المبلغ الكلي">
                                            <DataItemTemplate>
                                                <%# 
                                                    "<div style='font-weight:bold;'>" +
                                                        Eval("totalAmount") + " " + MainHelper.GetCurrency(Eval("countryId")) +
                                                    "</div>" +

                                                    ((Eval("l_paymentMethodId2") != DBNull.Value 
                                                      && Convert.ToInt32(Eval("l_paymentMethodId2")) > 0)
                                                    ?
                                                    "<div style='font-size:12px; color:#555; margin-top:4px; line-height:12px; border-top:1px solid #ccc; padding-top:6px'>" +
                                                        Eval("paymentMethod1") + "<br/>" +
                                                        "<b style='color:#777'>+</b><br/>" +
                                                        Eval("paymentMethod2") +
                                                    "</div>"
                                                    :
                                                    "<div style='font-size:12px; color:#555; margin-top:4px;border-top:1px solid #ccc; padding-top:6px'>" +
                                                        Eval("paymentMethod1") +
                                                    "</div>")
                                                %>
                                            </DataItemTemplate>

                                            <EditFormSettings Visible="False" />
                                            <CellStyle VerticalAlign="Middle" Font-Bold="true" HorizontalAlign="Center" />
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

                                        <dx:GridViewDataColumn Caption="التحكم">
                                            <DataItemTemplate>
                                                <%# 
                                                    Convert.ToInt32(Eval("l_orderStatus")) == 1 
                                                    ? 
                                                    "<div style='display:flex; flex-direction:column; gap:6px; align-items:center;'>" +

                                                        "<button type='button' class=\"dx-button\" onclick=\"ShowApprovePopup(" + Eval("id") + "); return false;\" " +
                                                        "style='background-color:green;color:white;font-family:Cairo; width:90px;border:none;padding:6px;border-radius:4px;'>موافقة</button>" +

                                                        "<button type='button' class=\"dx-button\" onclick=\"ShowRejectPopup(" + Eval("id") + "); return false;\" " +
                                                        "style='background-color:red;color:white;font-family:Cairo; width:90px;border:none;padding:6px;border-radius:4px;'>رفض</button>" +

                                                    "</div>"
                                                    :
                                                    "<div style='display:flex; flex-direction:column; align-items:center;'>" +

                                                    "<button type='button' class=\"dx-button\" onclick=\"ShowRejectPopup(" + Eval("id") + "); return false;\" " +
                                                    "style='background-color:orange;color:white;font-family:Cairo; width:90px;border:none;padding:6px;border-radius:4px;'>إلغاء</button>" +

                                                    "</div>"
                                                %>
                                            </DataItemTemplate>

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
                                        <Footer Font-Names="cairo">
                                        </Footer>
                                    </Styles>
                                    <Paddings Padding="2em" />

                                </dx:ASPxGridView>

                                <dx:ASPxPopupControl ID="popupApprove1" runat="server"
                                    Width="430px"
                                    ClientInstanceName="popupApprove1"
                                    PopupHorizontalAlign="WindowCenter"
                                    PopupVerticalAlign="WindowCenter"
                                    CloseAction="CloseButton"
                                    HeaderText="رفض الطلب"
                                    Modal="True"
                                    AllowDragging="True"
                                    AutoUpdatePosition="True"
                                    Style="height: 140px;"
                                    HeaderStyle-Font-Names="Cairo"
                                    HeaderStyle-Font-Size="18px"
                                    BackColor="#ffffff"
                                    Border-BorderStyle="Solid"
                                    Border-BorderWidth="2px"
                                    Border-BorderColor="#b7b7b7"
                                    PopupAnimationType="Fade">

<HeaderStyle Font-Names="Cairo" Font-Size="18px"></HeaderStyle>

                                    <ContentCollection>
                                        <dx:PopupControlContentControl>

                                            <div style="text-align: center; font-family: Cairo; font-size: 16px; margin-bottom: 10px;">
                                                هل أنت متأكد من الموافقة على الطلب؟
           
                                            </div>

                                            <div style="text-align: center; font-family: Cairo;">

                                                <button type="button"
                                                    onclick="ConfirmApproveNow();"
                                                    style="background-color: green; color: white; width: 100px; padding: 6px 10px; border: none; border-radius: 4px; font-family: Cairo; font-weight: bold; margin-left: 10px;">
                                                    موافقة
               
                                                </button>

                                                <button type="button"
                                                    onclick="popupApprove1.Hide();"
                                                    style="background-color: red; color: white; width: 100px; padding: 6px 10px; border: none; border-radius: 4px; font-family: Cairo; font-weight: bold;">
                                                    إلغاء
               
                                                </button>

                                            </div>

                                        </dx:PopupControlContentControl>
                                    </ContentCollection>

<Border BorderColor="#B7B7B7" BorderStyle="Solid" BorderWidth="2px"></Border>
                                </dx:ASPxPopupControl>



                                <dx:ASPxCallbackPanel ID="callbackApprove" runat="server"
                                    ClientInstanceName="callbackApprove"
                                    OnCallback="callbackApprove_Callback">
                                    <PanelCollection>
<dx:PanelContent runat="server"></dx:PanelContent>
</PanelCollection>
                                </dx:ASPxCallbackPanel>


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
                                    ID="dsBranches"
                                    runat="server"
                                    ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>"
                                    SelectCommand="SELECT id, name FROM branches"></asp:SqlDataSource>

                                <asp:SqlDataSource
                                    ID="db_Orders"
                                    runat="server"
                                    ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>"
                                    SelectCommand="
                                            SELECT 
                                                o.[id], 
                                                o.[l_orderStatus],
                                                o.[companyId], 
                                                o.[addressId], 
                                                c.[countryID] AS countryId, 
                                                o.[username], 
                                                o.[totalAmount], 
                                                o.[usersDeliveryId],
                                                ud.[username]  AS deliveryUserName,
                                                ud.[firstName] AS deliveryFirstName,
                                                ud.[lastName]  AS deliveryLastName,
                                                ua.[firstName], 
                                                ua.[lastName], 
                                                o.[branchId],
                                                b.[name]  AS branchName, 
                                                b.[phone] AS branchPhone,
                                                o.[l_paymentMethodId],
                                                o.[l_paymentMethodId2],
                                                pm1.[description] AS paymentMethod1,
                                                pm2.[description] AS paymentMethod2,
                                                o.[userDate]
                                            FROM [Orders] o
                                            JOIN [companies] c 
                                                ON o.[companyId] = c.[id]
                                            JOIN [usersApp] ua 
                                                ON o.[username] = ua.[username]
                                            JOIN [branches] b 
                                                ON o.[branchId] = b.[id]
                                            LEFT JOIN [usersDelivery] ud 
                                                ON o.[usersDeliveryId] = ud.[id]
                                            LEFT JOIN l_paymentMethod pm1 
                                                ON o.l_paymentMethodId = pm1.id
                                            LEFT JOIN l_paymentMethod pm2 
                                                ON o.l_paymentMethodId2 = pm2.id
                                            WHERE 
                                                (o.[l_orderStatus] = 1 
                                                 OR o.[l_orderStatus] = 2 
                                                 OR o.[l_orderStatus] = 3)

                                            ORDER BY o.id DESC
                                        " />
                            </div>

                            <dx:ASPxPopupControl ID="popupReject" runat="server"
                                Width="430px"
                                PopupHorizontalAlign="WindowCenter"
                                PopupVerticalAlign="WindowCenter"
                                CloseAction="CloseButton"
                                HeaderText="رفض الطلب"
                                ClientInstanceName="popupReject"
                                Modal="True"
                                AllowDragging="True"
                                HeaderStyle-Font-Names="Cairo"
                                HeaderStyle-Font-Size="18px"
                                BackColor="#ffffff"
                                Border-BorderStyle="Solid"
                                Border-BorderWidth="2px"
                                Border-BorderColor="#b7b7b7"
                                PopupAnimationType="Fade">

<HeaderStyle Font-Names="Cairo" Font-Size="18px"></HeaderStyle>

                                <ContentCollection>
                                    <dx:PopupControlContentControl>
                                        <div style="font-family: Cairo; font-size: 15px; margin-bottom: 8px; color: #444;">
                                            الرجاء كتابة سبب الرفض:
           
                                        </div>

                                        <textarea id="txtRejectNote" style="width: 100%; height: 140px; font-family: Cairo; font-size: 14px; padding: 8px; border: 1px solid #ccc; border-radius: 5px; resize: none;"></textarea>

                                        <div id="rejectNoteError" style="color: red; font-family: Cairo; font-size: 14px; margin-top: 5px; display: none;">
                                            الرجاء كتابة سبب الرفض
                                        </div>

                                        <input type="hidden" id="lblRejectOrderId" />

                                        <div style="display: flex; justify-content: space-between; gap: 5px; margin-top: 12px;">
                                            <button type="button" onclick="ConfirmReject()" style="flex: 1; padding: 12px; background: #b00000; color: white; border: none; border-radius: 8px; font-family: Cairo; font-size: 16px; font-weight: bold; cursor: pointer; box-shadow: 0 2px 4px rgba(0,0,0,0.2); transition: 0.2s;"
                                                onmouseover="this.style.background='#d30000'"
                                                onmouseout="this.style.background='#b00000'">
                                                تأكيد الرفض
               
                                            </button>

                                            <button type="button" onclick="popupReject.Hide()" style="flex: 1; padding: 12px; margin-right: 8px; background: #777; color: white; border: none; border-radius: 8px; font-family: Cairo; font-size: 16px; font-weight: bold; cursor: pointer; box-shadow: 0 2px 4px rgba(0,0,0,0.2); transition: 0.2s;"
                                                onmouseover="this.style.background='#555'"
                                                onmouseout="this.style.background='#777'">
                                                إلغاء
               
                                            </button>
                                        </div>
                                    </dx:PopupControlContentControl>
                                </ContentCollection>

<Border BorderColor="#B7B7B7" BorderStyle="Solid" BorderWidth="2px"></Border>
                            </dx:ASPxPopupControl>

                            <dx:ASPxPopupControl ID="popupAddress1" runat="server" ClientInstanceName="popupAddress1"
                                Width="750px" Font-Names="Cairo" HeaderText="تفاصيل العنوان" ShowCloseButton="true"
                                PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" Modal="true">
                                <ClientSideEvents Shown="function(s, e) { s.UpdatePosition(); }" />
                                <ContentCollection>
                                    <dx:PopupControlContentControl>
                                        <dx:ASPxCallbackPanel ID="callbackAddress1" runat="server" ClientInstanceName="callbackAddress1"
                                            OnCallback="callbackAddress1_Callback">
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
                                                    <asp:Label ID="lblAddressInfo1" runat="server" Font-Names="Cairo" Text="جارٍ تحميل التفاصيل..." />
                                                </dx:PanelContent>
                                            </PanelCollection>
                                        </dx:ASPxCallbackPanel>
                                    </dx:PopupControlContentControl>
                                </ContentCollection>
                            </dx:ASPxPopupControl>

                            <dx:ASPxPopupControl ID="popupAddress" runat="server" ClientInstanceName="popupAddress"
                                Width="950px" Font-Names="Cairo" HeaderText="تتبع السائق" ShowCloseButton="true"
                                PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" Modal="true">
                                <ClientSideEvents Shown="function(s, e) { s.UpdatePosition(); }"
                                    CloseUp="function(s, e) {
                                                if (window.currentMapDivId && mapIntervals[window.currentMapDivId]) {
                                                    clearInterval(mapIntervals[window.currentMapDivId]);
                                                    delete mapIntervals[window.currentMapDivId];
                                                }
                                            }" />
                                <ContentCollection>
                                    <dx:PopupControlContentControl>
                                        <dx:ASPxCallbackPanel ID="callbackAddress" runat="server" ClientInstanceName="callbackAddress"
                                            OnCallback="callbackAddress_Callback">
                                            <ClientSideEvents EndCallback="function(s, e) {
                                                        var json = s.cpMapData;
                                                        if (json) {
                                                            var data = JSON.parse(json);
                                                            window.currentMapData = data;

                                                            if (window.initCurrentMap) initCurrentMap();

                                                            // Use the same ID that was embedded by server
                                                            startTracking(parseInt(data.mapId.replace('map_', '')), data.mapId);
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
                        </dx:ContentControl>
                    </ContentCollection>
                </dx:TabPage>
                <%----------------------------------------------------------------------------------------%>
                <dx:TabPage Text="خريطة السائقين" TabStyle-Font-Bold="true" TabStyle-Font-Names="cairo" TabStyle-Font-Size="X-Large">
                    <TabStyle Font-Bold="True" Font-Names="cairo" Font-Size="X-Large"></TabStyle>
                    <ContentCollection>
                        <dx:ContentControl>
                            <script>
                                let driversMap;
                                let driverOverlays = {};
                                let lastPositions1 = {};

                                class RotatingCarOverlay extends google.maps.OverlayView {
                                    constructor(position, map, imageUrl, rotation, isBike = false) {
                                        super();
                                        this.position = position;
                                        this.map = map;
                                        this.imageUrl = imageUrl;
                                        this.rotation = rotation || 0;
                                        this.isBike = isBike;
                                        this.div = null;
                                        this.setMap(map);
                                    }

                                    onAdd() {
                                        const div = document.createElement("div");
                                        div.style.position = "absolute";
                                        div.style.width = "60px";
                                        div.style.height = "60px";
                                        div.style.transition = "transform 0.3s ease";
                                        div.innerHTML = `<img src="${this.imageUrl}" style="width: 70px; height: 110px;" />`;
                                        this.div = div;
                                        this.getPanes().overlayImage.appendChild(div);
                                    }

                                    draw() {
                                        const overlayProjection = this.getProjection();
                                        const pixel = overlayProjection.fromLatLngToDivPixel(new google.maps.LatLng(this.position.lat, this.position.lng));
                                        if (this.div) {
                                            if (this.isBike) {
                                                this.div.style.left = (pixel.x - 30) + "px";
                                                this.div.style.top = (pixel.y - 50) + "px";
                                            } else {
                                                this.div.style.left = (pixel.x - 30) + "px";
                                                this.div.style.top = (pixel.y - 50) + "px";
                                            }
                                            this.div.style.transform = `rotate(${this.rotation}deg)`;
                                        }
                                    }

                                    update(position, rotation) {
                                        this.position = position;
                                        this.rotation = rotation;
                                        this.draw();
                                    }

                                    onRemove() {
                                        if (this.div) {
                                            this.div.parentNode.removeChild(this.div);
                                            this.div = null;
                                        }
                                    }
                                }

                                function calculateBearing(from, to) {
                                    const lat1 = from.lat * Math.PI / 180;
                                    const lat2 = to.lat * Math.PI / 180;
                                    const deltaLng = (to.lng - from.lng) * Math.PI / 180;

                                    const y = Math.sin(deltaLng) * Math.cos(lat2);
                                    const x = Math.cos(lat1) * Math.sin(lat2) -
                                        Math.sin(lat1) * Math.cos(lat2) * Math.cos(deltaLng);
                                    const bearing = Math.atan2(y, x) * 180 / Math.PI;
                                    return (bearing + 360) % 360;
                                }

                                function initDriversMap() {
                                    driversMap = new google.maps.Map(document.getElementById("driversMap"), {
                                        center: { lat: 31.963158, lng: 35.930359 },
                                        zoom: 10
                                    });
                                    // Add traffic layer
                                    const trafficLayer = new google.maps.TrafficLayer();
                                    trafficLayer.setMap(driversMap);
                                }

                                function refreshDriversMap() {
                                    callbackDriversMap.PerformCallback();
                                }

                                function onDriversMapEndCallback(s, e) {
                                    const data = s.cpMapData;
                                    if (!data || data === "null") return;

                                    const locations = JSON.parse(data);
                                    const seenIds = new Set();

                                    locations.forEach(loc => {
                                        const pos = { lat: parseFloat(loc.latitude), lng: parseFloat(loc.longitude) };
                                        const id = loc.orderId;
                                        const fullName = `${loc.firstName} ${loc.lastName}`;
                                        const tooltip = `رقم الطلب: ${id}\nالسائق: ${fullName}`;
                                        seenIds.add(id);

                                        const last = lastPositions1[id];
                                        const rotation = last ? calculateBearing(last, pos) : 0;

                                        const imageUrl = loc.l_vehicleType === "2"
                                            ? "/assets/animations/bike.png"
                                            : "/assets/animations/WhiteCar.png";

                                        const isBike = loc.l_vehicleType === "2";

                                        if (!driverOverlays[id]) {
                                            const overlay = new RotatingCarOverlay(pos, driversMap, imageUrl, rotation, isBike);

                                            overlay.onAdd = function () {
                                                const div = document.createElement("div");
                                                div.style.position = "absolute";
                                                div.style.width = "60px";
                                                div.style.height = "60px";
                                                div.style.transition = "transform 0.3s ease";
                                                div.title = tooltip; // ✅ Tooltip includes Order ID + Name
                                                div.innerHTML = `<img src="${this.imageUrl}" style="width: 70px; height: 110px;" />`;
                                                this.div = div;
                                                this.getPanes().overlayImage.appendChild(div);
                                            };

                                            driverOverlays[id] = overlay;
                                        } else {
                                            driverOverlays[id].update(pos, rotation);
                                        }

                                        lastPositions1[id] = pos;
                                    });

                                    Object.keys(driverOverlays).forEach(id => {
                                        if (!seenIds.has(id)) {
                                            driverOverlays[id].setMap(null);
                                            delete driverOverlays[id];
                                            delete lastPositions1[id];
                                        }
                                    });
                                }


                                function onPageLoaded() {
                                    initDriversMap();
                                    refreshDriversMap();
                                    setInterval(refreshDriversMap, 10000);
                                }
                            </script>

                            <dx:ASPxCallback ID="callbackDriversMap" runat="server" ClientInstanceName="callbackDriversMap"
                                OnCallback="callbackDriversMap_Callback">
                                <ClientSideEvents EndCallback="onDriversMapEndCallback" />
                            </dx:ASPxCallback>

                            <dx:ASPxHiddenField ID="HiddenInitTrigger" runat="server" ClientInstanceName="hiddenInitTrigger">
                                <ClientSideEvents Init="onPageLoaded" />
                            </dx:ASPxHiddenField>

                            <div style="display: flex; justify-content: center; margin-top: 20px;">
                                <div style="width: 95%; max-width: 1200px; height: 600px; border: 3px solid #c6bbff; border-radius: 15px; overflow: hidden; box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);">
                                    <div id="driversMap" style="width: 100%; height: 100%;"></div>
                                </div>
                            </div>
                        </dx:ContentControl>
                    </ContentCollection>
                </dx:TabPage>
            </TabPages>
        </dx:ASPxPageControl>


        <dx:ASPxTextBox ID="l_Order_Id" runat="server" BackColor="Transparent" ClientInstanceName="l_Order_Id" Font-Size="0pt" ForeColor="Transparent" Text="" Width="0px" Theme="Default">
            <Border BorderStyle="None" BorderWidth="0px" />
        </dx:ASPxTextBox>


        <dx:ASPxPopupControl ID="popupOrderProducts" runat="server"
            ClientInstanceName="popupOrderProducts"
            Width="900px" HeaderText="المنتجات في الطلب"
            PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter"
            Modal="true" Font-Names="Cairo">
            <ClientSideEvents Shown="function(s,e){ 
                setTimeout ( 
                         function() { 
                            s.UpdatePosition();
                        },1000);                     
                }" />
            <ContentCollection>
                <dx:PopupControlContentControl>

                    <dx:ASPxGridView ID="gridOrderProducts" runat="server"
                        DataSourceID="dsOrderProducts"
                        KeyFieldName="id" ClientInstanceName="gridOrderProducts"
                        Width="100%" AutoGenerateColumns="False"
                        Font-Names="Cairo" Font-Size="0.9em" RightToLeft="True"
                        EnablePagingCallbackAnimation="True">

                        <SettingsPager PageSize="5">
                        </SettingsPager>

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



    </main>

</asp:Content>
