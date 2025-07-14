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
        "SELECT p.id_pedido, p.fecha, p.subtotal, p.totalventa, p.id_cliente, p.estado, " +
        "c.nombres, c.apellidos, c.dni " +
        "FROM t_pedido p " +
        "LEFT JOIN t_cliente c ON p.id_cliente = c.id_cliente " +
        "ORDER BY p.fecha DESC";
    
    private static final String SELECT_BY_ID = 
        "SELECT p.id_pedido, p.fecha, p.subtotal, p.totalventa, p.id_cliente, p.estado, " +
        "c.nombres, c.apellidos, c.dni, c.direccion " +
        "FROM t_pedido p " +
        "LEFT JOIN t_cliente c ON p.id_cliente = c.id_cliente " +
        "WHERE p.id_pedido = ?";
    
    private static final String SELECT_BY_CLIENTE = 
        "SELECT p.id_pedido, p.fecha, p.subtotal, p.totalventa, p.id_cliente, p.estado, " +
        "c.nombres, c.apellidos, c.dni " +
        "FROM t_pedido p " +
        "LEFT JOIN t_cliente c ON p.id_cliente = c.id_cliente " +
        "WHERE p.id_cliente = ? " +
        "ORDER BY p.fecha DESC";
    
    private static final String INSERT = 
        "INSERT INTO t_pedido (id_pedido, fecha, subtotal, totalventa, id_cliente, estado) " +
        "VALUES (?, ?, ?, ?, ?, ?)";
    
    private static final String UPDATE = 
        "UPDATE t_pedido SET fecha = ?, subtotal = ?, totalventa = ?, id_cliente = ?, estado = ? " +
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

    // Nuevas consultas para estado y transportista
    private static final String UPDATE_ESTADO = 
        "UPDATE t_pedido SET estado = ? WHERE id_pedido = ?";

    private static final String SELECT_BY_ESTADO = 
        "SELECT p.id_pedido, p.fecha, p.subtotal, p.totalventa, p.id_cliente, p.estado, " +
        "c.nombres, c.apellidos, c.dni " +
        "FROM t_pedido p " +
        "LEFT JOIN t_cliente c ON p.id_cliente = c.id_cliente " +
        "WHERE p.estado = ? " +
        "ORDER BY p.fecha DESC";

    private static final String SELECT_BY_TRANSPORTISTA = 
        "SELECT p.id_pedido, p.fecha, p.subtotal, p.totalventa, p.id_cliente, p.estado, " +
        "c.nombres, c.apellidos, c.dni, a.fecha_asignacion " +
        "FROM t_pedido p " +
        "LEFT JOIN t_cliente c ON p.id_cliente = c.id_cliente " +
        "INNER JOIN t_asignacion_pedido a ON p.id_pedido = a.id_pedido " +
        "WHERE a.id_transportista = ? " +
        "ORDER BY p.fecha DESC";

    private static final String ASIGNAR_TRANSPORTISTA = 
        "INSERT INTO t_asignacion_pedido (id_pedido, id_transportista) VALUES (?, ?) " +
        "ON DUPLICATE KEY UPDATE fecha_asignacion = CURRENT_TIMESTAMP";

    private static final String OBTENER_TRANSPORTISTA = 
        "SELECT a.id_transportista, u.id_usuario " +
        "FROM t_asignacion_pedido a " +
        "INNER JOIN t_usuario u ON a.id_transportista = u.id_usuario " +
        "WHERE a.id_pedido = ?";

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
            ps.setInt(6, pedido.getEstado());
            
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
            ps.setInt(5, pedido.getEstado());
            ps.setString(6, pedido.getId_pedido());
            
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
        pedido.setEstado(rs.getInt("estado"));
        
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
        pedido.setEstado(rs.getInt("estado"));
        
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

    /**
     * Actualiza el estado de un pedido
     */
    public boolean actualizarEstado(String idPedido, int estado) {
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(UPDATE_ESTADO)) {
            
            ps.setInt(1, estado);
            ps.setString(2, idPedido);
            
            int filasAfectadas = ps.executeUpdate();
            return filasAfectadas > 0;
            
        } catch (SQLException e) {
            System.err.println("Error al actualizar estado del pedido: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Obtiene pedidos por estado
     */
    public List<Pedido> obtenerPedidosPorEstado(int estado) {
        List<Pedido> pedidos = new ArrayList<>();
        
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(SELECT_BY_ESTADO)) {
            
            ps.setInt(1, estado);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Pedido pedido = mapearPedidoConEstado(rs);
                    pedidos.add(pedido);
                }
            }
            
        } catch (SQLException e) {
            System.err.println("Error al obtener pedidos por estado: " + e.getMessage());
            e.printStackTrace();
        }
        
        return pedidos;
    }

    /**
     * Obtiene pedidos asignados a un transportista
     */
    public List<Pedido> obtenerPedidosPorTransportista(String idTransportista) {
        List<Pedido> pedidos = new ArrayList<>();
        
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(SELECT_BY_TRANSPORTISTA)) {
            
            ps.setString(1, idTransportista);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Pedido pedido = mapearPedidoConEstado(rs);
                    pedidos.add(pedido);
                }
            }
            
        } catch (SQLException e) {
            System.err.println("Error al obtener pedidos por transportista: " + e.getMessage());
            e.printStackTrace();
        }
        
        return pedidos;
    }

    /**
     * Asigna un transportista a un pedido
     */
    public boolean asignarTransportista(String idPedido, String idTransportista) {
        try (Connection conn = ConexionDB.getConnection()) {
            conn.setAutoCommit(false);
            
            try {
                // Insertar/actualizar asignación
                try (PreparedStatement ps = conn.prepareStatement(ASIGNAR_TRANSPORTISTA)) {
                    ps.setString(1, idPedido);
                    ps.setString(2, idTransportista);
                    ps.executeUpdate();
                }
                
                // Actualizar estado del pedido a "asignado" (3)
                try (PreparedStatement ps = conn.prepareStatement(UPDATE_ESTADO)) {
                    ps.setInt(1, 3);
                    ps.setString(2, idPedido);
                    ps.executeUpdate();
                }
                
                conn.commit();
                return true;
                
            } catch (SQLException e) {
                conn.rollback();
                throw e;
            }
            
        } catch (SQLException e) {
            System.err.println("Error al asignar transportista: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Obtiene el transportista asignado a un pedido
     */
    public String obtenerTransportistaAsignado(String idPedido) {
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(OBTENER_TRANSPORTISTA)) {
            
            ps.setString(1, idPedido);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("id_transportista");
                }
            }
            
        } catch (SQLException e) {
            System.err.println("Error al obtener transportista asignado: " + e.getMessage());
            e.printStackTrace();
        }
        
        return null;
    }

    /**
     * Obtiene todos los pedidos con información de transportista asignado
     */
    public List<Pedido> listarPedidosConTransportista() {
        List<Pedido> pedidos = new ArrayList<>();
        
        String sql = "SELECT p.id_pedido, p.fecha, p.subtotal, p.totalventa, p.id_cliente, p.estado, " +
                "c.nombres, c.apellidos, c.dni, " +
                "a.id_transportista " +
                "FROM t_pedido p " +
                "LEFT JOIN t_cliente c ON p.id_cliente = c.id_cliente " +
                "LEFT JOIN t_asignacion_pedido a ON p.id_pedido = a.id_pedido " +
                "ORDER BY p.fecha DESC";
    
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
        
            while (rs.next()) {
                Pedido pedido = mapearPedido(rs);
                // Agregar información del transportista si existe
                String transportistaId = rs.getString("id_transportista");
                if (transportistaId != null) {
                    pedido.setTransportistaAsignado(transportistaId);
                }
                pedidos.add(pedido);
            }
        
        } catch (SQLException e) {
            System.err.println("Error al listar pedidos con transportista: " + e.getMessage());
            e.printStackTrace();
        }
    
        return pedidos;
    }

    /**
     * Verifica si un pedido puede ser editado por el rol actual
     */
    public boolean puedeEditarPedido(String idPedido, int rolUsuario) {
        // Solo admins (0) y usuarios normales (1) pueden editar
        if (rolUsuario == 0 || rolUsuario == 1) {
            return true;
        }
    
        // Transportistas (3), recepcionistas (2) y clientes (99) no pueden editar
        return false;
    }

    /**
     * Verifica si un pedido puede ser eliminado por el rol actual
     */
    public boolean puedeEliminarPedido(String idPedido, int rolUsuario) {
        // Solo admins (0) y usuarios normales (1) pueden eliminar
        if (rolUsuario == 0 || rolUsuario == 1) {
            return true;
        }
    
        return false;
    }

    /**
     * Mapea un ResultSet a un objeto Pedido incluyendo estado
     */
    private Pedido mapearPedidoConEstado(ResultSet rs) throws SQLException {
        Pedido pedido = new Pedido();
        pedido.setId_pedido(rs.getString("id_pedido"));
        pedido.setFecha(rs.getDate("fecha"));
        pedido.setSubtotal(rs.getBigDecimal("subtotal"));
        pedido.setTotalventa(rs.getBigDecimal("totalventa"));
        pedido.setId_cliente(rs.getString("id_cliente"));
        pedido.setEstado(rs.getInt("estado"));
        
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
}
