<%@ Page Title="Landing" Language="C#" MasterPageFile="~/LSite.Master" AutoEventWireup="true" CodeBehind="Landing.aspx.cs" Inherits="ShabAdmin.Landing" %>

<%@ Register Assembly="DevExpress.Web.v24.1, Version=24.1.6.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">


    <main>
        <script>
            window.onload = function () {
                var deep = decodeURIComponent("<%= Request.QueryString["deep"] %>");
                var fallback = decodeURIComponent("<%= Request.QueryString["fallback"] %>");

                // محاولة فتح التطبيق
                window.location = deep;

                // fallback إذا التطبيق مش منصّب
                setTimeout(function () {
                    window.location = fallback;
                }, 1500);
            };
        </script>
    </main>


</asp:Content>
