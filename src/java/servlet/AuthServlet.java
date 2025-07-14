package servlet;

import dao.UsuarioDAO;
import dao.ClienteDAO;
import modelo.Usuario;
import modelo.Cliente;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.io.PrintWriter;

@WebServlet(urlPatterns = {"/login", "/logout", "/register", "/auth"})
public class AuthServlet extends HttpServlet {
    private final UsuarioDAO usuarioDAO = new UsuarioDAO();
    private final ClienteDAO clienteDAO = new ClienteDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String path = request.getServletPath();

        if ("/login".equals(path)) {
            String error = request.getParameter("error");
            String success = request.getParameter("success");
            
            if (error != null) {
                request.setAttribute("error", "DNI o contraseña incorrectos");
            }
            if (success != null) {
                request.setAttribute("success", "Usuario registrado exitosamente. Puede iniciar sesión.");
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
            
        } else if ("/auth".equals(path)) {
            // Manejar verificación de sesión para AJAX
            String action = request.getParameter("action");
            
            if ("checkSession".equals(action)) {
                checkSession(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Acción no válida");
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String path = request.getServletPath();

        if ("/login".equals(path)) {
    String dni = request.getParameter("dni");
    String password = request.getParameter("password");

    System.out.println("[DEBUG] Intentando login con DNI: " + dni);
    System.out.println("[DEBUG] Password ingresado (plain): " + password);

    // Primero verificar en tabla de usuarios
    Usuario usuario = usuarioDAO.obtenerUsuarioPorId(dni);
    
    if (usuario != null) {
        System.out.println("[DEBUG] Usuario encontrado: " + usuario.getId_usuario());
        System.out.println("[DEBUG] Estado del usuario: " + usuario.getEstado());

        if (usuario.getEstado() == 1) {
            String hashedPassword = usuarioDAO.hashPassword(password);

            System.out.println("[DEBUG] Password hasheado (input): " + hashedPassword);
            System.out.println("[DEBUG] Password almacenado (usuario): " + usuario.getPasswd());

            if (usuario.getPasswd().equals(hashedPassword)) {
                System.out.println("[DEBUG] Login de usuario exitoso");
                HttpSession session = request.getSession(true);
                session.setAttribute("usuario", usuario);
                session.setAttribute("username", usuario.getId_usuario());
                session.setAttribute("rol", usuario.getRol());
                session.setAttribute("tipoUsuario", "usuario");
                session.setMaxInactiveInterval(30 * 60); // 30 minutos

                response.sendRedirect(request.getContextPath() + "/dashboard.jsp");
                return;
            } else {
                System.out.println("[DEBUG] Contraseña de usuario no coincide");
            }
        } else {
            System.out.println("[DEBUG] Usuario inactivo");
        }
    } else {
        System.out.println("[DEBUG] Usuario no encontrado");
    }

    // Si no se encuentra en usuarios, verificar en clientes
    Cliente cliente = clienteDAO.obtenerClientePorDni(dni);

    if (cliente != null) {
        System.out.println("[DEBUG] Cliente encontrado: " + cliente.getDni());
        String hashedPassword = usuarioDAO.hashPassword(password);

        System.out.println("[DEBUG] Password hasheado (input): " + hashedPassword);
        System.out.println("[DEBUG] Password almacenado (cliente): " + cliente.getPasswd());

        if (cliente.getPasswd().equals(hashedPassword)) {
            System.out.println("[DEBUG] Login de cliente exitoso");
            HttpSession session = request.getSession(true);
            session.setAttribute("cliente", cliente);
            session.setAttribute("username", cliente.getNombres() + " " + cliente.getApellidos());

            session.setAttribute("rol", 99);
            session.setAttribute("tipoUsuario", "cliente");
            session.setAttribute("clienteId", cliente.getId_cliente());
            session.setMaxInactiveInterval(30 * 60); // 30 minutos

            response.sendRedirect(request.getContextPath() + "/productos");
            return;
        } else {
            System.out.println("[DEBUG] Contraseña de cliente no coincide");
        }
    } else {
        System.out.println("[DEBUG] Cliente no encontrado");
    }

    System.out.println("[DEBUG] Login fallido: DNI o contraseña incorrectos");
    request.setAttribute("error", "DNI o contraseña incorrectos");
    request.getRequestDispatcher("/login.jsp").forward(request, response);
}
 else if ("/register".equals(path)) {
            String tipoRegistro = request.getParameter("tipoRegistro");
            
            if ("usuario".equals(tipoRegistro)) {
                registrarUsuario(request, response);
            } else if ("cliente".equals(tipoRegistro)) {
                registrarCliente(request, response);
            } else {
                request.setAttribute("error", "Tipo de registro no válido");
                request.getRequestDispatcher("/register.jsp").forward(request, response);
            }
            
        } else if ("/auth".equals(path)) {
            // Manejar acciones de autenticación por AJAX
            String action = request.getParameter("action");
            
            if ("logout".equals(action)) {
                handleAjaxLogout(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Acción no válida");
            }
        }
    }
    
    /**
     * Registrar nuevo usuario del sistema
     */
    private void registrarUsuario(HttpServletRequest request, HttpServletResponse response) 
            throws IOException, ServletException {
        
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
        String rolParam = request.getParameter("rol");
        int rol = (rolParam != null && !rolParam.isEmpty()) ? Integer.parseInt(rolParam) : 2;
        nuevo.setRol(rol);

        boolean exito = usuarioDAO.guardarUsuario(nuevo);

        if (exito) {
            response.sendRedirect(request.getContextPath() + "/login?success=1");
        } else {
            request.setAttribute("error", "Error al registrar el usuario.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
        }
    }
    
    /**
     * Registrar nuevo cliente
     */
    private void registrarCliente(HttpServletRequest request, HttpServletResponse response) 
            throws IOException, ServletException {
        
        String nombres = request.getParameter("nombres");
        String apellidos = request.getParameter("apellidos");
        String dni = request.getParameter("dni");
        String email = request.getParameter("email");
        String telefono = request.getParameter("telefono");
        String movil = request.getParameter("movil");
        String direccion = request.getParameter("direccion");
        String password = request.getParameter("passwd");

        if (nombres == null || nombres.isEmpty() || 
            apellidos == null || apellidos.isEmpty() ||
            dni == null || dni.isEmpty() || 
            password == null || password.isEmpty()) {
            request.setAttribute("error", "Los campos nombres, apellidos, DNI y contraseña son obligatorios");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        // Verificar si el DNI ya existe en usuarios o clientes
        Usuario usuarioExistente = usuarioDAO.obtenerUsuarioPorId(dni);
        Cliente clienteExistente = clienteDAO.obtenerClientePorDni(dni);
        
        if (usuarioExistente != null || clienteExistente != null) {
            request.setAttribute("error", "El DNI ya está registrado en el sistema");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        Cliente nuevo = new Cliente();
        nuevo.setId_cliente(clienteDAO.generarNuevoId());
        nuevo.setNombres(nombres);
        nuevo.setApellidos(apellidos);
        nuevo.setDni(dni);
        nuevo.setEmail(email);
        nuevo.setTelefono(telefono);
        nuevo.setMovil(movil);
        nuevo.setDireccion(direccion);
        nuevo.setPasswd(usuarioDAO.hashPassword(password));

        boolean exito = clienteDAO.guardarCliente(nuevo);

        if (exito) {
            response.sendRedirect(request.getContextPath() + "/login?success=1");
        } else {
            request.setAttribute("error", "Error al registrar el cliente.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
        }
    }
    
    /**
     * Verifica si existe una sesión activa y devuelve respuesta JSON
     */
    private void checkSession(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        HttpSession session = request.getSession(false);
        boolean hasSession = session != null && session.getAttribute("username") != null;
        
        PrintWriter out = response.getWriter();
        
        if (hasSession) {
            // Actualizar el tiempo de última actividad
            session.setAttribute("lastActivity", System.currentTimeMillis());
            String tipoUsuario = (String) session.getAttribute("tipoUsuario");
            out.print("{\"hasSession\": true, \"username\": \"" + session.getAttribute("username") + "\", \"tipoUsuario\": \"" + tipoUsuario + "\"}");
        } else {
            out.print("{\"hasSession\": false}");
        }
        
        out.flush();
    }
    
    /**
     * Maneja logout por AJAX
     */
    private void handleAjaxLogout(HttpServletRequest request, HttpServletResponse response) 
        throws IOException {
    
        HttpSession session = request.getSession(false);
        String username = null;
        
        if (session != null) {
            username = (String) session.getAttribute("username");
            session.invalidate();
            System.out.println("Sesión cerrada para usuario: " + username + " (cierre automático)");
        }
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        PrintWriter out = response.getWriter();
        out.print("{\"success\": true, \"message\": \"Sesión cerrada correctamente\"}");
        out.flush();
    }
}
