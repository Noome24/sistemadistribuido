package dao;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import modelo.Usuario;
import util.ConexionDB;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UsuarioDAO {
    private static final String SELECT_ALL_USUARIOS = "SELECT * FROM t_usuario ORDER BY id_usuario";
    private static final String SELECT_USUARIO_BY_ID = "SELECT * FROM t_usuario WHERE id_usuario = ?";
    private static final String SELECT_USUARIO_BY_CREDENTIALS = "SELECT * FROM t_usuario WHERE id_usuario = ? AND passwd = ? AND estado = 1";
    private static final String INSERT_USUARIO = "INSERT INTO t_usuario (id_usuario, estado, passwd, rol) VALUES (?, ?, ?, ?)";
    private static final String UPDATE_USUARIO = "UPDATE t_usuario SET estado = ?, passwd = ?, rol = ? WHERE id_usuario = ?";
    private static final String DELETE_USUARIO = "DELETE FROM t_usuario WHERE id_usuario = ?";
    private static final String UPDATE_PASSWORD = "UPDATE t_usuario SET passwd = ? WHERE id_usuario = ?";
    private static final String COUNT_USUARIOS = "SELECT COUNT(*) FROM t_usuario";

    public List<Usuario> listarUsuarios() {
        List<Usuario> usuarios = new ArrayList<>();
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(SELECT_ALL_USUARIOS);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Usuario u = new Usuario();
                u.setId_usuario(rs.getString("id_usuario"));
                u.setEstado(rs.getInt("estado"));
                u.setPasswd(rs.getString("passwd"));
                u.setRol(rs.getInt("rol"));
                usuarios.add(u);
            }

        } catch (SQLException e) {
            System.err.println("Error al listar usuarios: " + e.getMessage());
        }
        return usuarios;
    }

    public Usuario obtenerUsuarioPorId(String id) {
        Usuario usuario = null;
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(SELECT_USUARIO_BY_ID)) {
            
            ps.setString(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    usuario = new Usuario();
                    usuario.setId_usuario(rs.getString("id_usuario"));
                    usuario.setEstado(rs.getInt("estado"));
                    usuario.setPasswd(rs.getString("passwd"));
                    usuario.setRol(rs.getInt("rol"));
                }
            }
        } catch (SQLException e) {
            System.err.println("Error al obtener usuario por ID: " + e.getMessage());
        }
        return usuario;
    }

    public Usuario validarCredenciales(String idUsuario, String password) {
        Usuario usuario = null;
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(SELECT_USUARIO_BY_CREDENTIALS)) {
            
            ps.setString(1, idUsuario);
            ps.setString(2, password);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    usuario = new Usuario();
                    usuario.setId_usuario(rs.getString("id_usuario"));
                    usuario.setEstado(rs.getInt("estado"));
                    usuario.setPasswd(rs.getString("passwd"));
                    usuario.setRol(rs.getInt("rol"));
                }
            }
        } catch (SQLException e) {
            System.err.println("Error al validar credenciales: " + e.getMessage());
        }
        return usuario;
    }

    public boolean guardarUsuario(Usuario usuario) {
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(INSERT_USUARIO)) {
            
            ps.setString(1, usuario.getId_usuario());
            ps.setInt(2, usuario.getEstado());
            ps.setString(3, usuario.getPasswd());
            ps.setInt(4, usuario.getRol());
            
            return ps.executeUpdate() > 0;
            
        } catch (SQLException e) {
            System.err.println("Error al guardar usuario: " + e.getMessage());
            return false;
        }
    }

    public boolean actualizarUsuario(Usuario usuario) {
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(UPDATE_USUARIO)) {
            
            ps.setInt(1, usuario.getEstado());
            ps.setString(2, usuario.getPasswd());
            ps.setInt(3, usuario.getRol());
            ps.setString(4, usuario.getId_usuario());
            
            return ps.executeUpdate() > 0;
            
        } catch (SQLException e) {
            System.err.println("Error al actualizar usuario: " + e.getMessage());
            return false;
        }
    }

    public boolean eliminarUsuario(String id) {
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(DELETE_USUARIO)) {
            
            ps.setString(1, id);
            return ps.executeUpdate() > 0;
            
        } catch (SQLException e) {
            System.err.println("Error al eliminar usuario: " + e.getMessage());
            return false;
        }
    }

    public boolean cambiarPassword(String idUsuario, String nuevaPassword) {
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(UPDATE_PASSWORD)) {
            
            ps.setString(1, nuevaPassword);
            ps.setString(2, idUsuario);
            
            return ps.executeUpdate() > 0;
            
        } catch (SQLException e) {
            System.err.println("Error al cambiar password: " + e.getMessage());
            return false;
        }
    }

    public int contarUsuarios() {
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(COUNT_USUARIOS);
             ResultSet rs = ps.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
            
        } catch (SQLException e) {
            System.err.println("Error al contar usuarios: " + e.getMessage());
        }
        return 0;
    }

    // Método para generar nuevo ID de usuario
    public String generarNuevoId() {
        String nuevoId = "USR001";
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement ps = conn.prepareStatement("SELECT MAX(CAST(SUBSTRING(id_usuario, 4) AS UNSIGNED)) FROM t_usuario WHERE id_usuario LIKE 'USR%'");
             ResultSet rs = ps.executeQuery()) {
            
            if (rs.next()) {
                int ultimoNumero = rs.getInt(1);
                nuevoId = String.format("USR%03d", ultimoNumero + 1);
            }
            
        } catch (SQLException e) {
            System.err.println("Error al generar nuevo ID: " + e.getMessage());
        }
        return nuevoId;
    }

    // Método para verificar si existe un usuario
    public boolean existeUsuario(String id) {
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(SELECT_USUARIO_BY_ID)) {
            
            ps.setString(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            System.err.println("Error al verificar existencia de usuario: " + e.getMessage());
            return false;
        }
    }
    
    public String hashPassword(String password) {
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] encodedHash = digest.digest(password.getBytes(java.nio.charset.StandardCharsets.UTF_8));

            StringBuilder hexString = new StringBuilder();
            for (byte b : encodedHash) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) hexString.append('0');
                hexString.append(hex);
            }

            return hexString.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("Error al hashear la contraseña", e);
        }
    }

}
