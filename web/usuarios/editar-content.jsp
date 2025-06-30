<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="container-fluid">
    <div class="row">
        <div class="col-12">
            <div class="card">
                <div class="card-header">
                    <h4 class="mb-0">
                        <i class="fas fa-user-edit me-2"></i>Editar Usuario: ${usuario.id_usuario}
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

                    <c:if test="${not empty usuario}">
                        <form id="formEditarUsuario" method="post" action="${pageContext.request.contextPath}/usuarios/editar">
                            <input type="hidden" name="id_usuario" value="${usuario.id_usuario}">
                            
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="id_usuario_display" class="form-label">
                                            ID Usuario
                                        </label>
                                        <input type="text" class="form-control" id="id_usuario_display" 
                                               value="${usuario.id_usuario}" readonly 
                                               style="background-color: #f8f9fa; cursor: not-allowed;">
                                        <div class="form-text">
                                            <i class="fas fa-lock me-1"></i>
                                            El ID de usuario no se puede modificar
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="rol" class="form-label">
                                            Rol <span class="text-danger">*</span>
                                        </label>
                                        <select class="form-select" id="rol" name="rol" required>
                                            <option value="">Seleccionar rol...</option>
                                            <option value="1" ${usuario.rol == 1 ? 'selected' : ''}>Administrador</option>
                                            <option value="2" ${usuario.rol == 2 ? 'selected' : ''}>Vendedor</option>
                                        </select>
                                        <div class="form-text">
                                            <i class="fas fa-user-tag me-1"></i>
                                            Administrador: acceso completo, Vendedor: acceso limitado
                                        </div>
                                        <div class="invalid-feedback" id="error-rol"></div>
                                    </div>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="estado" class="form-label">
                                            Estado <span class="text-danger">*</span>
                                        </label>
                                        <select class="form-select" id="estado" name="estado" required>
                                            <option value="">Seleccionar estado...</option>
                                            <option value="1" ${usuario.estado == 1 ? 'selected' : ''}>Activo</option>
                                            <option value="0" ${usuario.estado == 0 ? 'selected' : ''}>Inactivo</option>
                                        </select>
                                        <div class="form-text">
                                            <i class="fas fa-toggle-on me-1"></i>
                                            Solo usuarios activos pueden iniciar sesión
                                        </div>
                                        <div class="invalid-feedback" id="error-estado"></div>
                                    </div>
                                </div>
                            </div>

                            <!-- Sección de cambio de contraseña -->
                            <div class="card mt-4">
                                <div class="card-header">
                                    <h6 class="mb-0">
                                        <i class="fas fa-key me-2"></i>Cambiar Contraseña (Opcional)
                                    </h6>
                                </div>
                                <div class="card-body">
                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="mb-3">
                                                <label for="nueva_passwd" class="form-label">Nueva Contraseña</label>
                                                <div class="input-group">
                                                    <input type="password" class="form-control" id="nueva_passwd" 
                                                           name="nueva_passwd" minlength="6" 
                                                           placeholder="Dejar vacío para mantener actual">
                                                    <button class="btn btn-outline-secondary" type="button" id="toggleNewPassword">
                                                        <i class="fas fa-eye"></i>
                                                    </button>
                                                </div>
                                                <div class="form-text">
                                                    <i class="fas fa-info-circle me-1"></i>
                                                    Mínimo 6 caracteres. Dejar vacío para no cambiar
                                                </div>
                                                <div class="invalid-feedback" id="error-nueva_passwd"></div>
                                            </div>
                                        </div>
                                        
                                        <div class="col-md-6">
                                            <div class="mb-3">
                                                <label for="confirmar_passwd" class="form-label">Confirmar Nueva Contraseña</label>
                                                <div class="input-group">
                                                    <input type="password" class="form-control" id="confirmar_passwd" 
                                                           name="confirmar_passwd" placeholder="Confirmar nueva contraseña">
                                                    <button class="btn btn-outline-secondary" type="button" id="toggleConfirmPassword">
                                                        <i class="fas fa-eye"></i>
                                                    </button>
                                                </div>
                                                <div class="form-text">
                                                    <i class="fas fa-check-double me-1"></i>
                                                    Debe coincidir con la nueva contraseña
                                                </div>
                                                <div class="invalid-feedback" id="error-confirmar_passwd"></div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="row mt-4">
                                <div class="col-12">
                                    <div class="d-flex justify-content-between">
                                        <a href="${pageContext.request.contextPath}/usuarios/listar" class="btn btn-secondary">
                                            <i class="fas fa-arrow-left me-1"></i>Volver a la Lista
                                        </a>
                                        <div>
                                            <button type="reset" class="btn btn-outline-secondary me-2">
                                                <i class="fas fa-undo me-1"></i>Restaurar
                                            </button>
                                            <button type="submit" class="btn btn-primary">
                                                <i class="fas fa-save me-1"></i>Actualizar Usuario
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </form>
                    </c:if>

                    <c:if test="${empty usuario}">
                        <div class="text-center py-5">
                            <i class="fas fa-user-times fa-3x text-muted mb-3"></i>
                            <h5 class="text-muted">Usuario no encontrado</h5>
                            <a href="${pageContext.request.contextPath}/usuarios/listar" class="btn btn-primary">
                                <i class="fas fa-arrow-left me-1"></i>Volver a la Lista
                            </a>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
$(document).ready(function() {
    // Toggle password visibility
    $('#toggleNewPassword').click(function() {
        togglePasswordVisibility('nueva_passwd', $(this));
    });
    
    $('#toggleConfirmPassword').click(function() {
        togglePasswordVisibility('confirmar_passwd', $(this));
    });

    // Validación de contraseñas coincidentes
    $('#confirmar_passwd').on('input', function() {
        const nuevaPasswd = $('#nueva_passwd').val();
        const confirmarPasswd = $(this).val();
        
        if (nuevaPasswd !== '' && confirmarPasswd !== '') {
            if (nuevaPasswd !== confirmarPasswd) {
                mostrarError('confirmar_passwd', 'Las contraseñas no coinciden');
            } else {
                limpiarError('confirmar_passwd');
            }
        }
    });

    $('#nueva_passwd').on('input', function() {
        const valor = $(this).val();
        
        if (valor !== '' && valor.length < 6) {
            mostrarError('nueva_passwd', 'La contraseña debe tener al menos 6 caracteres');
        } else {
            limpiarError('nueva_passwd');
            // Revalidar confirmación si existe
            const confirmar = $('#confirmar_passwd').val();
            if (confirmar !== '') {
                $('#confirmar_passwd').trigger('input');
            }
        }
    });

    // Validación del formulario
    $('#formEditarUsuario').on('submit', function(e) {
        let valido = true;

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

        // Validar contraseñas si se proporcionan
        const nuevaPasswd = $('#nueva_passwd').val();
        const confirmarPasswd = $('#confirmar_passwd').val();
        
        if (nuevaPasswd !== '' || confirmarPasswd !== '') {
            if (nuevaPasswd.length < 6) {
                mostrarError('nueva_passwd', 'La contraseña debe tener al menos 6 caracteres');
                valido = false;
            }
            
            if (nuevaPasswd !== confirmarPasswd) {
                mostrarError('confirmar_passwd', 'Las contraseñas no coinciden');
                valido = false;
            }
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

function togglePasswordVisibility(fieldId, button) {
    const passwordField = $('#' + fieldId);
    const icon = button.find('i');
    
    if (passwordField.attr('type') === 'password') {
        passwordField.attr('type', 'text');
        icon.removeClass('fa-eye').addClass('fa-eye-slash');
    } else {
        passwordField.attr('type', 'password');
        icon.removeClass('fa-eye-slash').addClass('fa-eye');
    }
}

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
