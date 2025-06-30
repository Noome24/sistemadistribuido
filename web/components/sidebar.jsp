<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!-- Sidebar -->
<div class="sidebar" id="sidebar">
    <div class="sidebar-header">
        <h3>SisGestión</h3>
    </div>
    <ul class="sidebar-menu">
        <li>
            <a href="${pageContext.request.contextPath}/dashboard.jsp" class="${pageContext.request.requestURI.contains('dashboard') ? 'active' : ''}">
                <i class="bi bi-speedometer2"></i>
                <span class="menu-text">Dashboard</span>
            </a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/clientes" class="${pageContext.request.requestURI.contains('clientes') ? 'active' : ''}">
                <i class="bi bi-people"></i>
                <span class="menu-text">Clientes</span>
            </a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/productos" class="${pageContext.request.requestURI.contains('productos') ? 'active' : ''}">
                <i class="bi bi-box-seam"></i>
                <span class="menu-text">Productos</span>
            </a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/pedidos" class="${pageContext.request.requestURI.contains('pedidos') ? 'active' : ''}">
                <i class="bi bi-cart3"></i>
                <span class="menu-text">Pedidos</span>
            </a>
        </li>
        <c:if test="${rol == 1}">
            <li>
                <a href="${pageContext.request.contextPath}/usuarios" class="${pageContext.request.requestURI.contains('usuarios') ? 'active' : ''}">
                    <i class="bi bi-person-badge"></i>
                    <span class="menu-text">Usuarios</span>
                </a>
            </li>
        </c:if>
        <li>
            <a href="${pageContext.request.contextPath}/logout">
                <i class="bi bi-box-arrow-right"></i>
                <span class="menu-text">Cerrar Sesión</span>
            </a>
        </li>
    </ul>
</div>
