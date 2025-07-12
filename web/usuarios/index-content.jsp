<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div class="container-fluid">
    <div class="row">
        <div class="col-12">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2 class="mb-0">
                    <i class="fas fa-users me-2 text-primary"></i>Gestión de Usuarios
                </h2>
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb mb-0">
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/dashboard.jsp">Dashboard</a></li>
                        <li class="breadcrumb-item active">Usuarios</li>
                    </ol>
                </nav>
            </div>
        </div>
    </div>

    <div class="row g-4">
        <!-- Tarjeta Agregar Usuario -->
        <div class="col-md-6">
            <div class="card h-100 shadow-sm border-0 card-hover">
                <div class="card-body text-center p-4">
                    <div class="mb-3">
                        <div class="bg-danger bg-opacity-10 rounded-circle d-inline-flex align-items-center justify-content-center" 
                             style="width: 80px; height: 80px;">
                            <i class="fas fa-user-plus fa-2x text-danger"></i>
                        </div>
                    </div>
                    <h4 class="card-title text-danger mb-3">Agregar Usuario</h4>
                    <p class="card-text text-muted mb-4">
                        Crear nuevos usuarios del sistema con diferentes roles y permisos.
                        <br><small class="text-muted">
                            <i class="fas fa-info-circle me-1"></i>
                            Administradores y Recepcionistas
                        </small>
                    </p>
                    <a href="${pageContext.request.contextPath}/usuarios/agregar" 
                       class="btn btn-danger btn-lg px-4">
                        <i class="fas fa-plus me-2"></i>Nuevo Usuario
                    </a>
                </div>
            </div>
        </div>

        <!-- Tarjeta Listar Usuarios -->
        <div class="col-md-6">
            <div class="card h-100 shadow-sm border-0 card-hover">
                <div class="card-body text-center p-4">
                    <div class="mb-3">
                        <div class="bg-primary bg-opacity-10 rounded-circle d-inline-flex align-items-center justify-content-center" 
                             style="width: 80px; height: 80px;">
                            <i class="fas fa-list fa-2x text-primary"></i>
                        </div>
                    </div>
                    <h4 class="card-title text-primary mb-3">Lista de Usuarios</h4>
                    <p class="card-text text-muted mb-4">
                        Ver, editar y gestionar todos los usuarios registrados en el sistema.
                        <br><small class="text-muted">
                            <i class="fas fa-info-circle me-1"></i>
                            Gestión completa de usuarios
                        </small>
                    </p>
                    <a href="${pageContext.request.contextPath}/usuarios/listar" 
                       class="btn btn-primary btn-lg px-4">
                        <i class="fas fa-list me-2"></i>Ver Lista
                    </a>
                </div>
            </div>
        </div>
    </div>

    <!-- Información adicional -->
    <div class="row mt-5">
        <div class="col-12">
            <div class="card border-0 bg-light">
                <div class="card-body">
                    <h5 class="card-title">
                        <i class="fas fa-info-circle me-2 text-info"></i>Información sobre Usuarios
                    </h5>
                    <div class="row">
                        <div class="col-md-4">
                            <h6 class="text-primary">
                                <i class="fas fa-user-shield me-1"></i>Administrador
                            </h6>
                            <p class="small text-muted mb-3">
                                Acceso completo al sistema, puede gestionar usuarios, productos, clientes y pedidos.
                            </p>
                        </div>
                        <div class="col-md-4">
                            <h6 class="text-info">
                                <i class="fas fa-user-tie me-1"></i>Recepcionista
                            </h6>
                            <p class="small text-muted mb-3">
                                Acceso limitado, puede gestionar productos, clientes y pedidos, pero no usuarios.
                            </p>
                        </div>
                        <div class="col-md-4">
                            <h6 class="text-success">
                                <i class="fas fa-shield-alt me-1"></i>Seguridad
                            </h6>
                            <p class="small text-muted mb-3">
                                Las contraseñas se encriptan automáticamente y solo usuarios activos pueden acceder.
                            </p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<style>
.card-hover {
    transition: all 0.3s ease;
}

.card-hover:hover {
    transform: translateY(-5px);
    box-shadow: 0 8px 25px rgba(0,0,0,0.15) !important;
}

.card-hover:hover .btn {
    transform: scale(1.05);
}

.btn {
    transition: all 0.3s ease;
}
</style>
