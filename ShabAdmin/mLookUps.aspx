<%@ Page Title="Points" Language="C#" MasterPageFile="~/mSite.Master" AutoEventWireup="true" CodeBehind="mLookUps.aspx.cs" Inherits="ShabAdmin.mLookUps" %>

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

                var deleteGridName = null;
                var deleteRowKey = null;

                function showDeletePopup(gridName, rowKey) {
                    deleteGridName = gridName;
                    deleteRowKey = rowKey;
                    Pop_DeleteConfirm.Show();
                }

                function executeDeleteConfirmed() {
                    if (deleteGridName && deleteRowKey) {
                        var grid = ASPxClientControl.GetControlCollection().GetByName(deleteGridName);
                        if (grid) {
                            grid.DeleteRowByKey(deleteRowKey);
                        }
                    }
                    Pop_DeleteConfirm.Hide();
                }
                function onUpdateClickGeneric(gridName, rowKey) {
                    var grid = ASPxClientControl.GetControlCollection().GetByName(gridName);
                    if (grid) {
                        grid.StartEditRowByKey(rowKey);
                    } else {
                        alert("Grid غير موجود: " + gridName);
                    }
                }
            </script>

            <div class="w-100 text-center my-4">
                <h2 class="pageTitle d-inline-block" style="font-family: Cairo">البيانات الاساسية</h2>
            </div>

            <dx:ASPxPageControl ID="pageTab" runat="server" CssClass="divSTARProviders" ActiveTabIndex="0" ClientInstanceName="pageTab" Theme="Material" Width="100%" EnableCallbackAnimation="True" >
                <TabPages>
                    <dx:TabPage Text="نوع العنوان" TabStyle-Font-Bold="true" TabStyle-Font-Names="cairo" TabStyle-Font-Size="Medium">
                        <TabStyle Font-Bold="True" Font-Names="cairo" Font-Size="x-large"></TabStyle>
                        <ContentCollection>
                            <dx:ContentControl>

                                <div class="navbar-main navbar-expand-lg px-0 mx-4 border-radius-xl bg-white shadow mt-3 mb-1">

                                    <div style="margin: 0 auto; width: 100%;">
                                        <div class="content-div">
                                            <dx:ASPxGridView ID="Grid_l_AdreesType" runat="server" DataSourceID="db_L_AddressType" KeyFieldName="id"
                                                ClientInstanceName="Grid_l_AdreesType" Width="100%" AutoGenerateColumns="False"
                                                EnablePagingCallbackAnimation="True" Font-Names="cairo" Font-Size="1em" RightToLeft="True">
                                                <%--<ClientSideEvents RowClick="function(s,e){ OnRowClick(e); }" />--%>
                                                <SettingsAdaptivity AdaptivityMode="HideDataCells"></SettingsAdaptivity>
                                                <Settings ShowFooter="True" />
                                                <SettingsCommandButton>
                                                    <NewButton Text="جديد"></NewButton>
                                                    <UpdateButton Text=" حفظ ">
                                                        <Image Url="~/assets/img/save.png" SpriteProperties-Left="50">
                                                            <SpriteProperties Left="50px"></SpriteProperties>
                                                        </Image>
                                                    </UpdateButton>
                                                    <CancelButton Text=" الغاء ">
                                                        <Image Url="~/assets/img/cancel.png"></Image>
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
                                                        <CellStyle VerticalAlign="Middle" HorizontalAlign="Center"></CellStyle>
                                                    </dx:GridViewDataColumn>

                                                    <dx:GridViewDataColumn Caption="الوصف" FieldName="description">
                                                        <EditFormSettings />
                                                        <CellStyle VerticalAlign="Middle" HorizontalAlign="Center"></CellStyle>
                                                    </dx:GridViewDataColumn>

                                                    <dx:GridViewDataTextColumn Caption="" Width="100px">
                                                        <DataItemTemplate>
                                                            <div style="text-align: center">
                                                                <img src="/assets/img/update.png" width="32" height="32" title="تعديل"
                                                                    style="cursor: pointer"
                                                                    onclick="onUpdateClickGeneric('Grid_l_AdreesType','<%# Container.KeyValue %>');" />

                                                                <img src="/assets/img/delete.png" width="32" height="32" title="حذف"
                                                                    style="cursor: pointer"
                                                                    onclick="showDeletePopup('Grid_l_AdreesType','<%# Container.KeyValue %>');" />
                                                            </div>
                                                        </DataItemTemplate>
                                                        <EditFormSettings Visible="False" />
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
                                                    <AlternatingRow BackColor="#F0F0F0"></AlternatingRow>
                                                    <Footer Font-Names="cairo"></Footer>
                                                </Styles>
                                                <Paddings Padding="2em" />
                                            </dx:ASPxGridView>
                                        </div>
                                    </div>

                                    <asp:SqlDataSource
                                        ID="db_L_AddressType"
                                        runat="server"
                                        ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>"
                                        CancelSelectOnNullParameter="false"
                                        SelectCommand="
                                            SELECT 
                                                id,
                                                description
                                            FROM L_AddressType"
                                        InsertCommand="
                                            INSERT INTO L_AddressType (description)
                                            VALUES (@description)"
                                        UpdateCommand="
                                            UPDATE L_AddressType
                                            SET description = @description
                                            WHERE id = @id"
                                        DeleteCommand="
                                            DELETE FROM L_AddressType
                                            WHERE id = @id">

                                        <InsertParameters>
                                            <asp:Parameter Name="description" Type="String" />
                                        </InsertParameters>

                                        <UpdateParameters>
                                            <asp:Parameter Name="description" Type="String" />
                                            <asp:Parameter Name="id" Type="Int32" />
                                        </UpdateParameters>

                                        <DeleteParameters>
                                            <asp:Parameter Name="id" Type="Int32" />
                                        </DeleteParameters>
                                    </asp:SqlDataSource>

                                </div>

                            </dx:ContentControl>
                        </ContentCollection>
                    </dx:TabPage>

                    <dx:TabPage Text="حالة الشركة" TabStyle-Font-Bold="true" TabStyle-Font-Names="cairo" TabStyle-Font-Size="Medium">
                        <TabStyle Font-Bold="True" Font-Names="cairo" Font-Size="x-large"></TabStyle>
                        <ContentCollection>
                            <dx:ContentControl>

                                <div class="navbar-main navbar-expand-lg px-0 mx-4 border-radius-xl bg-white shadow mt-3 mb-1">

                                    <div style="margin: 0 auto; width: 100%;">
                                        <div class="content-div">
                                            <dx:ASPxGridView ID="Grid_L_CompanyStatus" runat="server" DataSourceID="db_L_CompanyStatus" KeyFieldName="id"
                                                ClientInstanceName="Grid_L_CompanyStatus" Width="100%" AutoGenerateColumns="False"
                                                EnablePagingCallbackAnimation="True" Font-Names="cairo" Font-Size="1em" RightToLeft="True">
                                                <%--<ClientSideEvents RowClick="function(s,e){ OnRowClick(e); }" />--%>
                                                <SettingsAdaptivity AdaptivityMode="HideDataCells"></SettingsAdaptivity>
                                                <Settings ShowFooter="True" />
                                                <SettingsCommandButton>
                                                    <NewButton Text="جديد"></NewButton>
                                                    <UpdateButton Text=" حفظ ">
                                                        <Image Url="~/assets/img/save.png" SpriteProperties-Left="50">
                                                            <SpriteProperties Left="50px"></SpriteProperties>
                                                        </Image>
                                                    </UpdateButton>
                                                    <CancelButton Text=" الغاء ">
                                                        <Image Url="~/assets/img/cancel.png"></Image>
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
                                                        <CellStyle VerticalAlign="Middle" HorizontalAlign="Center"></CellStyle>
                                                    </dx:GridViewDataColumn>

                                                    <dx:GridViewDataColumn Caption="الوصف" FieldName="description">
                                                        <EditFormSettings />
                                                        <CellStyle VerticalAlign="Middle" HorizontalAlign="Center"></CellStyle>
                                                    </dx:GridViewDataColumn>

                                                    <dx:GridViewDataTextColumn Caption="" Width="100px">
                                                        <DataItemTemplate>
                                                            <div style="text-align: center">
                                                                <img src="/assets/img/update.png" width="32" height="32" title="تعديل"
                                                                    style="cursor: pointer"
                                                                    onclick="onUpdateClickGeneric('Grid_L_CompanyStatus','<%# Container.KeyValue %>');" />

                                                                <img src="/assets/img/delete.png" width="32" height="32" title="حذف"
                                                                    style="cursor: pointer"
                                                                    onclick="showDeletePopup('Grid_L_CompanyStatus','<%# Container.KeyValue %>');" />
                                                            </div>
                                                        </DataItemTemplate>
                                                        <EditFormSettings Visible="False" />
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
                                                    <AlternatingRow BackColor="#F0F0F0"></AlternatingRow>
                                                    <Footer Font-Names="cairo"></Footer>
                                                </Styles>
                                                <Paddings Padding="2em" />
                                            </dx:ASPxGridView>
                                        </div>
                                    </div>

                                    <asp:SqlDataSource
                                        ID="db_L_CompanyStatus"
                                        runat="server"
                                        ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>"
                                        CancelSelectOnNullParameter="false"
                                        SelectCommand="
                        SELECT 
                            id,
                            description
                        FROM L_CompanyStatus"
                                        InsertCommand="
                        INSERT INTO L_CompanyStatus (description)
                        VALUES (@description)"
                                        UpdateCommand="
                        UPDATE L_CompanyStatus
                        SET description = @description
                        WHERE id = @id"
                                        DeleteCommand="
                        DELETE FROM L_CompanyStatus
                        WHERE id = @id">

                                        <InsertParameters>
                                            <asp:Parameter Name="description" Type="String" />
                                        </InsertParameters>

                                        <UpdateParameters>
                                            <asp:Parameter Name="description" Type="String" />
                                            <asp:Parameter Name="id" Type="Int32" />
                                        </UpdateParameters>

                                        <DeleteParameters>
                                            <asp:Parameter Name="id" Type="Int32" />
                                        </DeleteParameters>
                                    </asp:SqlDataSource>

                                </div>

                            </dx:ContentControl>
                        </ContentCollection>
                    </dx:TabPage>

                    <dx:TabPage Text="نوع القسيمة" TabStyle-Font-Bold="true" TabStyle-Font-Names="cairo" TabStyle-Font-Size="Medium">
                        <TabStyle Font-Bold="True" Font-Names="cairo" Font-Size="x-large"></TabStyle>
                        <ContentCollection>
                            <dx:ContentControl>

                                <div class="navbar-main navbar-expand-lg px-0 mx-4 border-radius-xl bg-white shadow mt-3 mb-1">

                                    <div style="margin: 0 auto; width: 100%;">
                                        <div class="content-div">
                                            <dx:ASPxGridView ID="Grid_L_CouponType" runat="server" DataSourceID="db_L_CouponType" KeyFieldName="id"
                                                ClientInstanceName="Grid_L_CouponType" Width="100%" AutoGenerateColumns="False"
                                                EnablePagingCallbackAnimation="True" Font-Names="cairo" Font-Size="1em" RightToLeft="True">
                                                <%--<ClientSideEvents RowClick="function(s,e){ OnRowClick(e); }" />--%>
                                                <SettingsAdaptivity AdaptivityMode="HideDataCells"></SettingsAdaptivity>
                                                <Settings ShowFooter="True" />
                                                <SettingsCommandButton>
                                                    <NewButton Text="جديد"></NewButton>
                                                    <UpdateButton Text=" حفظ ">
                                                        <Image Url="~/assets/img/save.png" SpriteProperties-Left="50">
                                                            <SpriteProperties Left="50px"></SpriteProperties>
                                                        </Image>
                                                    </UpdateButton>
                                                    <CancelButton Text=" الغاء ">
                                                        <Image Url="~/assets/img/cancel.png"></Image>
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
                                                        <CellStyle VerticalAlign="Middle" HorizontalAlign="Center"></CellStyle>
                                                    </dx:GridViewDataColumn>

                                                    <dx:GridViewDataColumn Caption="الوصف" FieldName="description">
                                                        <EditFormSettings />
                                                        <CellStyle VerticalAlign="Middle" HorizontalAlign="Center"></CellStyle>
                                                    </dx:GridViewDataColumn>

                                                    <dx:GridViewDataTextColumn Caption="" Width="100px">
                                                        <DataItemTemplate>
                                                            <div style="text-align: center">
                                                                <img src="/assets/img/update.png" width="32" height="32" title="تعديل"
                                                                    style="cursor: pointer"
                                                                    onclick="onUpdateClickGeneric('Grid_L_CouponType','<%# Container.KeyValue %>');" />

                                                                <img src="/assets/img/delete.png" width="32" height="32" title="حذف"
                                                                    style="cursor: pointer"
                                                                    onclick="showDeletePopup('Grid_L_CouponType','<%# Container.KeyValue %>');" />
                                                            </div>
                                                        </DataItemTemplate>
                                                        <EditFormSettings Visible="False" />
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
                                                    <AlternatingRow BackColor="#F0F0F0"></AlternatingRow>
                                                    <Footer Font-Names="cairo"></Footer>
                                                </Styles>
                                                <Paddings Padding="2em" />
                                            </dx:ASPxGridView>
                                        </div>
                                    </div>

                                    <asp:SqlDataSource
                                        ID="db_L_CouponType"
                                        runat="server"
                                        ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>"
                                        CancelSelectOnNullParameter="false"
                                        SelectCommand="
                        SELECT 
                            id,
                            description
                        FROM L_CouponType"
                                        InsertCommand="
                        INSERT INTO L_CouponType (description)
                        VALUES (@description)"
                                        UpdateCommand="
                        UPDATE L_CouponType
                        SET description = @description
                        WHERE id = @id"
                                        DeleteCommand="
                        DELETE FROM L_CouponType
                        WHERE id = @id">

                                        <InsertParameters>
                                            <asp:Parameter Name="description" Type="String" />
                                        </InsertParameters>

                                        <UpdateParameters>
                                            <asp:Parameter Name="description" Type="String" />
                                            <asp:Parameter Name="id" Type="Int32" />
                                        </UpdateParameters>

                                        <DeleteParameters>
                                            <asp:Parameter Name="id" Type="Int32" />
                                        </DeleteParameters>
                                    </asp:SqlDataSource>

                                </div>

                            </dx:ContentControl>
                        </ContentCollection>
                    </dx:TabPage>

                    <dx:TabPage Text="نوع البطاقة" TabStyle-Font-Bold="true" TabStyle-Font-Names="cairo" TabStyle-Font-Size="Medium">
                        <TabStyle Font-Bold="True" Font-Names="cairo" Font-Size="x-large"></TabStyle>
                        <ContentCollection>
                            <dx:ContentControl>

                                <div class="navbar-main navbar-expand-lg px-0 mx-4 border-radius-xl bg-white shadow mt-3 mb-1">

                                    <div style="margin: 0 auto; width: 100%;">
                                        <div class="content-div">
                                            <dx:ASPxGridView ID="Grid_L_CreditType" runat="server" DataSourceID="db_L_CreditType" KeyFieldName="id"
                                                ClientInstanceName="Grid_L_CouponType" Width="100%" AutoGenerateColumns="False"
                                                EnablePagingCallbackAnimation="True" Font-Names="cairo" Font-Size="1em" RightToLeft="True">
                                                <%--<ClientSideEvents RowClick="function(s,e){ OnRowClick(e); }" />--%>
                                                <SettingsAdaptivity AdaptivityMode="HideDataCells"></SettingsAdaptivity>
                                                <Settings ShowFooter="True" />
                                                <SettingsCommandButton>
                                                    <NewButton Text="جديد"></NewButton>
                                                    <UpdateButton Text=" حفظ ">
                                                        <Image Url="~/assets/img/save.png" SpriteProperties-Left="50">
                                                            <SpriteProperties Left="50px"></SpriteProperties>
                                                        </Image>
                                                    </UpdateButton>
                                                    <CancelButton Text=" الغاء ">
                                                        <Image Url="~/assets/img/cancel.png"></Image>
                                                    </CancelButton>
                                                </SettingsCommandButton>
                                                <SettingsPopup>
                                                    <FilterControl AutoUpdatePosition="False"></FilterControl>
                                                </SettingsPopup>
                                                <SettingsSearchPanel CustomEditorID="tbToolbarSearch4" />
                                                <SettingsExport EnableClientSideExportAPI="true" ExcelExportMode="WYSIWYG" PaperKind="A4" RightToLeft="True" />
                                                <SettingsLoadingPanel Text="Please Wait &amp;hellip;" Mode="ShowAsPopup" />
                                                <SettingsText SearchPanelEditorNullText="ابحث في الجدول..." EmptyDataRow="لا يوجد" />

                                                <Columns>

                                                    <dx:GridViewDataColumn Caption="الرقم" FieldName="id">
                                                        <EditFormSettings Visible="False" />
                                                        <CellStyle VerticalAlign="Middle" HorizontalAlign="Center"></CellStyle>
                                                    </dx:GridViewDataColumn>

                                                    <dx:GridViewDataColumn Caption="الوصف" FieldName="description">
                                                        <EditFormSettings />
                                                        <CellStyle VerticalAlign="Middle" HorizontalAlign="Center"></CellStyle>
                                                    </dx:GridViewDataColumn>

                                                    <dx:GridViewDataTextColumn Caption="" Width="100px">
                                                        <DataItemTemplate>
                                                            <div style="text-align: center">
                                                                <img src="/assets/img/update.png" width="32" height="32" title="تعديل"
                                                                    style="cursor: pointer"
                                                                    onclick="onUpdateClickGeneric('Grid_L_CouponType','<%# Container.KeyValue %>');" />

                                                                <img src="/assets/img/delete.png" width="32" height="32" title="حذف"
                                                                    style="cursor: pointer"
                                                                    onclick="showDeletePopup('Grid_L_CouponType','<%# Container.KeyValue %>');" />
                                                            </div>
                                                        </DataItemTemplate>
                                                        <EditFormSettings Visible="False" />
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
                                                                    <dx:ASPxButtonEdit ID="tbToolbarSearch4" runat="server" NullText="البحث..." Width="140" Font-Names="cairo" />
                                                                </Template>
                                                            </dx:GridViewToolbarItem>
                                                        </Items>
                                                    </dx:GridViewToolbar>
                                                </Toolbars>

                                                <TotalSummary>
                                                    <dx:ASPxSummaryItem FieldName="id" SummaryType="Count" DisplayFormat="العدد = {0}" />
                                                </TotalSummary>

                                                <Styles>
                                                    <AlternatingRow BackColor="#F0F0F0"></AlternatingRow>
                                                    <Footer Font-Names="cairo"></Footer>
                                                </Styles>
                                                <Paddings Padding="2em" />
                                            </dx:ASPxGridView>
                                        </div>
                                    </div>

                                    <asp:SqlDataSource
                                        ID="db_L_CreditType"
                                        runat="server"
                                        ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>"
                                        CancelSelectOnNullParameter="false"
                                        SelectCommand="
                        SELECT 
                            id,
                            description
                        FROM L_CreditType"
                                        InsertCommand="
                        INSERT INTO L_CouponType (description)
                        VALUES (@description)"
                                        UpdateCommand="
                        UPDATE L_CreditType
                        SET description = @description
                        WHERE id = @id"
                                        DeleteCommand="
                        DELETE FROM L_CreditType
                        WHERE id = @id">

                                        <InsertParameters>
                                            <asp:Parameter Name="description" Type="String" />
                                        </InsertParameters>

                                        <UpdateParameters>
                                            <asp:Parameter Name="description" Type="String" />
                                            <asp:Parameter Name="id" Type="Int32" />
                                        </UpdateParameters>

                                        <DeleteParameters>
                                            <asp:Parameter Name="id" Type="Int32" />
                                        </DeleteParameters>
                                    </asp:SqlDataSource>

                                </div>

                            </dx:ContentControl>
                        </ContentCollection>
                    </dx:TabPage>

                    <dx:TabPage Text="نوع الخصم" TabStyle-Font-Bold="true" TabStyle-Font-Names="cairo" TabStyle-Font-Size="Medium">
                        <TabStyle Font-Bold="True" Font-Names="cairo" Font-Size="x-large"></TabStyle>
                        <ContentCollection>
                            <dx:ContentControl>

                                <div class="navbar-main navbar-expand-lg px-0 mx-4 border-radius-xl bg-white shadow mt-3 mb-1">

                                    <div style="margin: 0 auto; width: 100%;">
                                        <div class="content-div">
                                            <dx:ASPxGridView ID="Grid_L_DiscountType" runat="server" DataSourceID="db_L_DiscountType" KeyFieldName="id"
                                                ClientInstanceName="Grid_L_DiscountType" Width="100%" AutoGenerateColumns="False"
                                                EnablePagingCallbackAnimation="True" Font-Names="cairo" Font-Size="1em" RightToLeft="True">
                                                <%--<ClientSideEvents RowClick="function(s,e){ OnRowClick(e); }" />--%>
                                                <SettingsAdaptivity AdaptivityMode="HideDataCells"></SettingsAdaptivity>
                                                <Settings ShowFooter="True" />
                                                <SettingsCommandButton>
                                                    <NewButton Text="جديد"></NewButton>
                                                    <UpdateButton Text=" حفظ ">
                                                        <Image Url="~/assets/img/save.png" SpriteProperties-Left="50">
                                                            <SpriteProperties Left="50px"></SpriteProperties>
                                                        </Image>
                                                    </UpdateButton>
                                                    <CancelButton Text=" الغاء ">
                                                        <Image Url="~/assets/img/cancel.png"></Image>
                                                    </CancelButton>
                                                </SettingsCommandButton>
                                                <SettingsPopup>
                                                    <FilterControl AutoUpdatePosition="False"></FilterControl>
                                                </SettingsPopup>
                                                <SettingsSearchPanel CustomEditorID="tbToolbarSearch5" />
                                                <SettingsExport EnableClientSideExportAPI="true" ExcelExportMode="WYSIWYG" PaperKind="A4" RightToLeft="True" />
                                                <SettingsLoadingPanel Text="Please Wait &amp;hellip;" Mode="ShowAsPopup" />
                                                <SettingsText SearchPanelEditorNullText="ابحث في الجدول..." EmptyDataRow="لا يوجد" />

                                                <Columns>

                                                    <dx:GridViewDataColumn Caption="الرقم" FieldName="id">
                                                        <EditFormSettings Visible="False" />
                                                        <CellStyle VerticalAlign="Middle" HorizontalAlign="Center"></CellStyle>
                                                    </dx:GridViewDataColumn>

                                                    <dx:GridViewDataColumn Caption="الوصف" FieldName="description">
                                                        <EditFormSettings />
                                                        <CellStyle VerticalAlign="Middle" HorizontalAlign="Center"></CellStyle>
                                                    </dx:GridViewDataColumn>

                                                    <dx:GridViewDataTextColumn Caption="" Width="100px">
                                                        <DataItemTemplate>
                                                            <div style="text-align: center">
                                                                <img src="/assets/img/update.png" width="32" height="32" title="تعديل"
                                                                    style="cursor: pointer"
                                                                    onclick="onUpdateClickGeneric('Grid_L_DiscountType','<%# Container.KeyValue %>');" />

                                                                <img src="/assets/img/delete.png" width="32" height="32" title="حذف"
                                                                    style="cursor: pointer"
                                                                    onclick="showDeletePopup('Grid_L_DiscountType','<%# Container.KeyValue %>');" />
                                                            </div>
                                                        </DataItemTemplate>
                                                        <EditFormSettings Visible="False" />
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
                                                                    <dx:ASPxButtonEdit ID="tbToolbarSearch5" runat="server" NullText="البحث..." Width="140" Font-Names="cairo" />
                                                                </Template>
                                                            </dx:GridViewToolbarItem>
                                                        </Items>
                                                    </dx:GridViewToolbar>
                                                </Toolbars>

                                                <TotalSummary>
                                                    <dx:ASPxSummaryItem FieldName="id" SummaryType="Count" DisplayFormat="العدد = {0}" />
                                                </TotalSummary>

                                                <Styles>
                                                    <AlternatingRow BackColor="#F0F0F0"></AlternatingRow>
                                                    <Footer Font-Names="cairo"></Footer>
                                                </Styles>
                                                <Paddings Padding="2em" />
                                            </dx:ASPxGridView>
                                        </div>
                                    </div>

                                    <asp:SqlDataSource
                                        ID="db_L_DiscountType"
                                        runat="server"
                                        ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>"
                                        CancelSelectOnNullParameter="false"
                                        SelectCommand="
                        SELECT 
                            id,
                            description
                        FROM L_DiscountType"
                                        InsertCommand="
                        INSERT INTO L_DiscountType (description)
                        VALUES (@description)"
                                        UpdateCommand="
                        UPDATE L_DiscountType
                        SET description = @description
                        WHERE id = @id"
                                        DeleteCommand="
                        DELETE FROM L_DiscountType
                        WHERE id = @id">

                                        <InsertParameters>
                                            <asp:Parameter Name="description" Type="String" />
                                        </InsertParameters>

                                        <UpdateParameters>
                                            <asp:Parameter Name="description" Type="String" />
                                            <asp:Parameter Name="id" Type="Int32" />
                                        </UpdateParameters>

                                        <DeleteParameters>
                                            <asp:Parameter Name="id" Type="Int32" />
                                        </DeleteParameters>
                                    </asp:SqlDataSource>

                                </div>

                            </dx:ContentControl>
                        </ContentCollection>
                    </dx:TabPage>

                    <dx:TabPage Text="نوع الاعلان" TabStyle-Font-Bold="true" TabStyle-Font-Names="cairo" TabStyle-Font-Size="Medium">
                        <TabStyle Font-Bold="True" Font-Names="cairo" Font-Size="x-large"></TabStyle>
                        <ContentCollection>
                            <dx:ContentControl>

                                <div class="navbar-main navbar-expand-lg px-0 mx-4 border-radius-xl bg-white shadow mt-3 mb-1">

                                    <div style="margin: 0 auto; width: 100%;">
                                        <div class="content-div">
                                            <dx:ASPxGridView ID="Grid_L_Offers" runat="server" DataSourceID="db_L_Offers" KeyFieldName="id"
                                                ClientInstanceName="Grid_L_Offers" Width="100%" AutoGenerateColumns="False"
                                                EnablePagingCallbackAnimation="True" Font-Names="cairo" Font-Size="1em" RightToLeft="True">
                                                <%--<ClientSideEvents RowClick="function(s,e){ OnRowClick(e); }" />--%>
                                                <SettingsAdaptivity AdaptivityMode="HideDataCells"></SettingsAdaptivity>
                                                <Settings ShowFooter="True" />
                                                <SettingsCommandButton>
                                                    <NewButton Text="جديد"></NewButton>
                                                    <UpdateButton Text=" حفظ ">
                                                        <Image Url="~/assets/img/save.png" SpriteProperties-Left="50">
                                                            <SpriteProperties Left="50px"></SpriteProperties>
                                                        </Image>
                                                    </UpdateButton>
                                                    <CancelButton Text=" الغاء ">
                                                        <Image Url="~/assets/img/cancel.png"></Image>
                                                    </CancelButton>
                                                </SettingsCommandButton>
                                                <SettingsPopup>
                                                    <FilterControl AutoUpdatePosition="False"></FilterControl>
                                                </SettingsPopup>
                                                <SettingsSearchPanel CustomEditorID="tbToolbarSearch6" />
                                                <SettingsExport EnableClientSideExportAPI="true" ExcelExportMode="WYSIWYG" PaperKind="A4" RightToLeft="True" />
                                                <SettingsLoadingPanel Text="Please Wait &amp;hellip;" Mode="ShowAsPopup" />
                                                <SettingsText SearchPanelEditorNullText="ابحث في الجدول..." EmptyDataRow="لا يوجد" />

                                                <Columns>

                                                    <dx:GridViewDataColumn Caption="الرقم" FieldName="id">
                                                        <EditFormSettings Visible="False" />
                                                        <CellStyle VerticalAlign="Middle" HorizontalAlign="Center"></CellStyle>
                                                    </dx:GridViewDataColumn>

                                                    <dx:GridViewDataColumn Caption="الوصف" FieldName="description">
                                                        <EditFormSettings />
                                                        <CellStyle VerticalAlign="Middle" HorizontalAlign="Center"></CellStyle>
                                                    </dx:GridViewDataColumn>

                                                    <dx:GridViewDataTextColumn Caption="" Width="100px">
                                                        <DataItemTemplate>
                                                            <div style="text-align: center">
                                                                <img src="/assets/img/update.png" width="32" height="32" title="تعديل"
                                                                    style="cursor: pointer"
                                                                    onclick="onUpdateClickGeneric('Grid_L_Offers','<%# Container.KeyValue %>');" />

                                                                <img src="/assets/img/delete.png" width="32" height="32" title="حذف"
                                                                    style="cursor: pointer"
                                                                    onclick="showDeletePopup('Grid_L_Offers','<%# Container.KeyValue %>');" />
                                                            </div>
                                                        </DataItemTemplate>
                                                        <EditFormSettings Visible="False" />
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
                                                                    <dx:ASPxButtonEdit ID="tbToolbarSearch6" runat="server" NullText="البحث..." Width="140" Font-Names="cairo" />
                                                                </Template>
                                                            </dx:GridViewToolbarItem>
                                                        </Items>
                                                    </dx:GridViewToolbar>
                                                </Toolbars>

                                                <TotalSummary>
                                                    <dx:ASPxSummaryItem FieldName="id" SummaryType="Count" DisplayFormat="العدد = {0}" />
                                                </TotalSummary>

                                                <Styles>
                                                    <AlternatingRow BackColor="#F0F0F0"></AlternatingRow>
                                                    <Footer Font-Names="cairo"></Footer>
                                                </Styles>
                                                <Paddings Padding="2em" />
                                            </dx:ASPxGridView>
                                        </div>
                                    </div>

                                    <asp:SqlDataSource
                                        ID="db_L_Offers"
                                        runat="server"
                                        ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>"
                                        CancelSelectOnNullParameter="false"
                                        SelectCommand="
                        SELECT 
                            id,
                            description
                        FROM L_Offers"
                                        InsertCommand="
                        INSERT INTO L_Offers (description)
                        VALUES (@description)"
                                        UpdateCommand="
                        UPDATE L_Offers
                        SET description = @description
                        WHERE id = @id"
                                        DeleteCommand="
                        DELETE FROM L_Offers
                        WHERE id = @id">
                                        <InsertParameters>
                                            <asp:Parameter Name="description" Type="String" />
                                        </InsertParameters>

                                        <UpdateParameters>
                                            <asp:Parameter Name="description" Type="String" />
                                            <asp:Parameter Name="id" Type="Int32" />
                                        </UpdateParameters>

                                        <DeleteParameters>
                                            <asp:Parameter Name="id" Type="Int32" />
                                        </DeleteParameters>
                                    </asp:SqlDataSource>

                                </div>

                            </dx:ContentControl>
                        </ContentCollection>
                    </dx:TabPage>

                    <dx:TabPage Text="مكان الاعلان" TabStyle-Font-Bold="true" TabStyle-Font-Names="cairo" TabStyle-Font-Size="Medium">
                        <TabStyle Font-Bold="True" Font-Names="cairo" Font-Size="x-large"></TabStyle>
                        <ContentCollection>
                            <dx:ContentControl>

                                <div class="navbar-main navbar-expand-lg px-0 mx-4 border-radius-xl bg-white shadow mt-3 mb-1">

                                    <div style="margin: 0 auto; width: 100%;">
                                        <div class="content-div">
                                            <dx:ASPxGridView ID="Grid_L_OffersType" runat="server" DataSourceID="db_L_OffersType" KeyFieldName="id"
                                                ClientInstanceName="Grid_L_OffersType" Width="100%" AutoGenerateColumns="False"
                                                EnablePagingCallbackAnimation="True" Font-Names="cairo" Font-Size="1em" RightToLeft="True">
                                                <%--<ClientSideEvents RowClick="function(s,e){ OnRowClick(e); }" />--%>
                                                <SettingsAdaptivity AdaptivityMode="HideDataCells"></SettingsAdaptivity>
                                                <Settings ShowFooter="True" />
                                                <SettingsCommandButton>
                                                    <NewButton Text="جديد"></NewButton>
                                                    <UpdateButton Text=" حفظ ">
                                                        <Image Url="~/assets/img/save.png" SpriteProperties-Left="50">
                                                            <SpriteProperties Left="50px"></SpriteProperties>
                                                        </Image>
                                                    </UpdateButton>
                                                    <CancelButton Text=" الغاء ">
                                                        <Image Url="~/assets/img/cancel.png"></Image>
                                                    </CancelButton>
                                                </SettingsCommandButton>
                                                <SettingsPopup>
                                                    <FilterControl AutoUpdatePosition="False"></FilterControl>
                                                </SettingsPopup>
                                                <SettingsSearchPanel CustomEditorID="tbToolbarSearch7" />
                                                <SettingsExport EnableClientSideExportAPI="true" ExcelExportMode="WYSIWYG" PaperKind="A4" RightToLeft="True" />
                                                <SettingsLoadingPanel Text="Please Wait &amp;hellip;" Mode="ShowAsPopup" />
                                                <SettingsText SearchPanelEditorNullText="ابحث في الجدول..." EmptyDataRow="لا يوجد" />

                                                <Columns>

                                                    <dx:GridViewDataColumn Caption="الرقم" FieldName="id">
                                                        <EditFormSettings Visible="False" />
                                                        <CellStyle VerticalAlign="Middle" HorizontalAlign="Center"></CellStyle>
                                                    </dx:GridViewDataColumn>

                                                    <dx:GridViewDataColumn Caption="الوصف" FieldName="description">
                                                        <EditFormSettings />
                                                        <CellStyle VerticalAlign="Middle" HorizontalAlign="Center"></CellStyle>
                                                    </dx:GridViewDataColumn>

                                                    <dx:GridViewDataTextColumn Caption="" Width="100px">
                                                        <DataItemTemplate>
                                                            <div style="text-align: center">
                                                                <img src="/assets/img/update.png" width="32" height="32" title="تعديل"
                                                                    style="cursor: pointer"
                                                                    onclick="onUpdateClickGeneric('Grid_L_OffersType','<%# Container.KeyValue %>');" />

                                                                <img src="/assets/img/delete.png" width="32" height="32" title="حذف"
                                                                    style="cursor: pointer"
                                                                    onclick="showDeletePopup('Grid_L_OffersType','<%# Container.KeyValue %>');" />
                                                            </div>
                                                        </DataItemTemplate>
                                                        <EditFormSettings Visible="False" />
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
                                                                    <dx:ASPxButtonEdit ID="tbToolbarSearch7" runat="server" NullText="البحث..." Width="140" Font-Names="cairo" />
                                                                </Template>
                                                            </dx:GridViewToolbarItem>
                                                        </Items>
                                                    </dx:GridViewToolbar>
                                                </Toolbars>

                                                <TotalSummary>
                                                    <dx:ASPxSummaryItem FieldName="id" SummaryType="Count" DisplayFormat="العدد = {0}" />
                                                </TotalSummary>

                                                <Styles>
                                                    <AlternatingRow BackColor="#F0F0F0"></AlternatingRow>
                                                    <Footer Font-Names="cairo"></Footer>
                                                </Styles>
                                                <Paddings Padding="2em" />
                                            </dx:ASPxGridView>
                                        </div>
                                    </div>

                                    <asp:SqlDataSource
                                        ID="db_L_OffersType"
                                        runat="server"
                                        ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>"
                                        CancelSelectOnNullParameter="false"
                                        SelectCommand="
                        SELECT 
                            id,
                            description
                        FROM L_OffersType"
                                        InsertCommand="
                        INSERT INTO L_OffersType (description)
                        VALUES (@description)"
                                        UpdateCommand="
                        UPDATE L_OffersType
                        SET description = @description
                        WHERE id = @id"
                                        DeleteCommand="
                        DELETE FROM L_OffersType
                        WHERE id = @id">
                                        <InsertParameters>
                                            <asp:Parameter Name="description" Type="String" />
                                        </InsertParameters>

                                        <UpdateParameters>
                                            <asp:Parameter Name="description" Type="String" />
                                            <asp:Parameter Name="id" Type="Int32" />
                                        </UpdateParameters>

                                        <DeleteParameters>
                                            <asp:Parameter Name="id" Type="Int32" />
                                        </DeleteParameters>
                                    </asp:SqlDataSource>

                                </div>

                            </dx:ContentControl>
                        </ContentCollection>
                    </dx:TabPage>

                    <dx:TabPage Text="حالة الطلب" TabStyle-Font-Bold="true" TabStyle-Font-Names="cairo" TabStyle-Font-Size="Medium">
                        <TabStyle Font-Bold="True" Font-Names="cairo" Font-Size="x-large"></TabStyle>
                        <ContentCollection>
                            <dx:ContentControl>

                                <div class="navbar-main navbar-expand-lg px-0 mx-4 border-radius-xl bg-white shadow mt-3 mb-1">

                                    <div style="margin: 0 auto; width: 100%;">
                                        <div class="content-div">
                                            <dx:ASPxGridView ID="Grid_L_OrderStatus" runat="server" DataSourceID="db_L_OrderStatus" KeyFieldName="id"
                                                ClientInstanceName="Grid_L_OrderStatus" Width="100%" AutoGenerateColumns="False"
                                                EnablePagingCallbackAnimation="True" Font-Names="cairo" Font-Size="1em" RightToLeft="True">
                                                <%--<ClientSideEvents RowClick="function(s,e){ OnRowClick(e); }" />--%>
                                                <SettingsAdaptivity AdaptivityMode="HideDataCells"></SettingsAdaptivity>
                                                <Settings ShowFooter="True" />
                                                <SettingsCommandButton>
                                                    <NewButton Text="جديد"></NewButton>
                                                    <UpdateButton Text=" حفظ ">
                                                        <Image Url="~/assets/img/save.png" SpriteProperties-Left="50">
                                                            <SpriteProperties Left="50px"></SpriteProperties>
                                                        </Image>
                                                    </UpdateButton>
                                                    <CancelButton Text=" الغاء ">
                                                        <Image Url="~/assets/img/cancel.png"></Image>
                                                    </CancelButton>
                                                </SettingsCommandButton>
                                                <SettingsPopup>
                                                    <FilterControl AutoUpdatePosition="False"></FilterControl>
                                                </SettingsPopup>
                                                <SettingsSearchPanel CustomEditorID="tbToolbarSearch8" />
                                                <SettingsExport EnableClientSideExportAPI="true" ExcelExportMode="WYSIWYG" PaperKind="A4" RightToLeft="True" />
                                                <SettingsLoadingPanel Text="Please Wait &amp;hellip;" Mode="ShowAsPopup" />
                                                <SettingsText SearchPanelEditorNullText="ابحث في الجدول..." EmptyDataRow="لا يوجد" />

                                                <Columns>

                                                    <dx:GridViewDataColumn Caption="الرقم" FieldName="id">
                                                        <EditFormSettings Visible="False" />
                                                        <CellStyle VerticalAlign="Middle" HorizontalAlign="Center"></CellStyle>
                                                    </dx:GridViewDataColumn>

                                                    <dx:GridViewDataColumn Caption="الوصف" FieldName="description">
                                                        <EditFormSettings />
                                                        <CellStyle VerticalAlign="Middle" HorizontalAlign="Center"></CellStyle>
                                                    </dx:GridViewDataColumn>

                                                    <dx:GridViewDataTextColumn Caption="" Width="100px">
                                                        <DataItemTemplate>
                                                            <div style="text-align: center">
                                                                <img src="/assets/img/update.png" width="32" height="32" title="تعديل"
                                                                    style="cursor: pointer"
                                                                    onclick="onUpdateClickGeneric('Grid_L_OrderStatus','<%# Container.KeyValue %>');" />

                                                                <img src="/assets/img/delete.png" width="32" height="32" title="حذف"
                                                                    style="cursor: pointer"
                                                                    onclick="showDeletePopup('Grid_L_OrderStatus','<%# Container.KeyValue %>');" />
                                                            </div>
                                                        </DataItemTemplate>
                                                        <EditFormSettings Visible="False" />
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
                                                                    <dx:ASPxButtonEdit ID="tbToolbarSearch8" runat="server" NullText="البحث..." Width="140" Font-Names="cairo" />
                                                                </Template>
                                                            </dx:GridViewToolbarItem>
                                                        </Items>
                                                    </dx:GridViewToolbar>
                                                </Toolbars>

                                                <TotalSummary>
                                                    <dx:ASPxSummaryItem FieldName="id" SummaryType="Count" DisplayFormat="العدد = {0}" />
                                                </TotalSummary>

                                                <Styles>
                                                    <AlternatingRow BackColor="#F0F0F0"></AlternatingRow>
                                                    <Footer Font-Names="cairo"></Footer>
                                                </Styles>
                                                <Paddings Padding="2em" />
                                            </dx:ASPxGridView>
                                        </div>
                                    </div>

                                    <asp:SqlDataSource
                                        ID="db_L_OrderStatus"
                                        runat="server"
                                        ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>"
                                        CancelSelectOnNullParameter="false"
                                        SelectCommand="
                        SELECT 
                            id,
                            description
                        FROM L_OrderStatus"
                                        InsertCommand="
                        INSERT INTO L_OrderStatus (description)
                        VALUES (@description)"
                                        UpdateCommand="
                        UPDATE L_OrderStatus
                        SET description = @description
                        WHERE id = @id"
                                        DeleteCommand="
                        DELETE FROM L_OrderStatus
                        WHERE id = @id">
                                        <InsertParameters>
                                            <asp:Parameter Name="description" Type="String" />
                                        </InsertParameters>

                                        <UpdateParameters>
                                            <asp:Parameter Name="description" Type="String" />
                                            <asp:Parameter Name="id" Type="Int32" />
                                        </UpdateParameters>

                                        <DeleteParameters>
                                            <asp:Parameter Name="id" Type="Int32" />
                                        </DeleteParameters>
                                    </asp:SqlDataSource>

                                </div>

                            </dx:ContentControl>
                        </ContentCollection>
                    </dx:TabPage>

                    <dx:TabPage Text="نوع الدفع" TabStyle-Font-Bold="true" TabStyle-Font-Names="cairo" TabStyle-Font-Size="Medium">
                        <TabStyle Font-Bold="True" Font-Names="cairo" Font-Size="x-large"></TabStyle>
                        <ContentCollection>
                            <dx:ContentControl>

                                <div class="navbar-main navbar-expand-lg px-0 mx-4 border-radius-xl bg-white shadow mt-3 mb-1">

                                    <div style="margin: 0 auto; width: 100%;">
                                        <div class="content-div">
                                            <dx:ASPxGridView ID="Grid_L_PaymentMethod" runat="server" DataSourceID="db_L_PaymentMethod" KeyFieldName="id"
                                                ClientInstanceName="Grid_L_PaymentMethod" Width="100%" AutoGenerateColumns="False"
                                                EnablePagingCallbackAnimation="True" Font-Names="cairo" Font-Size="1em" RightToLeft="True">
                                                <%--<ClientSideEvents RowClick="function(s,e){ OnRowClick(e); }" />--%>
                                                <SettingsAdaptivity AdaptivityMode="HideDataCells"></SettingsAdaptivity>
                                                <Settings ShowFooter="True" />
                                                <SettingsCommandButton>
                                                    <NewButton Text="جديد"></NewButton>
                                                    <UpdateButton Text=" حفظ ">
                                                        <Image Url="~/assets/img/save.png" SpriteProperties-Left="50">
                                                            <SpriteProperties Left="50px"></SpriteProperties>
                                                        </Image>
                                                    </UpdateButton>
                                                    <CancelButton Text=" الغاء ">
                                                        <Image Url="~/assets/img/cancel.png"></Image>
                                                    </CancelButton>
                                                </SettingsCommandButton>
                                                <SettingsPopup>
                                                    <FilterControl AutoUpdatePosition="False"></FilterControl>
                                                </SettingsPopup>
                                                <SettingsSearchPanel CustomEditorID="tbToolbarSearch9" />
                                                <SettingsExport EnableClientSideExportAPI="true" ExcelExportMode="WYSIWYG" PaperKind="A4" RightToLeft="True" />
                                                <SettingsLoadingPanel Text="Please Wait &amp;hellip;" Mode="ShowAsPopup" />
                                                <SettingsText SearchPanelEditorNullText="ابحث في الجدول..." EmptyDataRow="لا يوجد" />

                                                <Columns>

                                                    <dx:GridViewDataColumn Caption="الرقم" FieldName="id">
                                                        <EditFormSettings Visible="False" />
                                                        <CellStyle VerticalAlign="Middle" HorizontalAlign="Center"></CellStyle>
                                                    </dx:GridViewDataColumn>

                                                    <dx:GridViewDataColumn Caption="الوصف" FieldName="description">
                                                        <EditFormSettings />
                                                        <CellStyle VerticalAlign="Middle" HorizontalAlign="Center"></CellStyle>
                                                    </dx:GridViewDataColumn>

                                                    <dx:GridViewDataTextColumn Caption="" Width="100px">
                                                        <DataItemTemplate>
                                                            <div style="text-align: center">
                                                                <img src="/assets/img/update.png" width="32" height="32" title="تعديل"
                                                                    style="cursor: pointer"
                                                                    onclick="onUpdateClickGeneric('Grid_L_PaymentMethod','<%# Container.KeyValue %>');" />

                                                                <img src="/assets/img/delete.png" width="32" height="32" title="حذف"
                                                                    style="cursor: pointer"
                                                                    onclick="showDeletePopup('Grid_L_PaymentMethod','<%# Container.KeyValue %>');" />
                                                            </div>
                                                        </DataItemTemplate>
                                                        <EditFormSettings Visible="False" />
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
                                                                    <dx:ASPxButtonEdit ID="tbToolbarSearch9" runat="server" NullText="البحث..." Width="140" Font-Names="cairo" />
                                                                </Template>
                                                            </dx:GridViewToolbarItem>
                                                        </Items>
                                                    </dx:GridViewToolbar>
                                                </Toolbars>

                                                <TotalSummary>
                                                    <dx:ASPxSummaryItem FieldName="id" SummaryType="Count" DisplayFormat="العدد = {0}" />
                                                </TotalSummary>

                                                <Styles>
                                                    <AlternatingRow BackColor="#F0F0F0"></AlternatingRow>
                                                    <Footer Font-Names="cairo"></Footer>
                                                </Styles>
                                                <Paddings Padding="2em" />
                                            </dx:ASPxGridView>
                                        </div>
                                    </div>

                                    <asp:SqlDataSource
                                        ID="db_L_PaymentMethod"
                                        runat="server"
                                        ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>"
                                        CancelSelectOnNullParameter="false"
                                        SelectCommand="
                        SELECT 
                            id,
                            description
                        FROM L_PaymentMethod"
                                        InsertCommand="
                        INSERT INTO L_PaymentMethod (description)
                        VALUES (@description)"
                                        UpdateCommand="
                        UPDATE L_PaymentMethod
                        SET description = @description
                        WHERE id = @id"
                                        DeleteCommand="
                        DELETE FROM L_PaymentMethod
                        WHERE id = @id">
                                        <InsertParameters>
                                            <asp:Parameter Name="description" Type="String" />
                                        </InsertParameters>

                                        <UpdateParameters>
                                            <asp:Parameter Name="description" Type="String" />
                                            <asp:Parameter Name="id" Type="Int32" />
                                        </UpdateParameters>

                                        <DeleteParameters>
                                            <asp:Parameter Name="id" Type="Int32" />
                                        </DeleteParameters>
                                    </asp:SqlDataSource>

                                </div>

                            </dx:ContentControl>
                        </ContentCollection>
                    </dx:TabPage>

                    <dx:TabPage Text="نوع المرتجعات" TabStyle-Font-Bold="true" TabStyle-Font-Names="cairo" TabStyle-Font-Size="Medium">
                        <TabStyle Font-Bold="True" Font-Names="cairo" Font-Size="x-large"></TabStyle>
                        <ContentCollection>
                            <dx:ContentControl>

                                <div class="navbar-main navbar-expand-lg px-0 mx-4 border-radius-xl bg-white shadow mt-3 mb-1">

                                    <div style="margin: 0 auto; width: 100%;">
                                        <div class="content-div">
                                            <dx:ASPxGridView ID="Grid_L_RefundType" runat="server" DataSourceID="db_L_RefundType" KeyFieldName="id"
                                                ClientInstanceName="Grid_L_RefundType" Width="100%" AutoGenerateColumns="False"
                                                EnablePagingCallbackAnimation="True" Font-Names="cairo" Font-Size="1em" RightToLeft="True">
                                                <%--<ClientSideEvents RowClick="function(s,e){ OnRowClick(e); }" />--%>
                                                <SettingsAdaptivity AdaptivityMode="HideDataCells"></SettingsAdaptivity>
                                                <Settings ShowFooter="True" />
                                                <SettingsCommandButton>
                                                    <NewButton Text="جديد"></NewButton>
                                                    <UpdateButton Text=" حفظ ">
                                                        <Image Url="~/assets/img/save.png" SpriteProperties-Left="50">
                                                            <SpriteProperties Left="50px"></SpriteProperties>
                                                        </Image>
                                                    </UpdateButton>
                                                    <CancelButton Text=" الغاء ">
                                                        <Image Url="~/assets/img/cancel.png"></Image>
                                                    </CancelButton>
                                                </SettingsCommandButton>
                                                <SettingsPopup>
                                                    <FilterControl AutoUpdatePosition="False"></FilterControl>
                                                </SettingsPopup>
                                                <SettingsSearchPanel CustomEditorID="tbToolbarSearch10" />
                                                <SettingsExport EnableClientSideExportAPI="true" ExcelExportMode="WYSIWYG" PaperKind="A4" RightToLeft="True" />
                                                <SettingsLoadingPanel Text="Please Wait &amp;hellip;" Mode="ShowAsPopup" />
                                                <SettingsText SearchPanelEditorNullText="ابحث في الجدول..." EmptyDataRow="لا يوجد" />

                                                <Columns>

                                                    <dx:GridViewDataColumn Caption="الرقم" FieldName="id">
                                                        <EditFormSettings Visible="False" />
                                                        <CellStyle VerticalAlign="Middle" HorizontalAlign="Center"></CellStyle>
                                                    </dx:GridViewDataColumn>

                                                    <dx:GridViewDataColumn Caption="الوصف" FieldName="description">
                                                        <EditFormSettings />
                                                        <CellStyle VerticalAlign="Middle" HorizontalAlign="Center"></CellStyle>
                                                    </dx:GridViewDataColumn>

                                                    <dx:GridViewDataTextColumn Caption="" Width="100px">
                                                        <DataItemTemplate>
                                                            <div style="text-align: center">
                                                                <img src="/assets/img/update.png" width="32" height="32" title="تعديل"
                                                                    style="cursor: pointer"
                                                                    onclick="onUpdateClickGeneric('Grid_L_PaymentMethod','<%# Container.KeyValue %>');" />

                                                                <img src="/assets/img/delete.png" width="32" height="32" title="حذف"
                                                                    style="cursor: pointer"
                                                                    onclick="showDeletePopup('Grid_L_PaymentMethod','<%# Container.KeyValue %>');" />
                                                            </div>
                                                        </DataItemTemplate>
                                                        <EditFormSettings Visible="False" />
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
                                                                    <dx:ASPxButtonEdit ID="tbToolbarSearch10" runat="server" NullText="البحث..." Width="140" Font-Names="cairo" />
                                                                </Template>
                                                            </dx:GridViewToolbarItem>
                                                        </Items>
                                                    </dx:GridViewToolbar>
                                                </Toolbars>

                                                <TotalSummary>
                                                    <dx:ASPxSummaryItem FieldName="id" SummaryType="Count" DisplayFormat="العدد = {0}" />
                                                </TotalSummary>

                                                <Styles>
                                                    <AlternatingRow BackColor="#F0F0F0"></AlternatingRow>
                                                    <Footer Font-Names="cairo"></Footer>
                                                </Styles>
                                                <Paddings Padding="2em" />
                                            </dx:ASPxGridView>
                                        </div>
                                    </div>

                                    <asp:SqlDataSource
                                        ID="db_L_RefundType"
                                        runat="server"
                                        ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>"
                                        CancelSelectOnNullParameter="false"
                                        SelectCommand="
                        SELECT 
                            id,
                            description
                        FROM L_RefundType"
                                        InsertCommand="
                        INSERT INTO L_RefundType (description)
                        VALUES (@description)"
                                        UpdateCommand="
                        UPDATE L_RefundType
                        SET description = @description
                        WHERE id = @id"
                                        DeleteCommand="
                        DELETE FROM L_RefundType
                        WHERE id = @id">
                                        <InsertParameters>
                                            <asp:Parameter Name="description" Type="String" />
                                        </InsertParameters>

                                        <UpdateParameters>
                                            <asp:Parameter Name="description" Type="String" />
                                            <asp:Parameter Name="id" Type="Int32" />
                                        </UpdateParameters>

                                        <DeleteParameters>
                                            <asp:Parameter Name="id" Type="Int32" />
                                        </DeleteParameters>
                                    </asp:SqlDataSource>

                                </div>

                            </dx:ContentControl>
                        </ContentCollection>
                    </dx:TabPage>

                    <dx:TabPage Text="حالة المستخدم" TabStyle-Font-Bold="true" TabStyle-Font-Names="cairo" TabStyle-Font-Size="Medium">
                        <TabStyle Font-Bold="True" Font-Names="cairo" Font-Size="x-large"></TabStyle>
                        <ContentCollection>
                            <dx:ContentControl>

                                <div class="navbar-main navbar-expand-lg px-0 mx-4 border-radius-xl bg-white shadow mt-3 mb-1">

                                    <div style="margin: 0 auto; width: 100%;">
                                        <div class="content-div">
                                            <dx:ASPxGridView ID="Grid_L_Status" runat="server" DataSourceID="db_L_Status" KeyFieldName="id"
                                                ClientInstanceName="Grid_L_Status" Width="100%" AutoGenerateColumns="False"
                                                EnablePagingCallbackAnimation="True" Font-Names="cairo" Font-Size="1em" RightToLeft="True">
                                                <%--<ClientSideEvents RowClick="function(s,e){ OnRowClick(e); }" />--%>
                                                <SettingsAdaptivity AdaptivityMode="HideDataCells"></SettingsAdaptivity>
                                                <Settings ShowFooter="True" />
                                                <SettingsCommandButton>
                                                    <NewButton Text="جديد"></NewButton>
                                                    <UpdateButton Text=" حفظ ">
                                                        <Image Url="~/assets/img/save.png" SpriteProperties-Left="50">
                                                            <SpriteProperties Left="50px"></SpriteProperties>
                                                        </Image>
                                                    </UpdateButton>
                                                    <CancelButton Text=" الغاء ">
                                                        <Image Url="~/assets/img/cancel.png"></Image>
                                                    </CancelButton>
                                                </SettingsCommandButton>
                                                <SettingsPopup>
                                                    <FilterControl AutoUpdatePosition="False"></FilterControl>
                                                </SettingsPopup>
                                                <SettingsSearchPanel CustomEditorID="tbToolbarSearch11" />
                                                <SettingsExport EnableClientSideExportAPI="true" ExcelExportMode="WYSIWYG" PaperKind="A4" RightToLeft="True" />
                                                <SettingsLoadingPanel Text="Please Wait &amp;hellip;" Mode="ShowAsPopup" />
                                                <SettingsText SearchPanelEditorNullText="ابحث في الجدول..." EmptyDataRow="لا يوجد" />

                                                <Columns>

                                                    <dx:GridViewDataColumn Caption="الرقم" FieldName="id">
                                                        <EditFormSettings Visible="False" />
                                                        <CellStyle VerticalAlign="Middle" HorizontalAlign="Center"></CellStyle>
                                                    </dx:GridViewDataColumn>

                                                    <dx:GridViewDataColumn Caption="الوصف" FieldName="description">
                                                        <EditFormSettings />
                                                        <CellStyle VerticalAlign="Middle" HorizontalAlign="Center"></CellStyle>
                                                    </dx:GridViewDataColumn>

                                                    <dx:GridViewDataTextColumn Caption="" Width="100px">
                                                        <DataItemTemplate>
                                                            <div style="text-align: center">
                                                                <img src="/assets/img/update.png" width="32" height="32" title="تعديل"
                                                                    style="cursor: pointer"
                                                                    onclick="onUpdateClickGeneric('Grid_L_Status','<%# Container.KeyValue %>');" />

                                                                <img src="/assets/img/delete.png" width="32" height="32" title="حذف"
                                                                    style="cursor: pointer"
                                                                    onclick="showDeletePopup('Grid_L_Status','<%# Container.KeyValue %>');" />
                                                            </div>
                                                        </DataItemTemplate>
                                                        <EditFormSettings Visible="False" />
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
                                                                    <dx:ASPxButtonEdit ID="tbToolbarSearch11" runat="server" NullText="البحث..." Width="140" Font-Names="cairo" />
                                                                </Template>
                                                            </dx:GridViewToolbarItem>
                                                        </Items>
                                                    </dx:GridViewToolbar>
                                                </Toolbars>

                                                <TotalSummary>
                                                    <dx:ASPxSummaryItem FieldName="id" SummaryType="Count" DisplayFormat="العدد = {0}" />
                                                </TotalSummary>

                                                <Styles>
                                                    <AlternatingRow BackColor="#F0F0F0"></AlternatingRow>
                                                    <Footer Font-Names="cairo"></Footer>
                                                </Styles>
                                                <Paddings Padding="2em" />
                                            </dx:ASPxGridView>
                                        </div>
                                    </div>

                                    <asp:SqlDataSource
                                        ID="db_L_Status"
                                        runat="server"
                                        ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>"
                                        CancelSelectOnNullParameter="false"
                                        SelectCommand="
                        SELECT 
                            id,
                            description
                        FROM L_Status"
                                        InsertCommand="
                        INSERT INTO L_Status (description)
                        VALUES (@description)"
                                        UpdateCommand="
                        UPDATE L_Status
                        SET description = @description
                        WHERE id = @id"
                                        DeleteCommand="
                        DELETE FROM L_Status
                        WHERE id = @id">
                                        <InsertParameters>
                                            <asp:Parameter Name="description" Type="String" />
                                        </InsertParameters>

                                        <UpdateParameters>
                                            <asp:Parameter Name="description" Type="String" />
                                            <asp:Parameter Name="id" Type="Int32" />
                                        </UpdateParameters>

                                        <DeleteParameters>
                                            <asp:Parameter Name="id" Type="Int32" />
                                        </DeleteParameters>
                                    </asp:SqlDataSource>

                                </div>

                            </dx:ContentControl>
                        </ContentCollection>
                    </dx:TabPage>

                    <dx:TabPage Text="مستوى المستخدم" TabStyle-Font-Bold="true" TabStyle-Font-Names="cairo" TabStyle-Font-Size="Medium">
                        <TabStyle Font-Bold="True" Font-Names="cairo" Font-Size="x-large"></TabStyle>
                        <ContentCollection>
                            <dx:ContentControl>

                                <div class="navbar-main navbar-expand-lg px-0 mx-4 border-radius-xl bg-white shadow mt-3 mb-1">

                                    <div style="margin: 0 auto; width: 100%;">
                                        <div class="content-div">
                                            <dx:ASPxGridView ID="Grid_L_UserLevel" runat="server" DataSourceID="db_L_UserLevel" KeyFieldName="id"
                                                ClientInstanceName="Grid_L_UserLevel" Width="100%" AutoGenerateColumns="False"
                                                EnablePagingCallbackAnimation="True" Font-Names="cairo" Font-Size="1em" RightToLeft="True">
                                                <%--<ClientSideEvents RowClick="function(s,e){ OnRowClick(e); }" />--%>
                                                <SettingsAdaptivity AdaptivityMode="HideDataCells"></SettingsAdaptivity>
                                                <Settings ShowFooter="True" />
                                                <SettingsCommandButton>
                                                    <NewButton Text="جديد"></NewButton>
                                                    <UpdateButton Text=" حفظ ">
                                                        <Image Url="~/assets/img/save.png" SpriteProperties-Left="50">
                                                            <SpriteProperties Left="50px"></SpriteProperties>
                                                        </Image>
                                                    </UpdateButton>
                                                    <CancelButton Text=" الغاء ">
                                                        <Image Url="~/assets/img/cancel.png"></Image>
                                                    </CancelButton>
                                                </SettingsCommandButton>
                                                <SettingsPopup>
                                                    <FilterControl AutoUpdatePosition="False"></FilterControl>
                                                </SettingsPopup>
                                                <SettingsSearchPanel CustomEditorID="tbToolbarSearch12" />
                                                <SettingsExport EnableClientSideExportAPI="true" ExcelExportMode="WYSIWYG" PaperKind="A4" RightToLeft="True" />
                                                <SettingsLoadingPanel Text="Please Wait &amp;hellip;" Mode="ShowAsPopup" />
                                                <SettingsText SearchPanelEditorNullText="ابحث في الجدول..." EmptyDataRow="لا يوجد" />

                                                <Columns>

                                                    <dx:GridViewDataColumn Caption="الرقم" FieldName="id">
                                                        <EditFormSettings Visible="False" />
                                                        <CellStyle VerticalAlign="Middle" HorizontalAlign="Center"></CellStyle>
                                                    </dx:GridViewDataColumn>

                                                    <dx:GridViewDataColumn Caption="الوصف" FieldName="description">
                                                        <EditFormSettings />
                                                        <CellStyle VerticalAlign="Middle" HorizontalAlign="Center"></CellStyle>
                                                    </dx:GridViewDataColumn>

                                                    <dx:GridViewDataTextColumn Caption="" Width="100px">
                                                        <DataItemTemplate>
                                                            <div style="text-align: center">
                                                                <img src="/assets/img/update.png" width="32" height="32" title="تعديل"
                                                                    style="cursor: pointer"
                                                                    onclick="onUpdateClickGeneric('Grid_L_UserLevel','<%# Container.KeyValue %>');" />

                                                                <img src="/assets/img/delete.png" width="32" height="32" title="حذف"
                                                                    style="cursor: pointer"
                                                                    onclick="showDeletePopup('Grid_L_UserLevel','<%# Container.KeyValue %>');" />
                                                            </div>
                                                        </DataItemTemplate>
                                                        <EditFormSettings Visible="False" />
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
                                                                    <dx:ASPxButtonEdit ID="tbToolbarSearch12" runat="server" NullText="البحث..." Width="140" Font-Names="cairo" />
                                                                </Template>
                                                            </dx:GridViewToolbarItem>
                                                        </Items>
                                                    </dx:GridViewToolbar>
                                                </Toolbars>

                                                <TotalSummary>
                                                    <dx:ASPxSummaryItem FieldName="id" SummaryType="Count" DisplayFormat="العدد = {0}" />
                                                </TotalSummary>

                                                <Styles>
                                                    <AlternatingRow BackColor="#F0F0F0"></AlternatingRow>
                                                    <Footer Font-Names="cairo"></Footer>
                                                </Styles>
                                                <Paddings Padding="2em" />
                                            </dx:ASPxGridView>
                                        </div>
                                    </div>

                                    <asp:SqlDataSource
                                        ID="db_L_UserLevel"
                                        runat="server"
                                        ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>"
                                        CancelSelectOnNullParameter="false"
                                        SelectCommand="
                        SELECT 
                            id,
                            description
                        FROM L_UserLevel"
                                        InsertCommand="
                        INSERT INTO L_UserLevel (description)
                        VALUES (@description)"
                                        UpdateCommand="
                        UPDATE L_UserLevel
                        SET description = @description
                        WHERE id = @id"
                                        DeleteCommand="
                        DELETE FROM L_UserLevel
                        WHERE id = @id">
                                        <InsertParameters>
                                            <asp:Parameter Name="description" Type="String" />
                                        </InsertParameters>

                                        <UpdateParameters>
                                            <asp:Parameter Name="description" Type="String" />
                                            <asp:Parameter Name="id" Type="Int32" />
                                        </UpdateParameters>

                                        <DeleteParameters>
                                            <asp:Parameter Name="id" Type="Int32" />
                                        </DeleteParameters>
                                    </asp:SqlDataSource>

                                </div>

                            </dx:ContentControl>
                        </ContentCollection>
                    </dx:TabPage>

                    <dx:TabPage Text="نوع المستخدم" TabStyle-Font-Bold="true" TabStyle-Font-Names="cairo" TabStyle-Font-Size="Medium">
                        <TabStyle Font-Bold="True" Font-Names="cairo" Font-Size="x-large"></TabStyle>
                        <ContentCollection>
                            <dx:ContentControl>

                                <div class="navbar-main navbar-expand-lg px-0 mx-4 border-radius-xl bg-white shadow mt-3 mb-1">

                                    <div style="margin: 0 auto; width: 100%;">
                                        <div class="content-div">
                                            <dx:ASPxGridView ID="Grid_L_UsersType" runat="server" DataSourceID="db_L_UsersType" KeyFieldName="id"
                                                ClientInstanceName="Grid_L_UsersType" Width="100%" AutoGenerateColumns="False"
                                                EnablePagingCallbackAnimation="True" Font-Names="cairo" Font-Size="1em" RightToLeft="True">
                                                <%--<ClientSideEvents RowClick="function(s,e){ OnRowClick(e); }" />--%>
                                                <SettingsAdaptivity AdaptivityMode="HideDataCells"></SettingsAdaptivity>
                                                <Settings ShowFooter="True" />
                                                <SettingsCommandButton>
                                                    <NewButton Text="جديد"></NewButton>
                                                    <UpdateButton Text=" حفظ ">
                                                        <Image Url="~/assets/img/save.png" SpriteProperties-Left="50">
                                                            <SpriteProperties Left="50px"></SpriteProperties>
                                                        </Image>
                                                    </UpdateButton>
                                                    <CancelButton Text=" الغاء ">
                                                        <Image Url="~/assets/img/cancel.png"></Image>
                                                    </CancelButton>
                                                </SettingsCommandButton>
                                                <SettingsPopup>
                                                    <FilterControl AutoUpdatePosition="False"></FilterControl>
                                                </SettingsPopup>
                                                <SettingsSearchPanel CustomEditorID="tbToolbarSearch13" />
                                                <SettingsExport EnableClientSideExportAPI="true" ExcelExportMode="WYSIWYG" PaperKind="A4" RightToLeft="True" />
                                                <SettingsLoadingPanel Text="Please Wait &amp;hellip;" Mode="ShowAsPopup" />
                                                <SettingsText SearchPanelEditorNullText="ابحث في الجدول..." EmptyDataRow="لا يوجد" />

                                                <Columns>

                                                    <dx:GridViewDataColumn Caption="الرقم" FieldName="id">
                                                        <EditFormSettings Visible="False" />
                                                        <CellStyle VerticalAlign="Middle" HorizontalAlign="Center"></CellStyle>
                                                    </dx:GridViewDataColumn>

                                                    <dx:GridViewDataColumn Caption="الوصف" FieldName="description">
                                                        <EditFormSettings />
                                                        <CellStyle VerticalAlign="Middle" HorizontalAlign="Center"></CellStyle>
                                                    </dx:GridViewDataColumn>

                                                    <dx:GridViewDataTextColumn Caption="" Width="100px">
                                                        <DataItemTemplate>
                                                            <div style="text-align: center">
                                                                <img src="/assets/img/update.png" width="32" height="32" title="تعديل"
                                                                    style="cursor: pointer"
                                                                    onclick="onUpdateClickGeneric('Grid_L_UsersType','<%# Container.KeyValue %>');" />

                                                                <img src="/assets/img/delete.png" width="32" height="32" title="حذف"
                                                                    style="cursor: pointer"
                                                                    onclick="showDeletePopup('Grid_L_UsersType','<%# Container.KeyValue %>');" />
                                                            </div>
                                                        </DataItemTemplate>
                                                        <EditFormSettings Visible="False" />
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
                                                                    <dx:ASPxButtonEdit ID="tbToolbarSearch13" runat="server" NullText="البحث..." Width="140" Font-Names="cairo" />
                                                                </Template>
                                                            </dx:GridViewToolbarItem>
                                                        </Items>
                                                    </dx:GridViewToolbar>
                                                </Toolbars>

                                                <TotalSummary>
                                                    <dx:ASPxSummaryItem FieldName="id" SummaryType="Count" DisplayFormat="العدد = {0}" />
                                                </TotalSummary>

                                                <Styles>
                                                    <AlternatingRow BackColor="#F0F0F0"></AlternatingRow>
                                                    <Footer Font-Names="cairo"></Footer>
                                                </Styles>
                                                <Paddings Padding="2em" />
                                            </dx:ASPxGridView>
                                        </div>
                                    </div>

                                    <asp:SqlDataSource
                                        ID="db_L_UsersType"
                                        runat="server"
                                        ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>"
                                        CancelSelectOnNullParameter="false"
                                        SelectCommand="
                        SELECT 
                            id,
                            description
                        FROM L_UsersType"
                                        InsertCommand="
                        INSERT INTO L_UsersType (description)
                        VALUES (@description)"
                                        UpdateCommand="
                        UPDATE L_UsersType
                        SET description = @description
                        WHERE id = @id"
                                        DeleteCommand="
                        DELETE FROM L_UsersType
                        WHERE id = @id">
                                        <InsertParameters>
                                            <asp:Parameter Name="description" Type="String" />
                                        </InsertParameters>

                                        <UpdateParameters>
                                            <asp:Parameter Name="description" Type="String" />
                                            <asp:Parameter Name="id" Type="Int32" />
                                        </UpdateParameters>

                                        <DeleteParameters>
                                            <asp:Parameter Name="id" Type="Int32" />
                                        </DeleteParameters>
                                    </asp:SqlDataSource>

                                </div>

                            </dx:ContentControl>
                        </ContentCollection>
                    </dx:TabPage>
                    <dx:TabPage Text="حالة تسجيل السائق" TabStyle-Font-Bold="true" TabStyle-Font-Names="cairo" TabStyle-Font-Size="Medium">
                        <TabStyle Font-Bold="True" Font-Names="cairo" Font-Size="x-large"></TabStyle>
                        <ContentCollection>
                            <dx:ContentControl>

                                <div class="navbar-main navbar-expand-lg px-0 mx-4 border-radius-xl bg-white shadow mt-3 mb-1">

                                    <div style="margin: 0 auto; width: 100%;">
                                        <div class="content-div">
                                            <dx:ASPxGridView ID="Grid_L_DeliveryStatus" runat="server" DataSourceID="db_L_DeliveryStatus" KeyFieldName="id"
                                                ClientInstanceName="Grid_L_DeliveryStatus" Width="100%" AutoGenerateColumns="False"
                                                EnablePagingCallbackAnimation="True" Font-Names="cairo" Font-Size="1em" RightToLeft="True">
                                                <%--<ClientSideEvents RowClick="function(s,e){ OnRowClick(e); }" />--%>
                                                <SettingsAdaptivity AdaptivityMode="HideDataCells"></SettingsAdaptivity>
                                                <Settings ShowFooter="True" />
                                                <SettingsCommandButton>
                                                    <NewButton Text="جديد"></NewButton>
                                                    <UpdateButton Text=" حفظ ">
                                                        <Image Url="~/assets/img/save.png" SpriteProperties-Left="50">
                                                            <SpriteProperties Left="50px"></SpriteProperties>
                                                        </Image>
                                                    </UpdateButton>
                                                    <CancelButton Text=" الغاء ">
                                                        <Image Url="~/assets/img/cancel.png"></Image>
                                                    </CancelButton>
                                                </SettingsCommandButton>
                                                <SettingsPopup>
                                                    <FilterControl AutoUpdatePosition="False"></FilterControl>
                                                </SettingsPopup>
                                                <SettingsSearchPanel CustomEditorID="tbToolbarSearch14" />
                                                <SettingsExport EnableClientSideExportAPI="true" ExcelExportMode="WYSIWYG" PaperKind="A4" RightToLeft="True" />
                                                <SettingsLoadingPanel Text="Please Wait &amp;hellip;" Mode="ShowAsPopup" />
                                                <SettingsText SearchPanelEditorNullText="ابحث في الجدول..." EmptyDataRow="لا يوجد" />

                                                <Columns>

                                                    <dx:GridViewDataColumn Caption="الرقم" FieldName="id">
                                                        <EditFormSettings Visible="False" />
                                                        <CellStyle VerticalAlign="Middle" HorizontalAlign="Center"></CellStyle>
                                                    </dx:GridViewDataColumn>

                                                    <dx:GridViewDataColumn Caption="الوصف" FieldName="description">
                                                        <EditFormSettings />
                                                        <CellStyle VerticalAlign="Middle" HorizontalAlign="Center"></CellStyle>
                                                    </dx:GridViewDataColumn>

                                                    <dx:GridViewDataTextColumn Caption="" Width="100px">
                                                        <DataItemTemplate>
                                                            <div style="text-align: center">
                                                                <img src="/assets/img/update.png" width="32" height="32" title="تعديل"
                                                                    style="cursor: pointer"
                                                                    onclick="onUpdateClickGeneric('Grid_L_DeliveryStatus','<%# Container.KeyValue %>');" />

                                                                <img src="/assets/img/delete.png" width="32" height="32" title="حذف"
                                                                    style="cursor: pointer"
                                                                    onclick="showDeletePopup('Grid_L_DeliveryStatus','<%# Container.KeyValue %>');" />
                                                            </div>
                                                        </DataItemTemplate>
                                                        <EditFormSettings Visible="False" />
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
                                                                    <dx:ASPxButtonEdit ID="tbToolbarSearch14" runat="server" NullText="البحث..." Width="140" Font-Names="cairo" />
                                                                </Template>
                                                            </dx:GridViewToolbarItem>
                                                        </Items>
                                                    </dx:GridViewToolbar>
                                                </Toolbars>

                                                <TotalSummary>
                                                    <dx:ASPxSummaryItem FieldName="id" SummaryType="Count" DisplayFormat="العدد = {0}" />
                                                </TotalSummary>

                                                <Styles>
                                                    <AlternatingRow BackColor="#F0F0F0"></AlternatingRow>
                                                    <Footer Font-Names="cairo"></Footer>
                                                </Styles>
                                                <Paddings Padding="2em" />
                                            </dx:ASPxGridView>
                                        </div>
                                    </div>

                                    <asp:SqlDataSource
                                        ID="db_L_DeliveryStatus"
                                        runat="server"
                                        ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>"
                                        CancelSelectOnNullParameter="false"
                                        SelectCommand="
                        SELECT 
                            id,
                            description
                        FROM L_DeliveryStatus"
                                        InsertCommand="
                        INSERT INTO L_DeliveryStatus (description)
                        VALUES (@description)"
                                        UpdateCommand="
                        UPDATE L_DeliveryStatus
                        SET description = @description
                        WHERE id = @id"
                                        DeleteCommand="
                        DELETE FROM L_DeliveryStatus
                        WHERE id = @id">
                                        <InsertParameters>
                                            <asp:Parameter Name="description" Type="String" />
                                        </InsertParameters>

                                        <UpdateParameters>
                                            <asp:Parameter Name="description" Type="String" />
                                            <asp:Parameter Name="id" Type="Int32" />
                                        </UpdateParameters>

                                        <DeleteParameters>
                                            <asp:Parameter Name="id" Type="Int32" />
                                        </DeleteParameters>
                                    </asp:SqlDataSource>

                                </div>

                            </dx:ContentControl>
                        </ContentCollection>
                    </dx:TabPage>
                    
                    <dx:TabPage Text="نوع المركبة" TabStyle-Font-Bold="true" TabStyle-Font-Names="cairo" TabStyle-Font-Size="Medium">
                        <TabStyle Font-Bold="True" Font-Names="cairo" Font-Size="x-large"></TabStyle>
                        <ContentCollection>
                            <dx:ContentControl>

                                <div class="navbar-main navbar-expand-lg px-0 mx-4 border-radius-xl bg-white shadow mt-3 mb-1">

                                    <div style="margin: 0 auto; width: 100%;">
                                        <div class="content-div">
                                            <dx:ASPxGridView ID="Grid_L_VehicleType" runat="server" DataSourceID="db_L_VehicleType" KeyFieldName="id"
                                                ClientInstanceName="Grid_L_VehicleType" Width="100%" AutoGenerateColumns="False"
                                                EnablePagingCallbackAnimation="True" Font-Names="cairo" Font-Size="1em" RightToLeft="True">
                                                <%--<ClientSideEvents RowClick="function(s,e){ OnRowClick(e); }" />--%>
                                                <SettingsAdaptivity AdaptivityMode="HideDataCells"></SettingsAdaptivity>
                                                <Settings ShowFooter="True" />
                                                <SettingsCommandButton>
                                                    <NewButton Text="جديد"></NewButton>
                                                    <UpdateButton Text=" حفظ ">
                                                        <Image Url="~/assets/img/save.png" SpriteProperties-Left="50">
                                                            <SpriteProperties Left="50px"></SpriteProperties>
                                                        </Image>
                                                    </UpdateButton>
                                                    <CancelButton Text=" الغاء ">
                                                        <Image Url="~/assets/img/cancel.png"></Image>
                                                    </CancelButton>
                                                </SettingsCommandButton>
                                                <SettingsPopup>
                                                    <FilterControl AutoUpdatePosition="False"></FilterControl>
                                                </SettingsPopup>
                                                <SettingsSearchPanel CustomEditorID="tbToolbarSearch15" />
                                                <SettingsExport EnableClientSideExportAPI="true" ExcelExportMode="WYSIWYG" PaperKind="A4" RightToLeft="True" />
                                                <SettingsLoadingPanel Text="Please Wait &amp;hellip;" Mode="ShowAsPopup" />
                                                <SettingsText SearchPanelEditorNullText="ابحث في الجدول..." EmptyDataRow="لا يوجد" />

                                                <Columns>

                                                    <dx:GridViewDataColumn Caption="الرقم" FieldName="id">
                                                        <EditFormSettings Visible="False" />
                                                        <CellStyle VerticalAlign="Middle" HorizontalAlign="Center"></CellStyle>
                                                    </dx:GridViewDataColumn>

                                                    <dx:GridViewDataColumn Caption="الوصف" FieldName="description">
                                                        <EditFormSettings />
                                                        <CellStyle VerticalAlign="Middle" HorizontalAlign="Center"></CellStyle>
                                                    </dx:GridViewDataColumn>

                                                    <dx:GridViewDataTextColumn Caption="" Width="100px">
                                                        <DataItemTemplate>
                                                            <div style="text-align: center">
                                                                <img src="/assets/img/update.png" width="32" height="32" title="تعديل"
                                                                    style="cursor: pointer"
                                                                    onclick="onUpdateClickGeneric('Grid_L_VehicleType','<%# Container.KeyValue %>');" />

                                                                <img src="/assets/img/delete.png" width="32" height="32" title="حذف"
                                                                    style="cursor: pointer"
                                                                    onclick="showDeletePopup('Grid_L_VehicleType','<%# Container.KeyValue %>');" />
                                                            </div>
                                                        </DataItemTemplate>
                                                        <EditFormSettings Visible="False" />
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
                                                                    <dx:ASPxButtonEdit ID="tbToolbarSearch15" runat="server" NullText="البحث..." Width="140" Font-Names="cairo" />
                                                                </Template>
                                                            </dx:GridViewToolbarItem>
                                                        </Items>
                                                    </dx:GridViewToolbar>
                                                </Toolbars>

                                                <TotalSummary>
                                                    <dx:ASPxSummaryItem FieldName="id" SummaryType="Count" DisplayFormat="العدد = {0}" />
                                                </TotalSummary>

                                                <Styles>
                                                    <AlternatingRow BackColor="#F0F0F0"></AlternatingRow>
                                                    <Footer Font-Names="cairo"></Footer>
                                                </Styles>
                                                <Paddings Padding="2em" />
                                            </dx:ASPxGridView>
                                        </div>
                                    </div>

                                    <asp:SqlDataSource
                                        ID="db_L_VehicleType"
                                        runat="server"
                                        ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>"
                                        CancelSelectOnNullParameter="false"
                                        SelectCommand="
                        SELECT 
                            id,
                            description
                        FROM L_VehicleType"
                                        InsertCommand="
                        INSERT INTO L_VehicleType (description)
                        VALUES (@description)"
                                        UpdateCommand="
                        UPDATE L_VehicleType
                        SET description = @description
                        WHERE id = @id"
                                        DeleteCommand="
                        DELETE FROM L_VehicleType
                        WHERE id = @id">
                                        <InsertParameters>
                                            <asp:Parameter Name="description" Type="String" />
                                        </InsertParameters>

                                        <UpdateParameters>
                                            <asp:Parameter Name="description" Type="String" />
                                            <asp:Parameter Name="id" Type="Int32" />
                                        </UpdateParameters>

                                        <DeleteParameters>
                                            <asp:Parameter Name="id" Type="Int32" />
                                        </DeleteParameters>
                                    </asp:SqlDataSource>

                                </div>

                            </dx:ContentControl>
                        </ContentCollection>
                    </dx:TabPage>

                </TabPages>
            </dx:ASPxPageControl>


            <dx:ASPxPopupControl ID="Pop_DeleteConfirm" runat="server"
                PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter"
                AutoUpdatePosition="True" Modal="True" ClientInstanceName="Pop_DeleteConfirm"
                CloseAnimationType="Slide" HeaderText="تأكيد الحذف" Font-Names="Cairo"
                MinWidth="350px" MinHeight="150px" Width="350px" Height="150px">

                <ContentCollection>
                    <dx:PopupControlContentControl runat="server">
                        <div style="padding: 20px; font-family: 'Cairo', sans-serif; text-align: center">
                            <dx:ASPxLabel ID="lblDeleteMessage" runat="server"
                                Text="هل أنت متأكد أنك تريد الحذف؟"
                                Font-Names="Cairo" Font-Size="x-large" ForeColor="#333333" />

                            <div style="margin-top: 25px;">
                                <dx:ASPxButton ID="btnConfirmDelete" runat="server" AutoPostBack="False" Text="حذف"
                                    UseSubmitBehavior="False" Font-Names="Cairo"
                                    Style="margin: 0 10px;">
                                    <ClientSideEvents Click="function(s,e){ executeDeleteConfirmed(); }" />
                                </dx:ASPxButton>

                                <dx:ASPxButton ID="btnCancelDelete" runat="server" AutoPostBack="False" Text="إلغاء"
                                    UseSubmitBehavior="False" Font-Names="Cairo"
                                    Style="margin: 0 10px;">
                                    <ClientSideEvents Click="function(s,e){ Pop_DeleteConfirm.Hide(); }" />
                                </dx:ASPxButton>
                            </div>
                        </div>
                    </dx:PopupControlContentControl>
                </ContentCollection>
            </dx:ASPxPopupControl>
        </main>

    

</asp:Content>
