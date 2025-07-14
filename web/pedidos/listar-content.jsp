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
                        <c:choose>
                            <c:when test="${sessionScope.rol == 2}">Pedidos Sin Asignar</c:when>
                            <c:when test="${sessionScope.rol == 3}">Mis Pedidos Asignados</c:when>
                            <c:when test="${sessionScope.rol == 99}">Mis Pedidos</c:when>
                            <c:otherwise>Lista de Pedidos</c:otherwise>
                        </c:choose>
                    </h2>
                    <p class="text-muted mb-0">
                        <c:choose>
                            <c:when test="${sessionScope.rol == 2}">Gestiona pedidos pendientes de asignación</c:when>
                            <c:when test="${sessionScope.rol == 3}">Visualiza y actualiza tus pedidos asignados</c:when>
                            <c:when test="${sessionScope.rol == 99}">Visualiza el estado de tus pedidos</c:when>
                            <c:otherwise>Gestiona y visualiza todos los pedidos registrados</c:otherwise>
                        </c:choose>
                    </p>
                </div>
                <div>
                    <!-- Solo admins y usuarios normales pueden crear pedidos -->
                    <c:if test="${sessionScope.rol == 0 || sessionScope.rol == 1}">
                        <a href="${pageContext.request.contextPath}/pedidos/agregar" class="btn btn-success">
                            <i class="fas fa-plus me-2"></i>
                            Nuevo Pedido
                        </a>
                    </c:if>
                    <a href="${pageContext.request.contextPath}/pedidos" class="btn btn-secondary">
                        <i class="fas fa-arrow-left me-2"></i>
                        Volver
                    </a>
                </div>
            </div>
        </div>
    </div>

    <!-- Filtros para Recepcionistas -->
    <c:if test="${sessionScope.rol == 2}">
        <div class="row mb-3">
            <div class="col-12">
                <div class="card border-info">
                    <div class="card-body">
                        <h6 class="card-title text-info">
                            <i class="fas fa-info-circle me-2"></i>
                            Panel de Recepcionista
                        </h6>
                        <p class="card-text small">
                            Como recepcionista, puedes ver solo los pedidos sin asignar y decidir si aceptarlos o rechazarlos.
                            Una vez aceptados, los administradores podrán asignar transportistas.
                        </p>
                    </div>
                </div>
            </div>
        </div>
    </c:if>

    <!-- Información para Transportistas -->
    <c:if test="${sessionScope.rol == 3}">
        <div class="row mb-3">
            <div class="col-12">
                <div class="card border-warning">
                    <div class="card-body">
                        <h6 class="card-title text-warning">
                            <i class="fas fa-truck me-2"></i>
                            Panel de Transportista
                        </h6>
                        <p class="card-text small">
                            Aquí puedes ver todos los pedidos que te han sido asignados. 
                            Puedes cambiar el estado de "Asignado" a "En Proceso" y finalmente a "Entregado".
                        </p>
                    </div>
                </div>
            </div>
        </div>
    </c:if>

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
                <c:choose>
                    <c:when test="${sessionScope.rol == 2}">Pedidos Pendientes de Asignación</c:when>
                    <c:when test="${sessionScope.rol == 3}">Mis Pedidos Asignados</c:when>
                    <c:when test="${sessionScope.rol == 99}">Mis Pedidos</c:when>
                    <c:otherwise>Pedidos Registrados</c:otherwise>
                </c:choose>
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
                                    <th><i class="fas fa-info-circle me-1"></i>Estado</th>
                                    <th><i class="fas fa-calculator me-1"></i>Subtotal</th>
                                    <th><i class="fas fa-dollar-sign me-1"></i>Total</th>
                                    <!-- Solo admins ven la columna de transportista -->
                                    <c:if test="${sessionScope.rol == 0}">
                                        <th><i class="fas fa-truck me-1"></i>Transportista</th>
                                    </c:if>
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
                                            <span class="badge bg-${pedido.estadoColor}">
                                                ${pedido.estadoTexto}
                                            </span>
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
                                        
                                        <!-- Columna de asignación de transportista - Solo para Admins -->
                                        <c:if test="${sessionScope.rol == 0}">
                                            <td>
                                                <c:choose>
                                                    <c:when test="${pedido.estado == 2}">
                                                        <select class="form-select form-select-sm" 
                                                                onchange="asignarTransportista('${pedido.id_pedido}', this.value)">
                                                            <option value="">Seleccionar transportista</option>
                                                            <c:forEach var="transportista" items="${transportistas}">
                                                                <option value="${transportista.id_usuario}">
                                                                    ${transportista.id_usuario}
                                                                </option>
                                                            </c:forEach>
                                                        </select>
                                                    </c:when>
                                                    <c:when test="${pedido.estado >= 3}">
                                                        <span class="badge bg-info">Asignado</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted">Pendiente</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </c:if>
                                        
                                        <td>
                                            <div class="btn-group" role="group">
                                                <!-- Todos pueden ver detalles -->
                                                <a href="${pageContext.request.contextPath}/pedidos/detalles/${pedido.id_pedido}" 
                                                   class="btn btn-info btn-sm" title="Ver Detalles">
                                                    <i class="fas fa-eye"></i>
                                                </a>
                                                
                                                <c:if test="${sessionScope.rol == 0}">
                                                    <a href="${pageContext.request.contextPath}/pedidos/editar/${pedido.id_pedido}" 
                                                       class="btn btn-warning btn-sm" title="Editar">
                                                        <i class="fas fa-edit"></i>
                                                    </a>
                                                    <button type="button" class="btn btn-danger btn-sm" 
                                                            onclick="confirmarEliminar('${pedido.id_pedido}')" title="Eliminar">
                                                        <i class="fas fa-trash"></i>
                                                    </button>
                                                </c:if>
                                                
                                                <!-- Acciones específicas para Recepcionistas -->
                                                <c:if test="${sessionScope.rol == 2}">
                                                    <button type="button" class="btn btn-success btn-sm" 
                                                            onclick="cambiarEstado('${pedido.id_pedido}', 2)" 
                                                            title="Aceptar Pedido">
                                                        <i class="fas fa-check"></i> Aceptar
                                                    </button>
                                                    <button type="button" class="btn btn-danger btn-sm" 
                                                            onclick="cambiarEstado('${pedido.id_pedido}', 1)" 
                                                            title="Rechazar Pedido">
                                                        <i class="fas fa-times"></i> Rechazar
                                                    </button>
                                                </c:if>
                                                
                                                <!-- Acciones específicas para Transportistas -->
                                                <c:if test="${sessionScope.rol == 3}">
                                                    <c:choose>
                                                        <c:when test="${pedido.estado == 3}">
                                                            <button type="button" class="btn btn-warning btn-sm" 
                                                                    onclick="cambiarEstado('${pedido.id_pedido}', 4)" 
                                                                    title="Iniciar Proceso de Entrega">
                                                                <i class="fas fa-play"></i> Iniciar
                                                            </button>
                                                        </c:when>
                                                        <c:when test="${pedido.estado == 4}">
                                                            <button type="button" class="btn btn-success btn-sm" 
                                                                    onclick="cambiarEstado('${pedido.id_pedido}', 5)" 
                                                                    title="Marcar como Entregado">
                                                                <i class="fas fa-check-circle"></i> Entregar
                                                            </button>
                                                        </c:when>
                                                        <c:when test="${pedido.estado == 5}">
                                                            <span class="badge bg-success">
                                                                <i class="fas fa-check-circle"></i> Entregado
                                                            </span>
                                                        </c:when>
                                                    </c:choose>
                                                </c:if>
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
                        <h5 class="text-muted">
                            <c:choose>
                                <c:when test="${sessionScope.rol == 2}">No hay pedidos sin asignar</c:when>
                                <c:when test="${sessionScope.rol == 3}">No tienes pedidos asignados</c:when>
                                <c:when test="${sessionScope.rol == 99}">No has realizado pedidos</c:when>
                                <c:otherwise>No hay pedidos registrados</c:otherwise>
                            </c:choose>
                        </h5>
                        <p class="text-muted">
                            <c:choose>
                                <c:when test="${sessionScope.rol == 2}">Todos los pedidos han sido procesados</c:when>
                                <c:when test="${sessionScope.rol == 3}">Espera a que te asignen pedidos</c:when>
                                <c:when test="${sessionScope.rol == 99}">Comienza realizando tu primer pedido</c:when>
                                <c:otherwise>Comienza agregando tu primer pedido</c:otherwise>
                            </c:choose>
                        </p>
                        <c:if test="${sessionScope.rol == 0 || sessionScope.rol == 1}">
                            <a href="${pageContext.request.contextPath}/pedidos/agregar" class="btn btn-success">
                                <i class="fas fa-plus me-2"></i>
                                Agregar Primer Pedido
                            </a>
                        </c:if>
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

function asignarTransportista(idPedido, idTransportista) {
    if (!idTransportista) {
        alert('Por favor seleccione un transportista');
        return;
    }
    
    if (confirm('¿Está seguro que desea asignar este transportista al pedido?')) {
        fetch(`${pageContext.request.contextPath}/api/pedidos/${idPedido}/asignar/${idTransportista}`, {
            method: 'PATCH',
            headers: {
                'Content-Type': 'application/json',
            }
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                alert('Transportista asignado exitosamente');
                location.reload();
            } else {
                alert('Error al asignar transportista: ' + data.message);
            }
        })
        .catch(error => {
            console.error('Error:', error);
            alert('Error al asignar transportista');
        });
    }
}

function cambiarEstado(idPedido, nuevoEstado) {
    const contextPath = "${pageContext.request.contextPath}";
    
    if (!idPedido) {
        alert("Error: ID del pedido no válido");
        return;
    }

    const estados = {
        1: 'rechazar',
        2: 'aceptar',
        4: 'iniciar proceso de entrega',
        5: 'marcar como entregado'
    };

    const accion = estados[nuevoEstado];
    
    if (!accion) {
        alert("Error: Estado no válido");
        return;
    }

    const url = contextPath + "/api/pedidos/" + idPedido + "/estado/" + nuevoEstado;

    if (confirm(`¿Está seguro que desea ${accion} este pedido?`)) {
        fetch(url, {
            method: 'PATCH',
            headers: {
                'Content-Type': 'application/json'
            }
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                alert(`Pedido ${accion} exitosamente`);
                location.reload();
            } else {
                alert("Error al cambiar estado: " + data.message);
            }
        })
        .catch(error => {
            console.error("Error:", error);
            alert("Error al cambiar estado: " + error.message);
        });
    }
}

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

.form-select-sm {
    max-width: 180px;
}

/* Role-specific styling */
.border-info {
    border-color: #0dcaf0 !important;
}

.border-warning {
    border-color: #ffc107 !important;
}

.text-info {
    color: #0dcaf0 !important;
}

.text-warning {
    color: #ffc107 !important;
}
</style>
