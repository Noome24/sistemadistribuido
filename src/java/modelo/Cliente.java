package modelo;

public class Cliente {
    private String id_cliente;
    private String nombres;
    private String apellidos;
    private String dni;
    private String direccion;
    private String telefono;
    private String movil;
    private String email;
    private String passwd;  // AÑADIDO: contraseña para login

    // Constructores
    public Cliente() {}

    public Cliente(String id_cliente, String nombres, String apellidos, String dni,
                   String direccion, String telefono, String movil,
                   String email, String passwd, int estado) {
        this.id_cliente = id_cliente;
        this.nombres = nombres;
        this.apellidos = apellidos;
        this.dni = dni;
        this.direccion = direccion;
        this.telefono = telefono;
        this.movil = movil;
        this.email = email;
        this.passwd = passwd;
    }

    // Getters y Setters
    public String getId_cliente() {
        return id_cliente;
    }

    public void setId_cliente(String id_cliente) {
        this.id_cliente = id_cliente;
    }

    public String getNombres() {
        return nombres;
    }

    public void setNombres(String nombres) {
        this.nombres = nombres;
    }

    public String getApellidos() {
        return apellidos;
    }

    public void setApellidos(String apellidos) {
        this.apellidos = apellidos;
    }

    public String getDni() {
        return dni;
    }

    public void setDni(String dni) {
        this.dni = dni;
    }

    public String getDireccion() {
        return direccion;
    }

    public void setDireccion(String direccion) {
        this.direccion = direccion;
    }

    public String getTelefono() {
        return telefono;
    }

    public void setTelefono(String telefono) {
        this.telefono = telefono;
    }

    public String getMovil() {
        return movil;
    }

    public void setMovil(String movil) {
        this.movil = movil;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPasswd() {
        return passwd;
    }

    public void setPasswd(String passwd) {
        this.passwd = passwd;
    }



    // Método para obtener nombre completo
    public String getNombre() {
        return (nombres != null ? nombres : "") + " " + (apellidos != null ? apellidos : "");
    }

    @Override
    public String toString() {
        return "Cliente{" +
                "id_cliente='" + id_cliente + '\'' +
                ", nombres='" + nombres + '\'' +
                ", apellidos='" + apellidos + '\'' +
                ", dni='" + dni + '\'' +
                ", direccion='" + direccion + '\'' +
                ", telefono='" + telefono + '\'' +
                ", movil='" + movil + '\'' +
                ", email='" + email + '\'' +
                ", passwd='" + passwd + '\'' +
                '}';
    }
}
