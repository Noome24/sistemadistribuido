package modelo;

import java.math.BigDecimal;

public class DetallePedido {
    private String id_pedido;       // VARCHAR(10) - FK
    private String id_prod;         // VARCHAR(10) - FK
    private int cantidad;           // INT
    private BigDecimal precio;      // DECIMAL(10,2)
    private BigDecimal total_deta;  // DECIMAL(10,2)

    // Relación
    private Producto producto;

    // Constructores
    public DetallePedido() {}

    public DetallePedido(String id_pedido, String id_prod, int cantidad, BigDecimal precio, BigDecimal total_deta) {
        this.id_pedido = id_pedido;
        this.id_prod = id_prod;
        this.cantidad = cantidad;
        this.precio = precio;
        this.total_deta = total_deta;
    }

    // Getters y Setters
    public String getId_pedido() {
        return id_pedido;
    }

    public void setId_pedido(String id_pedido) {
        this.id_pedido = id_pedido;
    }

    public String getId_prod() {
        return id_prod;
    }

    public void setId_prod(String id_prod) {
        this.id_prod = id_prod;
    }

    public int getCantidad() {
        return cantidad;
    }

    public void setCantidad(int cantidad) {
        this.cantidad = cantidad;
    }

    public BigDecimal getPrecio() {
        return precio;
    }

    public void setPrecio(BigDecimal precio) {
        this.precio = precio;
    }

    public BigDecimal getTotal_deta() {
        return total_deta;
    }

    public void setTotal_deta(BigDecimal total_deta) {
        this.total_deta = total_deta;
    }

    public Producto getProducto() {
        return producto;
    }

    public void setProducto(Producto producto) {
        this.producto = producto;
    }

    // Método para calcular total automáticamente
    public void calcularTotal() {
        if (precio != null && cantidad > 0) {
            this.total_deta = precio.multiply(new BigDecimal(cantidad));
        }
    }

    @Override
    public String toString() {
        return "DetallePedido{" +
                "id_pedido='" + id_pedido + '\'' +
                ", id_prod='" + id_prod + '\'' +
                ", cantidad=" + cantidad +
                ", precio=" + precio +
                ", total_deta=" + total_deta +
                '}';
    }
}
