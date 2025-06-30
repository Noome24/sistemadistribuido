<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="container-fluid">
    <div class="row">
        <div class="col-12">
            <div class="card">
                <div class="card-header">
                    <h4 class="mb-0">
                        <i class="fas fa-user-plus me-2"></i>Agregar Nuevo Usuario
                    </h4>
                </div>
                <div class="card-body">
                    <!-- Mensajes de error -->
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="fas fa-exclamation-circle me-2"></i>${error}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <form id="formAgregarUsuario" method="post" action="${pageContext.request.contextPath}/usuarios/agregar">
                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="id_usuario" class="form-label">
                                        ID Usuario <span class="text-danger">*</span>
                                    </label>
                                    <input type="text" class="form-control" id="id_usuario" name="id_usuario" 
                                           value="${param.id_usuario}" required maxlength="10"
                                           placeholder="Ej: admin01, vendedor1">
                                    <div class="form-text">
                                        <i class="fas fa-info-circle me-1"></i>
                                        Mínimo 3 caracteres, solo letras y números
                                    </div>
                                    <div class="invalid-feedback" id="error-id_usuario"></div>
                                </div>
                            </div>
                            
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="passwd" class="form-label">
                                        Contraseña <span class="text-danger">*</span>
                                    </label>
                                    <div class="input-group">
                                        <input type="password" class="form-control" id="passwd" name="passwd" 
                                               required minlength="6" placeholder="Mínimo 6 caracteres">
                                        <button class="btn btn-outline-secondary" type="button" id="togglePassword">
                                            <i class="fas fa-eye"></i>
                                        </button>
                                    </div>
                                    <div class="form-text">
                                        <i class="fas fa-shield-alt me-1"></i>
                                        La contraseña será encriptada automáticamente
                                    </div>
                                    <div class="invalid-feedback" id="error-passwd"></div>
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="rol" class="form-label">
                                        Rol <span class="text-danger">*</span>
                                    </label>
                                    <select class="form-select" id="rol" name="rol" required>
                                        <option value="">Seleccionar rol...</option>
                                        <option value="1" ${param.rol == '1' ? 'selected' : ''}>Administrador</option>
                                        <option value="2" ${param.rol == '2' ? 'selected' : ''}>Vendedor</option>
                                    </select>
                                    <div class="form-text">
                                        <i class="fas fa-user-tag me-1"></i>
                                        Administrador: acceso completo, Vendedor: acceso limitado
                                    </div>
                                    <div class="invalid-feedback" id="error-rol"></div>
                                </div>
                            </div>
                            
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="estado" class="form-label">
                                        Estado <span class="text-danger">*</span>
                                    </label>
                                    <select class="form-select" id="estado" name="estado" required>
                                        <option value="">Seleccionar estado...</option>
                                        <option value="1" ${param.estado == '1' ? 'selected' : ''}>Activo</option>
                                        <option value="0" ${param.estado == '0' ? 'selected' : ''}>Inactivo</option>
                                    </select>
                                    <div class="form-text">
                                        <i class="fas fa-toggle-on me-1"></i>
                                        Solo usuarios activos pueden iniciar sesión
                                    </div>
                                    <div class="invalid-feedback" id="error-estado"></div>
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-12">
                                <div class="d-flex justify-content-between">
                                    <a href="${pageContext.request.contextPath}/usuarios/listar" class="btn btn-secondary">
                                        <i class="fas fa-arrow-left me-1"></i>Volver a la Lista
                                    </a>
                                    <div>
                                        <button type="reset" class="btn btn-outline-secondary me-2">
                                            <i class="fas fa-undo me-1"></i>Limpiar
                                        </button>
                                        <button type="submit" class="btn btn-success">
                                            <i class="fas fa-save me-1"></i>Guardar Usuario
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
$(document).ready(function() {
    // Toggle password visibility
    $('#togglePassword').click(function() {
        const passwordField = $('#passwd');
        const icon = $(this).find('i');
        
        if (passwordField.attr('type') === 'password') {
            passwordField.attr('type', 'text');
            icon.removeClass('fa-eye').addClass('fa-eye-slash');
        } else {
            passwordField.attr('type', 'password');
            icon.removeClass('fa-eye-slash').addClass('fa-eye');
        }
    });

    // Validación en tiempo real
    $('#id_usuario').on('input', function() {
        const valor = $(this).val();
        const regex = /^[a-zA-Z0-9]+$/;
        
        if (valor.length < 3) {
            mostrarError('id_usuario', 'El ID debe tener al menos 3 caracteres');
        } else if (!regex.test(valor)) {
            mostrarError('id_usuario', 'Solo se permiten letras y números');
        } else {
            limpiarError('id_usuario');
        }
    });

    $('#passwd').on('input', function() {
        const valor = $(this).val();
        
        if (valor.length < 6) {
            mostrarError('passwd', 'La contraseña debe tener al menos 6 caracteres');
        } else {
            limpiarError('passwd');
        }
    });

    // Validación del formulario
    $('#formAgregarUsuario').on('submit', function(e) {
        let valido = true;

        // Validar ID usuario
        const idUsuario = $('#id_usuario').val().trim();
        if (idUsuario.length < 3) {
            mostrarError('id_usuario', 'El ID debe tener al menos 3 caracteres');
            valido = false;
        } else if (!/^[a-zA-Z0-9]+$/.test(idUsuario)) {
            mostrarError('id_usuario', 'Solo se permiten letras y números');
            valido = false;
        }

        // Validar contraseña
        const passwd = $('#passwd').val();
        if (passwd.length < 6) {
            mostrarError('passwd', 'La contraseña debe tener al menos 6 caracteres');
            valido = false;
        }

        // Validar rol
        if ($('#rol').val() === '') {
            mostrarError('rol', 'Debe seleccionar un rol');
            valido = false;
        }

        // Validar estado
        if ($('#estado').val() === '') {
            mostrarError('estado', 'Debe seleccionar un estado');
            valido = false;
        }

        if (!valido) {
            e.preventDefault();
        }
    });

    // Auto-eliminar alertas después de 5 segundos
    setTimeout(function() {
        $('.alert').fadeOut('slow');
    }, 5000);
});

function mostrarError(campo, mensaje) {
    const input = $('#' + campo);
    const errorDiv = $('#error-' + campo);
    
    input.addClass('is-invalid');
    errorDiv.text(mensaje);
}

function limpiarError(campo) {
    const input = $('#' + campo);
    const errorDiv = $('#error-' + campo);
    
    input.removeClass('is-invalid');
    errorDiv.text('');
}
</script>
