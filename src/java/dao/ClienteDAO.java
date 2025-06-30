package dao;

import modelo.Cliente;
import util.ConexionDB;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ClienteDAO {
    private static final String SELECT_ALL_CLIENTES = "SELECT * FROM t_cliente ORDER BY nombres";
    private static final String SELECT_CLIENTE_BY_ID = "SELECT * FROM t_cliente WHERE id_cliente = ?";
    private static final String SELECT_CLIENTE_BY_DNI = "SELECT * FROM t_cliente WHERE dni = ?";
    private static final String INSERT_CLIENTE = "INSERT INTO t_cliente (id_cliente, apellidos, direccion, dni, movil, nombres, telefono) VALUES (?, ?, ?, ?, ?, ?, ?)";
    private static final String UPDATE_CLIENTE = "UPDATE t_cliente SET apellidos = ?, direccion = ?, dni = ?, movil = ?, nombres = ?, telefono = ? WHERE id_cliente = ?";
    private static final String DELETE_CLIENTE = "DELETE FROM t_cliente WHERE id_cliente = ?";
    private static final String COUNT_CLIENTES = "SELECT COUNT(*) FROM t_cliente";

    public List<Cliente> listarClientes() {
        List<Cliente> clientes = new ArrayList<>();
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(SELECT_ALL_CLIENTES);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Cliente c = new Cliente();
                c.setId_cliente(rs.getString("id_cliente"));
                c.setApellidos(rs.getString("apellidos"));
                c.setDireccion(rs.getString("direccion"));
                c.setDni(rs.getString("dni"));
                c.setMovil(rs.getString("movil"));
                c.setNombres(rs.getString("nombres"));
                c.setTelefono(rs.getString("telefono"));
                clientes.add(c);
            }

        } catch (SQLException e) {
            System.err.println("Error al listar clientes: " + e.getMessage());
        }
        return clientes;
    }

    public Cliente obtenerClientePorId(String id) {
        Cliente cliente = null;
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(SELECT_CLIENTE_BY_ID)) {
            
            ps.setString(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    cliente = new Cliente();
                    cliente.setId_cliente(rs.getString("id_cliente"));
                    cliente.setApellidos(rs.getString("apellidos"));
                    cliente.setDireccion(rs.getString("direccion"));
                    cliente.setDni(rs.getString("dni"));
                    cliente.setMovil(rs.getString("movil"));
                    cliente.setNombres(rs.getString("nombres"));
                    cliente.setTelefono(rs.getString("telefono"));
                }
            }
        } catch (SQLException e) {
            System.err.println("Error al obtener cliente por ID: " + e.getMessage());
        }
        return cliente;
    }

    public Cliente obtenerClientePorDni(String dni) {
        Cliente cliente = null;
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(SELECT_CLIENTE_BY_DNI)) {
            
            ps.setString(1, dni);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    cliente = new Cliente();
                    cliente.setId_cliente(rs.getString("id_cliente"));
                    cliente.setApellidos(rs.getString("apellidos"));
                    cliente.setDireccion(rs.getString("direccion"));
                    cliente.setDni(rs.getString("dni"));
                    cliente.setMovil(rs.getString("movil"));
                    cliente.setNombres(rs.getString("nombres"));
                    cliente.setTelefono(rs.getString("telefono"));
                }
            }
        } catch (SQLException e) {
            System.err.println("Error al obtener cliente por DNI: " + e.getMessage());
        }
        return cliente;
    }

    public Cliente obtenerClientePorRuc(String ruc) {
        Cliente cliente = null;
        String sql = "SELECT * FROM t_cliente WHERE dni = ?";
        
        try (Connection conn = ConexionDB.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, ruc);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    cliente = new Cliente();
                    cliente.setId_cliente(rs.getString("id_cliente"));
                    cliente.setApellidos(rs.getString("apellidos"));
                    cliente.setDireccion(rs.getString("direccion"));
                    cliente.setDni(rs.getString("dni"));
                    cliente.setMovil(rs.getString("movil"));
                    cliente.setNombres(rs.getString("nombres"));
                    cliente.setTelefono(rs.getString("telefono"));
                }
            }
        } catch (SQLException e) {
            System.err.println("Error al obtener cliente por RUC: " + e.getMessage());
        }
        return cliente;
    }


    public boolean guardarCliente(Cliente cliente) {
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(INSERT_CLIENTE)) {
            
            ps.setString(1, cliente.getId_cliente());
            ps.setString(2, cliente.getApellidos());
            ps.setString(3, cliente.getDireccion());
            ps.setString(4, cliente.getDni());
            ps.setString(5, cliente.getMovil());
            ps.setString(6, cliente.getNombres());
            ps.setString(7, cliente.getTelefono());
            
            return ps.executeUpdate() > 0;
            
        } catch (SQLException e) {
            System.err.println("Error al guardar cliente: " + e.getMessage());
            return false;
        }
    }

    public boolean actualizarCliente(Cliente cliente) {
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(UPDATE_CLIENTE)) {
            
            ps.setString(1, cliente.getApellidos());
            ps.setString(2, cliente.getDireccion());
            ps.setString(3, cliente.getDni());
            ps.setString(4, cliente.getMovil());
            ps.setString(5, cliente.getNombres());
            ps.setString(6, cliente.getTelefono());
            ps.setString(7, cliente.getId_cliente());
            
            return ps.executeUpdate() > 0;
            
        } catch (SQLException e) {
            System.err.println("Error al actualizar cliente: " + e.getMessage());
            return false;
        }
    }

    public boolean eliminarCliente(String id) {
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(DELETE_CLIENTE)) {
            
            ps.setString(1, id);
            return ps.executeUpdate() > 0;
            
        } catch (SQLException e) {
            System.err.println("Error al eliminar cliente: " + e.getMessage());
            return false;
        }
    }

    public int contarClientes() {
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(COUNT_CLIENTES);
             ResultSet rs = ps.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
            
        } catch (SQLException e) {
            System.err.println("Error al contar clientes: " + e.getMessage());
        }
        return 0;
    }

    // Método para generar nuevo ID de cliente
    public String generarNuevoId() {
        String nuevoId = "CLI001";
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement ps = conn.prepareStatement("SELECT MAX(CAST(SUBSTRING(id_cliente, 4) AS UNSIGNED)) FROM t_cliente WHERE id_cliente LIKE 'CLI%'");
             ResultSet rs = ps.executeQuery()) {
            
            if (rs.next()) {
                int ultimoNumero = rs.getInt(1);
                nuevoId = String.format("CLI%03d", ultimoNumero + 1);
            }
            
        } catch (SQLException e) {
            System.err.println("Error al generar nuevo ID: " + e.getMessage());
        }
        return nuevoId;
    }
}
