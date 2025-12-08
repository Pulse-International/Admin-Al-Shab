<%@ Page Title="Prohibited" Language="C#" AutoEventWireup="true" CodeBehind="GetApp.aspx.cs" Inherits="ShabAdmin.GetApp" %>

<%@ Register Assembly="DevExpress.Web.v24.1, Version=24.1.6.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="icon" type="image/png" href="/assets/img/favicon.png">
    <title>Shab Admin
    </title>
    <!--     Fonts and icons     -->
    <link href="https://fonts.googleapis.com/css2?family=Cairo:wght@200..1000&display=swap" rel="stylesheet">
    <!-- Nucleo Icons -->
    <link href="/assets/css/nucleo-icons.css" rel="stylesheet" />
    <link href="/assets/css/nucleo-svg.css" rel="stylesheet" />
    <!-- Font Awesome Icons -->
    <script src="https://kit.fontawesome.com/42d5adcbca.js" crossorigin="anonymous"></script>
    <!-- Material Icons -->
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons+Round" rel="stylesheet">
    <!-- CSS Files -->
    <link id="pagestyle" href="/assets/css/material-dashboard.css?v=3.0.0" rel="stylesheet" />

    <script>
        function detectPlatformAndRedirect() {
            const userAgent = navigator.userAgent || navigator.vendor || window.opera;

            // Your redirect URLs
            const redirectUrls = {
                web: "https://www.alshaeb.com",
                ios: "https://apps.apple.com/us/app/alshaeb-click/id6752823758",
                android: "https://play.google.com/store/apps/details?id=com.alshaeb.alshaeb"
            };

            let platform = 'web';

            // Check if running in standalone mode (PWA)
            const isStandalone = window.matchMedia('(display-mode: standalone)').matches
                || window.navigator.standalone
                || document.referrer.includes('android-app://');

            // Android detection
            if (/android/i.test(userAgent)) {
                platform = 'android';
            }
            // iOS detection
            else if (/iPad|iPhone|iPod/.test(userAgent) && !window.MSStream) {
                platform = 'ios';
            }
            // Additional checks for iOS in some cases
            else if (navigator.platform && /iPad|iPhone|iPod/.test(navigator.platform)) {
                platform = 'ios';
            }

            // Redirect
            console.log('Detected platform:', platform);
            window.location.href = redirectUrls[platform];
        }

        // Execute on page load
        detectPlatformAndRedirect();
    </script>
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
                                        <h6 class="text-white font-weight-bolder text-center mt-2 mb-0">(تحويل لتنزيل التطبيق)</h6>
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
                                <div style="line-height: 1.5em; text-align:center; margin:0 auto; padding-top:3em; padding-bottom:3em; font-size:2em">
                                    الرجاء الانتظار...
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
