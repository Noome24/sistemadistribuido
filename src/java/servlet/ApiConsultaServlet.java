package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import com.google.gson.Gson;
import com.google.gson.JsonObject;

import java.io.IOException;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/api/consulta/*")
public class ApiConsultaServlet extends HttpServlet {
    
    private static final String API_TOKEN = "apis-token-16568.dvoFwkvVqa1SerBezSX6SyvV0ss9SAID";
    private static final String RENIEC_URL = "https://api.apis.net.pe/v2/reniec/dni";
    private static final String SUNAT_URL = "https://api.apis.net.pe/v2/sunat/ruc";
    
    private final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Verificar sesión
        HttpSession session = request.getSession(false);
        if (session == null || (session.getAttribute("usuario") == null && session.getAttribute("cliente") == null)) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("error", "Sesión expirada");
            errorResponse.put("redirect", request.getContextPath() + "/login");
            
            response.getWriter().write(gson.toJson(errorResponse));
            return;
        }

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        String pathInfo = request.getPathInfo();
        
        if (pathInfo == null) {
            sendErrorResponse(response, "Ruta no especificada");
            return;
        }

        try {
            if (pathInfo.startsWith("/dni/")) {
                String dni = pathInfo.substring(5);
                consultarDNI(dni, response);
            } else if (pathInfo.startsWith("/ruc/")) {
                String ruc = pathInfo.substring(5);
                consultarRUC(ruc, response);
            } else {
                sendErrorResponse(response, "Ruta no válida");
            }
        } catch (Exception e) {
            e.printStackTrace();
            sendErrorResponse(response, "Error interno del servidor: " + e.getMessage());
        }
    }

    private void consultarDNI(String dni, HttpServletResponse response) throws IOException {
        // Validar DNI
        if (dni == null || !dni.matches("\\d{8}")) {
            sendErrorResponse(response, "DNI debe tener exactamente 8 dígitos");
            return;
        }

        try {
            String apiUrl = RENIEC_URL + "?numero=" + dni;
            String apiResponse = makeApiCall(apiUrl);
            
            if (apiResponse != null) {
                // Parsear respuesta de la API
                JsonObject jsonResponse = gson.fromJson(apiResponse, JsonObject.class);
                
                Map<String, Object> result = new HashMap<>();
                result.put("success", true);
                result.put("data", jsonResponse);
                
                response.getWriter().write(gson.toJson(result));
            } else {
                sendErrorResponse(response, "No se pudo consultar el DNI en este momento");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            sendErrorResponse(response, "Error al consultar DNI: " + e.getMessage());
        }
    }

    private void consultarRUC(String ruc, HttpServletResponse response) throws IOException {
        // Validar RUC
        if (ruc == null || !ruc.matches("\\d{11}")) {
            sendErrorResponse(response, "RUC debe tener exactamente 11 dígitos");
            return;
        }

        try {
            String apiUrl = SUNAT_URL + "?numero=" + ruc;
            String apiResponse = makeApiCall(apiUrl);
            
            if (apiResponse != null) {
                // Parsear respuesta de la API
                JsonObject jsonResponse = gson.fromJson(apiResponse, JsonObject.class);
                
                Map<String, Object> result = new HashMap<>();
                result.put("success", true);
                result.put("data", jsonResponse);
                
                response.getWriter().write(gson.toJson(result));
            } else {
                sendErrorResponse(response, "No se pudo consultar el RUC en este momento");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            sendErrorResponse(response, "Error al consultar RUC: " + e.getMessage());
        }
    }

    private String makeApiCall(String apiUrl) {
        try {
            URL url = new URL(apiUrl);
            HttpURLConnection connection = (HttpURLConnection) url.openConnection();
            
            // Configurar headers
            connection.setRequestMethod("GET");
            connection.setRequestProperty("Accept", "application/json");
            connection.setRequestProperty("Authorization", "Bearer " + API_TOKEN);
            connection.setConnectTimeout(10000); // 10 segundos
            connection.setReadTimeout(10000); // 10 segundos
            
            int responseCode = connection.getResponseCode();
            
            if (responseCode == HttpURLConnection.HTTP_OK) {
                BufferedReader reader = new BufferedReader(
                    new InputStreamReader(connection.getInputStream(), "UTF-8"));
                StringBuilder response = new StringBuilder();
                String line;
                
                while ((line = reader.readLine()) != null) {
                    response.append(line);
                }
                reader.close();
                
                return response.toString();
            } else {
                System.err.println("Error en API call: " + responseCode);
                return null;
            }
            
        } catch (Exception e) {
            System.err.println("Error al hacer llamada a API: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }

    private void sendErrorResponse(HttpServletResponse response, String message) throws IOException {
        Map<String, Object> errorResponse = new HashMap<>();
        errorResponse.put("success", false);
        errorResponse.put("error", message);
        
        response.getWriter().write(gson.toJson(errorResponse));
    }
}
