package servlet;

import dao.UsuarioDAO;
import modelo.Usuario;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {"/usuarios", "/usuarios/listar", "/usuarios/agregar", "/usuarios/editar/*", "/usuarios/eliminar/*"})
public class UsuarioViewServlet extends HttpServlet {
    private final UsuarioDAO usuarioDAO = new UsuarioDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        // Verificar sesión
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String path = request.getServletPath();
        String pathInfo = request.getPathInfo();

        try {
            if ("/usuarios".equals(path)) {
                mostrarIndex(request, response);
            } else if ("/usuarios/listar".equals(path)) {
                listarUsuarios(request, response);
            } else if ("/usuarios/agregar".equals(path)) {
                mostrarFormularioAgregar(request, response);
            } else if ("/usuarios/editar".equals(path) && pathInfo != null) {
                String id = pathInfo.substring(1);
                mostrarFormularioEditar(request, response, id);
            } else if ("/usuarios/eliminar".equals(path) && pathInfo != null) {
                String id = pathInfo.substring(1);
                eliminarUsuario(request, response, id);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error interno del servidor: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        // Verificar sesión
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String path = request.getServletPath();

        try {
            if ("/usuarios/agregar".equals(path)) {
                procesarAgregar(request, response);
            } else if ("/usuarios/editar".equals(path)) {
                procesarEditar(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error interno del servidor: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }

    private void mostrarIndex(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/usuarios/index.jsp").forward(request, response);
    }

    private void listarUsuarios(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Usuario> usuarios = usuarioDAO.listarUsuarios();
        request.setAttribute("usuarios", usuarios);
        request.getRequestDispatcher("/usuarios/listar.jsp").forward(request, response);
    }

    private void mostrarFormularioAgregar(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/usuarios/agregar.jsp").forward(request, response);
    }

    private void mostrarFormularioEditar(HttpServletRequest request, HttpServletResponse response, String id) throws ServletException, IOException {
        Usuario usuario = usuarioDAO.obtenerUsuarioPorId(id);
        if (usuario != null) {
            request.setAttribute("usuario", usuario);
            request.getRequestDispatcher("/usuarios/editar.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Usuario no encontrado");
            listarUsuarios(request, response);
        }
    }

    private void procesarAgregar(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idUsuario = request.getParameter("id_usuario");
        String passwd = request.getParameter("passwd");
        String rolStr = request.getParameter("rol");
        String estadoStr = request.getParameter("estado");

        // Validaciones
        if (idUsuario == null || idUsuario.trim().isEmpty()) {
            request.setAttribute("error", "El ID de usuario es obligatorio");
            request.getRequestDispatcher("/usuarios/agregar.jsp").forward(request, response);
            return;
        }

        if (passwd == null || passwd.trim().isEmpty()) {
            request.setAttribute("error", "La contraseña es obligatoria");
            request.getRequestDispatcher("/usuarios/agregar.jsp").forward(request, response);
            return;
        }

        if (idUsuario.length() < 3) {
            request.setAttribute("error", "El ID de usuario debe tener al menos 3 caracteres");
            request.getRequestDispatcher("/usuarios/agregar.jsp").forward(request, response);
            return;
        }

        if (passwd.length() < 6) {
            request.setAttribute("error", "La contraseña debe tener al menos 6 caracteres");
            request.getRequestDispatcher("/usuarios/agregar.jsp").forward(request, response);
            return;
        }

        // Verificar si el usuario ya existe
        Usuario existente = usuarioDAO.obtenerUsuarioPorId(idUsuario);
        if (existente != null) {
            request.setAttribute("error", "Ya existe un usuario con ese ID");
            request.getRequestDispatcher("/usuarios/agregar.jsp").forward(request, response);
            return;
        }

        try {
            int rol = Integer.parseInt(rolStr);
            int estado = Integer.parseInt(estadoStr);

            if (rol < 1 || rol > 2) {
                request.setAttribute("error", "El rol debe ser 1 (Administrador) o 2 (Vendedor)");
                request.getRequestDispatcher("/usuarios/agregar.jsp").forward(request, response);
                return;
            }

            if (estado < 0 || estado > 1) {
                request.setAttribute("error", "El estado debe ser 0 (Inactivo) o 1 (Activo)");
                request.getRequestDispatcher("/usuarios/agregar.jsp").forward(request, response);
                return;
            }

            Usuario usuario = new Usuario();
            usuario.setId_usuario(idUsuario.trim());
            usuario.setPasswd(usuarioDAO.hashPassword(passwd));
            usuario.setRol(rol);
            usuario.setEstado(estado);

            boolean exito = usuarioDAO.guardarUsuario(usuario);

            if (exito) {
                request.setAttribute("success", "Usuario agregado exitosamente");
                listarUsuarios(request, response);
            } else {
                request.setAttribute("error", "Error al agregar el usuario");
                request.getRequestDispatcher("/usuarios/agregar.jsp").forward(request, response);
            }

        } catch (NumberFormatException e) {
            request.setAttribute("error", "Rol y estado deben ser números válidos");
            request.getRequestDispatcher("/usuarios/agregar.jsp").forward(request, response);
        }
    }

    private void procesarEditar(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idUsuario = request.getParameter("id_usuario");
        String rolStr = request.getParameter("rol");
        String estadoStr = request.getParameter("estado");
        String nuevaPasswd = request.getParameter("nueva_passwd");

        // Validaciones
        if (idUsuario == null || idUsuario.trim().isEmpty()) {
            request.setAttribute("error", "ID de usuario inválido");
            listarUsuarios(request, response);
            return;
        }

        Usuario usuario = usuarioDAO.obtenerUsuarioPorId(idUsuario);
        if (usuario == null) {
            request.setAttribute("error", "Usuario no encontrado");
            listarUsuarios(request, response);
            return;
        }

        try {
            int rol = Integer.parseInt(rolStr);
            int estado = Integer.parseInt(estadoStr);

            if (rol < 1 || rol > 2) {
                request.setAttribute("error", "El rol debe ser 1 (Administrador) o 2 (Vendedor)");
                request.setAttribute("usuario", usuario);
                request.getRequestDispatcher("/usuarios/editar.jsp").forward(request, response);
                return;
            }

            if (estado < 0 || estado > 1) {
                request.setAttribute("error", "El estado debe ser 0 (Inactivo) o 1 (Activo)");
                request.setAttribute("usuario", usuario);
                request.getRequestDispatcher("/usuarios/editar.jsp").forward(request, response);
                return;
            }

            usuario.setRol(rol);
            usuario.setEstado(estado);

            // Si se proporciona nueva contraseña, actualizarla
            if (nuevaPasswd != null && !nuevaPasswd.trim().isEmpty()) {
                if (nuevaPasswd.length() < 6) {
                    request.setAttribute("error", "La nueva contraseña debe tener al menos 6 caracteres");
                    request.setAttribute("usuario", usuario);
                    request.getRequestDispatcher("/usuarios/editar.jsp").forward(request, response);
                    return;
                }
                usuario.setPasswd(usuarioDAO.hashPassword(nuevaPasswd));
            }

            boolean exito = usuarioDAO.actualizarUsuario(usuario);

            if (exito) {
                request.setAttribute("success", "Usuario actualizado exitosamente");
                listarUsuarios(request, response);
            } else {
                request.setAttribute("error", "Error al actualizar el usuario");
                request.setAttribute("usuario", usuario);
                request.getRequestDispatcher("/usuarios/editar.jsp").forward(request, response);
            }

        } catch (NumberFormatException e) {
            request.setAttribute("error", "Rol y estado deben ser números válidos");
            request.setAttribute("usuario", usuario);
            request.getRequestDispatcher("/usuarios/editar.jsp").forward(request, response);
        }
    }

    private void eliminarUsuario(HttpServletRequest request, HttpServletResponse response, String id) throws ServletException, IOException {
        // Verificar que no se elimine a sí mismo
        HttpSession session = request.getSession();
        Usuario usuarioActual = (Usuario) session.getAttribute("usuario");
        
        if (usuarioActual != null && usuarioActual.getId_usuario().equals(id)) {
            request.setAttribute("error", "No puedes eliminar tu propio usuario");
            listarUsuarios(request, response);
            return;
        }

        Usuario usuario = usuarioDAO.obtenerUsuarioPorId(id);
        if (usuario == null) {
            request.setAttribute("error", "Usuario no encontrado");
            listarUsuarios(request, response);
            return;
        }

        boolean exito = usuarioDAO.eliminarUsuario(id);

        if (exito) {
            request.setAttribute("success", "Usuario eliminado exitosamente");
        } else {
            request.setAttribute("error", "Error al eliminar el usuario");
        }

        listarUsuarios(request, response);
    }
}
