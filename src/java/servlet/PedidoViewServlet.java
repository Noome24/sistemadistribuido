package servlet;

import dao.PedidoDAO;
import dao.ClienteDAO;
import dao.ProductoDAO;
import dao.DetallePedidoDAO;
import modelo.Pedido;
import modelo.Cliente;
import modelo.Producto;
import modelo.DetallePedido;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.sql.Date;
import java.math.BigDecimal;

@WebServlet({"/pedidos", "/pedidos/listar", "/pedidos/agregar", "/pedidos/editar/*", "/pedidos/eliminar/*", "/pedidos/detalles/*", "/pedidos/guardar", "/pedidos/actualizar"})
public class PedidoViewServlet extends HttpServlet {
    private final PedidoDAO pedidoDAO = new PedidoDAO();
    private final ClienteDAO clienteDAO = new ClienteDAO();
    private final ProductoDAO productoDAO = new ProductoDAO();
    private final DetallePedidoDAO detallePedidoDAO = new DetallePedidoDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Verificar sesión
        HttpSession session = request.getSession(false);
        if (session == null || (session.getAttribute("usuario") == null && session.getAttribute("cliente") == null)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String path = request.getServletPath();
        String pathInfo = request.getPathInfo();

        try {
            switch (path) {
                case "/pedidos":
                    mostrarIndex(request, response);
                    break;
                case "/pedidos/listar":
                    listarPedidos(request, response);
                    break;
                case "/pedidos/agregar":
                    mostrarFormularioAgregar(request, response);
                    break;
                case "/pedidos/editar":
                    if (pathInfo != null && pathInfo.length() > 1) {
                        String id = pathInfo.substring(1);
                        mostrarFormularioEditar(request, response, id);
                    } else {
                        response.sendRedirect(request.getContextPath() + "/pedidos");
                    }
                    break;
                case "/pedidos/detalles":
                    if (pathInfo != null && pathInfo.length() > 1) {
                        String id = pathInfo.substring(1);
                        mostrarDetalles(request, response, id);
                    } else {
                        response.sendRedirect(request.getContextPath() + "/pedidos");
                    }
                    break;
                case "/pedidos/eliminar":
                    if (pathInfo != null && pathInfo.length() > 1) {
                        String id = pathInfo.substring(1);
                        eliminarPedido(request, response, id);
                    } else {
                        response.sendRedirect(request.getContextPath() + "/pedidos");
                    }
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/pedidos");
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Error interno del servidor: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/pedidos");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Verificar sesión
        HttpSession session = request.getSession(false);
        if (session == null || (session.getAttribute("usuario") == null && session.getAttribute("cliente") == null)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String path = request.getServletPath();

        try {
            switch (path) {
                case "/pedidos/guardar":
                    guardarPedido(request, response);
                    break;
                case "/pedidos/actualizar":
                    actualizarPedido(request, response);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/pedidos");
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Error interno del servidor: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/pedidos");
        }
    }

    private void mostrarIndex(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/pedidos/index.jsp").forward(request, response);
    }

    private void listarPedidos(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        if (session == null || (session.getAttribute("usuario") == null && session.getAttribute("cliente") == null)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        List<Pedido> pedidos;

        if (session.getAttribute("cliente") != null) {
            // Si es cliente, mostrar solo sus pedidos
            String clienteId = (String) session.getAttribute("clienteId");
            pedidos = pedidoDAO.obtenerPedidosPorCliente(clienteId);
        } else {
            // Si es usuario (empleado), mostrar todos los pedidos
            pedidos = pedidoDAO.listarPedidos();
        }

        request.setAttribute("pedidos", pedidos);
        request.getRequestDispatcher("/pedidos/listar.jsp").forward(request, response);
    }


    private void mostrarFormularioAgregar(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Cliente> clientes = clienteDAO.listarClientes();
        List<Producto> productos = productoDAO.listarProductos();
        String nuevoId = pedidoDAO.generarNuevoId();
        
        request.setAttribute("clientes", clientes);
        request.setAttribute("productos", productos);
        request.setAttribute("nuevoId", nuevoId);
        request.getRequestDispatcher("/pedidos/agregar.jsp").forward(request, response);
    }

    private void mostrarFormularioEditar(HttpServletRequest request, HttpServletResponse response, String id) throws ServletException, IOException {
        Pedido pedido = pedidoDAO.obtenerPedidoPorId(id);
        if (pedido != null) {
            List<Cliente> clientes = clienteDAO.listarClientes();
            List<Producto> productos = productoDAO.listarProductos();
            List<DetallePedido> detalles = detallePedidoDAO.obtenerDetallesPorPedido(id);
            
            request.setAttribute("pedido", pedido);
            request.setAttribute("clientes", clientes);
            request.setAttribute("productos", productos);
            request.setAttribute("detalles", detalles);
            request.getRequestDispatcher("/pedidos/editar.jsp").forward(request, response);
        } else {
            request.getSession().setAttribute("error", "Pedido no encontrado");
            response.sendRedirect(request.getContextPath() + "/pedidos/listar");
        }
    }

    private void mostrarDetalles(HttpServletRequest request, HttpServletResponse response, String id) throws ServletException, IOException {
        Pedido pedido = pedidoDAO.obtenerPedidoPorId(id);
        if (pedido != null) {
            List<DetallePedido> detalles = detallePedidoDAO.obtenerDetallesPorPedido(id);
            
            // Obtener información de productos para mostrar en la vista
            Map<String, Producto> productosMap = new HashMap<>();
            List<Producto> productos = new ArrayList<>();
            
            for (DetallePedido detalle : detalles) {
                if (!productosMap.containsKey(detalle.getId_prod())) {
                    Producto producto = productoDAO.obtenerProductoPorId(detalle.getId_prod());
                    if (producto != null) {
                        productosMap.put(detalle.getId_prod(), producto);
                        productos.add(producto);
                    }
                }
            }
            
            request.setAttribute("pedido", pedido);
            request.setAttribute("detalles", detalles);
            request.setAttribute("productos", productos);
            request.getRequestDispatcher("/pedidos/detalles.jsp").forward(request, response);
        } else {
            request.getSession().setAttribute("error", "Pedido no encontrado");
            response.sendRedirect(request.getContextPath() + "/pedidos/listar");
        }
    }

    private void guardarPedido(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            // Obtener parámetros del formulario
            String idPedido = request.getParameter("id_pedido");
            String fechaStr = request.getParameter("fecha");
            String idCliente = request.getParameter("id_cliente");
            
            // Obtener arrays de productos
            String[] productos = request.getParameterValues("productos[]");
            String[] cantidades = request.getParameterValues("cantidades[]");

            // Validaciones básicas
            if (idPedido == null || idPedido.trim().isEmpty()) {
                request.getSession().setAttribute("error", "ID de pedido es requerido");
                response.sendRedirect(request.getContextPath() + "/pedidos/agregar");
                return;
            }

            if (fechaStr == null || fechaStr.trim().isEmpty()) {
                request.getSession().setAttribute("error", "Fecha es requerida");
                response.sendRedirect(request.getContextPath() + "/pedidos/agregar");
                return;
            }

            if (idCliente == null || idCliente.trim().isEmpty()) {
                request.getSession().setAttribute("error", "Cliente es requerido");
                response.sendRedirect(request.getContextPath() + "/pedidos/agregar");
                return;
            }

            if (productos == null || cantidades == null || productos.length == 0) {
                request.getSession().setAttribute("error", "Debe agregar al menos un producto al pedido");
                response.sendRedirect(request.getContextPath() + "/pedidos/agregar");
                return;
            }

            // Crear objeto Pedido
            Pedido pedido = new Pedido();
            pedido.setId_pedido(idPedido.trim());
            pedido.setFecha(Date.valueOf(fechaStr));
            pedido.setId_cliente(idCliente.trim());

            // Procesar productos y calcular totales
            List<DetallePedido> detalles = new ArrayList<>();
            BigDecimal subtotal = BigDecimal.ZERO;
            
            for (int i = 0; i < productos.length; i++) {
                if (productos[i] != null && !productos[i].trim().isEmpty() && 
                    cantidades[i] != null && !cantidades[i].trim().isEmpty()) {
                    
                    String prodId = productos[i].trim();
                    int cantidad = Integer.parseInt(cantidades[i].trim());
                    
                    if (cantidad <= 0) {
                        request.getSession().setAttribute("error", "Las cantidades deben ser mayores a 0");
                        response.sendRedirect(request.getContextPath() + "/pedidos/agregar");
                        return;
                    }
                    
                    // Obtener información del producto
                    Producto producto = productoDAO.obtenerProductoPorId(prodId);
                    if (producto == null) {
                        request.getSession().setAttribute("error", "Producto no encontrado: " + prodId);
                        response.sendRedirect(request.getContextPath() + "/pedidos/agregar");
                        return;
                    }
                    
                    // Verificar stock
                    if (cantidad > producto.getCantidad()) {
                        request.getSession().setAttribute("error", "Stock insuficiente para el producto: " + producto.getDescripcion());
                        response.sendRedirect(request.getContextPath() + "/pedidos/agregar");
                        return;
                    }
                    
                    // Crear detalle
                    DetallePedido detalle = new DetallePedido();
                    detalle.setId_pedido(idPedido.trim());
                    detalle.setId_prod(prodId);
                    detalle.setCantidad(cantidad);
                    detalle.setPrecio(producto.getPrecio());
                    
                    BigDecimal totalDetalle = producto.getPrecio().multiply(new BigDecimal(cantidad));
                    detalle.setTotal_deta(totalDetalle);
                    
                    detalles.add(detalle);
                    subtotal = subtotal.add(totalDetalle);
                }
            }

            if (detalles.isEmpty()) {
                request.getSession().setAttribute("error", "Debe agregar al menos un producto válido");
                response.sendRedirect(request.getContextPath() + "/pedidos/agregar");
                return;
            }

            // Calcular IGV y total
            BigDecimal igv = subtotal.multiply(new BigDecimal("0.18"));
            BigDecimal total = subtotal.add(igv);

            pedido.setSubtotal(subtotal);
            pedido.setTotalventa(total);

            // Guardar pedido
            boolean pedidoGuardado = pedidoDAO.guardarPedido(pedido);
            
            if (pedidoGuardado) {
                // Guardar detalles
                boolean detallesGuardados = detallePedidoDAO.guardarDetalles(pedido.getId_pedido(), detalles);
                
                if (detallesGuardados) {
                    // Actualizar stock de productos
                    for (DetallePedido detalle : detalles) {
                        productoDAO.actualizarStock(detalle.getId_prod(), detalle.getCantidad());
                    }
                    
                    request.getSession().setAttribute("success", "Pedido guardado exitosamente");
                } else {
                    // Si falló guardar detalles, eliminar el pedido
                    pedidoDAO.eliminarPedido(idPedido);
                    request.getSession().setAttribute("error", "Error al guardar los detalles del pedido");
                }
            } else {
                request.getSession().setAttribute("error", "Error al guardar el pedido");
            }

        } catch (NumberFormatException e) {
            request.getSession().setAttribute("error", "Error en los datos numéricos ingresados");
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Error al guardar el pedido: " + e.getMessage());
        }
        
        response.sendRedirect(request.getContextPath() + "/pedidos/listar");
    }

    private void actualizarPedido(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            String idPedido = request.getParameter("id_pedido");
            String fechaStr = request.getParameter("fecha");
            String idCliente = request.getParameter("id_cliente");
            
            String[] productos = request.getParameterValues("productos[]");
            String[] cantidades = request.getParameterValues("cantidades[]");
            String[] precios = request.getParameterValues("precios[]");

            if (productos == null || cantidades == null || precios == null) {
                request.getSession().setAttribute("error", "Debe agregar al menos un producto al pedido");
                response.sendRedirect(request.getContextPath() + "/pedidos/editar/" + idPedido);
                return;
            }

            Pedido pedido = new Pedido();
            pedido.setId_pedido(idPedido);
            pedido.setFecha(Date.valueOf(fechaStr));
            pedido.setId_cliente(idCliente);

            List<DetallePedido> detalles = new ArrayList<>();
            BigDecimal subtotal = BigDecimal.ZERO;
            
            for (int i = 0; i < productos.length; i++) {
                if (productos[i] != null && !productos[i].isEmpty()) {
                    DetallePedido detalle = new DetallePedido();
                    detalle.setId_pedido(idPedido);
                    detalle.setId_prod(productos[i]);
                    detalle.setCantidad(Integer.parseInt(cantidades[i]));
                    detalle.setPrecio(new BigDecimal(precios[i]));
                    detalle.calcularTotal();
                    
                    detalles.add(detalle);
                    subtotal = subtotal.add(detalle.getTotal_deta());
                }
            }

            BigDecimal igv = subtotal.multiply(new BigDecimal("0.18"));
            BigDecimal total = subtotal.add(igv);

            pedido.setSubtotal(subtotal);
            pedido.setTotalventa(total);

            boolean pedidoActualizado = pedidoDAO.actualizarPedido(pedido);
            
            if (pedidoActualizado) {
                boolean detallesActualizados = detallePedidoDAO.guardarDetalles(idPedido, detalles);
                
                if (detallesActualizados) {
                    request.getSession().setAttribute("success", "Pedido actualizado exitosamente");
                } else {
                    request.getSession().setAttribute("error", "Error al actualizar los detalles del pedido");
                }
            } else {
                request.getSession().setAttribute("error", "Error al actualizar el pedido");
            }

        } catch (NumberFormatException e) {
            request.getSession().setAttribute("error", "Error en los datos numéricos ingresados");
        } catch (Exception e) {
            request.getSession().setAttribute("error", "Error al actualizar el pedido: " + e.getMessage());
        }
        
        response.sendRedirect(request.getContextPath() + "/pedidos/listar");
    }

    private void eliminarPedido(HttpServletRequest request, HttpServletResponse response, String id) throws IOException {
        try {
            boolean detallesEliminados = detallePedidoDAO.eliminarDetallesPorPedido(id);
            
            if (detallesEliminados) {
                boolean pedidoEliminado = pedidoDAO.eliminarPedido(id);
                
                if (pedidoEliminado) {
                    request.getSession().setAttribute("success", "Pedido eliminado exitosamente");
                } else {
                    request.getSession().setAttribute("error", "Error al eliminar el pedido");
                }
            } else {
                request.getSession().setAttribute("error", "Error al eliminar los detalles del pedido");
            }
            
        } catch (Exception e) {
            request.getSession().setAttribute("error", "Error al eliminar el pedido: " + e.getMessage());
        }
        
        response.sendRedirect(request.getContextPath() + "/pedidos/listar");
    }
}
