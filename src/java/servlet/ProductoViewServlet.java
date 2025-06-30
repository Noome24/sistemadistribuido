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
import java.math.BigDecimal;
import java.util.List;

@WebServlet({"/productos", "/productos/listar", "/productos/agregar", "/productos/editar/*", "/productos/eliminar/*", "/productos/guardar", "/productos/actualizar"})
public class ProductoViewServlet extends HttpServlet {
    private final ProductoDAO productoDAO = new ProductoDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Verificar sesión
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String path = request.getServletPath();
        String pathInfo = request.getPathInfo();

        try {
            switch (path) {
                case "/productos":
                    mostrarIndex(request, response);
                    break;
                case "/productos/listar":
                    listarProductos(request, response);
                    break;
                case "/productos/agregar":
                    mostrarFormularioAgregar(request, response);
                    break;
                case "/productos/editar":
                    if (pathInfo != null && pathInfo.length() > 1) {
                        String id = pathInfo.substring(1);
                        mostrarFormularioEditar(request, response, id);
                    } else {
                        response.sendRedirect(request.getContextPath() + "/productos");
                    }
                    break;
                case "/productos/eliminar":
                    if (pathInfo != null && pathInfo.length() > 1) {
                        String id = pathInfo.substring(1);
                        eliminarProducto(request, response, id);
                    } else {
                        response.sendRedirect(request.getContextPath() + "/productos");
                    }
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/productos");
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Error interno del servidor: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/productos");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Verificar sesión
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String path = request.getServletPath();

        try {
            switch (path) {
                case "/productos/guardar":
                    guardarProducto(request, response);
                    break;
                case "/productos/actualizar":
                    actualizarProducto(request, response);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/productos");
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Error interno del servidor: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/productos");
        }
    }

    private void mostrarIndex(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/productos/index.jsp").forward(request, response);
    }

    private void listarProductos(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Producto> productos = productoDAO.listarProductos();
        request.setAttribute("productos", productos);
        request.getRequestDispatcher("/productos/listar.jsp").forward(request, response);
    }

    private void mostrarFormularioAgregar(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/productos/agregar.jsp").forward(request, response);
    }

    private void mostrarFormularioEditar(HttpServletRequest request, HttpServletResponse response, String id) throws ServletException, IOException {
        Producto producto = productoDAO.obtenerProductoPorId(id);
        if (producto != null) {
            request.setAttribute("producto", producto);
            request.getRequestDispatcher("/productos/editar.jsp").forward(request, response);
        } else {
            request.getSession().setAttribute("error", "Producto no encontrado");
            response.sendRedirect(request.getContextPath() + "/productos/listar");
        }
    }

    private void guardarProducto(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            Producto producto = new Producto();
            
            // Generar ID automáticamente
            producto.setId_prod(productoDAO.generarNuevoId());
            producto.setCantidad(Integer.parseInt(request.getParameter("cantidad")));
            producto.setCosto(new BigDecimal(request.getParameter("costo")));
            producto.setPrecio(new BigDecimal(request.getParameter("precio")));
            producto.setDescripcion(request.getParameter("descripcion"));

            // Validaciones
            if (producto.getCosto().compareTo(BigDecimal.ZERO) <= 0) {
                request.getSession().setAttribute("error", "El costo debe ser mayor a 0");
                response.sendRedirect(request.getContextPath() + "/productos/agregar");
                return;
            }

            if (producto.getPrecio().compareTo(producto.getCosto()) <= 0) {
                request.getSession().setAttribute("error", "El precio debe ser mayor al costo");
                response.sendRedirect(request.getContextPath() + "/productos/agregar");
                return;
            }

            boolean success = productoDAO.guardarProducto(producto);
            
            if (success) {
                request.getSession().setAttribute("success", "Producto guardado exitosamente");
            } else {
                request.getSession().setAttribute("error", "Error al guardar el producto");
            }
            
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("error", "Error en los datos numéricos ingresados");
        } catch (Exception e) {
            request.getSession().setAttribute("error", "Error al guardar el producto: " + e.getMessage());
        }
        
        response.sendRedirect(request.getContextPath() + "/productos/listar");
    }

    private void actualizarProducto(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            Producto producto = new Producto();
            producto.setId_prod(request.getParameter("id_prod"));
            producto.setCantidad(Integer.parseInt(request.getParameter("cantidad")));
            producto.setCosto(new BigDecimal(request.getParameter("costo")));
            producto.setPrecio(new BigDecimal(request.getParameter("precio")));
            producto.setDescripcion(request.getParameter("descripcion"));

            // Validaciones
            if (producto.getCosto().compareTo(BigDecimal.ZERO) <= 0) {
                request.getSession().setAttribute("error", "El costo debe ser mayor a 0");
                response.sendRedirect(request.getContextPath() + "/productos/editar/" + producto.getId_prod());
                return;
            }

            if (producto.getPrecio().compareTo(producto.getCosto()) <= 0) {
                request.getSession().setAttribute("error", "El precio debe ser mayor al costo");
                response.sendRedirect(request.getContextPath() + "/productos/editar/" + producto.getId_prod());
                return;
            }

            boolean success = productoDAO.actualizarProducto(producto);
            
            if (success) {
                request.getSession().setAttribute("success", "Producto actualizado exitosamente");
            } else {
                request.getSession().setAttribute("error", "Error al actualizar el producto");
            }
            
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("error", "Error en los datos numéricos ingresados");
        } catch (Exception e) {
            request.getSession().setAttribute("error", "Error al actualizar el producto: " + e.getMessage());
        }
        
        response.sendRedirect(request.getContextPath() + "/productos/listar");
    }

    private void eliminarProducto(HttpServletRequest request, HttpServletResponse response, String id) throws IOException {
        try {
            boolean success = productoDAO.eliminarProducto(id);
            
            if (success) {
                request.getSession().setAttribute("success", "Producto eliminado exitosamente");
            } else {
                request.getSession().setAttribute("error", "Error al eliminar el producto");
            }
            
        } catch (Exception e) {
            request.getSession().setAttribute("error", "Error al eliminar el producto: " + e.getMessage());
        }
        
        response.sendRedirect(request.getContextPath() + "/productos/listar");
    }
}
