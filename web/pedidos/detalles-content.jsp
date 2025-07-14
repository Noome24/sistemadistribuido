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
                        <i class="fas fa-file-invoice text-info me-2"></i>
                        Detalles del Pedido
                    </h2>
                    <p class="text-muted mb-0">Información completa del pedido #${pedido.id_pedido}</p>
                </div>
                <div>
                    <c:if test="${sessionScope.usuario != null && sessionScope.usuario.rol == 0}">
                    <a href="${pageContext.request.contextPath}/pedidos/editar/${pedido.id_pedido}" class="btn btn-warning">
                        <i class="fas fa-edit me-2"></i>
                        Editar
                    </a>
                    </c:if>
                    <a href="${pageContext.request.contextPath}/pedidos/listar" class="btn btn-secondary">
                        <i class="fas fa-arrow-left me-2"></i>
                        Volver
                    </a>
                </div>
            </div>
        </div>
    </div>

    <div class="row">
        <!-- Información del Pedido -->
        <div class="col-md-6">
            <div class="card shadow-sm border-0 mb-4">
                <div class="card-header bg-primary text-white">
                    <h5 class="card-title mb-0">
                        <i class="fas fa-info-circle me-2"></i>
                        Información General
                    </h5>
                </div>
                <div class="card-body">
                    <div class="row mb-3">
                        <div class="col-sm-4">
                            <strong><i class="fas fa-hashtag me-1"></i>ID Pedido:</strong>
                        </div>
                        <div class="col-sm-8">
                            <span class="badge bg-primary fs-6">${pedido.id_pedido}</span>
                        </div>
                    </div>
                    
                    <div class="row mb-3">
                        <div class="col-sm-4">
                            <strong><i class="fas fa-calendar me-1"></i>Fecha:</strong>
                        </div>
                        <div class="col-sm-8">
                            <fmt:formatDate value="${pedido.fecha}" pattern="dd/MM/yyyy" />
                        </div>
                    </div>
                    
                    <div class="row mb-3">
                        <div class="col-sm-4">
                            <strong><i class="fas fa-user me-1"></i>Cliente:</strong>
                        </div>
                        <div class="col-sm-8">
                            <c:choose>
                                <c:when test="${pedido.cliente != null}">
                                    ${pedido.cliente.nombres} ${pedido.cliente.apellidos}
                                </c:when>
                                <c:otherwise>
                                    Cliente no disponible
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    
                    <div class="row mb-3">
                        <div class="col-sm-4">
                            <strong><i class="fas fa-id-card me-1"></i>ID Cliente:</strong>
                        </div>
                        <div class="col-sm-8">
                            ${pedido.id_cliente}
                        </div>
                    </div>
                    
                    <c:if test="${pedido.cliente != null && pedido.cliente.dni != null}">
                        <div class="row mb-3">
                            <div class="col-sm-4">
                                <strong><i class="fas fa-id-badge me-1"></i>DNI:</strong>
                            </div>
                            <div class="col-sm-8">
                                ${pedido.cliente.dni}
                            </div>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>

        <!-- Resumen Financiero -->
        <div class="col-md-6">
            <div class="card shadow-sm border-0 mb-4">
                <div class="card-header bg-success text-white">
                    <h5 class="card-title mb-0">
                        <i class="fas fa-calculator me-2"></i>
                        Resumen Financiero
                    </h5>
                </div>
                <div class="card-body">
                    <div class="row mb-3">
                        <div class="col-6">
                            <div class="text-center">
                                <h6 class="text-muted mb-1">Subtotal</h6>
                                <h4 class="text-success mb-0">
                                    S/. <fmt:formatNumber value="${pedido.subtotal}" pattern="#,##0.00" />
                                </h4>
                            </div>
                        </div>
                        <div class="col-6">
                            <div class="text-center">
                                <h6 class="text-muted mb-1">IGV (18%)</h6>
                                <h4 class="text-warning mb-0">
                                    S/. <fmt:formatNumber value="${pedido.igv}" pattern="#,##0.00" />
                                </h4>
                            </div>
                        </div>
                    </div>
                    <hr>
                    <div class="text-center">
                        <h5 class="text-muted mb-1">Total Pagado</h5>
                        <h2 class="text-primary fw-bold mb-0">
                            S/. <fmt:formatNumber value="${pedido.totalventa}" pattern="#,##0.00" />
                        </h2>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Detalles de Productos -->
    <div class="card shadow-sm border-0">
        <div class="card-header bg-info text-white">
            <h5 class="card-title mb-0">
                <i class="fas fa-shopping-cart me-2"></i>
                Productos del Pedido
            </h5>
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-hover">
                    <thead class="table-dark">
                        <tr>
                            <th><i class="fas fa-hashtag me-1"></i>ID Producto</th>
                            <th><i class="fas fa-box me-1"></i>Producto</th>
                            <th class="text-center"><i class="fas fa-sort-numeric-up me-1"></i>Cantidad</th>
                            <th class="text-end"><i class="fas fa-dollar-sign me-1"></i>Precio Unit.</th>
                            <th class="text-end"><i class="fas fa-calculator me-1"></i>Total</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="detalle" items="${detalles}">
                            <tr>
                                <td>
                                    <span class="badge bg-secondary">${detalle.id_prod}</span>
                                </td>
                                <td>
                                    <i class="fas fa-cube me-2 text-muted"></i>
                                    <c:choose>
                                        <c:when test="${productos != null}">
                                            <c:forEach var="producto" items="${productos}">
                                                <c:if test="${producto.id_prod == detalle.id_prod}">
                                                    ${producto.descripcion}
                                                </c:if>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            Producto ${detalle.id_prod}
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="text-center">
                                    <span class="badge bg-primary">${detalle.cantidad}</span>
                                </td>
                                <td class="text-end">
                                    <span class="text-success">
                                        S/. <fmt:formatNumber value="${detalle.precio}" pattern="#,##0.00" />
                                    </span>
                                </td>
                                <td class="text-end">
                                    <strong class="text-primary">
                                        S/. <fmt:formatNumber value="${detalle.total_deta}" pattern="#,##0.00" />
                                    </strong>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                    <tfoot class="table-light">
                        <tr>
                            <td colspan="4" class="text-end fw-bold">
                                <i class="fas fa-calculator me-2"></i>Subtotal:
                            </td>
                            <td class="text-end fw-bold text-success">
                                S/. <fmt:formatNumber value="${pedido.subtotal}" pattern="#,##0.00" />
                            </td>
                        </tr>
                        <tr>
                            <td colspan="4" class="text-end fw-bold">
                                <i class="fas fa-percent me-2"></i>IGV (18%):
                            </td>
                            <td class="text-end fw-bold text-warning">
                                S/. <fmt:formatNumber value="${pedido.igv}" pattern="#,##0.00" />
                            </td>
                        </tr>
                        <tr class="table-primary">
                            <td colspan="4" class="text-end fw-bold fs-5">
                                <i class="fas fa-dollar-sign me-2"></i>TOTAL:
                            </td>
                            <td class="text-end fw-bold fs-5 text-primary">
                                S/. <fmt:formatNumber value="${pedido.totalventa}" pattern="#,##0.00" />
                            </td>
                        </tr>
                    </tfoot>
                </table>
            </div>
        </div>
    </div>

    <!-- Acciones Adicionales -->
    <div class="row mt-4">
        <div class="col-12">
            <div class="d-flex justify-content-center gap-3">
                <button class="btn btn-outline-primary" onclick="window.print()">
                    <i class="fas fa-print me-2"></i>
                    Imprimir Pedido
                </button>
                <c:if test="${sessionScope.usuario != null && sessionScope.usuario.rol == 0}">
                <a href="${pageContext.request.contextPath}/pedidos/editar/${pedido.id_pedido}" class="btn btn-warning">
                    <i class="fas fa-edit me-2"></i>
                    Editar Pedido
                </a>
            
                <button class="btn btn-outline-danger" onclick="confirmarEliminacion('${pedido.id_pedido}')">
                    <i class="fas fa-trash me-2"></i>
                    Eliminar Pedido
                </button>
                </c:if>
            </div>
        </div>
    </div>
</div>

<!-- Modal de Confirmación -->
<div class="modal fade" id="modalEliminar" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-danger text-white">
                <h5 class="modal-title">
                    <i class="fas fa-exclamation-triangle me-2"></i>
                    Confirmar Eliminación
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <p class="mb-0">¿Está seguro que desea eliminar este pedido?</p>
                <small class="text-muted">Esta acción no se puede deshacer y eliminará todos los detalles asociados.</small>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                    <i class="fas fa-times me-1"></i>Cancelar
                </button>
                <a id="btnConfirmarEliminar" href="#" class="btn btn-danger">
                    <i class="fas fa-trash me-1"></i>Eliminar
                </a>
            </div>
        </div>
    </div>
</div>

<script>
function confirmarEliminacion(idPedido) {
    const modal = new bootstrap.Modal(document.getElementById('modalEliminar'));
    const btnConfirmar = document.getElementById('btnConfirmarEliminar');
    btnConfirmar.href = '${pageContext.request.contextPath}/pedidos/eliminar/' + idPedido;
    modal.show();
}

// Estilos para impresión
window.addEventListener('beforeprint', function() {
    document.body.classList.add('printing');
});

window.addEventListener('afterprint', function() {
    document.body.classList.remove('printing');
});
</script>

<style>
.card {
    border-radius: 10px;
}

.card-header {
    border-radius: 10px 10px 0 0 !important;
}

.badge {
    font-size: 0.9rem;
}

.table th {
    border-top: none;
    font-weight: 600;
}

.table-hover tbody tr:hover {
    background-color: rgba(0,123,255,0.1);
}

/* Estilos para impresión */
@media print {
    .printing .btn,
    .printing .card-header,
    .printing .modal {
        display: none !important;
    }
    
    .printing .card {
        border: 1px solid #000 !important;
        box-shadow: none !important;
    }
    
    .printing .table {
        border: 1px solid #000;
    }
    
    .printing .table th,
    .printing .table td {
        border: 1px solid #000 !important;
    }
}
</style>
