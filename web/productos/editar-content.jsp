<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<div class="container-fluid">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1>
            <i class="bi bi-box me-2 text-warning"></i>Editar Producto
        </h1>
        <a href="${pageContext.request.contextPath}/productos/listar" class="btn btn-secondary">
            <i class="bi bi-arrow-left me-1"></i> Volver
        </a>
    </div>

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

    <div class="card shadow mb-4">
        <div class="card-header py-3 bg-light">
            <h6 class="m-0 font-weight-bold text-primary">
                <i class="bi bi-info-circle me-1"></i>Datos del Producto
            </h6>
        </div>
        <div class="card-body">
            <c:choose>
                <c:when test="${not empty producto}">
                    <form action="${pageContext.request.contextPath}/productos/actualizar" method="post" id="formProducto">
                        <input type="hidden" name="id_prod" value="${producto.id_prod}">
                        
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="id_prod_display" class="form-label">ID Producto</label>
                                <div class="input-group">
                                    <span class="input-group-text bg-light">
                                        <i class="bi bi-upc-scan"></i>
                                    </span>
                                    <input type="text" class="form-control bg-light" id="id_prod_display" 
                                           value="${producto.id_prod}" readonly tabindex="-1" 
                                           aria-readonly="true" style="pointer-events: none;">
                                </div>
                            </div>
                            <div class="col-md-6">
                                <label for="descripcion" class="form-label">Descripción <span class="text-danger">*</span></label>
                                <div class="input-group">
                                    <span class="input-group-text">
                                        <i class="bi bi-card-text"></i>
                                    </span>
                                    <input type="text" class="form-control" id="descripcion" name="descripcion" 
                                           value="${producto.descripcion}" required>
                                </div>
                            </div>
                        </div>

                        <div class="row mb-3">
                            <div class="col-md-4">
                                <label for="costo" class="form-label">Costo <span class="text-danger">*</span></label>
                                <div class="input-group">
                                    <span class="input-group-text">S/</span>
                                    <input type="number" class="form-control" id="costo" name="costo" 
                                           value="${producto.costo}" step="0.01" min="0" required>
                                </div>
                                <small class="text-muted">Valor de adquisición o fabricación</small>
                            </div>
                            <div class="col-md-4">
                                <label for="precio" class="form-label">Precio de Venta <span class="text-danger">*</span></label>
                                <div class="input-group">
                                    <span class="input-group-text">S/</span>
                                    <input type="number" class="form-control" id="precio" name="precio" 
                                           value="${producto.precio}" step="0.01" min="0" required>
                                </div>
                                <small class="text-muted">Precio final al cliente</small>
                            </div>
                            <div class="col-md-4">
                                <label for="cantidad" class="form-label">Stock <span class="text-danger">*</span></label>
                                <div class="input-group">
                                    <span class="input-group-text">
                                        <i class="bi bi-boxes"></i>
                                    </span>
                                    <input type="number" class="form-control" id="cantidad" name="cantidad" 
                                           value="${producto.cantidad}" min="0" required>
                                </div>
                                <small class="text-muted">Cantidad disponible en inventario</small>
                            </div>
                        </div>
                        
                        <!-- Calculadora de Ganancias -->
                        <div class="card bg-light mb-3">
                            <div class="card-header">
                                <i class="bi bi-calculator me-1"></i>Calculadora de Ganancias
                            </div>
                            <div class="card-body">
                                <div class="row">
                                    <div class="col-md-4">
                                        <label class="form-label">Ganancia Bruta</label>
                                        <div class="input-group">
                                            <span class="input-group-text">S/</span>
                                            <input type="text" class="form-control bg-light" id="ganancia" 
                                                   readonly tabindex="-1" aria-readonly="true">
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                        <label class="form-label">Margen de Ganancia</label>
                                        <div class="input-group">
                                            <input type="text" class="form-control bg-light" id="margen" 
                                                   readonly tabindex="-1" aria-readonly="true">
                                            <span class="input-group-text">%</span>
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                        <label class="form-label">Precio Sugerido (+30%)</label>
                                        <div class="input-group">
                                            <span class="input-group-text">S/</span>
                                            <input type="text" class="form-control bg-light" id="precioSugerido" 
                                                   readonly tabindex="-1" aria-readonly="true">
                                            <button class="btn btn-outline-secondary" type="button" id="aplicarSugerido">
                                                <i class="bi bi-check-lg"></i> Aplicar
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="d-grid gap-2 d-md-flex justify-content-md-end mt-4">
                            <button type="reset" class="btn btn-secondary me-md-2">
                                <i class="bi bi-arrow-clockwise me-1"></i> Restaurar
                            </button>
                            <button type="submit" class="btn btn-primary">
                                <i class="bi bi-save me-1"></i> Actualizar Producto
                            </button>
                        </div>
                    </form>
                </c:when>
                <c:otherwise>
                    <div class="text-center py-4">
                        <i class="bi bi-exclamation-triangle fa-3x text-warning mb-3"></i>
                        <h5 class="text-muted">Producto no encontrado</h5>
                        <p class="text-muted">El producto que intenta editar no existe o ha sido eliminado</p>
                        <a href="${pageContext.request.contextPath}/productos/listar" class="btn btn-primary">
                            <i class="bi bi-arrow-left me-2"></i>Volver al Listado
                        </a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<script>
document.addEventListener('DOMContentLoaded', function() {
    // Solo ejecutar si existe el producto
    if (document.getElementById('costo')) {
        // Calcular valores iniciales
        calcularGanancias();
        calcularPrecioSugerido();
        
        // Eventos para recalcular
        document.getElementById('costo').addEventListener('input', function() {
            calcularGanancias();
            calcularPrecioSugerido();
        });
        document.getElementById('precio').addEventListener('input', calcularGanancias);
        
        // Aplicar precio sugerido
        document.getElementById('aplicarSugerido').addEventListener('click', function() {
            const precioSugerido = document.getElementById('precioSugerido').value;
            if (precioSugerido) {
                document.getElementById('precio').value = precioSugerido;
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
    }
});

function calcularGanancias() {
    const costo = parseFloat(document.getElementById('costo').value) || 0;
    const precio = parseFloat(document.getElementById('precio').value) || 0;
    
    const ganancia = precio - costo;
    const margen = precio > 0 ? (ganancia / precio) * 100 : 0;
    
    document.getElementById('ganancia').value = ganancia.toFixed(2);
    document.getElementById('margen').value = margen.toFixed(2);
}

function calcularPrecioSugerido() {
    const costo = parseFloat(document.getElementById('costo').value) || 0;
    const precioSugerido = costo * 1.3; // 30% de margen
    
    document.getElementById('precioSugerido').value = precioSugerido.toFixed(2);
}
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
