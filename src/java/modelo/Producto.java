package modelo;

import java.math.BigDecimal;

public class Producto {
    private String id_prod;         // VARCHAR(10)
    private int cantidad;           // INT
    private BigDecimal costo;       // DECIMAL(10,2)
    private String descripcion;     // VARCHAR(200)
    private BigDecimal precio;      // DECIMAL(10,2)

    // Constructores
    public Producto() {}

    public Producto(String id_prod, int cantidad, BigDecimal costo, String descripcion, BigDecimal precio) {
        this.id_prod = id_prod;
        this.cantidad = cantidad;
        this.costo = costo;
        this.descripcion = descripcion;
        this.precio = precio;
    }

    // Getters y Setters
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

    public BigDecimal getCosto() {
        return costo;
    }

    public void setCosto(BigDecimal costo) {
        this.costo = costo;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    public BigDecimal getPrecio() {
        return precio;
    }

    public void setPrecio(BigDecimal precio) {
        this.precio = precio;
    }

    // Método para calcular ganancia
    public BigDecimal getGanancia() {
        if (precio != null && costo != null) {
            return precio.subtract(costo);
        }
        return BigDecimal.ZERO;
    }

    // Método para calcular porcentaje de ganancia
    public BigDecimal getPorcentajeGanancia() {
        if (costo != null && costo.compareTo(BigDecimal.ZERO) > 0 && precio != null) {
            return getGanancia().divide(costo, 4, BigDecimal.ROUND_HALF_UP).multiply(new BigDecimal("100"));
        }
        return BigDecimal.ZERO;
    }

    @Override
    public String toString() {
        return "Producto{" +
                "id_prod='" + id_prod + '\'' +
                ", cantidad=" + cantidad +
                ", costo=" + costo +
                ", descripcion='" + descripcion + '\'' +
                ", precio=" + precio +
                '}';
    }
}
