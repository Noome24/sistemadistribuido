<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="pageTitle" value="Listar Productos - SisGestión" scope="request" />
<c:set var="contentPage" value="/productos/listar-content.jsp" scope="request" />

<!-- CSS adicional para DataTables -->
<c:set var="additionalCSS" scope="request">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.4/css/dataTables.bootstrap5.min.css">
</c:set>

<!-- JS adicional para DataTables -->
<c:set var="additionalJS" scope="request">
    <script src="https://cdn.datatables.net/1.13.4/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.4/js/dataTables.bootstrap5.min.js"></script>
    <script>
        $(document).ready(function() {
            $('#productosTable').DataTable({
                language: {
                    url: '//cdn.datatables.net/plug-ins/1.13.4/i18n/es-ES.json'
                },
                responsive: true,
                initComplete: function() {
                    $('.dataTables_filter').addClass('mx-2 mt-3 mb-2');
                    $('.dataTables_length').addClass('mx-2 mt-3 mb-2');
                    $('.dataTables_paginate').addClass('mx-2 mb-3');
                    $('.dataTables_info').addClass('mx-2 mb-3');
                }
            });
        });
    </script>
</c:set>

<jsp:include page="/layout.jsp" />
