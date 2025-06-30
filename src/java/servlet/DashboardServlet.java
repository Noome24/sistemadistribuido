package servlet;

import dao.ClienteDAO;
import dao.ProductoDAO;
import dao.PedidoDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.math.BigDecimal;

import com.google.gson.Gson;

@WebServlet("/api/dashboard")
public class DashboardServlet extends HttpServlet {
    private final ClienteDAO clienteDAO = new ClienteDAO();
    private final ProductoDAO productoDAO = new ProductoDAO();
    private final PedidoDAO pedidoDAO = new PedidoDAO();
    private final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        // Verificar autenticación
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            // Si es una petición AJAX, devolver JSON de error
            String acceptHeader = request.getHeader("Accept");
            if (acceptHeader != null && acceptHeader.contains("application/json")) {
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                Map<String, String> error = new HashMap<>();
                error.put("error", "Sesión expirada");
                error.put("redirect", request.getContextPath() + "/login");
                response.getWriter().write(gson.toJson(error));
            } else {
                // Si es una petición normal, redirigir al login
                response.sendRedirect(request.getContextPath() + "/login");
            }
            return;
        }

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            // Obtener estadísticas del dashboard
            Map<String, Object> dashboard = new HashMap<>();
            
            // Contadores
            dashboard.put("totalClientes", clienteDAO.contarClientes());
            dashboard.put("totalProductos", productoDAO.contarProductos());
            dashboard.put("totalPedidos", pedidoDAO.contarPedidos());
            
            // Ventas
            dashboard.put("ventasHoy", pedidoDAO.obtenerVentasHoy());
            dashboard.put("ventasMes", pedidoDAO.obtenerVentasMes());
            
            // Productos con bajo stock
            dashboard.put("productosBajoStock", productoDAO.obtenerProductosBajoStock());
            
            response.getWriter().write(gson.toJson(dashboard));
            
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            Map<String, String> error = new HashMap<>();
            error.put("error", "Error interno del servidor: " + e.getMessage());
            response.getWriter().write(gson.toJson(error));
        }
    }
}
