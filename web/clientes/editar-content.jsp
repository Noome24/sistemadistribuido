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
                </div>

                <!-- Selector de tipo de documento -->
                <div class="form-section mb-3">
                    <label class="form-label">Tipo de Documento:</label>
                    <div class="btn-group" role="group">
                        <input type="radio" class="btn-check" name="tipoDocumento" id="tipoDni" value="dni" checked>
                        <label class="btn btn-outline-primary" for="tipoDni">
                            <i class="bi bi-person-vcard me-2"></i>DNI
                        </label>
                        
                        <input type="radio" class="btn-check" name="tipoDocumento" id="tipoRuc" value="ruc">
                        <label class="btn btn-outline-success" for="tipoRuc">
                            <i class="bi bi-building me-2"></i>RUC
                        </label>
                    </div>
                </div>

                <!-- Campo DNI -->
                <div class="form-group mb-3" id="dniSection">
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

                <!-- Campo RUC -->
                <div class="form-group mb-3" id="rucSection" style="display: none;">
                    <label for="ruc" class="form-label">RUC</label>
                    <div class="input-group">
                        <span class="input-group-text">
                            <i class="bi bi-building"></i>
                        </span>
                        <input type="text" class="form-control" id="ruc" name="ruc" 
                               maxlength="11" pattern="[0-9]{11}" placeholder="Ingrese RUC de 11 dígitos">
                        <button class="btn btn-outline-secondary" type="button" id="buscarRuc">
                            <i class="bi bi-search"></i> Buscar
                        </button>
                    </div>
                    <small class="text-muted">Registro Único de Contribuyentes (11 dígitos)</small>
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
    
    // Manejar cambio de tipo de documento
    const tipoDni = document.getElementById('tipoDni');
    const tipoRuc = document.getElementById('tipoRuc');
    const dniSection = document.getElementById('dniSection');
    const rucSection = document.getElementById('rucSection');
    
    tipoDni.addEventListener('change', function() {
        if (this.checked) {
            dniSection.style.display = 'block';
            rucSection.style.display = 'none';
            document.getElementById('ruc').value = '';
        }
    });
    
    tipoRuc.addEventListener('change', function() {
        if (this.checked) {
            dniSection.style.display = 'none';
            rucSection.style.display = 'block';
            document.getElementById('dni').value = '';
        }
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
        
        buscarDocumento('dni', dni);
    });
    
    // Buscar RUC
    document.getElementById('buscarRuc').addEventListener('click', function() {
        const ruc = document.getElementById('ruc').value.trim();
        
        if (ruc.length !== 11) {
            alert('El RUC debe tener exactamente 11 dígitos');
            return;
        }
        
        if (!/^\d{11}$/.test(ruc)) {
            alert('El RUC solo debe contener números');
            return;
        }
        
        buscarDocumento('ruc', ruc);
    });
    
    function buscarDocumento(tipo, numero) {
        const button = document.getElementById('buscar' + tipo.charAt(0).toUpperCase() + tipo.slice(1));
        const originalText = button.innerHTML;
        
        // Mostrar loading
        button.innerHTML = '<i class="bi bi-arrow-repeat"></i> Buscando...';
        button.disabled = true;
        
        // Construir URL correcta
        const contextPath = '${pageContext.request.contextPath}';
        const apiUrl = contextPath + '/api/consulta/' + tipo + '/' + numero;
        
        console.log('Consultando URL:', apiUrl); // Para debug
        
        fetch(apiUrl, {
            method: 'GET',
            headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json'
            }
        })
        .then(response => {
            console.log('Response status:', response.status); // Para debug
            return response.json();
        })
        .then(data => {
            console.log('Response data:', data); // Para debug
            
            if (data.success && data.data) {
                // Autocompletar campos según el tipo
                if (tipo === 'dni') {
                    if (data.data.nombres) {
                        document.getElementById('nombres').value = data.data.nombres;
                    }
                    if (data.data.apellidoPaterno && data.data.apellidoMaterno) {
                        document.getElementById('apellidos').value = 
                            data.data.apellidoPaterno + ' ' + data.data.apellidoMaterno;
                    } else if (data.data.apellidoPaterno) {
                        document.getElementById('apellidos').value = data.data.apellidoPaterno;
                    }
                } else if (tipo === 'ruc') {
                    if (data.data.razonSocial) {
                        document.getElementById('nombres').value = data.data.razonSocial;
                    }
                    if (data.data.direccion && data.data.direccion !== '-') {
                        document.getElementById('direccion').value = data.data.direccion;
                    }
                    // Para RUC, limpiar apellidos ya que es razón social
                    document.getElementById('apellidos').value = '';
                }
                
                alert('Información encontrada y cargada automáticamente');
            } else {
                alert('Error: ' + (data.error || 'No se encontraron datos'));
            }
        })
        .catch(error => {
            console.error('Error completo:', error); // Para debug
            alert('Error de conexión. Por favor, intente nuevamente.');
        })
        .finally(() => {
            // Restaurar botón
            button.innerHTML = originalText;
            button.disabled = false;
        });
    }
    
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
