<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<%
    // Verificar sesión
    if (session == null || session.getAttribute("usuario") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>

<div class="container-fluid">
    <!-- Header Section -->
    <div class="row mb-4">
        <div class="col-12">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <h2 class="mb-1">
                        <i class="fas fa-box text-warning me-2"></i>
                        Gestión de Productos
                    </h2>
                    <p class="text-muted mb-0">Administra tu inventario y catálogo de productos de manera eficiente</p>
                </div>
            </div>
        </div>
    </div>

    <!-- Alertas -->
    <c:if test="${not empty sessionScope.success}">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <i class="fas fa-check-circle me-2"></i>${sessionScope.success}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
        <c:remove var="success" scope="session"/>
    </c:if>

    <c:if test="${not empty sessionScope.error}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <i class="fas fa-exclamation-circle me-2"></i>${sessionScope.error}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
        <c:remove var="error" scope="session"/>
    </c:if>

    <!-- Action Cards -->
    <div class="row g-4">
        <!-- Añadir Producto Card -->
        <div class="col-md-6">
            <div class="card h-100 shadow-sm border-0 hover-card">
                <div class="card-body text-center p-4">
                    <div class="mb-3">
                        <div class="icon-circle bg-warning bg-opacity-10 mx-auto mb-3">
                            <i class="fas fa-plus-square text-warning fa-2x"></i>
                        </div>
                    </div>
                    <h4 class="card-title mb-3">Añadir Producto</h4>
                    <p class="card-text text-muted mb-4">
                        Registra un nuevo producto con descripción, precio y cantidad en inventario.
                    </p>
                    <a href="${pageContext.request.contextPath}/productos/agregar" class="btn btn-warning btn-lg px-4">
                        <i class="fas fa-plus me-2"></i>
                        Nuevo Producto
                    </a>
                </div>
            </div>
        </div>

        <!-- Listar Productos Card -->
        <div class="col-md-6">
            <div class="card h-100 shadow-sm border-0 hover-card">
                <div class="card-body text-center p-4">
                    <div class="mb-3">
                        <div class="icon-circle bg-info bg-opacity-10 mx-auto mb-3">
                            <i class="fas fa-boxes text-info fa-2x"></i>
                        </div>
                    </div>
                    <h4 class="card-title mb-3">Listar Productos</h4>
                    <p class="card-text text-muted mb-4">
                        Visualiza, busca y gestiona todo tu catálogo de productos disponibles.
                    </p>
                    <a href="${pageContext.request.contextPath}/productos/listar" class="btn btn-info btn-lg px-4">
                        <i class="fas fa-eye me-2"></i>
                        Ver Productos
                    </a>
                </div>
            </div>
        </div>
    </div>

    <!-- Quick Stats -->
    <div class="row mt-5">
        <div class="col-12">
            <div class="card border-0 bg-light">
                <div class="card-body text-center py-3">
                    <small class="text-muted">
                        <i class="fas fa-info-circle me-1"></i>
                        Utiliza las opciones anteriores para gestionar eficientemente todos los productos
                    </small>
                </div>
            </div>
        </div>
    </div>
</div>

<style>
.hover-card {
    transition: all 0.3s ease;
    cursor: pointer;
}

.hover-card:hover {
    transform: translateY(-5px);
    box-shadow: 0 8px 25px rgba(0,0,0,0.15) !important;
}

.icon-circle {
    width: 80px;
    height: 80px;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
}

.btn-lg {
    padding: 12px 30px;
    font-weight: 500;
    border-radius: 8px;
    transition: all 0.3s ease;
}

.btn-lg:hover {
    transform: translateY(-2px);
    box-shadow: 0 4px 15px rgba(0,0,0,0.2);
}
</style>
