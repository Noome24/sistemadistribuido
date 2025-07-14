<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div class="container-fluid">
    <!-- Header Section -->
    <div class="row mb-4">
        <div class="col-12">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <h2 class="mb-1">
                        <i class="fas fa-users text-primary me-2"></i>
                        Gestión de Clientes
                    </h2>
                    <p class="text-muted mb-0">Administra la información de todos tus clientes de manera eficiente</p>
                </div>
            </div>
        </div>
    </div>

    <!-- Action Cards -->
    <div class="row g-4">
        <!-- Añadir Cliente Card -->
         <c:if test="${sessionScope.usuario != null && sessionScope.usuario.rol == 0}">
        <div class="col-md-6">
            <div class="card h-100 shadow-sm border-0 hover-card">
                <div class="card-body text-center p-4">
                    <div class="mb-3">
                        <div class="icon-circle bg-primary bg-opacity-10 mx-auto mb-3">
                            <i class="fas fa-user-plus text-primary fa-2x"></i>
                        </div>
                    </div>
                    <h4 class="card-title mb-3">Añadir Cliente</h4>
                    <p class="card-text text-muted mb-4">
                        Registra un nuevo cliente con toda su información personal y de contacto.
                    </p>
                    <a href="${pageContext.request.contextPath}/clientes/agregar.jsp" class="btn btn-primary btn-lg px-4">
                        <i class="fas fa-plus me-2"></i>
                        Nuevo Cliente
                    </a>
                </div>
            </div>
        </div>
        </c:if>
        <!-- Listar Clientes Card -->
        <div class="col-md-6">
            <div class="card h-100 shadow-sm border-0 hover-card">
                <div class="card-body text-center p-4">
                    <div class="mb-3">
                        <div class="icon-circle bg-info bg-opacity-10 mx-auto mb-3">
                            <i class="fas fa-list text-info fa-2x"></i>
                        </div>
                    </div>
                    <h4 class="card-title mb-3">Listar Clientes</h4>
                    <p class="card-text text-muted mb-4">
                        Visualiza, busca y gestiona todos los clientes registrados en el sistema.
                    </p>
                    <a href="${pageContext.request.contextPath}/clientes/listar" class="btn btn-info btn-lg px-4">
                        <i class="fas fa-eye me-2"></i>
                        Ver Clientes
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
                        Utiliza las opciones anteriores para gestionar eficientemente todos los clientes
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
