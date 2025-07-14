<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!-- Sidebar -->
<div class="sidebar" id="sidebar">
    <div class="sidebar-header">
        <h3>SisGestión</h3>
    </div>
    <ul class="sidebar-menu">
        
        <!-- Admin: Acceso completo -->
        <c:if test="${rol == 0}">
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
            <li>
                <a href="${pageContext.request.contextPath}/usuarios" class="${pageContext.request.requestURI.contains('usuarios') ? 'active' : ''}">
                    <i class="bi bi-person-badge"></i>
                    <span class="menu-text">Usuarios</span>
                </a>
            </li>
        </c:if>
        
        <!-- Recepcionista: Clientes, productos y pedidos (para modificar estados) -->
        <c:if test="${rol == 2}">
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
        </c:if>
        
        <!-- Transportista: Solo productos (listar) y pedidos asignados -->
        <c:if test="${rol == 3}">
            <li>
                <a href="${pageContext.request.contextPath}/productos" class="${pageContext.request.requestURI.contains('productos') ? 'active' : ''}">
                    <i class="bi bi-box-seam"></i>
                    <span class="menu-text">Productos</span>
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/pedidos" class="${pageContext.request.requestURI.contains('pedidos') ? 'active' : ''}">
                    <i class="bi bi-cart3"></i>
                    <span class="menu-text">Mis Pedidos</span>
                </a>
            </li>
        </c:if>
        
        <!-- Cliente: Solo productos (listar) y sus pedidos -->
        <c:if test="${rol == 99}">
            <li>
                <a href="${pageContext.request.contextPath}/productos" class="${pageContext.request.requestURI.contains('productos') ? 'active' : ''}">
                    <i class="bi bi-box-seam"></i>
                    <span class="menu-text">Productos</span>
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/pedidos" class="${pageContext.request.requestURI.contains('pedidos') ? 'active' : ''}">
                    <i class="bi bi-cart3"></i>
                    <span class="menu-text">Mis Pedidos</span>
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
