<%@ Page Title="Sign" Language="C#" AutoEventWireup="true" CodeBehind="Sign.aspx.cs" Inherits="ShabAdmin.Sign" %>

<%@ Register Assembly="DevExpress.Web.v24.1, Version=24.1.6.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="icon" type="image/png" href="/assets/img/favicon.png">
    <title>AlShab Admin
    </title>
    <!--     Fonts and icons     -->
    <link href="https://fonts.googleapis.com/css2?family=Cairo:wght@200..1000&display=swap" rel="stylesheet">
    <!-- Nucleo Icons -->
    <link href="/assets/css/nucleo-icons.css" rel="stylesheet" />
    <link href="/assets/css/nucleo-svg.css" rel="stylesheet" />
    <!-- Material Icons -->
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons+Round" rel="stylesheet">
    <!-- CSS Files -->
    <link id="pagestyle" href="/assets/css/material-dashboard.css?v=3.0.0" rel="stylesheet" />

    <script src="https://code.jquery.com/jquery-3.7.1.min.js" integrity="sha256-/JqT3SQfawRcv/BIHPThkBvs0OEvtFFmqPF/lYI/Cxo=" crossorigin="anonymous"></script>

</head>

<body class="bg-gray-200">
    <form runat="server" dir="rtl">
        <main class="main-content  mt-0">
            <div class="page-header align-items-start min-vh-100" style="background-image: url('https://images.unsplash.com/photo-1497294815431-9365093b7331?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1950&q=80');">
                <span class="mask bg-gradient-dark opacity-6"></span>
                <div class="container my-auto">
                    <div class="row">
                        <div class="col-lg-4 col-md-8 col-12 mx-auto">
                            <div class="card z-index-0 fadeIn3 fadeInBottom">
                                <div class="card-header p-0 position-relative mt-n4 mx-3 z-index-2">
                                    <div class="bg-gradient-primary shadow-primary border-radius-lg py-3 pe-1">
                                        <h4 class="text-white font-weight-bolder text-center mt-2 mb-0">الشــــعـب</h4>
                                        <hr />
                                        <h6 class="text-white font-weight-bolder text-center mt-2 mb-0">(دخول النظام)</h6>
                                        <%--<div class="row mt-3">
                                            <div class="col-2 text-center ms-auto">
                                                <a class="btn btn-link px-3" href="javascript:;">
                                                    <i class="fa fa-facebook text-white text-lg"></i>
                                                </a>
                                            </div>
                                            <div class="col-2 text-center px-1">
                                                <a class="btn btn-link px-3" href="javascript:;">
                                                    <i class="fa fa-github text-white text-lg"></i>
                                                </a>
                                            </div>
                                            <div class="col-2 text-center me-auto">
                                                <a class="btn btn-link px-3" href="javascript:;">
                                                    <i class="fa fa-google text-white text-lg"></i>
                                                </a>
                                            </div>
                                        </div>--%>
                                    </div>
                                </div>

                                <div class="card-body">
                                    <!-- 1. تعريف الدالة -->
                                    <script>
                                        function getParameterByName(name) {
                                            const url = window.location.href;
                                            name = name.replace(/[\[\]]/g, "\\$&");
                                            const regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)");
                                            const results = regex.exec(url);
                                            if (!results) return null;
                                            if (!results[2]) return '';
                                            return decodeURIComponent(results[2].replace(/\+/g, " "));
                                        }
                                    </script>

                                    <!-- 2. استخدام الدالة مع jQuery -->
                                    <script>
                                        $(function () {
                                            const error = getParameterByName('error');
                                            const $errorDiv = $('#divError');

                                            if (error === '1') {
                                                $errorDiv.text("خطأ في اسم المستخدم أو كلمة السر!").css('display', 'block');
                                            } else if (error === '2') {
                                                $errorDiv.text("خطأ في الرمز المدخل!").css('display', 'block');
                                            } else {
                                                $errorDiv.hide();
                                            }
                                        });
                                    </script>

                                    <div id="divError" style="display: none; background-color: #e53935; color: #fff; padding: 0.75rem; font-family: 'Cairo'; border-radius: 6px; text-align: center; margin-bottom: 1rem; font-size: 1.1em;">
                                        خطأ في اسم المستخدم أو كلمة السر!
                                    </div>


                                    <div class="input-group input-group-outline my-3">
                                        <label class="form-label">Username</label>
                                        <dx:ASPxTextBox ID="username" runat="server" Font-Names="Cairo" Font-Size="Large" MaxLength="70" Width="100%">
                                            <ValidationSettings Display="None" SetFocusOnError="True" ValidationGroup="userGroup">
                                                <RequiredField IsRequired="True" />
                                            </ValidationSettings>
                                        </dx:ASPxTextBox>
                                    </div>

                                    <div class="input-group input-group-outline mb-3">
                                        <label class="form-label">Password</label>
                                        <dx:ASPxButtonEdit ID="cPassword" runat="server" ClientInstanceName="cPassword" Font-Names="Cairo" Font-Size="Large" MaxLength="70" Password="True" Width="100%">
                                            <Buttons>
                                                <dx:EditButton>
                                                    <Image Url="~/assets/img/showPassword.png?v=1" Height="32px" Width="32px" />
                                                </dx:EditButton>
                                                <dx:EditButton>
                                                    <Image Url="~/assets/img/hidePassword.png?v=1" Height="32px" Width="32px" />
                                                </dx:EditButton>
                                            </Buttons>
                                            <ClientSideEvents
                                                ButtonClick="function(s, e) {
                var input = s.GetInputElement();
                if (input.type === 'password') {
                    input.type = 'text';
                    s.SetButtonVisible(0, false);
                    s.SetButtonVisible(1, true);
                } else {
                    input.type = 'password';
                    s.SetButtonVisible(0, true);
                    s.SetButtonVisible(1, false);
                }
            }"
                                                Init="function(s, e) {
                s.SetButtonVisible(1, false);
            }" />
                                        </dx:ASPxButtonEdit>
                                    </div>

                                    <div class="input-group input-group-outline mb-3" style="text-align: center;">
                                        <dx:ASPxCaptcha ID="Captche_Check" runat="server" TextBox-Position="Bottom"
                                            CharacterSet="23456789" CodeLength="4" EnableCallbackAnimation="True"
                                            Font-Names="Cairo" Font-Size="Large">

                                            <ValidationSettings SetFocusOnError="True" ErrorDisplayMode="Text" ValidationGroup="userGroup">
                                                <RequiredField IsRequired="True" />
                                            </ValidationSettings>

                                            <RefreshButton Text="" Position="Right" />
                                            <RefreshButtonStyle ImageSpacing="0px">
                                                <Paddings Padding="0px" />
                                            </RefreshButtonStyle>

                                            <TextBox LabelText="" Position="Bottom" ShowLabel="False" NullText="الرمز" />

                                            <ChallengeImage ForegroundColor="#000000" Height="60" FontFamily="Courier New" />

                                            <LoadingPanel Enabled="False" />

                                            <ClientSideEvents Init="function(s, e) {
            var editor = s.GetEditor();
            var input = editor.GetInputElement();
            input.maxLength = 4;
        }" />
                                        </dx:ASPxCaptcha>
                                    </div>

                                    <div class="text-center">
                                        <dx:ASPxButton ID="btnLogin" runat="server" Text="دخـــول" ClientEnabled="true" Font-Names="cairo" Font-Size="Large" Width="100%" ValidationGroup="userGroup" OnClick="btnLogin_Click" AutoPostBack="False">
                                        </dx:ASPxButton>
                                        <asp:SqlDataSource ID="DB_Login" runat="server" ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>" SelectCommand="SELECT [id], [username], [password], [isActive] FROM [users] WHERE username = @Username"
                                            InsertCommand="insert into users (username, password, isActive) values (@username, @password, @isActive)">
                                            <InsertParameters>
                                                <asp:Parameter Name="username" />
                                                <asp:Parameter Name="password" />
                                                <asp:Parameter Name="isActive" />
                                            </InsertParameters>
                                            <SelectParameters>
                                                <asp:Parameter DefaultValue="0" Name="Username" Type="String" />
                                                <asp:Parameter DefaultValue="0" Name="Password" />
                                            </SelectParameters>
                                        </asp:SqlDataSource>
                                    </div>


                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>
        <!--   Core JS Files   -->
        <script src="/assets/js/core/popper.min.js"></script>
        <script src="/assets/js/core/bootstrap.min.js"></script>
        <script src="/assets/js/plugins/perfect-scrollbar.min.js"></script>
        <script src="/assets/js/plugins/smooth-scrollbar.min.js"></script>
   </form> 
</body>

</html>
