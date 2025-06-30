package dao;

import modelo.DetallePedido;
import modelo.Producto;
import util.ConexionDB;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DetallePedidoDAO {

    // Consultas SQL
    private static final String SELECT_BY_PEDIDO = 
        "SELECT dp.*, p.descripcion, p.precio as precio_producto, p.cantidad as stock_producto, p.costo " +
        "FROM t_detalle_pedido dp " +
        "INNER JOIN t_producto p ON dp.id_prod = p.id_prod " +
        "WHERE dp.id_pedido = ? " +
        "ORDER BY dp.id_prod";
    
    private static final String INSERT = 
        "INSERT INTO t_detalle_pedido (id_pedido, id_prod, cantidad, precio, total_deta) " +
        "VALUES (?, ?, ?, ?, ?)";
    
    private static final String DELETE_BY_PEDIDO = 
        "DELETE FROM t_detalle_pedido WHERE id_pedido = ?";

    /**
     * Obtiene todos los detalles de un pedido
     */
    public List<DetallePedido> obtenerDetallesPorPedido(String idPedido) {
        List<DetallePedido> detalles = new ArrayList<>();
        
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(SELECT_BY_PEDIDO)) {
            
            ps.setString(1, idPedido);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    DetallePedido detalle = mapearDetalle(rs);
                    detalles.add(detalle);
                }
            }
            
        } catch (SQLException e) {
            System.err.println("Error al obtener detalles del pedido: " + e.getMessage());
            e.printStackTrace();
        }
        
        return detalles;
    }

    /**
     * Guarda múltiples detalles de un pedido
     */
    public boolean guardarDetalles(String idPedido, List<DetallePedido> detalles) {
        Connection conn = null;
        PreparedStatement ps = null;
        boolean exito = true;
        
        try {
            conn = ConexionDB.getConnection();
            conn.setAutoCommit(false); // Iniciar transacción
            
            // Primero eliminar detalles existentes
            eliminarDetallesPorPedido(idPedido);
            
            // Insertar nuevos detalles
            ps = conn.prepareStatement(INSERT);
            
            for (DetallePedido detalle : detalles) {
                ps.setString(1, idPedido);
                ps.setString(2, detalle.getId_prod());
                ps.setInt(3, detalle.getCantidad());
                ps.setBigDecimal(4, detalle.getPrecio());
                ps.setBigDecimal(5, detalle.getTotal_deta());
                ps.addBatch();
            }
            
            int[] resultados = ps.executeBatch();
            
            // Verificar que todos los detalles se guardaron correctamente
            for (int resultado : resultados) {
                if (resultado <= 0) {
                    exito = false;
                    break;
                }
            }
            
            if (exito) {
                conn.commit();
            } else {
                conn.rollback();
            }
            
        } catch (SQLException e) {
            System.err.println("Error al guardar detalles: " + e.getMessage());
            e.printStackTrace();
            exito = false;
            
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    System.err.println("Error al hacer rollback: " + ex.getMessage());
                }
            }
        } finally {
            try {
                if (ps != null) ps.close();
                if (conn != null) {
                    conn.setAutoCommit(true);
                    conn.close();
                }
            } catch (SQLException e) {
                System.err.println("Error al cerrar conexión: " + e.getMessage());
            }
        }
        
        return exito;
    }

    /**
     * Guarda un detalle de pedido individual
     */
    public boolean guardarDetalle(DetallePedido detalle) {
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(INSERT)) {
            
            ps.setString(1, detalle.getId_pedido());
            ps.setString(2, detalle.getId_prod());
            ps.setInt(3, detalle.getCantidad());
            ps.setBigDecimal(4, detalle.getPrecio());
            ps.setBigDecimal(5, detalle.getTotal_deta());
            
            int filasAfectadas = ps.executeUpdate();
            return filasAfectadas > 0;
            
        } catch (SQLException e) {
            System.err.println("Error al guardar detalle: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Elimina todos los detalles de un pedido
     */
    public boolean eliminarDetallesPorPedido(String idPedido) {
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(DELETE_BY_PEDIDO)) {
            
            ps.setString(1, idPedido);
            
            int filasAfectadas = ps.executeUpdate();
            return filasAfectadas >= 0; // Puede ser 0 si no hay detalles
            
        } catch (SQLException e) {
            System.err.println("Error al eliminar detalles: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Mapea un ResultSet a un objeto DetallePedido
     */
    private DetallePedido mapearDetalle(ResultSet rs) throws SQLException {
        DetallePedido detalle = new DetallePedido();
        detalle.setId_pedido(rs.getString("id_pedido"));
        detalle.setId_prod(rs.getString("id_prod"));
        detalle.setCantidad(rs.getInt("cantidad"));
        detalle.setPrecio(rs.getBigDecimal("precio"));
        detalle.setTotal_deta(rs.getBigDecimal("total_deta"));
        
        // Información del producto basada en el modelo correcto
        Producto producto = new Producto();
        producto.setId_prod(rs.getString("id_prod"));
        producto.setDescripcion(rs.getString("descripcion"));
        producto.setPrecio(rs.getBigDecimal("precio_producto"));
        producto.setCantidad(rs.getInt("stock_producto"));
        producto.setCosto(rs.getBigDecimal("costo"));
        
        detalle.setProducto(producto);
        
        return detalle;
    }
}
