package dao;

import modelo.Producto;
import util.ConexionDB;
import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProductoDAO {
    private static final String SELECT_ALL_PRODUCTOS = "SELECT * FROM t_producto ORDER BY descripcion";
    private static final String SELECT_PRODUCTO_BY_ID = "SELECT * FROM t_producto WHERE id_prod = ?";
    private static final String INSERT_PRODUCTO = "INSERT INTO t_producto (id_prod, cantidad, costo, descripcion, precio) VALUES (?, ?, ?, ?, ?)";
    private static final String UPDATE_PRODUCTO = "UPDATE t_producto SET cantidad = ?, costo = ?, descripcion = ?, precio = ? WHERE id_prod = ?";
    private static final String DELETE_PRODUCTO = "DELETE FROM t_producto WHERE id_prod = ?";
    private static final String UPDATE_STOCK = "UPDATE t_producto SET cantidad = cantidad - ? WHERE id_prod = ?";
    private static final String COUNT_PRODUCTOS = "SELECT COUNT(*) FROM t_producto";
    private static final String SELECT_PRODUCTOS_BAJO_STOCK = "SELECT * FROM t_producto WHERE cantidad <= 5 ORDER BY cantidad";

    public List<Producto> listarProductos() {
        List<Producto> productos = new ArrayList<>();
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(SELECT_ALL_PRODUCTOS);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Producto p = new Producto();
                p.setId_prod(rs.getString("id_prod"));
                p.setCantidad(rs.getInt("cantidad"));
                p.setCosto(rs.getBigDecimal("costo"));
                p.setDescripcion(rs.getString("descripcion"));
                p.setPrecio(rs.getBigDecimal("precio"));
                productos.add(p);
            }

        } catch (SQLException e) {
            System.err.println("Error al listar productos: " + e.getMessage());
        }
        return productos;
    }

    public Producto obtenerProductoPorId(String id) {
        Producto producto = null;
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(SELECT_PRODUCTO_BY_ID)) {
            
            ps.setString(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    producto = new Producto();
                    producto.setId_prod(rs.getString("id_prod"));
                    producto.setCantidad(rs.getInt("cantidad"));
                    producto.setCosto(rs.getBigDecimal("costo"));
                    producto.setDescripcion(rs.getString("descripcion"));
                    producto.setPrecio(rs.getBigDecimal("precio"));
                }
            }
        } catch (SQLException e) {
            System.err.println("Error al obtener producto por ID: " + e.getMessage());
        }
        return producto;
    }

    public boolean guardarProducto(Producto producto) {
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(INSERT_PRODUCTO)) {
            
            ps.setString(1, producto.getId_prod());
            ps.setInt(2, producto.getCantidad());
            ps.setBigDecimal(3, producto.getCosto());
            ps.setString(4, producto.getDescripcion());
            ps.setBigDecimal(5, producto.getPrecio());
            
            return ps.executeUpdate() > 0;
            
        } catch (SQLException e) {
            System.err.println("Error al guardar producto: " + e.getMessage());
            return false;
        }
    }

    public boolean actualizarProducto(Producto producto) {
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(UPDATE_PRODUCTO)) {
            
            ps.setInt(1, producto.getCantidad());
            ps.setBigDecimal(2, producto.getCosto());
            ps.setString(3, producto.getDescripcion());
            ps.setBigDecimal(4, producto.getPrecio());
            ps.setString(5, producto.getId_prod());
            
            return ps.executeUpdate() > 0;
            
        } catch (SQLException e) {
            System.err.println("Error al actualizar producto: " + e.getMessage());
            return false;
        }
    }

    public boolean eliminarProducto(String id) {
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(DELETE_PRODUCTO)) {
            
            ps.setString(1, id);
            return ps.executeUpdate() > 0;
            
        } catch (SQLException e) {
            System.err.println("Error al eliminar producto: " + e.getMessage());
            return false;
        }
    }

    public boolean actualizarStock(String idProducto, int cantidadVendida) {
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(UPDATE_STOCK)) {
            
            ps.setInt(1, cantidadVendida);
            ps.setString(2, idProducto);
            
            return ps.executeUpdate() > 0;
            
        } catch (SQLException e) {
            System.err.println("Error al actualizar stock: " + e.getMessage());
            return false;
        }
    }

    public List<Producto> obtenerProductosBajoStock() {
        List<Producto> productos = new ArrayList<>();
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(SELECT_PRODUCTOS_BAJO_STOCK);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Producto p = new Producto();
                p.setId_prod(rs.getString("id_prod"));
                p.setCantidad(rs.getInt("cantidad"));
                p.setCosto(rs.getBigDecimal("costo"));
                p.setDescripcion(rs.getString("descripcion"));
                p.setPrecio(rs.getBigDecimal("precio"));
                productos.add(p);
            }

        } catch (SQLException e) {
            System.err.println("Error al obtener productos bajo stock: " + e.getMessage());
        }
        return productos;
    }

    public int contarProductos() {
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(COUNT_PRODUCTOS);
             ResultSet rs = ps.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
            
        } catch (SQLException e) {
            System.err.println("Error al contar productos: " + e.getMessage());
        }
        return 0;
    }

    // Método para generar nuevo ID de producto
    public String generarNuevoId() {
        String nuevoId = "PROD001";
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement ps = conn.prepareStatement("SELECT MAX(CAST(SUBSTRING(id_prod, 5) AS UNSIGNED)) FROM t_producto WHERE id_prod LIKE 'PROD%'");
             ResultSet rs = ps.executeQuery()) {
            
            if (rs.next()) {
                int ultimoNumero = rs.getInt(1);
                nuevoId = String.format("PROD%03d", ultimoNumero + 1);
            }
            
        } catch (SQLException e) {
            System.err.println("Error al generar nuevo ID: " + e.getMessage());
        }
        return nuevoId;
    }
}
