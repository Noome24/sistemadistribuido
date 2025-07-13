CREATE DATABASE database_use;
USE database_use;

-- =====================================================
-- TABLA: t_usuario
-- =====================================================
CREATE TABLE t_usuario (
    id_usuario VARCHAR(10) NOT NULL PRIMARY KEY,
    estado TINYINT NOT NULL DEFAULT 1 COMMENT '0=inactivo, 1=activo',
    passwd VARCHAR(100) NOT NULL,
    rol TINYINT NOT NULL DEFAULT 0 COMMENT '0=admin, 1=usuario, 2=recepcionista, 3=transportista'
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_modificacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- =====================================================
-- TABLA: t_cliente
-- =====================================================
CREATE TABLE t_cliente (
    id_cliente VARCHAR(10) NOT NULL PRIMARY KEY,
    apellidos VARCHAR(100) NOT NULL,
    direccion VARCHAR(200),
    dni VARCHAR(20) NOT NULL UNIQUE,
    movil VARCHAR(20),
    nombres VARCHAR(100) NOT NULL,
    telefono VARCHAR(20),
    email VARCHAR(100),
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_modificacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- =====================================================
-- TABLA: t_producto
-- =====================================================
CREATE TABLE t_producto (
    id_prod VARCHAR(10) NOT NULL PRIMARY KEY,
    cantidad INT NOT NULL DEFAULT 0,
    costo DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    descripcion VARCHAR(200) NOT NULL,
    precio DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_modificacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- =====================================================
-- TABLA: t_pedido
-- =====================================================
CREATE TABLE t_pedido (
    id_pedido VARCHAR(10) NOT NULL PRIMARY KEY,
    fecha DATE NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    totalventa DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    id_cliente VARCHAR(10) NOT NULL,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_modificacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (id_cliente) REFERENCES t_cliente(id_cliente) ON DELETE CASCADE
);

-- =====================================================
-- TABLA: t_detalle_pedido
-- =====================================================
CREATE TABLE t_detalle_pedido (
    id_pedido VARCHAR(10) NOT NULL,
    id_prod VARCHAR(10) NOT NULL,
    cantidad INT NOT NULL DEFAULT 1,
    precio DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    total_deta DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    PRIMARY KEY (id_pedido, id_prod),
    FOREIGN KEY (id_pedido) REFERENCES t_pedido(id_pedido) ON DELETE CASCADE,
    FOREIGN KEY (id_prod) REFERENCES t_producto(id_prod) ON DELETE CASCADE
);

-- =====================================================
-- ÍNDICES PARA OPTIMIZACIÓN
-- =====================================================

-- Índices para t_cliente
CREATE INDEX idx_cliente_dni ON t_cliente(dni);
CREATE INDEX idx_cliente_nombres ON t_cliente(nombres);
CREATE INDEX idx_cliente_apellidos ON t_cliente(apellidos);

-- Índices para t_producto
CREATE INDEX idx_producto_descripcion ON t_producto(descripcion);
CREATE INDEX idx_producto_precio ON t_producto(precio);
CREATE INDEX idx_producto_cantidad ON t_producto(cantidad);

-- Índices para t_pedido
CREATE INDEX idx_pedido_fecha ON t_pedido(fecha);
CREATE INDEX idx_pedido_cliente ON t_pedido(id_cliente);
CREATE INDEX idx_pedido_total ON t_pedido(totalventa);

-- Índices para t_detalle_pedido
CREATE INDEX idx_detalle_producto ON t_detalle_pedido(id_prod);
CREATE INDEX idx_detalle_cantidad ON t_detalle_pedido(cantidad);

-- Índices para t_usuario
CREATE INDEX idx_usuario_estado ON t_usuario(estado);
CREATE INDEX idx_usuario_rol ON t_usuario(rol);

-- =====================================================
-- TRIGGERS PARA CÁLCULOS AUTOMÁTICOS
-- =====================================================

-- Trigger para calcular total_deta en detalle_pedido
DELIMITER $$
CREATE TRIGGER tr_detalle_pedido_total_insert
    BEFORE INSERT ON t_detalle_pedido
    FOR EACH ROW
BEGIN
    SET NEW.total_deta = NEW.cantidad * NEW.precio;
END$$

CREATE TRIGGER tr_detalle_pedido_total_update
    BEFORE UPDATE ON t_detalle_pedido
    FOR EACH ROW
BEGIN
    SET NEW.total_deta = NEW.cantidad * NEW.precio;
END$$
DELIMITER ;

-- Trigger para actualizar totales del pedido
DELIMITER $$
CREATE TRIGGER tr_actualizar_totales_pedido_insert
    AFTER INSERT ON t_detalle_pedido
    FOR EACH ROW
BEGIN
    UPDATE t_pedido 
    SET subtotal = (
        SELECT COALESCE(SUM(total_deta), 0) 
        FROM t_detalle_pedido 
        WHERE id_pedido = NEW.id_pedido
    ),
    totalventa = (
        SELECT COALESCE(SUM(total_deta), 0) * 1.18 
        FROM t_detalle_pedido 
        WHERE id_pedido = NEW.id_pedido
    )
    WHERE id_pedido = NEW.id_pedido;
END$$

CREATE TRIGGER tr_actualizar_totales_pedido_update
    AFTER UPDATE ON t_detalle_pedido
    FOR EACH ROW
BEGIN
    UPDATE t_pedido 
    SET subtotal = (
        SELECT COALESCE(SUM(total_deta), 0) 
        FROM t_detalle_pedido 
        WHERE id_pedido = NEW.id_pedido
    ),
    totalventa = (
        SELECT COALESCE(SUM(total_deta), 0) * 1.18 
        FROM t_detalle_pedido 
        WHERE id_pedido = NEW.id_pedido
    )
    WHERE id_pedido = NEW.id_pedido;
END$$

CREATE TRIGGER tr_actualizar_totales_pedido_delete
    AFTER DELETE ON t_detalle_pedido
    FOR EACH ROW
BEGIN
    UPDATE t_pedido 
    SET subtotal = (
        SELECT COALESCE(SUM(total_deta), 0) 
        FROM t_detalle_pedido 
        WHERE id_pedido = OLD.id_pedido
    ),
    totalventa = (
        SELECT COALESCE(SUM(total_deta), 0) * 1.18 
        FROM t_detalle_pedido 
        WHERE id_pedido = OLD.id_pedido
    )
    WHERE id_pedido = OLD.id_pedido;
END$$
DELIMITER ;

-- =====================================================
-- VISTAS PARA REPORTES
-- =====================================================

-- Vista de pedidos con información del cliente
CREATE VIEW v_pedidos_completos AS
SELECT 
    p.id_pedido,
    p.fecha,
    p.subtotal,
    p.totalventa,
    c.id_cliente,
    c.nombres,
    c.apellidos,
    c.dni,
    c.direccion,
    c.telefono,
    c.movil,
    CONCAT(c.nombres, ' ', c.apellidos) as nombre_completo
FROM t_pedido p
LEFT JOIN t_cliente c ON p.id_cliente = c.id_cliente;

-- Vista de productos con bajo stock
CREATE VIEW v_productos_bajo_stock AS
SELECT 
    id_prod,
    descripcion,
    cantidad,
    precio,
    costo,
    (precio - costo) as ganancia,
    CASE 
        WHEN cantidad = 0 THEN 'SIN STOCK'
        WHEN cantidad <= 5 THEN 'STOCK BAJO'
        WHEN cantidad <= 10 THEN 'STOCK MEDIO'
        ELSE 'STOCK NORMAL'
    END as estado_stock
FROM t_producto
WHERE cantidad <= 10
ORDER BY cantidad ASC;

-- Vista de ventas por mes
CREATE VIEW v_ventas_mensuales AS
SELECT 
    YEAR(fecha) as año,
    MONTH(fecha) as mes,
    MONTHNAME(fecha) as nombre_mes,
    COUNT(*) as total_pedidos,
    SUM(subtotal) as total_subtotal,
    SUM(totalventa) as total_ventas,
    AVG(totalventa) as promedio_venta
FROM t_pedido
GROUP BY YEAR(fecha), MONTH(fecha)
ORDER BY año DESC, mes DESC;

-- =====================================================
-- PROCEDIMIENTOS ALMACENADOS
-- =====================================================

-- Procedimiento para obtener estadísticas del dashboard
DELIMITER $$
CREATE PROCEDURE sp_estadisticas_dashboard()
BEGIN
    SELECT 
        (SELECT COUNT(*) FROM t_cliente) as total_clientes,
        (SELECT COUNT(*) FROM t_producto) as total_productos,
        (SELECT COUNT(*) FROM t_pedido) as total_pedidos,
        (SELECT COUNT(*) FROM t_usuario WHERE estado = 1) as usuarios_activos,
        (SELECT COALESCE(SUM(totalventa), 0) FROM t_pedido WHERE DATE(fecha) = CURDATE()) as ventas_hoy,
        (SELECT COALESCE(SUM(totalventa), 0) FROM t_pedido WHERE YEAR(fecha) = YEAR(CURDATE()) AND MONTH(fecha) = MONTH(CURDATE())) as ventas_mes,
        (SELECT COUNT(*) FROM t_producto WHERE cantidad <= 5) as productos_bajo_stock;
END$$
DELIMITER ;

-- Procedimiento para generar reporte de ventas por período
DELIMITER $$
CREATE PROCEDURE sp_reporte_ventas(IN fecha_inicio DATE, IN fecha_fin DATE)
BEGIN
    SELECT 
        p.id_pedido,
        p.fecha,
        CONCAT(c.nombres, ' ', c.apellidos) as cliente,
        c.dni,
        p.subtotal,
        (p.totalventa - p.subtotal) as igv,
        p.totalventa,
        COUNT(dp.id_prod) as items_vendidos
    FROM t_pedido p
    LEFT JOIN t_cliente c ON p.id_cliente = c.id_cliente
    LEFT JOIN t_detalle_pedido dp ON p.id_pedido = dp.id_pedido
    WHERE p.fecha BETWEEN fecha_inicio AND fecha_fin
    GROUP BY p.id_pedido
    ORDER BY p.fecha DESC;
END$$
DELIMITER ;

-- =====================================================
-- DATOS DE PRUEBA
-- =====================================================

-- Insertar usuarios de prueba
INSERT INTO t_usuario (id_usuario, estado, passwd, rol) VALUES
('admin', 1, 'admin123', 2),
('USR001', 1, 'user123', 1),
('USR002', 1, 'user456', 0);

-- Insertar clientes de prueba
INSERT INTO t_cliente (id_cliente, apellidos, direccion, dni, movil, nombres, telefono, email) VALUES
('CLI001', 'García López', 'Av. Principal 123, Lima', '12345678', '987654321', 'Juan Carlos', '014567890', 'juan.garcia@email.com'),
('CLI002', 'Rodríguez Silva', 'Jr. Los Olivos 456, Lima', '87654321', '912345678', 'María Elena', '015678901', 'maria.rodriguez@email.com'),
('CLI003', 'Martínez Pérez', 'Calle Las Flores 789, Lima', '11223344', '998877665', 'Carlos Alberto', '016789012', 'carlos.martinez@email.com'),
('CLI004', 'López Vásquez', 'Av. Los Pinos 321, Lima', '44332211', '955443322', 'Ana Lucía', '017890123', 'ana.lopez@email.com'),
('CLI005', 'Sánchez Torres', 'Jr. San Martín 654, Lima', '55667788', '966554433', 'Roberto Miguel', '018901234', 'roberto.sanchez@email.com');

-- Insertar productos de prueba
INSERT INTO t_producto (id_prod, cantidad, costo, descripcion, precio) VALUES
('PROD001', 50, 15.00, 'Laptop HP Pavilion 15.6" Intel Core i5', 25.00),
('PROD002', 30, 8.00, 'Mouse Inalámbrico Logitech M220', 15.00),
('PROD003', 25, 12.00, 'Teclado Mecánico RGB Gaming', 22.00),
('PROD004', 40, 20.00, 'Monitor LED 24" Full HD', 35.00),
('PROD005', 15, 45.00, 'Impresora Multifuncional Canon', 75.00),
('PROD006', 60, 5.00, 'Cable USB Tipo C 1.5m', 10.00),
('PROD007', 35, 18.00, 'Auriculares Bluetooth Sony', 32.00),
('PROD008', 20, 25.00, 'Webcam HD 1080p Logitech', 45.00),
('PROD009', 45, 10.00, 'Memoria USB 32GB Kingston', 18.00),
('PROD010', 12, 35.00, 'Disco Duro Externo 1TB Seagate', 65.00);

-- Insertar pedidos de prueba
INSERT INTO t_pedido (id_pedido, fecha, subtotal, totalventa, id_cliente) VALUES
('PED001', '2024-01-15', 0, 0, 'CLI001'),
('PED002', '2024-01-16', 0, 0, 'CLI002'),
('PED003', '2024-01-17', 0, 0, 'CLI003'),
('PED004', '2024-01-18', 0, 0, 'CLI001'),
('PED005', '2024-01-19', 0, 0, 'CLI004');

-- Insertar detalles de pedidos de prueba
INSERT INTO t_detalle_pedido (id_pedido, id_prod, cantidad, precio) VALUES
-- Pedido 1
('PED001', 'PROD001', 2, 25.00),
('PED001', 'PROD002', 1, 15.00),
('PED001', 'PROD006', 3, 10.00),

-- Pedido 2
('PED002', 'PROD003', 1, 22.00),
('PED002', 'PROD004', 1, 35.00),
('PED002', 'PROD007', 2, 32.00),

-- Pedido 3
('PED003', 'PROD005', 1, 75.00),
('PED003', 'PROD008', 1, 45.00),
('PED003', 'PROD009', 2, 18.00),

-- Pedido 4
('PED004', 'PROD010', 1, 65.00),
('PED004', 'PROD001', 1, 25.00),
('PED004', 'PROD002', 2, 15.00),

-- Pedido 5
('PED005', 'PROD003', 2, 22.00),
('PED005', 'PROD006', 5, 10.00),
('PED005', 'PROD009', 3, 18.00);

-- =====================================================
-- CONFIGURACIÓN DE PERMISOS
-- =====================================================

-- Crear usuario para la aplicación
CREATE USER IF NOT EXISTS 'admin'@'%' IDENTIFIED BY 'admin123';
GRANT ALL PRIVILEGES ON sistema_ventas.* TO 'admin'@'%';

-- Crear usuario de solo lectura para reportes
CREATE USER IF NOT EXISTS 'readonly'@'%' IDENTIFIED BY 'readonly123';
GRANT SELECT ON sistema_ventas.* TO 'readonly'@'%';

-- Aplicar cambios
FLUSH PRIVILEGES;

-- =====================================================
-- VERIFICACIÓN DE DATOS
-- =====================================================

-- Mostrar resumen de datos insertados
SELECT 'USUARIOS' as tabla, COUNT(*) as registros FROM t_usuario
UNION ALL
SELECT 'CLIENTES' as tabla, COUNT(*) as registros FROM t_cliente
UNION ALL
SELECT 'PRODUCTOS' as tabla, COUNT(*) as registros FROM t_producto
UNION ALL
SELECT 'PEDIDOS' as tabla, COUNT(*) as registros FROM t_pedido
UNION ALL
SELECT 'DETALLES' as tabla, COUNT(*) as registros FROM t_detalle_pedido;

-- Mostrar estadísticas básicas
CALL sp_estadisticas_dashboard();

-- =====================================================
-- SCRIPT COMPLETADO EXITOSAMENTE
-- =====================================================
-- Base de datos 'sistema_ventas' creada con:
-- - 5 tablas principales
-- - Índices optimizados
-- - Triggers automáticos
-- - 3 vistas de reporte
-- - 2 procedimientos almacenados
-- - Datos de prueba
-- - Usuarios configurados
-- =====================================================