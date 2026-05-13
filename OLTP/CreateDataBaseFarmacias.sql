CREATE DATABASE Farmacia;
GO

USE Farmacia;
GO

-- =========================
-- TABLA CLIENTE
-- =========================
CREATE TABLE cliente (
    id INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    telefono VARCHAR(20) NULL,
    correo VARCHAR(100) NULL,
    direccion VARCHAR(150) NULL
);
GO

-- =========================
-- TABLA SEDE
-- =========================
CREATE TABLE sede (
    id INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    telefono VARCHAR(20) NULL,
    direccion VARCHAR(150) NULL,
    ciudad VARCHAR(100) NULL,
    distrito VARCHAR(100) NULL
);
GO

-- =========================
-- TABLA PROVEEDOR
-- =========================
CREATE TABLE proveedor (
    id INT IDENTITY(1,1) PRIMARY KEY,
    ruc VARCHAR(20) NOT NULL,
    razon_social VARCHAR(150) NOT NULL,
    telefono VARCHAR(20) NULL,
    correo VARCHAR(100) NULL,
    direccion VARCHAR(150) NULL
);
GO

-- =========================
-- TABLA CATEGORIA_PRODUCTO
-- =========================
CREATE TABLE categoria_producto (
    id INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);
GO

-- =========================
-- TABLA PRODUCTO
-- =========================
CREATE TABLE producto (
    id INT IDENTITY(1,1) PRIMARY KEY,
    nombre_generico VARCHAR(100) NOT NULL,
    nombre_comercial VARCHAR(100) NULL,
    laboratorio VARCHAR(100) NULL,
    precio_venta DECIMAL(10,2) NULL,
    receta_medica BIT DEFAULT 0,
    estado VARCHAR(50) NULL,
    categoria_id INT NOT NULL,

    CONSTRAINT FK_producto_categoria
        FOREIGN KEY (categoria_id)
        REFERENCES categoria_producto(id)
);
GO

-- =========================
-- TABLA INVENTARIO
-- =========================
CREATE TABLE inventario (
    id INT IDENTITY(1,1) PRIMARY KEY,
    producto_id INT NOT NULL,
    sede_id INT NOT NULL,
    stock INT NOT NULL,
    lote VARCHAR(50) NULL,
    fecha_vencimiento DATE NULL,

    CONSTRAINT FK_inventario_producto
        FOREIGN KEY (producto_id)
        REFERENCES producto(id),

    CONSTRAINT FK_inventario_sede
        FOREIGN KEY (sede_id)
        REFERENCES sede(id)
);
GO

-- =========================
-- TABLA VENTA
-- =========================
CREATE TABLE venta (
    id INT IDENTITY(1,1) PRIMARY KEY,
    cliente_id INT NOT NULL,
    sede_id INT NOT NULL,
    fecha_venta DATE NOT NULL,
    tipo_comprobante VARCHAR(50) NULL,
    metodo_pago VARCHAR(50) NULL,
    monto_total DECIMAL(10,2) NULL,

    CONSTRAINT FK_venta_cliente
        FOREIGN KEY (cliente_id)
        REFERENCES cliente(id),

    CONSTRAINT FK_venta_sede
        FOREIGN KEY (sede_id)
        REFERENCES sede(id)
);
GO

-- =========================
-- TABLA DETALLE_VENTA
-- =========================
CREATE TABLE detalle_venta (
    id INT IDENTITY(1,1) PRIMARY KEY,
    venta_id INT NOT NULL,
    producto_id INT NOT NULL,
    unidades INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL,

    CONSTRAINT FK_detalleVenta_venta
        FOREIGN KEY (venta_id)
        REFERENCES venta(id),

    CONSTRAINT FK_detalleVenta_producto
        FOREIGN KEY (producto_id)
        REFERENCES producto(id)
);
GO

-- =========================
-- TABLA COMPRA
-- =========================
CREATE TABLE compra (
    id INT IDENTITY(1,1) PRIMARY KEY,
    proveedor_id INT NOT NULL,
    sede_id INT NOT NULL,
    fecha_compra DATE NOT NULL,

    CONSTRAINT FK_compra_proveedor
        FOREIGN KEY (proveedor_id)
        REFERENCES proveedor(id),

    CONSTRAINT FK_compra_sede
        FOREIGN KEY (sede_id)
        REFERENCES sede(id)
);
GO

-- =========================
-- TABLA DETALLE_COMPRA
-- =========================
CREATE TABLE detalle_compra (
    id INT IDENTITY(1,1) PRIMARY KEY,
    compra_id INT NOT NULL,
    producto_id INT NOT NULL,
    unidades INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL,

    CONSTRAINT FK_detalleCompra_compra
        FOREIGN KEY (compra_id)
        REFERENCES compra(id),

    CONSTRAINT FK_detalleCompra_producto
        FOREIGN KEY (producto_id)
        REFERENCES producto(id)
);
GO