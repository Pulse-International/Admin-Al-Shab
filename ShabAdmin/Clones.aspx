<%@ Page Title="Products" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Clones.aspx.cs" Inherits="ShabAdmin.Clones" %>

<%@ Register Assembly="DevExpress.Web.v24.1, Version=24.1.6.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <script>
        var sourceCountry = 0;
        var targetCountry = 0;
        var sourceClicked = 0;
        var targetClicked = 0;
    </script>
    
        <main>


            <div class="w-100 text-center my-4">
                <h2 class="pageTitle d-inline-block" style="font-family: Cairo">نسخ المنتجات الدولي</h2>
                <br />
                <span style="color: #000000">في حال طلب النسخ لكامل المنتجات من فرع إلى فرع داخل نفس الدولة يرجى الذهاب إلى قسم <a href="branches">( الفروع )</a>
                </span>
            </div>

            <div class="navbar-main navbar-expand-lg px-0 mx-4 border-radius-xl bg-white shadow mt-1 mb-1" style="font-size: 5em; text-align: center; padding-top: 0.5em; padding-bottom: 1.5em">
                <dx:ASPxCallbackPanel ID="cloneCallback" ClientInstanceName="cloneCallback" runat="server" Width="100%" EnableCallbackAnimation="True" OnCallback="cloneCallback_Callback">
                    <ClientSideEvents EndCallback="function(s, e) { 
                        if(s.cpResult == 1){
                            labelClone.SetText('تم نقل بيانات المنتجات بنجاح');
                            Pop_Clone.Show(); 
                        }
                        else if(s.cpResult == 0)
                        {
                            labelClone.SetText('حدث خطأ، الرجاء المحاولة مرة أخرى أو التواصل مع الدعم الفني');
                            Pop_Clone.Show(); 
                        }
                        Btn_Del_Branches.SetEnabled(false);
                     }" />
                    <PanelCollection>
                        <dx:PanelContent runat="server">
                            <div style="font-size: 1.1em; margin: 0 auto; text-align: center; font-family: cairo">
                                الرجاء اختيار الدولة التي سيتم نسخ بيانات المنتجات منها، ثم اختيار الدولة التي سيتم نسخ البيانات إليها، 
                                بعد النسخ يرجى الانتقال إلى صفحة المنتجات ومراجعة البيانات
                                <br />
                                <span style="color: #ff0000">( مهم جدا: في حال وجود نفس المنتج في الدولة التي سيتم النسخ إليها فلن يتم نسخ هذا المنتج وستكمل العملية لباقي المنتجات، ويجب أن تحتوي الدولتين على شركة وفرع واحد على الأقل )
                                </span><br />
                            </div>
                            <div class="row mt-4" style="width: 70%; margin: 0 auto; border: 4px solid #e6edff; border-radius: 1em;">
                                <div class="col-lg-6 col-md-6 mt-4 mb-4" style="text-align: center; text-align: -moz-center; text-align: -webkit-center;">

                                    <dx:ASPxComboBox ID="SourceCountry" runat="server" ValueType="System.String" DataSourceID="DB_GetCountries" Font-Names="cairo" Font-Size="X-Large" Caption="نسخ بيانات المنتجات من الدولة" TextField="countryName" ValueField="id" Width="70%" ClientInstanceName="SourceCountry">
                                        <ClientSideEvents SelectedIndexChanged="function(s, e) { sourceClicked=1; checkClone.PerformCallback(s.GetValue() + '|' + 'source') }" />
                                        <CaptionSettings Position="Top" HorizontalAlign="Center" />
                                        <ValidationSettings Display="Dynamic" SetFocusOnError="True" ValidationGroup="cloneGroup">
                                            <RequiredField IsRequired="True" />
                                        </ValidationSettings>
                                        <CaptionCellStyle>
                                            <Paddings Padding="10px" />
                                        </CaptionCellStyle>
                                    </dx:ASPxComboBox>

                                </div>
                                <div class="col-lg-6 col-md-6 mt-4 mb-4" style="text-align: center; text-align: -moz-center; text-align: -webkit-center;">

                                    <dx:ASPxComboBox ID="TargetCountry" runat="server" ValueType="System.Int32" DataSourceID="DB_GetCountries" Font-Names="cairo" Font-Size="X-Large" Caption="نسخ بيانات المنتجات إلى الدولة" TextField="countryName" ValueField="id" Width="70%" ClientInstanceName="TargetCountry">
                                        <ClientSideEvents SelectedIndexChanged="function(s, e) { targetClicked=1; checkClone.PerformCallback(s.GetValue() + '|' + 'target'); }" />
                                        <CaptionSettings Position="Top" HorizontalAlign="Center" />
                                        <ValidationSettings Display="Dynamic" SetFocusOnError="True" ValidationGroup="cloneGroup">
                                            <RequiredField IsRequired="True" />
                                        </ValidationSettings>
                                        <CaptionCellStyle>
                                            <Paddings Padding="10px" />
                                        </CaptionCellStyle>
                                    </dx:ASPxComboBox>

                                </div>
                                <div style="width:90%; font-size: 1.1em; margin: 0 auto; text-align: center; font-family: cairo; border-top:1px solid #d9d9d9; border-bottom:1px solid #d9d9d9; padding-bottom:1em; padding-top:1em">
                                    اختياري: يمكن اختيار الشركة لكل دولة حيث سيتم نسخ منتجات الشركة في الدولة الأولى إلى الشركة الموجودة في الدولة الثانية وغير ذلك ستتم العملية بشكل آلي
                                </div>

                                <div class="col-lg-6 col-md-6 mt-4 mb-4" style="text-align: center; text-align: -moz-center; text-align: -webkit-center;">

                                    <dx:ASPxComboBox ID="SourceCompany" runat="server" ValueType="System.String" DataSourceID="DB_GetCompanies" Font-Names="cairo" Font-Size="X-Large" Caption=" من الشركة (اختياري)" TextField="CompanyName" ValueField="id" Width="70%" ClientInstanceName="SourceCompany" OnCallback="SourceCompany_Callback">
                                        <CaptionSettings Position="Top" HorizontalAlign="Center" />
                                        <CaptionCellStyle>
                                            <Paddings Padding="10px" />
                                        </CaptionCellStyle>
                                    </dx:ASPxComboBox>

                                </div>
                                <div class="col-lg-6 col-md-6 mt-4 mb-4" style="text-align: center; text-align: -moz-center; text-align: -webkit-center;">

                                    <dx:ASPxComboBox ID="TargetCompany" runat="server" ValueType="System.Int32" DataSourceID="DB_GetCompanies" Font-Names="cairo" Font-Size="X-Large" Caption="إلى الشركة (اختياري)" TextField="CompanyName" ValueField="id" Width="70%" ClientInstanceName="TargetCompany" OnCallback="TargetCompany_Callback">
                                        <CaptionSettings Position="Top" HorizontalAlign="Center" />
                                        <CaptionCellStyle>
                                            <Paddings Padding="10px" />
                                        </CaptionCellStyle>
                                    </dx:ASPxComboBox>

                                </div>
                                <div class="col-lg-12 col-md-12 mb-4 mt-3">
                                    <dx:ASPxButton ID="Btn_Del_Branches" ClientInstanceName="Btn_Del_Branches" runat="server" AutoPostBack="False" Text="بدء نقل البيانات للمنتجات"
                                        UseSubmitBehavior="False" Font-Names="Cairo" HorizontalAlign="Center" VerticalAlign="Middle" Font-Size="XX-Large" Width="50%" Height="70px" Font-Bold="True">
                                        <ClientSideEvents Init="function(s, e) { Btn_Del_Branches.SetEnabled(false); }" Click="function(s, e) {    
                                            if(ASPxClientEdit.ValidateGroup('cloneGroup'))     
                                                cloneCallback.PerformCallback();
                                            }" />
                                    </dx:ASPxButton>
                                </div>
                            </div>


                        </dx:PanelContent>
                    </PanelCollection>
                </dx:ASPxCallbackPanel>
            </div>

        </main>

        <dx:ASPxCallbackPanel ID="checkClone" ClientInstanceName="checkClone" runat="server" Width="0px" OnCallback="checkClone_Callback">
            <ClientSideEvents 
                EndCallback="function(s, e) { 
                         if (s.cpResultCheck == 0) 
                         {
                                labelClone.SetText('لا يمكن نسخ البيانات<br> يجب أن تحتوي الدولة المختارة على شركة و فرع واحد على الأقل');
                                Pop_Clone.Show();
                                if(s.cpResultControl == 1){
                                    sourceCountry = 0;                             
                                }
                                 else if(s.cpResultControl == 2){
                                    targetCountry = 0;                             
                                } 
                         }
                         else if (s.cpResultCheck == 1){
                              if(s.cpResultControl == 1){
                                        sourceCountry = 1;                             
                              }
                              else if(s.cpResultControl == 2){
                                        targetCountry = 1;                             
                              }                              
                        }
                        
                        if(sourceCountry == 1 && targetCountry == 1)
                            Btn_Del_Branches.SetEnabled(true); 
                        else
                            Btn_Del_Branches.SetEnabled(false);
                        
                        if(sourceClicked == 1)
                            SourceCompany.PerformCallback(SourceCountry.GetValue());
                        if(targetClicked == 1)
                            TargetCompany.PerformCallback(TargetCountry.GetValue());

                        sourceClicked = 0;
                        targetClicked = 0;

                }                       
              " />
            <PanelCollection>
                <dx:PanelContent runat="server"></dx:PanelContent>
            </PanelCollection>
        </dx:ASPxCallbackPanel>

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


        <asp:SqlDataSource ID="DB_GetCountries" runat="server" ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>"
            SelectCommand="SELECT id, countryName FROM countries where id <> 1000"></asp:SqlDataSource>

        <asp:SqlDataSource ID="DB_GetCompanies" runat="server" ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>"
            SelectCommand="SELECT id, companyName FROM companies where  id <> 1000 and countryId=@countryId">
            <SelectParameters>
                <asp:Parameter Name="countryId" Type="String" />
            </SelectParameters>
        </asp:SqlDataSource>

        <asp:SqlDataSource ID="DB_CheckCountries" runat="server" ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>"
            SelectCommand="if exists(select distinct 1 from branches where countryID=@countryID) and exists(select distinct 1 from companies where countryID=@countryID)
                            begin
                                select 1
                            end
                            else
                            begin
                                select 0
                            end">
            <SelectParameters>
                <asp:Parameter DefaultValue="0" Name="countryID" Type="String" />
            </SelectParameters>
        </asp:SqlDataSource>


    

</asp:Content>
