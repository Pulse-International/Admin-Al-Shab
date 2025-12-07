<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/lSite.Master" CodeBehind="LMain_page.aspx.cs" Inherits="ShabAdmin.LMain_page" %>

<%@ Register Assembly="DevExpress.Web.v24.1, Version=24.1.6.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <style>
        /* Reset for this page */
        .main-content {
            padding: 0 !important;
            margin: 0 !important;
        }

        /* ==================== HERO SECTION ==================== */
        .hero-section {
            background: linear-gradient(135deg, #dc3545 0%, #c82333 100%);
            position: relative;
            overflow: hidden;
            padding: 100px 0 120px;
            min-height: 600px;
        }

            /* Background pattern similar to logo */
            .hero-section::before {
                content: '';
                position: absolute;
                top: -50%;
                right: -10%;
                width: 800px;
                height: 800px;
                background: radial-gradient(circle, rgba(255, 193, 7, 0.1) 0%, transparent 70%);
                border-radius: 50%;
                animation: float 20s infinite ease-in-out;
            }

            .hero-section::after {
                content: '';
                position: absolute;
                bottom: -30%;
                left: -5%;
                width: 600px;
                height: 600px;
                background: radial-gradient(circle, rgba(255, 193, 7, 0.08) 0%, transparent 70%);
                border-radius: 50%;
                animation: float 15s infinite ease-in-out reverse;
            }

        @keyframes float {
            0%, 100% {
                transform: translateY(0) scale(1);
            }

            50% {
                transform: translateY(-30px) scale(1.05);
            }
        }

        .hero-container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 0 30px;
            position: relative;
            z-index: 2;
        }

        .hero-content {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 60px;
            align-items: center;
        }

        /* Hero Text Content */
        .hero-text {
            color: white;
        }

        @keyframes pulse-border {
            0%, 100% {
                box-shadow: 0 0 0 0 rgba(255, 193, 7, 0.4);
            }

            50% {
                box-shadow: 0 0 0 10px rgba(255, 193, 7, 0);
            }
        }

        .hero-title {
            font-size: 52px;
            font-weight: 900;
            line-height: 1.2;
            margin-bottom: 20px;
            text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.2);
        }

            .hero-title .highlight {
                color: #ffc107;
                position: relative;
                display: inline-block;
            }

        .hero-description {
            font-size: 18px;
            line-height: 1.8;
            margin-bottom: 35px;
            color: rgba(255, 255, 255, 0.95);
            font-weight: 500;
        }

        /* Hero Buttons */
        .hero-buttons {
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
        }

        .hero-btn {
            padding: 16px 35px;
            border-radius: 25px;
            font-weight: 700;
            font-size: 17px;
            text-decoration: none;
            transition: all 0.3s ease;
            border: 2px solid transparent;
            display: inline-flex;
            align-items: center;
            gap: 10px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
            cursor: pointer;
        }

            .hero-btn.btn-merchant {
                background: linear-gradient(135deg, #ffc107 0%, #ffdb4d 100%);
                color: #dc3545;
                border-color: #ffc107;
            }

                .hero-btn.btn-merchant:hover {
                    background: white;
                    color: #dc3545;
                    transform: translateY(-3px);
                    box-shadow: 0 8px 25px rgba(255, 255, 255, 0.3);
                }

            .hero-btn.btn-driver {
                background: white;
                color: #dc3545;
                border: 2px solid #ffc107;
            }

                .hero-btn.btn-driver:hover {
                    background: linear-gradient(135deg, #ffc107 0%, #ffdb4d 100%);
                    color: #dc3545;
                    transform: translateY(-3px);
                    box-shadow: 0 8px 25px rgba(255, 193, 7, 0.4);
                }

        /* Hero Image */
        .hero-image {
            position: relative;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .hero-image-wrapper {
            position: relative;
            width: 100%;
            max-width: 500px;
            animation: float-image 6s infinite ease-in-out;
        }

        @keyframes float-image {
            0%, 100% {
                transform: translateY(0);
            }

            50% {
                transform: translateY(-20px);
            }
        }

        .hero-image-wrapper img {
            height: auto;
            filter: drop-shadow(0 20px 40px rgba(0, 0, 0, 0.3));
            border-radius: 20px;
            padding-right: 15px;
        }

        /* Decorative circles */
        .hero-circle {
            position: absolute;
            border-radius: 50%;
            border: 3px solid rgba(255, 193, 7, 0.3);
        }

        .hero-circle-1 {
            width: 400px;
            height: 400px;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            animation: rotate-circle 20s linear infinite;
        }

        .hero-circle-2 {
            width: 500px;
            height: 500px;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            animation: rotate-circle 25s linear infinite reverse;
        }

        @keyframes rotate-circle {
            from {
                transform: translate(-50%, -50%) rotate(0deg);
            }

            to {
                transform: translate(-50%, -50%) rotate(360deg);
            }
        }

        /* ==================== ABOUT SECTION ==================== */
        .about-section {
            padding: 100px 0;
            background: #f8f9fa;
            position: relative;
        }

        .section-container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 0 30px;
        }

        .section-header {
            text-align: center;
            margin-bottom: 60px;
        }

        .section-badge {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: linear-gradient(135deg, #dc3545 0%, #c82333 100%);
            color: white;
            padding: 8px 20px;
            border-radius: 50px;
            font-size: 14px;
            font-weight: 700;
            margin-bottom: 15px;
        }

        .section-title {
            font-size: 42px;
            font-weight: 900;
            color: #1a252f;
            margin-bottom: 15px;
        }

            .section-title .highlight {
                color: #dc3545;
            }

        .section-description {
            font-size: 18px;
            color: #6c757d;
            margin: 0 auto;
            line-height: 1.8;
        }

        /* About Content */
        .about-content {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 30px;
            margin-top: 50px;
        }

        .about-card {
            background: white;
            padding: 35px;
            border-radius: 20px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.08);
            transition: all 0.3s ease;
            border: 2px solid transparent;
            text-align: center;
        }

            .about-card:hover {
                transform: translateY(-10px);
                box-shadow: 0 15px 40px rgba(220, 53, 69, 0.15);
                border-color: #ffc107;
            }

        .about-card-icon {
            width: 80px;
            height: 80px;
            background: linear-gradient(135deg, #dc3545 0%, #c82333 100%);
            border-radius: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 35px;
            color: #ffc107;
            margin: 0 auto 20px;
            box-shadow: 0 5px 15px rgba(220, 53, 69, 0.3);
        }

        .about-card-title {
            font-size: 22px;
            font-weight: 800;
            color: #1a252f;
            margin-bottom: 12px;
        }

        .about-card-description {
            font-size: 15px;
            color: #6c757d;
            line-height: 1.7;
        }

        /* ==================== APP FEATURES SECTION ==================== */
        .features-section {
            padding: 100px 0;
        }

        .features-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 25px;
            margin-top: 50px;
        }

        .feature-card {
            background: linear-gradient(135deg, #fff 0%, #f8f9fa 100%);
            padding: 30px;
            border-radius: 15px;
            border: 2px solid #f0f0f0;
            transition: all 0.3s ease;
            text-align: center;
        }

            .feature-card:hover {
                border-color: #ffc107;
                transform: translateY(-5px);
                box-shadow: 0 10px 30px rgba(220, 53, 69, 0.1);
            }

        .feature-icon {
            width: 70px;
            height: 70px;
            background: linear-gradient(135deg, #dc3545 0%, #c82333 100%);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 30px;
            color: #ffc107;
            margin: 0 auto 20px;
            border: 3px solid #ffc107;
        }

        .feature-title {
            font-size: 18px;
            font-weight: 700;
            color: #1a252f;
            margin-bottom: 10px;
        }

        .feature-description {
            font-size: 14px;
            color: #6c757d;
            line-height: 1.6;
        }

        /* ==================== JOIN TABS SECTION ==================== */
        .join-section {
            padding: 100px 0;
            position: relative;
            overflow: hidden;
        }

            .join-section::before {
                content: '';
                position: absolute;
                top: -100px;
                right: -100px;
                width: 400px;
                height: 400px;
                background: radial-gradient(circle, rgba(220, 53, 69, 0.05) 0%, transparent 70%);
                border-radius: 50%;
            }

        .tabs-wrapper {
            max-width: 1000px;
            margin: 0 auto;
            background: white;
            border-radius: 25px;
            box-shadow: 0 10px 50px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            position: relative;
            z-index: 2;
        }

        .tabs-header {
            display: flex;
            border-bottom: 3px solid #f0f0f0;
            background: #f8f9fa;
        }

        .tab-button {
            flex: 1;
            padding: 25px 30px;
            background: transparent;
            border: none;
            font-size: 20px;
            font-weight: 700;
            color: #6c757d;
            cursor: pointer;
            transition: all 0.3s ease;
            position: relative;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }

            .tab-button:hover {
                background: rgba(220, 53, 69, 0.05);
                color: #dc3545;
            }

            .tab-button.active {
                color: #dc3545;
                background: white;
            }

                .tab-button.active::after {
                    content: '';
                    position: absolute;
                    bottom: -3px;
                    left: 0;
                    right: 0;
                    height: 3px;
                    background: linear-gradient(90deg, #dc3545 0%, #ffc107 100%);
                }

        .tabs-content {
            padding: 50px;
        }

        .tab-panel {
            display: none;
            animation: fadeIn 0.5s ease;
        }

            .tab-panel.active {
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

        /* Tab Content Layout */
        .tab-content-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 40px;
            align-items: center;
        }

        .tab-info h3 {
            font-size: 32px;
            font-weight: 900;
            color: #1a252f;
            margin-bottom: 20px;
        }

        .tab-info p {
            font-size: 16px;
            color: #6c757d;
            line-height: 1.8;
            margin-bottom: 25px;
        }

        .benefits-list {
            list-style: none;
            padding: 0;
            margin: 30px 0;
        }

            .benefits-list li {
                padding: 12px 0;
                font-size: 16px;
                color: #495057;
                display: flex;
                align-items: center;
                gap: 12px;
            }

                .benefits-list li i {
                    color: #dc3545;
                    font-size: 20px;
                    background: rgba(220, 53, 69, 0.1);
                    width: 35px;
                    height: 35px;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    border-radius: 50%;
                }

        .tab-cta-button {
            display: inline-flex;
            align-items: center;
            gap: 10px;
            padding: 18px 40px;
            background: linear-gradient(135deg, #dc3545 0%, #c82333 100%);
            color: white;
            border: none;
            border-radius: 25px;
            font-size: 18px;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 5px 20px rgba(220, 53, 69, 0.3);
            text-decoration: none;
        }

            .tab-cta-button:hover {
                transform: translateY(-3px);
                box-shadow: 0 8px 30px rgba(220, 53, 69, 0.4);
                background: linear-gradient(135deg, #c82333 0%, #dc3545 100%);
            }

        .tab-image img {
            width: 100%;
            height: auto;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.15);
        }

        /* ==================== STATISTICS SECTION ==================== */
        .stats-section {
            background: linear-gradient(135deg, #dc3545 0%, #c82333 100%);
            padding: 80px 0;
            margin-top: 0;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 40px;
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 30px;
        }

        .stat-card {
            text-align: center;
            color: white;
        }

        .stat-number {
            font-size: 48px;
            font-weight: 900;
            color: #ffc107;
            margin-bottom: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 5px;
        }

        .stat-label {
            font-size: 16px;
            font-weight: 600;
            color: rgba(255, 255, 255, 0.9);
        }

        /* ==================== RESPONSIVE ==================== */
        @media (max-width: 1200px) {
            .features-grid {
                grid-template-columns: repeat(2, 1fr);
            }
        }
        /* Hover Effects */
        .join-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 15px 40px rgba(0,0,0,0.12);
        }

        @media (max-width: 992px) {
            .hero-content {
                grid-template-columns: 1fr;
                text-align: center;
            }

            .hero-buttons {
                justify-content: center;
            }

            .hero-image {
                order: -1;
            }

            .about-content {
                grid-template-columns: 1fr;
            }

            .tab-content-grid {
                grid-template-columns: 1fr;
            }

            .stats-grid {
                grid-template-columns: repeat(2, 1fr);
            }
        }

        @media (max-width: 768px) {
            .hero-title {
                font-size: 36px;
            }

            .section-title {
                font-size: 32px;
            }

            .features-grid {
                grid-template-columns: 1fr;
            }

            .tabs-header {
                flex-direction: column;
            }

            .stats-grid {
                grid-template-columns: 1fr;
                gap: 30px;
            }

            .tabs-content {
                padding: 30px 20px;
            }
        }

        .cards-wrapper {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
            gap: 25px;
            margin-top: 40px;
        }


        .join-card {
            background: #fff;
            border-radius: 18px;
            padding: 30px;
            text-align: center;
            box-shadow: 0 4px 18px rgba(0,0,0,0.08);
            transition: 0.3s;
        }
        /* Responsive Adjustments */
        @media (max-width: 768px) {
            .join-section {
                padding: 60px 0;
            }

            .cards-wrapper {
                grid-template-columns: 1fr;
                gap: 25px;
            }

            .join-card {
                padding: 30px 20px;
            }
        }

        .card-icon {
            font-size: 3rem;
            color: #dc3545;
            margin-bottom: 15px;
        }


        .card-title {
            font-size: 1.6rem;
            margin-bottom: 15px;
            color: #333;
            font-weight: bold;
        }


        .card-text {
            color: #666;
            margin-bottom: 20px;
        }


        .benefits-list {
            text-align: right;
            list-style: none;
            padding: 0;
            margin-bottom: 25px;
        }


            .benefits-list li {
                margin: 8px 0;
                font-size: 0.95rem;
                color: #444;
            }


            .benefits-list i {
                color: #28a745;
                margin-left: 8px;
            }


        .card-button {
            display: inline-block;
            padding: 12px 20px;
            background: #dc3545;
            color: #fff;
            border-radius: 10px;
            text-decoration: none;
            font-weight: bold;
            transition: 0.3s;
        }


            .card-button:hover {
                background: #b71d30;
            }
            .merchant:hover{
                background-color:black;
            }
            .merchant1:hover{
                background-color:aliceblue;
            }
    </style>

    <main>
        <!-- Hero Section -->
        <section class="hero-section">
            <div class="hero-container">
                <div class="hero-content">
                    <!-- Hero Text -->
                    <div class="hero-text">
                        <h1 class="hero-title"><span class="highlight">انضم</span><br />
                              إلى عائلة الشعب.. حيث يبدأ النجاح
                        </h1>
                        <p class="hero-description">
في عائلة الشعب، نؤمن بأن نجاحك هو نجاحنا. لذلك نمنحك كل ما تحتاجه لتبدأ رحلتك بثقة: شبكة عملاء واسعة، نظام دفع شفاف، دعم فني على مدار الساعة، واسم تجاري موثوق. انضم إلى عائلة دعمت على مدى 24 عاماً، وكن التالي في قصة نجاحنا.                        </p>
                        <div class="hero-buttons">
                            <a href="#join" class="hero-btn btn-merchant">
                                <i class="fas fa-store"></i>
                                سجل كتاجر
                            </a>
                            <a href="#join" class="hero-btn btn-driver">
                                <i class="fas fa-steering-wheel"></i>
                                سجل كسائق
                            </a>
                        </div>
                    </div>

                    <!-- Hero Image -->
                    <div class="hero-image">
                        <div class="hero-circle hero-circle-1"></div>
                        <div class="hero-circle hero-circle-2"></div>
                        <div class="hero-image-wrapper">
                            <img src="assets/img/header.png" />
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- About Section -->
        <section class="about-section">
            <div class="section-container">
                <div class="section-header">
                    <span class="section-badge">
                        <i class="fas fa-info-circle"></i>
                        من نحن
                    </span>
                    <h2 class="section-title">لماذا <span class="highlight">الشعب</span>؟
                    </h2>
                    <p class="section-description">
                        خبرة تمتد لأكثر من 24 عامًا، نصنع بها نكهات تُحكى.
تأسست محامص الشعب عام 2001، لتصبح خلال سنوات قليلة واحدة من أبرز العلامات التجارية في عالم المكسرات والقهوة والبهارات في المنطقة.
بدأت رحلتنا من الأردن، وانطلقت رؤيتنا لتصل اليوم إلى أكثر من 61 فرعًا في الأردن، الإمارات، قطر، البحرين، وتركيا — جميعها تحمل نفس الشغف بالجودة والنكهة الأصيلة.

منذ اليوم الأول، التزمنا بتقديم منتجات تجمع بين الطزاجة، التوازن، والأصالة، عبر تشكيلة واسعة تشمل:
المكسرات المحمصة والمملحة، القهوة العربية والتركية، التمور الفاخرة، البهارات والأعشاب الطبيعية، إضافةً إلى منتجات خاصة بالمناسبات والهدايا.
                    </p>
                </div>

                <div class="about-content">
                    <div class="about-card">
                        <div class="about-card-icon">
                            <i class="fas fa-bolt"></i>
                        </div>
                        <h3 class="about-card-title">سرعة فائقة</h3>
                        <p class="about-card-description">
                            نضمن لك وصول طلباتك في أسرع وقت ممكن مع متابعة دقيقة لكل مرحلة من مراحل التوصيل
                        </p>
                    </div>

                    <div class="about-card">
                        <div class="about-card-icon">
                            <i class="fas fa-shield-alt"></i>
                        </div>
                        <h3 class="about-card-title">أمان وثقة</h3>
                        <p class="about-card-description">
                            جميع سائقينا مدربون ومعتمدون، مع نظام تأمين شامل على كافة الشحنات لراحة بالك
                        </p>
                    </div>

                    <div class="about-card">
                        <div class="about-card-icon">
                            <i class="fas fa-headset"></i>
                        </div>
                        <h3 class="about-card-title">دعم 24/7</h3>
                        <p class="about-card-description">
                            فريق الدعم الفني متاح على مدار الساعة للإجابة على استفساراتك وحل أي مشكلة فوراً
                        </p>
                    </div>
                </div>
            </div>
        </section>
        <!-- Join Cards Section - Enhanced Design -->
        <section class="join-section" style="padding: 80px 0; background: linear-gradient(135deg, #f8f9fa 0%, #ffffff 100%); font-family: 'Cairo', sans-serif; direction: rtl;">
            <div class="container" style="max-width: 1200px; margin: auto; text-align: center;">

                <!-- Header -->
                <div class="section-header" id="join" style="margin-bottom: 60px;">
                    <span style="background: linear-gradient(135deg, #dc3545 0%, #c82333 100%); color: #fff; padding: 10px 25px; border-radius: 50px; font-size: 16px; font-weight: 700; display: inline-flex; align-items: center; gap: 8px; box-shadow: 0 4px 12px rgba(220, 53, 69, 0.3);">
                        <i class="fas fa-user-plus"></i>انضم إلينا
                    </span>
                    <h2 style="margin-top: 25px; font-size: 38px; font-weight: 800; color: #1a252f;">انضم لعائلة <span style="color: #dc3545; position: relative;">الشعب
                <span style="position: absolute; bottom: -5px; left: 0; width: 100%; height: 3px; background: #ffc107; border-radius: 2px;"></span>
                    </span></h2>
                    <p style="max-width: 650px; margin: 20px auto 0; font-size: 18px; color: #6c757d; line-height: 1.7;">سواء كنت تاجراً أو سائقاً — اختر المسار المناسب وابدأ معنا رحلة نجاحك!</p>
                </div>

                <!-- Cards Wrapper -->
                <div class="cards-wrapper" style="display: grid; grid-template-columns: repeat(auto-fit, minmax(350px, 1fr)); gap: 30px; position: relative; z-index: 2;">

                    <!-- Merchant Card -->
                    <div class="join-card" style="background: #fff; border-radius: 20px; padding: 40px 30px; text-align: center; box-shadow: 0 10px 30px rgba(0,0,0,0.08); transition: all 0.4s ease; position: relative; overflow: hidden; border: 1px solid rgba(220, 53, 69, 0.1);">
                        <div style="position: absolute; top: 0; right: 0; width: 100%; height: 5px; background: linear-gradient(90deg, #dc3545 0%, #ffc107 100%);"></div>
                        <div class="card-icon" style="width: 90px; height: 90px; background: linear-gradient(135deg, #dc3545 0%, #c82333 100%); border-radius: 50%; display: flex; align-items: center; justify-content: center; margin: 0 auto 20px; box-shadow: 0 8px 20px rgba(220, 53, 69, 0.3);">
                            <i class="fas fa-store" style="font-size: 2.5rem; color: #fff;"></i>
                        </div>
                        <h3 style="font-size: 1.8rem; font-weight: 800; color: #1a252f; margin-bottom: 15px;">سجّل كتاجر</h3>
                        <p style="color: #6c757d; margin-bottom: 25px; line-height: 1.7; font-size: 16px;">انضم كتاجر واحصل على شبكة واسعة من السائقين المحترفين لخدمة توصيل فورية وآمنة.</p>
                        <a href="/RegisterMerchant.aspx" class="merchant" style="display: inline-flex; align-items: center; justify-content: center; gap: 10px; padding: 14px 30px; background: linear-gradient(135deg, #dc3545 0%, #c82333 100%); color: #fff; border-radius: 12px; text-decoration: none; font-weight: 700; font-size: 16px; transition: all 0.3s ease; box-shadow: 0 5px 15px rgba(220, 53, 69, 0.3); width: 100%;">ابدأ الآن كتاجر
                    <i class="fas fa-arrow-left" style="font-size: 14px;"></i>
                        </a>
                    </div>
                    <!-- Driver Card -->
                    <div class="join-card" style="background: #fff; border-radius: 20px; padding: 40px 30px; text-align: center; box-shadow: 0 10px 30px rgba(0,0,0,0.08); transition: all 0.4s ease; position: relative; overflow: hidden; border: 1px solid rgba(220, 53, 69, 0.1);">
                        <div style="position: absolute; top: 0; right: 0; width: 100%; height: 5px; background: linear-gradient(90deg, #ffc107 0%, #dc3545 100%);"></div>
                        <div class="card-icon" style="width: 90px; height: 90px; background: linear-gradient(135deg, #ffc107 0%, #ffdb4d 100%); border-radius: 50%; display: flex; align-items: center; justify-content: center; margin: 0 auto 20px; box-shadow: 0 8px 20px rgba(255, 193, 7, 0.3);">
                            <i class="fas fa-car" style="font-size: 2.5rem; color: #dc3545;"></i>
                        </div>
                        <h3 style="font-size: 1.8rem; font-weight: 800; color: #1a252f; margin-bottom: 15px;">سجّل كسائق</h3>
                        <p style="color: #6c757d; margin-bottom: 25px; line-height: 1.7; font-size: 16px;">انضم كسائق واستمتع بمرونة ساعات العمل وزيادة دخلك الشهري بسهولة.</p>
                        <a href="registerDriver.aspx" class="merchant1" style="display: inline-flex; align-items: center; justify-content: center; gap: 10px; padding: 14px 30px; background: linear-gradient(135deg, #ffc107 0%, #ffdb4d 100%); color: #dc3545; border-radius: 12px; text-decoration: none; font-weight: 700; font-size: 16px; transition: all 0.3s ease; box-shadow: 0 5px 15px rgba(255, 193, 7, 0.3); width: 100%; margin-top: 29px">ابدأ الآن كسائق
                    <i class="fas fa-arrow-left" style="font-size: 14px;"></i>
                        </a>
                    </div>
                </div>

            </div>
        </section>
        <!-- App Features Section -->
        <section class="features-section">
            <div class="section-container">
                <div class="section-header">
                    <span class="section-badge">
                        <i class="fas fa-mobile-alt"></i>
                        تطبيق الشعب كليك
                    </span>
                    <h2 class="section-title">مزايا <span class="highlight">التطبيق</span>
                    </h2>
                    <p class="section-description">
                        تطبيق الشعب كليك يوفر لك تجربة سلسة وسهلة لإدارة جميع طلباتك بضغطة زر واحدة. حمّل التطبيق الآن واستمتع بالمزايا التالية
                    </p>
                </div>

                <div class="features-grid">
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="fas fa-map-marked-alt"></i>
                        </div>
                        <h4 class="feature-title">تتبع مباشر</h4>
                        <p class="feature-description">
                            تابع موقع طلبك لحظة بلحظة على الخريطة
                        </p>
                    </div>

                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="fas fa-credit-card"></i>
                        </div>
                        <h4 class="feature-title">دفع آمن</h4>
                        <p class="feature-description">
                            خيارات دفع متعددة وآمنة لراحتك
                        </p>
                    </div>

                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="fas fa-star"></i>
                        </div>
                        <h4 class="feature-title">تقييمات موثوقة</h4>
                        <p class="feature-description">
                            نظام تقييم شفاف للسائقين والخدمة
                        </p>
                    </div>

                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="fas fa-bell"></i>
                        </div>
                        <h4 class="feature-title">إشعارات فورية</h4>
                        <p class="feature-description">
                            تنبيهات فورية لكل تحديث على طلبك
                        </p>
                    </div>

                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="fas fa-history"></i>
                        </div>
                        <h4 class="feature-title">سجل الطلبات</h4>
                        <p class="feature-description">
                            الوصول لجميع طلباتك السابقة بسهولة
                        </p>
                    </div>

                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="fas fa-gift"></i>
                        </div>
                        <h4 class="feature-title">عروض حصرية</h4>
                        <p class="feature-description">
                            استفد من العروض والخصومات المميزة
                        </p>
                    </div>

                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="fas fa-comments"></i>
                        </div>
                        <h4 class="feature-title">دردشة مباشرة</h4>
                        <p class="feature-description">
                            تواصل مع السائق والدعم الفني مباشرة
                        </p>
                    </div>

                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="fas fa-calendar-check"></i>
                        </div>
                        <h4 class="feature-title">جدولة مسبقة</h4>
                        <p class="feature-description">
                            جدول طلباتك المستقبلية بكل سهولة
                        </p>
                    </div>
                </div>
            </div>
        </section>
    </main>

    <script>
        function switchTab(event, tabId) {
            // Remove active class from all buttons and panels
            var tabButtons = document.querySelectorAll('.tab-button');
            var tabPanels = document.querySelectorAll('.tab-panel');

            tabButtons.forEach(function (button) {
                button.classList.remove('active');
            });

            tabPanels.forEach(function (panel) {
                panel.classList.remove('active');
            });

            // Add active class to clicked button and corresponding panel
            event.currentTarget.classList.add('active');
            document.getElementById(tabId).classList.add('active');
        }
    </script>
</asp:Content>
