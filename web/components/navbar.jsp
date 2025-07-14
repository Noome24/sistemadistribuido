<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<nav class="navbar navbar-expand-lg navbar-light bg-light shadow-sm mb-4">
    <div class="container-fluid">
        <!-- Botón para togglear sidebar en móviles -->
        <button class="btn btn-outline-primary d-lg-none me-3" id="sidebarToggle">
            <i class="fas fa-bars"></i>
        </button>

        <!-- Logo o marca -->
        <a class="navbar-brand fw-bold" href="${pageContext.request.contextPath}/dashboard.jsp">
            <i class="fas fa-cogs me-2"></i>SisGestión
        </a>

        <!-- Usuario y rol visible (a la derecha) -->
        <div class="ms-auto d-flex align-items-center gap-3">
            <div class="text-end">
                <div class="fw-semibold text-dark">${username}</div>
                <div class="text-muted small">
                    <c:choose>
                        <c:when test="${rol == 0}">Administrador</c:when>
                        <c:when test="${rol == 2}">Recepcionista</c:when>
                        <c:when test="${rol == 3}">Transportista</c:when>
                        <c:otherwise>Cliente</c:otherwise>
                    </c:choose>
                </div>
            </div>
            <i class="fas fa-user-circle fa-2x text-primary"></i>
            <a href="${pageContext.request.contextPath}/logout" class="btn btn-sm btn-outline-danger ms-2">
                <i class="fas fa-sign-out-alt me-1"></i>Salir
            </a>
        </div>
    </div>
</nav>
