<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="pageTitle" value="Editar Pedido" scope="request" />
<c:set var="contentPage" value="/pedidos/editar-content.jsp" scope="request" />

<!-- JS específico para edición de pedidos -->
<c:set var="additionalJS" scope="request">
    <script>
        var productos = [
            <c:forEach var="producto" items="${productos}" varStatus="status">
            {
                id: '${producto.id_prod}',
                descripcion: '${producto.descripcion}',
                precio: ${producto.precio},
                stock: ${producto.cantidad}
            }<c:if test="${!status.last}">,</c:if>
            </c:forEach>
        ];

        var detallesExistentes = [
            <c:forEach var="detalle" items="${detalles}" varStatus="status">
            {
                id_prod: '${detalle.id_prod}',
                cantidad: ${detalle.cantidad},
                precio: ${detalle.precio}
            }<c:if test="${!status.last}">,</c:if>
            </c:forEach>
        ];

        var contadorProductos = 0;

        function agregarProducto(productoId = '', cantidad = '', precio = '') {
            contadorProductos++;
            var html = `
                <tr id="producto_${contadorProductos}">
                    <td>
                        <select class="form-control producto-select" name="productos[]" onchange="actualizarPrecio(${contadorProductos})" required>
                            <option value="">Seleccione un producto</option>`;
            
            productos.forEach(function(producto) {
                var selected = (producto.id === productoId) ? 'selected' : '';
                html += `<option value="${producto.id}" data-precio="${producto.precio}" data-stock="${producto.stock}" ${selected}>
                            ${producto.descripcion} - S/ ${producto.precio.toFixed(2)}
                         </option>`;
            });
            
            html += `
                        </select>
                    </td>
                    <td>
                        <input type="number" class="form-control precio-input" name="precios[]" 
                               id="precio_${contadorProductos}" step="0.01" min="0" value="${precio}" readonly>
                    </td>
                    <td>
                        <input type="number" class="form-control cantidad-input" name="cantidades[]" 
                               id="cantidad_${contadorProductos}" min="1" value="${cantidad}" onchange="calcularSubtotal(${contadorProductos})" required>
                    </td>
                    <td>
                        <span class="badge badge-info" id="stock_${contadorProductos}">-</span>
                    </td>
                    <td>
                        <input type="text" class="form-control subtotal-input" 
                               id="subtotal_${contadorProductos}" readonly>
                    </td>
                    <td>
                        <button type="button" class="btn btn-danger btn-sm" onclick="eliminarProducto(${contadorProductos})">
                            <i class="fas fa-trash"></i>
                        </button>
                    </td>
                </tr>
            `;
            
            document.getElementById('productosBody').insertAdjacentHTML('beforeend', html);
            
            // Si se especificó un producto, actualizar el precio y stock
            if (productoId) {
                actualizarPrecio(contadorProductos);
            }
        }

        function eliminarProducto(id) {
            document.getElementById('producto_' + id).remove();
            calcularTotalGeneral();
        }

        function actualizarPrecio(id) {
            var select = document.querySelector(`#producto_${id} .producto-select`);
            var precioInput = document.getElementById('precio_' + id);
            var stockSpan = document.getElementById('stock_' + id);
            var cantidadInput = document.getElementById('cantidad_' + id);
            
            if (select.value) {
                var option = select.options[select.selectedIndex];
                var precio = parseFloat(option.dataset.precio);
                var stock = parseInt(option.dataset.stock);
                
                precioInput.value = precio.toFixed(2);
                stockSpan.textContent = stock;
                cantidadInput.max = stock;
                
                calcularSubtotal(id);
            } else {
                precioInput.value = '';
                stockSpan.textContent = '-';
                cantidadInput.max = '';
                document.getElementById('subtotal_' + id).value = '';
            }
            
            calcularTotalGeneral();
        }

        function calcularSubtotal(id) {
            var precio = parseFloat(document.getElementById('precio_' + id).value) || 0;
            var cantidad = parseInt(document.getElementById('cantidad_' + id).value) || 0;
            var stock = parseInt(document.getElementById('stock_' + id).textContent) || 0;
            
            if (cantidad > stock) {
                alert('La cantidad no puede ser mayor al stock disponible (' + stock + ')');
                document.getElementById('cantidad_' + id).value = stock;
                cantidad = stock;
            }
            
            var subtotal = precio * cantidad;
            document.getElementById('subtotal_' + id).value = 'S/ ' + subtotal.toFixed(2);
            
            calcularTotalGeneral();
        }

        function calcularTotalGeneral() {
            var subtotal = 0;
            var subtotalInputs = document.querySelectorAll('.subtotal-input');
            
            subtotalInputs.forEach(function(input) {
                if (input.value) {
                    var valor = parseFloat(input.value.replace('S/ ', '')) || 0;
                    subtotal += valor;
                }
            });
            
            var igv = subtotal * 0.18;
            var total = subtotal + igv;
            
            document.getElementById('subtotalGeneral').textContent = subtotal.toFixed(2);
            document.getElementById('igvGeneral').textContent = igv.toFixed(2);
            document.getElementById('totalGeneral').textContent = total.toFixed(2);
        }

        // Validación del formulario
        document.getElementById('formPedido').addEventListener('submit', function(e) {
            var productosBody = document.getElementById('productosBody');
            if (productosBody.children.length === 0) {
                e.preventDefault();
                alert('Debe agregar al menos un producto al pedido');
                return false;
            }
            
            var cliente = document.getElementById('id_cliente').value;
            if (!cliente) {
                e.preventDefault();
                alert('Debe seleccionar un cliente');
                return false;
            }
            
            return true;
        });

        // Cargar productos existentes al cargar la página
        document.addEventListener('DOMContentLoaded', function() {
            // Cargar detalles existentes
            detallesExistentes.forEach(function(detalle) {
                agregarProducto(detalle.id_prod, detalle.cantidad, detalle.precio);
            });
            
            // Si no hay detalles existentes, agregar una fila vacía
            if (detallesExistentes.length === 0) {
                agregarProducto();
            }
            
            // Calcular total inicial
            calcularTotalGeneral();
        });
    </script>
</c:set>

<jsp:include page="/layout.jsp" />
