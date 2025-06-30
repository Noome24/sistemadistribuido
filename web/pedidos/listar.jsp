<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="Lista de Pedidos" scope="request" />
<c:set var="contentPage" value="/pedidos/listar-content.jsp" scope="request" />

<!-- CSS adicional para DataTables -->
<c:set var="additionalCSS" scope="request">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.4/css/dataTables.bootstrap4.min.css">
</c:set>

<!-- JS adicional para DataTables -->
<c:set var="additionalJS" scope="request">
    <script src="https://cdn.datatables.net/1.13.4/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.4/js/dataTables.bootstrap4.min.js"></script>
    <script>
        $(document).ready(function() {
            $('#pedidosTable').DataTable({
                "language": {
                    "url": "//cdn.datatables.net/plug-ins/1.13.4/i18n/es-ES.json"
                },
                "order": [[ 2, "desc" ]], // Ordenar por fecha descendente
                "pageLength": 25,
                "responsive": true
            });
        });

        function confirmarEliminar(id) {
            if (confirm('¿Está seguro de que desea eliminar este pedido? Esta acción no se puede deshacer.')) {
                window.location.href = '${pageContext.request.contextPath}/pedidos/eliminar/' + id;
            }
        }
    </script>
</c:set>

<jsp:include page="/layout.jsp" />
