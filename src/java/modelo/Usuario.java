package modelo;

public class Usuario {
    private String id_usuario;      // VARCHAR(10) - Cambiado de int a String
    private int estado;          // TINYINT (0 = inactivo, 1 = activo)
    private String passwd;       // VARCHAR(100)
    private int rol;            // TINYINT (0 = cliente, 1 = admin, 2 = superadmin)

    // Constructores
    public Usuario() {}

    public Usuario(String id_usuario, int estado, String passwd, int rol) {
        this.id_usuario = id_usuario;
        this.estado = estado;
        this.passwd = passwd;
        this.rol = rol;
    }

    // Getters y Setters
    public String getId_usuario() {
        return id_usuario;
    }

    public void setId_usuario(String id_usuario) {
        this.id_usuario = id_usuario;
    }

    public int getEstado() {
        return estado;
    }

    public void setEstado(int estado) {
        this.estado = estado;
    }

    public String getPasswd() {
        return passwd;
    }

    public void setPasswd(String passwd) {
        this.passwd = passwd;
    }

    public int getRol() {
        return rol;
    }

    public void setRol(int rol) {
        this.rol = rol;
    }

    @Override
    public String toString() {
        return "Usuario{" +
                "id_usuario='" + id_usuario + '\'' +
                ", estado=" + estado +
                ", passwd='" + passwd + '\'' +
                ", rol=" + rol +
                '}';
    }
}
