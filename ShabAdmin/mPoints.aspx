<%@ Page Title="Points" Language="C#" MasterPageFile="~/mSite.Master" AutoEventWireup="true" CodeBehind="mPoints.aspx.cs" Inherits="ShabAdmin.mPoints" %>

<%@ Register Assembly="DevExpress.Web.v24.1, Version=24.1.6.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">


    <main>
        <script>
            var MyId;
            var MyIndex;
            var MyIndexDetail;
            var lastUploadedImage;

            function OnRowClick(s, e) {
                MyIndex = e.visibleIndex;
                GridPoints.GetRowValues(e.visibleIndex, 'id;image', OnGetRowValues);
            }

            function OnGetRowValues(Value) {
                MyId = Value[0];
                l_item_file.SetText(Value[1]);
                l_item_file_old.SetText(Value[1]);
            }

            function onFileUploadStart(s, e) {
                l_item_file_check.SetText('0');
            }

            function onFileUploadComplete(s, e) {
                var fileData = e.callbackData.split('|');
                var fileName = fileData[0];
                lastUploadedImage = fileName;
                if (document.getElementById("DocsFile-" + MyId) != null) {
                    document.getElementById("DocsFile-" + MyId).src = fileName;
                    document.getElementById("DocsFileLarge-" + MyId).src = fileName;
                }
                else {
                    document.getElementById("DocsFileLarge-").src = fileName;
                }
                l_item_file.SetText(fileName);
                l_item_file_check.SetText('1');
                MyId = 0;
            }

            function OnGridBeginCallback(s, e) {
                if (e.command == 'STARTEDIT') {
                    l_item_file_check.SetText('0');
                }
                if (e.command == 'ADDNEWROW') {
                    MyId = 0;
                    l_item_file.SetText('');
                    l_item_file_old.SetText('');
                }
                if (e.command == 'UPDATEEDIT') {

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

            function OnGridEndCallback(s, e) {
                if (s.cpShowActivePopup) {
                    s.cpShowActivePopup = false;
                    popupActive.Show();
                }
                var exists = s.cpOrdersExist;
                var pointId = s.cpPointId;

                if (exists === "1") {

                    s.cpOrdersExist = "0";

                    // افتح السطر بواسطة الـ ID
                    s.StartEditRowByKey(pointId);

                    setTimeout(function () {

                        var fieldsToDisable = ["description", "points", "discountAmount", "countryId", "companyId", "userDate"];
                        fieldsToDisable.forEach(function (f) {
                            var editor = s.GetEditor(f);
                            if (editor) editor.SetEnabled(false);
                        });

                        // disable upload
                        var upload = window["poorImageUpload_" + pointId];
                        if (upload) upload.SetEnabled(false);

                    }, 300);
                }
                else if (exists === "2") {
                    s.cpOrdersExist = "0";
                    s.StartEditRowByKey(pointId);
                }

                // إعادة تعيين الصورة
                if (lastUploadedImage != null) {
                    if (document.getElementById("DocsFile-" + MyId) != null) {
                        var img1 = document.getElementById("DocsFile-" + pointId);
                        var img2 = document.getElementById("DocsFileLarge-" + pointId);
                    } else {
                        var img1 = document.getElementById("DocsFile-");
                        var img2 = document.getElementById("DocsFileLarge-");
                    }
                    if (img1) img1.src = lastUploadedImage;
                    if (img2) img2.src = lastUploadedImage;
                    lastUploadedImage = null;
                }
            }

        </script>

        <div class="w-100 text-center my-4">
            <h2 class="pageTitle d-inline-block" style="font-family: Cairo">النقـــاط والمكافـــآت</h2>
        </div>

        <div class="navbar-main navbar-expand-lg px-0 mx-4 border-radius-xl bg-white shadow mt-3 mb-1">


            <dx:ASPxGridView ID="GridPoints" runat="server" DataSourceID="db_Points" KeyFieldName="id" ClientInstanceName="GridPoints" Width="100%" AutoGenerateColumns="False" EnablePagingCallbackAnimation="True" Font-Names="cairo" Font-Size="1em" RightToLeft="True"
                OnCancelRowEditing="GridPoints_CancelRowEditing" OnCustomCallback="GridPoints_CustomCallback" OnRowValidating="GridPoints_RowValidating" OnRowUpdated="GridPoints_RowUpdated" OnRowDeleting="GridPoints_RowDeleting" OnCellEditorInitialize="GridPoints_CellEditorInitialize">
                <Settings ShowFilterRow="True" ShowFilterRowMenu="False" ShowHeaderFilterButton="False" AutoFilterCondition="Contains" />

                <ClientSideEvents BeginCallback="OnGridBeginCallback" EndCallback="OnGridEndCallback" RowClick="OnRowClick" RowDblClick="function(s, e) {setTimeout(function(){GridPoints.StartEditRow(MyIndex);},100);}" />
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

                    <dx:GridViewDataColumn Caption="الصورة" FieldName="image" EditFormSettings-VisibleIndex="1" EditFormSettings-Caption=" ">
                        <EditFormSettings RowSpan="6" VisibleIndex="1" Caption=" "></EditFormSettings>
                        <DataItemTemplate>
                            <div style="text-align: center; width: 100%">
                                <img id="<%# "DocsFile-" + Eval("id") %>" src="<%# (!string.IsNullOrEmpty(Eval("image").ToString()) ? Eval("image") : "/assets/uploads/noFile.png") + "?v=" + DateTime.Now.Ticks %>" style="width: 7em; border: 1px solid #c8c8c8; border-radius: 5px; margin-top: 10px;" />
                            </div>
                        </DataItemTemplate>
                        <CellStyle VerticalAlign="Middle">
                        </CellStyle>

                        <EditItemTemplate>
                            <div style="text-align: center; width: 90%">
                                <img id="<%# "DocsFileLarge-" + Eval("id") %>" src="<%# (Eval("image") != null && Eval("image").ToString().Length > 1 ? Eval("image").ToString() : "/assets/uploads/noFile.png") + "?v=" + DateTime.Now.Ticks %>" style="width: 15em; border: 1px solid #c8c8c8; border-radius: 5px;" />
                                <dx:ASPxUploadControl ID="poorImageUpload" runat="server" ClientInstanceName='<%# "poorImageUpload_" + Eval("id") %>' FileUploadMode="OnPageLoad" Font-Names="Cairo" Font-Size="1em" OnFileUploadComplete="ImageUpload_FileUploadComplete" ShowProgressPanel="True" UploadMode="Auto" Width="100%" AutoStartUpload="True">
                                    <ValidationSettings AllowedFileExtensions=".jpg, .jpeg, .png, .bmp" GeneralErrorText="حدث خطأ أثناء تحميل الصور ، الرجاء المحاولة لاحقا" MaxFileSize="5048576" MaxFileSizeErrorText="حجم الصورة أكبر من 1 ميجابايت ، الرجاء اختيار صورة بحجم أقل" NotAllowedFileExtensionErrorText="امتداد الصورة غير مسموح به">
                                    </ValidationSettings>
                                    <ClientSideEvents FilesUploadStart="onFileUploadStart" FileUploadComplete="onFileUploadComplete" />
                                    <BrowseButton Text="اختيــــــــار">
                                    </BrowseButton>
                                    <CancelButton Text="إلغاء التحميل">
                                    </CancelButton>
                                    <NullTextStyle Font-Names="Cairo">
                                    </NullTextStyle>
                                </dx:ASPxUploadControl>
                            </div>
                        </EditItemTemplate>

                    </dx:GridViewDataColumn>

                    <dx:GridViewDataTextColumn Caption="وصف عرض النقاط" FieldName="description">
                        <PropertiesTextEdit>
                            <ValidationSettings RequiredField-IsRequired="true" SetFocusOnError="True" ErrorText="required." Display="Dynamic">
                                <RequiredField IsRequired="True"></RequiredField>
                            </ValidationSettings>
                        </PropertiesTextEdit>
                        <CellStyle VerticalAlign="Middle" HorizontalAlign="Center" />
                    </dx:GridViewDataTextColumn>

                    <dx:GridViewDataCheckColumn Caption="فعال" FieldName="isActive">
                        <PropertiesCheckEdit>
                            <ValidationSettings RequiredField-IsRequired="true" SetFocusOnError="True" ErrorText="required." Display="Dynamic">
                                <RequiredField IsRequired="True"></RequiredField>
                            </ValidationSettings>
                        </PropertiesCheckEdit>
                        <CellStyle HorizontalAlign="Center" VerticalAlign="Middle">
                        </CellStyle>
                    </dx:GridViewDataCheckColumn>


                    <dx:GridViewDataSpinEditColumn Caption="النقاط" FieldName="points">
                        <PropertiesSpinEdit DisplayFormatString="g" MaxValue="999999" NumberType="Integer">
                            <ValidationSettings Display="Dynamic" ErrorText="" SetFocusOnError="True">
                                <RequiredField IsRequired="True" />
                            </ValidationSettings>
                        </PropertiesSpinEdit>
                        <CellStyle HorizontalAlign="Center" VerticalAlign="Middle" Font-Bold="True" Font-Size="Larger">
                        </CellStyle>
                    </dx:GridViewDataSpinEditColumn>

                    <dx:GridViewDataSpinEditColumn Caption="مبلغ الخصم" FieldName="discountAmount">
                        <PropertiesSpinEdit DisplayFormatString="g" MaxValue="99999" NumberType="Float" Increment="0.1" LargeIncrement="1">
                            <ValidationSettings Display="Dynamic" ErrorText="" SetFocusOnError="True">
                                <RequiredField IsRequired="True" />
                            </ValidationSettings>
                        </PropertiesSpinEdit>
                        <CellStyle HorizontalAlign="Center" VerticalAlign="Middle" Font-Bold="True" Font-Size="Larger">
                        </CellStyle>
                    </dx:GridViewDataSpinEditColumn>

                    <dx:GridViewDataComboBoxColumn Caption="الدولة" FieldName="countryId">
                        <PropertiesComboBox DataSourceID="DB_Countries" TextField="countryName" ValueField="id" ValueType="System.Int32">
                            <ValidationSettings RequiredField-IsRequired="true" SetFocusOnError="True" ErrorText="required." Display="Dynamic">
                                <RequiredField IsRequired="True"></RequiredField>
                            </ValidationSettings>
                            <ItemStyle Font-Size="1.5em" />
                            <ClientSideEvents SelectedIndexChanged="onSelectedCountryChanged" />
                        </PropertiesComboBox>
                        <CellStyle VerticalAlign="Middle" HorizontalAlign="Center">
                        </CellStyle>
                    </dx:GridViewDataComboBoxColumn>

                    <dx:GridViewDataComboBoxColumn Caption="الشركة" FieldName="companyId">
                        <PropertiesComboBox DataSourceID="DB_Companies" ValueField="id" TextField="companyName" ValueType="System.Int32">
                            <ClientSideEvents EndCallback="onCityEndCallback" />
                            <ValidationSettings RequiredField-IsRequired="true" SetFocusOnError="True" ErrorText="required." Display="Dynamic">
                                <RequiredField IsRequired="True"></RequiredField>
                            </ValidationSettings>
                        </PropertiesComboBox>
                        <CellStyle VerticalAlign="Middle" HorizontalAlign="Center">
                        </CellStyle>
                    </dx:GridViewDataComboBoxColumn>

                    <dx:GridViewDataDateColumn Caption="التاريخ" FieldName="userDate" Width="7%">
                        <EditFormSettings Visible="False" />
                        <PropertiesDateEdit DisplayFormatString="dd/MM/yyyy"></PropertiesDateEdit>
                        <CellStyle VerticalAlign="Middle"></CellStyle>
                    </dx:GridViewDataDateColumn>

                    <dx:GridViewDataTextColumn Caption="" ShowInCustomizationForm="True" Width="100px">
                        <EditFormSettings Visible="False" />
                        <DataItemTemplate>
                            <div style="width: 100%; text-align: center;">
                                <img src="/assets/img/update.png" width="32" height="32" title="تعديل" style="cursor: pointer"
                                    onclick='<%# "GridPoints.PerformCallback(\"CheckOrders|" + Eval("id") + "|" + Container.VisibleIndex + "\");" %>' />
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

            <dx:ASPxPopupControl ID="popupActive" runat="server" ClientInstanceName="popupActive"
                HeaderText="تنبيه" Modal="true" CloseAction="CloseButton"
                PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter"
                ShowCloseButton="true" Width="400px"
                Font-Names="Cairo" Font-Size="1.2em">

                <HeaderStyle Font-Bold="True" Font-Names="Cairo" Font-Size="1.3em" />

                <ContentCollection>
                    <dx:PopupControlContentControl>
                        <div style="text-align: center; padding: 20px; font-family: 'Cairo', sans-serif; line-height: 1.4em; font-size: 1.2em;">
                            يوجد عرض نقاط سابق لنفس الشركة.
                            <br />
                            الرجاء الغاء عملية الادخال او التعديل ثم ايقاف العرض السابق لاكمال العملية.
           
                        </div>
                        <div style="text-align: center; margin-top: 20px;">
                            <dx:ASPxButton ID="btnClosePopup" runat="server" Text="اغلاق" AutoPostBack="False"
                                Font-Names="Cairo" Font-Size="1em"
                                ClientInstanceName="btnClosePopup"
                                ClientSideEvents-Click="function(s,e){popupActive.Hide();}" />
                        </div>
                    </dx:PopupControlContentControl>
                </ContentCollection>
            </dx:ASPxPopupControl>


            <asp:SqlDataSource
                ID="db_Points"
                runat="server"
                ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>"
                SelectCommand="SELECT [id], [countryId], [companyId], [points], [image], [description], [discountAmount], [isActive], [userDate] FROM [pointsOffers];"
                InsertCommand="INSERT INTO [pointsOffers] ([countryId], [companyId], [points], [image], [description], [discountAmount], [isActive], [userDate])
                                   VALUES (@countryId, @companyId, @points, @image, @description, @discountAmount, @isActive, getdate());"
                UpdateCommand="UPDATE [pointsOffers]
                   SET [countryId]   = @countryId,
                       [companyId]  = @companyId,
                       [points]  = @points,
                       [image]  = @image,
                       [description] = @description,
                       [discountAmount] = @discountAmount,
                       [isActive] = @isActive
                   WHERE [id] = @id;"
                DeleteCommand="
                        DELETE FROM pointsOffers WHERE id = @id;">
                <InsertParameters>
                    <asp:Parameter Name="countryId" Type="Int32" />
                    <asp:Parameter Name="companyId" Type="Int32" />
                    <asp:Parameter Name="points" Type="Int32" />
                    <asp:Parameter Name="description" Type="String" />
                    <asp:Parameter Name="discountAmount" Type="String" />
                    <asp:Parameter Name="isActive" Type="Int32" />
                    <asp:ControlParameter ControlID="l_item_file" Name="image" PropertyName="Text" />
                </InsertParameters>
                <UpdateParameters>
                    <asp:Parameter Name="countryId" Type="Int32" />
                    <asp:Parameter Name="companyId" Type="Int32" />
                    <asp:Parameter Name="points" Type="Int32" />
                    <asp:Parameter Name="description" Type="String" />
                    <asp:Parameter Name="discountAmount" Type="String" />
                    <asp:Parameter Name="isActive" Type="Int32" />
                    <asp:ControlParameter ControlID="l_item_file" Name="image" PropertyName="Text" Type="String" />
                </UpdateParameters>
            </asp:SqlDataSource>

            <asp:SqlDataSource ID="DB_Countries" runat="server" ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>" SelectCommand="SELECT * FROM countries where id <> 1000"></asp:SqlDataSource>

            <asp:SqlDataSource ID="DB_Companies" runat="server" ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>"
                SelectCommand="SELECT id,companyName FROM companies where id <> 1000"></asp:SqlDataSource>

            <asp:SqlDataSource ID="DB_Companies_Selected" runat="server" ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>"
                SelectCommand="SELECT id,companyName FROM companies where id <> 1000 and countryId=@countryId">
                <SelectParameters>
                    <asp:Parameter Name="countryId" />
                </SelectParameters>
            </asp:SqlDataSource>




            <dx:ASPxTextBox ID="l_item_file" runat="server" BackColor="Transparent" ClientInstanceName="l_item_file" Font-Size="0pt" ForeColor="Transparent" Text="" Width="0px" Theme="Default">
                <Border BorderStyle="None" BorderWidth="0px" />
            </dx:ASPxTextBox>
            <dx:ASPxTextBox ID="l_item_file_old" runat="server" BackColor="Transparent" ClientInstanceName="l_item_file_old" Font-Size="0pt" ForeColor="Transparent" Text="" Width="0px" Theme="Default">
                <Border BorderStyle="None" BorderWidth="0px" />
            </dx:ASPxTextBox>
            <dx:ASPxTextBox ID="l_item_file_check" runat="server" BackColor="Transparent" ClientInstanceName="l_item_file_check" Font-Size="0pt" ForeColor="Transparent" Text="0" Width="0px" Theme="Default">
                <Border BorderStyle="None" BorderWidth="0px" />
            </dx:ASPxTextBox>
        </div>
    </main>



</asp:Content>
