<%@ Page Title="Branches" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Companies.aspx.cs" Inherits="ShabAdmin.Companies" %>

<%@ Register Assembly="DevExpress.Web.v24.1, Version=24.1.6.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">


    <main>

        <script>
            var MyIndex;
            var gridNo;
            var minTime;

            function OnRowClick(e) {
                MyIndex = e.visibleIndex;
                GridCompanies.GetRowValues(MyIndex, 'id;minDeliveryTime', OnGetRowValues);
            }

            function OnGetRowValues(Value) {
                MyId = Value[0];
                minTime = Value[1];
            }

            function calcPercent(s, e) {
                s.SetMinValue(minTime + 5);
            }

            function onDeleteClick(visibleIndex) {
                GridCompanies.DeleteRow(visibleIndex);
            }

            function OnGridCompaniesEndCallback(s, e) {
                if (s.cpShowDeletePopup) {
                    Pop_Del_Grids.Show();
                    s.cpShowDeletePopup = null;
                }
            }

        </script>

        <div class="w-100 text-center my-4">
            <h2 class="pageTitle d-inline-block" style="font-family: Cairo">الشـــركات</h2>
            <div style="margin: 0 auto; font-size: 1.1em; font-family: cairo; color: #ff0000; margin-bottom: 0em; text-align: center">
                عروض النقاط وعدد النقاط : في حال (نعم) يمكن للمستخدم استبدال نقاطه عند الشراء في صفحة الدفع، كل 1000 نقطة سيتم خصم وحدة مالية واحدة (دينار مثلا) أقل قيمة 1000 وحتى 5000 نقطة         
            </div>
        </div>

        <div class="navbar-main navbar-expand-lg px-0 mx-4 border-radius-xl bg-white shadow mt-3 mb-1">



            <dx:ASPxGridView ID="GridCompanies" runat="server" DataSourceID="db_Companies" KeyFieldName="id" ClientInstanceName="GridCompanies" Width="100%" AutoGenerateColumns="False" EnablePagingCallbackAnimation="True" OnRowDeleting="GridCompanies_RowDeleting" Font-Names="cairo" Font-Size="1em" RightToLeft="True">
                <Settings ShowFooter="True" ShowFilterRow="True" />
                <ClientSideEvents EndCallback="OnGridCompaniesEndCallback" RowClick="function(s, e) {OnRowClick(e);}" RowDblClick="function(s, e) {setTimeout(function(){GridCompanies.StartEditRow(MyIndex);},100);}" />
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
                    <dx:GridViewDataColumn Caption="الرقم" FieldName="id" Width="1%">
                        <EditFormSettings Visible="False" />
                        <CellStyle VerticalAlign="Middle" HorizontalAlign="Center">
                        </CellStyle>
                    </dx:GridViewDataColumn>

                    <dx:GridViewDataTextColumn Caption="الشركة" FieldName="companyName" Width="15%">
                        <PropertiesTextEdit>
                            <ValidationSettings RequiredField-IsRequired="true" SetFocusOnError="True" ErrorText="حقل مطلوب" Display="Dynamic">
                                <RequiredField IsRequired="True"></RequiredField>
                            </ValidationSettings>
                        </PropertiesTextEdit>
                        <CellStyle VerticalAlign="Middle" HorizontalAlign="Center">
                        </CellStyle>
                    </dx:GridViewDataTextColumn>

                    <dx:GridViewDataComboBoxColumn Caption="البلد" FieldName="countryID">
                        <PropertiesComboBox
                            ClientInstanceName="comboCountry"
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

                    <dx:GridViewDataComboBoxColumn Caption="الحالة" FieldName="l_companyStatus">
                        <PropertiesComboBox DataSourceID="dsCompanyStatus" ValueField="id" TextField="description" ValueType="System.Int32">
                            <ValidationSettings RequiredField-IsRequired="true" SetFocusOnError="True" ErrorText="required." Display="Dynamic">
                                <RequiredField IsRequired="True"></RequiredField>
                            </ValidationSettings>
                        </PropertiesComboBox>
                        <CellStyle VerticalAlign="Middle" HorizontalAlign="Center">
                        </CellStyle>
                    </dx:GridViewDataComboBoxColumn>

                    <dx:GridViewDataSpinEditColumn Caption="الضريبة" FieldName="companyTax">
                        <PropertiesSpinEdit DisplayFormatString="{0:0.0} %" MaxLength="4" MaxValue="99.9" NumberType="Float" DecimalPlaces="1">
                            <ValidationSettings Display="Dynamic" ErrorText="required." SetFocusOnError="True">
                                <RequiredField IsRequired="True" />
                            </ValidationSettings>
                        </PropertiesSpinEdit>
                        <CellStyle HorizontalAlign="Center" VerticalAlign="Middle">
                        </CellStyle>
                    </dx:GridViewDataSpinEditColumn>


                    <dx:GridViewDataComboBoxColumn Caption="عروض النقاط" FieldName="isPointsOffer">
                        <PropertiesComboBox>
                            <Items>
                                <dx:ListEditItem Text="نعم" Value="True" />
                                <dx:ListEditItem Text="لا" Value="False" />
                            </Items>
                        </PropertiesComboBox>
                        <DataItemTemplate>
                            <%# Convert.ToBoolean(Eval("isPointsOffer")) ? "نعم" : "لا" %>
                        </DataItemTemplate>
                        <HeaderStyle Font-Bold="True" />
                        <CellStyle VerticalAlign="Middle" HorizontalAlign="Center" Font-Bold="True" Font-Size="Large" />
                    </dx:GridViewDataComboBoxColumn>

                    <dx:GridViewDataSpinEditColumn Caption="عدد النقاط" FieldName="pointsOffer">
                        <PropertiesSpinEdit DisplayFormatString="g" MaxLength="4" MinValue="1000" MaxValue="5000" NullText="1000">
                        </PropertiesSpinEdit>
                        <HeaderStyle Font-Bold="True" />
                        <CellStyle HorizontalAlign="Center" VerticalAlign="Middle" Font-Bold="True" Font-Size="Large">
                        </CellStyle>
                    </dx:GridViewDataSpinEditColumn>



                    <dx:GridViewDataSpinEditColumn Caption="قيمة التوصيل" FieldName="deliveryAmount">
                        <DataItemTemplate>
                            <%# Eval("deliveryAmount") + "</br>" + MainHelper.GetCurrency(Eval("countryId")) %>
                        </DataItemTemplate>
                        <PropertiesSpinEdit DisplayFormatString="g" MaxLength="4" MaxValue="1000">
                            <ValidationSettings Display="Dynamic" ErrorText="required." SetFocusOnError="True">
                                <RequiredField IsRequired="True" />
                            </ValidationSettings>
                        </PropertiesSpinEdit>
                        <CellStyle HorizontalAlign="Center" VerticalAlign="Middle">
                        </CellStyle>
                    </dx:GridViewDataSpinEditColumn>

                    <dx:GridViewDataSpinEditColumn Caption="أقل طلب" FieldName="minAmountOrder">
                        <DataItemTemplate>
                            <%# Eval("minAmountOrder") + "</br>" + MainHelper.GetCurrency(Eval("countryId")) %>
                        </DataItemTemplate>

                        <PropertiesSpinEdit DisplayFormatString="g" MaxLength="4" MaxValue="1000">
                            <ValidationSettings Display="Dynamic" ErrorText="required." SetFocusOnError="True">
                                <RequiredField IsRequired="True" />
                            </ValidationSettings>
                        </PropertiesSpinEdit>


                        <CellStyle HorizontalAlign="Center" VerticalAlign="Middle">
                        </CellStyle>
                    </dx:GridViewDataSpinEditColumn>


                    <dx:GridViewDataTextColumn FieldName="startHour" Caption="الدوام من">
                        <PropertiesTextEdit HelpText="مثال الساعة 8:30 صباحا تكتب (08:30)" HelpTextStyle-Font-Names="Cairo" HelpTextStyle-Font-Bold="true" HelpTextStyle-Font-Size="1em">
                            <ClientSideEvents Init="function(s,e){
                                var v = s.GetValue();
                                if(v && v.length == 4 && v.indexOf(':') == -1){
                                    s.SetValue(v.substring(0,2) + ':' + v.substring(2,4));
                                } else if(v && v.length == 3 && v.indexOf(':') == -1){
                                    s.SetValue('0' + v.substring(0,1) + ':' + v.substring(1,3));
                                }
                            }" />
                            <MaskSettings Mask="00:00" />
                            <ValidationSettings Display="Dynamic" ErrorText="Invalid time format" SetFocusOnError="True">
                                <RequiredField IsRequired="True" />
                                <RegularExpression ValidationExpression="^([0-1][0-9]|2[0-3]):[0-5][0-9]$" ErrorText="Enter valid time (00:00 - 23:59)" />
                            </ValidationSettings>
                        </PropertiesTextEdit>
                        <CellStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                    </dx:GridViewDataTextColumn>

                    <dx:GridViewDataTextColumn FieldName="endHour" Caption="الدوام إلى">
                        <PropertiesTextEdit HelpText="مثال الساعة 9:30 مساء تكتب (21:30)" HelpTextStyle-Font-Names="Cairo" HelpTextStyle-Font-Bold="true" HelpTextStyle-Font-Size="1em">
                            <ClientSideEvents Init="function(s,e){
                                var v = s.GetValue();
                                if(v && v.length == 4 && v.indexOf(':') == -1){
                                    s.SetValue(v.substring(0,2) + ':' + v.substring(2,4));
                                } else if(v && v.length == 3 && v.indexOf(':') == -1){
                                    s.SetValue('0' + v.substring(0,1) + ':' + v.substring(1,3));
                                }
                            }" />
                            <MaskSettings Mask="00:00" />
                            <ValidationSettings Display="Dynamic" ErrorText="Invalid time format" SetFocusOnError="True">
                                <RequiredField IsRequired="True" />
                                <RegularExpression ValidationExpression="^([0-1][0-9]|2[0-3]):[0-5][0-9]$" ErrorText="Enter valid time (00:00 - 23:59)" />
                            </ValidationSettings>
                        </PropertiesTextEdit>
                        <CellStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                    </dx:GridViewDataTextColumn>



                    <dx:GridViewDataSpinEditColumn Caption="الطلب من" FieldName="minDeliveryTime">
                        <PropertiesSpinEdit DisplayFormatString="{0} دقيقة" MaxLength="4" MaxValue="480">

                            <ValidationSettings Display="Dynamic" ErrorText="required." SetFocusOnError="True">
                                <RequiredField IsRequired="True" />
                            </ValidationSettings>
                        </PropertiesSpinEdit>


                        <CellStyle HorizontalAlign="Center" VerticalAlign="Middle">
                        </CellStyle>
                    </dx:GridViewDataSpinEditColumn>

                    <dx:GridViewDataSpinEditColumn Caption="الطلب إلى" FieldName="maxDeliveryTime">
                        <PropertiesSpinEdit DisplayFormatString="{0} دقيقة" MaxLength="4" MaxValue="480">
                            <ClientSideEvents ValueChanged="function(s, e) {
                                 calcPercent(s, e);
                             }" />
                            <ValidationSettings Display="Dynamic" ErrorText="required." SetFocusOnError="True">
                                <RequiredField IsRequired="True" />
                            </ValidationSettings>
                        </PropertiesSpinEdit>


                        <CellStyle HorizontalAlign="Center" VerticalAlign="Middle">
                        </CellStyle>
                    </dx:GridViewDataSpinEditColumn>

                    <dx:GridViewDataComboBoxColumn Caption="مرئية" FieldName="isVisible">
                        <PropertiesComboBox>
                            <Items>
                                <dx:ListEditItem Text="نعم" Value="True" />
                                <dx:ListEditItem Text="لا" Value="False" />
                            </Items>
                            <ValidationSettings RequiredField-IsRequired="true" SetFocusOnError="True" ErrorText="حقل مطلوب" Display="Dynamic">
                                <RequiredField IsRequired="True"></RequiredField>
                            </ValidationSettings>
                        </PropertiesComboBox>
                        <DataItemTemplate>
                            <%# Convert.ToBoolean(Eval("isVisible")) ? "نعم" : "لا" %>
                        </DataItemTemplate>
                        <CellStyle VerticalAlign="Middle" HorizontalAlign="Center" />
                    </dx:GridViewDataComboBoxColumn>

                    <dx:GridViewDataTextColumn Caption="" ShowInCustomizationForm="True" Width="100px">
                        <EditFormSettings Visible="False" />
                        <DataItemTemplate>
                            <div style="width: 100%; float: left; text-align: center">
                                <img src="/assets/img/update.png" width="32" height="32" title="تعديل" style="cursor: pointer" onclick="setTimeout(function(){GridCompanies.StartEditRow(MyIndex);},100);" />
                                <img src="/assets/img/delete.png" width="32" height="32" title="حذف" style="cursor: pointer" onclick="setTimeout(function(){GridCompanies.DeleteRow(MyIndex);},100);" />

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
                ID="db_Companies"
                runat="server"
                ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>"
                SelectCommand="SELECT [id], [companyName], [countryID], [companyTax], [isVisible], 
   [l_companyStatus], [minAmountOrder], [deliveryAmount], [minDeliveryTime], 
   [maxDeliveryTime], [pointsOffer], [isPointsOffer], [startHour], [endHour]
   FROM [companies] 
   WHERE id != 1000"
                InsertCommand="INSERT INTO [companies] 
                   ([companyName], [countryID], [companyTax], [isVisible], [l_companyStatus], [minAmountOrder], [deliveryAmount], [minDeliveryTime], [maxDeliveryTime], [pointsOffer], [isPointsOffer], [startHour], [endHour], [userDate]) 
                   VALUES 
                   (@companyName, @countryID, @companyTax, @isVisible, @l_companyStatus, @minAmountOrder, @deliveryAmount, @minDeliveryTime, @maxDeliveryTime, @pointsOffer, @isPointsOffer, @startHour, @endHour, getdate());"
                UpdateCommand="UPDATE [companies] 
                   SET [companyName] = @companyName, 
                       [countryID] = @countryID, 
                       [companyTax] = @companyTax, 
                       [isVisible] = @isVisible, 
                       [l_companyStatus] = @l_companyStatus, 
                       [minAmountOrder] = @minAmountOrder, 
                       [deliveryAmount] = @deliveryAmount, 
                       [minDeliveryTime] = @minDeliveryTime, 
                       [maxDeliveryTime] = @maxDeliveryTime,
                       [pointsOffer] = @pointsOffer,
                       [isPointsOffer] = @isPointsOffer,
                       [startHour] = @startHour,
                       [endHour] = @endHour
                WHERE [id] = @id;"
                DeleteCommand="DELETE FROM [companies] WHERE [id] = @id;">

                <InsertParameters>
                    <asp:Parameter Name="companyName" Type="String" />
                    <asp:Parameter Name="companyTax" Type="String" />
                    <asp:Parameter Name="minAmountOrder" Type="String" />
                    <asp:Parameter Name="minDeliveryTime" Type="String" />
                    <asp:Parameter Name="maxDeliveryTime" Type="String" />
                    <asp:Parameter Name="deliveryAmount" Type="String" />
                    <asp:Parameter Name="countryID" Type="String" />
                    <asp:Parameter Name="isVisible" Type="String" />
                    <asp:Parameter Name="l_companyStatus" Type="String" />
                    <asp:Parameter Name="pointsOffer" Type="String" DefaultValue="1000" />
                    <asp:Parameter Name="isPointsOffer" Type="String" DefaultValue="0" />
                    <asp:Parameter Name="startHour" Type="String" />
                    <asp:Parameter Name="endHour" Type="String" />
                </InsertParameters>

                <UpdateParameters>
                    <asp:Parameter Name="companyName" Type="String" />
                    <asp:Parameter Name="companyTax" Type="String" />
                    <asp:Parameter Name="minAmountOrder" Type="String" />
                    <asp:Parameter Name="minDeliveryTime" Type="String" />
                    <asp:Parameter Name="maxDeliveryTime" Type="String" />
                    <asp:Parameter Name="deliveryAmount" Type="String" />
                    <asp:Parameter Name="countryID" Type="String" />
                    <asp:Parameter Name="isVisible" Type="String" />
                    <asp:Parameter Name="l_companyStatus" Type="String" />
                    <asp:Parameter Name="pointsOffer" Type="String" DefaultValue="1000" />
                    <asp:Parameter Name="isPointsOffer" Type="String" DefaultValue="0" />
                    <asp:Parameter Name="startHour" Type="String" />
                    <asp:Parameter Name="endHour" Type="String" />
                    <asp:Parameter Name="id" Type="Int32" />
                </UpdateParameters>

                <DeleteParameters>
                    <asp:Parameter Name="id" Type="Int32" />
                </DeleteParameters>
            </asp:SqlDataSource>


            <asp:SqlDataSource
                ID="dsCountries"
                runat="server"
                ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>"
                SelectCommand="SELECT id, countryName FROM countries where id != 1000"></asp:SqlDataSource>

            <asp:SqlDataSource
                ID="dsCompanyStatus"
                runat="server"
                ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>"
                SelectCommand="SELECT id, description FROM L_CompanyStatus"></asp:SqlDataSource>
        </div>



    </main>


    <dx:ASPxPopupControl runat="server"
        PopupHorizontalAlign="WindowCenter"
        PopupVerticalAlign="WindowCenter"
        AutoUpdatePosition="True"
        Modal="True"
        ClientInstanceName="Pop_Del_Grids"
        CloseAnimationType="Slide"
        HeaderText="تنبيه"
        Font-Names="Cairo"
        Width="500px"
        Height="300px"
        ID="Pop_Del_Compnies">

        <ContentCollection>
            <dx:PopupControlContentControl runat="server">
                <div style="padding: 10px; font-family: 'Cairo', sans-serif; text-align: center;">
                    <div style="text-align: center">
                        <img src="assets/img/danger.png" height="60px" alt="danger" />
                    </div>
                    <dx:ASPxLabel runat="server"
                        ClientInstanceName="labelCompnies"
                        Font-Names="Cairo"
                        Font-Size="Medium"
                        ForeColor="#333333"
                        EncodeHtml="False"
                        ID="labelCompnies"
                        Text="لا يمكن حذف هذه الشركة لأنها تحتوي على منتجات مرتبطة بها <br>أو لديها فروع أو مجموعات مرتبطة بها.<br><br><b>الرجاء حذفها بالكامل ليتم حذف الشركة أولا</b>.">
                    </dx:ASPxLabel>

                    <div style="margin-top: 20px;">
                        <dx:ASPxButton ID="Btn_Close_Compnies" runat="server"
                            AutoPostBack="False" Text="إغلاق"
                            Font-Names="Cairo">
                            <ClientSideEvents Click="function(s, e) { Pop_Del_Grids.Hide(); }" />
                        </dx:ASPxButton>
                    </div>
                </div>
            </dx:PopupControlContentControl>
        </ContentCollection>
    </dx:ASPxPopupControl>





</asp:Content>
