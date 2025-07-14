<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registro - Sistema de Gestión</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <!-- Custom CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sistema-styles.css">
</head>

<body class="d-flex align-items-center justify-content-center min-vh-100">
    <div class="container">
        <div class="register-container mx-auto fade-in">
            <div class="row g-0">
                <div class="col-md-6 register-image d-none d-md-block"
                     style="background-image: url('https://images.unsplash.com/photo-1551836022-deb4988cc6c0?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1470&q=80');">
                </div>
                <div class="col-md-6 register-form">
                    <div class="text-center mb-4">
                        <i class="fas fa-user-plus text-primary" style="font-size: 3rem;"></i>
                        <h2 class="register-title">Registro de Usuario</h2>
                        <p class="text-muted">Crea tu cuenta nueva</p>
                    </div>

                    <c:if test="${not empty error}">
                        <div class="alert alert-danger" role="alert">
                            <i class="fas fa-exclamation-circle me-2"></i> ${error}
                        </div>
                    </c:if>

                    <!-- Selector de tipo de registro -->
                    <div class="mb-4">
                        <div class="btn-group w-100" role="group" aria-label="Tipo de registro">
                            <input type="radio" class="btn-check" name="tipoRegistroRadio" id="tipoCliente" value="cliente" checked>
                            <label class="btn btn-outline-primary" for="tipoCliente">
                                <i class="fas fa-user me-2"></i>Cliente
                            </label>
                            
                            <input type="radio" class="btn-check" name="tipoRegistroRadio" id="tipoUsuario" value="usuario">
                            <label class="btn btn-outline-primary" for="tipoUsuario">
                                <i class="fas fa-user-tie me-2"></i>Empleado
                            </label>
                        </div>
                    </div>

                    <!-- Formulario de registro de cliente -->
                    <form id="formCliente" action="${pageContext.request.contextPath}/register" method="post">
                        <input type="hidden" name="tipoRegistro" value="cliente">
                        
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="nombres" class="form-label">Nombres *</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fas fa-user"></i></span>
                                    <input type="text" class="form-control" id="nombres" name="nombres" required 
                                           placeholder="Nombres">
                                </div>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="apellidos" class="form-label">Apellidos *</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fas fa-user"></i></span>
                                    <input type="text" class="form-control" id="apellidos" name="apellidos" required 
                                           placeholder="Apellidos">
                                </div>
                            </div>
                        </div>
                        
                        <div class="mb-3">
                            <label for="dni" class="form-label">DNI *</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="fas fa-id-card"></i></span>
                                <input type="text" class="form-control" id="dni" name="dni" required 
                                       placeholder="Número de DNI" maxlength="20">
                            </div>
                        </div>
                        
                        <div class="mb-3">
                            <label for="email" class="form-label">Email</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="fas fa-envelope"></i></span>
                                <input type="email" class="form-control" id="email" name="email" 
                                       placeholder="correo@ejemplo.com">
                            </div>
                        </div>
                        
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="telefono" class="form-label">Teléfono</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fas fa-phone"></i></span>
                                    <input type="text" class="form-control" id="telefono" name="telefono" 
                                           placeholder="Teléfono fijo">
                                </div>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="movil" class="form-label">Móvil</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fas fa-mobile-alt"></i></span>
                                    <input type="text" class="form-control" id="movil" name="movil" 
                                           placeholder="Número móvil">
                                </div>
                            </div>
                        </div>
                        
                        <div class="mb-3">
                            <label for="direccion" class="form-label">Dirección</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="fas fa-map-marker-alt"></i></span>
                                <input type="text" class="form-control" id="direccion" name="direccion" 
                                       placeholder="Dirección completa">
                            </div>
                        </div>
                        
                        <div class="mb-4">
                            <label for="passwdCliente" class="form-label">Contraseña *</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="fas fa-lock"></i></span>
                                <input type="password" class="form-control" id="passwdCliente" name="passwd" required 
                                       placeholder="Contraseña">
                            </div>
                        </div>
                        
                        <button type="submit" class="btn btn-primary btn-register">
                            <i class="fas fa-user-plus me-2"></i> Registrarse como Cliente
                        </button>
                    </form>

                    <!-- Formulario de registro de empleado -->
                    <form id="formUsuario" action="${pageContext.request.contextPath}/register" method="post" style="display: none;">
                        <input type="hidden" name="tipoRegistro" value="usuario">
                        
                        <div class="mb-3">
                            <label for="idUsuario" class="form-label">Nombre de Usuario *</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="fas fa-user"></i></span>
                                <input type="text" class="form-control" id="idUsuario" name="idUsuario" 
                                       placeholder="Nombre de usuario">
                            </div>
                        </div>
                        
                        <div class="mb-3">
                            <label for="passwdUsuario" class="form-label">Contraseña *</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="fas fa-lock"></i></span>
                                <input type="password" class="form-control" id="passwdUsuario" name="passwd" 
                                       placeholder="Contraseña">
                            </div>
                        </div>
                        
                        <div class="mb-4">
                            <label for="rol" class="form-label">Rol *</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="fas fa-user-tag"></i></span>
                                <select class="form-control" id="rol" name="rol" required>
                                    <option value="0" selected>Administrador</option>
                                    <option value="2">Recepcionista</option>
                                    <option value="3">Transportista</option>
                                </select>
                            </div>
                            <small class="form-text text-muted mt-2">
                                <strong>Administrador:</strong> Acceso completo al sistema<br>
                                <strong>Recepcionista:</strong> Acceso a ventas y productos<br>
                                <strong>Transportista:</strong> Acceso a órdenes de envío y logística
                            </small>
                        </div>
                        
                        <button type="submit" class="btn btn-primary btn-register">
                            <i class="fas fa-user-plus me-2"></i> Registrarse como Empleado
                        </button>
                    </form>

                    <div class="text-center mt-4">
                        <p class="text-muted">¿Ya tienes una cuenta? 
                            <a href="${pageContext.request.contextPath}/login" 
                               class="text-primary text-decoration-none fw-medium">Inicia sesión aquí</a>
                        </p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // Cambiar entre formularios de cliente y empleado
        document.querySelectorAll('input[name="tipoRegistroRadio"]').forEach(radio => {
            radio.addEventListener('change', function() {
                const formCliente = document.getElementById('formCliente');
                const formUsuario = document.getElementById('formUsuario');
                
                if (this.value === 'cliente') {
                    formCliente.style.display = 'block';
                    formUsuario.style.display = 'none';
                    // Limpiar campos requeridos del formulario oculto
                    document.getElementById('idUsuario').removeAttribute('required');
                    document.getElementById('passwdUsuario').removeAttribute('required');
                    // Agregar required a campos del formulario visible
                    document.getElementById('nombres').setAttribute('required', '');
                    document.getElementById('apellidos').setAttribute('required', '');
                    document.getElementById('dni').setAttribute('required', '');
                    document.getElementById('passwdCliente').setAttribute('required', '');
                } else {
                    formCliente.style.display = 'none';
                    formUsuario.style.display = 'block';
                    // Limpiar campos requeridos del formulario oculto
                    document.getElementById('nombres').removeAttribute('required');
                    document.getElementById('apellidos').removeAttribute('required');
                    document.getElementById('dni').removeAttribute('required');
                    document.getElementById('passwdCliente').removeAttribute('required');
                    // Agregar required a campos del formulario visible
                    document.getElementById('idUsuario').setAttribute('required', '');
                    document.getElementById('passwdUsuario').setAttribute('required', '');
                }
            });
        });
    </script>
</body>
</html>
