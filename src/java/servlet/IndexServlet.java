package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "IndexServlet", urlPatterns = {"/index"})
public class IndexServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Verificar si hay sesión activa
        HttpSession session = request.getSession(false);
        
        if (session != null && session.getAttribute("username") != null) {
            // Hay sesión activa, redirigir al dashboard
            response.sendRedirect(request.getContextPath() + "/dashboard.jsp");
        } else {
            // No hay sesión activa, redirigir al login
            response.sendRedirect(request.getContextPath() + "/login");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Redirigir POST requests al método GET
        doGet(request, response);
    }
}
