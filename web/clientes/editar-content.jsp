<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<div class="container-fluid">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1>
            <i class="bi bi-person-lines-fill me-2 text-primary"></i>Editar Cliente
        </h1>
        <a href="${pageContext.request.contextPath}/clientes/listar.jsp" class="btn btn-secondary">
            <i class="bi bi-arrow-left me-1"></i> Volver
        </a>
    </div>

    <div class="card shadow mb-4">
        <div class="card-header py-3 bg-light">
            <h6 class="m-0 font-weight-bold text-primary">
                <i class="bi bi-info-circle me-1"></i>Datos del Cliente
            </h6>
        </div>
        <div class="card-body">
            <form action="${pageContext.request.contextPath}/api/clientes/actualizar" method="post" id="formCliente">
                <input type="hidden" name="id_cliente" value="${cliente.id_cliente}">

                <div class="row mb-3">
                    <div class="col-md-6">
                        <label for="id_cliente" class="form-label">ID Cliente</label>
                        <div class="input-group">
                            <span class="input-group-text bg-light">
                                <i class="bi bi-person-badge"></i>
                            </span>
                            <input type="text" class="form-control bg-light" id="id_cliente" 
                                   value="${cliente.id_cliente}" readonly tabindex="-1" 
                                   aria-readonly="true" style="pointer-events: none;">
                        </div>
                    </div>
                    <div class="col-md-6">
                        <label for="dni" class="form-label">DNI</label>
                        <div class="input-group">
                            <span class="input-group-text">
                                <i class="bi bi-person-vcard"></i>
                            </span>
                            <input type="text" class="form-control" id="dni" name="dni" 
                                   value="${cliente.dni}" maxlength="8" pattern="[0-9]{8}">
                            <button class="btn btn-outline-secondary" type="button" id="buscarDni">
                                <i class="bi bi-search"></i> Buscar
                            </button>
                        </div>
                        <small class="text-muted">Documento de identidad (8 dígitos)</small>
                    </div>
                </div>

                <div class="row mb-3">
                    <div class="col-md-6">
                        <label for="nombres" class="form-label">Nombres <span class="text-danger">*</span></label>
                        <div class="input-group">
                            <span class="input-group-text">
                                <i class="bi bi-person"></i>
                            </span>
                            <input type="text" class="form-control" id="nombres" name="nombres" 
                                   value="${cliente.nombres}" required>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <label for="apellidos" class="form-label">Apellidos <span class="text-danger">*</span></label>
                        <div class="input-group">
                            <span class="input-group-text">
                                <i class="bi bi-person"></i>
                            </span>
                            <input type="text" class="form-control" id="apellidos" name="apellidos" 
                                   value="${cliente.apellidos}" required>
                        </div>
                    </div>
                </div>

                <div class="mb-3">
                    <label for="direccion" class="form-label">Dirección</label>
                    <div class="input-group">
                        <span class="input-group-text">
                            <i class="bi bi-geo-alt"></i>
                        </span>
                        <input type="text" class="form-control" id="direccion" name="direccion" 
                               value="${cliente.direccion}">
                    </div>
                </div>

                <div class="row mb-3">
                    <div class="col-md-4">
                        <label for="telefono" class="form-label">Teléfono</label>
                        <div class="input-group">
                            <span class="input-group-text">
                                <i class="bi bi-telephone"></i>
                            </span>
                            <input type="text" class="form-control" id="telefono" name="telefono" 
                                   value="${cliente.telefono}" pattern="[0-9]{6,9}">
                        </div>
                    </div>
                    <div class="col-md-4">
                        <label for="movil" class="form-label">Móvil</label>
                        <div class="input-group">
                            <span class="input-group-text">
                                <i class="bi bi-phone"></i>
                            </span>
                            <input type="text" class="form-control" id="movil" name="movil" 
                                   value="${cliente.movil}" pattern="[0-9]{9}">
                        </div>
                        <small class="text-muted">Número de 9 dígitos</small>
                    </div>
                </div>

                <div class="d-grid gap-2 d-md-flex justify-content-md-end mt-4">
                    <button type="reset" class="btn btn-secondary me-md-2">
                        <i class="bi bi-arrow-clockwise me-1"></i> Restaurar
                    </button>
                    <button type="submit" class="btn btn-primary">
                        <i class="bi bi-save me-1"></i> Actualizar Cliente
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
document.addEventListener('DOMContentLoaded', function() {
    // Prevenir interacción con campos de solo lectura
    const readonlyFields = document.querySelectorAll('input[readonly]');
    readonlyFields.forEach(field => {
        field.addEventListener('focus', function(e) {
            this.blur();
        });
        field.addEventListener('click', function(e) {
            e.preventDefault();
        });
    });
    
    // Buscar DNI
    document.getElementById('buscarDni').addEventListener('click', function() {
        const dni = document.getElementById('dni').value.trim();
        
        if (dni.length !== 8) {
            alert('El DNI debe tener exactamente 8 dígitos');
            return;
        }
        
        if (!/^\d{8}$/.test(dni)) {
            alert('El DNI solo debe contener números');
            return;
        }
        
        const button = this;
        const originalText = button.innerHTML;
        
        // Mostrar loading
        button.innerHTML = '<i class="bi bi-spinner-border"></i> Buscando...';
        button.disabled = true;
        
        // Preparar datos para envío
        const formData = new FormData();
        formData.append('dni', dni);
        
        fetch('/clientes/buscar-dni', {
            method: 'POST',
            body: formData
        })
        .then(response => response.json())
        .then(data => {
            if (data.error) {
                alert('Error: ' + data.error);
            } else {
                // Autocompletar campos
                if (data.nombres) {
                    document.getElementById('nombres').value = data.nombres;
                }
                if (data.apellidoPaterno && data.apellidoMaterno) {
                    document.getElementById('apellidos').value = 
                        data.apellidoPaterno + ' ' + data.apellidoMaterno;
                } else if (data.apellidoPaterno) {
                    document.getElementById('apellidos').value = data.apellidoPaterno;
                }
                
                alert('Información encontrada y cargada automáticamente');
            }
        })
        .catch(error => {
            console.error('Error:', error);
            alert('Error de conexión. Por favor, intente nuevamente.');
        })
        .finally(() => {
            // Restaurar botón
            button.innerHTML = originalText;
            button.disabled = false;
        });
    });
    
    // Validación del formulario
    document.getElementById('formCliente').addEventListener('submit', function(e) {
        const nombres = document.getElementById('nombres').value.trim();
        const apellidos = document.getElementById('apellidos').value.trim();
        
        if (nombres === '' || apellidos === '') {
            e.preventDefault();
            alert('Los nombres y apellidos son obligatorios');
        }
    });
});
</script>
