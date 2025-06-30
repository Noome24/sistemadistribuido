<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="d-flex justify-content-between align-items-center mb-4">
    <h1>Agregar Nuevo Producto</h1>
    <a href="${pageContext.request.contextPath}/productos/listar" class="btn btn-secondary">
        <i class="bi bi-arrow-left"></i> Volver al Listado
    </a>
</div>

<!-- Solo mostrar alertas si tienen contenido -->
<c:if test="${not empty error and error != ''}">
    <div class="alert alert-danger alert-dismissible fade show" role="alert">
        <i class="bi bi-exclamation-circle me-2"></i> ${error}
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
    <c:remove var="error" scope="session" />
</c:if>

<c:if test="${not empty success and success != ''}">
    <div class="alert alert-success alert-dismissible fade show" role="alert">
        <i class="bi bi-check-circle me-2"></i> ${success}
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
    <c:remove var="success" scope="session" />
</c:if>

<div class="row">
    <div class="col-lg-8">
        <div class="card shadow mb-4">
            <div class="card-header py-3">
                <h6 class="m-0 font-weight-bold text-primary">Información del Producto</h6>
            </div>
            <div class="card-body">
                <form action="${pageContext.request.contextPath}/productos/guardar" method="post" id="productoForm">
                    <div class="row">
                        <div class="col-md-12">
                            <div class="mb-3">
                                <label for="descripcion" class="form-label">Descripción del Producto <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" id="descripcion" name="descripcion" required>
                                <div class="form-text">Ingrese una descripción clara y detallada del producto</div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="row">
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="costo" class="form-label">Costo <span class="text-danger">*</span></label>
                                <div class="input-group">
                                    <span class="input-group-text">S/</span>
                                    <input type="number" class="form-control" id="costo" name="costo" step="0.01" min="0" required>
                                </div>
                                <div class="form-text">El valor que te cuesta adquirir o fabricar el producto</div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="precio" class="form-label">Precio de Venta <span class="text-danger">*</span></label>
                                <div class="input-group">
                                    <span class="input-group-text">S/</span>
                                    <input type="number" class="form-control" id="precio" name="precio" step="0.01" min="0" required>
                                </div>
                                <div class="form-text">El valor al que vendes el producto al cliente</div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="row">
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="cantidad" class="form-label">Stock Inicial <span class="text-danger">*</span></label>
                                <input type="number" class="form-control" id="cantidad" name="cantidad" min="0" required>
                                <div class="form-text">Cantidad inicial en inventario</div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label class="form-label">Precio Sugerido</label>
                                <div class="input-group">
                                    <span class="input-group-text">S/</span>
                                    <input type="text" class="form-control" id="precioSugerido" readonly>
                                    <button class="btn btn-outline-secondary" type="button" id="aplicarSugerido">
                                        <i class="bi bi-magic"></i> Aplicar
                                    </button>
                                </div>
                                <div class="form-text">Precio sugerido con 30% de ganancia</div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="d-flex justify-content-between">
                        <a href="${pageContext.request.contextPath}/productos/listar" class="btn btn-secondary">
                            <i class="bi bi-x"></i> Cancelar
                        </a>
                        <button type="submit" class="btn btn-primary">
                            <i class="bi bi-save"></i> Guardar Producto
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <div class="col-lg-4">
        <div class="calculator-card">
            <h6 class="text-primary mb-3">
                <i class="bi bi-calculator"></i> Calculadora de Ganancias
            </h6>
            
            <div class="mb-3">
                <label class="form-label">Ganancia Bruta</label>
                <div class="profit-indicator text-success" id="gananciaBruta">S/ 0.00</div>
            </div>
            
            <div class="mb-3">
                <label class="form-label">Margen de Ganancia</label>
                <div class="profit-indicator text-info" id="margenGanancia">0%</div>
            </div>
            
            <div class="mb-3">
                <label class="form-label">Markup</label>
                <div class="profit-indicator text-warning" id="markup">0%</div>
            </div>
            
            <hr>
            
            <div class="mb-2">
                <small class="text-muted">
                    <strong>Ganancia Bruta:</strong> Precio - Costo<br>
                    <strong>Margen:</strong> (Ganancia / Precio) × 100<br>
                    <strong>Markup:</strong> (Ganancia / Costo) × 100
                </small>
            </div>
        </div>
    </div>
</div>

<style>
.calculator-card {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    color: white;
    padding: 20px;
    border-radius: 15px;
    box-shadow: 0 4px 20px rgba(0,0,0,0.1);
}

.profit-indicator {
    font-size: 1.5rem;
    font-weight: bold;
    padding: 10px;
    background: rgba(255,255,255,0.1);
    border-radius: 8px;
    text-align: center;
}
</style>

<script>
document.addEventListener('DOMContentLoaded', function() {
    const costoInput = document.getElementById('costo');
    const precioInput = document.getElementById('precio');
    const precioSugeridoInput = document.getElementById('precioSugerido');
    const aplicarBtn = document.getElementById('aplicarSugerido');
    
    function calcularGanancias() {
        const costo = parseFloat(costoInput.value) || 0;
        const precio = parseFloat(precioInput.value) || 0;
        
        const ganancia = precio - costo;
        const margen = precio > 0 ? (ganancia / precio) * 100 : 0;
        const markup = costo > 0 ? (ganancia / costo) * 100 : 0;
        
        document.getElementById('gananciaBruta').textContent = 'S/ ' + ganancia.toFixed(2);
        document.getElementById('margenGanancia').textContent = margen.toFixed(1) + '%';
        document.getElementById('markup').textContent = markup.toFixed(1) + '%';
        
        // Cambiar colores según rentabilidad
        const gananciaBrutaEl = document.getElementById('gananciaBruta');
        if (ganancia > 0) {
            gananciaBrutaEl.className = 'profit-indicator text-success';
        } else if (ganancia < 0) {
            gananciaBrutaEl.className = 'profit-indicator text-danger';
        } else {
            gananciaBrutaEl.className = 'profit-indicator text-warning';
        }
    }
    
    function calcularPrecioSugerido() {
        const costo = parseFloat(costoInput.value) || 0;
        const precioSugerido = costo * 1.3; // 30% de ganancia
        precioSugeridoInput.value = precioSugerido.toFixed(2);
    }
    
    costoInput.addEventListener('input', function() {
        calcularGanancias();
        calcularPrecioSugerido();
    });
    
    precioInput.addEventListener('input', calcularGanancias);
    
    aplicarBtn.addEventListener('click', function() {
        const precioSugerido = precioSugeridoInput.value;
        if (precioSugerido) {
            precioInput.value = precioSugerido;
            calcularGanancias();
            
            // Toast notification
            const toast = document.createElement('div');
            toast.className = 'toast-notification';
            toast.textContent = '¡Precio sugerido aplicado!';
            document.body.appendChild(toast);
            
            setTimeout(() => {
                toast.remove();
            }, 3000);
        }
    });
});
</script>

<style>
.toast-notification {
    position: fixed;
    top: 20px;
    right: 20px;
    background: #28a745;
    color: white;
    padding: 10px 20px;
    border-radius: 5px;
    z-index: 9999;
    animation: slideIn 0.3s ease;
}

@keyframes slideIn {
    from { transform: translateX(100%); }
    to { transform: translateX(0); }
}
</style>
