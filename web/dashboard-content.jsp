<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

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
                        <div class="card-value">${totalClientes}</div>
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
                        <div class="card-value">${totalProductos}</div>
                        <div class="text-xs text-warning">
                            <i class="fas fa-exclamation-triangle"></i> Stock bajo: ${productosStockBajo}
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
                            Pedidos Hoy</div>
                        <div class="card-value">${pedidosHoy}</div>
                        <div class="text-xs text-info">
                            <i class="fas fa-chart-line"></i> Total: ${totalPedidos}
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
                            Ventas del Mes</div>
                        <div class="card-value">S/ ${ventasMes}</div>
                        <div class="text-xs text-success">
                            <i class="fas fa-percentage"></i> Margen: ${margenPromedio}%
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
    <!-- Ventas por Día -->
    <div class="col-xl-8 col-lg-7">
        <div class="card">
            <div class="card-header d-flex flex-row align-items-center justify-content-between">
                <h6 class="m-0 font-weight-bold text-primary">Ventas de los Últimos 7 Días</h6>
                <div class="dropdown no-arrow">
                    <a class="dropdown-toggle" href="#" role="button" id="dropdownMenuLink" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                        <i class="fas fa-ellipsis-v fa-sm fa-fw text-gray-400"></i>
                    </a>
                    <div class="dropdown-menu dropdown-menu-right shadow animated--fade-in" aria-labelledby="dropdownMenuLink">
                        <div class="dropdown-header">Opciones:</div>
                        <a class="dropdown-item" href="#">Ver Reporte Completo</a>
                        <a class="dropdown-item" href="#">Exportar Datos</a>
                    </div>
                </div>
            </div>
            <div class="card-body">
                <div style="height: 300px;">
                    <canvas id="salesChart"></canvas>
                </div>
            </div>
        </div>
    </div>

    <!-- Top Productos -->
    <div class="col-xl-4 col-lg-5">
        <div class="card">
            <div class="card-header d-flex flex-row align-items-center justify-content-between">
                <h6 class="m-0 font-weight-bold text-primary">Productos Más Vendidos</h6>
            </div>
            <div class="card-body">
                <div style="height: 300px;">
                    <canvas id="topProductsChart"></canvas>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Additional Metrics Row -->
<div class="row">
    <!-- Inventario Crítico -->
    <div class="col-xl-6 col-lg-6">
        <div class="card">
            <div class="card-header">
                <h6 class="m-0 font-weight-bold text-danger">Inventario Crítico (Stock < 10)</h6>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-sm">
                        <thead>
                            <tr>
                                <th>Producto</th>
                                <th>Stock</th>
                                <th>Estado</th>
                            </tr>
                        </thead>
                        <tbody id="inventarioCritico">
                            <!-- Datos dinámicos -->
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- Actividad Reciente -->
    <div class="col-xl-6 col-lg-6">
        <div class="card">
            <div class="card-header">
                <h6 class="m-0 font-weight-bold text-primary">Actividad Reciente</h6>
            </div>
            <div class="card-body">
                <div class="timeline">
                    <div class="timeline-item">
                        <div class="timeline-marker bg-success"></div>
                        <div class="timeline-content">
                            <h6 class="timeline-title">Nuevo pedido registrado</h6>
                            <p class="timeline-text">Cliente: Juan Pérez - S/ 150.00</p>
                            <small class="text-muted">Hace 2 horas</small>
                        </div>
                    </div>
                    <div class="timeline-item">
                        <div class="timeline-marker bg-info"></div>
                        <div class="timeline-content">
                            <h6 class="timeline-title">Producto actualizado</h6>
                            <p class="timeline-text">Stock de "Laptop HP" actualizado</p>
                            <small class="text-muted">Hace 4 horas</small>
                        </div>
                    </div>
                    <div class="timeline-item">
                        <div class="timeline-marker bg-warning"></div>
                        <div class="timeline-content">
                            <h6 class="timeline-title">Stock bajo detectado</h6>
                            <p class="timeline-text">Mouse Inalámbrico - Solo 3 unidades</p>
                            <small class="text-muted">Hace 6 horas</small>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    // Set current date
    document.getElementById('currentDate').textContent = new Date().toLocaleDateString('es-ES', {
        weekday: 'long',
        year: 'numeric',
        month: 'long',
        day: 'numeric'
    });

    // Charts
    document.addEventListener('DOMContentLoaded', function() {
        // Sales Chart - Last 7 days
        const salesCtx = document.getElementById('salesChart').getContext('2d');
        const salesChart = new Chart(salesCtx, {
            type: 'line',
            data: {
                labels: ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'],
                datasets: [{
                    label: 'Ventas Diarias (S/)',
                    data: [1200, 1900, 800, 2200, 2600, 1800, 2100],
                    backgroundColor: 'rgba(99, 102, 241, 0.1)',
                    borderColor: 'rgba(99, 102, 241, 1)',
                    pointBackgroundColor: 'rgba(99, 102, 241, 1)',
                    pointBorderColor: '#fff',
                    pointHoverBackgroundColor: '#fff',
                    pointHoverBorderColor: 'rgba(99, 102, 241, 1)',
                    borderWidth: 3,
                    fill: true,
                    tension: 0.4
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
                                return 'S/ ' + value;
                            }
                        }
                    }
                }
            }
        });
        
        // Top Products Chart
        const topProductsCtx = document.getElementById('topProductsChart').getContext('2d');
        const topProductsChart = new Chart(topProductsCtx, {
            type: 'doughnut',
            data: {
                labels: ['Laptops', 'Smartphones', 'Tablets', 'Accesorios', 'Otros'],
                datasets: [{
                    data: [35, 25, 20, 15, 5],
                    backgroundColor: [
                        '#6366f1',
                        '#10b981',
                        '#06b6d4',
                        '#f59e0b',
                        '#ef4444'
                    ],
                    hoverBackgroundColor: [
                        '#4f46e5',
                        '#059669',
                        '#0891b2',
                        '#d97706',
                        '#dc2626'
                    ],
                    borderWidth: 2,
                    borderColor: '#fff'
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
                cutout: '60%'
            }
        });

        // Load critical inventory
        loadCriticalInventory();
    });

    function loadCriticalInventory() {
        // Simulated data - in real app, this would come from the server
        const criticalItems = [
            { name: 'Mouse Inalámbrico', stock: 3, status: 'critical' },
            { name: 'Teclado Mecánico', stock: 7, status: 'warning' },
            { name: 'Monitor 24"', stock: 2, status: 'critical' },
            { name: 'Webcam HD', stock: 9, status: 'warning' }
        ];

        const tbody = document.getElementById('inventarioCritico');
        tbody.innerHTML = '';

        criticalItems.forEach(item => {
            const row = document.createElement('tr');
            const statusClass = item.status === 'critical' ? 'danger' : 'warning';
            const statusIcon = item.status === 'critical' ? 'exclamation-triangle' : 'exclamation-circle';
            
            row.innerHTML = `
                <td>${item.name}</td>
                <td><span class="badge bg-${statusClass}">${item.stock}</span></td>
                <td><i class="fas fa-${statusIcon} text-${statusClass}"></i></td>
            `;
            tbody.appendChild(row);
        });
    }
</script>
