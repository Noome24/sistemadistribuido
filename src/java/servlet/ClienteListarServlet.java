package servlet;

import dao.ClienteDAO;
import modelo.Cliente;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/clientes/listar")
public class ClienteListarServlet extends HttpServlet {
    private final ClienteDAO clienteDAO = new ClienteDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Verificar autenticación
        HttpSession session = request.getSession(false);
        if (session == null || (session.getAttribute("usuario") == null && session.getAttribute("cliente") == null)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            List<Cliente> clientes = clienteDAO.listarClientes();
            request.setAttribute("clientes", clientes);
            request.getRequestDispatcher("/clientes/listar.jsp").forward(request, response);
        } catch (Exception e) {
            // En caso de error, se puede redirigir a una página de error o mostrar un mensaje
            request.setAttribute("error", "Error al listar los clientes: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/clientes/listar.jsp?error=1");

        }
    }
}
