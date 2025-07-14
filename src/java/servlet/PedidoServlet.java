package servlet;

import dao.PedidoDAO;
import dao.DetallePedidoDAO;
import dao.ProductoDAO;
import dao.UsuarioDAO;
import modelo.Pedido;
import modelo.DetallePedido;
import modelo.Usuario;

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
import java.util.ArrayList;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

@WebServlet("/api/pedidos/*")
public class PedidoServlet extends HttpServlet {
    private final PedidoDAO pedidoDAO = new PedidoDAO();
    private final DetallePedidoDAO detallePedidoDAO = new DetallePedidoDAO();
    private final ProductoDAO productoDAO = new ProductoDAO();
    private final Gson gson = new Gson();
    private final UsuarioDAO usuarioDAO = new UsuarioDAO();

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

        // Obtener información del usuario
        Integer rol = (Integer) session.getAttribute("rol");
        String userId = (String) session.getAttribute("username");
        String clienteId = (String) session.getAttribute("clienteId");

        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                // Listar pedidos según el rol
                List<Pedido> pedidos = new ArrayList<>();
            
                if (rol != null) {
                    switch (rol) {
                        case 0: // Admin - todos los pedidos
                        case 1: // Usuario normal - todos los pedidos
                            pedidos = pedidoDAO.listarPedidos();
                            break;
                        case 2: // Recepcionista - solo pedidos sin asignar
                            pedidos = pedidoDAO.obtenerPedidosPorEstado(0);
                            break;
                        case 3: // Transportista - solo sus pedidos asignados
                            if (userId != null) {
                                pedidos = pedidoDAO.obtenerPedidosPorTransportista(userId);
                            }
                            break;
                        case 99: // Cliente - solo sus pedidos
                            if (clienteId != null) {
                                pedidos = pedidoDAO.obtenerPedidosPorCliente(clienteId);
                            }
                            break;
                    }
                }
            
                response.getWriter().write(gson.toJson(pedidos));
            
            } else if (pathInfo.equals("/transportistas")) {
                // Solo admins pueden ver la lista de transportistas
                if (rol != null && rol == 0) {
                    List<Usuario> transportistas = usuarioDAO.obtenerUsuariosPorRol(3);
                    response.getWriter().write(gson.toJson(transportistas));
                } else {
                    response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                    Map<String, String> error = new HashMap<>();
                    error.put("error", "Acceso denegado");
                    response.getWriter().write(gson.toJson(error));
                }
            
            } else if (pathInfo.equals("/count")) {
                // Contar pedidos según rol
                int count = 0;
                if (rol != null) {
                    switch (rol) {
                        case 0:
                        case 1:
                            count = pedidoDAO.contarPedidos();
                            break;
                        case 2:
                            count = pedidoDAO.obtenerPedidosPorEstado(0).size();
                            break;
                        case 3:
                            if (userId != null) {
                                count = pedidoDAO.obtenerPedidosPorTransportista(userId).size();
                            }
                            break;
                        case 99:
                            if (clienteId != null) {
                                count = pedidoDAO.obtenerPedidosPorCliente(clienteId).size();
                            }
                            break;
                    }
                }
            
                Map<String, Integer> result = new HashMap<>();
                result.put("count", count);
                response.getWriter().write(gson.toJson(result));
            
            } else if (pathInfo.equals("/ventas-hoy")) {
                // Solo admins y usuarios normales pueden ver ventas
                if (rol != null && (rol == 0 || rol == 1)) {
                    BigDecimal ventas = pedidoDAO.obtenerVentasHoy();
                    Map<String, BigDecimal> result = new HashMap<>();
                    result.put("ventas", ventas);
                    response.getWriter().write(gson.toJson(result));
                } else {
                    response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                    Map<String, String> error = new HashMap<>();
                    error.put("error", "Acceso denegado");
                    response.getWriter().write(gson.toJson(error));
                }
            
            } else if (pathInfo.equals("/ventas-mes")) {
                // Solo admins y usuarios normales pueden ver ventas
                if (rol != null && (rol == 0 || rol == 1)) {
                    BigDecimal ventas = pedidoDAO.obtenerVentasMes();
                    Map<String, BigDecimal> result = new HashMap<>();
                    result.put("ventas", ventas);
                    response.getWriter().write(gson.toJson(result));
                } else {
                    response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                    Map<String, String> error = new HashMap<>();
                    error.put("error", "Acceso denegado");
                    response.getWriter().write(gson.toJson(error));
                }
            
            } else if (pathInfo.startsWith("/") && pathInfo.contains("/detalles")) {
                // Obtener detalles de un pedido (verificar permisos)
                String id = pathInfo.substring(1, pathInfo.indexOf("/detalles"));
            
                // Verificar si el usuario puede ver este pedido
                boolean puedeVer = false;
                if (rol != null) {
                    switch (rol) {
                        case 0:
                        case 1:
                            puedeVer = true; // Admins y usuarios normales ven todo
                            break;
                        case 2:
                            // Recepcionistas solo ven pedidos sin asignar
                            Pedido pedido = pedidoDAO.obtenerPedidoPorId(id);
                            puedeVer = (pedido != null && pedido.getEstado() == 0);
                            break;
                        case 3:
                            // Transportistas solo ven sus pedidos asignados
                            List<Pedido> pedidosTransportista = pedidoDAO.obtenerPedidosPorTransportista(userId);
                            puedeVer = pedidosTransportista.stream().anyMatch(p -> p.getId_pedido().equals(id));
                            break;
                        case 99:
                            // Clientes solo ven sus pedidos
                            List<Pedido> pedidosCliente = pedidoDAO.obtenerPedidosPorCliente(clienteId);
                            puedeVer = pedidosCliente.stream().anyMatch(p -> p.getId_pedido().equals(id));
                            break;
                    }
                }
            
                if (puedeVer) {
                    List<DetallePedido> detalles = detallePedidoDAO.obtenerDetallesPorPedido(id);
                    response.getWriter().write(gson.toJson(detalles));
                } else {
                    response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                    Map<String, String> error = new HashMap<>();
                    error.put("error", "No tiene permisos para ver este pedido");
                    response.getWriter().write(gson.toJson(error));
                }
            
            } else if (pathInfo.startsWith("/cliente/")) {
                // Solo admins, usuarios normales y el propio cliente pueden ver pedidos por cliente
                String idCliente = pathInfo.substring("/cliente/".length());
            
                boolean puedeVer = false;
                if (rol != null) {
                    if (rol == 0 || rol == 1) {
                        puedeVer = true;
                    } else if (rol == 99 && idCliente.equals(clienteId)) {
                        puedeVer = true;
                    }
                }
            
                if (puedeVer) {
                    List<Pedido> pedidos = pedidoDAO.obtenerPedidosPorCliente(idCliente);
                    response.getWriter().write(gson.toJson(pedidos));
                } else {
                    response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                    Map<String, String> error = new HashMap<>();
                    error.put("error", "No tiene permisos para ver estos pedidos");
                    response.getWriter().write(gson.toJson(error));
                }
            
            } else if (pathInfo.startsWith("/")) {
                // Obtener pedido por ID (con verificación de permisos)
                String id = pathInfo.substring(1);
            
                // Verificar permisos similar a detalles
                boolean puedeVer = false;
                if (rol != null) {
                    switch (rol) {
                        case 0:
                        case 1:
                            puedeVer = true;
                            break;
                        case 2:
                            Pedido pedido = pedidoDAO.obtenerPedidoPorId(id);
                            puedeVer = (pedido != null && pedido.getEstado() == 0);
                            break;
                        case 3:
                            List<Pedido> pedidosTransportista = pedidoDAO.obtenerPedidosPorTransportista(userId);
                            puedeVer = pedidosTransportista.stream().anyMatch(p -> p.getId_pedido().equals(id));
                            break;
                        case 99:
                            List<Pedido> pedidosCliente = pedidoDAO.obtenerPedidosPorCliente(clienteId);
                            puedeVer = pedidosCliente.stream().anyMatch(p -> p.getId_pedido().equals(id));
                            break;
                    }
                }
            
                if (puedeVer) {
                    Pedido pedido = pedidoDAO.obtenerPedidoPorId(id);
                    if (pedido != null) {
                        List<DetallePedido> detalles = detallePedidoDAO.obtenerDetallesPorPedido(id);
                        pedido.setDetalles(detalles);
                        response.getWriter().write(gson.toJson(pedido));
                    } else {
                        response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                        Map<String, String> error = new HashMap<>();
                        error.put("error", "Pedido no encontrado");
                        response.getWriter().write(gson.toJson(error));
                    }
                } else {
                    response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                    Map<String, String> error = new HashMap<>();
                    error.put("error", "No tiene permisos para ver este pedido");
                    response.getWriter().write(gson.toJson(error));
                }
            
            } else if (pathInfo.startsWith("/estado/")) {
                // Obtener pedidos por estado (con restricciones de rol)
                String estadoStr = pathInfo.substring("/estado/".length());
                try {
                    int estado = Integer.parseInt(estadoStr);
                
                    List<Pedido> pedidos = new ArrayList<>();
                    if (rol != null) {
                        switch (rol) {
                            case 0:
                            case 1:
                                pedidos = pedidoDAO.obtenerPedidosPorEstado(estado);
                                break;
                            case 2:
                                // Recepcionistas solo ven estado 0
                                if (estado == 0) {
                                    pedidos = pedidoDAO.obtenerPedidosPorEstado(estado);
                                }
                                break;
                            case 3:
                                // Transportistas solo ven sus pedidos con ese estado
                                List<Pedido> todosPedidos = pedidoDAO.obtenerPedidosPorTransportista(userId);
                                pedidos = todosPedidos.stream()
                                        .filter(p -> p.getEstado() == estado)
                                        .collect(java.util.stream.Collectors.toList());
                                break;
                            case 99:
                                // Clientes solo ven sus pedidos con ese estado
                                List<Pedido> pedidosCliente = pedidoDAO.obtenerPedidosPorCliente(clienteId);
                                pedidos = pedidosCliente.stream()
                                        .filter(p -> p.getEstado() == estado)
                                        .collect(java.util.stream.Collectors.toList());
                                break;
                        }
                    }
                
                    response.getWriter().write(gson.toJson(pedidos));
                } catch (NumberFormatException e) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    Map<String, String> error = new HashMap<>();
                    error.put("error", "Estado inválido");
                    response.getWriter().write(gson.toJson(error));
                }
            
            } else if (pathInfo.startsWith("/transportista/")) {
                // Solo el propio transportista o admins pueden ver estos pedidos
                String idTransportista = pathInfo.substring("/transportista/".length());
            
                boolean puedeVer = false;
                if (rol != null) {
                    if (rol == 0 || rol == 1) {
                        puedeVer = true;
                    } else if (rol == 3 && idTransportista.equals(userId)) {
                        puedeVer = true;
                    }
                }
            
                if (puedeVer) {
                    List<Pedido> pedidos = pedidoDAO.obtenerPedidosPorTransportista(idTransportista);
                    response.getWriter().write(gson.toJson(pedidos));
                } else {
                    response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                    Map<String, String> error = new HashMap<>();
                    error.put("error", "No tiene permisos para ver estos pedidos");
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
        if (session == null || (session.getAttribute("usuario") == null && session.getAttribute("cliente") == null)) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            Map<String, String> error = new HashMap<>();
            error.put("error", "No autorizado");
            response.getWriter().write(gson.toJson(error));
            return;
        }

        // Verificar permisos para crear pedidos
        Integer rol = (Integer) session.getAttribute("rol");
        if (rol == null || (rol != 0 && rol != 1 && rol != 99)) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            Map<String, String> error = new HashMap<>();
            error.put("error", "No tiene permisos para crear pedidos");
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
            
            // Si es un cliente, asegurar que el pedido sea suyo
            if (rol == 99) {
                String clienteId = (String) session.getAttribute("clienteId");
                if (clienteId != null) {
                    pedido.setId_cliente(clienteId);
                } else {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    Map<String, String> error = new HashMap<>();
                    error.put("error", "Cliente no identificado");
                    response.getWriter().write(gson.toJson(error));
                    return;
                }
            }
            
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
            
            // Establecer estado por defecto
            if (pedido.getEstado() == 0) {
                pedido.setEstado(0); // Sin asignar por defecto
            }
            
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
        if (session == null || (session.getAttribute("usuario") == null && session.getAttribute("cliente") == null)) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            Map<String, String> error = new HashMap<>();
            error.put("error", "No autorizado");
            response.getWriter().write(gson.toJson(error));
            return;
        }

        // Verificar permisos para editar pedidos
        Integer rol = (Integer) session.getAttribute("rol");
        if (rol == null || (rol != 0 && rol != 1)) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            Map<String, String> error = new HashMap<>();
            error.put("error", "No tiene permisos para editar pedidos");
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
        if (session == null || (session.getAttribute("usuario") == null && session.getAttribute("cliente") == null)) {
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

    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String method = request.getMethod();
        if ("PATCH".equals(method)) {
            doPatch(request, response);
        } else {
            super.service(request, response);
        }
    }

    protected void doPatch(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
    String pathInfo = request.getPathInfo();
    response.setContentType("application/json");
    response.setCharacterEncoding("UTF-8");

    HttpSession session = request.getSession(false);
    if (session == null || (session.getAttribute("usuario") == null && session.getAttribute("cliente") == null)) {
        response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
        Map<String, String> error = new HashMap<>();
        error.put("error", "No autorizado");
        response.getWriter().write(gson.toJson(error));
        return;
    }

    // Obtener información del usuario
    Integer rol = (Integer) session.getAttribute("rol");
    String userId = (String) session.getAttribute("username");

    try {
        if (pathInfo != null && pathInfo.contains("/estado/")) {
            String[] parts = pathInfo.split("/");

            if (parts.length >= 4 && "estado".equals(parts[2])) {
                String idPedido = parts[1];
                int nuevoEstado = Integer.parseInt(parts[3]);

                // Verificar permisos según el rol y el estado
                boolean puedeActualizar = false;
                String mensajeError = "No tiene permisos para cambiar el estado";

                if (rol != null) {
                    switch (rol) {
                        case 0: // Admin - puede cambiar cualquier estado
                        case 1: // Usuario normal - puede cambiar cualquier estado
                            puedeActualizar = true;
                            break;
                            
                        case 2: // Recepcionista - solo puede aceptar (2) o rechazar (1) pedidos sin asignar
                            if (nuevoEstado == 1 || nuevoEstado == 2) {
                                // Verificar que el pedido esté sin asignar
                                Pedido pedido = pedidoDAO.obtenerPedidoPorId(idPedido);
                                if (pedido != null && pedido.getEstado() == 0) {
                                    puedeActualizar = true;
                                } else {
                                    mensajeError = "Solo puede cambiar el estado de pedidos sin asignar";
                                }
                            } else {
                                mensajeError = "Los recepcionistas solo pueden aceptar o rechazar pedidos";
                            }
                            break;
                            
                        case 3: // Transportista - solo puede cambiar estado de sus pedidos asignados
                            if (nuevoEstado == 4 || nuevoEstado == 5) {
                                // Verificar que el pedido esté asignado a este transportista
                                List<Pedido> pedidosTransportista = pedidoDAO.obtenerPedidosPorTransportista(userId);
                                boolean esAsignado = pedidosTransportista.stream()
                                        .anyMatch(p -> p.getId_pedido().equals(idPedido));
                                
                                if (esAsignado) {
                                    // Verificar transición de estado válida
                                    Pedido pedido = pedidoDAO.obtenerPedidoPorId(idPedido);
                                    if (pedido != null) {
                                        if ((nuevoEstado == 4 && pedido.getEstado() == 3) || 
                                            (nuevoEstado == 5 && pedido.getEstado() == 4)) {
                                            puedeActualizar = true;
                                        } else {
                                            mensajeError = "Transición de estado no válida";
                                        }
                                    }
                                } else {
                                    mensajeError = "Solo puede cambiar el estado de sus pedidos asignados";
                                }
                            } else {
                                mensajeError = "Los transportistas solo pueden iniciar proceso o marcar como entregado";
                            }
                            break;
                            
                        case 99: // Cliente - no puede cambiar estados
                            mensajeError = "Los clientes no pueden cambiar el estado de los pedidos";
                            break;
                    }
                }

                if (puedeActualizar) {
                    boolean actualizado = pedidoDAO.actualizarEstado(idPedido, nuevoEstado);
                    Map<String, Object> result = new HashMap<>();
                    result.put("success", actualizado);
                    result.put("message", actualizado ? "Estado actualizado correctamente" : "Error al actualizar estado");
                    response.getWriter().write(gson.toJson(result));
                } else {
                    response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                    Map<String, String> error = new HashMap<>();
                    error.put("error", mensajeError);
                    response.getWriter().write(gson.toJson(error));
                }
            } else {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                Map<String, String> error = new HashMap<>();
                error.put("error", "URL mal formada para actualizar estado");
                response.getWriter().write(gson.toJson(error));
            }
            
        } else if (pathInfo != null && pathInfo.contains("/asignar/")) {
            String[] parts = pathInfo.split("/");

            if (parts.length >= 4 && "asignar".equals(parts[2])) {
                String idPedido = parts[1];
                String idTransportista = parts[3];

                // Solo admins pueden asignar transportistas
                if (rol != null && rol == 0) {
                    // Verificar que el pedido esté aceptado (estado 2)
                    Pedido pedido = pedidoDAO.obtenerPedidoPorId(idPedido);
                    if (pedido != null && pedido.getEstado() == 2) {
                        boolean asignado = pedidoDAO.asignarTransportista(idPedido, idTransportista);
                        Map<String, Object> result = new HashMap<>();
                        result.put("success", asignado);
                        result.put("message", asignado ? "Transportista asignado correctamente" : "Error al asignar transportista");
                        response.getWriter().write(gson.toJson(result));
                    } else {
                        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                        Map<String, String> error = new HashMap<>();
                        error.put("error", "Solo se pueden asignar transportistas a pedidos aceptados");
                        response.getWriter().write(gson.toJson(error));
                    }
                } else {
                    response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                    Map<String, String> error = new HashMap<>();
                    error.put("error", "Solo los administradores pueden asignar transportistas");
                    response.getWriter().write(gson.toJson(error));
                }
            } else {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                Map<String, String> error = new HashMap<>();
                error.put("error", "URL mal formada para asignar transportista");
                response.getWriter().write(gson.toJson(error));
            }
        } else {
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            Map<String, String> error = new HashMap<>();
            error.put("error", "Ruta PATCH no válida");
            response.getWriter().write(gson.toJson(error));
        }
    } catch (Exception e) {
        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        Map<String, String> error = new HashMap<>();
        error.put("error", "Error interno del servidor: " + e.getMessage());
        response.getWriter().write(gson.toJson(error));
    }
}

}
