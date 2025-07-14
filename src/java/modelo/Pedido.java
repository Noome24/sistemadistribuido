package modelo;

import java.math.BigDecimal;
import java.sql.Date;
import java.util.List;

public class Pedido {
    private String id_pedido;
    private Date fecha;
    private BigDecimal subtotal;
    private BigDecimal totalventa;
    private String id_cliente;
    private int estado; // AÑADIDO: 0=sin asignar, 1=rechazado, 2=aceptado, 3=asignado, 4=en proceso, 5=entregado
    
    // Relaciones
    private Cliente cliente;
    private List<DetallePedido> detalles;
    
    // Constructor vacío
    public Pedido() {
        this.estado = 0; // Por defecto sin asignar
    }
    
    // Constructor con parámetros
    public Pedido(String id_pedido, Date fecha, BigDecimal subtotal, BigDecimal totalventa, String id_cliente, int estado) {
        this.id_pedido = id_pedido;
        this.fecha = fecha;
        this.subtotal = subtotal;
        this.totalventa = totalventa;
        this.id_cliente = id_cliente;
        this.estado = estado;
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
    
    public int getEstado() {
        return estado;
    }
    
    public void setEstado(int estado) {
        this.estado = estado;
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
    
    public BigDecimal getIgv() {
        if (subtotal != null) {
            return subtotal.multiply(new BigDecimal("0.18"));
        } else {
            return BigDecimal.ZERO;
        }
    }


    // Métodos de utilidad
    public String getEstadoTexto() {
        switch (estado) {
            case 0: return "Sin asignar";
            case 1: return "Rechazado";
            case 2: return "Aceptado";
            case 3: return "Asignado";
            case 4: return "En proceso";
            case 5: return "Entregado";
            default: return "Desconocido";
        }
    }
    
    public String getEstadoColor() {
        switch (estado) {
            case 0: return "secondary"; // Sin asignar - gris
            case 1: return "danger";    // Rechazado - rojo
            case 2: return "success";   // Aceptado - verde
            case 3: return "info";      // Asignado - azul
            case 4: return "warning";   // En proceso - amarillo
            case 5: return "primary";   // Entregado - azul oscuro
            default: return "dark";
        }
    }
    
    @Override
    public String toString() {
        return "Pedido{" +
                "id_pedido='" + id_pedido + '\'' +
                ", fecha=" + fecha +
                ", subtotal=" + subtotal +
                ", totalventa=" + totalventa +
                ", id_cliente='" + id_cliente + '\'' +
                ", estado=" + estado +
                '}';
    }
}
