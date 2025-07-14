<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<script>
    console.log("=== DEBUG CLIENTES LISTAR ===");
    
</script>

<div class="container-fluid">
    <div class="page-header mb-3">
        <h1 class="page-title">
            <i class="fas fa-users me-3"></i>
            Listado de Clientes
        </h1>
        <c:if test="${sessionScope.usuario != null && sessionScope.usuario.rol == 0}">
        <a href="${pageContext.request.contextPath}/clientes/agregar.jsp" class="btn btn-primary btn-modern ms-3">
            <i class="fas fa-user-plus me-2"></i>Nuevo Cliente
        </a>
        </c:if>
    </div>

    <c:if test="${not empty success}">
        <div class="alert alert-success alert-modern alert-dismissible fade show" role="alert">
            <i class="fas fa-check-circle me-2"></i> ${success}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>

    <c:if test="${not empty error}">
        <div class="alert alert-danger alert-modern alert-dismissible fade show" role="alert">
            <i class="fas fa-exclamation-circle me-2"></i> ${error}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>

    <div class="card card-modern">
        <div class="card-header">
            <h6 class="card-title">
                <i class="fas fa-table me-2"></i>Clientes Registrados
            </h6>
        </div>
        <div class="card-body">
            <c:choose>
                <c:when test="${not empty clientes}">
                    <div class="table-responsive">
                        <table class="table table-modern" id="clientesTable" width="100%" cellspacing="0">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Nombre Completo</th>
                                    <th>DNI</th>
                                    <th>Teléfono</th>
                                    <th>Móvil</th>
                                    <th>Dirección</th>
                                    <th>Acciones</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${clientes}" var="cliente">
                                    <tr>
                                        <td><span class="badge badge-light">${cliente.id_cliente}</span></td>
                                        <td>
                                            <div class="user-info">
                                                <div class="user-avatar">
                                                    <i class="fas fa-user"></i>
                                                </div>
                                                <div class="user-details">
                                                    <div class="user-name">
                                                        <c:out value="${cliente.nombres}" /> <c:out value="${cliente.apellidos}" />
                                                    </div>
                                                </div>
                                            </div>
                                        </td>
                                        <td><c:out value="${cliente.dni}" /></td>
                                        <td><c:out value="${cliente.telefono}" /></td>
                                        <td><c:out value="${cliente.movil}" /></td>
                                        <td><c:out value="${cliente.direccion}" /></td>
                                        <td>
                                            <c:if test="${sessionScope.usuario != null && sessionScope.usuario.rol == 0}">
                                            <div class="action-buttons">
                                                <a href="${pageContext.request.contextPath}/api/clientes/editar/${cliente.id_cliente}" class="btn btn-sm btn-outline-primary btn-action" title="Editar">
                                                    <i class="fas fa-edit"></i>
                                                </a>
                                                <a href="${pageContext.request.contextPath}/api/clientes/eliminar/${cliente.id_cliente}" class="btn btn-sm btn-outline-danger btn-action" 
                                                   onclick="return confirm('¿Está seguro de eliminar este cliente?')" title="Eliminar">
                                                    <i class="fas fa-trash"></i>
                                                </a>
                                            </div>
                                            </c:if>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="text-center py-4">
                        <i class="fas fa-users fa-3x text-muted mb-3"></i>
                        <h5 class="text-muted">No hay clientes registrados</h5>
                        <c:if test="${sessionScope.usuario != null && sessionScope.usuario.rol == 0}">
                        <p class="text-muted">Comience agregando un nuevo cliente</p>
                        <a href="${pageContext.request.contextPath}/clientes/agregar.jsp" class="btn btn-primary">
                            <i class="fas fa-user-plus me-2"></i>Agregar Cliente
                        </a>
                        </c:if>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>
