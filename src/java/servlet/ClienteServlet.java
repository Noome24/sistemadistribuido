package servlet;

import dao.ClienteDAO;
import modelo.Cliente;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/api/clientes/*")

public class ClienteServlet extends HttpServlet {
    private final ClienteDAO clienteDAO = new ClienteDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getPathInfo();

        if (path == null || path.equals("/")) {
            response.sendRedirect(request.getContextPath() + "/clientes/");
            return;
        }

        if (path.equals("/listar")) {
            List<Cliente> clientes = clienteDAO.listarClientes();
            request.setAttribute("clientes", clientes);
            request.getRequestDispatcher("/clientes/listar.jsp").forward(request, response);

        } else if (path.equals("/agregar")) {
            request.getRequestDispatcher("/clientes/formulario.jsp").forward(request, response);

        } else if (path.startsWith("/editar/")) {
            String id = path.substring("/editar/".length());
            Cliente cliente = clienteDAO.obtenerClientePorId(id);
            if (cliente != null) {
                request.setAttribute("cliente", cliente);
                request.getRequestDispatcher("/clientes/editar.jsp").forward(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Cliente no encontrado");
            }

        } else if (path.startsWith("/eliminar/")) {
            String id = path.substring("/eliminar/".length());
            boolean success = clienteDAO.eliminarCliente(id);
            response.sendRedirect(request.getContextPath() + "/clientes/listar?eliminado=" + success);

        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getPathInfo();

        if (path == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        switch (path) {
            case "/guardar": {
                Cliente cliente = crearClienteDesdeRequest(request);

                if (cliente.getId_cliente() == null || cliente.getId_cliente().isEmpty()) {
                    cliente.setId_cliente(clienteDAO.generarNuevoId());
                }

                boolean success = clienteDAO.guardarCliente(cliente);

                if (success) {
                    response.sendRedirect(request.getContextPath() + "/clientes/listar");
                } else {
                    response.sendRedirect(request.getContextPath() + "/clientes/listar");
                }
                break;
            }

            case "/actualizar": {
                Cliente cliente = crearClienteDesdeRequest(request);
                boolean success = clienteDAO.actualizarCliente(cliente);

                if (success) {
                    response.sendRedirect(request.getContextPath() + "/clientes/listar");
                } else {
                    response.sendRedirect(request.getContextPath() + "/clientes/listar");
                }
                break;
            }

            case "/buscar-dni": {
                String dni = request.getParameter("dni");
                Cliente cliente = clienteDAO.obtenerClientePorDni(dni);
                request.setAttribute("cliente", cliente);
                request.getRequestDispatcher("/clientes/formulario.jsp").forward(request, response);
                break;
            }

            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private Cliente crearClienteDesdeRequest(HttpServletRequest request) {
        Cliente cliente = new Cliente();
        cliente.setId_cliente(request.getParameter("id_cliente"));
        cliente.setDni(request.getParameter("dni"));
        cliente.setNombres(request.getParameter("nombres"));
        cliente.setApellidos(request.getParameter("apellidos"));
        cliente.setDireccion(request.getParameter("direccion"));
        cliente.setTelefono(request.getParameter("telefono"));
        cliente.setMovil(request.getParameter("movil"));
        return cliente;
    }
}
