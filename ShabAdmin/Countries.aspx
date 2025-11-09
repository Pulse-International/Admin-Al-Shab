<%@ Page Title="Branches" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Countries.aspx.cs" Inherits="ShabAdmin.Countries" %>

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

            <div class="w-100 text-center my-4">
                <h2 class="pageTitle d-inline-block" style="font-family: Cairo">الــــدول</h2>
            </div>

            <div class="navbar-main navbar-expand-lg px-0 mx-4 border-radius-xl bg-white shadow mt-3 mb-1">

                <dx:ASPxGridView ID="GridCountries" runat="server" DataSourceID="db_Countries" KeyFieldName="id" ClientInstanceName="GridCountries" Width="100%" AutoGenerateColumns="False" EnablePagingCallbackAnimation="True" Font-Names="cairo" Font-Size="1em" RightToLeft="True" OnBeforePerformDataSelect="GridCountries_BeforePerformDataSelect">
                    <Settings ShowFooter="True" ShowFilterRow="True" />


                    <ClientSideEvents RowClick="function(s, e) {OnRowClick(e);}" RowDblClick="function(s, e) {setTimeout(function(){GridCountries.StartEditRow(MyIndex);},100);}" />
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

                        <dx:GridViewDataTextColumn Caption="الدولة" FieldName="countryName">
                            <PropertiesTextEdit>
                                <ValidationSettings RequiredField-IsRequired="true" SetFocusOnError="True" ErrorText="حقل مطلوب" Display="Dynamic">
                                    <RequiredField IsRequired="True"></RequiredField>
                                </ValidationSettings>
                            </PropertiesTextEdit>
                            <CellStyle VerticalAlign="Middle" HorizontalAlign="Center">
                            </CellStyle>
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataTextColumn Caption="" ShowInCustomizationForm="True" Width="100px">
                            <EditFormSettings Visible="False" />
                            <DataItemTemplate>
                                <div style="width: 100%; float: left; text-align: center">
                                    <img src="/assets/img/update.png" width="32" height="32" title="تعديل" style="cursor: pointer" onclick="setTimeout(function(){GridCountries.StartEditRow(MyIndex);},100);" />
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
                    ID="db_Countries"
                    runat="server"
                    ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>"
                    SelectCommand="SELECT [id], [countryName] FROM [countries] where [id] != 1000" 
                    InsertCommand="INSERT INTO [countries] ([countryName], [userDate]) VALUES (@countryName, getdate());"
                    UpdateCommand="UPDATE [countries]
                    SET [countryName]        = @countryName                        
                    WHERE [id] = @id;"
                    DeleteCommand="DELETE FROM [branches] WHERE [id] = @id;">
                    <InsertParameters>
                        <asp:Parameter Name="countryName" Type="String" />
                    </InsertParameters>
                    <UpdateParameters>
                        <asp:Parameter Name="countryName" Type="String" />
                    </UpdateParameters>
                    <DeleteParameters>
                        <asp:Parameter Name="id" Type="Int32" />
                    </DeleteParameters>
                </asp:SqlDataSource>
            </div>

        </main>
    

</asp:Content>
