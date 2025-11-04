<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="ShabAdmin.Default" %>

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
                            <div class="icon icon-lg icon-shape bg-gradient-info shadow-info text-center border-radius-xl mt-n4 position-absolute">
                                <i class="material-icons opacity-10">shopping_bag</i>
                            </div>
                            <div class="text-start pt-1">
                                <p class="text-sm mb-0 text-capitalize">المنتجات المباعة (اليوم)</p>
                                <h4 class="mb-0"><%= ProductsSoldToday %></h4>
                            </div>
                        </div>
                        <hr class="dark horizontal my-0">
                        <div class="card-footer p-3">
                            <p class="mb-0" style="text-align: center;">إجمالي المنتجات المباعة اليوم</p>
                        </div>
                    </div>
                </div>



                <div class="col-lg-3 col-sm-6 mb-lg-0 mb-4">
                    <div class="card">
                        <div class="card-header p-3 pt-2">
                            <div class="icon icon-lg icon-shape bg-gradient-warning shadow-warning text-center border-radius-xl mt-n4 position-absolute">
                                <i class="material-icons opacity-10">payments</i>
                            </div>
                            <div class="text-start pt-1">
                                <p class="text-sm mb-0 text-capitalize">قيمة المنتجات المباعة (اليوم)</p>
                                <h4 class="mb-0"><%= SalesFromCartsToday.ToString("N2") %> <%= SelectedCurrencySymbol %></h4>
                            </div>
                        </div>
                        <hr class="dark horizontal my-0">
                        <div class="card-footer p-3">
                            <p class="mb-0 text-center">إجمالي قيمة المبيعات من الـ Carts اليوم</p>
                        </div>
                    </div>
                </div>



                <div class="col-lg-3 col-sm-6">
                    <div class="card">
                        <div class="card-header p-3 pt-2">
                            <div class="icon icon-lg icon-shape bg-gradient-secondary shadow-secondary text-center border-radius-xl mt-n4 position-absolute">
                                <i class="material-icons opacity-10">store</i>
                            </div>

                            <div class="text-start pt-1">
                                <p class="text-sm mb-0 text-capitalize">عدد الفروع</p>
                                <h4 class="mb-0"><%= BranchesCount %></h4>
                            </div>
                        </div>
                        <hr class="dark horizontal my-0">
                        <div class="card-footer p-3">
                            <p class="mb-0 text-center">إجمالي عدد الفروع المسجّلة</p>
                        </div>
                    </div>
                </div>


                <div class="col-lg-3 col-sm-6 mb-lg-0 mb-4">
                    <div class="card">
                        <div class="card-header p-3 pt-2">
                            <div class="icon icon-lg icon-shape bg-gradient-success shadow-success text-center border-radius-xl mt-n4 position-absolute">
                                <i class="material-icons opacity-10">category</i>
                            </div>
                            <div class="text-start pt-1">
                                <p class="text-sm mb-0 text-capitalize">الأصناف المباعة (اليوم)</p>
                                <h4 class="mb-0"><%= CategoriesSoldToday %></h4>
                            </div>
                        </div>
                        <hr class="dark horizontal my-0">
                        <div class="card-footer p-3">
                            <p class="mb-0 text-center">عدد التصنيفات التي تم بيع منتجات منها اليوم</p>
                        </div>
                    </div>
                </div>





            </div>
            <div class="row mt-4">
                <div class="col-lg-4 col-md-6 mt-4 mb-4">
                    <div class="card z-index-2">
                        <div class="card-header p-0 position-relative mt-n4 mx-3 z-index-2 bg-transparent">
                            <div class="bg-gradient-success shadow-success border-radius-lg py-3 pe-1">
                                <div class="chart">
                                    <canvas id="chart-top-products" class="chart-canvas" height="170"></canvas>
                                </div>
                            </div>
                        </div>
                        <div class="card-body">
                            <h6 class="mb-0">أعلى 6 منتجات مبيعًا اليوم</h6>
                            <p class="text-sm">حسب الطلبات المكتملة اليوم</p>
                            <hr class="dark horizontal">
                            <div class="d-flex">
                                <i class="material-icons text-sm my-auto ms-1">shopping_cart</i>
                                <p class="mb-0 text-sm">محدث اليوم</p>
                            </div>
                        </div>
                    </div>
                </div>


                <div class="col-lg-4 col-md-6 mt-4 mb-4">
                    <div class="card z-index-2">
                        <div class="card-header p-0 position-relative mt-n4 mx-3 z-index-2 bg-transparent">
                            <div class="bg-gradient-info shadow-info border-radius-lg py-3 pe-1">
                                <div class="chart">
                                    <canvas id="chart-line" class="chart-canvas" height="170"></canvas>
                                </div>
                            </div>
                        </div>
                        <div class="card-body">
                            <h6 class="mb-0">مبيعات المنتجات اليومية</h6>
                            <p class="text-sm">المبيعات الفعلية من carts في آخر 7 أيام</p>
                            <hr class="dark horizontal">
                            <div class="d-flex">
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

            <div class="row my-4 mt-3">
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
                                            <th class="text-center text-uppercase text-secondary font-weight-bolder opacity-7" style="font-size: 1rem;">عدد المبيعات</th>
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
                                                    <%= cs.SalesAmount.ToString("N2") %> <%= cs.CurrencySymbol %>
    </span>
                                            </td>


                                            <!-- نسبة مساهمة الدولة من إجمالي عدد المبيعات -->
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

                <!-- آخر ٦ منتجات مباعة -->
                <div class="col-lg-4 col-md-6">
                    <div class="card h-100 shadow-sm border-0" style="border-radius: 12px; overflow: hidden;">
                        <div class="card-header pb-0"
                            style="color: #fff; border: none;">
                            <h6 style="font-size: 1.2rem; font-weight: 700; margin: 0; text-align: center">آخر ٦ منتجات مباعة</h6>
                        </div>
                        <div class="card-body p-0">
                            <% if (Last6ProductsSold != null && Last6ProductsSold.Count > 0)
                                { %>
                            <ul class="list-group list-group-flush">
                                <% foreach (var item in Last6ProductsSold)
                                    { %>
                                <li class="list-group-item"
                                    style="padding: 15px 18px; border: none; border-bottom: 1px solid #f0f0f0;">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <div class="d-flex align-items-center">
                                            <i class="fa fa-cube text-primary me-3" style="font-size: 1.3rem;"></i>
                                            <div>
                                                <div style="font-weight: 600; font-size: 1rem; color: #333;">
                                                    <%= item.ProductName %>
                                                </div>
                                                <div style="font-size: 0.85rem; color: #888;">
                                                    <%= item.OrderDate.ToString("dd/MM/yyyy hh:mm tt") %>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </li>
                                <% } %>
                            </ul>
                            <% }
                                else
                                { %>
                            <div class="text-center text-muted" style="font-size: 1rem; padding: 20px;">
                                لا يوجد منتجات مباعة بعد
           
                            </div>
                            <% } %>
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
        var productLabels = <%= GetTopProductsTodayLabelsJson() %>;
        var productData = <%= GetTopProductsTodayDataJson() %>;

        var ctxProducts = document.getElementById("chart-top-products");
        if (ctxProducts) {
            new Chart(ctxProducts.getContext("2d"), {
                type: "bar",
                data: {
                    labels: productLabels,
                    datasets: [{
                        label: "عدد المبيعات",
                        data: productData,
                        backgroundColor: "rgba(255, 255, 255, .8)",
                        borderRadius: 6,
                        borderSkipped: false,
                        maxBarThickness: 25
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: { legend: { display: false } },
                    scales: {
                        y: {
                            beginAtZero: true,
                            ticks: {
                                color: "#fff",
                                font: { size: 14, family: "Cairo" }
                            },
                            grid: {
                                color: "rgba(255,255,255,.2)",
                                borderDash: [5, 5]
                            }
                        },
                        x: {
                            ticks: {
                                color: "#fff",
                                font: { size: 12, family: "Cairo" }
                            },
                            grid: {
                                color: "rgba(255,255,255,.2)",
                                borderDash: [5, 5]
                            }
                        }
                    }
                }
            });
        }


        var productSalesLabels = <%= GetLast7DayLabelsArabic() %>;
        var productSalesData = <%= GetProductSalesLast7Json() %>;

        var ctx2 = document.getElementById("chart-line").getContext("2d");
        new Chart(ctx2, {
            type: "line",
            data: {
                labels: productSalesLabels,
                datasets: [{
                    label: "مبيعات المنتجات",
                    tension: 0.3,
                    pointRadius: 5,
                    pointBackgroundColor: "rgba(255, 255, 255, .8)",
                    borderColor: "rgba(54, 162, 235, 1)",
                    borderWidth: 3,
                    backgroundColor: "transparent",
                    fill: true,
                    data: productSalesData
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


        var monthlyLabels = <%= GetProductSalesLast6MonthsLabelsJson() %>;
        var monthlyData = <%= GetProductSalesLast6MonthsJson() %>;

        var ctxMonthly = document.getElementById("chart-line-tasks");
        if (ctxMonthly) {
            new Chart(ctxMonthly.getContext("2d"), {
                type: "line",
                data: {
                    labels: monthlyLabels,
                    datasets: [{
                        label: "المبيعات",
                        data: monthlyData,
                        borderColor: "#fff",
                        backgroundColor: "rgba(255,255,255,.3)",
                        tension: 0.4,
                        fill: true
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: { legend: { display: false } },
                    scales: {
                        y: {
                            beginAtZero: true,
                            ticks: { color: "#fff", font: { size: 14, family: "Cairo" } },
                            grid: { color: "rgba(255,255,255,.2)", borderDash: [5, 5] }
                        },
                        x: {
                            ticks: { color: "#fff", font: { size: 12, family: "Cairo" } },
                            grid: { color: "rgba(255,255,255,.2)", borderDash: [5, 5] }
                        }
                    }
                }
            });
        }

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
