package dao;

import modelo.Pedido;
import modelo.Cliente;
import util.ConexionDB;
import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PedidoDAO {
    
    // Consultas SQL
    private static final String SELECT_ALL = 
        "SELECT p.id_pedido, p.fecha, p.subtotal, p.totalventa, p.id_cliente, " +
        "c.nombres, c.apellidos, c.dni " +
        "FROM t_pedido p " +
        "LEFT JOIN t_cliente c ON p.id_cliente = c.id_cliente " +
        "ORDER BY p.fecha DESC";
    
    private static final String SELECT_BY_ID = 
        "SELECT p.id_pedido, p.fecha, p.subtotal, p.totalventa, p.id_cliente, " +
        "c.nombres, c.apellidos, c.dni, c.direccion " +
        "FROM t_pedido p " +
        "LEFT JOIN t_cliente c ON p.id_cliente = c.id_cliente " +
        "WHERE p.id_pedido = ?";
    
    private static final String SELECT_BY_CLIENTE = 
        "SELECT p.id_pedido, p.fecha, p.subtotal, p.totalventa, p.id_cliente, " +
        "c.nombres, c.apellidos, c.dni " +
        "FROM t_pedido p " +
        "LEFT JOIN t_cliente c ON p.id_cliente = c.id_cliente " +
        "WHERE p.id_cliente = ? " +
        "ORDER BY p.fecha DESC";
    
    private static final String INSERT = 
        "INSERT INTO t_pedido (id_pedido, fecha, subtotal, totalventa, id_cliente) " +
        "VALUES (?, ?, ?, ?, ?)";
    
    private static final String UPDATE = 
        "UPDATE t_pedido SET fecha = ?, subtotal = ?, totalventa = ?, id_cliente = ? " +
        "WHERE id_pedido = ?";
    
    private static final String DELETE = "DELETE FROM t_pedido WHERE id_pedido = ?";
    
    private static final String COUNT = "SELECT COUNT(*) FROM t_pedido";
    
    private static final String VENTAS_HOY = 
        "SELECT COALESCE(SUM(totalventa), 0) FROM t_pedido WHERE DATE(fecha) = CURDATE()";
    
    private static final String VENTAS_MES = 
        "SELECT COALESCE(SUM(totalventa), 0) FROM t_pedido " +
        "WHERE YEAR(fecha) = YEAR(CURDATE()) AND MONTH(fecha) = MONTH(CURDATE())";
    
    private static final String GENERATE_ID = 
        "SELECT MAX(CAST(SUBSTRING(id_pedido, 4) AS UNSIGNED)) FROM t_pedido " +
        "WHERE id_pedido LIKE 'PED%'";

    /**
     * Lista todos los pedidos con información del cliente
     */
    public List<Pedido> listarPedidos() {
        List<Pedido> pedidos = new ArrayList<>();
        
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(SELECT_ALL);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Pedido pedido = mapearPedido(rs);
                pedidos.add(pedido);
            }
            
        } catch (SQLException e) {
            System.err.println("Error al listar pedidos: " + e.getMessage());
            e.printStackTrace();
        }
        
        return pedidos;
    }

    /**
     * Obtiene un pedido por su ID
     */
    public Pedido obtenerPedidoPorId(String id) {
        Pedido pedido = null;
        
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(SELECT_BY_ID)) {
            
            ps.setString(1, id);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    pedido = mapearPedidoCompleto(rs);
                }
            }
            
        } catch (SQLException e) {
            System.err.println("Error al obtener pedido por ID: " + e.getMessage());
            e.printStackTrace();
        }
        
        return pedido;
    }

    /**
     * Obtiene pedidos por cliente
     */
    public List<Pedido> obtenerPedidosPorCliente(String idCliente) {
        List<Pedido> pedidos = new ArrayList<>();
        
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(SELECT_BY_CLIENTE)) {
            
            ps.setString(1, idCliente);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Pedido pedido = mapearPedido(rs);
                    pedidos.add(pedido);
                }
            }
            
        } catch (SQLException e) {
            System.err.println("Error al obtener pedidos por cliente: " + e.getMessage());
            e.printStackTrace();
        }
        
        return pedidos;
    }

    /**
     * Guarda un nuevo pedido
     */
    public boolean guardarPedido(Pedido pedido) {
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(INSERT)) {
            
            ps.setString(1, pedido.getId_pedido());
            ps.setDate(2, pedido.getFecha());
            ps.setBigDecimal(3, pedido.getSubtotal());
            ps.setBigDecimal(4, pedido.getTotalventa());
            ps.setString(5, pedido.getId_cliente());
            
            int filasAfectadas = ps.executeUpdate();
            return filasAfectadas > 0;
            
        } catch (SQLException e) {
            System.err.println("Error al guardar pedido: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Actualiza un pedido existente
     */
    public boolean actualizarPedido(Pedido pedido) {
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(UPDATE)) {
            
            ps.setDate(1, pedido.getFecha());
            ps.setBigDecimal(2, pedido.getSubtotal());
            ps.setBigDecimal(3, pedido.getTotalventa());
            ps.setString(4, pedido.getId_cliente());
            ps.setString(5, pedido.getId_pedido());
            
            int filasAfectadas = ps.executeUpdate();
            return filasAfectadas > 0;
            
        } catch (SQLException e) {
            System.err.println("Error al actualizar pedido: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Elimina un pedido
     */
    public boolean eliminarPedido(String id) {
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(DELETE)) {
            
            ps.setString(1, id);
            
            int filasAfectadas = ps.executeUpdate();
            return filasAfectadas > 0;
            
        } catch (SQLException e) {
            System.err.println("Error al eliminar pedido: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Cuenta el total de pedidos
     */
    public int contarPedidos() {
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(COUNT);
             ResultSet rs = ps.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
            
        } catch (SQLException e) {
            System.err.println("Error al contar pedidos: " + e.getMessage());
            e.printStackTrace();
        }
        
        return 0;
    }

    /**
     * Obtiene las ventas del día actual
     */
    public BigDecimal obtenerVentasHoy() {
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(VENTAS_HOY);
             ResultSet rs = ps.executeQuery()) {
            
            if (rs.next()) {
                return rs.getBigDecimal(1);
            }
            
        } catch (SQLException e) {
            System.err.println("Error al obtener ventas de hoy: " + e.getMessage());
            e.printStackTrace();
        }
        
        return BigDecimal.ZERO;
    }

    /**
     * Obtiene las ventas del mes actual
     */
    public BigDecimal obtenerVentasMes() {
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(VENTAS_MES);
             ResultSet rs = ps.executeQuery()) {
            
            if (rs.next()) {
                return rs.getBigDecimal(1);
            }
            
        } catch (SQLException e) {
            System.err.println("Error al obtener ventas del mes: " + e.getMessage());
            e.printStackTrace();
        }
        
        return BigDecimal.ZERO;
    }

    /**
     * Genera un nuevo ID para pedido
     */
    public String generarNuevoId() {
        String nuevoId = "PED001";
        
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(GENERATE_ID);
             ResultSet rs = ps.executeQuery()) {
            
            if (rs.next()) {
                int ultimoNumero = rs.getInt(1);
                nuevoId = String.format("PED%03d", ultimoNumero + 1);
            }
            
        } catch (SQLException e) {
            System.err.println("Error al generar nuevo ID: " + e.getMessage());
            e.printStackTrace();
        }
        
        return nuevoId;
    }

    /**
     * Mapea un ResultSet a un objeto Pedido (información básica)
     */
    private Pedido mapearPedido(ResultSet rs) throws SQLException {
        Pedido pedido = new Pedido();
        pedido.setId_pedido(rs.getString("id_pedido"));
        pedido.setFecha(rs.getDate("fecha"));
        pedido.setSubtotal(rs.getBigDecimal("subtotal"));
        pedido.setTotalventa(rs.getBigDecimal("totalventa"));
        pedido.setId_cliente(rs.getString("id_cliente"));
        
        // Información básica del cliente (solo si existe)
        String nombres = rs.getString("nombres");
        if (nombres != null) {
            Cliente cliente = new Cliente();
            cliente.setId_cliente(rs.getString("id_cliente"));
            cliente.setNombres(nombres);
            cliente.setApellidos(rs.getString("apellidos"));
            cliente.setDni(rs.getString("dni"));
            pedido.setCliente(cliente);
        }
        
        return pedido;
    }

    /**
     * Mapea un ResultSet a un objeto Pedido (información completa)
     */
    private Pedido mapearPedidoCompleto(ResultSet rs) throws SQLException {
        Pedido pedido = new Pedido();
        pedido.setId_pedido(rs.getString("id_pedido"));
        pedido.setFecha(rs.getDate("fecha"));
        pedido.setSubtotal(rs.getBigDecimal("subtotal"));
        pedido.setTotalventa(rs.getBigDecimal("totalventa"));
        pedido.setId_cliente(rs.getString("id_cliente"));
        
        // Información completa del cliente (solo si existe)
        String nombres = rs.getString("nombres");
        if (nombres != null) {
            Cliente cliente = new Cliente();
            cliente.setId_cliente(rs.getString("id_cliente"));
            cliente.setNombres(nombres);
            cliente.setApellidos(rs.getString("apellidos"));
            cliente.setDni(rs.getString("dni"));
            cliente.setDireccion(rs.getString("direccion"));
            pedido.setCliente(cliente);
        }
        
        return pedido;
    }
}
