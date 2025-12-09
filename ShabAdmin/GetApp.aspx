<%@ Page Title="Prohibited" Language="C#" AutoEventWireup="true" CodeBehind="GetApp.aspx.cs" Inherits="ShabAdmin.GetApp" %>

<%@ Register Assembly="DevExpress.Web.v24.1, Version=24.1.6.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<!DOCTYPE html>
<html lang="en">

<head>
    <style>
        body {
            margin: 0;
            padding: 0;
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
        }
    </style>
    <script>
        function detectPlatformAndRedirect() {
            const userAgent = navigator.userAgent || navigator.vendor || window.opera;
            const platform = navigator.platform || '';

            const redirectUrls = {
                android: "https://play.google.com/store/apps/details?id=com.alshaeb.alshaeb",
                ios: "https://apps.apple.com/us/app/alshaeb-click/id6752823758",
                web: "https://www.alshaeb.com#app"
            };

            let targetUrl = redirectUrls.web;

            // iOS detection (check first as it's more specific)
            const isIOS = /iPad|iPhone|iPod/.test(userAgent) && !window.MSStream;

            // Android detection - comprehensive check
            const isAndroid = /android/i.test(userAgent) ||
                /linux/i.test(platform.toLowerCase()) ||
                /SM-A/i.test(userAgent) ||  // Samsung A series
                /SM-/i.test(userAgent) ||    // All Samsung models
                /SAMSUNG/i.test(userAgent) ||
                /Galaxy/i.test(userAgent);

            // Mobile detection fallback
            const isMobile = /Mobi|Android/i.test(userAgent) ||
                ('ontouchstart' in window && window.innerWidth <= 768);

            console.log('UserAgent:', userAgent);
            console.log('Platform:', platform);
            console.log('isAndroid:', isAndroid);
            console.log('isIOS:', isIOS);
            console.log('isMobile:', isMobile);

            if (isIOS) {
                targetUrl = redirectUrls.ios;
            } else if (isAndroid) {
                targetUrl = redirectUrls.android;
            } else if (isMobile) {
                // If mobile but not detected, default to Android
                targetUrl = redirectUrls.android;
            }

            console.log('Redirecting to:', targetUrl);
            window.location.href = targetUrl;
        }

        detectPlatformAndRedirect();
    </script>
</head>

<body>
    <h1>
        <img src="assets/img/loading.gif" />
    </h1>
</body>

</html>
