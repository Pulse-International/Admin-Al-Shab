<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/mSite.Master" AutoEventWireup="true" CodeBehind="mDefault.aspx.cs" Inherits="ShabAdmin.mDefault" %>

<%@ Register Assembly="DevExpress.Web.v24.1, Version=24.1.6.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">


    <main>
        <div class="container-fluid py-4">

            <script>

                function updateCharts(countryId) {
                    fetch(`/GetChartDataHandler.ashx?countryId=${countryId}`)
                        .then(res => res.json())
                        .then(data => {
                            chart.data.datasets[0].data = data.orders;
                            chart.update();
                        });

                    fetch(`/GetLineChartDataHandler.ashx?countryId=${countryId}`)
                        .then(res => res.json())
                        .then(data => {
                            chartLine.data.datasets[0].data = data.amounts;
                            chartLine.update();
                        });
                }
            </script>

            <div class="row">

                <div class="col-lg-3 col-sm-6 mb-lg-0 mb-4">
                    <div class="card">
                        <div class="card-header p-3 pt-2">
                            <div class="icon icon-lg icon-shape bg-gradient-success shadow-success text-center border-radius-xl mt-n4 position-absolute">
                                <i class="material-icons opacity-10">attach_money</i>
                            </div>
                            <div class="text-start pt-1">
                                <p class="text-sm mb-0 text-capitalize">إجمالي المبيعات (اليوم)</p>
                                <h4 class="mb-0"><%= TodaySalesAmount.ToString("N2") %> <%= SelectedCurrencySymbol %> </h4>
                            </div>
                        </div>
                        <hr class="dark horizontal my-0">
                        <div class="card-footer p-3">
                            <p class="mb-0" style="text-align: center;">قيمة المبيعات الكلية لليوم</p>
                        </div>
                    </div>
                </div>


                <div class="col-lg-3 col-sm-6 mb-lg-0 mb-4">
                    <div class="card">
                        <div class="card-header p-3 pt-2">
                            <div class="icon icon-lg icon-shape bg-gradient-info shadow-info text-center border-radius-xl mt-n4 position-absolute">
                                <i class="material-icons opacity-10">shopping_cart</i>
                            </div>
                            <div class="text-start pt-1">
                                <p class="text-sm mb-0 text-capitalize">عدد الطلبات (اليوم)</p>
                                <h4 class="mb-0"><%= TodayOrders %></h4>
                            </div>
                        </div>
                        <hr class="dark horizontal my-0">
                        <div class="card-footer p-3">
                            <p class="mb-0 text-center">إجمالي الطلبات المسجلة اليوم</p>
                        </div>
                    </div>
                </div>


                <div class="col-lg-3 col-sm-6">
                    <div class="card">
                        <div class="card-header p-3 pt-2">
                            <div class="icon icon-lg icon-shape bg-gradient-secondary shadow-secondary text-center border-radius-xl mt-n4 position-absolute">
                                <i class="material-icons opacity-10">person_add</i>
                            </div>

                            <div class="text-start pt-1">
                                <p class="text-sm mb-0 text-capitalize">عدد المسجلين (اليوم)</p>
                                <h4 class="mb-0"><%= TodayRegisteredUsers %></h4>
                            </div>
                        </div>
                        <hr class="dark horizontal my-0">
                        <div class="card-footer p-3">
                            <p class="mb-0" style="text-align: center;">عدد المستخدمين الذين سجّلوا اليوم</p>
                        </div>
                    </div>
                </div>

                <div class="col-lg-3 col-sm-6 mb-lg-0 mb-4">
                    <div class="card">
                        <div class="card-header p-3 pt-2">
                            <div class="icon icon-lg icon-shape bg-gradient-warning shadow-warning text-center border-radius-xl mt-n4 position-absolute">
                                <i class="material-icons opacity-10">local_shipping</i>
                            </div>
                            <div class="text-start pt-1">
                                <p class="text-sm mb-0 text-capitalize">مجموع التوصيل (اليوم)</p>
                                <h4 class="mb-0"><%= TodayDeliveryAmount.ToString("N2") %> <%= SelectedCurrencySymbol %> </h4>
                            </div>
                        </div>
                        <hr class="dark horizontal my-0">
                        <div class="card-footer p-3">
                            <p class="mb-0" style="text-align: center;">إجمالي مبالغ التوصيل لليوم الحالي</p>
                        </div>
                    </div>
                </div>




            </div>
            <div class="row mt-4">
                <div class="col-lg-4 col-md-6 mt-4 mb-4">
                    <div class="card z-index-2 ">
                        <div class="card-header p-0 position-relative mt-n4 mx-3 z-index-2 bg-transparent">
                            <div class="bg-gradient-primary shadow-primary border-radius-lg py-3 pe-1">
                                <div class="chart">
                                    <canvas id="chart-bars" class="chart-canvas" height="170"></canvas>
                                </div>
                            </div>
                        </div>
                        <div class="card-body">
                            <h6 class="mb-0 ">طلبات الأسبوع</h6>
                            <p class="text-sm ">عدد الطلبات في آخر 7 أيام</p>
                            <hr class="dark horizontal">
                            <div class="d-flex ">
                                <i class="material-icons text-sm my-auto ms-1">schedule</i>
                                <p class="mb-0 text-sm">محدث اليوم</p>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-lg-4 col-md-6 mt-4 mb-4">
                    <div class="card z-index-2  ">
                        <div class="card-header p-0 position-relative mt-n4 mx-3 z-index-2 bg-transparent">
                            <div class="bg-gradient-success shadow-success border-radius-lg py-3 pe-1">
                                <div class="chart">
                                    <canvas id="chart-line" class="chart-canvas" height="170"></canvas>
                                </div>
                            </div>
                        </div>
                        <div class="card-body">
                            <h6 class="mb-0 ">المبيعات اليومية </h6>
                            <p class="text-sm ">المبيعات في آخر 7 أيام</p>
                            <hr class="dark horizontal">
                            <div class="d-flex ">
                                <i class="material-icons text-sm my-auto ms-1">schedule</i>
                                <p class="mb-0 text-sm">محدث اليوم</p>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-lg-4 mt-4 mb-3">
                    <div class="card z-index-2 ">
                        <div class="card-header p-0 position-relative mt-n4 mx-3 z-index-2 bg-transparent">
                            <div class="bg-gradient-dark shadow-dark border-radius-lg py-3 pe-1">
                                <div class="chart">
                                    <canvas id="chart-line-tasks" class="chart-canvas" height="170"></canvas>
                                </div>
                            </div>
                        </div>
                        <div class="card-body">
                            <h6 class="mb-0 ">المبيعات الشهرية</h6>
                            <p class="text-sm ">المبيعات آخر 6 اشهر</p>
                            <hr class="dark horizontal">
                            <div class="d-flex ">
                                <i class="material-icons text-sm my-auto me-1">schedule</i>
                                <p class="mb-0 text-sm">محدث اليوم</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="row mt-4">

                <div class="col-lg-6 col-sm-6 mb-lg-0 mb-4">
                    <div class="card">
                        <div class="card-header p-3 pt-2">
                            <div class="icon icon-lg icon-shape bg-gradient-primary shadow-primary text-center border-radius-xl mt-n4 position-absolute">
                                <i class="material-icons opacity-10">groups</i>
                            </div>
                            <div class="d-flex justify-content-center align-items-center gap-3 pt-1">
                                <p class="mb-0 text-capitalize"
                                    style="font-size: 1.4rem; font-weight: 500; font-family: Cairo; color: #444;">
                                    إجمالي عدد المستخدمين في النظام : 
                                </p>
                                <h4 class="mb-0"
                                    style="font-size: 2.5rem; font-weight: 700; font-family: Cairo; color: #111; line-height: 1.2;">
                                    <%= UsersCountByCountry %>
                                </h4>
                            </div>
                        </div>
                        <div class="card-footer p-1">
                        </div>
                    </div>
                </div>

                <div class="col-lg-6 col-sm-6 mb-lg-0 mb-4">
                    <div class="card">
                        <div class="card-header p-3 pt-2">
                            <div class="icon icon-lg icon-shape bg-gradient-success shadow-success text-center border-radius-xl mt-n4 position-absolute">
                                <i class="material-icons opacity-10">business</i>
                            </div>
                            <div class="d-flex justify-content-center align-items-center gap-3 pt-1">
                                <p class="mb-0 text-capitalize"
                                    style="font-size: 1.4rem; font-weight: 500; font-family: Cairo; color: #444;">
                                    إجمالي عدد الشركات في النظام : 
       
                                </p>
                                <h4 class="mb-0"
                                    style="font-size: 2.5rem; font-weight: 700; font-family: Cairo; color: #111; line-height: 1.2;">
                                    <%= CompaniesCount %>
        </h4>
                            </div>
                        </div>

                        <div class="card-footer p-1">
                        </div>
                    </div>
                </div>

            </div>

            <div class="row my-4 mt-5">
                <!-- المبيعات حسب الدولة -->
                <div class="col-lg-8 col-md-6 mb-md-0 mb-4">
                    <div class="card h-100">
                        <div class="card-header pb-0">
                            <div class="row mb-3">
                                <div class="col-6">
                                    <h6 style="font-size: 1.2rem; font-weight: 700;">المبيعات حسب الدولة</h6>
                                    <p class="text-sm" style="font-size: 1rem;">
                                        <i class="fa fa-globe text-info" aria-hidden="true"></i>
                                        <span class="font-weight-bold ms-1"><%= CountrySalesList.Count %> دولة</span> مدعومة
                       
                                    </p>
                                </div>
                            </div>
                        </div>
                        <div class="card-body d-flex flex-column p-0 pb-2">
                            <div class="table-responsive flex-grow-1">
                                <table class="table align-items-center mb-0">
                                    <thead>
                                        <tr>
                                            <th class="text-uppercase text-secondary font-weight-bolder opacity-7" style="font-size: 1rem;">الدولة</th>
                                            <th class="text-center text-uppercase text-secondary font-weight-bolder opacity-7" style="font-size: 1rem;">المبيعات</th>
                                            <th class="text-center text-uppercase text-secondary font-weight-bolder opacity-7" style="font-size: 1rem;">النسبة</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <% foreach (var cs in CountrySalesList)
                                            { %>
                                        <tr>
                                            <td>
                                                <h6 class="mb-0" style="font-size: 1.1rem; font-weight: 600;"><%= cs.CountryName %></h6>
                                            </td>
                                            <td class="align-middle text-center">
                                                <span class="font-weight-bold" style="font-size: 1.1rem;">
                                                    <%= cs.TotalSales.ToString("N2") %> <%= cs.CurrencySymbol %>
                                    </span>
                                            </td>
                                            <td class="align-middle pb-3">
                                                <div class="progress-wrapper w-75 mx-auto">
                                                    <div class="progress-info">
                                                        <div class="progress-percentage text-center">
                                                            <span class="font-weight-bold" style="font-size: 1.1rem;"><%= cs.Percentage %> %</span>
                                                        </div>
                                                    </div>
                                                    <div style="display: flex; justify-content: center;">
                                                        <div class="progress" style="width: 75%;">
                                                            <div class="progress-bar bg-gradient-info"
                                                                role="progressbar"
                                                                style="width: <%= cs.Percentage %>%;"
                                                                aria-valuenow="<%= cs.Percentage %>"
                                                                aria-valuemin="0" aria-valuemax="100">
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </td>
                                        </tr>
                                        <% } %>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- التايملاين: نظرة عامة على الطلبات -->
                <div class="col-lg-4 col-md-6">
                    <div class="card h-100">
                        <div class="card-header pb-0">
                            <h6 style="font-size: 1.2rem; font-weight: 700;">نظرة عامة على الطلبات</h6>
                            <p class="text-sm" style="font-size: 1rem;">
                                <i class="fa fa-arrow-up text-success" aria-hidden="true"></i>
                                <span class="font-weight-bold">24%</span> هذا الشهر
           
                            </p>
                        </div>
                        <div class="card-body p-3 d-flex flex-column">
                            <div class="timeline timeline-one-side flex-grow-1 overflow-auto">
                                <% if (TimelineEvents != null && TimelineEvents.Count > 0)
                                    { %>
                                <% foreach (var ev in TimelineEvents)
                                    { %>
                                <div class="timeline-block mb-3">
                                    <span class="timeline-step">
                                        <i class="material-icons <%= ev.Color %> text-gradient"><%= ev.Icon %></i>
                                    </span>
                                    <div class="timeline-content">
                                        <h6 class="text-dark font-weight-bold mb-0" style="font-size: 1.1rem;">
                                            <%= ev.Title %>
                                </h6>
                                        <p class="text-secondary font-weight-bold mt-1 mb-0" style="font-size: 0.95rem;">
                                            <%= ev.EventDate.ToString("dd MMM yyyy hh:mm tt", new System.Globalization.CultureInfo("ar-JO")) %>
                                        </p>
                                    </div>
                                </div>
                                <% } %>
                                <% }
                                else
                                { %>
                                <div class="text-center text-muted" style="font-size: 1rem; padding: 20px;">
                                    لا يوجد طلبات
                   
                                </div>
                                <% } %>
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
    <script src="/assets/js/plugins/chartjs.min.js"></script>
    <script>
        // ========= 1) الرسم العمودي: عدد الطلبات آخر 7 أيام =========
        var chartLabels = <%= GetLast7DayLabelsArabic() %>;
        var chartData = <%= GetOrdersLast7Json() %>;

        var ctx = document.getElementById("chart-bars").getContext("2d");
        new Chart(ctx, {
            type: "bar",
            data: {
                labels: chartLabels,
                datasets: [{
                    label: "طلبات",
                    tension: 0.4,
                    borderWidth: 0,
                    borderRadius: 4,
                    borderSkipped: false,
                    backgroundColor: "rgba(255, 255, 255, .8)",
                    data: chartData,
                    maxBarThickness: 6
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: { legend: { display: false } },
                interaction: { intersect: false, mode: 'index' },
                scales: {
                    y: {
                        grid: {
                            drawBorder: false,
                            display: true,
                            drawOnChartArea: true,
                            drawTicks: false,
                            borderDash: [5, 5],
                            color: 'rgba(255, 255, 255, .2)'
                        },
                        ticks: {
                            suggestedMin: 0,
                            beginAtZero: true,
                            padding: 10,
                            font: { size: 14, family: "Cairo" },
                            color: "#fff"
                        }
                    },
                    x: {
                        grid: {
                            drawBorder: false,
                            display: true,
                            drawOnChartArea: true,
                            drawTicks: false,
                            borderDash: [5, 5],
                            color: 'rgba(255, 255, 255, .2)'
                        },
                        ticks: {
                            display: true,
                            color: '#f8f9fa',
                            padding: 10,
                            font: { size: 14, family: "Cairo" }
                        }
                    }
                }
            }
        });

        // ========= 2) الرسم الخطي: إجمالي المبالغ اليومية =========
        var chartLineLabels = <%= GetLast7DayLabelsArabic() %>;
        var chartLineData = <%= GetSalesLast7Json() %>;

        var ctx2 = document.getElementById("chart-line").getContext("2d");
        new Chart(ctx2, {
            type: "line",
            data: {
                labels: chartLineLabels,
                datasets: [{
                    label: "إجمالي المبالغ",
                    tension: 0.3,
                    pointRadius: 5,
                    pointBackgroundColor: "rgba(255, 255, 255, .8)",
                    borderColor: "rgba(255, 255, 255, .8)",
                    borderWidth: 3,
                    backgroundColor: "transparent",
                    fill: true,
                    data: chartLineData
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: { legend: { display: false } },
                interaction: { intersect: false, mode: 'index' },
                scales: {
                    y: {
                        beginAtZero: true,
                        grid: { color: 'rgba(255, 255, 255, .2)' },
                        ticks: { color: '#f8f9fa', font: { family: "Cairo", size: 14 } }
                    },
                    x: {
                        grid: { display: false },
                        ticks: { color: '#f8f9fa', font: { family: "Cairo", size: 14 } }
                    }
                }
            }
        });

        // ========= 3) الرسم الخطي: مبيعات آخر 6 أشهر =========
        var monthlyLabels = <%= GetMonthlyLabelsJson() %>;
        var monthlyData = <%= GetMonthlyDataJson() %>;

        var ctx3 = document.getElementById("chart-line-tasks").getContext("2d");
        new Chart(ctx3, {
            type: "line",
            data: {
                labels: monthlyLabels,
                datasets: [{
                    label: "مبيعات (آخر 6 أشهر)",
                    tension: 0.3,
                    borderWidth: 4,
                    pointRadius: 4,
                    pointBackgroundColor: "rgba(255, 255, 255, .8)",
                    pointBorderColor: "transparent",
                    borderColor: "rgba(255, 255, 255, .8)",
                    backgroundColor: "transparent",
                    fill: true,
                    data: monthlyData,
                    maxBarThickness: 6
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: { legend: { display: false } },
                interaction: { intersect: false, mode: 'index' },
                scales: {
                    y: {
                        grid: {
                            drawBorder: false,
                            display: true,
                            drawOnChartArea: true,
                            drawTicks: false,
                            borderDash: [5, 5],
                            color: 'rgba(255,255,255,.2)'
                        },
                        ticks: {
                            display: true,
                            padding: 10,
                            color: '#f8f9fa',
                            font: { size: 14, family: "Cairo" }
                        }
                    },
                    x: {
                        grid: { drawBorder: false, display: false, drawOnChartArea: false, drawTicks: false, borderDash: [5, 5] },
                        ticks: { display: true, color: '#f8f9fa', padding: 10, font: { size: 14, family: "Cairo" } }
                    }
                }
            }
        });
</script>


    <script>
        var win = navigator.platform.indexOf('Win') > -1;
        if (win && document.querySelector('#sidenav-scrollbar')) {
            var options = {
                damping: '0.5'
            }
            Scrollbar.init(document.querySelector('#sidenav-scrollbar'), options);
        }
    </script>
    <!-- Github buttons -->
    <script async defer src="https://buttons.github.io/buttons.js"></script>
    <!-- Control Center for Material Dashboard: parallax effects, scripts for the example pages etc -->




</asp:Content>
