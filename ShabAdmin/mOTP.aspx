<%@ Page Title="Points" Language="C#" MasterPageFile="~/mSite.Master" AutoEventWireup="true" CodeBehind="mOTP.aspx.cs" Inherits="ShabAdmin.mOTP" %>

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

            var isResetRequired = false;
            function onSelectedCountryChanged(s, e) {
                isResetRequired = true;
                GridPoints.GetEditor("companyId").PerformCallback(s.GetValue());
            }
            function onCityEndCallback(s, e) {
                if (isResetRequired) {
                    isResetRequired = false;
                    s.SetSelectedIndex(0);
                }
            }

        </script>

        <div class="w-100 text-center my-4">
            <h2 class="pageTitle d-inline-block" style="font-family: Cairo">رموز التحقق</h2>
        </div>

        <div class="navbar-main navbar-expand-lg px-0 mx-4 border-radius-xl bg-white shadow mt-3 mb-1">


            <dx:ASPxGridView ID="GridPoints" runat="server" DataSourceID="db_UserOtps" KeyFieldName="id" ClientInstanceName="GridPoints" Width="100%" AutoGenerateColumns="False" EnablePagingCallbackAnimation="True" Font-Names="cairo" Font-Size="1em" RightToLeft="True">
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

                    <dx:GridViewDataTextColumn Caption="اسم المستخدم" FieldName="username">
                        <PropertiesTextEdit>
                            <ValidationSettings RequiredField-IsRequired="true" SetFocusOnError="True" ErrorText="مطلوب" Display="Dynamic">
                                <RequiredField IsRequired="True"></RequiredField>
                            </ValidationSettings>
                        </PropertiesTextEdit>
                        <CellStyle VerticalAlign="Middle" HorizontalAlign="Center" />
                    </dx:GridViewDataTextColumn>

                    <dx:GridViewDataTextColumn Caption="الدولة" FieldName="countryName" ReadOnly="True">
                        <CellStyle VerticalAlign="Middle" HorizontalAlign="Center" />
                    </dx:GridViewDataTextColumn>

                    <dx:GridViewDataTextColumn Caption="رمز التحقق (OTP)" FieldName="otp" Width="20%">
                        <DataItemTemplate>
                            <%# GetOtpSquares(Eval("otp")) %>
                        </DataItemTemplate>
                        <CellStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                    </dx:GridViewDataTextColumn>


                    <dx:GridViewDataCheckColumn Caption="فعال" FieldName="isActive">
                        <PropertiesCheckEdit DisplayTextChecked="نعم" DisplayTextUnchecked="لا" />
                        <CellStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                    </dx:GridViewDataCheckColumn>

                    <dx:GridViewDataCheckColumn Caption="موافقة" FieldName="approved">
                        <PropertiesCheckEdit DisplayTextChecked="موافق" DisplayTextUnchecked="غير موافق" />
                        <CellStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                    </dx:GridViewDataCheckColumn>

                    <dx:GridViewDataSpinEditColumn Caption="تأخير (دقائق)" FieldName="delayedMinutes">
                        <PropertiesSpinEdit DisplayFormatString="g" MaxValue="999999" NumberType="Integer">
                        </PropertiesSpinEdit>
                        <CellStyle HorizontalAlign="Center" VerticalAlign="Middle" Font-Bold="True" Font-Size="Larger" />
                    </dx:GridViewDataSpinEditColumn>

                    <dx:GridViewDataDateColumn Caption="التاريخ" FieldName="userDate" Width="15%">
                        <EditFormSettings Visible="False" />
                        <PropertiesDateEdit DisplayFormatString="dd/MM/yyyy HH:mm:ss" />
                        <CellStyle VerticalAlign="Middle" />
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
                ID="db_UserOtps"
                runat="server"
                ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>"
                SelectCommand="
                        SELECT o.id,
                               o.username,
                               o.otp,
                               o.isActive,
                               o.approved,
                               o.delayedMinutes,
                               o.userDate,
                               u.countryCode,
                               c.countryName
                        FROM usersappotps o
                        LEFT JOIN usersapp u ON o.username = u.username
                        LEFT JOIN countries c ON u.countryCode = c.countryCode
                    ORDER BY o.id DESC;
                    "></asp:SqlDataSource>


        </div>
    </main>



</asp:Content>
