<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!-- Top Bar -->
<div class="topbar" id="topbar">
    <button class="toggle-sidebar" id="toggle-sidebar">
        <i class="bi bi-list"></i>
    </button>
    <div class="user-info">
        <c:if test="${rol == 1}">
            <span class="badge bg-primary me-2">Administrador</span>
        </c:if>
        <c:if test="${rol == 2}">
            <span class="badge bg-info me-2">Vendedor</span>
        </c:if>
        <span class="me-2">${username}</span>
        <div class="dropdown">
            <button class="btn btn-link dropdown-toggle" type="button" id="userDropdown" data-bs-toggle="dropdown">
                <i class="bi bi-person-circle"></i>
            </button>
            <ul class="dropdown-menu dropdown-menu-end">
                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/perfil"><i class="bi bi-person me-2"></i>Perfil</a></li>
                <li><hr class="dropdown-divider"></li>
                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout"><i class="bi bi-box-arrow-right me-2"></i>Cerrar Sesión</a></li>
            </ul>
        </div>
    </div>
</div>
