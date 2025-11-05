<%@ Page Title="Branches" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Branches.aspx.cs" Inherits="ShabAdmin.Branches" %>

<%@ Register Assembly="DevExpress.Web.v24.1, Version=24.1.6.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">


    <main>
        <script>
            var MyIndex;
            var MyId;
            var isMain;

            function OnRowClick(e) {
                MyIndex = e.visibleIndex;
                GridBranches.GetRowValues(e.visibleIndex, 'id;isMain', OnGetRowValues);
            }

            function OnGetRowValues(Value) {
                MyId = Value[0];
                isMain = Value[1];
            }

            function copyBranch() {
                setTimeout(function () {
                    if (isMain == 1) {
                        labelBranches2.SetText('لا يمكن نقل المنتجات، الفرع الذي اخترته فرع رئيسي');
                        labelBranches3.SetText('مساعدة: قم بتعديل هذا الفرع وأطفىء خيار الفرع الرئيسي وضعه على فرع آخر يحتوي على كامل المنتجات وعد واختار هذا الفرع لنقل المنتجات');
                        Btn_Clone.SetVisible(false);
                        Pop_Copy.Show();
                    }
                    else {
                        checkBrackCallback.PerformCallback(MyId);
                    }
                }, 300);
            }

            function onDeleteClick(visibleIndex) {
                MyIndex = visibleIndex;
                Pop_Del_Grids.Show();
            }

            function onCountryChanged(s, e) {
                var countryId = s.GetValue();
                cpCompany.PerformCallback(countryId);
            }

            function onCountryChanged2(s, e) {
                var countryId = comboCountry.GetValue();
                cpCompany.PerformCallback(countryId);
            }
            function CitiesCombo_SelectedIndexChanged(s, e) {
                var cityId = s.GetValue();
                var editorCity = GridBranches.GetEditor("cityId");
                if (editorCity != null)
                    editorCity.PerformCallback(cityId);

                var editorCompany = GridBranches.GetEditor("companyId");
                if (editorCompany != null)
                    editorCompany.PerformCallback("cityChanged|" + cityId);
            }


        </script>

        <div class="w-100 text-center my-4">
            <h2 class="pageTitle d-inline-block" style="font-family: Cairo">الفـــروع</h2>
        </div>

        <div class="navbar-main navbar-expand-lg px-0 mx-4 border-radius-xl bg-white shadow mt-3 mb-1">

            <dx:ASPxCallbackPanel ID="checkBrackCallback" ClientInstanceName="checkBrackCallback" OnCallback="checkBrackCallback_Callback" runat="server" Width="0px">
                <ClientSideEvents EndCallback="function(s, e){
                        if(s.cpResultCheck == 1){
                            labelBranches2.SetText('تأكيد نسخ كامل المنتجات من الفرع الرئيسي إلى هذا الفرع');
                            labelBranches3.SetText('مهم: يجب وجود فرع رئيسي لتبدأ عملية النسخ، ولن يتم نسخ أي منتج موجود مسبقا في هذا الفرع');
                            Btn_Clone.SetVisible(true);
                            Pop_Copy.Show();
                        }
                        else {
                            labelBranches2.SetText('لا يوجد فرع رئيسي للنسخ منه، الرجاء تحديد الفرع الرئيسي');
                            labelBranches3.SetText('مهم: يجب وجود فرع رئيسي لتبدأ عملية النسخ، ولن يتم نسخ أي منتج موجود مسبقا في هذا الفرع');
                            Btn_Clone.SetVisible(false);
                            Pop_Copy.Show();
                        }
                    }" />
                <PanelCollection>
                    <dx:PanelContent runat="server"></dx:PanelContent>
                </PanelCollection>
            </dx:ASPxCallbackPanel>

            <dx:ASPxGridView ID="GridBranches" runat="server" DataSourceID="db_Branches" KeyFieldName="id" ClientInstanceName="GridBranches" Width="100%" AutoGenerateColumns="False" EnablePagingCallbackAnimation="True" Font-Names="cairo" Font-Size="1em" RightToLeft="True" OnCellEditorInitialize="Grid_Association_CellEditorInitialize" OnRowInserting="GridBranches_RowInserting" OnRowUpdating="GridBranches_RowUpdating" OnCustomCallback="GridBranches_CustomCallback">
                <ClientSideEvents EndCallback="function(s ,e) {
                            if(s.cpResult == 1){
                                labelClone.SetText('تم نقل بيانات المنتجات من الفرع الرئيسي إلى الفرع رقم (' + MyId + ') بنجاح');
                                Pop_Clone.Show(); 
                            }
                            else if(s.cpResult == 0)
                            {
                                labelClone.SetText('حدث خطأ، الرجاء المحاولة مرة أخرى أو التواصل مع الدعم الفني');
                                Pop_Clone.Show(); 
                            }
                            s.cpResult = -1;
                        }
                         " />
                <Settings ShowFooter="True" ShowFilterRow="True" />


                <ClientSideEvents RowClick="function(s, e) {OnRowClick(e);}" RowDblClick="function(s, e) {setTimeout(function(){GridBranches.StartEditRow(MyIndex);},100);}" />
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

                    <dx:GridViewDataTextColumn Caption="الاسم" FieldName="name" Width="13%">
                        <PropertiesTextEdit>
                            <ValidationSettings RequiredField-IsRequired="true" SetFocusOnError="True" ErrorText="Country name in arabic is required." Display="Dynamic">
                                <RequiredField IsRequired="True"></RequiredField>
                            </ValidationSettings>
                        </PropertiesTextEdit>
                        <CellStyle VerticalAlign="Middle" HorizontalAlign="Center">
                        </CellStyle>
                    </dx:GridViewDataTextColumn>
                    <dx:GridViewDataComboBoxColumn Caption="الدولة" FieldName="countryId">
                        <PropertiesComboBox DataSourceID="DB_Countries" TextField="countryName" ValueField="id" ValueType="System.Int32">
                            <ValidationSettings RequiredField-IsRequired="true" SetFocusOnError="True" ErrorText="Country name in arabic is required." Display="Dynamic">
                                <RequiredField IsRequired="True"></RequiredField>
                            </ValidationSettings>
                            <ClientSideEvents SelectedIndexChanged="CitiesCombo_SelectedIndexChanged" />
                            <ItemStyle Font-Size="1.5em" />
                        </PropertiesComboBox>
                        <CellStyle VerticalAlign="Middle" HorizontalAlign="Center">
                        </CellStyle>
                    </dx:GridViewDataComboBoxColumn>

                    <dx:GridViewDataComboBoxColumn Caption="الحالة" FieldName="l_branchStatus">
                        <PropertiesComboBox DataSourceID="DB_BranchesList" TextField="description" ValueField="id" ValueType="System.Int32">
                            <ValidationSettings RequiredField-IsRequired="true" SetFocusOnError="True" ErrorText="name in arabic is required." Display="Dynamic">
                                <RequiredField IsRequired="True"></RequiredField>
                            </ValidationSettings>
                            <ItemStyle Font-Size="1.5em" />
                        </PropertiesComboBox>
                        <CellStyle VerticalAlign="Middle" HorizontalAlign="Center">
                        </CellStyle>
                    </dx:GridViewDataComboBoxColumn>

                    <dx:GridViewDataCheckColumn Caption="فرع رئيسي" FieldName="isMain" Width="5%">
                        <EditFormSettings Visible="True" />
                        <CellStyle HorizontalAlign="Center" VerticalAlign="Middle">
                        </CellStyle>
                    </dx:GridViewDataCheckColumn>

                    <dx:GridViewDataComboBoxColumn Caption="المدينة" FieldName="cityId">
                        <PropertiesComboBox DataSourceID="DB_Cities" TextField="cityName" ValueField="id" ValueType="System.Int32">
                            <ValidationSettings RequiredField-IsRequired="true" SetFocusOnError="True" ErrorText="Country name in arabic is required." Display="Dynamic">
                                <RequiredField IsRequired="True"></RequiredField>
                            </ValidationSettings>
                            <ItemStyle Font-Size="1.5em" />
                        </PropertiesComboBox>
                        <CellStyle VerticalAlign="Middle" HorizontalAlign="Center">
                        </CellStyle>
                    </dx:GridViewDataComboBoxColumn>

                    <dx:GridViewDataComboBoxColumn Caption="الشركة" FieldName="companyId">
                        <PropertiesComboBox DataSourceID="DB_Companies" TextField="companyName" ValueField="id" ValueType="System.Int32">
                            <ValidationSettings RequiredField-IsRequired="true" SetFocusOnError="True" ErrorText="required." Display="Dynamic">
                                <RequiredField IsRequired="True"></RequiredField>
                            </ValidationSettings>
                            <ItemStyle Font-Size="1.5em" />
                        </PropertiesComboBox>
                        <CellStyle VerticalAlign="Middle" HorizontalAlign="Center">
                        </CellStyle>
                    </dx:GridViewDataComboBoxColumn>

                    <dx:GridViewDataTextColumn Caption="خطوط الطول" FieldName="latitude">
                        <PropertiesTextEdit>
                            <ValidationSettings RequiredField-IsRequired="true" SetFocusOnError="True" ErrorText="Country name in arabic is required." Display="Dynamic">
                                <RequiredField IsRequired="True"></RequiredField>
                            </ValidationSettings>
                        </PropertiesTextEdit>
                        <EditFormSettings Visible="True" />
                        <CellStyle VerticalAlign="Middle" HorizontalAlign="Center" />
                        <DataItemTemplate>
                            <a href='<%# "https://maps.google.com/?q=" 
                                         + Eval("latitude") + "," + Eval("longitude") %>'
                                target="_blank">
                                <%# Eval("latitude") %>
                            </a>
                        </DataItemTemplate>
                    </dx:GridViewDataTextColumn>
                    <dx:GridViewDataTextColumn Caption="خطوط العرض" FieldName="longitude">
                        <PropertiesTextEdit>
                            <ValidationSettings RequiredField-IsRequired="true" SetFocusOnError="True" ErrorText="Country name in arabic is required." Display="Dynamic">
                                <RequiredField IsRequired="True"></RequiredField>
                            </ValidationSettings>
                        </PropertiesTextEdit>
                        <EditFormSettings Visible="True" />
                        <CellStyle VerticalAlign="Middle" HorizontalAlign="Center" />
                        <DataItemTemplate>
                            <a href='<%# "https://maps.google.com/?q=" 
                                         + Eval("latitude") + "," + Eval("longitude") %>'
                                target="_blank">
                                <%# Eval("longitude") %>
                            </a>
                        </DataItemTemplate>
                    </dx:GridViewDataTextColumn>
                    <dx:GridViewDataTextColumn Caption="الهاتف" FieldName="phone">
                        <PropertiesTextEdit>
                            <ValidationSettings RequiredField-IsRequired="true" SetFocusOnError="True" ErrorText="Country name in arabic is required." Display="Dynamic">
                                <RequiredField IsRequired="True"></RequiredField>
                            </ValidationSettings>
                        </PropertiesTextEdit>
                        <EditFormSettings Visible="True" />
                        <CellStyle VerticalAlign="Middle" HorizontalAlign="Center" />
                    </dx:GridViewDataTextColumn>
                    <dx:GridViewDataTextColumn Caption="الهاتف الفرعي" FieldName="extensionNumber">
                        <PropertiesTextEdit>
                            <ValidationSettings RequiredField-IsRequired="true" SetFocusOnError="True" ErrorText="Country name in arabic is required." Display="Dynamic">
                                <RequiredField IsRequired="True"></RequiredField>
                            </ValidationSettings>
                        </PropertiesTextEdit>
                        <EditFormSettings Visible="True" />
                        <CellStyle VerticalAlign="Middle" HorizontalAlign="Center" />
                    </dx:GridViewDataTextColumn>

                    <dx:GridViewDataTextColumn Caption="نسخ">
                        <EditFormSettings Visible="False" />
                        <CellStyle VerticalAlign="Middle" HorizontalAlign="Center" />
                        <DataItemTemplate>
                            <img src="assets/img/Copy.png" onclick="copyBranch();" style="cursor: pointer" alt="نسخ المنتجات من الفرع الرئيسي إلى هذا الفرع" title="نسخ المنتجات من الفرع الرئيسي إلى هذا الفرع" />
                        </DataItemTemplate>
                    </dx:GridViewDataTextColumn>

                    <dx:GridViewDataTextColumn Caption="" ShowInCustomizationForm="True" Width="100px">
                        <EditFormSettings Visible="False" />
                        <DataItemTemplate>
                            <div style="width: 100%; float: left; text-align: center">
                                <img src="/assets/img/update.png" width="32" height="32" title="تعديل" style="cursor: pointer" onclick="setTimeout(function(){GridBranches.StartEditRow(MyIndex);},100);" />
                                <img src="/assets/img/delete.png" width="32" height="32" title="حذف" style="cursor: pointer" onclick="onDeleteClick(<%# Container.VisibleIndex %>);" />
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
                ID="db_Branches"
                runat="server"
                ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>"
                SelectCommand="SELECT 
                        b.[id], 
                        b.[name], 
                        b.[l_branchStatus],
                        b.[countryId], 
                        b.[companyId], 
                        c.[companyName],
                        b.[cityId],
                        b.[latitude], 
                        b.[longitude], 
                        b.[phone], 
                        b.[extensionNumber],
                        b.[isMain]
                    FROM branches b
                    LEFT JOIN companies c ON b.companyId = c.id
"
                InsertCommand="INSERT INTO [branches] ([name], [l_branchStatus], [latitude], [longitude], [phone], [extensionNumber], [isMain], [countryId], [companyId], [cityId],[userDate]) VALUES (@name , @l_branchStatus, @latitude, @longitude, @phone, @extensionNumber,@isMain ,@countryId,@companyId,@cityId,getdate());"
                UpdateCommand="UPDATE [branches]
                    SET [name]        = @name,
                        l_branchStatus = @l_branchStatus,
                        [latitude]    = @latitude,
                        [longitude]   = @longitude,
                        [phone]       = @phone,
                        [extensionNumber] = @extensionNumber,
                        [isMain] = @isMain,
                        [countryId] = @countryId,
                        [companyId] = @companyId,
                        [cityId] = @cityId
                    WHERE [id] = @id;"
                DeleteCommand="DELETE FROM [branches] WHERE [id] = @id;
                    delete from branchproducts where branchId = @id;
                    ">
                <InsertParameters>
                    <asp:Parameter Name="name" Type="String" />
                    <asp:Parameter Name="l_branchStatus" Type="String" />
                    <asp:Parameter Name="latitude" Type="String" />
                    <asp:Parameter Name="longitude" Type="String" />
                    <asp:Parameter Name="phone" Type="String" />
                    <asp:Parameter Name="extensionNumber" Type="String" />
                    <asp:Parameter Name="isMain" Type="String" />
                    <asp:Parameter Name="countryId" Type="String" />
                    <asp:Parameter Name="companyId" Type="String" />
                    <asp:Parameter Name="cityId" Type="String" />
                </InsertParameters>
                <UpdateParameters>
                    <asp:Parameter Name="name" Type="String" />
                    <asp:Parameter Name="l_branchStatus" Type="String" />
                    <asp:Parameter Name="latitude" Type="String" />
                    <asp:Parameter Name="longitude" Type="String" />
                    <asp:Parameter Name="phone" Type="String" />
                    <asp:Parameter Name="extensionNumber" Type="String" />
                    <asp:Parameter Name="isMain" Type="String" />
                    <asp:Parameter Name="countryId" Type="String" />
                    <asp:Parameter Name="companyId" Type="String" />
                    <asp:Parameter Name="cityId" Type="String" />
                    <asp:Parameter Name="id" Type="Int32" />
                </UpdateParameters>
                <DeleteParameters>
                    <asp:Parameter Name="id" Type="Int32" />
                </DeleteParameters>
            </asp:SqlDataSource>
        </div>

        <asp:SqlDataSource ID="DB_CheckMainBranch" runat="server" ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>" SelectCommand="select b.id, b.isMain from branches b where countryId =  (select d.countryId from branches d where d.id=@id) and companyID = (select c.companyID from branches c where c.id=@id) and b.isMain =1">
            <SelectParameters>
                <asp:Parameter Name="id" />
            </SelectParameters>
        </asp:SqlDataSource>

        <asp:SqlDataSource ID="DB_BranchesList" runat="server" ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>" SelectCommand="SELECT id, description FROM L_BranchStatus"></asp:SqlDataSource>
        <asp:SqlDataSource ID="DB_Countries" runat="server" ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>" SelectCommand="SELECT * FROM countries where id <> 1000"></asp:SqlDataSource>

        <asp:SqlDataSource ID="DB_Cities" runat="server" ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>" SelectCommand="SELECT id,cityName FROM cities"></asp:SqlDataSource>
        <asp:SqlDataSource ID="DB_L_Cities_selected" runat="server" ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>" SelectCommand="SELECT id,cityName FROM cities where countryId=@id">
            <SelectParameters>
                <asp:Parameter Name="id" />
            </SelectParameters>
        </asp:SqlDataSource>



        <asp:SqlDataSource ID="DB_Companies" runat="server" ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>" SelectCommand="SELECT id,companyName FROM companies where id <> 1000"></asp:SqlDataSource>
        <asp:SqlDataSource ID="DB_L_Companies_selected" runat="server" ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>" SelectCommand="SELECT id,companyName FROM companies where countryId=@id AND (id = @companyID or @companyID=0) ">
            <SelectParameters>
                <asp:Parameter Name="id" />
                <asp:Parameter Name="companyID" Type="String" DefaultValue="0" />
            </SelectParameters>
        </asp:SqlDataSource>

        <dx:ASPxPopupControl runat="server" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter"
            AutoUpdatePosition="True" Modal="True" ClientInstanceName="Pop_Del_Grids" CloseAnimationType="Slide"
            FooterText="" HeaderText="حذف فرع" Font-Names="Cairo" MinWidth="350px" MinHeight="150px" Width="350px" Height="150px" ID="Pop_Del_Branches">
            <ContentCollection>
                <dx:PopupControlContentControl runat="server">
                    <div style="padding: 20px; font-family: 'Cairo', sans-serif; text-align: right">
                        <div class="mb-3" style="width: 100%;">
                            <dx:ASPxLabel runat="server" Text="هل أنت متأكد من حذف الفرع؟" ClientInstanceName="labelBranches"
                                Font-Names="Cairo" Font-Size="Medium" ForeColor="#333333" ID="labelBranches">
                            </dx:ASPxLabel>
                        </div>
                        <div style="width: 100%; margin-top: 20px; text-align: center;">
                            <dx:ASPxButton ID="Btn_Del_Branches" runat="server" AutoPostBack="False" Text="حــــــــذف"
                                UseSubmitBehavior="False" Font-Names="Cairo" HorizontalAlign="Center" VerticalAlign="Middle">
                                <ClientSideEvents Click="function(s, e) { 
                            GridBranches.DeleteRow(MyIndex); 
                            setTimeout(function() { GridBranches.Refresh(); }, 200);
                            Pop_Del_Grids.Hide();
                        }" />
                            </dx:ASPxButton>

                            <dx:ASPxButton ID="Btn_Close_Branches" runat="server" AutoPostBack="False" Text="إغـــــــــــلاق"
                                UseSubmitBehavior="False" Font-Names="Cairo" HorizontalAlign="Center" VerticalAlign="Middle"
                                Style="margin-right: 20px;">
                                <ClientSideEvents Click="function(s, e) {Pop_Del_Grids.Hide();}" />
                            </dx:ASPxButton>
                        </div>
                    </div>
                </dx:PopupControlContentControl>
            </ContentCollection>
        </dx:ASPxPopupControl>

        <dx:ASPxPopupControl runat="server" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter"
            AutoUpdatePosition="True" Modal="True" ClientInstanceName="Pop_Copy" CloseAnimationType="Slide"
            FooterText="" HeaderText="نسخ المنتجات" Font-Names="Cairo" MinWidth="550px" MinHeight="150px" Width="350px" Height="150px" ID="Pop_Copy">
            <ContentCollection>
                <dx:PopupControlContentControl runat="server">
                    <div style="padding: 20px; font-family: 'Cairo', sans-serif; text-align: center">
                        <div class="mb-3" style="width: 100%;">
                            <dx:ASPxLabel runat="server" Text="تأكيد نسخ كامل المنتجات من الفرع الرئيسي إلى هذا الفرع" ClientInstanceName="labelBranches2"
                                Font-Names="Cairo" Font-Size="Larger" ForeColor="#333333" ID="labelBranches2" EncodeHtml="False" Font-Bold="True">
                            </dx:ASPxLabel>
                            <br />
                            <dx:ASPxLabel runat="server" Text="ملاحظة: لن يتم نسخ أي منتج موجود مسبقا في هذا الفرع" ClientInstanceName="labelBranches3"
                                Font-Names="Cairo" Font-Size="Medium" ForeColor="#009933" ID="labelBranches3" EncodeHtml="False">
                            </dx:ASPxLabel>
                        </div>
                        <div style="width: 100%; margin-top: 20px; text-align: center;">
                            <dx:ASPxButton ID="Btn_Clone" runat="server" AutoPostBack="False" Text="نســـــــــــخ" ClientInstanceName="Btn_Clone"
                                UseSubmitBehavior="False" Font-Names="Cairo" HorizontalAlign="Center" VerticalAlign="Middle" Font-Bold="True">
                                <ClientSideEvents Click="function(s, e) { 
                                            setTimeout(function(){GridBranches.PerformCallback(MyId);},200); 
                                            Pop_Copy.Hide();
                                        }" />
                            </dx:ASPxButton>

                            <dx:ASPxButton ID="Btn_Close_Branches2" runat="server" AutoPostBack="False" Text="إغـــــــــــلاق"
                                UseSubmitBehavior="False" Font-Names="Cairo" HorizontalAlign="Center" VerticalAlign="Middle"
                                Style="margin-right: 20px;">
                                <ClientSideEvents Click="function(s, e) {Pop_Copy.Hide();}" />
                            </dx:ASPxButton>
                        </div>
                    </div>
                </dx:PopupControlContentControl>
            </ContentCollection>
        </dx:ASPxPopupControl>

        <dx:ASPxPopupControl runat="server" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter"
            AutoUpdatePosition="True" Modal="True" ClientInstanceName="Pop_Clone" CloseAnimationType="Slide"
            Font-Names="Cairo" Width="500px" ID="Pop_Clone" HeaderText="">
            <ContentCollection>
                <dx:PopupControlContentControl runat="server">
                    <div style="padding: 3em; font-family: 'Cairo', text-align: center">
                        <div class="mb-5" style="width: 100%; text-align: center">
                            <dx:ASPxLabel runat="server" Text="تم نقل بيانات المنتجات بنجاح" ClientInstanceName="labelClone"
                                Font-Names="Cairo" Font-Size="X-Large" ForeColor="#333333" ID="labelClone">
                            </dx:ASPxLabel>
                        </div>
                        <div style="width: 100%; text-align: center;">
                            <dx:ASPxButton Width="100%" ID="Btn_Close_Compnies" runat="server" AutoPostBack="False" Text="إغـــــــــــلاق" UseSubmitBehavior="False" Font-Names="Cairo" Font-Size="Large" Height="100px">
                                <ClientSideEvents Click="function(s, e) {Pop_Clone.Hide();}" />
                            </dx:ASPxButton>
                        </div>
                    </div>
                </dx:PopupControlContentControl>
            </ContentCollection>
        </dx:ASPxPopupControl>

    </main>



</asp:Content>
