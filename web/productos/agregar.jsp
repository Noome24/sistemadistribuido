<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="pageTitle" value="Agregar Producto - SisGestión" scope="request" />
<c:set var="contentPage" value="/productos/agregar-content.jsp" scope="request" />

<!-- JS específico para calculadora de ganancias -->
<c:set var="additionalJS" scope="request">
    <script>
        // Calculadora de ganancias
        function calcularGanancias() {
            const costo = parseFloat(document.getElementById('costo').value) || 0;
            const precio = parseFloat(document.getElementById('precio').value) || 0;
            
            const ganancia = precio - costo;
            const margen = precio > 0 ? (ganancia / precio) * 100 : 0;
            const markup = costo > 0 ? (ganancia / costo) * 100 : 0;
            
            document.getElementById('gananciaBruta').textContent = 'S/ ' + ganancia.toFixed(2);
            document.getElementById('margenGanancia').textContent = margen.toFixed(1) + '%';
            document.getElementById('markup').textContent = markup.toFixed(1) + '%';
            
            // Cambiar colores según la ganancia
            const gananciaBrutaEl = document.getElementById('gananciaBruta');
            if (ganancia > 0) {
                gananciaBrutaEl.className = 'profit-indicator text-success';
            } else if (ganancia < 0) {
                gananciaBrutaEl.className = 'profit-indicator text-danger';
            } else {
                gananciaBrutaEl.className = 'profit-indicator text-muted';
            }
        }
        
        // Calcular precio sugerido
        function calcularPrecioSugerido() {
            const costo = parseFloat(document.getElementById('costo').value) || 0;
            const precioSugerido = costo * 1.3; // 30% de ganancia
            document.getElementById('precioSugerido').value = precioSugerido.toFixed(2);
        }
        
        // Event listeners
        document.addEventListener('DOMContentLoaded', function() {
            document.getElementById('costo').addEventListener('input', function() {
                calcularGanancias();
                calcularPrecioSugerido();
            });
            
            document.getElementById('precio').addEventListener('input', calcularGanancias);
            
            document.getElementById('aplicarSugerido').addEventListener('click', function() {
                const precioSugerido = document.getElementById('precioSugerido').value;
                if (precioSugerido) {
                    document.getElementById('precio').value = precioSugerido;
                    calcularGanancias();
                }
            });
            
            // Validación del formulario
            document.getElementById('productoForm').addEventListener('submit', function(e) {
                const costo = parseFloat(document.getElementById('costo').value) || 0;
                const precio = parseFloat(document.getElementById('precio').value) || 0;
                
                if (precio <= costo) {
                    e.preventDefault();
                    alert('El precio de venta debe ser mayor al costo del producto.');
                    return false;
                }
            });
        });
    </script>
</c:set>

<jsp:include page="/layout.jsp" />
