<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<header class="header">
    <div class="container-fluid">
        <div class="row align-items-center">
            <div class="col-md-6">
                <h1 class="header-title">
                    <i class="fas fa-tachometer-alt me-2"></i>
                    ${pageTitle}
                </h1>
            </div>
            <div class="col-md-6">
                <div class="header-actions d-flex justify-content-end align-items-center">
                    <!-- User Info -->
                    <div class="user-info me-3">
                        <span class="text-muted">Bienvenido,</span>
                        <strong>${sessionScope.usuario.nombre}</strong>
                    </div>
                    
                    <!-- Notifications -->
                    <div class="dropdown me-3">
                        <button class="btn btn-outline-secondary btn-sm dropdown-toggle" type="button" id="notificationsDropdown" data-bs-toggle="dropdown">
                            <i class="fas fa-bell"></i>
                            <span class="badge bg-danger">3</span>
                        </button>
                        <ul class="dropdown-menu dropdown-menu-end">
                            <li><h6 class="dropdown-header">Notificaciones</h6></li>
                            <li><a class="dropdown-item" href="#"><i class="fas fa-info-circle me-2"></i>Nueva actualización disponible</a></li>
                            <li><a class="dropdown-item" href="#"><i class="fas fa-exclamation-triangle me-2"></i>Pedido pendiente de aprobación</a></li>
                            <li><a class="dropdown-item" href="#"><i class="fas fa-user me-2"></i>Nuevo usuario registrado</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item text-center" href="#">Ver todas las notificaciones</a></li>
                        </ul>
                    </div>
                    
                    <!-- User Menu -->
                    <div class="dropdown">
                        <button class="btn btn-outline-primary btn-sm dropdown-toggle" type="button" id="userDropdown" data-bs-toggle="dropdown">
                            <i class="fas fa-user me-1"></i>
                            ${sessionScope.usuario.username}
                        </button>
                        <ul class="dropdown-menu dropdown-menu-end">
                            <li><h6 class="dropdown-header">Mi Cuenta</h6></li>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/perfil"><i class="fas fa-user-edit me-2"></i>Editar Perfil</a></li>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/configuracion"><i class="fas fa-cog me-2"></i>Configuración</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item text-danger" href="#" onclick="cerrarSesion(); return false;"><i class="fas fa-sign-out-alt me-2"></i>Cerrar Sesión</a></li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div>
</header>
