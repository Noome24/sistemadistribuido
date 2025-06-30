<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
                    
                    <form action="${pageContext.request.contextPath}/register" method="post">
                        <div class="mb-3">
                            <label for="idUsuario" class="form-label">Nombre de Usuario</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="fas fa-user"></i></span>
                                <input type="text" class="form-control" id="idUsuario" name="idUsuario" required placeholder="Ingrese nombre de usuario">
                            </div>
                        </div>
                        <div class="mb-3">
                            <label for="passwd" class="form-label">Contraseña</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="fas fa-lock"></i></span>
                                <input type="password" class="form-control" id="passwd" name="passwd" required placeholder="Ingrese contraseña">
                            </div>
                        </div>
                        <div class="mb-4">
                            <label for="rol" class="form-label">Rol</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="fas fa-user-tag"></i></span>
                                <select class="form-control" id="rol" name="rol" required>
                                    <option value="1">Administrador</option>
                                    <option value="2" selected>Usuario</option>
                                    <option value="3">Vendedor</option>
                                </select>
                            </div>
                            <small class="form-text text-muted mt-2">
                                <strong>Administrador:</strong> Acceso completo al sistema<br>
                                <strong>Usuario:</strong> Acceso limitado (sin gestión de usuarios)<br>
                                <strong>Vendedor:</strong> Acceso a ventas y productos
                            </small>
                        </div>
                        <input type="hidden" name="estado" value="1">
                        <button type="submit" class="btn btn-primary btn-register">
                            <i class="fas fa-user-plus me-2"></i> Registrarse
                        </button>
                    </form>
                    
                    <div class="text-center mt-4">
                        <p class="text-muted">¿Ya tienes una cuenta? <a href="${pageContext.request.contextPath}/login" class="text-primary text-decoration-none fw-medium">Inicia sesión aquí</a></p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
