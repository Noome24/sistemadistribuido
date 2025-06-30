package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.RequestDispatcher;
import java.io.IOException;

@WebServlet("/api/content/*")
public class ContentServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String pathInfo = request.getPathInfo();
        if (pathInfo == null || pathInfo.equals("/")) {
            pathInfo = "/dashboard";
        }
        
        // Remove leading slash
        if (pathInfo.startsWith("/")) {
            pathInfo = pathInfo.substring(1);
        }
        
        String contentPage = getContentPage(pathInfo);
        
        if (contentPage != null) {
            // Set content type for HTML response
            response.setContentType("text/html;charset=UTF-8");
            
            // Forward to the appropriate content page
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/" + contentPage);
            if (dispatcher != null) {
                dispatcher.forward(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Página no encontrada");
            }
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Página no encontrada");
        }
    }
    
    private String getContentPage(String path) {
        switch (path) {
            case "dashboard":
                return "dashboard-content.jsp";
            
            // Clientes
            case "clientes/index":
                return "clientes/index-content.jsp";
            case "clientes/listar":
                return "clientes/listar-content.jsp";
            case "clientes/agregar":
                return "clientes/agregar-content.jsp";
            case "clientes/editar":
                return "clientes/editar-content.jsp";
            
            // Productos
            case "productos/index":
                return "productos/index-content.jsp";
            case "productos/listar":
                return "productos/listar-content.jsp";
            case "productos/agregar":
                return "productos/agregar-content.jsp";
            case "productos/editar":
                return "productos/editar-content.jsp";
            
            // Pedidos
            case "pedidos/index":
                return "pedidos/index-content.jsp";
            case "pedidos/listar":
                return "pedidos/listar-content.jsp";
            case "pedidos/agregar":
                return "pedidos/agregar-content.jsp";
            case "pedidos/editar":
                return "pedidos/editar-content.jsp";
            case "pedidos/detalles":
                return "pedidos/detalles-content.jsp";
            
            // Usuarios
            case "usuarios/index":
                return "usuarios/index-content.jsp";
            case "usuarios/listar":
                return "usuarios/listar-content.jsp";
            case "usuarios/agregar":
                return "usuarios/agregar-content.jsp";
            case "usuarios/editar":
                return "usuarios/editar-content.jsp";
            
            default:
                return null;
        }
    }
}
