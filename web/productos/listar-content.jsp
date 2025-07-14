<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>


<div class="container-fluid">
    <div class="page-header mb-3">
        <h1 class="page-title">
            <i class="fas fa-box me-3"></i>
            Listado de Productos
        </h1>
        <c:if test="${sessionScope.usuario != null && sessionScope.usuario.rol == 0}">
        <a href="${pageContext.request.contextPath}/productos/agregar" class="btn btn-primary btn-modern ms-3">
            <i class="fas fa-box-open me-2"></i>Nuevo Producto
        </a>
        </c:if>
    </div>
    
    <c:if test="${not empty success}">
        <div class="alert alert-success alert-modern alert-dismissible fade show" role="alert">
            <i class="fas fa-check-circle me-2"></i> ${success}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
        <c:remove var="success" scope="session" />
    </c:if>
    
    <c:if test="${not empty error}">
        <div class="alert alert-danger alert-modern alert-dismissible fade show" role="alert">
            <i class="fas fa-exclamation-circle me-2"></i> ${error}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
        <c:remove var="error" scope="session" />
    </c:if>
    
    <div class="card card-modern">
        <div class="card-header">
            <h6 class="card-title">
                <i class="fas fa-table me-2"></i>Productos Registrados
            </h6>
        </div>
        <div class="card-body">
            <c:choose>
                <c:when test="${not empty productos}">
                    <div class="table-responsive">
                        <table class="table table-modern" id="productosTable" width="100%" cellspacing="0">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Descripción</th>
                                    <th>Costo</th>
                                    <th>Precio</th>
                                    <th>Stock</th>
                                    <th>Ganancia</th>
                                    <th>Acciones</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${productos}" var="producto">
                                    <tr>
                                        <td><span class="badge badge-light"><c:out value="${producto.id_prod}" /></span></td>
                                        <td>
                                            <div class="product-info">
                                                <div class="product-icon">
                                                    <i class="fas fa-box"></i>
                                                </div>
                                                <div class="product-details">
                                                    <div class="product-name"><c:out value="${producto.descripcion}" /></div>
                                                </div>
                                            </div>
                                        </td>
                                        <td><span class="price-tag">S/ <fmt:formatNumber value="${producto.costo}" pattern="#,##0.00"/></span></td>
                                        <td><span class="price-tag price-sale">S/ <fmt:formatNumber value="${producto.precio}" pattern="#,##0.00"/></span></td>
                                        <td>
                                            <span class="badge ${producto.cantidad > 10 ? 'badge-success' : (producto.cantidad > 0 ? 'badge-warning' : 'badge-danger')}">
                                                <c:out value="${producto.cantidad}" />
                                            </span>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${producto.precio != null && producto.costo != null}">
                                                    <c:set var="ganancia" value="${producto.precio - producto.costo}" />
                                                    <c:choose>
                                                        <c:when test="${ganancia > 0}">
                                                            <span class="profit-positive">S/ <fmt:formatNumber value="${ganancia}" pattern="#,##0.00"/></span>
                                                        </c:when>
                                                        <c:when test="${ganancia < 0}">
                                                            <span class="profit-negative">S/ <fmt:formatNumber value="${ganancia}" pattern="#,##0.00"/></span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="profit-neutral">S/ 0.00</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-muted">N/A</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
    <div class="action-buttons">
        <c:choose>
            <c:when test="${sessionScope.usuario != null && sessionScope.usuario.rol == 0}">
                <!-- Botones habilitados para usuarios -->
                <a href="${pageContext.request.contextPath}/productos/editar/${producto.id_prod}" 
                   class="btn btn-sm btn-outline-primary btn-action" title="Editar">
                    <i class="fas fa-edit"></i>
                </a>
                <a href="${pageContext.request.contextPath}/productos/eliminar/${producto.id_prod}" 
                   class="btn btn-sm btn-outline-danger btn-action" 
                   onclick="return confirm('¿Está seguro de eliminar este producto?')" title="Eliminar">
                    <i class="fas fa-trash"></i>
                </a>
            </c:when>
            <c:otherwise>
                <!-- Botones deshabilitados para clientes -->
                <button type="button" class="btn btn-sm btn-outline-primary btn-action" disabled title="Solo usuarios pueden editar">
                    <i class="fas fa-edit"></i>
                </button>
                <button type="button" class="btn btn-sm btn-outline-danger btn-action" disabled title="Solo usuarios pueden eliminar">
                    <i class="fas fa-trash"></i>
                </button>
            </c:otherwise>
        </c:choose>
    </div>
</td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="text-center py-4">
                        <i class="fas fa-box fa-3x text-muted mb-3"></i>
                        <h5 class="text-muted">No hay productos registrados</h5>
                        <p class="text-muted">Comience agregando un nuevo producto</p>
                        <a href="${pageContext.request.contextPath}/productos/agregar" class="btn btn-primary">
                            <i class="fas fa-box-open me-2"></i>Agregar Producto
                        </a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<style>
.page-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    color: white;
    padding: 20px;
    border-radius: 10px;
    margin-bottom: 20px;
}

.page-title {
    margin: 0;
    font-weight: 600;
}

.btn-modern {
    border-radius: 8px;
    font-weight: 500;
    transition: all 0.3s ease;
}

.btn-modern:hover {
    transform: translateY(-2px);
    box-shadow: 0 4px 15px rgba(0,0,0,0.2);
}

.alert-modern {
    border: none;
    border-radius: 10px;
    box-shadow: 0 2px 10px rgba(0,0,0,0.1);
}

.card-modern {
    border: none;
    border-radius: 15px;
    box-shadow: 0 4px 20px rgba(0,0,0,0.1);
    overflow: hidden;
}

.card-modern .card-header {
    background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
    color: white;
    border: none;
    padding: 15px 20px;
}

.table-modern {
    margin: 0;
}

.table-modern thead th {
    background: #f8f9fa;
    border: none;
    font-weight: 600;
    color: #495057;
    padding: 15px;
}

.table-modern tbody td {
    padding: 15px;
    vertical-align: middle;
    border-top: 1px solid #e9ecef;
}

.badge-light {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    color: white;
    padding: 5px 10px;
    border-radius: 15px;
    font-weight: 500;
}

.product-info {
    display: flex;
    align-items: center;
}

.product-icon {
    width: 40px;
    height: 40px;
    background: linear-gradient(135deg, #ffecd2 0%, #fcb69f 100%);
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    margin-right: 15px;
    color: #d63384;
}

.product-name {
    font-weight: 500;
    color: #495057;
}

.price-tag {
    background: linear-gradient(135deg, #a8edea 0%, #fed6e3 100%);
    color: #495057;
    padding: 5px 12px;
    border-radius: 20px;
    font-weight: 600;
    display: inline-block;
}

.price-sale {
    background: linear-gradient(135deg, #d299c2 0%, #fef9d7 100%);
}

.badge-success {
    background: linear-gradient(135deg, #84fab0 0%, #8fd3f4 100%);
    color: #495057;
}

.badge-warning {
    background: linear-gradient(135deg, #ffecd2 0%, #fcb69f 100%);
    color: #495057;
}

.badge-danger {
    background: linear-gradient(135deg, #ff9a9e 0%, #fecfef 100%);
    color: #495057;
}

.profit-positive {
    color: #28a745;
    font-weight: 600;
}

.profit-negative {
    color: #dc3545;
    font-weight: 600;
}

.profit-neutral {
    color: #6c757d;
    font-weight: 600;
}

.action-buttons {
    display: flex;
    gap: 5px;
}

.btn-action {
    width: 35px;
    height: 35px;
    display: flex;
    align-items: center;
    justify-content: center;
    border-radius: 50%;
    transition: all 0.3s ease;
}

.btn-action:hover {
    transform: scale(1.1);
}
</style>

<script>
$(document).ready(function() {
    $('#productosTable').DataTable({
        "language": {
            "url": "//cdn.datatables.net/plug-ins/1.10.24/i18n/Spanish.json"
        },
        "pageLength": 10,
        "responsive": true,
        "order": [[ 1, "asc" ]]
    });
});
</script>
