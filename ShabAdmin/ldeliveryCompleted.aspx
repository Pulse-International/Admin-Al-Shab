<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/lSite.Master" CodeBehind="ldeliveryCompleted.aspx.cs" Inherits="ShabAdmin.ldeliveryCompleted"  Async="true"%>
<%@ Register Assembly="DevExpress.Web.v24.1, Version=24.1.6.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <style>
        :root {
            --primary-color: #ea1f29;
            --primary-hover: #c91b24;
            --text-color: #333;
            --bg-color: #f4f6f9;
            --input-bg: #fff;
            --border-color: #e1e1e1;
        }

        .password-card {
            background: white;
            padding: 40px 30px;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
            width: 100%;
            max-width: 450px;
            text-align: center;
            transition: transform 0.3s ease;
            margin: 20px auto;
        }

        .icon-circle {
            width: 80px;
            height: 80px;
            background: rgba(234, 31, 41, 0.1);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px auto;
        }

        .icon-circle i {
            font-size: 35px;
            color: var(--primary-color);
        }

        h2 {
            color: var(--text-color);
            margin-bottom: 10px;
            font-weight: 700;
            font-family: 'Cairo', sans-serif;
        }

        .input-group {
            margin-bottom: 20px;
            position: relative;
            text-align: right;
            display:block;
        }

        .input-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: var(--text-color);
            font-size: 14px;
            font-family: 'Cairo', sans-serif;
        }

        .input-wrapper {
            position: relative;
        }

        .custom-dx-input {
            width: 100%;
            border-radius: 12px !important;
            border: 2px solid var(--border-color) !important;
            background: var(--input-bg) !important;
            transition: all 0.3s ease;
            box-sizing: border-box; 
        }

        .custom-dx-input .dxeEditAreaSys {
            background-color: transparent !important;
        }

        .custom-dx-input.dxeFocused_Moderno {
            border-color: var(--primary-color) !important;
            box-shadow: 0 0 0 4px rgba(234, 31, 41, 0.1) !important;
        }

        .toggle-password {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #999;
            cursor: pointer;
            transition: color 0.3s;
            z-index: 10;
            font-size: 18px;
        }

        .toggle-password:hover {
            color: var(--primary-color);
        }

        .match-message {
            font-size: 12px;
            margin-top: 5px;
            display: none;
            font-family: 'Cairo', sans-serif;
            font-weight: bold;
        }
        .match-error { color: #dc3545; display: block; }
        .match-success { color: #28a745; display: block; }

        .btn-submit-dx {
            background-color: red !important;
            color: white !important;
            border-radius: 12px !important;
            font-size: 18px !important;
            font-weight: 700 !important;
            font-family: 'Cairo', sans-serif !important;
            border: none !important;
            padding: 12px !important;
            box-shadow: none !important;
        }
        .btn-submit-dx:hover {
            background-color: var(--primary-hover) !important;
        }
        .dxbButtonSys.dxbTSys{
            background:red !important;
        }
        .dxbButtonSys.dxbTSys:hover{
            background:#c93232 !important;
        }
        .driver-header-wrapper {
            background: linear-gradient(135deg, #ea1f29 0%, #b9161e 100%);
            padding: 50px 41px 43px 20px;
            border-radius: 0 0 30px 30px;
            color: white;
            box-shadow: 0 10px 30px rgba(234, 31, 41, 0.2);
            margin-bottom: 26px;
            position: relative;
            z-index: 1;
        }

        .driver-header-main {
            max-width: 850px;
            margin: 0 auto;
            display: flex;
            align-items: center;
            gap: 25px; 
           margin-top:15px;
        }

        .driver-profile-pic {
            width: 110px;
            height: 110px;
            border-radius: 50%;
            border: 4px solid rgba(255, 255, 255, 0.3); 
            object-fit: cover;
            background-color: white;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
            transition: transform 0.3s ease;
        }

        .driver-profile-pic:hover {
            transform: scale(1.05) rotate(2deg);
        }

        .driver-details-section {
            flex: 1;
        }

        .driver-greeting-text {
            font-size: 24px;
            font-weight: 400; 
            margin-bottom: 10px;
            line-height: 1.4;
        }

        .driver-fullname {
            font-weight: 800 !important;
            font-size: 28px !important;
            color: #fff !important;
            text-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        .driver-info-field {
            display: inline-flex;
            align-items: center;
            background: rgba(255, 255, 255, 0.15); 
            padding: 8px 16px;
            border-radius: 50px;
            backdrop-filter: blur(5px);
            border: 1px solid rgba(255, 255, 255, 0.2);
            margin-top: 5px;
        }

        .driver-info-icon {
            font-size: 16px;
            margin-left: 8px; 
            color: #ffd700; 
        }

        .ss {
            font-size: 14px !important;
            color: #f0f0f0 !important;
            font-weight: 600 !important;
            letter-spacing: 0.5px;
        }
        .password-card {
            position: relative;
            z-index: 2; 
            margin-top: 0 !important; 
            background: white;
            padding: 40px 30px;
            border-radius: 20px;
            box-shadow: 0 15px 40px rgba(0, 0, 0, 0.1); 
            width: 100%;
            max-width: 450px;
            text-align: center;
            margin: 0 auto 40px auto; 
        }
        @media (max-width: 600px) {
            .driver-header-wrapper {
                padding: 30px 20px 70px 20px;
                text-align: center;
            }

            .driver-header-main {
                flex-direction: column; 
                gap: 15px;
            }

            .driver-profile-pic {
                width: 90px;
                height: 90px;
            }

            .driver-fullname {
                font-size: 22px !important;
                display: block;
            }
            
            .driver-greeting-text {
                font-size: 18px;
            }
        }
        .main-content{
            padding:0px !important;
        }
        .redflagg{
            color:red;
        }
        .driver-header-wrapper,
    .driver-header-wrapper * {
        font-family: 'Cairo', sans-serif !important;
        color:white !important;
        font-size:28px !important;
    }

    .driver-header-wrapper {
        direction: rtl;
        text-align: right;
    }

    .driver-greeting-text {
        font-size: 16px;
        color: #333; 
        text-align: start;
    }

    .driver-fullname {
        font-weight: 700; /* جعل الاسم عريضاً */
        color: #000;
        unicode-bidi: plaintext;
    }
    </style>

    <script>
        function toggleDxPassword(clientControl, iconId) {
            var inputElement = clientControl.GetInputElement();
            var icon = document.getElementById(iconId);

            if (inputElement.type === "password") {
                inputElement.type = "text";
                icon.classList.remove("fa-eye");
                icon.classList.add("fa-eye-slash");
            } else {
                inputElement.type = "password";
                icon.classList.remove("fa-eye-slash");
                icon.classList.add("fa-eye");
            }
        }
        document.addEventListener("DOMContentLoaded", function () {
            // 1. إمساك الحاوية التي وضعنا فيها الأسماء
            var container = document.getElementById("namesContainer");

            if (container) {
                // 2. قراءة النص الموجود داخلها (الاسم الأول + العائلة)
                var fullText = container.innerText || container.textContent;

                // 3. فحص هل يحتوي النص على حروف عربية؟
                var hasArabic = /[\u0600-\u06FF]/.test(fullText);

                // 4. تطبيق الاتجاه بناءً على النتيجة
                if (hasArabic) {
                    container.style.direction = "rtl";
                    container.style.textAlign = "right";
                } else {
                    // إذا كان إنجليزي
                    container.style.direction = "ltr";
                    container.style.textAlign = "left";
                }
            }
        });


        function onSaveClick(s, e) {
            var pass = txtPassword.GetText();
            var confirm = txtConfirm.GetText();

            if (pass !== confirm || pass === "") {
                alert("يرجى التأكد من تطابق كلمات المرور!");
                e.processOnServer = false;
            } else {
                 e.processOnServer = true;
                 alert("تم الحفظ بنجاح.......");
            }
        }
        // دالة لتشغيل البوب أب والعداد التنازلي
        function ShowRedirectPopup(url) {
            popupSuccess.Show();
            var link = document.getElementById("lnkRedirect");
            if (link) link.href = url;

            var seconds = 10;
            var element = document.getElementById("lblCountDown");

            var interval = setInterval(function () {
                seconds--;
                if (element) element.innerText = seconds;

                if (seconds <= 0) {
                    clearInterval(interval);
                    window.location.href = url;
                }
            }, 1000);
        }
    </script>
    <main>
                <dx:ASPxPopupControl ID="PopupSuccess" runat="server" ClientInstanceName="popupSuccess"
            ShowHeader="false" CloseAction="None" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter"
            Modal="true" Width="400px" AllowDragging="false">
            <ContentCollection>
                <dx:PopupControlContentControl>
                    <div style="text-align: center; padding: 20px;">
                
                        <div style="width: 110px; height: 105px; background: #e6fffa; border-radius: 50%; display: flex; align-items: center; justify-content: center; margin: 0 auto 20px auto; overflow: hidden;">
                    
                            <img src="assets/img/bii.gif" style="width: 100%; height: 100%; object-fit: cover;" alt="Success" />
                    
                        </div>

                        <h3 style="color: #333; font-family: 'Cairo', sans-serif; margin-bottom: 15px; font-weight: 700;font-size:18px">
                            مبارك! لقد أصبحت فرداً من العائلة ❤️
                        </h3>
                        <br />
                        <p style="color: #666; font-family: 'Cairo', sans-serif; font-size: 16px; margin-bottom: 20px;font-size:18px;">
                            تم إعداد حسابك بنجاح.
                            <br />
                            <br />
                            سيتم تحويلك إلى موقع االشعب على الفور للبدء.
                        </p>
                        <div style="font-weight: bold; color: #ea1f29; font-size: 18px; font-family: 'Cairo', sans-serif;">
                            جاري النقل خلال <span id="lblCountDown" clientidmode="Static" runat="server">5</span> ثوانٍ...
                        </div>

                        <a id="lnkRedirect" clientidmode="Static" runat="server" href="https://alshaeb.com/?v=d41d8cd98f00#app" style="display: block; margin-top: 15px; color: #999; text-decoration: underline; font-size: 12px;">اضغط هنا إذا لم يتم تحويلك تلقائياً</a>
                    </div>
                </dx:PopupControlContentControl>
            </ContentCollection>
        </dx:ASPxPopupControl>
            <div class="driver-header-wrapper" runat="server" id="userinfo" dir="auto">
                <div class="driver-header-main">
        
                    <img src="" alt="Driver Pic" class="driver-profile-pic" id="driverProfilePic" runat="server" />
        
                    <div class="driver-details-section">
                        <div class="driver-greeting-text">
                            <dx:ASPxLabel runat="server" ID="lblGreeting" Text="مرحباً، "></dx:ASPxLabel>
                            <span id="namesContainer" class="names-wrapper" style="display: inline-block;">
                                <dx:ASPxLabel CssClass="driver-fullname" runat="server" ID="nameatheader"></dx:ASPxLabel>
                                <dx:ASPxLabel CssClass="driver-fullname" runat="server" ID="lastheader"></dx:ASPxLabel>
                            </span>
                        </div>
                    </div>
                </div>
            </div>
            <div class="password-card">
        <div class="icon-circle">
            <i class="fas fa-lock"></i>
        </div>

        <h2>تعيين كلمة المرور</h2>
        
        <div class="input-group">
            <label>كلمة المرور الجديدة</label>
            <div class="input-wrapper">
                <dx:ASPxTextBox ID="txtPassword" runat="server" ClientInstanceName="txtPassword" 
                    Password="true" CssClass="custom-dx-input" Height="50px">
                    <Paddings PaddingRight="15px" PaddingLeft="45px" /> 
                </dx:ASPxTextBox>
                <i id="iconPass" class="fas fa-eye toggle-password" onclick="toggleDxPassword(txtPassword, 'iconPass')"></i>
            </div>
        </div>

        <div class="input-group">
            <label>تأكيد كلمة المرور</label>
            <div class="input-wrapper">
                <dx:ASPxTextBox ID="txtConfirm" runat="server" ClientInstanceName="txtConfirm" 
                    Password="true" CssClass="custom-dx-input" Height="50px">
                    <Paddings PaddingRight="15px" PaddingLeft="45px" />
                </dx:ASPxTextBox>
                <i id="iconConfirm" class="fas fa-eye toggle-password" onclick="toggleDxPassword(txtConfirm, 'iconConfirm')"></i>
            </div>
            <dx:ASPxLabel ID="confirm" runat="server" CssClass="redflagg"></dx:ASPxLabel>
        </div>

        <dx:ASPxButton ID="btnSubmit" runat="server" OnClick="btnSubmit_change" Text="حفظ التغييرات"  Width="100%" Height="50px" 
            CssClass="btn-submit-dx" AutoPostBack="true">
        </dx:ASPxButton>
    </div>
    </main>
</asp:Content>