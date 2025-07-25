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
                        <i class="fas fa-plus-circle text-success me-2"></i>
                        Crear Nuevo Pedido
                    </h2>
                    <p class="text-muted mb-0">Registra un nuevo pedido de venta</p>
                </div>
                <div>
                    <a href="${pageContext.request.contextPath}/pedidos/listar" class="btn btn-secondary">
                        <i class="fas fa-arrow-left me-2"></i>
                        Volver a Lista
                    </a>
                </div>
            </div>
        </div>
    </div>

    <!-- Mensajes de Error -->
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

    <!-- Formulario -->
    <form id="formPedido" action="${pageContext.request.contextPath}/pedidos/guardar" method="post">
        <div class="row">
            <!-- Información del Pedido -->
            <div class="col-md-6">
                <div class="card shadow-sm border-0 mb-4">
                    <div class="card-header bg-primary text-white">
                        <h5 class="card-title mb-0">
                            <i class="fas fa-info-circle me-2"></i>
                            Información del Pedido
                        </h5>
                    </div>
                    <div class="card-body">
                        <div class="mb-3">
                            <label for="id_pedido" class="form-label">
                                <i class="fas fa-hashtag me-1"></i>ID Pedido
                            </label>
                            <input type="text" class="form-control" id="id_pedido" name="id_pedido" 
                                   value="${nuevoId}" readonly>
                        </div>
                        
                        <div class="mb-3">
                            <label for="fecha" class="form-label">
                                <i class="fas fa-calendar me-1"></i>Fecha *
                            </label>
                            <input type="date" class="form-control" id="fecha" name="fecha" 
                                   value="<fmt:formatDate value='<%= new java.util.Date() %>' pattern='yyyy-MM-dd' />" required>
                        </div>
                        
                        <div class="mb-3">
                                                    <c:choose>
    <c:when test="${sessionScope.cliente != null}">
        <%-- Mostrar campo no editable para cliente autenticado --%>
        <div class="mb-3">
            <label for="id_cliente" class="form-label">
                <i class="fas fa-user me-1"></i>Cliente *
            </label>
            <select class="form-select" id="id_cliente" name="id_cliente" disabled>
                <option value="${sessionScope.cliente.id_cliente}" selected>
                    ${sessionScope.cliente.nombres} ${sessionScope.cliente.apellidos}
                </option>
            </select>
            <input type="hidden" name="id_cliente" value="${sessionScope.cliente.id_cliente}" />
        </div>
    </c:when>

    <c:otherwise>
        <%-- Mostrar selector editable si no es cliente --%>
        <div class="mb-3">
            <label for="id_cliente" class="form-label">
                <i class="fas fa-user me-1"></i>Cliente *
            </label>
            <select class="form-select" id="id_cliente" name="id_cliente" required>
                <option value="">Seleccionar cliente...</option>
                <c:forEach var="cliente" items="${clientes}">
                    <option value="${cliente.id_cliente}">
                        ${cliente.nombres} ${cliente.apellidos}
                    </option>
                </c:forEach>
            </select>
        </div>
    </c:otherwise>
</c:choose>
                        </div>

                        <!-- Estado del Pedido -->
                        <c:if test="${sessionScope.rol == 0 || sessionScope.rol == 2}">
                            <div class="mb-3">
                                <label for="estado" class="form-label">
                                    <i class="fas fa-info-circle me-1"></i>Estado del Pedido
                                </label>
                                <select class="form-select" id="estado" name="estado">
                                    <option value="0">Sin asignar</option>
                                    <option value="2">Aceptado</option>
                                    <option value="3">Asignado</option>
                                </select>
                            </div>
                        </c:if>

                        <!-- Asignación de Transportista -->
                        <c:if test="${sessionScope.rol == 0 || sessionScope.rol == 2}">
                            <div class="mb-3">
                                <label for="id_transportista" class="form-label">
                                    <i class="fas fa-truck me-1"></i>Transportista
                                </label>
                                <select class="form-select" id="id_transportista" name="id_transportista">
                                    <option value="">Sin asignar</option>
                                    <c:forEach var="transportista" items="${transportistas}">
                                        <option value="${transportista.id_usuario}">${transportista.id_usuario}</option>
                                    </c:forEach>
                                </select>
                                <div class="form-text">
                                    <i class="fas fa-info-circle me-1"></i>
                                    Si asigna un transportista, el estado cambiará automáticamente a "Asignado"
                                </div>
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>

            <!-- Resumen del Pedido -->
            <div class="col-md-6">
                <div class="card shadow-sm border-0 mb-4">
                    <div class="card-header bg-info text-white">
                        <h5 class="card-title mb-0">
                            <i class="fas fa-calculator me-2"></i>
                            Resumen del Pedido
                        </h5>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-6">
                                <div class="text-center">
                                    <h6 class="text-muted">Subtotal</h6>
                                    <h4 class="text-success" id="subtotalDisplay">S/. 0.00</h4>
                                </div>
                            </div>
                            <div class="col-6">
                                <div class="text-center">
                                    <h6 class="text-muted">IGV (18%)</h6>
                                    <h4 class="text-warning" id="igvDisplay">S/. 0.00</h4>
                                </div>
                            </div>
                        </div>
                        <hr>
                        <div class="text-center">
                            <h5 class="text-muted">Total a Pagar</h5>
                            <h2 class="text-primary fw-bold" id="totalDisplay">S/. 0.00</h2>
                        </div>

                        <!-- Estado Visual -->
                        <div class="mt-3 text-center">
                            <h6 class="text-muted">Estado del Pedido</h6>
                            <span class="badge bg-secondary fs-6" id="estadoBadge">Sin asignar</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Productos del Pedido -->
        <div class="card shadow-sm border-0 mb-4">
            <div class="card-header bg-success text-white">
                <div class="d-flex justify-content-between align-items-center">
                    <h5 class="card-title mb-0">
                        <i class="fas fa-shopping-cart me-2"></i>
                        Productos del Pedido
                    </h5>
                    <button type="button" class="btn btn-light btn-sm" onclick="agregarProducto()">
                        <i class="fas fa-plus me-1"></i>Agregar Producto
                    </button>
                </div>
            </div>
            <div class="card-body">
                <div id="productosContainer">
                    <!-- Los productos se agregarán dinámicamente aquí -->
                </div>
                
                <div class="alert alert-info" id="noProductosAlert">
                    <i class="fas fa-info-circle me-2"></i>
                    No hay productos agregados. Haga clic en "Agregar Producto" para comenzar.
                </div>
            </div>
        </div>

        <!-- Campos ocultos para totales -->
        <input type="hidden" id="subtotal" name="subtotal" value="0">
        <input type="hidden" id="totalventa" name="totalventa" value="0">

        <!-- Botones de Acción -->
        <div class="row">
            <div class="col-12">
                <div class="d-flex justify-content-end gap-2">
                    <a href="${pageContext.request.contextPath}/pedidos" class="btn btn-secondary">
                        <i class="fas fa-times me-2"></i>Cancelar
                    </a>
                    <button type="submit" class="btn btn-success" id="btnGuardar">
                        <i class="fas fa-save me-2"></i>Guardar Pedido
                    </button>
                </div>
            </div>
        </div>
    </form>
</div>

<!-- Script con datos de productos -->
<script>
let contadorProductos = 0;
const productos = [
    <c:forEach var="producto" items="${productos}" varStatus="status">
        {
            id: '${producto.id_prod}',
            nombre: '${producto.descripcion}',
            precio: ${producto.precio},
            stock: ${producto.cantidad}
        }<c:if test="${!status.last}">,</c:if>
    </c:forEach>
];

const estadosTexto = {
    0: 'Sin asignar',
    1: 'Rechazado',
    2: 'Aceptado',
    3: 'Asignado',
    4: 'En proceso',
    5: 'Entregado'
};

const estadosColor = {
    0: 'secondary',
    1: 'danger',
    2: 'success',
    3: 'info',
    4: 'warning',
    5: 'primary'
};

function agregarProducto() {
    contadorProductos++;
    const container = document.getElementById('productosContainer');
    const noProductosAlert = document.getElementById('noProductosAlert');
    
    const productoDiv = document.createElement('div');
    productoDiv.className = 'producto-item border rounded p-3 mb-3';
    productoDiv.id = 'producto-' + contadorProductos;
    
    // Generar opciones de productos
    let opcionesProductos = '<option value="">Seleccionar producto...</option>';
    productos.forEach(function(p) {
        opcionesProductos += '<option value="' + p.id + '" data-precio="' + p.precio + '" data-stock="' + p.stock + '">' + 
                           p.nombre + ' (Stock: ' + p.stock + ')</option>';
    });
    
    productoDiv.innerHTML = 
        '<div class="row align-items-center">' +
            '<div class="col-md-4">' +
                '<label class="form-label">Producto *</label>' +
                '<select class="form-select" name="productos[]" onchange="actualizarPrecio(this, ' + contadorProductos + ')" required>' +
                    opcionesProductos +
                '</select>' +
            '</div>' +
            '<div class="col-md-2">' +
                '<label class="form-label">Cantidad *</label>' +
                '<input type="number" class="form-control" name="cantidades[]" min="1" ' +
                       'onchange="calcularTotal(' + contadorProductos + ')" required>' +
            '</div>' +
            '<div class="col-md-2">' +
                '<label class="form-label">Precio Unit.</label>' +
                '<input type="number" class="form-control precio-input" step="0.01" readonly>' +
            '</div>' +
            '<div class="col-md-2">' +
                '<label class="form-label">Total</label>' +
                '<input type="text" class="form-control total-producto" readonly>' +
            '</div>' +
            '<div class="col-md-2">' +
                '<label class="form-label">&nbsp;</label>' +
                '<div>' +
                    '<button type="button" class="btn btn-danger btn-sm w-100" onclick="eliminarProducto(' + contadorProductos + ')">' +
                        '<i class="fas fa-trash"></i> Eliminar' +
                    '</button>' +
                '</div>' +
            '</div>' +
        '</div>';
    
    container.appendChild(productoDiv);
    noProductosAlert.style.display = 'none';
    actualizarResumen();
}

function eliminarProducto(id) {
    const elemento = document.getElementById('producto-' + id);
    elemento.remove();
    
    const container = document.getElementById('productosContainer');
    const noProductosAlert = document.getElementById('noProductosAlert');
    
    if (container.children.length === 0) {
        noProductosAlert.style.display = 'block';
    }
    
    actualizarResumen();
}

function actualizarPrecio(select, id) {
    const option = select.options[select.selectedIndex];
    const precio = option.getAttribute('data-precio') || 0;
    const stock = option.getAttribute('data-stock') || 0;
    
    const productoDiv = document.getElementById('producto-' + id);
    const precioInput = productoDiv.querySelector('.precio-input');
    const cantidadInput = productoDiv.querySelector('input[name="cantidades[]"]');
    
    precioInput.value = precio;
    cantidadInput.max = stock;
    cantidadInput.value = '';
    
    calcularTotal(id);
}

function calcularTotal(id) {
    const productoDiv = document.getElementById('producto-' + id);
    const cantidad = parseFloat(productoDiv.querySelector('input[name="cantidades[]"]').value) || 0;
    const precio = parseFloat(productoDiv.querySelector('.precio-input').value) || 0;
    const totalInput = productoDiv.querySelector('.total-producto');
    
    const total = cantidad * precio;
    totalInput.value = 'S/. ' + total.toFixed(2);
    
    actualizarResumen();
}

function actualizarResumen() {
    let subtotal = 0;
    
    document.querySelectorAll('.producto-item').forEach(function(item) {
        const cantidad = parseFloat(item.querySelector('input[name="cantidades[]"]').value) || 0;
        const precio = parseFloat(item.querySelector('.precio-input').value) || 0;
        subtotal += cantidad * precio;
    });
    
    const igv = subtotal * 0.18;
    const total = subtotal + igv;
    
    document.getElementById('subtotalDisplay').textContent = 'S/. ' + subtotal.toFixed(2);
    document.getElementById('igvDisplay').textContent = 'S/. ' + igv.toFixed(2);
    document.getElementById('totalDisplay').textContent = 'S/. ' + total.toFixed(2);
}

function actualizarEstadoBadge() {
    const estadoSelect = document.getElementById('estado');
    const transportistaSelect = document.getElementById('id_transportista');
    const estadoBadge = document.getElementById('estadoBadge');
    
    if (estadoSelect && estadoBadge) {
        let estado = parseInt(estadoSelect.value) || 0;
        
        // Si se asigna transportista, cambiar estado a "Asignado"
        if (transportistaSelect && transportistaSelect.value && estado < 3) {
            estado = 3;
            estadoSelect.value = 3;
        }
        
        estadoBadge.textContent = estadosTexto[estado];
        estadoBadge.className = 'badge bg-' + estadosColor[estado] + ' fs-6';
    }
}

// Event listeners
document.addEventListener('DOMContentLoaded', function() {
    // Agregar primer producto automáticamente
    agregarProducto();
    
    // Listeners para actualizar estado
    const estadoSelect = document.getElementById('estado');
    const transportistaSelect = document.getElementById('id_transportista');
    
    if (estadoSelect) {
        estadoSelect.addEventListener('change', actualizarEstadoBadge);
    }
    
    if (transportistaSelect) {
        transportistaSelect.addEventListener('change', actualizarEstadoBadge);
    }
    
    // Actualizar badge inicial
    actualizarEstadoBadge();
});

// Validación del formulario
document.getElementById('formPedido').addEventListener('submit', function(e) {
    const productos = document.querySelectorAll('.producto-item');
    
    if (productos.length === 0) {
        e.preventDefault();
        alert('Debe agregar al menos un producto al pedido.');
        return false;
    }
    
    // Validar que todos los productos tengan cantidad
    let valido = true;
    productos.forEach(function(item) {
        const cantidad = item.querySelector('input[name="cantidades[]"]').value;
        const producto = item.querySelector('select[name="productos[]"]').value;
        
        if (!producto || !cantidad || cantidad <= 0) {
            valido = false;
        }
    });
    
    if (!valido) {
        e.preventDefault();
        alert('Todos los productos deben tener una cantidad válida.');
        return false;
    }
});
</script>

<style>
.producto-item {
    background-color: #f8f9fa;
    transition: all 0.3s ease;
}

.producto-item:hover {
    background-color: #e9ecef;
}

.card {
    border-radius: 10px;
}

.card-header {
    border-radius: 10px 10px 0 0 !important;
}

.btn-group .btn {
    margin-right: 5px;
}

.form-label {
    font-weight: 600;
    color: #495057;
}

.alert {
    border-radius: 8px;
}

#estadoBadge {
    transition: all 0.3s ease;
}
</style>
