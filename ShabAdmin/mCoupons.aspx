<%@ Page Title="Points" Language="C#" MasterPageFile="~/mSite.Master" AutoEventWireup="true" CodeBehind="mCoupons.aspx.cs" Inherits="ShabAdmin.mCoupons" %>

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
            var MyId;
            var MyIndex;
            var MyIndexDetail;

            function OnRowClick(s, e) {
                MyIndex = e.visibleIndex;
                GridCoupons.GetRowValues(e.visibleIndex, 'id', OnGetRowValues);
            }

            function OnGetRowValues(Value) {
                MyId = Value[0];
            }

            function CheckCouponCode(val, control) {
                if (!val) return;
                cbCheckCoupon.PerformCallback(val);
            }

        </script>

        <div class="w-100 text-center my-4">
            <h2 class="pageTitle d-inline-block" style="font-family: Cairo">القسائم</h2>
        </div>

        <dx:ASPxPageControl ID="pageTab" runat="server" CssClass="divSTARProviders" ActiveTabIndex="0" ClientInstanceName="pageTab" Theme="Material" Width="100%" EnableCallbackAnimation="True">
            <TabPages>
                <dx:TabPage Text="قسائم المستخدمين" TabStyle-Font-Bold="true" TabStyle-Font-Names="cairo" TabStyle-Font-Size="X-Large">
                    <TabStyle Font-Bold="True" Font-Names="cairo" Font-Size="X-Large"></TabStyle>
                    <ContentCollection>
                        <dx:ContentControl>
                            <div class="navbar-main navbar-expand-lg px-0 mx-4 border-radius-xl bg-white shadow mt-3 mb-1">

                                <dx:ASPxGridView ID="GridCoupons" runat="server" DataSourceID="db_Coupons" KeyFieldName="id" ClientInstanceName="GridCoupons" Width="100%" AutoGenerateColumns="False" EnablePagingCallbackAnimation="True" Font-Names="cairo" Font-Size="1em" RightToLeft="True">
                                    <Settings ShowFilterRow="True" ShowFilterRowMenu="False" ShowHeaderFilterButton="False" AutoFilterCondition="Contains" />

                                    <ClientSideEvents RowClick="OnRowClick" RowDblClick="function(s, e) {setTimeout(function(){GridCoupons.StartEditRow(MyIndex);},100);}" />
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

                                        <dx:GridViewDataColumn Caption="الدولة" FieldName="countryName">
                                            <CellStyle VerticalAlign="Middle" HorizontalAlign="Center">
                                            </CellStyle>
                                            <EditFormSettings Visible="False" />
                                        </dx:GridViewDataColumn>

                                        <dx:GridViewDataComboBoxColumn Caption="إسم المستخدم" FieldName="username">
                                            <PropertiesComboBox DataSourceID="DB_UsersApp" TextField="userFullName" ValueField="username" ValueType="System.String" EncodeHtml="False">
                                                <ValidationSettings RequiredField-IsRequired="true" SetFocusOnError="True" ErrorText="required." Display="Dynamic">
                                                    <RequiredField IsRequired="True"></RequiredField>
                                                </ValidationSettings>
                                                <ItemStyle Font-Size="1.5em" />
                                            </PropertiesComboBox>
                                            <CellStyle VerticalAlign="Middle" HorizontalAlign="Center">
                                            </CellStyle>
                                        </dx:GridViewDataComboBoxColumn>

                                        <dx:GridViewDataTextColumn Caption="رمز القسيمة" FieldName="couponCode">
                                            <PropertiesTextEdit>
                                                <ValidationSettings RequiredField-IsRequired="true" SetFocusOnError="True" ErrorText="required." Display="Dynamic">
                                                    <RequiredField IsRequired="True"></RequiredField>
                                                </ValidationSettings>
                                            </PropertiesTextEdit>
                                            <CellStyle VerticalAlign="Middle" HorizontalAlign="Center" />
                                        </dx:GridViewDataTextColumn>

                                        <dx:GridViewDataTextColumn Caption="وصف القسيمة" FieldName="description">
                                            <PropertiesTextEdit>
                                                <ValidationSettings RequiredField-IsRequired="true" SetFocusOnError="True" ErrorText="required." Display="Dynamic">
                                                    <RequiredField IsRequired="True"></RequiredField>
                                                </ValidationSettings>
                                            </PropertiesTextEdit>
                                            <CellStyle VerticalAlign="Middle" HorizontalAlign="Center" />
                                        </dx:GridViewDataTextColumn>

                                        <dx:GridViewDataComboBoxColumn Caption="نسبة أو مبلغ" FieldName="l_discountType">
                                            <PropertiesComboBox DataSourceID="DB_DiscountType" TextField="description" ValueField="id" ValueType="System.Int32">
                                                <ValidationSettings RequiredField-IsRequired="true" SetFocusOnError="True" ErrorText="required." Display="Dynamic">
                                                    <RequiredField IsRequired="True"></RequiredField>
                                                </ValidationSettings>
                                                <ItemStyle Font-Size="1.5em" />
                                            </PropertiesComboBox>
                                            <CellStyle VerticalAlign="Middle" HorizontalAlign="Center">
                                            </CellStyle>
                                        </dx:GridViewDataComboBoxColumn>

                                        <dx:GridViewDataComboBoxColumn Caption="نوع القسيمة" FieldName="l_couponTypeId">
                                            <PropertiesComboBox DataSourceID="db_CouponType" TextField="description" ValueField="id" ValueType="System.Int32">
                                                <ValidationSettings RequiredField-IsRequired="true" SetFocusOnError="True" ErrorText="required." Display="Dynamic">
                                                    <RequiredField IsRequired="True"></RequiredField>
                                                </ValidationSettings>
                                                <ItemStyle Font-Size="1.5em" />
                                            </PropertiesComboBox>
                                            <CellStyle VerticalAlign="Middle" HorizontalAlign="Center">
                                            </CellStyle>
                                        </dx:GridViewDataComboBoxColumn>

                                        <dx:GridViewDataSpinEditColumn Caption="قيمة الخصم" FieldName="discountAmount">
                                            <PropertiesSpinEdit DisplayFormatString="g" MaxValue="1000" NumberType="Float">
                                                <ValidationSettings Display="Dynamic" ErrorText="" SetFocusOnError="True">
                                                    <RequiredField IsRequired="True" />
                                                </ValidationSettings>
                                            </PropertiesSpinEdit>
                                            <DataItemTemplate>
                                                <%# Convert.ToDecimal(Eval("l_discountType")) == 1 ? Eval("discountAmount") : Convert.ToInt32(Eval("discountAmount")) + " % "  %>
                                            </DataItemTemplate>
                                            <CellStyle HorizontalAlign="Center" VerticalAlign="Middle" Font-Bold="True" Font-Size="X-Large" ForeColor="#00822B">
                                            </CellStyle>
                                        </dx:GridViewDataSpinEditColumn>


                                        <dx:GridViewDataCheckColumn Caption="تم استخدامها" FieldName="isUsed">
                                            <EditFormSettings Visible="False" />
                                            <PropertiesCheckEdit>
                                                <ValidationSettings RequiredField-IsRequired="true" SetFocusOnError="True" ErrorText="required." Display="Dynamic">
                                                    <RequiredField IsRequired="True"></RequiredField>
                                                </ValidationSettings>
                                            </PropertiesCheckEdit>
                                            <CellStyle HorizontalAlign="Center" VerticalAlign="Middle">
                                            </CellStyle>
                                        </dx:GridViewDataCheckColumn>

                                        <dx:GridViewDataDateColumn Caption="التاريخ" FieldName="userDate" Width="9%">
                                            <EditFormSettings Visible="False" />
                                            <PropertiesDateEdit DisplayFormatString="dd/MM/yyyy"></PropertiesDateEdit>
                                            <CellStyle VerticalAlign="Middle"></CellStyle>
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
                                    ID="db_Coupons"
                                    runat="server"
                                    ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>"
                                    SelectCommand="SELECT cp.id, (select c.countryName from countries c where c.countryCode = (select u.countryCode from usersApp u where u.username = cp.username)) as countryName, cp.username, cp.couponCode, cp.description, cp.discountAmount,cp.l_couponTypeId, cp.l_discountType, cp.isUsed, cp.userDate FROM [coupons] cp Where cp.id <> 1 and cp.username <> '0' order by id desc; "
                                    InsertCommand="INSERT INTO [coupons] ([username], [couponCode], [description], [discountAmount], [l_discountType], [userDate])
                                   VALUES (@username, @couponCode, @description, @discountAmount, @l_discountType, getdate());"
                                    UpdateCommand="UPDATE [coupons]
                                   SET [username]   = @username,
                                       [couponCode]  = @couponCode,
                                       [description]  = @description,
                                       [discountAmount]  = @discountAmount,
                                       [l_discountType] = @l_discountType
                                   WHERE [id] = @id;"
                                    DeleteCommand="
                        DELETE FROM coupons WHERE id = @id;">
                                    <InsertParameters>
                                        <asp:Parameter Name="username" Type="String" />
                                        <asp:Parameter Name="couponCode" Type="String" />
                                        <asp:Parameter Name="description" Type="String" />
                                        <asp:Parameter Name="discountAmount" Type="String" />
                                        <asp:Parameter Name="l_discountType" Type="String" />
                                    </InsertParameters>
                                    <UpdateParameters>
                                        <asp:Parameter Name="username" Type="String" />
                                        <asp:Parameter Name="couponCode" Type="String" />
                                        <asp:Parameter Name="description" Type="String" />
                                        <asp:Parameter Name="discountAmount" Type="String" />
                                        <asp:Parameter Name="l_discountType" Type="String" />
                                    </UpdateParameters>
                                </asp:SqlDataSource>

                                <asp:SqlDataSource ID="DB_UsersApp" runat="server" ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>"
                                    SelectCommand="SELECT '<b>' + firstName + ' ' + lastName + '</b> <br>( ' + username + ' ) ' as userFullName, username FROM usersApp"></asp:SqlDataSource>
                                <asp:SqlDataSource ID="DB_DiscountType" runat="server" ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>"
                                    SelectCommand="SELECT id, description FROM L_DiscountType"></asp:SqlDataSource>
                            </div>
                        </dx:ContentControl>
                    </ContentCollection>
                </dx:TabPage>

                <dx:TabPage Text="المستخدمين" TabStyle-Font-Bold="true" TabStyle-Font-Names="cairo" TabStyle-Font-Size="X-Large">
                    <TabStyle Font-Bold="True" Font-Names="cairo" Font-Size="X-Large"></TabStyle>
                    <ContentCollection>
                        <dx:ContentControl>

                            <div class="navbar-main navbar-expand-lg px-0 mx-4 border-radius-xl bg-white shadow mt-3 mb-1">

                                <div style="margin: 0 auto; text-align: center; width: 70%; padding: 1em; display: flex; gap: 2%; align-items: flex-start; flex-wrap: wrap;">



                                    <div style="flex: 1; min-width: 280px; padding: 1em;">
                                        <dx:ASPxComboBox ID="notificationList" runat="server"
                                            Font-Names="cairo" Width="100%"
                                            TextField="type" ValueField="id" ValueType="System.Int32"
                                            EncodeHtml="false" Font-Bold="True" Font-Size="X-Large"
                                            ClientInstanceName="notificationList"
                                            DataSourceID="DB_L_SpecialCouponsList"
                                            OnCallback="notificationList_Callback"
                                            NullText="نوع القسيمة" HorizontalAlign="Center"
                                            DropDownRows="4">

                                            <ClientSideEvents
                                                SelectedIndexChanged="function(s,e){
            var v = s.GetValue();
            if (typeof(GridUsersApp) !== 'undefined')
                GridUsersApp.PerformCallback(v ? ('filter|' + v) : 'filter|');
        }" />
                                            <ListBoxStyle Font-Size="Medium">
                                            </ListBoxStyle>
                                            <ValidationSettings Display="Dynamic" SetFocusOnError="True" ValidationGroup="notificationGroup">
                                                <RequiredField IsRequired="True" />
                                            </ValidationSettings>
                                        </dx:ASPxComboBox>


                                        <asp:SqlDataSource
                                            ID="DB_L_SpecialCouponsList"
                                            runat="server"
                                            ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>"
                                            SelectCommand="
        SELECT 
            n.id,
            N'&lt;span style=&quot;font-size:1.2em; color:#009933&quot;&gt;' + ISNULL(ct.description, N'') + N'&lt;/span&gt;'
            + CASE WHEN NULLIF(LTRIM(RTRIM(n.couponCode)), N'') IS NOT NULL 
                   THEN N'&lt;br /&gt; - الكود: ' + n.couponCode ELSE N'' END
            + CASE WHEN NULLIF(LTRIM(RTRIM(n.[description])), N'') IS NOT NULL 
                   THEN N'&lt;br /&gt; - الوصف: ' + n.[description] ELSE N'' END
            + CASE WHEN NULLIF(LTRIM(RTRIM(c.countryName)), N'') IS NOT NULL
                   THEN N'&lt;br /&gt; - البلد: ' + c.countryName ELSE N'' END
            AS [type]
        FROM dbo.coupons AS n
        INNER JOIN dbo.l_CouponType AS ct ON ct.id = n.l_CouponTypeId
        LEFT JOIN dbo.countries AS c ON c.id = n.countryId
        WHERE n.l_CouponTypeId &lt;&gt; 1
          AND n.username = '0'
        ORDER BY n.id DESC"></asp:SqlDataSource>


                                        <dx:ASPxCheckBox ID="checkAll" runat="server" ClientInstanceName="checkAll"
                                            Font-Names="cairo" Font-Size="X-Large" ForeColor="#009900"
                                            Text="كامل المستخدمين التابعين لدولة القسيمة" Layout="Flow" TextSpacing="10px">
                                            <ClientSideEvents ValueChanged="function(s, e) { 
                                                   if (s.GetChecked()) {
                                                        $('#showGridDisabled').show(700);                                                      
                                                    } else {
                                                         $('#showGridDisabled').hide(300);    
                                                    }                                                    
                           
                                                }" />
                                        </dx:ASPxCheckBox>
                                    </div>

                                    <div style="flex: 1; min-width: 280px; padding: 1em;">
                                        <dx:ASPxButton ID="sendNotifications" Width="100%" CssClass="top" ClientInstanceName="sendNotifications" Height="64px"
                                            runat="server" Text="إرســــــال" AutoPostBack="False" CausesValidation="False" UseSubmitBehavior="False"
                                            Font-Bold="True" Font-Size="XX-Large" Font-Names="cairo">
                                            <ClientSideEvents Click="function(s, e){ 
                  if (!ASPxClientEdit.ValidateGroup('notificationGroup')) return;
                  var couponId = notificationList.GetValue();
                  var all = (typeof checkAll !== 'undefined' && checkAll.GetChecked()) ? '|all' : '';
                  s.SetText('الرجاء الانتظار...'); setTimeout(function(){ s.SetEnabled(false); },1);
                  GridUsersApp.PerformCallback('insert|' + couponId + all);
              }" />
                                            <Border BorderColor="Silver" BorderStyle="Solid" BorderWidth="2px" />
                                        </dx:ASPxButton>
                                    </div>
                                </div>

                                <div style="margin: 0 auto; width: 100%;">
                                    <style>
                                        .parent-container {
                                            position: relative;
                                        }


                                        .overlay-div {
                                            position: absolute;
                                            top: 0;
                                            left: 0;
                                            width: 100%;
                                            height: 100%;
                                            display: none;
                                            color: white;
                                            border: 3px solid #484848;
                                            border-radius: 0.5em;
                                            vertical-align: top;
                                            padding-top: 2.1em;
                                            font-family: cairo;
                                            font-size: 2.5em;
                                            background-color: rgba(81, 81, 81, 0.8);
                                            z-index: 10;
                                            justify-content: center;
                                            align-items: center;
                                        }

                                        .dxgv td {
                                            text-align: center;
                                            vertical-align: middle;
                                        }
                                    </style>

                                    <div class="parent-container">
                                        <div class="content-div">
                                            <dx:ASPxGridView ID="GridUsersApp" runat="server" DataSourceID="db_UsersApp1" KeyFieldName="id"
                                                ClientInstanceName="GridUsersApp" Width="100%" AutoGenerateColumns="False"
                                                EnablePagingCallbackAnimation="True" Font-Names="cairo" Font-Size="1em" RightToLeft="True"
                                                OnCustomCallback="GridUsersApp_CustomCallback" OnBeforePerformDataSelect="GridUsersApp_BeforePerformDataSelect">

                                                <ClientSideEvents EndCallback="function(s, e) { 
    if (s.cpResult == '0'){ 
        Pop_DetailsNote.Show();
    }
    sendNotifications.SetText('إرســــــال');
    sendNotifications.SetEnabled(true);

     if (s.cpRefreshCoupons === '1' && s.cpResult != '0') {
         if (typeof(GridCoupons) !== 'undefined') {
             GridCoupons.Refresh();
         }
         delete s.cpRefreshCoupons;

         checkAll.SetChecked(false);
         notificationList.PerformCallback();
         $('#showGridDisabled').hide(300);  
         Pop_Inserted.Show();                         
     }

     delete s.cpResult; // تنظيف

       
}" />
                                                <Settings ShowFilterRow="True" ShowFilterRowMenu="True" ShowHeaderFilterButton="False" AutoFilterCondition="Contains" />
                                                <SettingsAdaptivity AdaptivityMode="HideDataCells"></SettingsAdaptivity>
                                                <Settings ShowFooter="True" />
                                                <SettingsBehavior AllowSelectByRowClick="True" />
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
                                                    <dx:GridViewCommandColumn ShowSelectCheckbox="True" ShowClearFilterButton="true" SelectAllCheckboxMode="AllPages" />

                                                    <dx:GridViewDataColumn Caption="الرقم" FieldName="id">
                                                        <EditFormSettings Visible="False" />
                                                        <CellStyle VerticalAlign="Middle" HorizontalAlign="Center"></CellStyle>
                                                    </dx:GridViewDataColumn>

                                                    <dx:GridViewDataColumn Caption="Token" FieldName="FCMToken" Visible="False">
                                                        <EditFormSettings Visible="False" />
                                                        <CellStyle VerticalAlign="Middle" HorizontalAlign="Center"></CellStyle>
                                                    </dx:GridViewDataColumn>

                                                    <dx:GridViewDataComboBoxColumn Caption="الدولة" FieldName="countryId">
                                                        <PropertiesComboBox DataSourceID="DB_Countries" TextField="countryName" ValueField="id" ValueType="System.Int32" />
                                                        <CellStyle VerticalAlign="Middle" HorizontalAlign="Center" />
                                                    </dx:GridViewDataComboBoxColumn>

                                                    <dx:GridViewDataTextColumn FieldName="username" Visible="False">
                                                        <EditFormSettings Visible="False" />
                                                    </dx:GridViewDataTextColumn>

                                                    <dx:GridViewDataSpinEditColumn Caption="الرصيد" FieldName="balance">
                                                        <PropertiesSpinEdit DisplayFormatString="g"></PropertiesSpinEdit>
                                                        <CellStyle HorizontalAlign="Center" VerticalAlign="Middle" Font-Bold="True" Font-Size="Larger"></CellStyle>
                                                    </dx:GridViewDataSpinEditColumn>

                                                    <dx:GridViewDataComboBoxColumn Caption="المستوى" FieldName="l_userLevelId">
                                                        <PropertiesComboBox DataSourceID="DB_UserLevel" TextField="description" ValueField="id" ValueType="System.Int32" />
                                                        <CellStyle HorizontalAlign="Center" VerticalAlign="Middle" Font-Bold="True" Font-Size="Larger"></CellStyle>
                                                    </dx:GridViewDataComboBoxColumn>

                                                    <dx:GridViewDataSpinEditColumn Caption="النقاط" FieldName="userPoints">
                                                        <PropertiesSpinEdit DisplayFormatString="g"></PropertiesSpinEdit>
                                                        <CellStyle HorizontalAlign="Center" VerticalAlign="Middle" Font-Bold="True" Font-Size="Larger"></CellStyle>
                                                    </dx:GridViewDataSpinEditColumn>

                                                    <dx:GridViewDataColumn Caption="المنصة" FieldName="userPlatform">
                                                        <CellStyle HorizontalAlign="Center" VerticalAlign="Middle"></CellStyle>
                                                    </dx:GridViewDataColumn>

                                                    <dx:GridViewDataDateColumn Caption="التاريخ" FieldName="userDate" Width="7%">
                                                        <EditFormSettings Visible="False" />
                                                        <PropertiesDateEdit DisplayFormatString="dd/MM/yyyy" />
                                                        <CellStyle VerticalAlign="Middle"></CellStyle>
                                                    </dx:GridViewDataDateColumn>

                                                    <dx:GridViewDataTextColumn Caption="إسم المستخدم" FieldName="userFullName" ShowInCustomizationForm="True" VisibleIndex="2">
                                                        <PropertiesTextEdit EncodeHtml="False"></PropertiesTextEdit>
                                                        <CellStyle HorizontalAlign="Center" VerticalAlign="Middle"></CellStyle>
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
                                                    <AlternatingRow BackColor="#F0F0F0"></AlternatingRow>
                                                    <Footer Font-Names="cairo"></Footer>
                                                </Styles>
                                                <Paddings Padding="2em" />
                                            </dx:ASPxGridView>
                                        </div>

                                        <div id="showGridDisabled" class="overlay-div">
                                            تم اختيار إرسال القسائم إلى جميع المستخدمين التابعين لدولة القسيمة
                                        </div>
                                    </div>
                                    <asp:SqlDataSource
                                        ID="db_UsersApp1"
                                        runat="server"
                                        ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>"
                                        CancelSelectOnNullParameter="false"
                                        SelectCommand="
SELECT 
    c.id AS countryId,
    u.username, 
    u.id, 
    u.balance, 
    N'&lt;b&gt;' + firstName + N' ' + lastName + N'&lt;/b&gt; &lt;br&gt;( ' + username + N' ) ' as userFullName, 
    u.l_userLevelId, 
    u.userPoints, 
    u.userPlatform, 
    u.FCMToken,  
    u.userDate
FROM usersApp u
JOIN countries c ON u.countryCode = c.countryCode
WHERE 
    u.isActive = 1 
    AND u.isDeleted = 0
    AND (
         @countryCode IS NULL 
         OR @countryCode = N'' 
         OR u.countryCode = @countryCode
    )
    AND NOT EXISTS (
        SELECT 1 
        FROM coupons cu
        WHERE cu.username = u.username
          AND cu.couponCode = @couponCode
    )
ORDER BY u.id DESC">
                                        <SelectParameters>
                                            <asp:Parameter Name="countryCode" Type="String" DefaultValue="" />
                                            <asp:Parameter Name="couponCode" Type="String" DefaultValue="" />
                                        </SelectParameters>
                                    </asp:SqlDataSource>


                                    <asp:SqlDataSource ID="DB_Countries" runat="server" ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>"
                                        SelectCommand="SELECT id, countryName FROM countries where id <> 1000"></asp:SqlDataSource>

                                    <asp:SqlDataSource ID="DB_UserLevel" runat="server" ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>"
                                        SelectCommand="SELECT id, description FROM L_UserLevel"></asp:SqlDataSource>

                                    <dx:ASPxPopupControl runat="server" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter"
                                        AutoUpdatePosition="True" Modal="True" ClientInstanceName="Pop_DetailsNote" CloseAnimationType="Slide"
                                        FooterText="" HeaderText="حذف إشعار" Font-Names="Cairo" MinWidth="350px" MinHeight="150px" Width="350px" Height="150px" ID="Pop_DetailsNote">
                                        <ContentCollection>
                                            <dx:PopupControlContentControl runat="server">
                                                <div style="padding: 20px; font-family: 'Cairo', sans-serif; text-align: center">
                                                    <div class="mb-3" style="width: 100%;">
                                                        <dx:ASPxLabel runat="server" Text="الرجاء اختيار مستخدمين حتى يتم إرسال القسائم" ClientInstanceName="labelProducts"
                                                            Font-Names="Cairo" Font-Size="Large" ForeColor="#333333" ID="ASPxLabel2">
                                                        </dx:ASPxLabel>
                                                    </div>
                                                    <div style="width: 100%; margin-top: 20px; text-align: center;">
                                                        <dx:ASPxButton ID="ASPxButton4" runat="server" AutoPostBack="False" Text="إغـــــــــــلاق"
                                                            UseSubmitBehavior="False" Font-Names="Cairo" HorizontalAlign="Center" VerticalAlign="Middle"
                                                            Style="margin-right: 20px;">
                                                            <ClientSideEvents Click="function(s, e) {Pop_DetailsNote.Hide();}" />
                                                        </dx:ASPxButton>
                                                    </div>
                                                </div>
                                            </dx:PopupControlContentControl>
                                        </ContentCollection>
                                    </dx:ASPxPopupControl>

                                    <dx:ASPxPopupControl runat="server" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter"
                                        AutoUpdatePosition="True" Modal="True" ClientInstanceName="Pop_Inserted" CloseAnimationType="Slide"
                                        FooterText="" HeaderText="تعيين القسيمة" Font-Names="Cairo" MinWidth="350px" MinHeight="150px" Width="350px" Height="150px" ID="Pop_Inserted">
                                        <ContentCollection>
                                            <dx:PopupControlContentControl runat="server">
                                                <div style="padding: 20px; font-family: 'Cairo', sans-serif; text-align: center">
                                                    <div class="mb-3" style="width: 100%;">
                                                        <dx:ASPxLabel runat="server" Text="تم تعيين القسيمة بنجاح إلى المستخدمين المختارين." ClientInstanceName="labelProducts"
                                                            Font-Names="Cairo" Font-Size="Large" ForeColor="#333333" ID="ASPxLabel3">
                                                        </dx:ASPxLabel>
                                                    </div>
                                                    <div style="width: 100%; margin-top: 20px; text-align: center;">
                                                        <dx:ASPxButton ID="ASPxButton5" runat="server" AutoPostBack="False" Text="إغـــــــــــلاق"
                                                            UseSubmitBehavior="False" Font-Names="Cairo" HorizontalAlign="Center" VerticalAlign="Middle"
                                                            Style="margin-right: 20px;">
                                                            <ClientSideEvents Click="function(s, e) {Pop_Inserted.Hide();}" />
                                                        </dx:ASPxButton>
                                                    </div>
                                                </div>
                                            </dx:PopupControlContentControl>
                                        </ContentCollection>
                                    </dx:ASPxPopupControl>





                                </div>
                            </div>

                        </dx:ContentControl>
                    </ContentCollection>
                </dx:TabPage>

                <dx:TabPage Text="إعداد القسائم" TabStyle-Font-Bold="true" TabStyle-Font-Names="cairo" TabStyle-Font-Size="X-Large">
                    <TabStyle Font-Bold="True" Font-Names="cairo" Font-Size="X-Large"></TabStyle>
                    <ContentCollection>
                        <dx:ContentControl>
                            <div class="navbar-main navbar-expand-lg px-0 mx-4 border-radius-xl bg-white shadow mt-3 mb-1">

                                <dx:ASPxGridView ID="GridSpecialCoupons" runat="server" DataSourceID="db_SpecialCoupons" KeyFieldName="id" ClientInstanceName="GridSpecialCoupons" Width="100%" AutoGenerateColumns="False" EnablePagingCallbackAnimation="True" OnRowInserted="GridSpecialCoupons_RowInserted" Font-Names="cairo" Font-Size="1.1em" RightToLeft="True">
                                    <Settings ShowFilterRow="True" ShowFilterRowMenu="False" ShowHeaderFilterButton="False" AutoFilterCondition="Contains" />

                                    <ClientSideEvents RowClick="OnRowClick" EndCallback="function(s,e){
        if (s.cpRefreshCombo){
            // إذا معاه ID جديد
            notificationList.PerformCallback(s.cpRefreshCombo);
            delete s.cpRefreshCombo;
        }
    }" />
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

                                    <SettingsSearchPanel CustomEditorID="tbToolbarSearch2" />

                                    <SettingsExport EnableClientSideExportAPI="true" ExcelExportMode="WYSIWYG" PaperKind="A4" RightToLeft="True" />
                                    <SettingsLoadingPanel Text="Please Wait &amp;hellip;" Mode="ShowAsPopup" />
                                    <SettingsText SearchPanelEditorNullText="ابحث في الجدول..." EmptyDataRow="لا يوجد" />
                                    <Columns>
                                        <dx:GridViewDataColumn Caption="الرقم" FieldName="id">
                                            <EditFormSettings Visible="False" />
                                            <CellStyle VerticalAlign="Middle" HorizontalAlign="Center">
                                            </CellStyle>
                                        </dx:GridViewDataColumn>


                                        <dx:GridViewDataComboBoxColumn Caption="البلد" FieldName="countryId">
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

                                        <dx:GridViewDataTextColumn Caption="رمز القسيمة" FieldName="couponCode">
                                            <PropertiesTextEdit ClientInstanceName="txtCouponCode">
                                                <ClientSideEvents LostFocus="function(s,e){ CheckCouponCode(s.GetText(), s); }" />
                                                <ValidationSettings RequiredField-IsRequired="true" SetFocusOnError="True" ErrorText="required." Display="Dynamic">
                                                    <RequiredField IsRequired="True" />
                                                </ValidationSettings>
                                            </PropertiesTextEdit>
                                            <CellStyle VerticalAlign="Middle" HorizontalAlign="Center" />
                                        </dx:GridViewDataTextColumn>

                                        <dx:GridViewDataTextColumn Caption="وصف القسيمة" FieldName="description">
                                            <PropertiesTextEdit>
                                                <ValidationSettings RequiredField-IsRequired="true" SetFocusOnError="True" ErrorText="required." Display="Dynamic">
                                                    <RequiredField IsRequired="True"></RequiredField>
                                                </ValidationSettings>
                                            </PropertiesTextEdit>
                                            <CellStyle VerticalAlign="Middle" HorizontalAlign="Center" />
                                        </dx:GridViewDataTextColumn>

                                        <dx:GridViewDataComboBoxColumn Caption="نسبة أو مبلغ" FieldName="l_discountType">
                                            <PropertiesComboBox DataSourceID="DB_DiscountType" TextField="description" ValueField="id" ValueType="System.Int32">
                                                <ValidationSettings RequiredField-IsRequired="true" SetFocusOnError="True" ErrorText="required." Display="Dynamic">
                                                    <RequiredField IsRequired="True"></RequiredField>
                                                </ValidationSettings>
                                                <ItemStyle Font-Size="1.5em" />
                                            </PropertiesComboBox>
                                            <CellStyle VerticalAlign="Middle" HorizontalAlign="Center">
                                            </CellStyle>
                                        </dx:GridViewDataComboBoxColumn>

                                        <dx:GridViewDataComboBoxColumn Caption="نوع القسيمة" FieldName="l_couponTypeId">
                                            <PropertiesComboBox DataSourceID="db_CouponType" TextField="description" ValueField="id" ValueType="System.Int32">
                                                <ValidationSettings RequiredField-IsRequired="true" SetFocusOnError="True" ErrorText="required." Display="Dynamic">
                                                    <RequiredField IsRequired="True"></RequiredField>
                                                </ValidationSettings>
                                                <ItemStyle Font-Size="1.5em" />
                                            </PropertiesComboBox>
                                            <CellStyle VerticalAlign="Middle" HorizontalAlign="Center">
                                            </CellStyle>
                                        </dx:GridViewDataComboBoxColumn>

                                        <dx:GridViewDataSpinEditColumn Caption="قيمة الخصم" FieldName="discountAmount">
                                            <PropertiesSpinEdit DisplayFormatString="g" MaxValue="1000" NumberType="Float">
                                                <ValidationSettings Display="Dynamic" ErrorText="" SetFocusOnError="True">
                                                    <RequiredField IsRequired="True" />
                                                </ValidationSettings>
                                            </PropertiesSpinEdit>
                                            <DataItemTemplate>
                                                <%# Convert.ToDecimal(Eval("l_discountType")) == 1 ? Eval("discountAmount") : Convert.ToInt32(Eval("discountAmount")) + " % "  %>
                                            </DataItemTemplate>
                                            <CellStyle HorizontalAlign="Center" VerticalAlign="Middle" Font-Bold="True" Font-Size="X-Large" ForeColor="#00822B">
                                            </CellStyle>
                                        </dx:GridViewDataSpinEditColumn>

                                        <dx:GridViewDataDateColumn Caption="التاريخ" FieldName="userDate" Width="9%">
                                            <EditFormSettings Visible="False" />
                                            <PropertiesDateEdit DisplayFormatString="dd/MM/yyyy"></PropertiesDateEdit>
                                            <CellStyle VerticalAlign="Middle"></CellStyle>
                                        </dx:GridViewDataDateColumn>

                                        <dx:GridViewDataTextColumn Caption="إجراء" ShowInCustomizationForm="True" Width="150px">
                                            <EditFormSettings Visible="False" />
                                            <DataItemTemplate>
                                                <%# Convert.ToInt32(Eval("HasUsers")) == 1
                                                    ? "<div style='color:red; font-weight:bold; text-align:center;'>لا يمكن تعديل هذا الكوبون</div>"
                                                    : "<div style='text-align:center;'><img src='/assets/img/update.png' width='32' height='32' title='تعديل' style='cursor:pointer' onclick='setTimeout(function(){GridSpecialCoupons.StartEditRow(MyIndex);},100);' /></div>" %>
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


                                <dx:ASPxCallback ID="cbCheckCoupon" runat="server" ClientInstanceName="cbCheckCoupon" OnCallback="cbCheckCoupon_Callback">
                                    <ClientSideEvents CallbackComplete="function(s,e){
                                        console.log('cbCheckCoupon result =', e.result);
                                        if (e.result === 'exists') {
                                            Pop_validate.Show();
                                            txtCouponCode.SetText('');
                                        }
                                    }" />
                                </dx:ASPxCallback>




                                <asp:SqlDataSource
                                    ID="db_SpecialCoupons"
                                    runat="server"
                                    ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>"
                                    SelectCommand="
        SELECT 
            cp.id,
            cp.countryId,
            cp.username,
            cp.couponCode,
            cp.description,
            cp.discountAmount,
            cp.l_couponTypeId,
            cp.l_discountType,
            cp.isUsed,
            cp.userDate,
            CASE 
                WHEN EXISTS (
                    SELECT 1 
                    FROM coupons c2 
                    WHERE c2.couponCode = cp.couponCode
                      AND c2.username &lt;&gt; '0'
                ) THEN 1 ELSE 0 
            END AS HasUsers
        FROM [coupons] cp 
        WHERE cp.id &lt;&gt; 1 
          AND cp.username = '0';"
                                    InsertCommand="
        INSERT INTO [coupons] (
            [username],
            [countryId],
            [couponCode],
            [description],
            [discountAmount],
            [l_discountType],
            [l_couponTypeId],
            [userDate]
        )
        VALUES (
            @username,
            @countryId,
            @couponCode,
            @description,
            @discountAmount,
            @l_discountType,
            @l_couponTypeId,
            GETDATE()
        );"
                                    UpdateCommand="
        UPDATE [coupons]
        SET 
            [username]       = @username,
            [countryId]      = @countryId,
            [couponCode]     = @couponCode,
            [description]    = @description,
            [discountAmount] = @discountAmount,
            [l_couponTypeId] = @l_couponTypeId,
            [l_discountType] = @l_discountType
        WHERE [id] = @id;"
                                    DeleteCommand="
        DELETE FROM coupons 
        WHERE id = @id;">

                                    <InsertParameters>
                                        <asp:Parameter Name="username" Type="String" DefaultValue="0" />
                                        <asp:Parameter Name="countryId" />
                                        <asp:Parameter Name="couponCode" Type="String" />
                                        <asp:Parameter Name="description" Type="String" />
                                        <asp:Parameter Name="discountAmount" Type="String" />
                                        <asp:Parameter Name="l_discountType" Type="String" />
                                        <asp:Parameter Name="l_couponTypeId" Type="String" />
                                    </InsertParameters>

                                    <UpdateParameters>
                                        <asp:Parameter Name="username" Type="String" DefaultValue="0" />
                                        <asp:Parameter Name="countryId" Type="String" />
                                        <asp:Parameter Name="couponCode" Type="String" />
                                        <asp:Parameter Name="description" Type="String" />
                                        <asp:Parameter Name="discountAmount" Type="String" />
                                        <asp:Parameter Name="l_discountType" Type="String" />
                                        <asp:Parameter Name="l_couponTypeId" Type="String" />
                                    </UpdateParameters>
                                </asp:SqlDataSource>

                                <asp:SqlDataSource
                                    ID="dsCountries"
                                    runat="server"
                                    ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>"
                                    SelectCommand="SELECT id, countryName FROM countries"></asp:SqlDataSource>

                                <asp:SqlDataSource ID="db_CouponType" runat="server" ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>"
                                    SelectCommand="SELECT id, description FROM l_couponType Where Id>1"></asp:SqlDataSource>

                                <dx:ASPxPopupControl runat="server" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter"
                                    AutoUpdatePosition="True" Modal="True" ClientInstanceName="Pop_DetailsDel" CloseAnimationType="Slide"
                                    FooterText="" HeaderText="حذف إشعار" Font-Names="Cairo" MinWidth="350px" MinHeight="150px" Width="350px" Height="150px" ID="Pop_DetailsDel">
                                    <ContentCollection>
                                        <dx:PopupControlContentControl runat="server">
                                            <div style="padding: 20px; font-family: 'Cairo', sans-serif; text-align: right">
                                                <div class="mb-3" style="width: 100%;">
                                                    <dx:ASPxLabel runat="server" Text="هل أنت متأكد من حذف الإشعار؟" ClientInstanceName="labelProducts"
                                                        Font-Names="Cairo" Font-Size="Medium" ForeColor="#333333" ID="ASPxLabel1">
                                                    </dx:ASPxLabel>
                                                </div>
                                                <div style="width: 100%; margin-top: 20px; text-align: center;">
                                                    <dx:ASPxButton ID="ASPxButton1" runat="server" AutoPostBack="False" Text="حــــــــذف"
                                                        UseSubmitBehavior="False" Font-Names="Cairo" HorizontalAlign="Center" VerticalAlign="Middle">
                                                        <ClientSideEvents Click="function(s, e) { 
                                                                 GridNotifications.DeleteRow(MyIndex); 
                                                                 Pop_DetailsDel.Hide();
                                                             }" />
                                                    </dx:ASPxButton>

                                                    <dx:ASPxButton ID="ASPxButton2" runat="server" AutoPostBack="False" Text="إغـــــــــــلاق"
                                                        UseSubmitBehavior="False" Font-Names="Cairo" HorizontalAlign="Center" VerticalAlign="Middle"
                                                        Style="margin-right: 20px;">
                                                        <ClientSideEvents Click="function(s, e) {Pop_DetailsDel.Hide();}" />
                                                    </dx:ASPxButton>
                                                </div>
                                            </div>
                                        </dx:PopupControlContentControl>
                                    </ContentCollection>
                                </dx:ASPxPopupControl>

                            </div>

                        </dx:ContentControl>
                    </ContentCollection>
                </dx:TabPage>
            </TabPages>
        </dx:ASPxPageControl>

        <dx:ASPxPopupControl
            ID="Pop_validate"
            runat="server"
            ClientInstanceName="Pop_validate"
            HeaderText="تحذير"
            PopupHorizontalAlign="WindowCenter"
            PopupVerticalAlign="WindowCenter"
            AutoUpdatePosition="True"
            Modal="True"
            CloseAnimationType="Slide"
            Font-Names="Cairo"
            MinWidth="350px"
            MinHeight="150px"
            Width="350px"
            Height="150px">

            <ContentCollection>
                <dx:PopupControlContentControl runat="server">
                    <div style="padding: 20px; font-family: 'Cairo', sans-serif; text-align: center">
                        <div class="mb-3" style="width: 100%;">
                            <dx:ASPxLabel
                                ID="lblValidateMsg"
                                runat="server"
                                Text="رمز القسيمة مستخدم مسبقًا، الرجاء إدخال رمز آخر."
                                Font-Names="Cairo"
                                Font-Size="Large"
                                ForeColor="Red">
                            </dx:ASPxLabel>
                        </div>
                        <div style="width: 100%; margin-top: 20px; text-align: center;">
                            <dx:ASPxButton
                                ID="btnCloseValidate"
                                runat="server"
                                AutoPostBack="False"
                                Text="إغـــــــــــلاق"
                                UseSubmitBehavior="False"
                                Font-Names="Cairo"
                                HorizontalAlign="Center"
                                VerticalAlign="Middle"
                                Style="margin-right: 20px;">
                                <ClientSideEvents Click="function(s, e) { Pop_validate.Hide(); }" />
                            </dx:ASPxButton>
                        </div>
                    </div>
                </dx:PopupControlContentControl>
            </ContentCollection>
        </dx:ASPxPopupControl>


    </main>



</asp:Content>
