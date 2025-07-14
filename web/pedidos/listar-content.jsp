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
                    <c:if test="${sessionScope.rol != 3 && sessionScope.rol != 99}">
                        <a href="${pageContext.request.contextPath}/pedidos/agregar" class="btn btn-success">
                            <i class="fas fa-plus me-2"></i>
                            Nuevo Pedido
                        </a>
                    </c:if>
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
                <c:choose>
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
                                    <c:if test="${sessionScope.rol == 0 || sessionScope.rol == 2}">
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
                                        <c:if test="${sessionScope.rol == 0 || sessionScope.rol == 2}">
                                            <td>
                                                <div class="d-flex align-items-center">
                                                    <select class="form-select form-select-sm me-2" 
                                                            onchange="asignarTransportista('${pedido.id_pedido}', this.value)"
                                                            ${pedido.estado >= 5 ? 'disabled' : ''}>
                                                        <option value="">Sin asignar</option>
                                                        <!-- Las opciones se cargarán dinámicamente -->
                                                    </select>
                                                </div>
                                            </td>
                                        </c:if>
                                        <td>
                                            <div class="btn-group" role="group">
                                                <a href="${pageContext.request.contextPath}/pedidos/detalles/${pedido.id_pedido}" 
                                                   class="btn btn-info btn-sm" title="Ver Detalles">
                                                    <i class="fas fa-eye"></i>
                                                </a>
                                                
                                                <c:if test="${sessionScope.rol == 0 || sessionScope.rol == 1}">
                                                    <a href="${pageContext.request.contextPath}/pedidos/editar/${pedido.id_pedido}" 
                                                       class="btn btn-warning btn-sm" title="Editar">
                                                        <i class="fas fa-edit"></i>
                                                    </a>
                                                    <button type="button" class="btn btn-danger btn-sm" 
                                                            onclick="confirmarEliminar('${pedido.id_pedido}')" title="Eliminar">
                                                        <i class="fas fa-trash"></i>
                                                    </button>
                                                </c:if>
                                                
                                                <c:if test="${sessionScope.rol == 2}">
                                                    <div class="btn-group" role="group">
                                                        <button type="button" class="btn btn-success btn-sm" 
                                                                onclick="cambiarEstado('${pedido.id_pedido}', 2)" 
                                                                title="Aceptar" ${pedido.estado >= 2 ? 'disabled' : ''}>
                                                            <i class="fas fa-check"></i>
                                                        </button>
                                                        <button type="button" class="btn btn-danger btn-sm" 
                                                                onclick="cambiarEstado('${pedido.id_pedido}', 1)" 
                                                                title="Rechazar" ${pedido.estado != 0 ? 'disabled' : ''}>
                                                            <i class="fas fa-times"></i>
                                                        </button>
                                                    </div>
                                                </c:if>
                                                
                                                <c:if test="${sessionScope.rol == 3}">
                                                    <c:if test="${pedido.estado == 3}">
                                                        <button type="button" class="btn btn-warning btn-sm" 
                                                                onclick="cambiarEstado('${pedido.id_pedido}', 4)" 
                                                                title="Iniciar Proceso">
                                                            <i class="fas fa-play"></i>
                                                        </button>
                                                    </c:if>
                                                    <c:if test="${pedido.estado == 4}">
                                                        <button type="button" class="btn btn-success btn-sm" 
                                                                onclick="cambiarEstado('${pedido.id_pedido}', 5)" 
                                                                title="Marcar Entregado">
                                                            <i class="fas fa-check-circle"></i>
                                                        </button>
                                                    </c:if>
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
                        <h5 class="text-muted">No hay pedidos registrados</h5>
                        <p class="text-muted">
                            <c:choose>
                                <c:when test="${sessionScope.rol == 3}">No tienes pedidos asignados</c:when>
                                <c:when test="${sessionScope.rol == 99}">No has realizado pedidos</c:when>
                                <c:otherwise>Comienza agregando tu primer pedido</c:otherwise>
                            </c:choose>
                        </p>
                        <c:if test="${sessionScope.rol != 3 && sessionScope.rol != 99}">
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
let transportistas = [];

$(document).ready(function() {
    // Cargar transportistas
    cargarTransportistas();
    
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

function cargarTransportistas() {
    fetch('${pageContext.request.contextPath}/api/pedidos/transportistas')
        .then(response => response.json())
        .then(data => {
            transportistas = data;
            actualizarSelectsTransportistas();
        })
        .catch(error => console.error('Error al cargar transportistas:', error));
}

function actualizarSelectsTransportistas() {
    document.querySelectorAll('select[onchange*="asignarTransportista"]').forEach(select => {
        const pedidoId = select.getAttribute('onchange').match(/'([^']+)'/)[1];
        
        // Limpiar opciones existentes excepto la primera
        while (select.children.length > 1) {
            select.removeChild(select.lastChild);
        }
        
        // Agregar transportistas
        transportistas.forEach(transportista => {
            const option = document.createElement('option');
            option.value = transportista.id_usuario;
            option.textContent = transportista.id_usuario;
            select.appendChild(option);
        });
        
        // Obtener transportista actual asignado
        obtenerTransportistaAsignado(pedidoId, select);
    });
}

function obtenerTransportistaAsignado(pedidoId, select) {
    fetch(`${pageContext.request.contextPath}/api/pedidos/${pedidoId}`)
        .then(response => response.json())
        .then(pedido => {
            // Aquí necesitarías obtener el transportista asignado
            // Por ahora dejamos el select sin selección específica
        })
        .catch(error => console.error('Error:', error));
}

function asignarTransportista(idPedido, idTransportista) {
    if (!idTransportista) return;
    
    fetch(`${pageContext.request.contextPath}/api/pedidos/${idPedido}/asignar/${idTransportista}`, {
        method: 'PATCH',
        headers: {
            'Content-Type': 'application/json',
        }
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
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

function cambiarEstado(idPedido, nuevoEstado) {
    const contextPath = "${pageContext.request.contextPath}";
    console.debug("📂 contextPath:", contextPath);
    console.debug("🧾 ID recibido:", idPedido);
    console.debug("🔄 Estado recibido:", nuevoEstado);

    if (!idPedido) {
        alert("⚠️ El ID del pedido está vacío. Revisa tu código JSP.");
        return;
    }
    const estados = {
        1: 'rechazar',
        2: 'aceptar',
        4: 'iniciar proceso',
        5: 'marcar como entregado'
    };

    const accion = estados[nuevoEstado];

    console.debug("📌 DEBUG: Preparando solicitud...");
    console.debug("🧾 ID del Pedido:", idPedido);
    console.debug("🔄 Nuevo Estado:", nuevoEstado);
    console.debug("📘 Acción:", accion);

    if (!idPedido || !nuevoEstado || !accion) {
        console.error("❌ ERROR: Datos inválidos para cambiar estado");
        alert("Error: datos incompletos para cambiar estado.");
        return;
    }

    

    const url = contextPath + "/api/pedidos/" + idPedido + "/estado/" + nuevoEstado;

    console.debug("🌐 URL construida:", url);

    if (confirm(`¿Está seguro que desea ${accion} este pedido?`)) {
        fetch(url, {
            method: 'PATCH',
            headers: {
                'Content-Type': 'application/json'
            }
        })
        .then(response => {
            console.debug("📦 DEBUG: Status de respuesta:", response.status);
            return response.text().then(text => {
                console.debug("📄 DEBUG: Respuesta raw:", text);

                try {
                    return JSON.parse(text);
                } catch (e) {
                    throw new Error("Respuesta no es JSON válida");
                }
            });
        })
        .then(data => {
            console.debug("✅ DEBUG: Respuesta parseada:", data);
            if (data.success) {
                location.reload();
            } else {
                alert("⚠️ Error al cambiar estado: " + data.message);
            }
        })
        .catch(error => {
            console.error("🔥 ERROR FATAL durante cambiarEstado():", error);
            alert("Error al cambiar estado: " + error.message);
        });
    }
}


function filtrarPorEstado(estado) {
    // Actualizar botones activos
    document.querySelectorAll('.btn-group .btn').forEach(btn => {
        btn.classList.remove('active');
    });
    event.target.classList.add('active');
    
    if (estado === 'todos') {
        location.href = '${pageContext.request.contextPath}/pedidos/listar';
    } else {
        // Aquí podrías implementar filtrado AJAX o redirigir con parámetros
        location.href = `${pageContext.request.contextPath}/pedidos/listar?estado=${estado}`;
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
    max-width: 150px;
}
</style>
