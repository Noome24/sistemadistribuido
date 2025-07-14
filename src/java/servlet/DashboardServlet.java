package servlet;

import dao.ClienteDAO;
import dao.ProductoDAO;
import dao.PedidoDAO;
import modelo.Producto;
import modelo.Cliente;
import modelo.Pedido;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.List;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.stream.Collectors;

import com.google.gson.Gson;

@WebServlet(urlPatterns = {"/dashboard.jsp", "/api/dashboard"})
public class DashboardServlet extends HttpServlet {
    private final ClienteDAO clienteDAO = new ClienteDAO();
    private final ProductoDAO productoDAO = new ProductoDAO();
    private final PedidoDAO pedidoDAO = new PedidoDAO();
    private final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        // Verificar autenticación
        HttpSession session = request.getSession(false);
        if (session == null || (session.getAttribute("usuario") == null && session.getAttribute("cliente") == null)) {
            if (request.getServletPath().equals("/api/dashboard")) {
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                Map<String, String> error = new HashMap<>();
                error.put("error", "Sesión expirada");
                error.put("redirect", request.getContextPath() + "/login");
                response.getWriter().write(gson.toJson(error));
                return;
            } else {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }
        }

        if (request.getServletPath().equals("/api/dashboard")) {
            handleApiRequest(request, response);
        } else {
            handlePageRequest(request, response);
        }
    }

    private void handleApiRequest(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            String action = request.getParameter("action");
            
            if ("chartData".equals(action)) {
                Map<String, Object> chartData = getChartData();
                response.getWriter().write(gson.toJson(chartData));
            } else {
                Map<String, Object> dashboard = getDashboardDataOptimized();
                response.getWriter().write(gson.toJson(dashboard));
            }
            
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            Map<String, String> error = new HashMap<>();
            error.put("error", "Error interno del servidor: " + e.getMessage());
            response.getWriter().write(gson.toJson(error));
        }
    }

    private void handlePageRequest(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        try {
            request.setAttribute("pageTitle", "Dashboard");
            request.setAttribute("contentPage", "/dashboard-content.jsp");
            
            request.getRequestDispatcher("/layout.jsp").forward(request, response);
            
        } catch (Exception e) {
            if (!response.isCommitted()) {
                request.setAttribute("error", "Error al cargar el dashboard: " + e.getMessage());
                request.getRequestDispatcher("/layout.jsp").forward(request, response);
            }
        }
    }

    private Map<String, Object> getDashboardDataOptimized() {
        Map<String, Object> dashboard = new HashMap<>();
        
        try {
            // Contadores básicos
            Integer totalClientes = clienteDAO.contarClientes();
            Integer totalProductos = productoDAO.contarProductos();
            Integer totalPedidos = pedidoDAO.contarPedidos();
            
            dashboard.put("totalClientes", totalClientes);
            dashboard.put("totalProductos", totalProductos);
            dashboard.put("totalPedidos", totalPedidos);
            
            // Ventas básicas
            BigDecimal ventasMes = pedidoDAO.obtenerVentasMes();
            BigDecimal ventasHoy = pedidoDAO.obtenerVentasHoy();
            dashboard.put("ventasMes", ventasMes != null ? ventasMes : BigDecimal.ZERO);
            dashboard.put("ventasHoy", ventasHoy != null ? ventasHoy : BigDecimal.ZERO);
            
            // Calcular margen promedio real
            BigDecimal margenPromedio = calcularMargenPromedio();
            dashboard.put("margenPromedio", margenPromedio);
            
            // Pedidos de hoy (simplificado)
            dashboard.put("pedidosHoy", Integer.valueOf(0));
            
        } catch (Exception e) {
            System.err.println("Error al obtener datos del dashboard: " + e.getMessage());
            e.printStackTrace();
            // Valores por defecto en caso de error
            dashboard.put("totalClientes", Integer.valueOf(0));
            dashboard.put("totalProductos", Integer.valueOf(0));
            dashboard.put("totalPedidos", Integer.valueOf(0));
            dashboard.put("ventasMes", BigDecimal.ZERO);
            dashboard.put("ventasHoy", BigDecimal.ZERO);
            dashboard.put("pedidosHoy", Integer.valueOf(0));
            dashboard.put("margenPromedio", BigDecimal.ZERO);
        }
        
        return dashboard;
    }

    private BigDecimal calcularMargenPromedio() {
        try {
            List<Producto> productos = productoDAO.listarProductos();
            if (productos.isEmpty()) return BigDecimal.ZERO;
            
            BigDecimal margenTotal = BigDecimal.ZERO;
            int productosConMargen = 0;
            
            for (Producto p : productos) {
                if (p.getPrecio() != null && p.getCosto() != null && 
                    p.getCosto().compareTo(BigDecimal.ZERO) > 0) {
                    BigDecimal margen = p.getPrecio().subtract(p.getCosto())
                        .divide(p.getPrecio(), 4, BigDecimal.ROUND_HALF_UP)
                        .multiply(new BigDecimal("100"));
                    margenTotal = margenTotal.add(margen);
                    productosConMargen++;
                }
            }
            
            if (productosConMargen > 0) {
                return margenTotal.divide(new BigDecimal(productosConMargen), 1, BigDecimal.ROUND_HALF_UP);
            }
            
        } catch (Exception e) {
            System.err.println("Error al calcular margen promedio: " + e.getMessage());
        }
        return BigDecimal.ZERO;
    }

    private Map<String, Object> getChartData() {
        Map<String, Object> chartData = new HashMap<>();
        
        try {
            // Gráfico 1: Top 5 productos más caros
            List<Map<String, Object>> topProductos = getTopProductosPorPrecio();
            chartData.put("topProductos", topProductos);
            
            // Gráfico 2: Distribución de productos por rango de precio
            List<Map<String, Object>> rangoPrecios = getProductosPorRangoPrecio();
            chartData.put("rangoPrecios", rangoPrecios);
            
        } catch (Exception e) {
            System.err.println("Error al obtener datos de gráficos: " + e.getMessage());
            chartData.put("topProductos", new ArrayList<>());
            chartData.put("rangoPrecios", new ArrayList<>());
        }
        
        return chartData;
    }

    private List<Map<String, Object>> getTopProductosPorPrecio() {
        List<Map<String, Object>> topProductos = new ArrayList<>();
        
        try {
            List<Producto> productos = productoDAO.listarProductos();
            
            // Filtrar productos con precio válido y ordenar por precio descendente
            List<Producto> productosOrdenados = productos.stream()
                .filter(p -> p.getPrecio() != null && p.getPrecio().compareTo(BigDecimal.ZERO) > 0)
                .sorted((p1, p2) -> p2.getPrecio().compareTo(p1.getPrecio()))
                .limit(5)
                .collect(Collectors.toList());
            
            for (Producto p : productosOrdenados) {
                Map<String, Object> producto = new HashMap<>();
                String nombre = p.getDescripcion();
                if (nombre != null && nombre.length() > 20) {
                    nombre = nombre.substring(0, 20) + "...";
                }
                producto.put("nombre", nombre != null ? nombre : "Sin nombre");
                producto.put("precio", p.getPrecio().doubleValue());
                topProductos.add(producto);
            }
            
        } catch (Exception e) {
            System.err.println("Error al obtener top productos: " + e.getMessage());
            // Datos por defecto si hay error
            for (int i = 1; i <= 3; i++) {
                Map<String, Object> producto = new HashMap<>();
                producto.put("nombre", "Producto " + i);
                producto.put("precio", 100.0 * i);
                topProductos.add(producto);
            }
        }
        
        return topProductos;
    }

    private List<Map<String, Object>> getProductosPorRangoPrecio() {
        List<Map<String, Object>> rangos = new ArrayList<>();
        
        try {
            List<Producto> productos = productoDAO.listarProductos();
            
            // Contadores para rangos de precio
            int rango0_50 = 0;
            int rango51_100 = 0;
            int rango101_200 = 0;
            int rango201_500 = 0;
            int rango500_mas = 0;
            
            for (Producto p : productos) {
                if (p.getPrecio() != null) {
                    double precio = p.getPrecio().doubleValue();
                    if (precio <= 50) {
                        rango0_50++;
                    } else if (precio <= 100) {
                        rango51_100++;
                    } else if (precio <= 200) {
                        rango101_200++;
                    } else if (precio <= 500) {
                        rango201_500++;
                    } else {
                        rango500_mas++;
                    }
                }
            }
            
            // Crear datos para el gráfico
            if (rango0_50 > 0) {
                Map<String, Object> rango = new HashMap<>();
                rango.put("rango", "S/ 0-50");
                rango.put("cantidad", rango0_50);
                rangos.add(rango);
            }
            
            if (rango51_100 > 0) {
                Map<String, Object> rango = new HashMap<>();
                rango.put("rango", "S/ 51-100");
                rango.put("cantidad", rango51_100);
                rangos.add(rango);
            }
            
            if (rango101_200 > 0) {
                Map<String, Object> rango = new HashMap<>();
                rango.put("rango", "S/ 101-200");
                rango.put("cantidad", rango101_200);
                rangos.add(rango);
            }
            
            if (rango201_500 > 0) {
                Map<String, Object> rango = new HashMap<>();
                rango.put("rango", "S/ 201-500");
                rango.put("cantidad", rango201_500);
                rangos.add(rango);
            }
            
            if (rango500_mas > 0) {
                Map<String, Object> rango = new HashMap<>();
                rango.put("rango", "S/ 500+");
                rango.put("cantidad", rango500_mas);
                rangos.add(rango);
            }
            
        } catch (Exception e) {
            System.err.println("Error al obtener rangos de precio: " + e.getMessage());
            // Datos por defecto si hay error
            String[] rangosDefault = {"S/ 0-50", "S/ 51-100", "S/ 101-200"};
            int[] cantidadesDefault = {2, 1, 1};
            
            for (int i = 0; i < rangosDefault.length; i++) {
                Map<String, Object> rango = new HashMap<>();
                rango.put("rango", rangosDefault[i]);
                rango.put("cantidad", cantidadesDefault[i]);
                rangos.add(rango);
            }
        }
        
        return rangos;
    }
}
