<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- 
    Document   : navbar
    Created on : 8 jun. 2025, 15:01:58
    Author     : DAMIAN
--%>
<%-- el de dasboard tiene mb-4, cliente index no,--%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<nav class="navbar navbar-expand-lg navbar-light mb-4">
    <div class="container-fluid">
        <button class="btn btn-outline-primary d-lg-none me-3" id="sidebarToggle">
            <i class="fas fa-bars"></i>
        </button>
        <a class="navbar-brand" href="${pageContext.request.contextPath}/dashboard.jsp">SisGestión</a>
        <div class="d-flex align-items-center ms-auto">
            <div class="dropdown">
                <a class="nav-link dropdown-toggle" href="#" role="button" id="userDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                    <span class="me-2 d-none d-lg-inline text-gray-600 small">${username}</span>
                    <i class="fas fa-user-circle fa-fw"></i>
                </a>
                <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userDropdown">
                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout"><i class="fas fa-sign-out-alt fa-sm fa-fw me-2 text-gray-400"></i> Cerrar Sesión</a></li>
                </ul>
            </div>
        </div>
    </div>
</nav>
