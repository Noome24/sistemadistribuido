<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<div class="container-fluid">
    <!-- Header Section -->
    <div class="row mb-4">
        <div class="col-12">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <h2 class="mb-1">
                        <i class="fas fa-list text-primary me-2"></i>
                        Lista de Pedidos
                    </h2>
                    <p class="text-muted mb-0">Gestiona y visualiza todos los pedidos registrados</p>
                </div>
                <div>
                    <a href="${pageContext.request.contextPath}/pedidos/agregar" class="btn btn-success">
                        <i class="fas fa-plus me-2"></i>
                        Nuevo Pedido
                    </a>
                    <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-secondary">
                        <i class="fas fa-arrow-left me-2"></i>
                        Volver
                    </a>
                </div>
            </div>
        </div>
    </div>

    <!-- Mensajes -->
    <c:if test="${not empty sessionScope.error}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <i class="fas fa-exclamation-circle me-2"></i>
            ${sessionScope.error}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <c:remove var="error" scope="session" />
    </c:if>

    <c:if test="${not empty sessionScope.success}">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <i class="fas fa-check-circle me-2"></i>
            ${sessionScope.success}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <c:remove var="success" scope="session" />
    </c:if>

    <!-- Tabla de Pedidos -->
    <div class="card shadow-sm border-0">
        <div class="card-header bg-light">
            <h5 class="card-title mb-0">
                <i class="fas fa-table me-2"></i>
                Pedidos Registrados
            </h5>
        </div>
        <div class="card-body">
            <c:choose>
                <c:when test="${not empty pedidos}">
                    <div class="table-responsive">
                        <table class="table table-hover" id="tablaPedidos">
                            <thead class="table-dark">
                                <tr>
                                    <th><i class="fas fa-hashtag me-1"></i>ID Pedido</th>
                                    <th><i class="fas fa-calendar me-1"></i>Fecha</th>
                                    <th><i class="fas fa-user me-1"></i>Cliente</th>
                                    <th><i class="fas fa-calculator me-1"></i>Subtotal</th>
                                    <th><i class="fas fa-dollar-sign me-1"></i>Total</th>
                                    <th><i class="fas fa-cogs me-1"></i>Acciones</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="pedido" items="${pedidos}">
                                    <tr>
                                        <td>
                                            <span class="badge bg-primary">${pedido.id_pedido}</span>
                                        </td>
                                        <td>
                                            <fmt:formatDate value="${pedido.fecha}" pattern="dd/MM/yyyy"/>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty pedido.cliente}">
                                                    <i class="fas fa-user me-1"></i>
                                                    ${pedido.cliente.nombres} ${pedido.cliente.apellidos}
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-muted">Cliente no disponible</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <span class="text-success fw-bold">
                                                S/. <fmt:formatNumber value="${pedido.subtotal}" pattern="#,##0.00"/>
                                            </span>
                                        </td>
                                        <td>
                                            <span class="text-primary fw-bold">
                                                S/. <fmt:formatNumber value="${pedido.totalventa}" pattern="#,##0.00"/>
                                            </span>
                                        </td>
                                        <td>
                                            <div class="btn-group" role="group">
                                                <a href="${pageContext.request.contextPath}/pedidos/detalles/${pedido.id_pedido}" 
                                                   class="btn btn-info btn-sm" title="Ver Detalles">
                                                    <i class="fas fa-eye"></i>
                                                </a>
                                                <a href="${pageContext.request.contextPath}/pedidos/editar/${pedido.id_pedido}" 
                                                   class="btn btn-warning btn-sm" title="Editar">
                                                    <i class="fas fa-edit"></i>
                                                </a>
                                                <button type="button" class="btn btn-danger btn-sm" 
                                                        onclick="confirmarEliminar('${pedido.id_pedido}')" title="Eliminar">
                                                    <i class="fas fa-trash"></i>
                                                </button>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="text-center py-5">
                        <i class="fas fa-inbox fa-3x text-muted mb-3"></i>
                        <h5 class="text-muted">No hay pedidos registrados</h5>
                        <p class="text-muted">Comienza agregando tu primer pedido</p>
                        <a href="${pageContext.request.contextPath}/pedidos/agregar" class="btn btn-success">
                            <i class="fas fa-plus me-2"></i>
                            Agregar Primer Pedido
                        </a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<!-- Modal de Confirmación -->
<div class="modal fade" id="modalEliminar" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">
                    <i class="fas fa-exclamation-triangle text-warning me-2"></i>
                    Confirmar Eliminación
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <p>¿Está seguro que desea eliminar este pedido?</p>
                <p class="text-muted">Esta acción no se puede deshacer.</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                    <i class="fas fa-times me-1"></i>Cancelar
                </button>
                <a href="#" id="btnConfirmarEliminar" class="btn btn-danger">
                    <i class="fas fa-trash me-1"></i>Eliminar
                </a>
            </div>
        </div>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
$(document).ready(function() {
    // Inicializar DataTable si está disponible
    if (typeof $.fn.DataTable !== 'undefined' && $('#tablaPedidos').length > 0) {
        $('#tablaPedidos').DataTable({
            language: {
                url: 'https://cdn.datatables.net/plug-ins/1.11.5/i18n/es-ES.json'
            },
            responsive: true,
            pageLength: 10,
            order: [[1, 'desc']] // Ordenar por fecha descendente
        });
    }
});

function confirmarEliminar(idPedido) {
    $('#btnConfirmarEliminar').attr('href', '${pageContext.request.contextPath}/pedidos/eliminar/' + idPedido);
    $('#modalEliminar').modal('show');
}
</script>

<style>
.card {
    border-radius: 10px;
}

.card-header {
    border-bottom: 1px solid #e9ecef;
    border-radius: 10px 10px 0 0 !important;
}

.table th {
    border-top: none;
    font-weight: 600;
}

.btn-group .btn {
    margin-right: 2px;
}

.btn-group .btn:last-child {
    margin-right: 0;
}

.badge {
    font-size: 0.9em;
}

.table-responsive {
    border-radius: 8px;
}

.modal-content {
    border-radius: 10px;
}
</style>
