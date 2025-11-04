<%@ Page Title="" Language="C#" AutoEventWireup="true" CodeBehind="CheckOut.aspx.cs" Inherits="ShabAdmin.CheckOut" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <script>
        var wpwlOptions = {style:"card"}
    </script>
       <script src="https://eu-test.oppwa.com/v1/paymentWidgets.js?checkoutId=<%=CheckPaymentId%>"></script>

</head>
<body>
   
                <form action="<%=ActionURL%>" class="paymentWidgets" data-brands="VISA MASTER AMEX"></form>

</body>
</html>
