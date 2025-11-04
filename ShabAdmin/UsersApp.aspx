<%@ Page Title="Branches" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="UsersApp.aspx.cs" Inherits="ShabAdmin.UsersApp" %>

<%@ Register Assembly="DevExpress.Web.v24.1, Version=24.1.6.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    
        <main>
            <script>
                var MyIndex;
                var isUpdating = 0;
                function OnRowClick(e) {
                    MyIndex = e.visibleIndex;
                }                
            </script>

            <div class="w-100 text-center my-4">
                <h2 class="pageTitle d-inline-block" style="font-family: Cairo">إدارة مستخدمي التطبيق</h2>
            </div>

            <div class="navbar-main navbar-expand-lg px-0 mx-4 border-radius-xl bg-white shadow mt-3 mb-1 px-3">

                <dx:ASPxGridView ID="Grid_members" runat="server" CssClass="myCenteredGrid" DataSourceID="DB_members" KeyFieldName="id" ClientInstanceName="Grid_members" Width="100%" AutoGenerateColumns="False" EnablePagingCallbackAnimation="True" Font-Names="cairo" Font-Size="1em">
                    <ClientSideEvents RowClick="function(s, e) {OnRowClick(e);}" />
                    <Settings ShowFooter="True" ShowFilterRow="True" />
                    <SettingsAdaptivity AdaptivityMode="HideDataCells">
                    </SettingsAdaptivity>
                    <Settings ShowFilterRow="True" ShowFilterRowMenu="False" ShowHeaderFilterButton="False" AutoFilterCondition="Contains" />

                    <SettingsCommandButton>
                        <UpdateButton Text=" حفظ ">
                            <Image Url="/assets/img/save.png" SpriteProperties-Left="50">
                                <SpriteProperties Left="50px"></SpriteProperties>
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

                    <SettingsSearchPanel CustomEditorID="tbToolbarSearch" />

                    <SettingsExport EnableClientSideExportAPI="true" ExcelExportMode="WYSIWYG" PaperKind="A4" RightToLeft="True" />
                    <SettingsLoadingPanel Text="الرجاء الانتظار &amp;hellip;" Mode="ShowAsPopup" />
                    <SettingsText SearchPanelEditorNullText="ابحث في كامل الجدول..." EmptyDataRow="لا يوجد" />
                    <Columns>
                        <dx:GridViewDataTextColumn FieldName="id" ReadOnly="True" VisibleIndex="0" Width="5%">
                            <EditFormSettings Visible="False" />
                            <CellStyle VerticalAlign="Middle"></CellStyle>
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn Caption="الدولة" FieldName="countryCode" VisibleIndex="1">
                            <EditFormSettings Visible="False" />
                            <CellStyle VerticalAlign="Middle"></CellStyle>
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn Caption="اسم المستخدم" FieldName="username" VisibleIndex="2" Width="30%">
                            <EditFormSettings Visible="False" />
                            <CellStyle VerticalAlign="Middle"></CellStyle>
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn Caption="الاسم الكامل" FieldName="fullName" VisibleIndex="3" Width="30%">
                            <EditFormSettings Visible="False" />
                            <CellStyle VerticalAlign="Middle"></CellStyle>
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataCheckColumn Caption="فعال" FieldName="isActive" VisibleIndex="7" Width="150px">
                            <PropertiesCheckEdit DisplayFormatString="g"></PropertiesCheckEdit>
                            <CellStyle VerticalAlign="Middle"></CellStyle>
                        </dx:GridViewDataCheckColumn>

                        <dx:GridViewDataSpinEditColumn Caption="النقاط" FieldName="userPoints" VisibleIndex="6" Width="10%">
                            <PropertiesSpinEdit DisplayFormatString="g" LargeIncrement="1" MaxValue="100000" NumberType="Integer">
                            </PropertiesSpinEdit>
                            <CellStyle VerticalAlign="Middle">
                            </CellStyle>
                        </dx:GridViewDataSpinEditColumn>
                        <dx:GridViewDataSpinEditColumn Caption="الرصيد" FieldName="balance" VisibleIndex="4" Width="10%">
                            <PropertiesSpinEdit DisplayFormatString="g" LargeIncrement="1">
                            </PropertiesSpinEdit>
                            <CellStyle VerticalAlign="Middle">
                            </CellStyle>
                        </dx:GridViewDataSpinEditColumn>
                        <dx:GridViewDataSpinEditColumn Caption="المستوى" FieldName="l_userLevelId" VisibleIndex="5" Width="10%">
                            <PropertiesSpinEdit DisplayFormatString="g" LargeIncrement="1" NumberType="Integer">
                            </PropertiesSpinEdit>
                            <CellStyle VerticalAlign="Middle">
                            </CellStyle>
                        </dx:GridViewDataSpinEditColumn>
                                                <dx:GridViewDataDateColumn Caption="التاريخ" FieldName="userDate" VisibleIndex="8" Width="11%">
                            <EditFormSettings Visible="False" />
                            <PropertiesDateEdit DisplayFormatString="dd/MM/yyyy"></PropertiesDateEdit>
                            <CellStyle VerticalAlign="Middle"></CellStyle>
                        </dx:GridViewDataDateColumn>

                                                <dx:GridViewDataTextColumn Caption="" ShowInCustomizationForm="True" VisibleIndex="9">
                            <EditFormSettings Visible="False" />
                            <DataItemTemplate>
                                <img src="/assets/img/update.png" width="32" height="32" title="تعديل" style="cursor: pointer" onclick="setTimeout(function(){Grid_members.StartEditRow(MyIndex);},100);" />
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
                                        <dx:ASPxButtonEdit ID="tbToolbarSearch" runat="server" NullText="بحث..." Width="140" Font-Names="cairo" />
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
                </dx:ASPxGridView>



                <asp:SqlDataSource ID="DB_members" runat="server" ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>"
                    SelectCommand=" SELECT id, countryCode, username, firstName + ' ' + lastName as fullName, isActive, balance, l_userLevelId, userPoints, userDate
                    FROM usersApp
                    ORDER BY id desc"
                    UpdateCommand="UPDATE [usersApp] SET isActive = @isActive, balance=@balance, l_userLevelId=@l_userLevelId, userPoints=@userPoints">
                    <UpdateParameters>
                        <asp:Parameter Name="isActive" Type="String" />
                        <asp:Parameter Name="balance" Type="String" />
                        <asp:Parameter Name="l_userLevelId" Type="String" />
                        <asp:Parameter Name="userPoints" Type="Int32" />
                    </UpdateParameters>
                </asp:SqlDataSource>

                <asp:SqlDataSource ID="DB_UserLevel" runat="server" ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>" SelectCommand="SELECT * FROM L_UserLevel"></asp:SqlDataSource>

            </div>

        </main>

    

</asp:Content>
