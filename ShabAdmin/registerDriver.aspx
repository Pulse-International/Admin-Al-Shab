<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/lSite.Master" Async="true"
    CodeBehind="registerDriver.aspx.cs"
    Inherits="ShabAdmin.lDriverRegisteration" %>

<%@ Register Assembly="DevExpress.Web.v24.1, Version=24.1.6.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a"
    Namespace="DevExpress.Web" TagPrefix="dx" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <style>
        * {
            font-family: 'Cairo', sans-serif;
        }

        .dxeBase_Moderno {
            font-family: 'Cairo', sans-serif;
        }
        #MainContent_txtPhone_EC{
            font-family: 'Cairo', sans-serif;
        }
        .auth-buttons {
            display: none !important;
        }

        .main-content {
            padding: 0 !important;
        }

        .new-stepper-container {
            background: linear-gradient(180deg, #fff5f5 0%, #ffffff 100%);
/*            padding: 30px 20px 40px 20px;*/
            direction: rtl;
            border-bottom: 1px solid #eee;
            margin-bottom: 6px;
            border-radius: 0 0 30px 30px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.05);
        }

        .progress-info {
            display: flex;
            justify-content: space-around;
            color: #ea1f29;
            font-weight: 700;
            font-size: 16px;
            margin-bottom: 10px;
            padding: 0 5px;
        }

        .progress-track {
            width: 100%;
            height: 10px;
            background-color: #f0f0f0;
            border-radius: 10px;
            position: relative;
            overflow: hidden;
        }

        .progress-fill {
            height: 100%;
            background-color: #ea1f29;
            border-radius: 10px;
            transition: width 0.5s ease;
            width: 20%;
            box-shadow: 0 0 10px rgba(234, 31, 41, 0.3);
        }

        .steps-row {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            position: relative;
            padding: 11px 10px;
        }

        .step-item {
            display: flex;
            flex-direction: column;
            align-items: center;
            position: relative;
            z-index: 2;
            width: 18%;
            cursor: default;
        }

        .step-circle {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            background: #ffffff;
            border: 2px solid #e0e0e0;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            font-size: 18px;
            color: #aeaeae;
            margin-bottom: 12px;
            transition: all 0.3s ease;
            box-shadow: 0 4px 10px rgba(0,0,0,0.05);
        }

        .step-label {
            font-size: 12px;
            color: #aeaeae;
            text-align: center;
            font-weight: 600;
            line-height: 1.4;
        }

        /* الحالات (Active & Completed) */
        .step-item.active .step-circle {
            background: #ea1f29;
            border-color: #ea1f29;
            color: #ffffff;
            box-shadow: 0 5px 15px rgba(234, 31, 41, 0.4);
            transform: scale(1.1);
        }

        .step-item.active .step-label {
            color: #ea1f29;
            font-weight: 800;
        }

        .step-item.completed .step-circle {
            background: #28a745;
            border-color: #28a745;
            color: #ffffff;
        }

        .step-item.completed .step-label {
            color: #28a745;
        }

        /* --- تصميم الإطار والعنوان (Fieldset & Legend) --- */
        .step-fieldset {
            border: 2px solid #f0f0f0;
            border-radius: 15px;
            padding: 25px 30px;
            margin-bottom: 25px;
            position: relative;
            background: #fff;
        }

        .step-legend {
            width: auto;
            border-bottom: none;
            margin-bottom: 0;
            font-size: 18px;
            font-weight: 700;
            color: #ea1f29;
            padding: 5px 15px;
            background: #fff;
            border-radius: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            display: inline-block;
        }

            .step-legend i {
                margin-left: 8px;
            }

        /* --- تحسين عرض الصور (Preview Styles) --- */
        .image-preview-container {
            margin-top: 10px;
            border: 2px dashed #ddd;
            border-radius: 10px;
            padding: 10px;
            text-align: center;
            background: #fafafa;
            min-height: 100px;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.3s;
        }

            .image-preview-container img {
                max-width: 100%;
                max-height: 250px;
                border-radius: 8px;
                box-shadow: 0 4px 10px rgba(0,0,0,0.1);
                display: block;
                margin: 0 auto;
            }

            .image-preview-container.has-image {
                border-style: solid;
                border-color: #ea1f29;
                background: #fff;
            }

        /* --- تنسيق المراجعة (Review) --- */
        .review-section {
            background: #f9f9f9;
            border-radius: 15px;
            padding: 20px;
            margin-bottom: 20px;
            border: 1px solid #eee;
        }

        .review-title {
            color: #ea1f29;
            font-weight: bold;
            font-size: 18px;
            border-bottom: 2px solid #eee;
            padding-bottom: 10px;
            margin-bottom: 15px;
        }

        .review-item {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
            border-bottom: 1px dashed #ddd;
            padding-bottom: 5px;
        }

        .review-label {
            font-weight: 600;
            color: #666;
        }

        .review-value {
            font-weight: bold;
            color: #333;
        }

        /* شبكة صور المراجعة */
        .review-images-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(150px, 1fr));
            gap: 15px;
            margin-top: 15px;
        }

        .review-img-card {
            background: white;
            padding: 10px;
            border-radius: 10px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            text-align: center;
            display: none;
        }

            .review-img-card span {
                display: block;
                font-size: 12px;
                font-weight: bold;
                margin-bottom: 5px;
                color: #555;
            }

            .review-img-card img {
                width: 100%;
                height: 100px;
                object-fit: cover;
                border-radius: 5px;
                cursor: zoom-in;
                border: 1px solid #ddd;
                transition: transform 0.2s;
            }

                .review-img-card img:hover {
                    transform: scale(1.05);
                }

        /* --- Lightbox (تكبير الصور) --- */
        .lightbox-modal {
            display: none;
            position: fixed;
            z-index: 9999;
            padding-top: 50px;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            overflow: auto;
            background-color: rgba(0,0,0,0.9);
        }

        .lightbox-content {
            margin: auto;
            display: block;
            max-width: 90%;
            max-height: 85vh;
            border: 5px solid white;
            border-radius: 5px;
            animation: zoom 0.6s;
        }

        .lightbox-close {
            position: absolute;
            top: 15px;
            right: 35px;
            color: #f1f1f1;
            font-size: 40px;
            font-weight: bold;
            transition: 0.3s;
            cursor: pointer;
        }

            .lightbox-close:hover {
                color: #bbb;
            }

        @keyframes zoom {
            from {
                transform: scale(0)
            }

            to {
                transform: scale(1)
            }
        }

        /* --- البطاقة والأزرار --- */
        .main-card {
            max-width: 850px;
            margin: 0 auto 40px auto;
            padding: 40px 50px;
            background: white;
            border-radius: 20px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.1);
        }

        .step-content {
            display: none;
            animation: fadeIn 0.5s ease;
        }

            .step-content.active {
                display: block;
            }

        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(10px);
            }

            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .form-navigation {
            display: flex;
            justify-content: space-between;
            gap: 15px;
            margin-top: 30px;
        }

        .btn-nav {
            flex: 1;
            padding: 15px;
            border: none;
            border-radius: 10px;
            font-size: 16px;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .btn-next {
            background: #ea1f29;
            color: white;
        }

        .btn-prev {
            background: #6c757d;
            color: white;
        }

        .btn-next:hover {
            background: #c91b24;
            transform: translateY(-2px);
        }

        #MainContent_btnSubmit {
            background: #ea1f29 !important;
            border: none !important;
            border-radius: 10px !important;
            font-size: 18px !important;
            font-weight: 700 !important;
            color: white !important;
            padding: 15px 30px !important;
            cursor: pointer !important;
            box-shadow: 0 8px 20px rgba(234, 31, 41, 0.3) !important;
            width: 60% !important;
        }

        #MainContent_btnUpdate {
            background: linear-gradient(135deg, #ea1f29 0%, #c0151e 100%) !important;
            color: white !important;
            font-size: 16px !important;
            font-weight: bold !important;
            border-radius: 50px !important;
            padding: 12px 35px !important; 
            box-shadow: 0 10px 25px rgba(234, 31, 41, 0.4) !important; 
            border: none !important;
            width: auto !important; 
            min-width: 200px;
            transition: all 0.3s ease;
        }

            #MainContent_btnUpdate:hover {
                transform: translateY(-5px); 
                box-shadow: 0 15px 30px rgba(234, 31, 41, 0.6) !important;
            }
        /* حركة الظهور */
        @keyframes slideUp {
            from {
                transform: translateY(100px);
                opacity: 0;
            }

            to {
                transform: translateY(0);
                opacity: 1;
            }
        }

        .main-card.edit-layout {
            padding-bottom: 80px !important;
        }
        /* Note Box & Alerts */
        .note-box {
            background-color: #fff8f8;
            border-right: 4px solid #ea1f29;
            padding: 15px;
            margin-bottom: 25px;
            border-radius: 8px;
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .note-icon {
            font-size: 24px;
            color: #ea1f29;
        }

        .note-text {
            color: #555;
            font-size: 14px;
            font-weight: 600;
        }

        /* استبدل كود CSS القديم بهذا */
        .driver-alert-card {
            background: #fff5f5 !important; /* خلفية حمراء فاتحة جداً */
            border-right: 5px solid #ea1f29 !important; /* خط أحمر جانبي */
            border-radius: 12px !important;
            padding: 25px 30px !important;
            display: flex !important;
            gap: 25px !important;
            align-items: flex-start !important;
            max-width: 800px;
            margin: 30px auto;
            box-shadow: 0 10px 30px rgba(234, 31, 41, 0.08); /* ظل أحمر خفيف */
            position: relative;
            overflow: hidden;
        }

        .driver-alert-icon {
            font-size: 32px;
            color: #ea1f29;
            background: #fff;
            width: 60px;
            height: 60px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05);
            flex-shrink: 0;
        }

        .driver-alert-body {
            flex: 1;
        }

        .driver-alert-heading {
            font-size: 20px;
            font-weight: 800;
            color: #ea1f29;
            margin-bottom: 8px;
            font-family: 'Cairo', sans-serif;
        }

        .driver-alert-text {
            font-size: 15px;
            color: #555;
            line-height: 1.7;
            font-weight: 600;
        }

            .driver-alert-text ul {
                margin: 10px 0 0 0;
                padding-right: 20px;
            }

            .driver-alert-text li {
                margin-bottom: 6px;
                color: #333;
            }

        .dxpc-header {
            background: #ea1f29 !important;
            color: white !important;
            font-weight: 700 !important;
            padding: 20px !important;
        }

        .driver-header-wrapper {
            background: linear-gradient(135deg, #ea1f29 0%, #c91b24 100%) !important;
            padding: 40px 30px !important;
            border-radius: 0 0 30px 30px;
            margin-bottom: 30px;
            color: white;
            box-shadow: 0 5px 20px rgba(234, 31, 41, 0.3);
        }

        .driver-header-main {
                display: flex;
                align-items: center;
                gap: 15px;
                justify-content:center;
        }

        .driver-profile-pic {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            border: 4px solid #fff;
            object-fit: cover;
            box-shadow: 0 4px 15px rgba(0,0,0,0.2);
            flex-shrink: 0;
        }

        .driver-details-section {
            flex: 1;
        }

        .driver-greeting-text {
            font-size: 24px;
            font-weight: 700;
            margin-bottom: 10px;
            color: white;
            margin-left:20px;
        }

        .driver-fullname {
            color: white !important;
            font-size: 40px;
        }

        .driver-info-row {
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 16px;
            opacity: 0.95;
        }

        .driver-info-icon {
            font-size: 18px;
        }

        .ss {
            color: white !important;
        }

        .main-card.edit-layout {
            display: flex;
            flex-direction: row; /* القائمة يمين والمحتوى يسار */
            gap: 25px;
            background: transparent !important;
            box-shadow: none !important;
            padding: 0 !important;
            max-width: 1228px !important;
        }

        .edit-sidebar {
            width: 280px;
            background: white;
            border-radius: 15px;
            padding: 20px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.05);
            flex-shrink: 0;
            height: fit-content;
        }

        .edit-sidebar {
            position: sticky;
            top: 177px; /* المسافة من أعلى الشاشة */
            height: fit-content;
            z-index: 100;
        }
        /* تنسيق الحقول */
        .dxeTextBoxSys, .dxeButtonEditSys {
            border-radius: 8px !important;
            border: 1px solid #e0e0e0 !important;
            padding: 10px 15px !important;
            transition: all 0.3s ease;
            background-color: #fcfcfc !important;
        }
        /* جعل الصورة الشخصية دائرية */
        #preview_userPic img {
            width: 150px !important;
            height: 150px !important;
            border-radius: 50% !important;
            object-fit: cover;
            border: 4px solid #ea1f29;
            padding: 3px;
            background: white;
        }

        /* تحسين منطقة الرفع */
        .image-preview-container {
            background-color: #f8f9fa;
            border: 2px dashed #ccc;
            transition: all 0.3s;
        }

            .image-preview-container:hover {
                border-color: #ea1f29;
                background-color: #fff5f5;
            }

        /* عند الضغط داخل الحقل */
        .dxeTextBoxSys:focus-within, .dxeButtonEditSys:focus-within {
            border-color: #ea1f29 !important;
            box-shadow: 0 0 0 3px rgba(234, 31, 41, 0.1) !important;
            background-color: #fff !important;
        }

        .sidebar-header {
            font-size: 18px;
            font-weight: 700;
            color: #333;
            margin-bottom: 20px;
            text-align: center;
        }

        .sidebar-item {
            padding: 15px 20px;
            margin-bottom: 12px;
            border-radius: 10px;
            cursor: pointer;
            background: #f8f9fa;
            color: #555;
            font-weight: 600;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 10px;
            border: 1px solid #eee;
        }

            .sidebar-item:hover {
                background: #ffecec;
                color: #ea1f29;
            }

            .sidebar-item.active {
                background: linear-gradient(135deg, #ea1f29 0%, #ff4b55 100%);
                color: white;
                border: none;
                box-shadow: 0 4px 10px rgba(234, 31, 41, 0.3);
            }

        /* منطقة المحتوى في وضع التعديل */
        .edit-layout .step-content {
            flex-grow: 1;
            background: white;
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.05);
            display: none;
        }

        /* إخفاء حدود الـ Fieldset القديمة في وضع التعديل */
        .edit-layout .step-fieldset {
            border: none !important;
            padding: 0 !important;
            box-shadow: none !important;
        }

        .edit-layout .step-legend {
            display: none;
        }

        /* إخفاء أزرار التنقل القديمة في وضع التعديل */
        .edit-layout .form-navigation:not(.edit-mode-nav) {
            display: none !important;
        }
        /* --- تصميم الزر العائم (Floating Capsule) --- */
        .edit-mode-nav {
            position: fixed;
            bottom: 30px; /* مسافة من الأسفل */
            left: 30px; /* مسافة من اليسار (للغة العربية) */
            width: auto !important; /* العرض حسب المحتوى */
            background: transparent; /* بدون خلفية للشريط */
            padding: 0;
            box-shadow: none;
            z-index: 1000;
            border: none;
            animation: slideUp 0.5s ease-out;
        }

        @media (max-width: 900px) {
            .edit-sidebar {
                /* إخفاء شريط السكرول للشكل الجمالي */
                scrollbar-width: none; /* Firefox */
                -ms-overflow-style: none; /* IE 10+ */
                position:static !important;
                display:block !important;
                margin-bottom:11px;
            }
            .dxpcLite_Moderno, .dxdpLite_Moderno{
                width:auto !important;
            }
            .edit-mode-nav{
                position:static;
                margin:20px auto;
            }
            .bts{
                    padding: 10px 67px !important; 
                    margin:0px 5px;
            }
            .btn-next {
                margin:0px 5px;
            }
            .main-card.edit-layout{
                gap:0px !important;
            }
            .driver-fullname{
                font-size:16px;
            }
            .main-card{
                padding:17px 0px;
            }

                .edit-sidebar::-webkit-scrollbar {
                    display: none; /* Chrome/Safari */
                }

            .sidebar-item {
                min-width: 120px; /* عرض أدنى للأزرار في الموبايل */
                text-align: center;
                justify-content: center;
            }
        }

        @media (max-width: 900px) {
            .main-card.edit-layout {
                flex-direction: column;
            }

            .edit-sidebar {
                width: 100%;
                display: flex;
                overflow-x: auto;
                padding: 10px;
                gap: 10px;
            }

            .sidebar-item {
                margin-bottom: 0;
                white-space: nowrap;
                flex: 1;
                justify-content: center;
            }
        }
        .bts{
            display:flex;
            padding: 6px 34%;
            gap:12px;
        }
    .edit-profile-header {
        display: flex;
        align-items: center;
        gap: 10px;
        background-color: #fff;
        border: 2px solid #ffcc00;
        padding: 5px 15px;
        border-radius: 10px;
        cursor: pointer;
        white-space: nowrap; 
    }

.edit-profile-header:hover {
    transform: translateY(-3px); /* حركة خفيفة عند المرور */
}

.edit-profile-header i {
    font-size: 22px;
    color: #ea1f29;
}

.edit-profile-header .header-text {
    display: flex;
    flex-direction: column;
}

.edit-profile-header .main-title {
    font-size: 18px;
    font-weight: 800;
    line-height: 1.2;
}

.edit-profile-header .sub-title {
    font-size: 12px;
    color: #666;
    font-weight: 600;
}
.info-and-badge-wrapper {
        display: flex;
        align-items: center;      
        justify-content: space-between; 
        flex-grow: 1;              
        padding-left: 10px;
    }
@media (max-width:900px){
    .info-and-badge-wrapper {
        display: block;
        align-items: center;      
        justify-content: space-between; 
        flex-grow: 1;              
        padding-left: 10px;
    }
}
    </style>
    <script type="text/javascript">
        // 1. منطق الـ Stepper (5 خطوات مع علامة الصح)
        var currentStep = 1;
        var totalSteps = 5;

        function updateProgressBar(step) {
            var percentage = (step / totalSteps) * 100;
            document.getElementById('progressBarFill').style.width = percentage + '%';
            document.getElementById('progressText').innerText = percentage + '%';
            document.getElementById('stepCounterText').innerText = 'خطوة ' + step + ' من ' + totalSteps;

            for (var i = 1; i <= totalSteps; i++) {
                var stepItem = document.querySelector('.step-item[data-step="' + i + '"]');
                var circle = stepItem.querySelector('.step-circle');
                stepItem.classList.remove('active', 'completed');

                if (i < step) {
                    stepItem.classList.add('completed');
                    circle.innerHTML = '<i class="fas fa-check"></i>'; // علامة الصح
                } else if (i === step) {
                    stepItem.classList.add('active');
                    circle.innerHTML = i;
                } else {
                    circle.innerHTML = i;
                }
            }
        }

        function nextStep(step) {
            var container = document.querySelector('.step-content[data-step="' + step + '"]');

            if (typeof ASPxClientEdit !== 'undefined' && !ASPxClientEdit.ValidateEditorsInContainer(container)) return;

            var imageErrorMsg = validateImagesForStep(step);
            if (imageErrorMsg !== null) {
                document.getElementById('lblValidationError').innerText = imageErrorMsg;
                ValidationPopup.Show();
                return; 
            }

            if (hasCustomErrors(step)) {
                document.getElementById('lblValidationError').innerText = 'يرجى تصحيح البيانات المكررة (المشار إليها باللون الأحمر) قبل المتابعة!';
                ValidationPopup.Show();
                return;
            }

            document.querySelector('.step-content[data-step="' + step + '"]').classList.remove('active');
            var nextStepNum = step + 1;
            currentStep = nextStepNum;
            document.querySelector('.step-content[data-step="' + nextStepNum + '"]').classList.add('active');

            updateProgressBar(nextStepNum);

            if (nextStepNum === 5) {
                populateReviewData();
            }

            window.scrollTo({ top: 0, behavior: 'smooth' });
        }

        function prevStep(step) {
            document.querySelector('.step-content[data-step="' + step + '"]').classList.remove('active');
            var prevStepNum = step - 1;
            currentStep = prevStepNum;
            document.querySelector('.step-content[data-step="' + prevStepNum + '"]').classList.add('active');
            updateProgressBar(prevStepNum);
            window.scrollTo({ top: 0, behavior: 'smooth' });
        }

        function hasCustomErrors(step) {
            if (step === 1) {
                try { if (typeof lblPhoneMessage !== 'undefined' && lblPhoneMessage.GetText().includes('❌')) return true; } catch (e) { }
                try { if (typeof ASPxLabel2 !== 'undefined' && ASPxLabel2.GetText().includes('❌')) return true; } catch (e) { }
            } else if (step === 2) {
                try { if (typeof abcdefg !== 'undefined' && abcdefg.GetText().includes('❌')) return true; } catch (e) { }
            } else if (step === 4) {
                try { if (typeof ASPxLabel3 !== 'undefined' && ASPxLabel3.GetText().includes('❌')) return true; } catch (e) { }
            }
            return false;
        }

        function onPreviewImage(s, e, previewId) {
            try {
                var input = s.GetFileInputElement(0);
                if (!input) {
                    input = s.GetMainElement().querySelector('input[type="file"]');
                }

                if (input && input.files && input.files[0]) {
                    var file = input.files[0];
                    if (!file.type.match('image.*')) {
                        alert('⚠️ الرجاء اختيار صورة صحيحة!');
                        return;
                    }

                    var reader = new FileReader();
                    reader.onload = function (e) {
                        var previewDiv = document.getElementById(previewId);
                        if (previewDiv) {
                            previewDiv.innerHTML = '<img src="' + e.target.result + '" alt="Preview" />';
                            previewDiv.classList.add('has-image');
                        }
                    };
                    reader.readAsDataURL(file);
                }
            } catch (ex) {
                console.error("❌ Exception in onPreviewImage: " + ex.message);
            }
        }

        function populateReviewData() {
            try {
                function safeSetText(elementId, value) {
                    var element = document.getElementById(elementId);
                    if (element) element.innerText = value || 'غير محدد';
                }
                safeSetText('rev_name', txtFirstName.GetText() + ' ' + txtLastName.GetText());
                safeSetText('rev_phone', txtPhone.GetText());
                safeSetText('rev_email', txtEmail.GetText());
                safeSetText('rev_country', coutryid.GetText());
                safeSetText('rev_docType', documentType.GetText());
                safeSetText('rev_docNum', documentnumber.GetText());
                safeSetText('rev_carType', carKind.GetText());
                safeSetText('rev_carModel', carmarka.GetText());
                safeSetText('rev_plate', Vehieclenumber.GetText());

                copyImageToReview('preview_userPic', 'rev_img_user');
                copyImageToReview('preview_idFront', 'rev_img_idFront');
                copyImageToReview('preview_idBack', 'rev_img_idBack');
                copyImageToReview('preview_passport', 'rev_img_passport');
                copyImageToReview('preview_residence', 'rev_img_residence');
                copyImageToReview('preview_license', 'rev_img_license');
                copyImageToReview('preview_carLicense', 'rev_img_carLicense');
                copyImageToReview('preview_car', 'rev_img_car');
            } catch (e) { }
        }

        function copyImageToReview(previewId, reviewImgId) {
            try {
                var previewDiv = document.getElementById(previewId);
                var reviewImg = document.getElementById(reviewImgId);
                if (!reviewImg) return;
                var container = reviewImg.parentElement;
                if (previewDiv) {
                    var imgInside = previewDiv.querySelector('img');
                    if (imgInside && imgInside.src && imgInside.src.startsWith('data:image')) {
                        reviewImg.src = imgInside.src;
                        container.style.display = 'block';
                    } else {
                        container.style.display = 'none';
                    }
                } else {
                    container.style.display = 'none';
                }
            } catch (ex) { }
        }

        function openLightbox(imgElement) {
            if (!imgElement.src || !imgElement.src.startsWith('data:image')) return;
            var modal = document.getElementById("imgLightbox");
            var modalImg = document.getElementById("imgLightboxContent");
            modal.style.display = "block";
            modalImg.src = imgElement.src;
        }

        function closeLightbox() {
            document.getElementById("imgLightbox").style.display = "none";
        }

        function OnDocumentTypeChanged(s, e) {
            var value = s.GetValue();
            document.getElementById('docIdFront').style.display = (value === "1") ? 'block' : 'none';
            document.getElementById('docIdBack').style.display = (value === "1") ? 'block' : 'none';
            document.getElementById('passportDiv').style.display = (value === "2") ? 'block' : 'none';
            document.getElementById('residenceDiv').style.display = (value === "3") ? 'block' : 'none';
            if (value === "" || value === null) {
                documentnumber.SetEnabled(false);
            } else {
                documentnumber.SetEnabled(true);
            }
        }

        function changemask(s, e) {
            var country = s.GetValue();
            if (e !== null) {
                Vehieclenumber.SetValue('');
                if (typeof ASPxLabel3 !== 'undefined') ASPxLabel3.SetText('');
            }
            var input = Vehieclenumber.GetInputElement();
            input.placeholder = (country === 'الأردن') ? 'مثال: 432444-12' : 'مثال: AB1234';
        }

        function formatVehicleNumber(value, country) {
            if (country === 'الأردن') {
                var cleaned = value.replace(/\D/g, '');
                return (cleaned.length > 2) ? cleaned.substring(0, 2) + '-' + cleaned.substring(2) : cleaned;
            }
            return value.replace(/[^A-Za-z0-9]/g, '');
        }

        // --- دالة التبديل بين التبويبات في وضع التعديل ---
        function switchEditTab(stepNumber, element) {
            // إزالة كلاس active من جميع القوائم
            var items = document.querySelectorAll('.sidebar-item');
            items.forEach(function (item) { item.classList.remove('active'); });

            // إضافة active للعنصر المضغوط
            if (element) { element.classList.add('active'); }

            // إخفاء جميع المحتويات
            var contents = document.querySelectorAll('.step-content');
            contents.forEach(function (content) {
                content.style.display = 'none'; // إخفاء إجباري
            });

            // إظهار المحتوى المطلوب
            var targetContent = document.querySelector('.step-content[data-step="' + stepNumber + '"]');
            if (targetContent) {
                targetContent.style.display = 'block';
            }
        }

        window.onload = function () {
            if (typeof documentType !== 'undefined' && documentType.GetValue() === null) {
                if (typeof documentnumber !== 'undefined') documentnumber.SetEnabled(false);
            }
        };
        function hasImage(uploadControlName, previewId) {
            var uploadControl = ASPxClientControl.GetControlCollection().GetByName(uploadControlName);
            if (uploadControl && uploadControl.GetText() !== "") return true;

            var previewDiv = document.getElementById(previewId);
            if (previewDiv && previewDiv.querySelector('img') && previewDiv.querySelector('img').src.length > 10) return true;

            return false;
        }
        function validateImagesForStep(step) {
            
            if (step === 1) {
                // التحقق من الصورة الشخصية
                if (!hasImage('userPic', 'preview_userPic')) 
                    return "عذراً، يرجى رفع الصورة الشخصية للمتابعة.";
            }
            else if (step === 2) {
                // التحقق حسب نوع الوثيقة المختار
                var docType = documentType.GetValue();

                if (docType == "1") { // هوية
                    if (!hasImage('idFrontPic', 'preview_idFront')) 
                        return "يرجى رفع صورة الهوية (الوجه الأمامي).";
                    
                    if (!hasImage('idBackPic', 'preview_idBack')) 
                        return "يرجى رفع صورة الهوية (الوجه الخلفي).";
                }
                else if (docType == "2") { // جواز سفر
                    if (!hasImage('passportPic', 'preview_passport')) 
                        return "يرجى رفع صورة جواز السفر.";
                }
                else if (docType == "3") { // إقامة
                    if (!hasImage('residencePic', 'preview_residence')) 
                        return "يرجى رفع صورة الإقامة.";
                }
                else {
                    // لم يتم اختيار نوع وثيقة
                    return "يرجى اختيار نوع الوثيقة أولاً.";
                }
            }
            else if (step === 3) {
                // رخصة القيادة
                if (!hasImage('licensePic', 'preview_license')) 
                    return "يرجى رفع صورة رخصة القيادة.";
            }
            else if (step === 4) {
                // رخصة المركبة + صورة المركبة
                if (!hasImage('carLicensePic', 'preview_carLicense')) 
                    return "يرجى رفع صورة رخصة المركبة (الاقتناء).";
                
                if (!hasImage('carPic', 'preview_car')) 
                    return "يرجى رفع صورة المركبة.";
            }

            return null; // null تعني أنه لا توجد أخطاء
        }
    </script>
    <main>
        
        <div id="imgLightbox" class="lightbox-modal" onclick="closeLightbox()">
            <span class="lightbox-close" onclick="closeLightbox()">&times;</span>
            <img class="lightbox-content" id="imgLightboxContent">
        </div>

            <div class="driver-header-wrapper" runat="server" id="userinfo">
                <div class="driver-header-main">
        
                    <img src="" alt="صورة السائق" class="driver-profile-pic" id="driverProfilePic" runat="server" width="80" height="80">

                    <div class="info-and-badge-wrapper">
            
                        <div class="driver-details-section">
                            <div class="driver-greeting-text">
                                مرحباً، <dx:ASPxLabel CssClass="driver-fullname" runat="server" ID="lastheader"></dx:ASPxLabel>
                                <dx:ASPxLabel CssClass="driver-fullname" runat="server" ID="nameatheader"></dx:ASPxLabel>
                            </div>
                            <div class="driver-info-field">
                                <span class="driver-info-icon">✉</span>
                                <dx:ASPxLabel CssClass="ss" runat="server" ID="driverEmailAddress"></dx:ASPxLabel>
                            </div>
                        </div>

                        <div id="editBadge" runat="server" class="edit-profile-header" visible="false">
                            <i class="fas fa-pen-to-square"></i>
                            <div class="header-text">
                                <span class="main-title" style="color:#d32f2f; font-weight:bold;">تحديث ملفي الشخصي</span>
                            </div>
                        </div>

                    </div>

                </div>
            </div>

        <dx:ASPxPopupControl ID="notePopup" runat="server" ClientInstanceName="notePopup" ShowOnPageLoad="false"
            PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" AllowDragging="True" CloseOnEscape="True" CloseAction="CloseButton" Modal="True" Width="500px" MaxWidth="500px" HeaderText="تنبيه هام">
            <ContentCollection><dx:PopupControlContentControl runat="server">
                <div class="driver-alert-card">
                    <div class="driver-alert-icon">⚠️</div>
                    <div class="driver-alert-body">
                        <div class="driver-alert-heading">يُرجى الانتباه</div>
                        <div class="driver-alert-text">
                            يرجى اخذ الملاحظات التالية بعين الاعتبار للموافقة على الطلب:
                            <ul runat="server" id="unorderr"></ul>
                        </div>
                    </div>
                </div>
            </dx:PopupControlContentControl></ContentCollection>
        </dx:ASPxPopupControl>

        <div class="driver-alerts-wrapper" runat="server" id="note">
            <div class="driver-alert-card" style="margin-bottom:20px;">
                <div class="driver-alert-icon">⚠️</div>
                <div class="driver-alert-body">
                    <div class="driver-alert-heading">يُرجى الانتباه</div>
                    <div class="driver-alert-text">
                        يرجى اخذ الملاحظات التالية بعين الاعتبار للموافقة على الطلب:
                        <ul runat="server" id="unorder"></ul>
                    </div>
                </div>
            </div>
        </div>

        <div class="new-stepper-container" id="stepperContainer" runat="server">
            <div class="progress-info">
                <span id="progressText">20%</span>
                <span id="stepCounterText">خطوة 1 من 5</span>
            </div>
            <div class="progress-track">
                <div class="progress-fill" id="progressBarFill"></div>
            </div>
            <div class="steps-row">
                <div class="step-item active" data-step="1">
                    <div class="step-circle">1</div>
                    <div class="step-label">البيانات<br>الشخصية</div>
                </div>
                <div class="step-item" data-step="2">
                    <div class="step-circle">2</div>
                    <div class="step-label">وثائق<br>الهوية</div>
                </div>
                <div class="step-item" data-step="3">
                    <div class="step-circle">3</div>
                    <div class="step-label">الرخصة</div>
                </div>
                <div class="step-item" data-step="4">
                    <div class="step-circle">4</div>
                    <div class="step-label">المركبة</div>
                </div>
                <div class="step-item" data-step="5">
                    <div class="step-circle">5</div>
                    <div class="step-label">المراجعة</div>
                </div>
            </div>
        </div>

        <div class="main-card" id="mainCardPanel" runat="server">
            
            <div style="text-align:center; margin-bottom: 30px;">
                <div id="divAddTitle" runat="server" class="bts" style="background:#ea1f29; border-radius:15px; color:white;">
                    <dx:ASPxLabel ID="addtitlee" style="color: #ffffff; font-size:22px; font-weight: 700;" runat="server" Text="تسجيل سائق جديد"></dx:ASPxLabel>
                    <i class="fas fa-user-plus" style="font-size:30px; margin-top:10px; display:block;"></i>
                </div>
                <div id="divEditTitle" runat="server" class="bts" style="background:#ea1f29; border-radius:15px; color:white;">
                    <dx:ASPxLabel ID="ASPxLabel5" style="color: #ffffff; font-size:28px; font-weight: 700;" runat="server" Text="تحديث بيانات السائق"></dx:ASPxLabel>
                    <i class="fas fa-user-edit" style="font-size:30px; margin-top:10px; display:block;"></i>
                </div>
            </div>

            <dx:ASPxLabel ID="lblMessage" runat="server" Style="display: block; margin: 20px auto; text-align: center; color:red; font-size:20px;" />
            <dx:ASPxLabel ID="ASPxLabel1" runat="server" Style="display: block; margin-top: 20px; text-align: center; font-weight: 600;" />

            <div id="EditModeSidebar" runat="server" class="edit-sidebar" visible="false">
                <div class="sidebar-header">أقسام البيانات</div>
                <div class="sidebar-item active" onclick="switchEditTab(1, this)">
                    <i class="fas fa-user"></i> البيانات الشخصية
                </div>
                <div class="sidebar-item" onclick="switchEditTab(2, this)">
                    <i class="fas fa-id-card"></i> وثائق الهوية
                </div>
                <div class="sidebar-item" onclick="switchEditTab(3, this)">
                    <i class="fas fa-id-badge"></i> رخصة القيادة
                </div>
                <div class="sidebar-item" onclick="switchEditTab(4, this)">
                    <i class="fas fa-car"></i> معلومات المركبة
                </div>
            </div>

            <div class="step-content active" data-step="1">
                <fieldset class="step-fieldset">
                    <legend class="step-legend"><i class="fas fa-user"></i> المعلومات الشخصية</legend>
                    
                    <div style="margin-bottom: 25px; text-align:center;">
                        <label style="display:block; margin-bottom:10px;">الصورة الشخصية <span style="color:red">*</span></label>
                        <dx:ASPxUploadControl ID="userPic" runat="server" ClientInstanceName="userPic" Width="100%" 
                            UploadMode="Standard" ShowProgressPanel="false" BrowseButton-Text="رفع صورة">
                             <ClientSideEvents TextChanged="function(s,e){ onPreviewImage(s,e,'preview_userPic'); }" />
                             <ValidationSettings AllowedFileExtensions=".jpg, .jpeg, .png, .bmp" GeneralErrorText="حدث خطأ أثناء تحميل الصور ، الرجاء المحاولة لاحقا" MaxFileSize="10000000" MaxFileSizeErrorText="حجم الصورة أكبر من 10 ميجابايت ، الرجاء اختيار صورة بحجم أقل" NotAllowedFileExtensionErrorText="امتداد الصورة غير مسموح به">
                              </ValidationSettings>
                        </dx:ASPxUploadControl>
                        <div id="preview_userPic" class="image-preview-container">
                            <span style="color:#aaa;">ستظهر الصورة هنا</span>
                        </div>
                    </div>

                    <div style="margin-bottom: 20px;">
                        <label>الدولة <span style="color:red">*</span></label>
                        <dx:ASPxComboBox ID="ddlCity" runat="server" Width="100%" Height="45px" ClientInstanceName="coutryid">
                            <Items>
                                <dx:ListEditItem Text="-- اختر المدينة --" Value="" />
                                <dx:ListEditItem Text="الأردن" Value="الأردن" />
                            </Items>
                            <ValidationSettings RequiredField-IsRequired="true" ErrorText="مطلوب" Display="Dynamic" SetFocusOnError="True" >
                            <RequiredField IsRequired="True"></RequiredField>
                            </ValidationSettings>
                            <ClientSideEvents SelectedIndexChanged="changemask" />
                        </dx:ASPxComboBox>
                    </div>

                    <div style="margin-bottom: 20px;">
                        <label>رقم الهاتف <span style="color:red">*</span></label>
                        <dx:ASPxTextBox ID="txtPhone" runat="server" ClientInstanceName="txtPhone" Width="100%"  Height="45px">
                        <ClientSideEvents TextChanged="function(s, e) { 
                                                        var phone = s.GetValue();
                                                        if (ASPxClientEdit.ValidateGroup('userGroupRegister')) {  
                                                         phoneCallback.PerformCallback(phone); 
                                                        }
                                                    }"
                                 KeyPress="function(s, e){
                                    // منع كتابة أي شيء غير الأرقام
                                    if(e.htmlEvent.key.length === 1 && !/[0-9]/.test(e.htmlEvent.key)){
                                        e.htmlEvent.preventDefault();
                                    }
                                }" />
                                                  <HelpTextStyle Font-Names="Arabic Typesetting">
                            </HelpTextStyle>
                                                  <ValidationSettings Display="Dynamic" SetFocusOnError="True" ValidationGroup="userGroupRegister" ErrorDisplayMode="Text" ErrorTextPosition="Bottom">
                            <ErrorFrameStyle Font-Size="0.8em">
                            </ErrorFrameStyle>
                            <RegularExpression ErrorText="يجب أن يكون رقم الهاتف 10 خانات على الأقل (أرقام)" ValidationExpression="^(?=.{10,})[0-9]*$" />
                            <RequiredField IsRequired="True" />
                        </ValidationSettings>
                        </dx:ASPxTextBox>
                        <dx:ASPxLabel ID="lblPhoneMessage" runat="server" ClientInstanceName="lblPhoneMessage" />
                        <dx:ASPxCallback ID="phoneCallback" runat="server" ClientInstanceName="phoneCallback" OnCallback="phoneCallback_Callback">
                            <ClientSideEvents CallbackComplete="function(s, e) { 
                                if (e.result == 'exists') {
                                    lblPhoneMessage.SetText('❌ هذا الرقم مسجل مسبقاً!');
                                    lblPhoneMessage.GetMainElement().style.color = 'red';
                                    if (typeof btnSubmit !== 'undefined') btnSubmit.SetEnabled(false);
                                } else {
                                    lblPhoneMessage.SetText('✅ الرقم متاح');
                                    lblPhoneMessage.GetMainElement().style.color = 'green';
                                    if (typeof btnSubmit !== 'undefined') btnSubmit.SetEnabled(true);
                                }
                            }" />
                        </dx:ASPxCallback>
                    </div>

                    <div style="display:flex; gap:15px; margin-bottom: 20px;">
                        <div style="flex:1;">
                            <label>الاسم الأول <span style="color:red">*</span></label>
                            <dx:ASPxTextBox ID="txtFirstName" runat="server" ClientInstanceName="txtFirstName" Width="100%" Height="45px">
                                <ValidationSettings RequiredField-IsRequired="true" Display="Dynamic" SetFocusOnError="True" >
<RequiredField IsRequired="True"></RequiredField>
                                </ValidationSettings>
                            </dx:ASPxTextBox>
                        </div>
                        <div style="flex:1;">
                            <label>اسم العائلة <span style="color:red">*</span></label>
                            <dx:ASPxTextBox ID="txtLastName" runat="server" ClientInstanceName="txtLastName" Width="100%" Height="45px">
                                <ValidationSettings RequiredField-IsRequired="true" Display="Dynamic" SetFocusOnError="True" >
<RequiredField IsRequired="True"></RequiredField>
                                </ValidationSettings>
                            </dx:ASPxTextBox>
                        </div>
                    </div>

                    <div style="margin-bottom: 20px;">
                        <label>البريد الإلكتروني <span style="color:red">*</span></label>
                        <dx:ASPxTextBox ID="txtEmail" runat="server" ClientInstanceName="txtEmail" Width="100%" Height="45px">
                        <ClientSideEvents TextChanged="function(s, e) { 
                                                        var email = s.GetValue();
                                                        if (ASPxClientEdit.ValidateGroup('emailGroupRegister')) {  
                                                         emailCallback.PerformCallback(email); 
                                                        }
                                                    }" />
                        <ValidationSettings Display="Dynamic" SetFocusOnError="True" ValidationGroup="emailGroupRegister" ErrorDisplayMode="Text" ErrorTextPosition="Bottom">
                            <ErrorFrameStyle Font-Size="0.8em">
                            </ErrorFrameStyle>
                            <RegularExpression ErrorText="الايميل غير صحيح" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"/>
                            <RequiredField IsRequired="True" />
                        </ValidationSettings>
                        </dx:ASPxTextBox>
                        <dx:ASPxLabel ID="ASPxLabel2" runat="server" ClientInstanceName="ASPxLabel2" />
                        <dx:ASPxCallback ID="ASPxCallback1" runat="server" ClientInstanceName="emailCallback" OnCallback="emailCallback_Callback">
                            <ClientSideEvents CallbackComplete="function(s, e) { 
                                if (e.result == 'exists') {
                                    ASPxLabel2.SetText('❌ الايميل مسجل مسبقاً!');
                                    ASPxLabel2.GetMainElement().style.color = 'red';
                                    if (typeof btnSubmit !== 'undefined') btnSubmit.SetEnabled(false);
                                } else {
                                    ASPxLabel2.SetText('✅ متاح');
                                    ASPxLabel2.GetMainElement().style.color = 'green';
                                    if (typeof btnSubmit !== 'undefined') btnSubmit.SetEnabled(true);
                                }
                            }" />
                        </dx:ASPxCallback>
                    </div>

                    <div style="display:flex; gap:15px; margin-bottom: 20px;">
                        <div style="flex:1;">
                            <label>الجنس</label>
                            <dx:ASPxComboBox runat="server" ID="gender" Width="100%" Height="45px">
                                <Items>
                                    <dx:ListEditItem Text="ذكر" Value="1" />
                                    <dx:ListEditItem Text="انثى" Value="2" />
                                </Items>
                                <ValidationSettings SetFocusOnError="True">
                                </ValidationSettings>
                            </dx:ASPxComboBox>
                        </div>
                        <div style="flex:1;">
                            <label>نظام الجهاز</label>
                            <dx:ASPxComboBox runat="server" ID="systemKind" Width="100%" Height="45px">
                                <Items>
                                    <dx:ListEditItem Text="IOS" Value="IOS" />
                                    <dx:ListEditItem Text="Android" Value="ANDROID" />
                                </Items>
                                <ValidationSettings SetFocusOnError="True">
                                </ValidationSettings>
                            </dx:ASPxComboBox>
                        </div>
                    </div>
                    
                    <div style="margin-bottom: 30px; padding-top: 10px;">

                        <!-- الهيدر مع البوردر -->
                        <div style="
                            border-top: 3px solid red;
                            padding-top: 10px;
                            margin-bottom: 15px;
                        ">
                            <h3 style="margin: 0; font-size: 20px; font-weight: bold;">
                                جهة اتصال الطوارئ
                            </h3>
                        </div>

                        <!-- الوصف -->
                        <p style="margin: 0 0 20px 0; color: #555; font-size: 14px;">
                            يرجى تقديم معلومات جهة الاتصال للطوارئ
                        </p>

                        <!-- اسم القريب -->
                        <div style="margin-bottom: 20px;">
                            <label>اسم أحد الأقارب</label>
                            <dx:ASPxTextBox ID="nerbyname" runat="server" Width="100%" Height="45px">
                                <ValidationSettings RequiredField-IsRequired="true" Display="Dynamic" SetFocusOnError="True" >
<RequiredField IsRequired="True"></RequiredField>
                                </ValidationSettings>
                            </dx:ASPxTextBox>
                        </div>

                        <div style="margin-bottom: 20px;">
                            <label>رقم هاتف القريب</label>
                            <dx:ASPxTextBox ID="nerbynumber" runat="server" Width="100%" Height="45px">
                                <ValidationSettings RequiredField-IsRequired="true" Display="Dynamic" SetFocusOnError="True" >
                                    <RegularExpression ValidationExpression="^(?=.{10,})[0-9]*$" ErrorText="الأدخال ارقام فقط"/>
                                    <RequiredField IsRequired="True"></RequiredField>
                                </ValidationSettings>
                                <ClientSideEvents
                                          KeyPress="function(s, e){
                                            // منع كتابة أي شيء غير الأرقام
                                            if(e.htmlEvent.key.length === 1 && !/[0-9]/.test(e.htmlEvent.key)){
                                                e.htmlEvent.preventDefault();
                                            }
                                        }" 
                                    />
                            </dx:ASPxTextBox>
                        </div>

                    </div>
                </fieldset>
                
                <div class="form-navigation" id="nextbutton" runat="server">
                    <button type="button" class="btn-nav btn-next" onclick="nextStep(1)">التالي ←</button>
                </div>
            </div>
            <div class="step-content" data-step="2">
                <fieldset class="step-fieldset">
                    <legend class="step-legend"><i class="fas fa-id-card"></i> وثائق الهوية</legend>

                    <div style="margin-bottom: 20px;">
                        <label>نوع الوثيقة <span style="color:red">*</span></label>
                        <dx:ASPxComboBox runat="server" ID="documentType" ClientInstanceName="documentType" Width="100%" Height="45px">
                            <Items>
                                <dx:ListEditItem Text="هوية أحوال" Value="1" />
                                <dx:ListEditItem Text="جواز سفر" Value="2" />
                                <dx:ListEditItem Text="إقامة" Value="3" />
                            </Items>
                            <ClientSideEvents SelectedIndexChanged="OnDocumentTypeChanged" Init="OnDocumentTypeChanged" />
                        </dx:ASPxComboBox>
                    </div>

                    <div style="margin-bottom: 20px;">
                        <label>رقم الوثيقة <span style="color:red">*</span></label>
    
                        <dx:ASPxTextBox runat="server" ID="documentnumber" ClientInstanceName="documentnumber" Width="100%" Height="45px">
                            <ValidationSettings RequiredField-IsRequired="true" Display="Dynamic" SetFocusOnError="True" ValidationGroup="DocCheckGroup">
                                <RegularExpression ErrorText="الرجاء إدخال أرقام فقط" ValidationExpression="^\d+$" />
                                <RequiredField IsRequired="True" ErrorText="رقم الوثيقة مطلوب" />
                            </ValidationSettings>

                            <ClientSideEvents 
                                KeyPress="function(s, e){
                                    // منع كتابة أي شيء غير الأرقام
                                    if(e.htmlEvent.key.length === 1 && !/[0-9]/.test(e.htmlEvent.key)){
                                        e.htmlEvent.preventDefault();
                                    }
                                }" 
            
                                LostFocus="function(s,e){
                                    // التحقق من صحة الإدخال (القروب) قبل إرسال الطلب للسيرفر
                                    if (ASPxClientEdit.ValidateGroup('DocCheckGroup')) {
                                        var num = s.GetValue();
                                        if(num) docnumnbercallback.PerformCallback(num);
                                    }
                                }" 
                            />
                        </dx:ASPxTextBox>

                        <dx:ASPxLabel ID="ASPxLabel4" ClientInstanceName="abcdefg" runat="server" />

                        <dx:ASPxCallback ID="documentnumbercallback" runat="server" ClientInstanceName="docnumnbercallback" OnCallback="numnbercallback">
                            <ClientSideEvents CallbackComplete="function(s, e) { 
                                if (e.result == 'exists') {
                                    abcdefg.SetText('❌ رقم الوثيقة موجود!');
                                    abcdefg.GetMainElement().style.color = 'red';
                                    // التأكد من وجود الزر قبل تعطيله لتجنب أخطاء جافاسكربت
                                    if (typeof btnSubmit !== 'undefined') btnSubmit.SetEnabled(false);
                                } else {
                                    abcdefg.SetText('✅ رقم الوثيقة متاح');
                                    abcdefg.GetMainElement().style.color = 'green';
                                    if (typeof btnSubmit !== 'undefined') btnSubmit.SetEnabled(true);
                                }
                            }" />
                        </dx:ASPxCallback>
                    </div>


                    <div id="docIdFront" style="display:none; margin-bottom:20px;">
                        <label>صورة الهوية (أمام)</label>
                        <dx:ASPxUploadControl ID="ASPxUploadControl5" runat="server" ClientInstanceName="idFrontPic" Width="100%" UploadMode="Standard" ShowProgressPanel="false" BrowseButton-Text="اختر صورة">
                            <ClientSideEvents TextChanged="function(s,e){ onPreviewImage(s,e,'preview_idFront'); }" />
                            <ValidationSettings AllowedFileExtensions=".jpg, .jpeg, .png, .bmp" GeneralErrorText="حدث خطأ أثناء تحميل الصور ، الرجاء المحاولة لاحقا" MaxFileSize="10000000" MaxFileSizeErrorText="حجم الصورة أكبر من 10 ميجابايت ، الرجاء اختيار صورة بحجم أقل" NotAllowedFileExtensionErrorText="امتداد الصورة غير مسموح به">
                            </ValidationSettings>
                        </dx:ASPxUploadControl>
                        <div id="preview_idFront" class="image-preview-container">
                            <span style="color:#aaa;">ستظهر الصورة هنا</span>
                        </div>
                    </div>
                    <div id="docIdBack" style="display:none; margin-bottom:20px;">
                        <label>صورة الهوية (خلف)</label>
                        <dx:ASPxUploadControl ID="ASPxUploadControl4" runat="server" ClientInstanceName="idBackPic" Width="100%" UploadMode="Standard" ShowProgressPanel="false" BrowseButton-Text="اختر صورة">
                            <ClientSideEvents TextChanged="function(s,e){ onPreviewImage(s,e,'preview_idBack'); }" />
                            <ValidationSettings AllowedFileExtensions=".jpg, .jpeg, .png, .bmp" GeneralErrorText="حدث خطأ أثناء تحميل الصور ، الرجاء المحاولة لاحقا" MaxFileSize="10000000" MaxFileSizeErrorText="حجم الصورة أكبر من 10 ميجابايت ، الرجاء اختيار صورة بحجم أقل" NotAllowedFileExtensionErrorText="امتداد الصورة غير مسموح به">
                            </ValidationSettings>
                        </dx:ASPxUploadControl>
                        <div id="preview_idBack" class="image-preview-container">
                            <span style="color:#aaa;">ستظهر الصورة هنا</span>
                        </div>
                    </div>
                      <div id="passportDiv" style="display:none;margin-bottom: 30px;">
                          <label>صورة جواز السفر *</label>
                          <dx:ASPxUploadControl ID="passport" runat="server" ClientInstanceName="passportPic" Width="100%" UploadMode="Standard" ShowProgressPanel="false" BrowseButton-Text="اختر صورة">
                              <ClientSideEvents TextChanged="function(s,e){ onPreviewImage(s,e,'preview_passport'); }" />
                                <ValidationSettings AllowedFileExtensions=".jpg, .jpeg, .png, .bmp" GeneralErrorText="حدث خطأ أثناء تحميل الصور ، الرجاء المحاولة لاحقا" MaxFileSize="10000000" MaxFileSizeErrorText="حجم الصورة أكبر من 10 ميجابايت ، الرجاء اختيار صورة بحجم أقل" NotAllowedFileExtensionErrorText="امتداد الصورة غير مسموح به">
                               </ValidationSettings>
                          </dx:ASPxUploadControl>
                          <div id="preview_passport" class="image-preview-container">
                            <span style="color:#aaa;">ستظهر الصورة هنا</span>
                          </div>
                      </div>
                      <div id="residenceDiv" style="display:none; margin-bottom:30px;">
                          <label>صورة الإقامة *</label>
                          <dx:ASPxUploadControl ID="resident" runat="server" ClientInstanceName="residencePic" Width="100%" UploadMode="Standard" ShowProgressPanel="false" BrowseButton-Text="اختر صورة">
                              <ClientSideEvents TextChanged="function(s,e){ onPreviewImage(s,e,'preview_residence'); }" />
                               <ValidationSettings AllowedFileExtensions=".jpg, .jpeg, .png, .bmp" GeneralErrorText="حدث خطأ أثناء تحميل الصور ، الرجاء المحاولة لاحقا" MaxFileSize="10000000" MaxFileSizeErrorText="حجم الصورة أكبر من 10 ميجابايت ، الرجاء اختيار صورة بحجم أقل" NotAllowedFileExtensionErrorText="امتداد الصورة غير مسموح به">
                               </ValidationSettings>
                          </dx:ASPxUploadControl>
                           <div id="preview_residence" class="image-preview-container">
                            <span style="color:#aaa;">ستظهر الصورة هنا</span>
                           </div>
                      </div>

                </fieldset>

                <div class="form-navigation" runat="server" id="beforeAndAfter">
                    <button type="button" class="btn-nav btn-prev" onclick="prevStep(2)">→ السابق</button>
                    <button type="button" class="btn-nav btn-next" onclick="nextStep(2)">التالي ←</button>
                </div>
            </div>

            <div class="step-content" data-step="3">
                <fieldset class="step-fieldset">
                    <legend class="step-legend"><i class="fas fa-id-badge"></i> رخصة القيادة</legend>
                    
                    <div class="note-box">
                        <i class="fas fa-exclamation-circle note-icon"></i>
                        <div class="note-text">
                            يرجى التأكد من أن رخصة القيادة صالحة وغير منتهية الصلاحية.
                            <br><span style="font-weight:normal; font-size:12px;">سيتم رفض الطلب في حال كانت الرخصة منتهية.</span>
                        </div>
                    </div>

                    <div style="margin-bottom: 30px;">
                        <label style="font-weight:bold; font-size:16px;">صورة رخصة القيادة <span style="color:red">*</span></label>
                        <dx:ASPxUploadControl ID="ASPxUploadControl3" runat="server" ClientInstanceName="licensePic" Width="100%" UploadMode="Standard" ShowProgressPanel="false" BrowseButton-Text="اختر صورة الرخصة">
                            <ClientSideEvents TextChanged="function(s,e){ onPreviewImage(s,e,'preview_license'); }" />
                            <ValidationSettings AllowedFileExtensions=".jpg, .jpeg, .png, .bmp" GeneralErrorText="حدث خطأ أثناء تحميل الصور ، الرجاء المحاولة لاحقا" MaxFileSize="10000000" MaxFileSizeErrorText="حجم الصورة أكبر من 10 ميجابايت ، الرجاء اختيار صورة بحجم أقل" NotAllowedFileExtensionErrorText="امتداد الصورة غير مسموح به">
                             </ValidationSettings>
                        </dx:ASPxUploadControl>
                        <div id="preview_license" class="image-preview-container">
                            <span style="color:#aaa;">ستظهر الصورة هنا</span>
                        </div>
                    </div>
                </fieldset>

                <div class="form-navigation">
                    <button type="button" class="btn-nav btn-prev" onclick="prevStep(3)">→ السابق</button>
                    <button type="button" class="btn-nav btn-next" onclick="nextStep(3)">التالي ←</button>
                </div>
            </div>

            <div class="step-content" data-step="4">
                <fieldset class="step-fieldset">
                    <legend class="step-legend"><i class="fas fa-car"></i> معلومات المركبة</legend>
                    
                    <div class="note-box">
                        <i class="fas fa-camera note-icon"></i>
                        <div class="note-text">
                            يجب أن تكون صور المركبة واضحة وتظهر اللوحة بشكل كامل.
                            <br><span style="font-weight:normal; font-size:12px;">تجنب الصور المعتمة أو المهتزة لضمان سرعة الموافقة.</span>
                        </div>
                    </div>

                    <div style="margin-bottom: 20px;">
                        <label>صنف المركبة</label>
                        <dx:ASPxComboBox ID="carKind" runat="server" ClientInstanceName="carKind" Width="100%" Height="45px">
                            <Items>
                                <dx:ListEditItem Text="سيارة" Value="سيارة" />
                                <dx:ListEditItem Text="دراجة" Value="دراجة" />
                            </Items>
                             <ValidationSettings RequiredField-IsRequired="true" Display="Dynamic" />
                        </dx:ASPxComboBox>
                    </div>
                    <div style="margin-bottom: 20px;">
                        <label>نوع المركبة</label>
                        <dx:ASPxTextBox ID="carmarka" runat="server" ClientInstanceName="carmarka" Width="100%" Height="45px"></dx:ASPxTextBox>
                    </div>

                    <div style="display:flex; gap:15px; margin-bottom: 20px;">
                    <div style="flex:1;">
                        <label>رقم اللوحة</label>
                        <dx:ASPxTextBox ID="Vehieclenumber" runat="server" ClientInstanceName="Vehieclenumber" Width="100%" Height="45px">
                             <ValidationSettings RequiredField-IsRequired="true" Display="Dynamic" ValidationGroup="VehicleCheckGroup">
                                <RequiredField IsRequired="True" ErrorText="رقم اللوحة مطلوب" />
                             </ValidationSettings>

                             <ClientSideEvents 
                                Init="function(s, e) {
                                    var input = s.GetInputElement();
                                    input.oninput = function() {
                                        var currentValue = s.GetValue();
                                        var country = (typeof coutryid !== 'undefined') ? coutryid.GetValue() : null;
                        
                                        if(typeof formatVehicleNumber === 'function' && country) {
                                            var formatted = formatVehicleNumber(currentValue, country);
                                            if (currentValue !== formatted) { s.SetValue(formatted); }
                                        }
                                    };
                                }"

                                TextChanged="function(s, e) {
                                    if (ASPxClientEdit.ValidateGroup('VehicleCheckGroup')) {
                                        var vno = s.GetValue();
                                        if(vno) {
                                            var cleanValue = vno.toString().replace(/-/g, '');
                                            if (cleanValue.length >= 3) { 
                                                vnoCallback.PerformCallback(cleanValue); 
                                            }
                                        }
                                    }
                                }"
                            />
                        </dx:ASPxTextBox>

                        <dx:ASPxLabel ID="ASPxLabel3" runat="server" ClientInstanceName="ASPxLabel3" />
        
                        <dx:ASPxCallback ID="vnoCallback" runat="server" ClientInstanceName="vnoCallback" OnCallback="vnoCallback_Callback">
                            <ClientSideEvents CallbackComplete="function(s, e) {              
                                if (e.result == 'exists') {
                                    ASPxLabel3.SetText('❌ رقم المركبة مسجل مسبقاً!');
                                    ASPxLabel3.GetMainElement().style.color = 'red';
                                    if (typeof btnSubmit !== 'undefined') btnSubmit.SetEnabled(false);
                                } else if (e.result == 'available') {
                                    ASPxLabel3.SetText('✅ رقم المركبة متاح');
                                    ASPxLabel3.GetMainElement().style.color = 'green';
                                    if (typeof btnSubmit !== 'undefined') btnSubmit.SetEnabled(true);
                                }
                            }" />
                        </dx:ASPxCallback>
                    </div>

                    <div style="flex:1;">
                        <label>رقم الشصي</label>
                        <dx:ASPxTextBox ID="vehieclevinn" runat="server" Width="100%" Height="45px">
                             <ValidationSettings RequiredField-IsRequired="true" Display="Dynamic">
                                <RegularExpression ValidationExpression="^[A-Za-z0-9]{1,17}$" ErrorText="يجب إدخال 17 حرف أو رقم" />
                             </ValidationSettings>
                        </dx:ASPxTextBox>
                    </div>
                </div>

                    <div style="margin-bottom: 20px;">
                        <label>صورة رخصة المركبة (الاقتناء)</label>
                        <dx:ASPxUploadControl ID="ASPxUploadControl2" runat="server" ClientInstanceName="carLicensePic" Width="100%" UploadMode="Standard" ShowProgressPanel="false" BrowseButton-Text="اختر صورة">
                            <ClientSideEvents TextChanged="function(s,e){ onPreviewImage(s,e,'preview_carLicense'); }" />
                            <ValidationSettings AllowedFileExtensions=".jpg, .jpeg, .png, .bmp" GeneralErrorText="حدث خطأ أثناء تحميل الصور ، الرجاء المحاولة لاحقا" MaxFileSize="10000000" MaxFileSizeErrorText="حجم الصورة أكبر من 10 ميجابايت ، الرجاء اختيار صورة بحجم أقل" NotAllowedFileExtensionErrorText="امتداد الصورة غير مسموح به">
                            </ValidationSettings>
                        </dx:ASPxUploadControl>
                        <div id="preview_carLicense" class="image-preview-container">
                            <span style="color:#aaa;">ستظهر الصورة هنا</span>
                        </div>
                    </div>

                    <div style="margin-bottom: 20px;">
                        <label>صورة المركبة من الأمام</label>
                        <dx:ASPxUploadControl ID="ASPxUploadControl1" runat="server" ClientInstanceName="carPic" Width="100%" UploadMode="Standard" ShowProgressPanel="false" BrowseButton-Text="اختر صورة">
                            <ClientSideEvents TextChanged="function(s,e){ onPreviewImage(s,e,'preview_car'); }" />
                            <ValidationSettings AllowedFileExtensions=".jpg, .jpeg, .png, .bmp" GeneralErrorText="حدث خطأ أثناء تحميل الصور ، الرجاء المحاولة لاحقا" MaxFileSize="10000000" MaxFileSizeErrorText="حجم الصورة أكبر من 10 ميجابايت ، الرجاء اختيار صورة بحجم أقل" NotAllowedFileExtensionErrorText="امتداد الصورة غير مسموح به">
                            </ValidationSettings>
                        </dx:ASPxUploadControl>
                        <div id="preview_car" class="image-preview-container">
                            <span style="color:#aaa;">ستظهر الصورة هنا</span>
                        </div>
                    </div>
                </fieldset>

                <div class="form-navigation">
                    <button type="button" class="btn-nav btn-prev" onclick="prevStep(4)">→ السابق</button>
                    <button type="button" class="btn-nav btn-next" onclick="nextStep(4)">التالي ←</button>
                </div>
            </div>

            <div class="step-content" data-step="5">
                
                <div style="text-align:center; margin-bottom:20px;">
                    <h3 style="color:#333;">مراجعة البيانات</h3>
                    <p style="color:#777;">يرجى التأكد من صحة البيانات والصور قبل الإرسال النهائي.</p>
                </div>

                <div class="review-section">
                    <div class="review-title">البيانات الشخصية</div>
                    <div class="review-item"><span class="review-label">الاسم الكامل:</span> <span class="review-value" id="rev_name"></span></div>
                    <div class="review-item"><span class="review-label">رقم الهاتف:</span> <span class="review-value" id="rev_phone"></span></div>
                    <div class="review-item"><span class="review-label">البريد الإلكتروني:</span> <span class="review-value" id="rev_email"></span></div>
                    <div class="review-item"><span class="review-label">الدولة:</span> <span class="review-value" id="rev_country"></span></div>
                </div>
                <div class="review-section">
                    <div class="review-title">الوثائق والمركبة</div>
                    <div class="review-item"><span class="review-label">نوع الوثيقة:</span> <span class="review-value" id="rev_docType"></span></div>
                    <div class="review-item"><span class="review-label">رقم الوثيقة:</span> <span class="review-value" id="rev_docNum"></span></div>
                    <div class="review-item"><span class="review-label">المركبة:</span> <span class="review-value" id="rev_carType"></span></div>
                    <div class="review-item"><span class="review-label">موديل السيارة:</span> <span class="review-value" id="rev_carModel"></span></div>
                    <div class="review-item"><span class="review-label">رقم اللوحة:</span> <span class="review-value" id="rev_plate"></span></div>
                </div>

                <div class="review-section">
                    <div class="review-title">الصور المرفقة (اضغط للتكبير)</div>
                    <div class="review-images-grid">
                        
                        <div class="review-img-card">
                            <span>الصورة الشخصية</span>
                            <img id="rev_img_user" onclick="openLightbox(this)" alt="صورة شخصية" />
                        </div>

                        <div class="review-img-card">
                            <span>الهوية (أمام)</span>
                            <img id="rev_img_idFront" onclick="openLightbox(this)" alt="هوية أمام" />
                        </div>

                        <div class="review-img-card">
                            <span>الهوية (خلف)</span>
                            <img id="rev_img_idBack" onclick="openLightbox(this)" alt="هوية خلف" />
                        </div>

                        <div class="review-img-card">
                            <span>جواز السفر</span>
                            <img id="rev_img_passport" onclick="openLightbox(this)" alt="جواز سفر" />
                        </div>

                        <div class="review-img-card">
                            <span>الإقامة</span>
                            <img id="rev_img_residence" onclick="openLightbox(this)" alt="إقامة" />
                        </div>

                        <div class="review-img-card">
                            <span>رخصة القيادة</span>
                            <img id="rev_img_license" onclick="openLightbox(this)" alt="رخصة قيادة" />
                        </div>

                        <div class="review-img-card">
                            <span>رخصة المركبة</span>
                            <img id="rev_img_carLicense" onclick="openLightbox(this)" alt="رخصة مركبة" />
                        </div>

                        <div class="review-img-card">
                            <span>المركبة</span>
                            <img id="rev_img_car" onclick="openLightbox(this)" alt="صورة مركبة" />
                        </div>

                    </div>
                </div>
                <div class="form-navigation">
                    <button type="button" class="btn-nav btn-prev" onclick="prevStep(5)">→ مراجعة وتعديل</button>
                <dx:ASPxButton ID="btnSubmit" runat="server" ClientInstanceName="btnSubmit" 
                    Text="إرسال الطلب الآن" Width="60%" Height="55px" 
                    AutoPostBack="false" CausesValidation="False">
    
                    <ClientSideEvents Click="function(s,e){ 
                        finalpopup.Show(); 
                    }" />
                </dx:ASPxButton>
                </div>
            </div> 

                <div class="form-navigation edit-mode-nav" style="display: none;">
                    <dx:ASPxButton ID="btnUpdate" runat="server" ClientInstanceName="btnUpdate" 
                        Text="💾 حفظ كافة التغييرات" 
                        Width="300px" Height="50px" OnClick="btnSubmit_Update" CausesValidation="False">
                    </dx:ASPxButton>
                </div>

        </div>
        <dx:ASPxPopupControl ID="popupSuccess" runat="server" ClientInstanceName="popupSuccess"
            HeaderText="نجاح العملية" ShowOnPageLoad="false" CloseAction="CloseButton" ShowCloseButton="true"
            Width="350px" Height="180px" Modal="true" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter">
            <ClientSideEvents Shown="function(s, e) { setTimeout(function() { window.location.href = 'lMain_page.aspx'; }, 2000); }" />
            <ContentCollection>
                <dx:PopupControlContentControl>
                    <div style="text-align:center; padding:20px; font-size:22px; font-weight:bold;">
                        <asp:Label ID="lblPopupMessage" runat="server" Text=""></asp:Label>
                    </div>
                    <div style="text-align:center; margin-top:20px;">
                        <dx:ASPxButton ID="btnClose" runat="server" AutoPostBack="false" Text="إغلاق">
                            <ClientSideEvents Click="function(s, e) { popupSuccess.Hide(); }" />
                        </dx:ASPxButton>
                    </div>
                </dx:PopupControlContentControl>
            </ContentCollection>
        </dx:ASPxPopupControl>
             <dx:ASPxPopupControl ID="ValidationPopup" runat="server" ClientInstanceName="ValidationPopup"
                    HeaderText="تنبيه: نقص في البيانات" ShowOnPageLoad="false" CloseAction="CloseButton" ShowCloseButton="true"
                    Width="400px" Modal="true" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter">
                    <HeaderStyle BackColor="#ea1f29" ForeColor="White" Font-Bold="true" />
                    <ContentCollection>
                        <dx:PopupControlContentControl>
                            <div style="text-align:center; padding:15px;">
                                <i class="fas fa-exclamation-triangle" style="font-size: 40px; color: #ea1f29; margin-bottom: 15px;"></i>
                
                                <div id="lblValidationError" style="font-size: 16px; font-weight: bold; color: #333; margin-bottom: 20px;">
                                    </div>

                                <dx:ASPxButton ID="btnErrorClose" runat="server" AutoPostBack="false" Text="حسناً"
                                    RenderMode="Button" Width="150px" BackColor="#ea1f29" ForeColor="White">
                                    <ClientSideEvents Click="function(s, e) { ValidationPopup.Hide(); }" />
                                    <HoverStyle BackColor="#c91b24"></HoverStyle>
                                </dx:ASPxButton>
                            </div>
                        </dx:PopupControlContentControl>
                    </ContentCollection>
                </dx:ASPxPopupControl>
                <dx:ASPxPopupControl ID="ASPxPopupControl1" runat="server" ClientInstanceName="finalpopup"
                    HeaderText="هل انت متأكد من بياناتك قبل الأرسال؟" ShowOnPageLoad="false" CloseAction="CloseButton" ShowCloseButton="true"
                    Width="400px" Modal="true" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter">
                    <HeaderStyle BackColor="#ea1f29" ForeColor="White" Font-Bold="true" />
                    <ContentCollection>
                        <dx:PopupControlContentControl>
                            <div style="text-align:center; padding:15px;">
                                <i class="fas fa-exclamation-triangle" style="font-size: 40px; color: #ea1f29; margin-bottom: 15px;"></i>
                                <div style="margin-bottom: 20px; font-size: 23px;color:black; font-weight: bold;line-height:27px">
                                    هل أنت متأكد من صحة البيانات 
                                    <br />
                                    وتريد إرسال الطلب؟
                                </div>
                                <dx:ASPxButton ID="ASPxButton1" runat="server" 
                                    AutoPostBack="true" 
                                    Text="حسناً"
                                    OnClick="btnSubmit_Click"
                                    RenderMode="Button" Width="150px"
                                    BackColor="#ea1f29" ForeColor="black">
                                    <ClientSideEvents Click="function(s,e){
                                            finalpopup.Hide();
                                        }" />
                                </dx:ASPxButton>
                            </div>
                        </dx:PopupControlContentControl>
                    </ContentCollection>
                </dx:ASPxPopupControl>
    </main>
</asp:Content>