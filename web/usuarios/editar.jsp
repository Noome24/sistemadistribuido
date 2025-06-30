<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="pageTitle" value="Editar Usuario - SisGestión" scope="request" />
<c:set var="contentPage" value="/usuarios/editar-content.jsp" scope="request" />

<!-- JS específico para validación de formulario -->
<c:set var="additionalJS" scope="request">
    <script>
        // Validación del formulario
        document.addEventListener('DOMContentLoaded', function() {
            document.getElementById('formUsuario').addEventListener('submit', function(e) {
                const password = document.getElementById('password').value;
                const confirmPassword = document.getElementById('confirmPassword').value;
                
                // Si se ingresó una nueva contraseña, validar que coincidan
                if (password && password !== confirmPassword) {
                    e.preventDefault();
                    alert('Las contraseñas no coinciden');
                    return;
                }
                
                // Validar longitud mínima de contraseña si se está cambiando
                if (password && password.length < 6) {
                    e.preventDefault();
                    alert('La contraseña debe tener al menos 6 caracteres');
                    return;
                }
            });
        });
    </script>
</c:set>

<jsp:include page="/layout.jsp" />
