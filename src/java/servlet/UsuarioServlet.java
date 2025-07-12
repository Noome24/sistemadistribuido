package servlet;

import dao.UsuarioDAO;
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

import com.google.gson.Gson;

@WebServlet("/api/usuarios/*")
public class UsuarioServlet extends HttpServlet {
    private final UsuarioDAO usuarioDAO = new UsuarioDAO();
    private final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String pathInfo = request.getPathInfo();
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        // Verificar autenticación y permisos de administrador
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            Map<String, String> error = new HashMap<>();
            error.put("error", "No autorizado");
            response.getWriter().write(gson.toJson(error));
            return;
        }

        Usuario usuarioSesion = (Usuario) session.getAttribute("usuario");
        if (usuarioSesion.getRol() != 0) { // Solo admin y superadmin
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            Map<String, String> error = new HashMap<>();
            error.put("error", "Permisos insuficientes");
            response.getWriter().write(gson.toJson(error));
            return;
        }

        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                // Listar todos los usuarios
                List<Usuario> usuarios = usuarioDAO.listarUsuarios();
                // Ocultar contraseñas en la respuesta
                usuarios.forEach(u -> u.setPasswd("***"));
                response.getWriter().write(gson.toJson(usuarios));
                
            } else if (pathInfo.equals("/count")) {
                // Contar usuarios
                int count = usuarioDAO.contarUsuarios();
                Map<String, Integer> result = new HashMap<>();
                result.put("count", count);
                response.getWriter().write(gson.toJson(result));
                
            } else if (pathInfo.startsWith("/")) {
                // Obtener usuario por ID
                String id = pathInfo.substring(1);
                Usuario usuario = usuarioDAO.obtenerUsuarioPorId(id);
                
                if (usuario != null) {
                    usuario.setPasswd("***"); // Ocultar contraseña
                    response.getWriter().write(gson.toJson(usuario));
                } else {
                    response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                    Map<String, String> error = new HashMap<>();
                    error.put("error", "Usuario no encontrado");
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

        // Verificar autenticación y permisos
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            Map<String, String> error = new HashMap<>();
            error.put("error", "No autorizado");
            response.getWriter().write(gson.toJson(error));
            return;
        }

        Usuario usuarioSesion = (Usuario) session.getAttribute("usuario");
        if (usuarioSesion.getRol() != 0) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            Map<String, String> error = new HashMap<>();
            error.put("error", "Permisos insuficientes");
            response.getWriter().write(gson.toJson(error));
            return;
        }

        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                // Crear nuevo usuario
                Usuario usuario = gson.fromJson(request.getReader(), Usuario.class);
                
                // Generar ID si no se proporciona
                if (usuario.getId_usuario() == null || usuario.getId_usuario().isEmpty()) {
                    usuario.setId_usuario(usuarioDAO.generarNuevoId());
                }
                
                // Verificar si el usuario ya existe
                if (usuarioDAO.existeUsuario(usuario.getId_usuario())) {
                    response.setStatus(HttpServletResponse.SC_CONFLICT);
                    Map<String, String> error = new HashMap<>();
                    error.put("error", "El usuario ya existe");
                    response.getWriter().write(gson.toJson(error));
                    return;
                }
                
                boolean success = usuarioDAO.guardarUsuario(usuario);
                Map<String, Object> result = new HashMap<>();
                
                if (success) {
                    result.put("success", true);
                    result.put("message", "Usuario guardado exitosamente");
                    usuario.setPasswd("***"); // Ocultar contraseña en respuesta
                    result.put("usuario", usuario);
                    response.setStatus(HttpServletResponse.SC_CREATED);
                } else {
                    result.put("success", false);
                    result.put("message", "Error al guardar usuario");
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                }
                
                response.getWriter().write(gson.toJson(result));
                
            } else if (pathInfo.equals("/cambiar-password")) {
                // Cambiar contraseña
                Map<String, Object> requestData = gson.fromJson(request.getReader(), Map.class);
                String idUsuario = (String) requestData.get("idUsuario");
                String nuevaPassword = (String) requestData.get("nuevaPassword");
                
                boolean success = usuarioDAO.cambiarPassword(idUsuario, nuevaPassword);
                Map<String, Object> result = new HashMap<>();
                
                if (success) {
                    result.put("success", true);
                    result.put("message", "Contraseña actualizada exitosamente");
                } else {
                    result.put("success", false);
                    result.put("message", "Error al actualizar contraseña");
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

        // Verificar autenticación y permisos
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            Map<String, String> error = new HashMap<>();
            error.put("error", "No autorizado");
            response.getWriter().write(gson.toJson(error));
            return;
        }

        Usuario usuarioSesion = (Usuario) session.getAttribute("usuario");
        if (usuarioSesion.getRol() !=0) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            Map<String, String> error = new HashMap<>();
            error.put("error", "Permisos insuficientes");
            response.getWriter().write(gson.toJson(error));
            return;
        }

        try {
            if (pathInfo != null && pathInfo.startsWith("/")) {
                // Actualizar usuario
                String id = pathInfo.substring(1);
                Usuario usuario = gson.fromJson(request.getReader(), Usuario.class);
                usuario.setId_usuario(id);
                
                boolean success = usuarioDAO.actualizarUsuario(usuario);
                Map<String, Object> result = new HashMap<>();
                
                if (success) {
                    result.put("success", true);
                    result.put("message", "Usuario actualizado exitosamente");
                    usuario.setPasswd("***"); // Ocultar contraseña
                    result.put("usuario", usuario);
                } else {
                    result.put("success", false);
                    result.put("message", "Error al actualizar usuario");
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

        // Verificar autenticación y permisos
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            Map<String, String> error = new HashMap<>();
            error.put("error", "No autorizado");
            response.getWriter().write(gson.toJson(error));
            return;
        }

        Usuario usuarioSesion = (Usuario) session.getAttribute("usuario");
        if (usuarioSesion.getRol() !=0) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            Map<String, String> error = new HashMap<>();
            error.put("error", "Permisos insuficientes");
            response.getWriter().write(gson.toJson(error));
            return;
        }

        try {
            if (pathInfo != null && pathInfo.startsWith("/")) {
                // Eliminar usuario
                String id = pathInfo.substring(1);
                
                // No permitir que un usuario se elimine a sí mismo
                if (id.equals(usuarioSesion.getId_usuario())) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    Map<String, String> error = new HashMap<>();
                    error.put("error", "No puedes eliminar tu propio usuario");
                    response.getWriter().write(gson.toJson(error));
                    return;
                }
                
                boolean success = usuarioDAO.eliminarUsuario(id);
                Map<String, Object> result = new HashMap<>();
                
                if (success) {
                    result.put("success", true);
                    result.put("message", "Usuario eliminado exitosamente");
                } else {
                    result.put("success", false);
                    result.put("message", "Error al eliminar usuario");
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
