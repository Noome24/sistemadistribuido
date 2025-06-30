<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<div class="container-fluid">
    <div class="page-header mb-3">
        <h1 class="page-title">
            <i class="fas fa-user-plus me-3"></i>
            Agregar Nuevo Cliente
        </h1>
        <a href="${pageContext.request.contextPath}/clientes/listar.jsp" class="btn btn-secondary btn-modern ms-3">
            <i class="fas fa-arrow-left me-2"></i>Volver
        </a>
    </div>
    
    <div class="card card-modern">
        <div class="card-header">
            <h6 class="card-title">
                <i class="fas fa-user-edit me-2"></i>Datos del Cliente
            </h6>
        </div>
        <div class="card-body">
            <form action="${pageContext.request.contextPath}/api/clientes/guardar" method="post" id="formCliente">
                <!-- Selector de tipo de documento -->
                <div class="form-section mb-3">
                    <label class="form-label">Tipo de Documento:</label>
                    <div class="btn-group" role="group">
                        <input type="radio" class="btn-check" name="tipoDocumento" id="tipoDni" value="dni" checked>
                        <label class="btn btn-outline-primary" for="tipoDni">
                            <i class="fas fa-id-card me-2"></i>DNI
                        </label>
                        
                        <input type="radio" class="btn-check" name="tipoDocumento" id="tipoRuc" value="ruc">
                        <label class="btn btn-outline-success" for="tipoRuc">
                            <i class="fas fa-building me-2"></i>RUC
                        </label>
                    </div>
                </div>
                
                <!-- Campo DNI -->
                <div class="form-group mb-3" id="dniSection">
                    <label for="dni" class="form-label">DNI</label>
                    <div class="input-group input-group-modern">
                        <span class="input-group-text"><i class="fas fa-id-card"></i></span>
                        <input type="text" class="form-control" id="dni" name="dni" maxlength="8" 
                               placeholder="Ingrese DNI de 8 dígitos" pattern="[0-9]{8}">
                        <button class="btn btn-outline-secondary" type="button" id="buscarDni">
                            <i class="fas fa-search"></i> Buscar
                        </button>
                    </div>
                    <small class="text-muted">Documento de identidad de 8 dígitos</small>
                </div>

                <!-- Campo RUC -->
                <div class="form-group mb-3" id="rucSection" style="display: none;">
                    <label for="ruc" class="form-label">RUC</label>
                    <div class="input-group input-group-modern">
                        <span class="input-group-text"><i class="fas fa-building"></i></span>
                        <input type="text" class="form-control" id="ruc" name="ruc" maxlength="11" 
                               placeholder="Ingrese RUC de 11 dígitos" pattern="[0-9]{11}">
                        <button class="btn btn-outline-secondary" type="button" id="buscarRuc">
                            <i class="fas fa-search"></i> Buscar
                        </button>
                    </div>
                    <small class="text-muted">Registro Único de Contribuyentes de 11 dígitos</small>
                </div>
                
                <div class="row">
                    <div class="col-md-6">
                        <div class="form-group mb-3">
                            <label for="nombres" class="form-label">Nombres / Razón Social <span class="text-danger">*</span></label>
                            <div class="input-group input-group-modern">
                                <span class="input-group-text"><i class="fas fa-user"></i></span>
                                <input type="text" class="form-control" id="nombres" name="nombres" required>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group mb-3">
                            <label for="apellidos" class="form-label">Apellidos</label>
                            <div class="input-group input-group-modern">
                                <span class="input-group-text"><i class="fas fa-user"></i></span>
                                <input type="text" class="form-control" id="apellidos" name="apellidos">
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="form-group mb-3">
                    <label for="direccion" class="form-label">Dirección</label>
                    <div class="input-group input-group-modern">
                        <span class="input-group-text"><i class="fas fa-map-marker-alt"></i></span>
                        <input type="text" class="form-control" id="direccion" name="direccion">
                    </div>
                </div>
                
                <div class="row">
                    <div class="col-md-4">
                        <div class="form-group mb-3">
                            <label for="telefono" class="form-label">Teléfono</label>
                            <div class="input-group input-group-modern">
                                <span class="input-group-text"><i class="fas fa-phone"></i></span>
                                <input type="text" class="form-control" id="telefono" name="telefono">
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="form-group mb-3">
                            <label for="movil" class="form-label">Móvil</label>
                            <div class="input-group input-group-modern">
                                <span class="input-group-text"><i class="fas fa-mobile-alt"></i></span>
                                <input type="text" class="form-control" id="movil" name="movil">
                            </div>
                        </div>
                    </div>
                    
                </div>
                
                <div class="form-actions mt-3">
                    <button type="reset" class="btn btn-secondary btn-modern">
                        <i class="fas fa-broom me-2"></i>Limpiar
                    </button>
                    <button type="submit" class="btn btn-primary btn-modern">
                        <i class="fas fa-save me-2"></i>Guardar
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
document.addEventListener('DOMContentLoaded', function() {
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
        button.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Buscando...';
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
                
                // Mostrar mensaje de éxito
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
        
        if (nombres === '') {
            e.preventDefault();
            alert('El campo Nombres/Razón Social es obligatorio');
            return;
        }
    });
});
</script>
