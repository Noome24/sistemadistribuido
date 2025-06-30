<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle} - SisGestión</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <!-- DataTables CSS -->
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.4/css/dataTables.bootstrap5.min.css">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <!-- Sistema Styles -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sistema-styles.css">
    
    <!-- Additional CSS if needed -->
    <c:if test="${not empty additionalCSS}">
        ${additionalCSS}
    </c:if>
</head>
<body>
    <!-- Include Sidebar -->
    <jsp:include page="/components/sidebar.jsp" />

    <!-- Main Content -->
    <div class="content" id="content">
        <!-- Include Navbar -->
        <jsp:include page="/components/navbar.jsp" />

        <!-- Page Content -->
        <div class="container-fluid">
            <!-- Include the specific page content -->
            <jsp:include page="${contentPage}" />
        </div>
    </div>

    <!-- Include Timer -->
    <jsp:include page="/components/temporizador.jsp" />

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <!-- DataTables JS -->
    <script src="https://cdn.datatables.net/1.13.4/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.4/js/dataTables.bootstrap5.min.js"></script>
    <!-- Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    
    <!-- Common Scripts -->
    <script>
        // Sidebar Toggle
        document.addEventListener('DOMContentLoaded', function() {
            const sidebarToggle = document.getElementById('sidebarToggle');
            if (sidebarToggle) {
                sidebarToggle.addEventListener('click', function() {
                    document.querySelector('.sidebar').classList.toggle('active');
                    document.querySelector('.content').classList.toggle('active');
                });
            }
        });
    </script>
    
    <!-- Additional JavaScript if needed -->
    <c:if test="${not empty additionalJS}">
        ${additionalJS}
    </c:if>
</body>
</html>
