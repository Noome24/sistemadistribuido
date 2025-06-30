package servlet;

import dao.UsuarioDAO;
import modelo.Usuario;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet(urlPatterns = {"/login", "/logout", "/register"})
public class AuthServlet extends HttpServlet {
    private final UsuarioDAO usuarioDAO = new UsuarioDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String path = request.getServletPath();

        if ("/login".equals(path)) {
            String error = request.getParameter("error");
            if (error != null) {
                request.setAttribute("error", "Usuario o contraseña incorrectos");
            }
            request.getRequestDispatcher("/login.jsp").forward(request, response);

        } else if ("/logout".equals(path)) {
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.invalidate();
            }
            response.sendRedirect(request.getContextPath() + "/login");

        } else if ("/register".equals(path)) {
            // Mostrar formulario de registro
            request.getRequestDispatcher("/register.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String path = request.getServletPath();

        if ("/login".equals(path)) {
            String username = request.getParameter("username");
            String password = request.getParameter("password");

            Usuario usuario = usuarioDAO.obtenerUsuarioPorId(username);

            if (usuario != null && usuario.getEstado() == 1) {
                String hashedPassword = usuarioDAO.hashPassword(password);

                if (usuario.getPasswd().equals(hashedPassword)) {
                    HttpSession session = request.getSession(true);
                    session.setAttribute("usuario", usuario);
                    session.setAttribute("username", usuario.getId_usuario());
                    session.setAttribute("rol", usuario.getRol());

                    response.sendRedirect(request.getContextPath() + "/dashboard.jsp");
                    return;
                }
            }

            request.setAttribute("error", "Usuario o contraseña incorrectos");
            request.getRequestDispatcher("/login.jsp").forward(request, response);

        } else if ("/register".equals(path)) {
            // Procesar registro
            String idUsuario = request.getParameter("idUsuario");
            String password = request.getParameter("passwd");

            if (idUsuario == null || idUsuario.isEmpty() || password == null || password.isEmpty()) {
                request.setAttribute("error", "Todos los campos son obligatorios");
                request.getRequestDispatcher("/register.jsp").forward(request, response);
                return;
            }


            Usuario existente = usuarioDAO.obtenerUsuarioPorId(idUsuario);
            if (existente != null) {
                request.setAttribute("error", "El nombre de usuario ya está en uso");
                request.getRequestDispatcher("/register.jsp").forward(request, response);
                return;
            }

            Usuario nuevo = new Usuario();
            nuevo.setId_usuario(idUsuario);
            nuevo.setPasswd(usuarioDAO.hashPassword(password));
            nuevo.setEstado(1);   // activo por defecto
            nuevo.setRol(3);      // rol default, ajústalo según necesites

            boolean exito = usuarioDAO.guardarUsuario(nuevo);

            if (exito) {
                response.sendRedirect(request.getContextPath() + "/login?success=1");
            } else {
                request.setAttribute("error", "Error al registrar el usuario.");
                request.getRequestDispatcher("/register.jsp").forward(request, response);
            }
        }
    }
}
