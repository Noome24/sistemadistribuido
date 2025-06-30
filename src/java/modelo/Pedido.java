package modelo;

import java.math.BigDecimal;
import java.sql.Date;
import java.util.List;

public class Pedido {
    private String id_pedido;       // VARCHAR(10)
    private Date fecha;             // DATE
    private BigDecimal subtotal;    // DECIMAL(10,2)
    private BigDecimal totalventa;  // DECIMAL(10,2)
    private String id_cliente;      // VARCHAR(10) - FK

    // Relaciones
    private Cliente cliente;
    private List<DetallePedido> detalles;

    // Constructores
    public Pedido() {}

    public Pedido(String id_pedido, Date fecha, BigDecimal subtotal, BigDecimal totalventa, String id_cliente) {
        this.id_pedido = id_pedido;
        this.fecha = fecha;
        this.subtotal = subtotal;
        this.totalventa = totalventa;
        this.id_cliente = id_cliente;
    }

    // Getters y Setters
    public String getId_pedido() {
        return id_pedido;
    }

    public void setId_pedido(String id_pedido) {
        this.id_pedido = id_pedido;
    }

    public Date getFecha() {
        return fecha;
    }

    public void setFecha(Date fecha) {
        this.fecha = fecha;
    }

    public BigDecimal getSubtotal() {
        return subtotal;
    }

    public void setSubtotal(BigDecimal subtotal) {
        this.subtotal = subtotal;
    }

    public BigDecimal getTotalventa() {
        return totalventa;
    }

    public void setTotalventa(BigDecimal totalventa) {
        this.totalventa = totalventa;
    }

    public String getId_cliente() {
        return id_cliente;
    }

    public void setId_cliente(String id_cliente) {
        this.id_cliente = id_cliente;
    }

    public Cliente getCliente() {
        return cliente;
    }

    public void setCliente(Cliente cliente) {
        this.cliente = cliente;
    }

    public List<DetallePedido> getDetalles() {
        return detalles;
    }

    public void setDetalles(List<DetallePedido> detalles) {
        this.detalles = detalles;
    }

    // Método para calcular IGV (18%)
    public BigDecimal getIgv() {
        if (subtotal != null) {
            return subtotal.multiply(new BigDecimal("0.18"));
        }
        return BigDecimal.ZERO;
    }

    @Override
    public String toString() {
        return "Pedido{" +
                "id_pedido='" + id_pedido + '\'' +
                ", fecha=" + fecha +
                ", subtotal=" + subtotal +
                ", totalventa=" + totalventa +
                ", id_cliente='" + id_cliente + '\'' +
                '}';
    }
}
