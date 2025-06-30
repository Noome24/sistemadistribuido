<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <h1 class="h3 text-gray-800 mb-2">Dashboard</h1>
        <p class="text-muted mb-0">Bienvenido al panel de control</p>
    </div>
    <div class="text-muted">
        <i class="fas fa-calendar-alt me-1"></i>
        <span id="currentDate"></span>
    </div>
</div>

<!-- Loading Spinner -->
<div id="loadingSpinner" class="text-center py-5">
    <div class="spinner-border text-primary" role="status">
        <span class="visually-hidden">Cargando...</span>
    </div>
    <p class="mt-2 text-muted">Cargando datos del dashboard...</p>
</div>

<!-- Dashboard Content -->
<div id="dashboardContent" style="display: none;">
    <!-- Cards Row -->
    <div class="row">
        <!-- Clientes Card -->
        <div class="col-xl-3 col-md-6 mb-4">
            <div class="card border-left-primary dashboard-card h-100">
                <div class="card-body">
                    <div class="row no-gutters align-items-center">
                        <div class="col mr-2">
                            <div class="text-xs font-weight-bold text-primary text-uppercase mb-1">
                                Total Clientes</div>
                            <div class="card-value" id="totalClientes">-</div>
                            <div class="text-xs text-success">
                                <i class="fas fa-arrow-up"></i> Activos
                            </div>
                        </div>
                        <div class="col-auto">
                            <i class="fas fa-users card-icon text-primary"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Productos Card -->
        <div class="col-xl-3 col-md-6 mb-4">
            <div class="card border-left-success dashboard-card h-100">
                <div class="card-body">
                    <div class="row no-gutters align-items-center">
                        <div class="col mr-2">
                            <div class="text-xs font-weight-bold text-success text-uppercase mb-1">
                                Productos</div>
                            <div class="card-value" id="totalProductos">-</div>
                            <div class="text-xs text-info">
                                <i class="fas fa-box"></i> En inventario
                            </div>
                        </div>
                        <div class="col-auto">
                            <i class="fas fa-box card-icon text-success"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Pedidos Card -->
        <div class="col-xl-3 col-md-6 mb-4">
            <div class="card border-left-info dashboard-card h-100">
                <div class="card-body">
                    <div class="row no-gutters align-items-center">
                        <div class="col mr-2">
                            <div class="text-xs font-weight-bold text-info text-uppercase mb-1">
                                Ganancias Hoy</div>
                            <div class="card-value" id="ventasHoy">S/ -</div>
                            <div class="text-xs text-info">
                                <i class="fas fa-chart-line"></i> Total: <span id="totalPedidos">-</span>
                            </div>
                        </div>
                        <div class="col-auto">
                            <i class="fas fa-shopping-cart card-icon text-info"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Ventas Card -->
        <div class="col-xl-3 col-md-6 mb-4">
            <div class="card border-left-warning dashboard-card h-100">
                <div class="card-body">
                    <div class="row no-gutters align-items-center">
                        <div class="col mr-2">
                            <div class="text-xs font-weight-bold text-warning text-uppercase mb-1">
                                Ganancias del Mes</div>
                            <div class="card-value" id="ventasMes">S/ -</div>
                            <div class="text-xs text-success">
                                <i class="fas fa-percentage"></i> Margen: <span id="margenPromedio">-</span>%
                            </div>
                        </div>
                        <div class="col-auto">
                            <i class="fas fa-dollar-sign card-icon text-warning"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Charts Row -->
    <div class="row">
        <!-- Top Productos por Precio -->
        <div class="col-xl-6 col-lg-6">
            <div class="card">
                <div class="card-header d-flex flex-row align-items-center justify-content-between">
                    <h6 class="m-0 font-weight-bold text-primary">Top 5 Productos Más Caros</h6>
                    <div class="dropdown no-arrow">
                        <a class="dropdown-toggle" href="#" role="button" id="dropdownMenuLink1" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                            <i class="fas fa-ellipsis-v fa-sm fa-fw text-gray-400"></i>
                        </a>
                        <div class="dropdown-menu dropdown-menu-right shadow animated--fade-in" aria-labelledby="dropdownMenuLink1">
                            <div class="dropdown-header">Opciones:</div>
                            <a class="dropdown-item" href="${pageContext.request.contextPath}/productos/listar.jsp">Ver Todos los Productos</a>
                        </div>
                    </div>
                </div>
                <div class="card-body">
                    <div style="height: 300px;">
                        <canvas id="topProductosChart"></canvas>
                    </div>
                </div>
            </div>
        </div>

        <!-- Productos por Rango de Precio -->
        <div class="col-xl-6 col-lg-6">
            <div class="card">
                <div class="card-header d-flex flex-row align-items-center justify-content-between">
                    <h6 class="m-0 font-weight-bold text-primary">Distribución por Rango de Precio</h6>
                    <div class="dropdown no-arrow">
                        <a class="dropdown-toggle" href="#" role="button" id="dropdownMenuLink2" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                            <i class="fas fa-ellipsis-v fa-sm fa-fw text-gray-400"></i>
                        </a>
                        <div class="dropdown-menu dropdown-menu-right shadow animated--fade-in" aria-labelledby="dropdownMenuLink2">
                            <div class="dropdown-header">Opciones:</div>
                            <a class="dropdown-item" href="${pageContext.request.contextPath}/productos/listar.jsp">Gestionar Productos</a>
                        </div>
                    </div>
                </div>
                <div class="card-body">
                    <div style="height: 300px;">
                        <canvas id="rangoPreciosChart"></canvas>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Scripts para gráficos -->
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
    // Set current date
    document.getElementById('currentDate').textContent = new Date().toLocaleDateString('es-ES', {
        weekday: 'long',
        year: 'numeric',
        month: 'long',
        day: 'numeric'
    });

    // Variables globales para los gráficos
    let topProductosChart, rangoPreciosChart;

    // Cargar dashboard al cargar la página
    document.addEventListener('DOMContentLoaded', function() {
        loadDashboard();
    });

    function loadDashboard() {
        // Cargar datos básicos primero
        fetch('${pageContext.request.contextPath}/api/dashboard')
            .then(response => {
                if (!response.ok) {
                    throw new Error('Error en la respuesta del servidor');
                }
                return response.json();
            })
            .then(data => {
                if (data.error) {
                    showError(data.error);
                } else {
                    updateBasicStats(data);
                    showDashboard();
                    // Cargar gráficos después
                    setTimeout(loadCharts, 500);
                }
            })
            .catch(error => {
                console.error('Error:', error);
                showError('Error al cargar el dashboard: ' + error.message);
            });
    }

    function updateBasicStats(data) {
        // Asegurar que los valores sean números
        const totalClientes = parseInt(data.totalClientes) || 0;
        const totalProductos = parseInt(data.totalProductos) || 0;
        const totalPedidos = parseInt(data.totalPedidos) || 0;
        const ventasHoy = parseFloat(data.ventasHoy) || 0;
        const ventasMes = parseFloat(data.ventasMes) || 0;
        const margenPromedio = parseFloat(data.margenPromedio) || 0;

        document.getElementById('totalClientes').textContent = totalClientes;
        document.getElementById('totalProductos').textContent = totalProductos;
        document.getElementById('totalPedidos').textContent = totalPedidos;
        document.getElementById('ventasHoy').textContent = 'S/ ' + ventasHoy.toLocaleString('es-PE', {minimumFractionDigits: 2});
        document.getElementById('ventasMes').textContent = 'S/ ' + ventasMes.toLocaleString('es-PE', {minimumFractionDigits: 2});
        document.getElementById('margenPromedio').textContent = margenPromedio.toFixed(1);
    }

    function showDashboard() {
        document.getElementById('loadingSpinner').style.display = 'none';
        document.getElementById('dashboardContent').style.display = 'block';
    }

    function showError(message) {
        document.getElementById('loadingSpinner').innerHTML = `
            <div class="alert alert-danger">
                <i class="fas fa-exclamation-triangle"></i>
                ${message}
            </div>
        `;
    }

    function loadCharts() {
        fetch('${pageContext.request.contextPath}/api/dashboard?action=chartData')
            .then(response => {
                if (!response.ok) {
                    throw new Error('Error al cargar datos de gráficos');
                }
                return response.json();
            })
            .then(data => {
                createTopProductosChart(data.topProductos || []);
                createRangoPreciosChart(data.rangoPrecios || []);
            })
            .catch(error => {
                console.error('Error al cargar gráficos:', error);
                loadDefaultCharts();
            });
    }

    function loadDefaultCharts() {
        const defaultTopProductos = [
            {nombre: 'Producto 1', precio: 300},
            {nombre: 'Producto 2', precio: 200},
            {nombre: 'Producto 3', precio: 100}
        ];

        const defaultRangoPrecios = [
            {rango: 'S/ 0-50', cantidad: 2},
            {rango: 'S/ 51-100', cantidad: 1},
            {rango: 'S/ 101-200', cantidad: 1}
        ];

        createTopProductosChart(defaultTopProductos);
        createRangoPreciosChart(defaultRangoPrecios);
    }

    function createTopProductosChart(data) {
        const ctx = document.getElementById('topProductosChart').getContext('2d');
        
        if (topProductosChart) {
            topProductosChart.destroy();
        }

        if (!data || data.length === 0) {
            loadDefaultCharts();
            return;
        }

        const labels = data.map(item => item.nombre || 'Sin nombre');
        const values = data.map(item => parseFloat(item.precio) || 0);

        topProductosChart = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: labels,
                datasets: [{
                    label: 'Precio (S/)',
                    data: values,
                    backgroundColor: 'rgba(54, 162, 235, 0.8)',
                    borderColor: 'rgba(54, 162, 235, 1)',
                    borderWidth: 2
                }]
            },
            options: {
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        display: false
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            callback: function(value) {
                                return 'S/ ' + value.toLocaleString();
                            }
                        }
                    }
                }
            }
        });
    }

    function createRangoPreciosChart(data) {
        const ctx = document.getElementById('rangoPreciosChart').getContext('2d');
        
        if (rangoPreciosChart) {
            rangoPreciosChart.destroy();
        }

        if (!data || data.length === 0) {
            loadDefaultCharts();
            return;
        }

        const labels = data.map(item => item.rango || 'Sin rango');
        const values = data.map(item => parseInt(item.cantidad) || 0);

        rangoPreciosChart = new Chart(ctx, {
            type: 'doughnut',
            data: {
                labels: labels,
                datasets: [{
                    data: values,
                    backgroundColor: [
                        'rgba(255, 99, 132, 0.8)',
                        'rgba(54, 162, 235, 0.8)',
                        'rgba(255, 205, 86, 0.8)',
                        'rgba(75, 192, 192, 0.8)',
                        'rgba(153, 102, 255, 0.8)'
                    ],
                    borderColor: [
                        'rgba(255, 99, 132, 1)',
                        'rgba(54, 162, 235, 1)',
                        'rgba(255, 205, 86, 1)',
                        'rgba(75, 192, 192, 1)',
                        'rgba(153, 102, 255, 1)'
                    ],
                    borderWidth: 2
                }]
            },
            options: {
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'bottom',
                        labels: {
                            padding: 20,
                            usePointStyle: true
                        }
                    }
                },
                cutout: '50%'
            }
        });
    }
</script>
