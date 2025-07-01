<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<script>
    <c:if test="${not empty usuarios}">
        console.log("Número de usuarios:", ${usuarios.size()});
        <c:forEach items="${usuarios}" var="usuario" varStatus="status">
            console.log("Usuario ${status.index}:", {
                id: "${usuario.id_usuario}",
                rol: "${usuario.rol}",
                estado: "${usuario.estado}"
            });
        </c:forEach>
    </c:if>
</script>

<div class="container-fluid">
    <div class="row">
        <div class="col-12">
            <div class="card">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <h4 class="mb-0">
                        <i class="fas fa-users me-2"></i>Lista de Usuarios
                    </h4>
                    <a href="${pageContext.request.contextPath}/usuarios/agregar" class="btn btn-success">
                        <i class="fas fa-plus me-1"></i>Nuevo Usuario
                    </a>
                </div>
                <div class="card-body">
                    <!-- Mensajes de éxito/error -->
                    <c:if test="${not empty success}">
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                            <i class="fas fa-check-circle me-2"></i>${success}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>
                    
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="fas fa-exclamation-circle me-2"></i>${error}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <c:choose>
                        <c:when test="${not empty usuarios}">
                            <div class="table-responsive">
                                <table id="usuariosTable" class="table table-striped table-hover">
                                    <thead class="table-dark">
                                        <tr>
                                            <th>ID Usuario</th>
                                            <th>Rol</th>
                                            <th>Estado</th>
                                            <th>Acciones</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${usuarios}" var="usuario">
                                            <tr>
                                                <td>
                                                    <strong>${usuario.id_usuario}</strong>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${usuario.rol == 1}">
                                                            <span class="badge bg-primary">Administrador</span>
                                                        </c:when>
                                                        <c:when test="${usuario.rol == 2}">
                                                            <span class="badge bg-info">Vendedor</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge bg-secondary">Desconocido</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${usuario.estado == 1}">
                                                            <span class="badge bg-success">Activo</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge bg-danger">Inactivo</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <div class="btn-group" role="group">
                                                        <a href="${pageContext.request.contextPath}/usuarios/editar/${usuario.id_usuario}" 
                                                           class="btn btn-sm btn-outline-primary" title="Editar">
                                                            <i class="fas fa-edit"></i>
                                                        </a>
                                                        <button type="button" class="btn btn-sm btn-outline-danger" 
                                                                onclick="confirmarEliminacion('${usuario.id_usuario}')" title="Eliminar">
                                                            <i class="fas fa-trash"></i>
                                                        </button>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="text-center py-5">
                                <i class="fas fa-users fa-3x text-muted mb-3"></i>
                                <h5 class="text-muted">No hay usuarios registrados</h5>
                                <p class="text-muted">Comienza agregando tu primer usuario</p>
                                <a href="${pageContext.request.contextPath}/usuarios/agregar" class="btn btn-success">
                                    <i class="fas fa-plus me-1"></i>Agregar Usuario
                                </a>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
$(document).ready(function() {
    // Inicializar DataTable
    $('#usuariosTable').DataTable({
        language: {
            url: 'https://cdn.datatables.net/plug-ins/1.11.5/i18n/es-ES.json'
        },
        responsive: true,
        pageLength: 10,
        order: [[0, 'asc']]
    });

    // Auto-eliminar alertas después de 5 segundos
    setTimeout(function() {
        $('.alert').fadeOut('slow');
    }, 5000);
});

function confirmarEliminacion(idUsuario) {
    if (confirm('¿Estás seguro de que deseas eliminar el usuario "' + idUsuario + '"?\n\nEsta acción no se puede deshacer.')) {
        window.location.href = '${pageContext.request.contextPath}/usuarios/eliminar/' + idUsuario;
    }
}
</script>
