package servlet;

import dao.PedidoDAO;
import dao.DetallePedidoDAO;
import dao.ProductoDAO;
import modelo.Pedido;
import modelo.DetallePedido;

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
import java.math.BigDecimal;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

@WebServlet("/api/pedidos/*")
public class PedidoServlet extends HttpServlet {
    private final PedidoDAO pedidoDAO = new PedidoDAO();
    private final DetallePedidoDAO detallePedidoDAO = new DetallePedidoDAO();
    private final ProductoDAO productoDAO = new ProductoDAO();
    private final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String pathInfo = request.getPathInfo();
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        // Verificar autenticación
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            Map<String, String> error = new HashMap<>();
            error.put("error", "No autorizado");
            response.getWriter().write(gson.toJson(error));
            return;
        }

        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                // Listar todos los pedidos
                List<Pedido> pedidos = pedidoDAO.listarPedidos();
                response.getWriter().write(gson.toJson(pedidos));
                
            } else if (pathInfo.equals("/count")) {
                // Contar pedidos
                int count = pedidoDAO.contarPedidos();
                Map<String, Integer> result = new HashMap<>();
                result.put("count", count);
                response.getWriter().write(gson.toJson(result));
                
            } else if (pathInfo.equals("/ventas-hoy")) {
                // Obtener ventas de hoy
                BigDecimal ventas = pedidoDAO.obtenerVentasHoy();
                Map<String, BigDecimal> result = new HashMap<>();
                result.put("ventas", ventas);
                response.getWriter().write(gson.toJson(result));
                
            } else if (pathInfo.equals("/ventas-mes")) {
                // Obtener ventas del mes
                BigDecimal ventas = pedidoDAO.obtenerVentasMes();
                Map<String, BigDecimal> result = new HashMap<>();
                result.put("ventas", ventas);
                response.getWriter().write(gson.toJson(result));
                
            } else if (pathInfo.startsWith("/") && pathInfo.contains("/detalles")) {
                // Obtener detalles de un pedido
                String id = pathInfo.substring(1, pathInfo.indexOf("/detalles"));
                List<DetallePedido> detalles = detallePedidoDAO.obtenerDetallesPorPedido(id);
                response.getWriter().write(gson.toJson(detalles));
                
            } else if (pathInfo.startsWith("/cliente/")) {
                // Obtener pedidos por cliente
                String idCliente = pathInfo.substring("/cliente/".length());
                List<Pedido> pedidos = pedidoDAO.obtenerPedidosPorCliente(idCliente);
                response.getWriter().write(gson.toJson(pedidos));
                
            } else if (pathInfo.startsWith("/")) {
                // Obtener pedido por ID
                String id = pathInfo.substring(1);
                Pedido pedido = pedidoDAO.obtenerPedidoPorId(id);
                
                if (pedido != null) {
                    // Cargar detalles del pedido
                    List<DetallePedido> detalles = detallePedidoDAO.obtenerDetallesPorPedido(id);
                    pedido.setDetalles(detalles);
                    response.getWriter().write(gson.toJson(pedido));
                } else {
                    response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                    Map<String, String> error = new HashMap<>();
                    error.put("error", "Pedido no encontrado");
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
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        // Verificar autenticación
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            Map<String, String> error = new HashMap<>();
            error.put("error", "No autorizado");
            response.getWriter().write(gson.toJson(error));
            return;
        }

        try {
            // Crear nuevo pedido con detalles
            Map<String, Object> requestData = gson.fromJson(request.getReader(), 
                new TypeToken<Map<String, Object>>(){}.getType());
            
            Pedido pedido = gson.fromJson(gson.toJson(requestData.get("pedido")), Pedido.class);
            List<DetallePedido> detalles = gson.fromJson(gson.toJson(requestData.get("detalles")), 
                new TypeToken<List<DetallePedido>>(){}.getType());
            
            // Generar ID si no se proporciona
            if (pedido.getId_pedido() == null || pedido.getId_pedido().isEmpty()) {
                pedido.setId_pedido(pedidoDAO.generarNuevoId());
            }
            
            // Calcular totales
            BigDecimal subtotal = BigDecimal.ZERO;
            for (DetallePedido detalle : detalles) {
                detalle.setId_pedido(pedido.getId_pedido());
                detalle.calcularTotal();
                subtotal = subtotal.add(detalle.getTotal_deta());
            }
            
            pedido.setSubtotal(subtotal);
            // Calcular total con IGV (18%)
            BigDecimal igv = subtotal.multiply(new BigDecimal("0.18"));
            pedido.setTotalventa(subtotal.add(igv));
            
            // Guardar pedido
            boolean pedidoGuardado = pedidoDAO.guardarPedido(pedido);
            boolean detallesGuardados = false;
            
            if (pedidoGuardado) {
                detallesGuardados = detallePedidoDAO.guardarDetalles(pedido.getId_pedido(), detalles);
                
                if (detallesGuardados) {
                    // Actualizar stock de productos
                    for (DetallePedido detalle : detalles) {
                        productoDAO.actualizarStock(detalle.getId_prod(), detalle.getCantidad());
                    }
                }
            }
            
            Map<String, Object> result = new HashMap<>();
            
            if (pedidoGuardado && detallesGuardados) {
                result.put("success", true);
                result.put("message", "Pedido guardado exitosamente");
                result.put("pedido", pedido);
                response.setStatus(HttpServletResponse.SC_CREATED);
            } else {
                result.put("success", false);
                result.put("message", "Error al guardar pedido");
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            }
            
            response.getWriter().write(gson.toJson(result));
            
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
        if (session == null || session.getAttribute("usuario") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            Map<String, String> error = new HashMap<>();
            error.put("error", "No autorizado");
            response.getWriter().write(gson.toJson(error));
            return;
        }

        try {
            if (pathInfo != null && pathInfo.startsWith("/")) {
                // Actualizar pedido
                String id = pathInfo.substring(1);
                
                Map<String, Object> requestData = gson.fromJson(request.getReader(), 
                    new TypeToken<Map<String, Object>>(){}.getType());
                
                Pedido pedido = gson.fromJson(gson.toJson(requestData.get("pedido")), Pedido.class);
                List<DetallePedido> detalles = gson.fromJson(gson.toJson(requestData.get("detalles")), 
                    new TypeToken<List<DetallePedido>>(){}.getType());
                
                pedido.setId_pedido(id);
                
                // Recalcular totales
                BigDecimal subtotal = BigDecimal.ZERO;
                for (DetallePedido detalle : detalles) {
                    detalle.setId_pedido(id);
                    detalle.calcularTotal();
                    subtotal = subtotal.add(detalle.getTotal_deta());
                }
                
                pedido.setSubtotal(subtotal);
                BigDecimal igv = subtotal.multiply(new BigDecimal("0.18"));
                pedido.setTotalventa(subtotal.add(igv));
                
                boolean pedidoActualizado = pedidoDAO.actualizarPedido(pedido);
                boolean detallesActualizados = false;
                
                if (pedidoActualizado) {
                    detallesActualizados = detallePedidoDAO.guardarDetalles(id, detalles);
                }
                
                Map<String, Object> result = new HashMap<>();
                
                if (pedidoActualizado && detallesActualizados) {
                    result.put("success", true);
                    result.put("message", "Pedido actualizado exitosamente");
                    result.put("pedido", pedido);
                } else {
                    result.put("success", false);
                    result.put("message", "Error al actualizar pedido");
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
        if (session == null || session.getAttribute("usuario") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            Map<String, String> error = new HashMap<>();
            error.put("error", "No autorizado");
            response.getWriter().write(gson.toJson(error));
            return;
        }

        try {
            if (pathInfo != null && pathInfo.startsWith("/")) {
                // Eliminar pedido
                String id = pathInfo.substring(1);
                
                // Primero eliminar detalles
                boolean detallesEliminados = detallePedidoDAO.eliminarDetallesPorPedido(id);
                boolean pedidoEliminado = false;
                
                if (detallesEliminados) {
                    pedidoEliminado = pedidoDAO.eliminarPedido(id);
                }
                
                Map<String, Object> result = new HashMap<>();
                
                if (pedidoEliminado) {
                    result.put("success", true);
                    result.put("message", "Pedido eliminado exitosamente");
                } else {
                    result.put("success", false);
                    result.put("message", "Error al eliminar pedido");
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
