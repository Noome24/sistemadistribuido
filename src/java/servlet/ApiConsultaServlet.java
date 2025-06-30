package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.HashMap;
import java.util.Map;

import com.google.gson.Gson;

@WebServlet("/api/consulta/*")
public class ApiConsultaServlet extends HttpServlet {
    private static final String API_TOKEN = "apis-token-16568.dvoFwkvVqa1SerBezSX6SyvV0ss9SAID";
    private static final String RENIEC_URL = "https://api.apis.net.pe/v2/reniec/dni?numero=";
    private static final String SUNAT_URL = "https://api.apis.net.pe/v2/sunat/ruc?numero=";
    private final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        // Verificar autenticación
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            Map<String, String> error = new HashMap<>();
            error.put("error", "No autorizado");
            response.getWriter().write(gson.toJson(error));
            return;
        }

        String pathInfo = request.getPathInfo();
        if (pathInfo == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            Map<String, String> error = new HashMap<>();
            error.put("error", "Ruta no especificada");
            response.getWriter().write(gson.toJson(error));
            return;
        }

        try {
            if (pathInfo.startsWith("/dni/")) {
                String dni = pathInfo.substring("/dni/".length());
                if (dni.length() == 8 && dni.matches("\\d+")) {
                    Map<String, Object> resultado = consultarDNI(dni);
                    response.getWriter().write(gson.toJson(resultado));
                } else {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    Map<String, String> error = new HashMap<>();
                    error.put("error", "DNI debe tener 8 dígitos");
                    response.getWriter().write(gson.toJson(error));
                }
            } else if (pathInfo.startsWith("/ruc/")) {
                String ruc = pathInfo.substring("/ruc/".length());
                if (ruc.length() == 11 && ruc.matches("\\d+")) {
                    Map<String, Object> resultado = consultarRUC(ruc);
                    response.getWriter().write(gson.toJson(resultado));
                } else {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    Map<String, String> error = new HashMap<>();
                    error.put("error", "RUC debe tener 11 dígitos");
                    response.getWriter().write(gson.toJson(error));
                }
            } else {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                Map<String, String> error = new HashMap<>();
                error.put("error", "Endpoint no encontrado");
                response.getWriter().write(gson.toJson(error));
            }
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            Map<String, String> error = new HashMap<>();
            error.put("error", "Error interno: " + e.getMessage());
            response.getWriter().write(gson.toJson(error));
        }
    }

    private Map<String, Object> consultarDNI(String dni) throws IOException {
        URL url = new URL(RENIEC_URL + dni);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        
        conn.setRequestMethod("GET");
        conn.setRequestProperty("Accept", "application/json");
        conn.setRequestProperty("Authorization", "Bearer " + API_TOKEN);
        
        int responseCode = conn.getResponseCode();
        
        if (responseCode == 200) {
            BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getInputStream()));
            StringBuilder response = new StringBuilder();
            String line;
            
            while ((line = reader.readLine()) != null) {
                response.append(line);
            }
            reader.close();
            
            // Parsear la respuesta JSON
            @SuppressWarnings("unchecked")
            Map<String, Object> data = gson.fromJson(response.toString(), Map.class);
            
            Map<String, Object> resultado = new HashMap<>();
            resultado.put("success", true);
            resultado.put("data", data);
            
            return resultado;
        } else {
            Map<String, Object> resultado = new HashMap<>();
            resultado.put("success", false);
            resultado.put("error", "No se pudo consultar el DNI");
            return resultado;
        }
    }

    private Map<String, Object> consultarRUC(String ruc) throws IOException {
        URL url = new URL(SUNAT_URL + ruc);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        
        conn.setRequestMethod("GET");
        conn.setRequestProperty("Accept", "application/json");
        conn.setRequestProperty("Authorization", "Bearer " + API_TOKEN);
        
        int responseCode = conn.getResponseCode();
        
        if (responseCode == 200) {
            BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getInputStream()));
            StringBuilder response = new StringBuilder();
            String line;
            
            while ((line = reader.readLine()) != null) {
                response.append(line);
            }
            reader.close();
            
            // Parsear la respuesta JSON
            @SuppressWarnings("unchecked")
            Map<String, Object> data = gson.fromJson(response.toString(), Map.class);
            
            Map<String, Object> resultado = new HashMap<>();
            resultado.put("success", true);
            resultado.put("data", data);
            
            return resultado;
        } else {
            Map<String, Object> resultado = new HashMap<>();
            resultado.put("success", false);
            resultado.put("error", "No se pudo consultar el RUC");
            return resultado;
        }
    }
}
