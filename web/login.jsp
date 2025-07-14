<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Iniciar Sesión - Sistema de Gestión</title>
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
        <div class="login-container mx-auto fade-in">
            <div class="row g-0">
                <div class="col-md-6 login-image d-none d-md-block" 
                     style="background-image: url('https://images.unsplash.com/photo-1556761175-5973dc0f32e7?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1632&q=80');">
                </div>
                <div class="col-md-6 login-form">
                    <div class="text-center mb-4">
                        <i class="fas fa-store text-primary" style="font-size: 3rem;"></i>
                        <h2 class="login-title">Sistema de Gestión</h2>
                        <p class="text-muted">Bienvenido de vuelta</p>
                    </div>
                    
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger" role="alert">
                            <i class="fas fa-exclamation-circle me-2"></i> ${error}
                        </div>
                    </c:if>
                    
                    <c:if test="${not empty success}">
                        <div class="alert alert-success" role="alert">
                            <i class="fas fa-check-circle me-2"></i> ${success}
                        </div>
                    </c:if>
                    
                    <form action="${pageContext.request.contextPath}/login" method="post">
                        <div class="mb-3">
                            <label for="dni" class="form-label">DNI / Usuario</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="fas fa-id-card"></i></span>
                                <input type="text" class="form-control" id="dni" name="dni" required 
                                       placeholder="Ingrese su DNI o usuario" maxlength="20">
                            </div>
                            <small class="form-text text-muted">
                                Ingrese su DNI si es cliente o su usuario si es empleado
                            </small>
                        </div>
                        <div class="mb-4">
                            <label for="password" class="form-label">Contraseña</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="fas fa-lock"></i></span>
                                <input type="password" class="form-control" id="password" name="password" required 
                                       placeholder="Ingrese su contraseña">
                            </div>
                        </div>
                        <button type="submit" class="btn btn-primary btn-login">
                            <i class="fas fa-sign-in-alt me-2"></i> Iniciar Sesión
                        </button>
                    </form>
                    
                    <div class="text-center mt-4">
                        <p class="text-muted">¿No tienes una cuenta? 
                            <a href="${pageContext.request.contextPath}/register" 
                               class="text-primary text-decoration-none fw-medium">Regístrate aquí</a>
                        </p>
                    </div>
                    
                    <div class="text-center mt-3">
                        <small class="text-muted">
                            <i class="fas fa-info-circle me-1"></i>
                            Los clientes usan su DNI, los empleados su usuario asignado
                        </small>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
