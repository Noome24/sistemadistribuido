package servlet;

import dao.ProductoDAO;
import modelo.Producto;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;
import java.util.HashMap;
import java.util.Map;

import com.google.gson.Gson;

@WebServlet("/api/productos/*")
public class ProductoServlet extends HttpServlet {
    private final ProductoDAO productoDAO = new ProductoDAO();
    private final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String pathInfo = request.getPathInfo();
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        // Verificar autenticación
        HttpSession session = request.getSession(false);
        if (session == null || (session.getAttribute("usuario") == null && session.getAttribute("cliente") == null)) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            Map<String, String> error = new HashMap<>();
            error.put("error", "No autorizado");
            response.getWriter().write(gson.toJson(error));
            return;
        }

        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                // Listar todos los productos
                List<Producto> productos = productoDAO.listarProductos();
                response.getWriter().write(gson.toJson(productos));
                
            } else if (pathInfo.equals("/count")) {
                // Contar productos
                int count = productoDAO.contarProductos();
                Map<String, Integer> result = new HashMap<>();
                result.put("count", count);
                response.getWriter().write(gson.toJson(result));
                
            } else if (pathInfo.equals("/bajo-stock")) {
                // Obtener productos con bajo stock
                List<Producto> productos = productoDAO.obtenerProductosBajoStock();
                response.getWriter().write(gson.toJson(productos));
                
            } else if (pathInfo.startsWith("/")) {
                // Obtener producto por ID
                String id = pathInfo.substring(1);
                Producto producto = productoDAO.obtenerProductoPorId(id);
                
                if (producto != null) {
                    response.getWriter().write(gson.toJson(producto));
                } else {
                    response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                    Map<String, String> error = new HashMap<>();
                    error.put("error", "Producto no encontrado");
                    response.getWriter().write(gson.toJson(error));
                }
            }
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            Map<String, String> error = new HashMap<>();
            error.put("error", "Error interno del servidor: " + e.getMessage());
            response.getWriter().write(gson.toJson(error));
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String pathInfo = request.getPathInfo();
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        // Verificar autenticación
        HttpSession session = request.getSession(false);
        if (session == null || (session.getAttribute("usuario") == null && session.getAttribute("cliente") == null)) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            Map<String, String> error = new HashMap<>();
            error.put("error", "No autorizado");
            response.getWriter().write(gson.toJson(error));
            return;
        }

        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                // Crear nuevo producto
                Producto producto = gson.fromJson(request.getReader(), Producto.class);
                
                // Generar ID si no se proporciona
                if (producto.getId_prod() == null || producto.getId_prod().isEmpty()) {
                    producto.setId_prod(productoDAO.generarNuevoId());
                }
                
                boolean success = productoDAO.guardarProducto(producto);
                Map<String, Object> result = new HashMap<>();
                
                if (success) {
                    result.put("success", true);
                    result.put("message", "Producto guardado exitosamente");
                    result.put("producto", producto);
                    response.setStatus(HttpServletResponse.SC_CREATED);
                } else {
                    result.put("success", false);
                    result.put("message", "Error al guardar producto");
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                }
                
                response.getWriter().write(gson.toJson(result));
            }
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            Map<String, String> error = new HashMap<>();
            error.put("error", "Error interno del servidor: " + e.getMessage());
            response.getWriter().write(gson.toJson(error));
        }
    }

    @Override
    protected void doPut(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String pathInfo = request.getPathInfo();
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        // Verificar autenticación
        HttpSession session = request.getSession(false);
        if (session == null || (session.getAttribute("usuario") == null && session.getAttribute("cliente") == null)) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            Map<String, String> error = new HashMap<>();
            error.put("error", "No autorizado");
            response.getWriter().write(gson.toJson(error));
            return;
        }

        try {
            if (pathInfo != null && pathInfo.startsWith("/")) {
                // Actualizar producto
                String id = pathInfo.substring(1);
                Producto producto = gson.fromJson(request.getReader(), Producto.class);
                producto.setId_prod(id);
                
                boolean success = productoDAO.actualizarProducto(producto);
                Map<String, Object> result = new HashMap<>();
                
                if (success) {
                    result.put("success", true);
                    result.put("message", "Producto actualizado exitosamente");
                    result.put("producto", producto);
                } else {
                    result.put("success", false);
                    result.put("message", "Error al actualizar producto");
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                }
                
                response.getWriter().write(gson.toJson(result));
            }
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            Map<String, String> error = new HashMap<>();
            error.put("error", "Error interno del servidor: " + e.getMessage());
            response.getWriter().write(gson.toJson(error));
        }
    }

    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String pathInfo = request.getPathInfo();
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        // Verificar autenticación
        HttpSession session = request.getSession(false);
        if (session == null || (session.getAttribute("usuario") == null && session.getAttribute("cliente") == null)) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            Map<String, String> error = new HashMap<>();
            error.put("error", "No autorizado");
            response.getWriter().write(gson.toJson(error));
            return;
        }

        try {
            if (pathInfo != null && pathInfo.startsWith("/")) {
                // Eliminar producto
                String id = pathInfo.substring(1);
                boolean success = productoDAO.eliminarProducto(id);
                Map<String, Object> result = new HashMap<>();
                
                if (success) {
                    result.put("success", true);
                    result.put("message", "Producto eliminado exitosamente");
                } else {
                    result.put("success", false);
                    result.put("message", "Error al eliminar producto");
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                }
                
                response.getWriter().write(gson.toJson(result));
            }
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            Map<String, String> error = new HashMap<>();
            error.put("error", "Error interno del servidor: " + e.getMessage());
            response.getWriter().write(gson.toJson(error));
        }
    }
}
