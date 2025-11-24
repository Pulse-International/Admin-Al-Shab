<%@ Page Title="Rates" Language="C#" MasterPageFile="~/mSite.Master" AutoEventWireup="true" CodeBehind="mUsers.aspx.cs" Inherits="ShabAdmin.mUsers" %>

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

            .image-popup-cairo-clean .dxpc-header {
                font-family: 'Cairo', sans-serif;
                font-size: 16px;
                font-weight: normal;
                background-color: transparent !important;
                color: #333 !important;
                border-bottom: none !important;
                text-align: center;
                padding: 10px 0;
            }

            .image-popup-cairo-clean .dxpc-closeButton {
                top: 10px !important;
                right: 12px !important;
                filter: none !important;
            }

            .image-popup-cairo-clean .dxpc-contentWrapper {
                border-radius: 10px;
                background-color: #fff;
                box-shadow: 0 0 15px rgba(0, 0, 0, 0.1);
                padding: 0 !important;
            }

            .water-button-wrapper {
                position: relative;
                width: 100%;
                overflow: hidden;
                background-color: #727272 !important;
                border-radius: 4px;
                box-shadow: 0 0 30px rgba(114, 114, 114, 0.8), 0 0 50px rgba(200, 200, 200, 0.6), 0 0 70px rgba(150, 150, 150, 0.4);
                animation: shadowPulse 2s ease-in-out infinite, buttonPulse 2s ease-in-out infinite;
            }

                .water-button-wrapper::after {
                    content: '';
                    position: absolute;
                    width: 100%;
                    height: 100%;
                    top: 0;
                    left: 0;
                    background: linear-gradient(90deg, transparent, rgba(255,255,255,0.4), transparent);
                    animation: shine 1.2s ease-in-out infinite;
                    pointer-events: none;
                    z-index: 2;
                }

            @keyframes shine {
                0% {
                    transform: translateX(-100%);
                }

                50% {
                    opacity: 1;
                }

                100% {
                    transform: translateX(100%);
                }
            }

            @keyframes shadowPulse {
                0% {
                    box-shadow: 0 0 15px rgba(114, 114, 114, 0.8), 0 0 25px rgba(200, 200, 200, 0.4), 0 0 35px rgba(150, 150, 150, 0.2);
                }

                50% {
                    box-shadow: 0 0 20px rgba(114, 114, 114, 1), 0 0 35px rgba(200, 200, 200, 0.8), 0 0 50px rgba(150, 150, 150, 0.6);
                }

                100% {
                    box-shadow: 0 0 15px rgba(114, 114, 114, 0.8), 0 0 25px rgba(200, 200, 200, 0.4), 0 0 35px rgba(150, 150, 150, 0.2);
                }
            }

            @keyframes buttonPulse {
                0% {
                    transform: scale(1);
                }

                50% {
                    transform: scale(1.05);
                }

                100% {
                    transform: scale(1);
                }
            }
        </style>

        <script src="https://cdnjs.cloudflare.com/ajax/libs/bodymovin/5.9.6/lottie.min.js"></script>

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
                GridMachineUsers.GetRowValues(MyIndex, 'id', OnGetRowValues);
            }

            function OnGetRowValues(Value) {
                MyId = Value[0];

            }
            function onCountryChanged(s, e) {
                var countryId = s.GetValue();
                if (countryId !== null) {
                    cmbCompany.PerformCallback(countryId.toString());
                }
                cmbBranch.ClearItems();
            }

            function onCompanyChanged(s, e) {
                var companyId = s.GetValue();
                var countryId = cmbCountry.GetValue();
                if (companyId !== null && countryId !== null) {
                    cmbBranch.PerformCallback(countryId + "|" + companyId);
                }
            }

            function onDeleteClick(visibleIndex, gridNo) {
                MyIndex = visibleIndex;
                Pop_Del_MachineUsers.Show();
            }

            function togglePasswordVisibility(icon) {
                var parentDiv = icon.closest('div');
                var input = parentDiv.querySelector('input[type="password"], input[type="text"]');
                if (!input) return;

                if (input.type === "password") {
                    input.type = "text";
                    icon.querySelector('img').src = "/assets/img/show.png";
                } else {
                    input.type = "password";
                    icon.querySelector('img').src = "/assets/img/show.png";
                }
            }

            function editCurrentRow() {
                setTimeout(function () {
                    GridMachineUsers.StartEditRow(MyIndex);
                }, 100);
            }
        </script>
        <script>
            var MyId;
            var MyIndex;
            var MyIndexDetail;
            var selectedCompanyId;
            var selectedCountryId;
            var checkBoxValue;

            var MyPrice;
            var MyPercent;

            function OnRowClick1(e) {
                MyIndex = e.visibleIndex;

                GridDeliveryUsers.GetRowValues(MyIndex, 'id;image;carPicture;carLicensePicture;idFrontPicture;idBackPicture;licensePicture', function (Value) {
                    MyId = Value[0];
                    l_item_file.SetText(Value[1]);
                    l_item_file_old.SetText(Value[1]);
                    l_car_file.SetText(Value[2]);
                    l_car_file_old.SetText(Value[2]);
                    l_carLicense_file.SetText(Value[3]);
                    l_carLicense_file_old.SetText(Value[3]);
                    l_idFront_file.SetText(Value[4]);
                    l_idFront_file_old.SetText(Value[4]);
                    l_idBack_file.SetText(Value[5]);
                    l_idBack_file_old.SetText(Value[5]);
                    l_license_file.SetText(Value[6]);
                    l_license_file_old.SetText(Value[6]);
                });
            }

            function onCountryChanged1(s, e) {
                var countryId = s.GetValue();
                if (countryId !== null) {
                    cmbCompany.PerformCallback(countryId.toString());
                }
                cmbBranch.ClearItems();
            }

            function onCompanyChanged1(s, e) {
                var companyId = s.GetValue();
                var countryId = cmbCountry.GetValue();
                if (companyId !== null && countryId !== null) {
                    cmbBranch.PerformCallback(countryId + "|" + companyId);
                }
            }

            function onDeleteClick1(visibleIndex, gridNo) {
                MyIndex = visibleIndex;
                Pop_Del_usersDelivery.Show();
            }

            function togglePasswordVisibility(icon) {
                var parentDiv = icon.closest('div');
                var input = parentDiv.querySelector('input[type="password"], input[type="text"]');
                if (!input) return;

                if (input.type === "password") {
                    input.type = "text";
                    icon.querySelector('img').src = "/assets/img/show.png";
                } else {
                    input.type = "password";
                    icon.querySelector('img').src = "/assets/img/show.png";
                }
            }

            function onFileUploadComplete(s, e, type) {
                var fileData = e.callbackData.split('|');
                var fileName = fileData[0];
                const index = GridDeliveryUsers.GetFocusedRowIndex();
                GridDeliveryUsers.GetRowValues(index, 'id', function (id) {
                    MyId = id;
                });

                console.log("Upload complete for type: " + type + " with ID: " + MyId);
                if (type === 'image') {

                    ////   صورة السائق

                    if (document.getElementById("DocsFile-" + MyId) != null) {
                        document.getElementById("DocsFile-" + MyId).src = fileName + "?v=" + new Date().getTime();
                        document.getElementById("PersonalImage").src = fileName + "?v=" + new Date().getTime();
                    } else {
                        document.getElementById("PersonalImage").src = fileName + "?v=" + new Date().getTime();
                    }
                    l_item_file.SetText(fileName);
                    l_item_file_check.SetText('1');
                } else if (type === 'carPicture') {

                    ////   صورة السيارة

                    if (document.getElementById("carFile-" + MyId) != null) {
                        document.getElementById("carFile-" + MyId).src = fileName + "?v=" + new Date().getTime();
                        document.getElementById("CarImage").src = fileName + "?v=" + new Date().getTime();
                    } else {
                        document.getElementById("CarImage").src = fileName + "?v=" + new Date().getTime();
                    }
                    l_car_file.SetText(fileName);
                    l_car_file_check.SetText('1');
                } else if (type === 'carLicense') {

                    ////   صورة رخصىة السيارة

                    if (document.getElementById("carLicenseFile-" + MyId) != null) {
                        document.getElementById("carLicenseFile-" + MyId).src = fileName + "?v=" + new Date().getTime();
                        document.getElementById("CarLicense").src = fileName + "?v=" + new Date().getTime();
                    } else {
                        document.getElementById("CarLicense").src = fileName + "?v=" + new Date().getTime();
                    }
                    l_carLicense_file.SetText(fileName);
                    l_carLicense_file_check.SetText('1');
                } else if (type === 'idFront') {

                    ////   صورة الهوية من الامام

                    if (document.getElementById("idFrontFile-" + MyId) != null) {
                        document.getElementById("idFrontFile-" + MyId).src = fileName + "?v=" + new Date().getTime();
                        document.getElementById("IdFront").src = fileName + "?v=" + new Date().getTime();
                    } else {
                        document.getElementById("IdFront").src = fileName + "?v=" + new Date().getTime();
                    }
                    l_idFront_file.SetText(fileName);
                    l_idFront_file_check.SetText('1');
                } else if (type === 'idBack') {

                    ////   صورة الهوية من الامام

                    if (document.getElementById("idBackFile-" + MyId) != null) {
                        document.getElementById("idBackFile-" + MyId).src = fileName + "?v=" + new Date().getTime();
                        document.getElementById("IdBack").src = fileName + "?v=" + new Date().getTime();
                    } else {
                        document.getElementById("IdBack").src = fileName + "?v=" + new Date().getTime();
                    }
                    l_idBack_file.SetText(fileName);
                    l_idBack_file_check.SetText('1');
                } else if (type === 'license') {

                    ////   صورة رخصة القيادة

                    if (document.getElementById("licenseFile-" + MyId) != null) {
                        document.getElementById("licenseFile-" + MyId).src = fileName + "?v=" + new Date().getTime();
                        document.getElementById("License").src = fileName + "?v=" + new Date().getTime();
                    } else {
                        document.getElementById("License").src = fileName + "?v=" + new Date().getTime();
                    }
                    l_license_file.SetText(fileName);
                    l_license_file_check.SetText('1');
                }

            }

            function onFileUploadStart(s, e, type) {
                hfUploadType.Set("type", type);

                if (type === 'image') {
                    l_item_file_check.SetText('0');
                } else if (type === 'carPicture') {
                    l_car_file_check.SetText('0');
                } else if (type === 'carLicense') {
                    l_carLicense_file_check.SetText('0');
                } else if (type === 'idFront') {
                    l_idFront_file_check.SetText('0');
                } else if (type === 'idBack') {
                    l_idBack_file_check.SetText('0');
                } else if (type === 'license') {
                    l_license_file_check.SetText('0');
                }
            }




            function OnGridBeginCallback1(s, e) {


                if (e.command == 'STARTEDIT') {
                    l_item_file_check.SetText('0');
                    l_car_file_check.SetText('0');
                    l_carLicense_file_check.SetText('0');
                    l_idFront_file_check.SetText('0');
                    l_idBack_file_check.SetText('0');
                    l_license_file_check.SetText('0');
                }
                if (e.command == 'ADDNEWROW') {
                    MyId = 0;
                    l_item_file.SetText('');
                    l_item_file_old.SetText('');

                    l_car_file.SetText('');
                    l_car_file_old.SetText('');

                    l_carLicense_file.SetText('');
                    l_carLicense_file_old.SetText('');

                    l_idFront_file.SetText('');
                    l_idFront_file_old.SetText('');

                    l_idBack_file.SetText('');
                    l_idBack_file_old.SetText('');

                    l_license_file.SetText('');
                    l_license_file_old.SetText('');

                }
                if (e.command == 'UPDATEEDIT') {
                    //Your code here when the Update button is clicked  
                }
                if (e.command == 'DELETEROW') {
                    //Your code here when the Delete button is clicked  
                }
                //and so on...  
            }

            function editCurrentRow1() {
                setTimeout(function () {
                    GridDeliveryUsers.StartEditRow(MyIndex);
                }, 100);
            }

            function showImagePopup(imageUrl) {
                if (!imageUrl || imageUrl.length < 5) {
                    imageUrl = "/assets/uploads/noFile.png";
                }
                console.log(imageUrl);

                var popupImage = document.getElementById("popupImage");
                if (popupImage) {
                    popupImage.src = imageUrl + "?v=" + new Date().getTime();
                    popupImageViewer.Show();
                }
            }



        </script>

        <script>
            var MyId;
            var MyIndex;
            var MyIndexDetail;
            var selectedCompanyId;
            var selectedCountryId;
            var checkBoxValue;

            var MyPrice;
            var MyPercent;

            function OnRowClick2(e) {
                MyIndex = e.visibleIndex;

                GridDeliveryUsers.GetRowValues(MyIndex, 'id', function (Value) {
                    MyId = Value;
                });
            }

            function onDeleteClick2(visibleIndex, gridNo) {
                MyIndex = visibleIndex;
                Pop_Del_usersApp.Show();
            }

            function editCurrentRow2() {
                setTimeout(function () {
                    GridAppUsers.StartEditRow(MyIndex);
                }, 100);
            }


        </script>
        <div class="w-100 text-center my-4">
            <h2 class="pageTitle d-inline-block" style="font-family: Cairo">المستخدمين</h2>
        </div>
        <dx:ASPxPageControl ID="pageTab" runat="server" CssClass="divSTARProviders" ActiveTabIndex="0" ClientInstanceName="pageTab" Theme="Material" Width="100%" EnableCallbackAnimation="True">
            <TabPages>

                <dx:TabPage Text="مستخدمين التطبيق" TabStyle-Font-Bold="true" TabStyle-Font-Names="cairo" TabStyle-Font-Size="X-Large">
                    <TabStyle Font-Bold="True" Font-Names="cairo" Font-Size="X-Large"></TabStyle>
                    <ContentCollection>
                        <dx:ContentControl>
                            <div class="navbar-main navbar-expand-lg px-0 mx-4 border-radius-xl bg-white shadow mt-3 mb-1">

                                <dx:ASPxGridView ID="GridAppUsers" runat="server" DataSourceID="db_AppUsers" KeyFieldName="id" ClientInstanceName="GridAppUsers" Width="100%" AutoGenerateColumns="False" EnablePagingCallbackAnimation="True" Font-Names="cairo" Font-Size="1em" RightToLeft="True" OnHtmlDataCellPrepared="GridUsers_HtmlDataCellPrepared">
                                    <Settings ShowFooter="True" ShowFilterRow="True" />


                                    <ClientSideEvents RowClick="function(s, e) {OnRowClick2(e);}" RowDblClick="function(s, e) {setTimeout(function(){GridAppUsers.StartEditRow(MyIndex);},100);}" />
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

                                        <dx:GridViewDataTextColumn Caption="رمز الدولة" FieldName="countryCode">
                                            <PropertiesTextEdit>
                                                <ValidationSettings RequiredField-IsRequired="true" ErrorText="هذا الحقل مطلوب">
                                                    <RequiredField IsRequired="True"></RequiredField>
                                                </ValidationSettings>
                                            </PropertiesTextEdit>
                                            <EditFormSettings Visible="False" />
                                            <CellStyle VerticalAlign="Middle" Font-Size="Large" HorizontalAlign="Center" />

                                        </dx:GridViewDataTextColumn>

                                        <dx:GridViewDataTextColumn Caption="الاسم الأول" FieldName="firstName">
                                            <PropertiesTextEdit>
                                                <ValidationSettings RequiredField-IsRequired="true" ErrorText="هذا الحقل مطلوب">
                                                    <RequiredField IsRequired="True"></RequiredField>
                                                </ValidationSettings>
                                            </PropertiesTextEdit>
                                            <EditFormSettings Visible="False" />
                                            <CellStyle VerticalAlign="Middle" Font-Size="Large" HorizontalAlign="Center" />

                                        </dx:GridViewDataTextColumn>

                                        <dx:GridViewDataTextColumn Caption="الاسم الأخير" FieldName="lastName">
                                            <PropertiesTextEdit>
                                                <ValidationSettings RequiredField-IsRequired="true" ErrorText="هذا الحقل مطلوب">
                                                    <RequiredField IsRequired="True"></RequiredField>
                                                </ValidationSettings>
                                            </PropertiesTextEdit>
                                            <EditFormSettings Visible="False" />
                                            <CellStyle VerticalAlign="Middle" Font-Size="Large" HorizontalAlign="Center" />

                                        </dx:GridViewDataTextColumn>

                                        <dx:GridViewDataTextColumn Caption="اسم المستخدم" FieldName="username">
                                            <PropertiesTextEdit>
                                                <ValidationSettings RequiredField-IsRequired="true" ErrorText="هذا الحقل مطلوب">
                                                    <RequiredField IsRequired="True"></RequiredField>
                                                </ValidationSettings>
                                            </PropertiesTextEdit>
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

                                        <%--   <dx:GridViewDataTextColumn Caption="FCMToken" FieldName="FCMToken">
                                            <PropertiesTextEdit>
                                                <ValidationSettings RequiredField-IsRequired="true" ErrorText="هذا الحقل مطلوب">
                                                    <RequiredField IsRequired="True"></RequiredField>
                                                </ValidationSettings>
                                            </PropertiesTextEdit>
                                            <EditFormSettings Visible="False" />
                                            <CellStyle VerticalAlign="Middle" Font-Size="Large" HorizontalAlign="Center" />

                                        </dx:GridViewDataTextColumn> --%>

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

                                        <dx:GridViewDataDateColumn FieldName="userDate" Caption="التاريخ">
                                            <PropertiesDateEdit DisplayFormatString="yyyy/MM/dd hh:mm tt" />
                                            <EditFormSettings Visible="False" />
                                            <CellStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                        </dx:GridViewDataDateColumn>

                                        <dx:GridViewDataTextColumn Caption="" ShowInCustomizationForm="True" Width="100px" VisibleIndex="999">
                                            <EditFormSettings Visible="False" />
                                            <DataItemTemplate>
                                                <div style="width: 100%; float: left; text-align: center">
                                                    <img src="/assets/img/update.png" width="32" height="32" title="تعديل" style="cursor: pointer" onclick="editCurrentRow2();" />
                                                    <img src="/assets/img/delete.png" width="32" height="32" title="حذف" style="cursor: pointer" onclick="onDeleteClick2(<%# Container.VisibleIndex %>, '1');" />
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

                            <asp:SqlDataSource
                                ID="db_AppUsers"
                                runat="server"
                                ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>"
                                SelectCommand="SELECT id, countryCode, LEFT(FCMToken, 5) AS FCMToken, userPlatform, firstName, lastName, username, isActive, balance, l_userLevelId, twoAuthenticationEnabled, userPoints, isDeleted, freeDeliveryCount,userDate
                                        FROM [usersApp]
                                        ORDER BY isDeleted ASC, id desc"
                                UpdateCommand="UPDATE [usersApp]
                                    SET
                                        balance = @balance,
                                        isActive = @isActive,
                                        l_userLevelId = @l_userLevelId,
                                        userPoints = @userPoints
                                    WHERE id = @id"
                                DeleteCommand="update usersApp set isDeleted=1, isActive=0 where id =@id">


                                <UpdateParameters>
                                    <asp:Parameter Name="balance" Type="Decimal" />
                                    <asp:Parameter Name="isActive" Type="Int32" />
                                    <asp:Parameter Name="l_userLevelId" Type="Int32" />
                                    <asp:Parameter Name="userPoints" Type="Int32" />
                                    <asp:Parameter Name="id" Type="Int32" />
                                </UpdateParameters>
                                <DeleteParameters>
                                    <asp:Parameter Name="id" Type="Int32" />
                                </DeleteParameters>
                            </asp:SqlDataSource>

                            <asp:SqlDataSource
                                ID="db_UserLevel"
                                runat="server"
                                ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>"
                                SelectCommand="SELECT id, description FROM [L_UserLevel]" />

                            <dx:ASPxPopupControl runat="server" ID="Pop_Del_usersApp"
                                PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter"
                                AutoUpdatePosition="True" Modal="True" ClientInstanceName="Pop_Del_usersApp"
                                HeaderText="حذف مستخدم" Font-Names="Cairo"
                                Width="350px" Height="150px" CloseAnimationType="Slide">
                                <ContentCollection>
                                    <dx:PopupControlContentControl runat="server">
                                        <div style="padding: 20px; text-align: right; font-family: 'Cairo', sans-serif;">
                                            <div class="mb-3">
                                                <dx:ASPxLabel ID="ASPxLabel2" runat="server" Text="هل أنت متأكد من تعيين المستخدم كمستخدم محذوف؟"
                                                    Font-Names="Cairo" Font-Size="Medium" ForeColor="#333333" />
                                            </div>
                                            <div style="margin-top: 20px; text-align: center;">
                                                <dx:ASPxButton ID="ASPxButton3" runat="server" Text="حذف"
                                                    AutoPostBack="False" Font-Names="Cairo">
                                                    <ClientSideEvents Click="function(s, e) { 
        GridAppUsers.DeleteRow(MyIndex); 
        setTimeout(function() { GridAppUsers.Refresh(); }, 200);
        Pop_Del_usersApp.Hide(); 
    }" />
                                                </dx:ASPxButton>
                                                <dx:ASPxButton ID="ASPxButton4" runat="server" Text="إغلاق"
                                                    AutoPostBack="False" Font-Names="Cairo" Style="margin-right: 20px;">
                                                    <ClientSideEvents Click="function(s, e) { Pop_Del_usersApp.Hide(); }" />
                                                </dx:ASPxButton>
                                            </div>
                                        </div>
                                    </dx:PopupControlContentControl>
                                </ContentCollection>
                            </dx:ASPxPopupControl>



                        </dx:ContentControl>
                    </ContentCollection>
                </dx:TabPage>

                <%----------------------------------------------------------------------------------------------------------------------------------%>

                <dx:TabPage Text="مستخدمين الفروع" TabStyle-Font-Bold="true" TabStyle-Font-Names="cairo" TabStyle-Font-Size="X-Large">
                    <TabStyle Font-Bold="True" Font-Names="cairo" Font-Size="X-Large"></TabStyle>
                    <ContentCollection>
                        <dx:ContentControl>
                            <div class="navbar-main navbar-expand-lg px-0 mx-4 border-radius-xl bg-white shadow mt-3 mb-1">

                                <dx:ASPxGridView ID="GridMachineUsers" runat="server" DataSourceID="db_MachineUsers" KeyFieldName="id" ClientInstanceName="GridMachineUsers" Width="100%" AutoGenerateColumns="False" EnablePagingCallbackAnimation="True" Font-Names="cairo" Font-Size="1em" RightToLeft="True" OnRowInserting="GridMachineUsers_RowInserting" OnCellEditorInitialize="GridMachineUsers_CellEditorInitialize" OnRowUpdating="GridMachineUsers_RowUpdating" OnRowValidating="GridMachineUsers_RowValidating" OnHtmlDataCellPrepared="GridMachineUsers_HtmlDataCellPrepared">
                                    <Settings ShowFooter="True" ShowFilterRow="True" />


                                    <ClientSideEvents RowClick="function(s, e) {OnRowClick(e);}" EndCallback="function(s,e){
                                            if(s.cpUsernameError){
                                                popupUsernameError.SetContentHtml( s.cpUsernameError );
                                                popupUsernameError.Show();
                                                s.cpUsernameError = null; 
                                            }
                                        }"
                                        RowDblClick="function(s, e) {setTimeout(function(){GridMachineUsers.StartEditRow(MyIndex);},100);}" />
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
                                            <CellStyle VerticalAlign="Middle" Font-Size="Large" HorizontalAlign="Center" />
                                        </dx:GridViewDataColumn>


                                        <dx:GridViewDataTextColumn Caption="اسم المستخدم" FieldName="username">
                                            <PropertiesTextEdit>
                                                <ValidationSettings
                                                    RequiredField-IsRequired="true"
                                                    ErrorText="اسم المستخدم مطلوب"
                                                    Display="Dynamic"
                                                    SetFocusOnError="true">
                                                    <RequiredField IsRequired="True"></RequiredField>
                                                </ValidationSettings>
                                            </PropertiesTextEdit>
                                            <CellStyle VerticalAlign="Middle" Font-Size="Large" HorizontalAlign="Center" />
                                        </dx:GridViewDataTextColumn>

                                        <dx:GridViewDataTextColumn Caption="كلمة السر" FieldName="password" Width="7%">
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


                                        <dx:GridViewDataTextColumn Caption="الاسم الاول" FieldName="firstName">
                                            <PropertiesTextEdit>
                                                <ValidationSettings
                                                    RequiredField-IsRequired="true"
                                                    ErrorText="الاسم الأول مطلوب"
                                                    Display="Dynamic"
                                                    SetFocusOnError="true">
                                                    <RequiredField IsRequired="True"></RequiredField>
                                                </ValidationSettings>
                                            </PropertiesTextEdit>
                                            <CellStyle VerticalAlign="Middle" Font-Size="Large" HorizontalAlign="Center" />
                                        </dx:GridViewDataTextColumn>

                                        <dx:GridViewDataTextColumn Caption="الاسم الاخير" FieldName="lastName">
                                            <PropertiesTextEdit>
                                                <ValidationSettings
                                                    RequiredField-IsRequired="true"
                                                    ErrorText="الاسم الأخير مطلوب"
                                                    Display="Dynamic"
                                                    SetFocusOnError="true">
                                                    <RequiredField IsRequired="True"></RequiredField>
                                                </ValidationSettings>
                                            </PropertiesTextEdit>
                                            <CellStyle VerticalAlign="Middle" Font-Size="Large" HorizontalAlign="Center" />
                                        </dx:GridViewDataTextColumn>

                                        <dx:GridViewDataComboBoxColumn Caption="فعال" FieldName="isActive">
                                            <PropertiesComboBox ValueType="System.Int32">
                                                <Items>
                                                    <dx:ListEditItem Text="فعال" Value="1" />
                                                    <dx:ListEditItem Text="غير فعال" Value="0" />
                                                </Items>
                                                <ValidationSettings
                                                    RequiredField-IsRequired="true"
                                                    ErrorText="يجب تحديد حالة التفعيل"
                                                    Display="Dynamic"
                                                    SetFocusOnError="true">
                                                    <RequiredField IsRequired="True"></RequiredField>
                                                </ValidationSettings>
                                            </PropertiesComboBox>
                                            <CellStyle VerticalAlign="Middle" Font-Size="Large" HorizontalAlign="Center" />
                                        </dx:GridViewDataComboBoxColumn>



                                        <dx:GridViewDataComboBoxColumn Caption="البلد" FieldName="countryId">
                                            <PropertiesComboBox ClientInstanceName="cmbCountry"
                                                DataSourceID="db_countryName"
                                                TextField="countryName"
                                                ValueField="id"
                                                ValueType="System.Int32"
                                                EnableCallbackMode="false">
                                                <ClientSideEvents SelectedIndexChanged="onCountryChanged" />
                                                <ValidationSettings RequiredField-IsRequired="true" ErrorText="اختر الدولة" Display="Dynamic">
                                                    <RequiredField IsRequired="True"></RequiredField>
                                                </ValidationSettings>
                                            </PropertiesComboBox>
                                            <CellStyle VerticalAlign="Middle" Font-Size="Large" HorizontalAlign="Center" />
                                        </dx:GridViewDataComboBoxColumn>




                                        <dx:GridViewDataComboBoxColumn Caption="الشركة" FieldName="companyId">
                                            <PropertiesComboBox
                                                DataSourceID="db_companyName"
                                                TextField="companyName"
                                                ValueField="id"
                                                ValueType="System.Int32"
                                                ClientInstanceName="cmbCompany">
                                                <ClientSideEvents SelectedIndexChanged="onCompanyChanged" />
                                                <ValidationSettings RequiredField-IsRequired="true" ErrorText="اختر الشركة" Display="Dynamic">
                                                    <RequiredField IsRequired="True"></RequiredField>
                                                </ValidationSettings>
                                            </PropertiesComboBox>
                                            <EditFormSettings Visible="true" VisibleIndex="7" />
                                            <CellStyle VerticalAlign="Middle" Font-Size="Large" HorizontalAlign="Center" />

                                        </dx:GridViewDataComboBoxColumn>

                                        <dx:GridViewDataComboBoxColumn Caption="الفرع" FieldName="branchId">
                                            <PropertiesComboBox
                                                DataSourceID="db_branchName"
                                                TextField="name"
                                                ValueField="id"
                                                ValueType="System.Int32"
                                                ClientInstanceName="cmbBranch">
                                                <ValidationSettings RequiredField-IsRequired="true" ErrorText="اختر الفرع" Display="Dynamic">
                                                    <RequiredField IsRequired="True"></RequiredField>
                                                </ValidationSettings>
                                            </PropertiesComboBox>
                                            <EditFormSettings Visible="true" VisibleIndex="8" />
                                            <CellStyle VerticalAlign="Middle" Font-Size="Large" HorizontalAlign="Center" />

                                        </dx:GridViewDataComboBoxColumn>

                                        <dx:GridViewDataDateColumn FieldName="userDate" Caption="التاريخ">
                                            <PropertiesDateEdit DisplayFormatString="yyyy/MM/dd hh:mm tt" />
                                            <EditFormSettings Visible="False" />
                                            <CellStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                        </dx:GridViewDataDateColumn>

                                        <dx:GridViewDataTextColumn Caption="" ShowInCustomizationForm="True" Width="100px" VisibleIndex="999">
                                            <EditFormSettings Visible="False" />
                                            <DataItemTemplate>
                                                <div style="width: 100%; float: left; text-align: center">
                                                    <img src="/assets/img/update.png" width="32" height="32" title="تعديل" style="cursor: pointer" onclick="editCurrentRow();" />

                                                    <img src="/assets/img/delete.png" width="32" height="32" title="حذف" style="cursor: pointer" onclick="onDeleteClick(<%# Container.VisibleIndex %>, '1');" />
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
                            </div>
                            <dx:ASPxPopupControl ID="popupUsernameError" runat="server" ClientInstanceName="popupUsernameError"
                                HeaderText="خطأ"
                                Modal="True"
                                CloseAction="CloseButton"
                                PopupHorizontalAlign="WindowCenter"
                                Width="300"
                                Height="100"
                                HeaderStyle-Font-Names="Cairo" HeaderStyle-Font-Size="20px"
                                OnClientShown="function(s,e){s.UpdatePosition();}"
                                Font-Names="Cairo" Font-Size="16px"
                                CloseButton-Visible="False">

                                <ContentCollection>
                                    <dx:PopupControlContentControl>
                                        <div style="font-family: Cairo; font-size: 16px; color: #D8000C; line-height: 1.5; background-color: #FFD2D2; padding: 15px; border-radius: 10px;">
                                            <div id="popupUsernameErrorContent"></div>
                                        </div>
                                    </dx:PopupControlContentControl>
                                </ContentCollection>
                            </dx:ASPxPopupControl>



                            <asp:SqlDataSource
                                ID="db_MachineUsers"
                                runat="server"
                                ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>"
                                SelectCommand="SELECT id, username, password, firstName, lastName, isActive, countryId, companyId, branchId,userDate FROM [usersMachine]"
                                InsertCommand="INSERT INTO [usersMachine] 
                                    (username, password, storedsalt, firstName, lastName, isActive, countryId, companyId, branchId, userDate)
                                    VALUES 
                                    (@username, @password, @storedsalt, @firstName, @lastName, @isActive, @countryId, @companyId, @branchId ,getDate())"
                                UpdateCommand="UPDATE [usersMachine]
                                    SET
                                        username = @username,
                                        password = @password,
                                        storedsalt = @storedsalt,
                                        firstName = @firstName,
                                        lastName = @lastName,
                                        isActive = @isActive,
                                        countryId = @countryId,
                                        companyId = @companyId,
                                        branchId = @branchId
                                    WHERE id = @id"
                                DeleteCommand="DELETE FROM usersMachine where id =@id">

                                <InsertParameters>
                                    <asp:Parameter Name="username" Type="String" />
                                    <asp:Parameter Name="password" Type="String" />
                                    <asp:Parameter Name="storedsalt" />
                                    <asp:Parameter Name="firstName" Type="String" />
                                    <asp:Parameter Name="lastName" Type="String" />
                                    <asp:Parameter Name="isActive" Type="Boolean" />
                                    <asp:Parameter Name="countryId" Type="Int32" />
                                    <asp:Parameter Name="companyId" Type="Int32" />
                                    <asp:Parameter Name="branchId" Type="Int32" />
                                </InsertParameters>
                                <UpdateParameters>
                                    <asp:Parameter Name="username" Type="String" />
                                    <asp:Parameter Name="password" Type="String" />
                                    <asp:Parameter Name="storedsalt" Type="Object" />
                                    <asp:Parameter Name="firstName" Type="String" />
                                    <asp:Parameter Name="lastName" Type="String" />
                                    <asp:Parameter Name="isActive" Type="Boolean" />
                                    <asp:Parameter Name="countryId" Type="Int32" />
                                    <asp:Parameter Name="companyId" Type="Int32" />
                                    <asp:Parameter Name="branchId" Type="Int32" />
                                    <asp:Parameter Name="id" Type="Int32" />
                                </UpdateParameters>
                                <DeleteParameters>
                                    <asp:Parameter Name="id" Type="Int32" />
                                </DeleteParameters>
                            </asp:SqlDataSource>



                            <asp:SqlDataSource
                                ID="db_Products"
                                runat="server"
                                ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>"
                                SelectCommand="SELECT id,name,countryId,companyId,rate,rateCount FROM [products]"></asp:SqlDataSource>


                            <asp:SqlDataSource
                                ID="db_productName"
                                runat="server"
                                ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>"
                                SelectCommand="SELECT id, name FROM [products]" />
                            <asp:SqlDataSource
                                ID="db_branchName"
                                runat="server"
                                ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>"
                                SelectCommand="SELECT id, name FROM [branches]" />
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
                                        }">

                                <ClientSideEvents EndCallback="function(){GridProductRates.Refresh();
                                        GridProducts.Refresh();
                                        }"></ClientSideEvents>
                            </dx:ASPxCallback>

                            <dx:ASPxPopupControl runat="server" ID="Pop_Del_MachineUsers"
                                PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter"
                                AutoUpdatePosition="True" Modal="True" ClientInstanceName="Pop_Del_MachineUsers"
                                HeaderText="حذف مستخدم" Font-Names="Cairo"
                                Width="350px" Height="150px" CloseAnimationType="Slide">
                                <ContentCollection>
                                    <dx:PopupControlContentControl runat="server">
                                        <div style="padding: 20px; text-align: right; font-family: 'Cairo', sans-serif;">
                                            <div class="mb-3">
                                                <dx:ASPxLabel ID="Label_DeleteUser" runat="server" Text="هل أنت متأكد من حذف المستخدم؟"
                                                    Font-Names="Cairo" Font-Size="Medium" ForeColor="#333333" />
                                            </div>
                                            <div style="margin-top: 20px; text-align: center;">
                                                <dx:ASPxButton ID="Btn_ConfirmDeleteUser" runat="server" Text="حذف"
                                                    AutoPostBack="False" Font-Names="Cairo">
                                                    <ClientSideEvents Click="function(s, e) { 
                            GridMachineUsers.DeleteRow(MyIndex); 
                            setTimeout(function() { GridMachineUsers.Refresh(); }, 200);
                            Pop_Del_MachineUsers.Hide(); 
                        }" />
                                                </dx:ASPxButton>
                                                <dx:ASPxButton ID="Btn_CancelDeleteUser" runat="server" Text="إغلاق"
                                                    AutoPostBack="False" Font-Names="Cairo" Style="margin-right: 20px;">
                                                    <ClientSideEvents Click="function(s, e) { Pop_Del_MachineUsers.Hide(); }" />
                                                </dx:ASPxButton>
                                            </div>
                                        </div>
                                    </dx:PopupControlContentControl>
                                </ContentCollection>
                            </dx:ASPxPopupControl>

                        </dx:ContentControl>
                    </ContentCollection>
                </dx:TabPage>


                <%----------------------------------------------------------------------------------------------------------------------------------%>


                <dx:TabPage Text="مستخدمين التوصيل" TabStyle-Font-Bold="true" TabStyle-Font-Names="cairo" TabStyle-Font-Size="X-Large">
                    <TabStyle Font-Bold="True" Font-Names="cairo" Font-Size="X-Large"></TabStyle>
                    <ContentCollection>
                        <dx:ContentControl>

                            <script>

                                function ShowASPXPopup(action, userId, existingNote) {
                                    hfPopupAction.Set("value", action);
                                    hfPopupUserId.Set("value", userId);

                                    // إخفاء الخطأ كل مرة
                                    lblPopupError.SetVisible(false);
                                    lblPopupError.SetText("");

                                    if (action === "approve") {
                                        lblPopupMessage.SetText("هل أنت متأكد من الموافقة على هذا المستخدم؟");
                                        txtPopupNote.SetVisible(false);
                                        txtPopupNote.SetText("");
                                    }
                                    else if (action === "reject") {
                                        lblPopupMessage.SetText("الرجاء كتابة سبب الرفض:");
                                        txtPopupNote.SetVisible(true);
                                        txtPopupNote.SetText(existingNote || "");
                                    }
                                    else if (action === "incomplete") {
                                        lblPopupMessage.SetText("الرجاء كتابة الملاحظة المطلوبة:");
                                        txtPopupNote.SetVisible(true);
                                        txtPopupNote.SetText(existingNote || "");
                                    }

                                    popupConfirm.Show();
                                }

                                function ConfirmPopupAction() {
                                    var action = hfPopupAction.Get("value");
                                    var userId = hfPopupUserId.Get("value");
                                    var note = txtPopupNote.GetText().trim();

                                    // شرط الملاحظة للحالات reject & incomplete
                                    if (action === "reject" || action === "incomplete") {
                                        var hasLetter = /[A-Za-z\u0600-\u06FF]/.test(note);
                                        if (!hasLetter) {
                                            lblPopupError.SetText("الرجاء كتابة الملاحظة.");
                                            lblPopupError.SetVisible(true);
                                            return;
                                        }
                                    }

                                    GridDeliveryUsers.PerformCallback(action + ":" + userId + ":" + note);
                                    popupConfirm.Hide();
                                }

                            </script>
                            <div class="navbar-main navbar-expand-lg px-0 mx-4 border-radius-xl bg-white shadow mt-3 mb-1">

                                <dx:ASPxGridView ID="GridDeliveryUsers" runat="server" DataSourceID="db_DeliveryUsers" KeyFieldName="id" ClientInstanceName="GridDeliveryUsers" Width="100%" AutoGenerateColumns="False" EnablePagingCallbackAnimation="True" Font-Names="cairo" Font-Size="0.93em" RightToLeft="True" OnRowInserting="GridDeliveryUsers_RowInserting" OnRowUpdating="GridDeliveryUsers_RowUpdating" OnRowValidating="GridDeliveryUsers_RowValidating" OnCancelRowEditing="GridDeliveryUsers_CancelRowEditing" OnRowDeleting="GridDeliveryUsers_RowDeleting" OnCellEditorInitialize="GridDeliveryUsers_CellEditorInitialize" OnHtmlDataCellPrepared="GridDeliveryUsers_HtmlDataCellPrepared" OnHtmlRowPrepared="GridDeliveryUsers_HtmlRowPrepared" OnCustomCallback="GridDeliveryUsers_CustomCallback">
                                    <Settings ShowFooter="True" ShowFilterRow="True" />

                                    <EditFormLayoutProperties ColCount="3">
                                        <Items>
                                            <dx:GridViewLayoutGroup Caption="البيانات الأساسية" ColCount="2" ColSpan="3">
                                                <Items>
                                                    <dx:GridViewColumnLayoutItem ColumnName="countryId" />
                                                    <dx:GridViewColumnLayoutItem ColumnName="username" />
                                                    <dx:GridViewColumnLayoutItem ColumnName="email" />
                                                    <dx:GridViewColumnLayoutItem ColumnName="firstName" />
                                                    <dx:GridViewColumnLayoutItem ColumnName="lastName" />
                                                    <dx:GridViewColumnLayoutItem ColumnName="password" />
                                                    <dx:GridViewColumnLayoutItem ColumnName="isActive" />
                                                    <dx:GridViewColumnLayoutItem ColumnName="l_vehicleType" />
                                                    <dx:GridViewColumnLayoutItem ColumnName="vehicleNo" />
                                                    <dx:GridViewColumnLayoutItem ColumnName="vehicleVin" />
                                                </Items>
                                            </dx:GridViewLayoutGroup>

                                            <dx:GridViewLayoutGroup Caption="الصور" ColCount="3">
                                                <Items>
                                                    <dx:GridViewColumnLayoutItem ColumnName="image" />
                                                    <dx:GridViewColumnLayoutItem ColumnName="idFrontPicture" />
                                                    <dx:GridViewColumnLayoutItem ColumnName="idBackPicture" />
                                                    <dx:GridViewColumnLayoutItem ColumnName="carPicture" />
                                                    <dx:GridViewColumnLayoutItem ColumnName="carLicensePicture" />
                                                    <dx:GridViewColumnLayoutItem ColumnName="licensePicture" />
                                                </Items>
                                            </dx:GridViewLayoutGroup>

                                            <dx:EditModeCommandLayoutItem ColumnSpan="3" HorizontalAlign="Center" />
                                        </Items>
                                    </EditFormLayoutProperties>




                                    <ClientSideEvents BeginCallback="OnGridBeginCallback1" EndCallback="function(s, e) {
                                            if(s.cpErrorMessage){
                                                popupError.SetContentHtml(s.cpErrorMessage);
                                                popupError.Show();
                                                s.cpErrorMessage = null; // إزالة الرسالة بعد العرض
                                            }
                                        }"
                                        RowClick="function(s, e) {OnRowClick1(e);}" RowDblClick="function(s, e) {setTimeout(function(){GridDeliveryUsers.StartEditRow(MyIndex);},100);}" />
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
                                            <CellStyle VerticalAlign="Middle" Font-Size="Medium" HorizontalAlign="Center" />
                                        </dx:GridViewDataColumn>



                                        <dx:GridViewDataColumn Caption="المستخدم (رقم الهاتف)" FieldName="username">
                                            <DataItemTemplate>
                                                <div style="font-family: Cairo; text-align: center;">
                                                    <div style="color: #888; font-size: 12px;"><%# Eval("username") %></div>
                                                    <div style="font-weight: bold;"><%# Eval("fullName") %></div>
                                                    <div style="color: #888; font-size: 12px;"><%# Eval("email") %></div>
                                                </div>
                                            </DataItemTemplate>
                                            <CellStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                        </dx:GridViewDataColumn>

                                        <dx:GridViewDataTextColumn Caption="الاسم الاول" Visible="false" Width="5%" FieldName="firstName">
                                            <PropertiesTextEdit>
                                                <ValidationSettings
                                                    RequiredField-IsRequired="true"
                                                    ErrorText="الاسم الاول مطلوب"
                                                    Display="Dynamic"
                                                    SetFocusOnError="true">
                                                    <RequiredField IsRequired="True"></RequiredField>
                                                </ValidationSettings>
                                            </PropertiesTextEdit>
                                            <CellStyle VerticalAlign="Middle" Font-Size="12px" HorizontalAlign="Center" />
                                            <EditFormSettings Visible="True" />
                                        </dx:GridViewDataTextColumn>

                                        <dx:GridViewDataTextColumn Caption="الاسم الاخير" Visible="false" Width="5%" FieldName="lastName">
                                            <PropertiesTextEdit>
                                                <ValidationSettings
                                                    RequiredField-IsRequired="true"
                                                    ErrorText="الاسم الاخير مطلوب"
                                                    Display="Dynamic"
                                                    SetFocusOnError="true">
                                                    <RequiredField IsRequired="True"></RequiredField>
                                                </ValidationSettings>
                                            </PropertiesTextEdit>
                                            <CellStyle VerticalAlign="Middle" Font-Size="12px" HorizontalAlign="Center" />
                                            <EditFormSettings Visible="True" />
                                        </dx:GridViewDataTextColumn>

                                        <dx:GridViewDataTextColumn Caption="البريد الالكتروني" Visible="false" Width="5%" FieldName="email">
                                            <PropertiesTextEdit>
                                                <ValidationSettings
                                                    RequiredField-IsRequired="true"
                                                    ErrorText="البريد الالكتروني مطلوب"
                                                    Display="Dynamic"
                                                    SetFocusOnError="true">
                                                    <RequiredField IsRequired="True"></RequiredField>
                                                </ValidationSettings>
                                            </PropertiesTextEdit>
                                            <CellStyle VerticalAlign="Middle" Font-Size="12px" HorizontalAlign="Center" />
                                            <EditFormSettings Visible="True" />
                                        </dx:GridViewDataTextColumn>

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
                                            <CellStyle VerticalAlign="Middle" Font-Size="12px" HorizontalAlign="Center" />
                                        </dx:GridViewDataComboBoxColumn>

                                        <dx:GridViewDataTextColumn Caption="كلمة السر" FieldName="password" Visible="false" VisibleIndex="3">
                                            <PropertiesTextEdit Password="True" HelpText="لتغيير كلمة السر الرجاء أدخل قيمة جديدة، أو اترك الحقل لبقاء نفس كلمة السر القديمة" Native="True">
                                                <NullTextStyle ForeColor="Red">
                                                </NullTextStyle>
                                                <Style ForeColor="Red">
                                                     </Style>
                                                <ValidationSettings RequiredField-IsRequired="true" SetFocusOnError="True" ErrorText="حقل اجباري" Display="Dynamic">
                                                    <RequiredField IsRequired="True"></RequiredField>
                                                </ValidationSettings>
                                            </PropertiesTextEdit>
                                            <EditFormSettings ColumnSpan="3" Visible="True" />
                                            <CellStyle VerticalAlign="Middle" Font-Size="12px" HorizontalAlign="Center" />
                                        </dx:GridViewDataTextColumn>

                                        <dx:GridViewDataTextColumn Caption="رقم الشصي" FieldName="vehicleVin">
                                            <PropertiesTextEdit>
                                                <ValidationSettings
                                                    RequiredField-IsRequired="true"
                                                    ErrorText="الاسم الأخير مطلوب"
                                                    Display="Dynamic"
                                                    SetFocusOnError="true">
                                                    <RequiredField IsRequired="True"></RequiredField>
                                                </ValidationSettings>
                                            </PropertiesTextEdit>
                                            <EditFormSettings ColumnSpan="3" />
                                            <CellStyle VerticalAlign="Middle" Font-Size="12px" HorizontalAlign="Center" />
                                        </dx:GridViewDataTextColumn>

                                        <dx:GridViewDataTextColumn Caption="رقم السيارة" FieldName="vehicleNo">
                                            <PropertiesTextEdit>
                                                <ValidationSettings
                                                    RequiredField-IsRequired="true"
                                                    ErrorText="الاسم الأخير مطلوب"
                                                    Display="Dynamic"
                                                    SetFocusOnError="true">
                                                    <RequiredField IsRequired="True"></RequiredField>
                                                </ValidationSettings>
                                            </PropertiesTextEdit>
                                            <EditFormSettings ColumnSpan="3" />
                                            <CellStyle VerticalAlign="Middle" Font-Size="12px" HorizontalAlign="Center" />
                                        </dx:GridViewDataTextColumn>

                                        <dx:GridViewDataComboBoxColumn Caption="فعال" FieldName="isActive">
                                            <PropertiesComboBox ValueType="System.Int32">
                                                <Items>
                                                    <dx:ListEditItem Text="فعال" Value="1" />
                                                    <dx:ListEditItem Text="غير فعال" Value="0" />
                                                </Items>
                                                <ValidationSettings
                                                    RequiredField-IsRequired="true"
                                                    ErrorText="يجب تحديد حالة التفعيل"
                                                    Display="Dynamic"
                                                    SetFocusOnError="true">
                                                    <RequiredField IsRequired="True"></RequiredField>
                                                </ValidationSettings>
                                            </PropertiesComboBox>
                                            <EditFormSettings ColumnSpan="2" />
                                            <CellStyle VerticalAlign="Middle" Font-Size="12px" HorizontalAlign="Center" />
                                        </dx:GridViewDataComboBoxColumn>

                                        <dx:GridViewDataComboBoxColumn Caption="نوع المركبة" FieldName="l_vehicleType">
                                            <PropertiesComboBox ValueType="System.Int32">
                                                <Items>
                                                    <dx:ListEditItem Text="سيارة" Value="1" />
                                                    <dx:ListEditItem Text="دراجة" Value="2" />
                                                </Items>
                                                <ValidationSettings
                                                    RequiredField-IsRequired="true"
                                                    ErrorText="يجب تحديد نوع السيارة"
                                                    Display="Dynamic"
                                                    SetFocusOnError="true">
                                                    <RequiredField IsRequired="True"></RequiredField>
                                                </ValidationSettings>
                                            </PropertiesComboBox>
                                            <EditFormSettings ColumnSpan="2" />
                                            <CellStyle VerticalAlign="Middle" Font-Size="Medium" HorizontalAlign="Center" />
                                            <DataItemTemplate>
                                                <%# GetLottieMarkup(Eval("l_vehicleType")) %>
                                            </DataItemTemplate>
                                        </dx:GridViewDataComboBoxColumn>



                                        <dx:GridViewDataColumn Caption="الصورة الشخصية" Visible="false" FieldName="image">
                                            <CellStyle VerticalAlign="Middle">
                                            </CellStyle>
                                            <EditItemTemplate>
                                                <div style="text-align: center; width: 90%">
                                                    <img id="PersonalImage"
                                                        src='<%# (Eval("image") != null && Eval("image").ToString().Length > 1 ? Eval("image").ToString() : "/assets/uploads/noFile.png") + "?v=" + DateTime.Now.Ticks %>'
                                                        style="width: 15em; border: 1px solid #c8c8c8; border-radius: 5px;" />
                                                    <dx:ASPxUploadControl ID="poorImageUpload" runat="server" ClientInstanceName="poorImageUpload"
                                                        FileUploadMode="OnPageLoad" Font-Names="Cairo" Font-Size="1em"
                                                        OnFileUploadComplete="ImageUpload_FileUploadComplete"
                                                        ShowProgressPanel="True" UploadMode="Auto" Width="100%" AutoStartUpload="True">
                                                        <ValidationSettings AllowedFileExtensions=".jpg, .jpeg, .png, .bmp"
                                                            GeneralErrorText="حدث خطأ أثناء تحميل الصور"
                                                            MaxFileSize="5048576"
                                                            MaxFileSizeErrorText="الحجم أكبر من 1 ميجابايت"
                                                            NotAllowedFileExtensionErrorText="امتداد غير مسموح به" />
                                                        <ClientSideEvents
                                                            FilesUploadStart="function(s,e){ onFileUploadStart(s,e,'image'); }"
                                                            FileUploadComplete="function(s,e){ onFileUploadComplete(s,e,'image'); }" />
                                                        <BrowseButton Text="اختيــــــــار" />
                                                        <CancelButton Text="إلغاء التحميل" />
                                                    </dx:ASPxUploadControl>
                                                </div>
                                            </EditItemTemplate>
                                            <EditFormSettings Visible="True" />

                                        </dx:GridViewDataColumn>

                                        <dx:GridViewDataColumn Caption="صورة السيارة" Visible="false" FieldName="carPicture">
                                            <CellStyle VerticalAlign="Middle">
                                            </CellStyle>
                                            <EditItemTemplate>
                                                <div style="text-align: center; width: 90%">
                                                    <img id="CarImage"
                                                        src='<%# (Eval("carPicture") != null && Eval("carPicture").ToString().Length > 1 ? Eval("carPicture").ToString() : "/assets/uploads/noFile.png") + "?v=" + DateTime.Now.Ticks %>'
                                                        style="width: 15em; border: 1px solid #c8c8c8; border-radius: 5px;" />
                                                    <dx:ASPxUploadControl ID="carImageUpload" runat="server" ClientInstanceName="carImageUpload"
                                                        FileUploadMode="OnPageLoad" Font-Names="Cairo" Font-Size="1em"
                                                        OnFileUploadComplete="ImageUpload_FileUploadComplete"
                                                        ShowProgressPanel="True" UploadMode="Auto" Width="100%" AutoStartUpload="True">
                                                        <ValidationSettings AllowedFileExtensions=".jpg, .jpeg, .png, .bmp"
                                                            GeneralErrorText="حدث خطأ أثناء تحميل الصور"
                                                            MaxFileSize="5048576"
                                                            MaxFileSizeErrorText="الحجم أكبر من 1 ميجابايت"
                                                            NotAllowedFileExtensionErrorText="امتداد غير مسموح به" />
                                                        <ClientSideEvents
                                                            FilesUploadStart="function(s,e){ onFileUploadStart(s,e,'carPicture'); }"
                                                            FileUploadComplete="function(s,e){ onFileUploadComplete(s,e,'carPicture'); }" />
                                                        <BrowseButton Text="اختيــــــــار" />
                                                        <CancelButton Text="إلغاء التحميل" />
                                                    </dx:ASPxUploadControl>
                                                </div>
                                            </EditItemTemplate>
                                            <EditFormSettings Visible="True" />

                                        </dx:GridViewDataColumn>

                                        <dx:GridViewDataColumn Caption="رخصة السيارة" Visible="false" FieldName="carLicensePicture">
                                            <CellStyle VerticalAlign="Middle">
                                            </CellStyle>
                                            <EditItemTemplate>
                                                <div style="text-align: center; width: 90%">
                                                    <img id="CarLicense"
                                                        src='<%# (Eval("carLicensePicture") != null && Eval("carLicensePicture").ToString().Length > 1 ? Eval("carLicensePicture").ToString() : "/assets/uploads/noFile.png") + "?v=" + DateTime.Now.Ticks %>'
                                                        style="width: 15em; border: 1px solid #c8c8c8; border-radius: 5px;" />
                                                    <dx:ASPxUploadControl ID="carImageUpload" runat="server" ClientInstanceName="carImageUpload"
                                                        FileUploadMode="OnPageLoad" Font-Names="Cairo" Font-Size="1em"
                                                        OnFileUploadComplete="ImageUpload_FileUploadComplete"
                                                        ShowProgressPanel="True" UploadMode="Auto" Width="100%" AutoStartUpload="True">
                                                        <ValidationSettings AllowedFileExtensions=".jpg, .jpeg, .png, .bmp"
                                                            GeneralErrorText="حدث خطأ أثناء تحميل الصور"
                                                            MaxFileSize="5048576"
                                                            MaxFileSizeErrorText="الحجم أكبر من 1 ميجابايت"
                                                            NotAllowedFileExtensionErrorText="امتداد غير مسموح به" />
                                                        <ClientSideEvents
                                                            FilesUploadStart="function(s,e){ onFileUploadStart(s,e,'carLicense'); }"
                                                            FileUploadComplete="function(s,e){ onFileUploadComplete(s,e,'carLicense'); }" />
                                                        <BrowseButton Text="اختيــــــــار" />
                                                        <CancelButton Text="إلغاء التحميل" />
                                                    </dx:ASPxUploadControl>
                                                </div>
                                            </EditItemTemplate>
                                            <EditFormSettings Visible="True" />

                                        </dx:GridViewDataColumn>

                                        <dx:GridViewDataColumn Caption="الهوية من الامام" Visible="false" FieldName="idFrontPicture">
                                            <CellStyle VerticalAlign="Middle">
                                            </CellStyle>
                                            <EditItemTemplate>
                                                <div style="text-align: center; width: 90%">
                                                    <img id="IdFront"
                                                        src='<%# (Eval("idFrontPicture") != null && Eval("idFrontPicture").ToString().Length > 1 ? Eval("idFrontPicture").ToString() : "/assets/uploads/noFile.png") + "?v=" + DateTime.Now.Ticks %>'
                                                        style="width: 15em; border: 1px solid #c8c8c8; border-radius: 5px;" />
                                                    <dx:ASPxUploadControl ID="carImageUpload" runat="server" ClientInstanceName="carImageUpload"
                                                        FileUploadMode="OnPageLoad" Font-Names="Cairo" Font-Size="1em"
                                                        OnFileUploadComplete="ImageUpload_FileUploadComplete"
                                                        ShowProgressPanel="True" UploadMode="Auto" Width="100%" AutoStartUpload="True">
                                                        <ValidationSettings AllowedFileExtensions=".jpg, .jpeg, .png, .bmp"
                                                            GeneralErrorText="حدث خطأ أثناء تحميل الصور"
                                                            MaxFileSize="5048576"
                                                            MaxFileSizeErrorText="الحجم أكبر من 1 ميجابايت"
                                                            NotAllowedFileExtensionErrorText="امتداد غير مسموح به" />
                                                        <ClientSideEvents
                                                            FilesUploadStart="function(s,e){ onFileUploadStart(s,e,'idFront'); }"
                                                            FileUploadComplete="function(s,e){ onFileUploadComplete(s,e,'idFront'); }" />
                                                        <BrowseButton Text="اختيــــــــار" />
                                                        <CancelButton Text="إلغاء التحميل" />
                                                    </dx:ASPxUploadControl>
                                                </div>
                                            </EditItemTemplate>
                                            <EditFormSettings Visible="True" />

                                        </dx:GridViewDataColumn>

                                        <dx:GridViewDataColumn Caption="الهوية من الخلف" Visible="false" FieldName="idBackPicture">
                                            <CellStyle VerticalAlign="Middle">
                                            </CellStyle>
                                            <EditItemTemplate>
                                                <div style="text-align: center; width: 90%">
                                                    <img id="IdBack"
                                                        src='<%# (Eval("idBackPicture") != null && Eval("idBackPicture").ToString().Length > 1 ? Eval("idBackPicture").ToString() : "/assets/uploads/noFile.png") + "?v=" + DateTime.Now.Ticks %>'
                                                        style="width: 15em; border: 1px solid #c8c8c8; border-radius: 5px;" />
                                                    <dx:ASPxUploadControl ID="carImageUpload" runat="server" ClientInstanceName="carImageUpload"
                                                        FileUploadMode="OnPageLoad" Font-Names="Cairo" Font-Size="1em"
                                                        OnFileUploadComplete="ImageUpload_FileUploadComplete"
                                                        ShowProgressPanel="True" UploadMode="Auto" Width="100%" AutoStartUpload="True">
                                                        <ValidationSettings AllowedFileExtensions=".jpg, .jpeg, .png, .bmp"
                                                            GeneralErrorText="حدث خطأ أثناء تحميل الصور"
                                                            MaxFileSize="5048576"
                                                            MaxFileSizeErrorText="الحجم أكبر من 1 ميجابايت"
                                                            NotAllowedFileExtensionErrorText="امتداد غير مسموح به" />
                                                        <ClientSideEvents
                                                            FilesUploadStart="function(s,e){ onFileUploadStart(s,e,'idBack'); }"
                                                            FileUploadComplete="function(s,e){ onFileUploadComplete(s,e,'idBack'); }" />
                                                        <BrowseButton Text="اختيــــــــار" />
                                                        <CancelButton Text="إلغاء التحميل" />
                                                    </dx:ASPxUploadControl>
                                                </div>
                                            </EditItemTemplate>
                                            <EditFormSettings Visible="True" />

                                        </dx:GridViewDataColumn>

                                        <dx:GridViewDataColumn Caption="رخصة القيادة" Visible="false" FieldName="licensePicture">
                                            <CellStyle VerticalAlign="Middle">
                                            </CellStyle>
                                            <EditItemTemplate>
                                                <div style="text-align: center; width: 90%">
                                                    <img id="License"
                                                        src='<%# (Eval("licensePicture") != null && Eval("licensePicture").ToString().Length > 1 ? Eval("licensePicture").ToString() : "/assets/uploads/noFile.png") + "?v=" + DateTime.Now.Ticks %>'
                                                        style="width: 15em; border: 1px solid #c8c8c8; border-radius: 5px;" />
                                                    <dx:ASPxUploadControl ID="carImageUpload" runat="server" ClientInstanceName="carImageUpload"
                                                        FileUploadMode="OnPageLoad" Font-Names="Cairo" Font-Size="1em"
                                                        OnFileUploadComplete="ImageUpload_FileUploadComplete"
                                                        ShowProgressPanel="True" UploadMode="Auto" Width="100%" AutoStartUpload="True">
                                                        <ValidationSettings AllowedFileExtensions=".jpg, .jpeg, .png, .bmp"
                                                            GeneralErrorText="حدث خطأ أثناء تحميل الصور"
                                                            MaxFileSize="5048576"
                                                            MaxFileSizeErrorText="الحجم أكبر من 1 ميجابايت"
                                                            NotAllowedFileExtensionErrorText="امتداد غير مسموح به" />
                                                        <ClientSideEvents
                                                            FilesUploadStart="function(s,e){ onFileUploadStart(s,e,'license'); }"
                                                            FileUploadComplete="function(s,e){ onFileUploadComplete(s,e,'license'); }" />
                                                        <BrowseButton Text="اختيــــــــار" />
                                                        <CancelButton Text="إلغاء التحميل" />
                                                    </dx:ASPxUploadControl>
                                                </div>
                                            </EditItemTemplate>
                                            <EditFormSettings Visible="True" />

                                        </dx:GridViewDataColumn>

                                        <dx:GridViewDataTextColumn Caption="حالة التسجيل" Width="130px">
                                            <DataItemTemplate>

                                                <dx:ASPxLabel ID="lblStatus" runat="server" Font-Names="Cairo"></dx:ASPxLabel>


                                                <div style="display: flex; flex-direction: column; gap: 8px; margin-top: 5px;">
                                                    <dx:ASPxButton ID="btnApprove" runat="server" Text="موافقة" Width="100%" Theme="Material" AutoPostBack="false" BackColor="Green" Font-Names="Cairo" />
                                                    <dx:ASPxButton ID="btnReject" runat="server" Text="رفض" Width="100%" Theme="Material" AutoPostBack="false" BackColor="Red" Font-Names="Cairo" />

                                                    <dx:ASPxButton ID="btnIncomplete" runat="server" Text="غير مكتمل" Width="100%" Theme="Material" AutoPostBack="false" Font-Names="Cairo" />

                                                    <div class="water-button-wrapper">
                                                        <dx:ASPxButton ID="btnIncompleteBulb" runat="server" Text="غير مكتمل&#10;تم التحديث"
                                                            Width="100%" Theme="Material" AutoPostBack="false"
                                                            Font-Names="Cairo" ClientVisible="False" />
                                                    </div>
                                            </DataItemTemplate>
                                        </dx:GridViewDataTextColumn>

                                        <dx:GridViewDataTextColumn Caption="ملاحظة التسجيل">
                                            <DataItemTemplate>
                                                <%# 
                                                    Convert.ToInt32(Eval("l_DeliveryStatusId")) == 4
                                                    ? Eval("rejectNote")
                                                    : Convert.ToInt32(Eval("l_DeliveryStatusId")) == 2
                                                        ? Eval("incompleteNote")
                                                        : "لا يوجد"
                                                %>
                                            </DataItemTemplate>
                                            <CellStyle VerticalAlign="Middle" Font-Size="12px" HorizontalAlign="Center" />
                                        </dx:GridViewDataTextColumn>

                                        <dx:GridViewDataColumn Caption="الصور" ShowInCustomizationForm="True">
                                            <EditFormSettings Visible="False" />
                                            <DataItemTemplate>
                                                <div style="text-align: center; font-family: Cairo;">

                                                    <!-- Row 1: الصورة الشخصية، الهوية من الأمام، الهوية من الخلف -->
                                                    <div style="display: flex; justify-content: center; gap: 20px; margin-bottom: 10px;">
                                                        <div>
                                                            <a href="javascript:void(0);" onclick="showImagePopup('<%# Eval("image") %>')">
                                                                <img src='<%# (!string.IsNullOrEmpty(Eval("image").ToString()) ? Eval("image").ToString() : "/assets/uploads/noFile.png") + "?v=" + DateTime.Now.Ticks %>'
                                                                    style="width: 5em; border: 1px solid #ccc; border-radius: 5px;" />
                                                            </a>
                                                            <div style="margin-top: 5px;">الصورة الشخصية</div>
                                                        </div>
                                                        <div>
                                                            <a href="javascript:void(0);" onclick="showImagePopup('<%# Eval("idFrontPicture") %>')">
                                                                <img src='<%# (!string.IsNullOrEmpty(Eval("idFrontPicture").ToString()) ? Eval("idFrontPicture").ToString() : "/assets/uploads/noFile.png") + "?v=" + DateTime.Now.Ticks %>'
                                                                    style="width: 5em; border: 1px solid #ccc; border-radius: 5px;" />
                                                            </a>
                                                            <div style="margin-top: 5px;">الهوية من الأمام</div>
                                                        </div>
                                                        <div>
                                                            <a href="javascript:void(0);" onclick="showImagePopup('<%# Eval("idBackPicture") %>')">
                                                                <img src='<%# (!string.IsNullOrEmpty(Eval("idBackPicture").ToString()) ? Eval("idBackPicture").ToString() : "/assets/uploads/noFile.png") + "?v=" + DateTime.Now.Ticks %>'
                                                                    style="width: 5em; border: 1px solid #ccc; border-radius: 5px;" />
                                                            </a>
                                                            <div style="margin-top: 5px;">الهوية من الخلف</div>
                                                        </div>
                                                    </div>

                                                    <!-- Row 2: صورة السيارة، رخصة السيارة، رخصة القيادة -->
                                                    <div style="display: flex; justify-content: center; gap: 20px;">
                                                        <div>
                                                            <a href="javascript:void(0);" onclick="showImagePopup('<%# Eval("carPicture") %>')">
                                                                <img src='<%# (!string.IsNullOrEmpty(Eval("carPicture").ToString()) ? Eval("carPicture").ToString() : "/assets/uploads/noFile.png") + "?v=" + DateTime.Now.Ticks %>'
                                                                    style="width: 5em; border: 1px solid #ccc; border-radius: 5px;" />
                                                            </a>
                                                            <div style="margin-top: 5px;">صورة السيارة</div>
                                                        </div>
                                                        <div>
                                                            <a href="javascript:void(0);" onclick="showImagePopup('<%# Eval("carLicensePicture") %>')">
                                                                <img src='<%# (!string.IsNullOrEmpty(Eval("carLicensePicture").ToString()) ? Eval("carLicensePicture").ToString() : "/assets/uploads/noFile.png") + "?v=" + DateTime.Now.Ticks %>'
                                                                    style="width: 5em; border: 1px solid #ccc; border-radius: 5px;" />
                                                            </a>
                                                            <div style="margin-top: 5px;">رخصة السيارة</div>
                                                        </div>
                                                        <div>
                                                            <a href="javascript:void(0);" onclick="showImagePopup('<%# Eval("licensePicture") %>')">
                                                                <img src='<%# (!string.IsNullOrEmpty(Eval("licensePicture").ToString()) ? Eval("licensePicture").ToString() : "/assets/uploads/noFile.png") + "?v=" + DateTime.Now.Ticks %>'
                                                                    style="width: 5em; border: 1px solid #ccc; border-radius: 5px;" />
                                                            </a>
                                                            <div style="margin-top: 5px;">رخصة القيادة</div>
                                                        </div>
                                                    </div>

                                                </div>
                                            </DataItemTemplate>
                                        </dx:GridViewDataColumn>

                                        <dx:GridViewDataDateColumn FieldName="userDate" Caption="التاريخ">
                                            <PropertiesDateEdit DisplayFormatString="yyyy/MM/dd hh:mm tt" />
                                            <EditFormSettings Visible="False" />
                                            <CellStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                        </dx:GridViewDataDateColumn>

                                        <dx:GridViewDataTextColumn Caption="" ShowInCustomizationForm="True" VisibleIndex="999">
                                            <EditFormSettings Visible="False" />
                                            <DataItemTemplate>
                                                <div style="width: 100%; float: left; text-align: center">
                                                    <img src="/assets/img/update.png" width="32" height="32" title="تعديل" style="cursor: pointer" onclick="editCurrentRow1();" />
                                                    <img src="/assets/img/delete.png" width="32" height="32" title="حذف" style="cursor: pointer" onclick="onDeleteClick1(<%# Container.VisibleIndex %>, '1');" />
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


                            <dx:ASPxPopupControl ID="popupError" runat="server" ClientInstanceName="popupError"
                                HeaderText="خطأ"
                                Modal="True"
                                CloseAction="CloseButton"
                                PopupHorizontalAlign="WindowCenter"
                                PopupVerticalAlign="WindowCenter"
                                ShowOnPageLoad="False"
                                OnClientShown="function(s,e){s.UpdatePosition();}"
                                Width="300px"
                                Height="100px"
                                HeaderStyle-Font-Names="Cairo" HeaderStyle-Font-Size="20px"
                                Font-Names="Cairo" Font-Size="16px">

                                <ContentCollection>
                                    <dx:PopupControlContentControl>
                                        <div style="font-family: Cairo; font-size: 16px; color: #D8000C; line-height: 1.5; background-color: #FFD2D2; padding: 15px; border-radius: 10px;">
                                            <div id="popupErrorContent"></div>
                                            <div style="text-align: center; margin-top: 20px;">
                                                <asp:Button ID="btnClosePopup" runat="server" Text="إغلاق"
                                                    OnClientClick="popupError.Hide(); return false;"
                                                    Style="font-family: Cairo; font-size: 16px; padding: 8px 20px; border-radius: 5px; background-color: #D8000C; color: white; border: none; cursor: pointer;" />
                                            </div>
                                        </div>
                                    </dx:PopupControlContentControl>
                                </ContentCollection>
                            </dx:ASPxPopupControl>


                            <asp:SqlDataSource
                                ID="db_DeliveryUsers"
                                runat="server"
                                ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>"
                                SelectCommand="SELECT id, username,email, firstName + ' ' + lastName AS fullName, userPicture AS image, carPicture ,carLicensePicture ,idFrontPicture,idBackPicture,licensePicture, password, firstName, lastName, l_vehicleType, isActive, vehicleVin, vehicleNo ,l_DeliveryStatusId,incompleteNote,rejectNote,isUpdated,isOnline,countryId,userDate FROM [usersDelivery] order by l_deliveryStatus "
                                InsertCommand="INSERT INTO [usersDelivery] 
                                    (username, password, storedsalt, email, firstName, lastName, isActive, l_vehicleType, userPicture ,carPicture,carLicensePicture,idFrontPicture,idBackPicture,licensePicture,vehicleNo,vehicleVin,isOnline,countryId,l_DeliveryStatusId, userDate)
                                    VALUES 
                                    (@username, @password, @storedsalt,@email, @firstName, @lastName, @isActive,@l_vehicleType, @image,@carPicture,@carLicensePicture,@idFrontPicture,@idBackPicture,@licensePicture, @vehicleNo, @vehicleVin, @isOnline,@countryId,3, getDate())"
                                UpdateCommand="UPDATE [usersDelivery]
                                    SET
                                        username = @username,
                                        password = @password,
                                        storedsalt = @storedsalt,
                                        firstName = @firstName,
                                        email = @email,
                                        lastName = @lastName,
                                        l_vehicleType = @l_vehicleType,
                                        vehicleVin = @vehicleVin,
                                        vehicleNo = @vehicleNo,
                                        isOnline = @isOnline,
                                        userPicture = @image,
                                        carPicture = @carPicture,
                                        carLicensePicture = @carLicensePicture,
                                        idFrontPicture = @idFrontPicture,
                                        idBackPicture = @idBackPicture,
                                        licensePicture = @licensePicture,
                                        countryId = @countryId,
                                        isActive = @isActive
                                    WHERE id = @id"
                                DeleteCommand="DELETE FROM usersDelivery where id =@id">

                                <InsertParameters>
                                    <asp:Parameter Name="username" Type="String" />
                                    <asp:Parameter Name="password" Type="String" />
                                    <asp:Parameter Name="storedsalt" />
                                    <asp:Parameter Name="email" Type="String" />
                                    <asp:Parameter Name="firstName" Type="String" />
                                    <asp:Parameter Name="lastName" Type="String" />
                                    <asp:Parameter Name="vehicleVin" Type="String" />
                                    <asp:Parameter Name="isOnline" Type="String" />
                                    <asp:Parameter Name="vehicleNo" Type="String" />
                                    <asp:Parameter Name="isActive" Type="Boolean" />
                                    <asp:Parameter Name="l_vehicleType" Type="string" />
                                    <asp:Parameter Name="countryId" Type="string" />
                                    <asp:ControlParameter ControlID="l_item_file" Name="image" PropertyName="Text" />
                                    <asp:ControlParameter ControlID="l_car_file" Name="carPicture" PropertyName="Text" />
                                    <asp:ControlParameter ControlID="l_carLicense_file" Name="carLicensePicture" PropertyName="Text" />
                                    <asp:ControlParameter ControlID="l_idFront_file" Name="idFrontPicture" PropertyName="Text" />
                                    <asp:ControlParameter ControlID="l_idBack_file" Name="idBackPicture" PropertyName="Text" />
                                    <asp:ControlParameter ControlID="l_license_file" Name="licensePicture" PropertyName="Text" />
                                </InsertParameters>
                                <UpdateParameters>
                                    <asp:Parameter Name="username" Type="String" />
                                    <asp:Parameter Name="password" Type="String" />
                                    <asp:Parameter Name="storedsalt" Type="Object" />
                                    <asp:Parameter Name="email" Type="String" />
                                    <asp:Parameter Name="firstName" Type="String" />
                                    <asp:Parameter Name="lastName" Type="String" />
                                    <asp:Parameter Name="vehicleVin" Type="String" />
                                    <asp:Parameter Name="isOnline" Type="String" />
                                    <asp:Parameter Name="vehicleNo" Type="String" />
                                    <asp:Parameter Name="isActive" Type="Boolean" />
                                    <asp:Parameter Name="l_vehicleType" Type="string" />
                                    <asp:Parameter Name="countryId" Type="string" />
                                    <asp:ControlParameter ControlID="l_item_file" Name="image" PropertyName="Text" />
                                    <asp:ControlParameter ControlID="l_car_file" Name="carPicture" PropertyName="Text" />
                                    <asp:ControlParameter ControlID="l_carLicense_file" Name="carLicensePicture" PropertyName="Text" />
                                    <asp:ControlParameter ControlID="l_idFront_file" Name="idFrontPicture" PropertyName="Text" />
                                    <asp:ControlParameter ControlID="l_idBack_file" Name="idBackPicture" PropertyName="Text" />
                                    <asp:ControlParameter ControlID="l_license_file" Name="licensePicture" PropertyName="Text" />
                                    <asp:Parameter Name="id" Type="Int32" />
                                </UpdateParameters>
                                <DeleteParameters>
                                    <asp:Parameter Name="id" Type="Int32" />
                                </DeleteParameters>
                            </asp:SqlDataSource>

                            <asp:SqlDataSource
                                ID="db_L_DeliveryStatus"
                                runat="server"
                                ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>"
                                SelectCommand="SELECT id, description FROM [l_DeliveryStatus]" />

                            <dx:ASPxPopupControl ID="popupImageViewer" runat="server"
                                ClientInstanceName="popupImageViewer"
                                HeaderText="عرض الصورة"
                                ShowCloseButton="true"
                                CloseAction="OuterMouseClick"
                                Modal="true"
                                AllowDragging="false"
                                EnableAnimation="true"
                                ShowShadow="true"
                                PopupHorizontalAlign="WindowCenter"
                                PopupVerticalAlign="WindowCenter"
                                OnClientShown="function(s,e){s.UpdatePosition();}"
                                CssClass="image-popup-cairo-clean">

                                <HeaderStyle Font-Names="Cairo" Font-Size="16px" ForeColor="#333" BackColor="Transparent" />

                                <ContentCollection>
                                    <dx:PopupControlContentControl runat="server">
                                        <div style="display: flex; justify-content: center; align-items: center; padding: 20px;">
                                            <img id="popupImage" runat="server" clientidmode="Static"
                                                src="/assets/uploads/noFile.png"
                                                style="max-width: 90vw; max-height: 80vh; border-radius: 10px; box-shadow: 0 0 20px rgba(0, 0, 0, 0.15);" />
                                            &nbsp;
                                        </div>
                                    </dx:PopupControlContentControl>
                                </ContentCollection>
                            </dx:ASPxPopupControl>

                            <dx:ASPxPopupControl ID="popupConfirm" runat="server" Modal="True"
                                ClientInstanceName="popupConfirm"
                                PopupHorizontalAlign="WindowCenter"
                                PopupVerticalAlign="WindowCenter"
                                CloseAction="CloseButton"
                                HeaderText="تأكيد الإجراء"
                                Width="400px"
                                Font-Names="Cairo">

                                <ContentCollection>
                                    <dx:PopupControlContentControl runat="server" Font-Names="Cairo">

                                        <dx:ASPxLabel ID="lblPopupMessage" runat="server"
                                            Text=""
                                            Font-Names="Cairo"
                                            ClientInstanceName="lblPopupMessage"
                                            Width="100%">
                                        </dx:ASPxLabel>

                                        <dx:ASPxLabel ID="lblPopupError" runat="server"
                                            Text=""
                                            Font-Names="Cairo"
                                            ClientInstanceName="lblPopupError"
                                            Width="100%"
                                            ForeColor="Red"
                                            ClientVisible="False">
                                        </dx:ASPxLabel>

                                        <br />

                                        <dx:ASPxMemo ID="txtPopupNote" runat="server"
                                            Width="100%" Height="90px"
                                            Font-Names="Cairo"
                                            ClientInstanceName="txtPopupNote"
                                            ClientVisible="False">
                                        </dx:ASPxMemo>

                                        <br />
                                        <br />

                                        <dx:ASPxButton ID="btnConfirmAction" runat="server" Text="نعم" AutoPostBack="false"
                                            Font-Names="Cairo">
                                            <ClientSideEvents Click="function(s,e){ ConfirmPopupAction(); }" />
                                        </dx:ASPxButton>

                                        <dx:ASPxButton ID="btnCancelPopup" runat="server" Text="إلغاء" AutoPostBack="false"
                                            Font-Names="Cairo" Style="margin-right: 100px;">
                                            <ClientSideEvents Click="function(s,e){ popupConfirm.Hide(); }" />
                                        </dx:ASPxButton>


                                        <dx:ASPxHiddenField ID="hfPopupAction" runat="server" ClientInstanceName="hfPopupAction" />
                                        <dx:ASPxHiddenField ID="hfPopupUserId" runat="server" ClientInstanceName="hfPopupUserId" />

                                    </dx:PopupControlContentControl>
                                </ContentCollection>
                            </dx:ASPxPopupControl>

                            <dx:ASPxPopupControl runat="server" ID="Pop_Del_usersDelivery"
                                PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter"
                                AutoUpdatePosition="True" Modal="True" ClientInstanceName="Pop_Del_usersDelivery"
                                HeaderText="حذف مستخدم" Font-Names="Cairo"
                                Width="350px" Height="150px" CloseAnimationType="Slide">
                                <ContentCollection>
                                    <dx:PopupControlContentControl runat="server">
                                        <div style="padding: 20px; text-align: right; font-family: 'Cairo', sans-serif;">
                                            <div class="mb-3">
                                                <dx:ASPxLabel ID="ASPxLabel1" runat="server" Text="هل أنت متأكد من حذف المستخدم؟"
                                                    Font-Names="Cairo" Font-Size="Medium" ForeColor="#333333" />
                                            </div>
                                            <div style="margin-top: 20px; text-align: center;">
                                                <dx:ASPxButton ID="ASPxButton1" runat="server" Text="حذف"
                                                    AutoPostBack="False" Font-Names="Cairo">
                                                    <ClientSideEvents Click="function(s, e) { 
                            GridDeliveryUsers.DeleteRow(MyIndex); 
                            setTimeout(function() { GridDeliveryUsers.Refresh(); }, 200);
                            Pop_Del_usersDelivery.Hide(); 
                        }" />
                                                </dx:ASPxButton>
                                                <dx:ASPxButton ID="ASPxButton2" runat="server" Text="إغلاق"
                                                    AutoPostBack="False" Font-Names="Cairo" Style="margin-right: 20px;">
                                                    <ClientSideEvents Click="function(s, e) { Pop_Del_usersDelivery.Hide(); }" />
                                                </dx:ASPxButton>
                                            </div>
                                        </div>
                                    </dx:PopupControlContentControl>
                                </ContentCollection>
                            </dx:ASPxPopupControl>

                            <dx:ASPxHiddenField ID="hfUploadType" runat="server" ClientInstanceName="hfUploadType" />

                            <dx:ASPxTextBox ID="l_item_file" runat="server" BackColor="Transparent" ClientInstanceName="l_item_file" Font-Size="0pt" ForeColor="Transparent" Text="" Width="0px" Theme="Default">
                                <Border BorderStyle="None" BorderWidth="0px" />
                            </dx:ASPxTextBox>
                            <dx:ASPxTextBox ID="l_item_file_old" runat="server" BackColor="Transparent" ClientInstanceName="l_item_file_old" Font-Size="0pt" ForeColor="Transparent" Text="" Width="0px" Theme="Default">
                                <Border BorderStyle="None" BorderWidth="0px" />
                            </dx:ASPxTextBox>
                            <dx:ASPxTextBox ID="l_item_file_check" runat="server" BackColor="Transparent" ClientInstanceName="l_item_file_check" Font-Size="0pt" ForeColor="Transparent" Text="0" Width="0px" Theme="Default">
                                <Border BorderStyle="None" BorderWidth="0px" />
                            </dx:ASPxTextBox>

                            <dx:ASPxTextBox ID="l_car_file" runat="server" BackColor="Transparent" ClientInstanceName="l_car_file" Font-Size="0pt" ForeColor="Transparent" Text="" Width="0px" Theme="Default">
                                <Border BorderStyle="None" BorderWidth="0px" />
                            </dx:ASPxTextBox>
                            <dx:ASPxTextBox ID="l_car_file_old" runat="server" BackColor="Transparent" ClientInstanceName="l_car_file_old" Font-Size="0pt" ForeColor="Transparent" Text="" Width="0px" Theme="Default">
                                <Border BorderStyle="None" BorderWidth="0px" />
                            </dx:ASPxTextBox>
                            <dx:ASPxTextBox ID="l_car_file_check" runat="server" BackColor="Transparent" ClientInstanceName="l_car_file_check" Font-Size="0pt" ForeColor="Transparent" Text="0" Width="0px" Theme="Default">
                                <Border BorderStyle="None" BorderWidth="0px" />
                            </dx:ASPxTextBox>

                            <dx:ASPxTextBox ID="l_carLicense_file" runat="server" BackColor="Transparent" ClientInstanceName="l_carLicense_file" Font-Size="0pt" ForeColor="Transparent" Text="" Width="0px" Theme="Default">
                                <Border BorderStyle="None" BorderWidth="0px" />
                            </dx:ASPxTextBox>
                            <dx:ASPxTextBox ID="l_carLicense_file_old" runat="server" BackColor="Transparent" ClientInstanceName="l_carLicense_file_old" Font-Size="0pt" ForeColor="Transparent" Text="" Width="0px" Theme="Default">
                                <Border BorderStyle="None" BorderWidth="0px" />
                            </dx:ASPxTextBox>
                            <dx:ASPxTextBox ID="l_carLicense_file_check" runat="server" BackColor="Transparent" ClientInstanceName="l_carLicense_file_check" Font-Size="0pt" ForeColor="Transparent" Text="0" Width="0px" Theme="Default">
                                <Border BorderStyle="None" BorderWidth="0px" />
                            </dx:ASPxTextBox>

                            <dx:ASPxTextBox ID="l_idFront_file" runat="server" BackColor="Transparent" ClientInstanceName="l_idFront_file" Font-Size="0pt" ForeColor="Transparent" Text="" Width="0px" Theme="Default">
                                <Border BorderStyle="None" BorderWidth="0px" />
                            </dx:ASPxTextBox>
                            <dx:ASPxTextBox ID="l_idFront_file_old" runat="server" BackColor="Transparent" ClientInstanceName="l_idFront_file_old" Font-Size="0pt" ForeColor="Transparent" Text="" Width="0px" Theme="Default">
                                <Border BorderStyle="None" BorderWidth="0px" />
                            </dx:ASPxTextBox>
                            <dx:ASPxTextBox ID="l_idFront_file_check" runat="server" BackColor="Transparent" ClientInstanceName="l_idFront_file_check" Font-Size="0pt" ForeColor="Transparent" Text="0" Width="0px" Theme="Default">
                                <Border BorderStyle="None" BorderWidth="0px" />
                            </dx:ASPxTextBox>

                            <dx:ASPxTextBox ID="l_idBack_file" runat="server" BackColor="Transparent" ClientInstanceName="l_idBack_file" Font-Size="0pt" ForeColor="Transparent" Text="" Width="0px" Theme="Default">
                                <Border BorderStyle="None" BorderWidth="0px" />
                            </dx:ASPxTextBox>
                            <dx:ASPxTextBox ID="l_idBack_file_old" runat="server" BackColor="Transparent" ClientInstanceName="l_idBack_file_old" Font-Size="0pt" ForeColor="Transparent" Text="" Width="0px" Theme="Default">
                                <Border BorderStyle="None" BorderWidth="0px" />
                            </dx:ASPxTextBox>
                            <dx:ASPxTextBox ID="l_idBack_file_check" runat="server" BackColor="Transparent" ClientInstanceName="l_idBack_file_check" Font-Size="0pt" ForeColor="Transparent" Text="0" Width="0px" Theme="Default">
                                <Border BorderStyle="None" BorderWidth="0px" />
                            </dx:ASPxTextBox>

                            <dx:ASPxTextBox ID="l_license_file" runat="server" BackColor="Transparent" ClientInstanceName="l_license_file" Font-Size="0pt" ForeColor="Transparent" Text="" Width="0px" Theme="Default">
                                <Border BorderStyle="None" BorderWidth="0px" />
                            </dx:ASPxTextBox>
                            <dx:ASPxTextBox ID="l_license_file_old" runat="server" BackColor="Transparent" ClientInstanceName="l_license_file_old" Font-Size="0pt" ForeColor="Transparent" Text="" Width="0px" Theme="Default">
                                <Border BorderStyle="None" BorderWidth="0px" />
                            </dx:ASPxTextBox>
                            <dx:ASPxTextBox ID="l_license_file_check" runat="server" BackColor="Transparent" ClientInstanceName="l_license_file_check" Font-Size="0pt" ForeColor="Transparent" Text="0" Width="0px" Theme="Default">
                                <Border BorderStyle="None" BorderWidth="0px" />
                            </dx:ASPxTextBox>


                        </dx:ContentControl>
                    </ContentCollection>
                </dx:TabPage>
            </TabPages>
        </dx:ASPxPageControl>
    </main>



</asp:Content>
