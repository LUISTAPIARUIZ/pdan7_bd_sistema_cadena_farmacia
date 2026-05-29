USE Farmacia;
GO

-- =========================
-- TABLA SEDE
-- =========================

INSERT INTO sede(nombre, telefono, direccion, ciudad, distrito)
VALUES 
('Jockey Center', '999111222', 'Av. Javier Prado 4200', 'Lima', 'Surco'),
('Mall Plaza Norte', '988222333', 'Panamericana Norte 1500', 'Lima', 'Independencia'),
('Centro Empresarial San Isidro', '977333444', 'Av. Canaval y Moreyra 250', 'Lima', 'San Isidro'),
('Open Plaza Angamos', '966444555', 'Av. Angamos Este 1803', 'Lima', 'Surquillo'),
('Real Plaza Salaverry', '955555666', 'Av. Salaverry 2370', 'Lima', 'Jesús María'),
('Mega Plaza', '944666777', 'Av. Alfredo Mendiola 3698', 'Lima', 'Independencia'),
('Larcomar', '933777888', 'Malecón de la Reserva 610', 'Lima', 'Miraflores'),
('Plaza San Miguel', '922888999', 'Av. La Marina 2000', 'Lima', 'San Miguel'),
('Centro Cívico', '911999000', 'Av. Inca Garcilaso de la Vega 1337', 'Lima', 'Cercado de Lima'),
('Mall del Sur', '900123456', 'Av. Los Lirios 301', 'Lima', 'San Juan de Miraflores');

SELECT * FROM dbo.sede;

-- =========================
-- TABLA CLIENTE
-- =========================

INSERT INTO cliente(nombre, telefono, correo, direccion)
VALUES
('Juan Perez', '987111222', 'juan.perez@gmail.com', 'Av. Primavera 123 - Surco'),
('Maria Torres', '986222333', 'maria.torres@gmail.com', 'Calle Los Olivos 456 - San Miguel'),
('Carlos Ramos', '985333444', 'carlos.ramos@gmail.com', 'Jr. Las Flores 789 - Miraflores'),
('Ana Gutierrez', '984444555', 'ana.gutierrez@gmail.com', 'Av. Brasil 321 - Pueblo Libre'),
('Luis Mendoza', '983555666', 'luis.mendoza@gmail.com', 'Calle Lima 654 - San Isidro'),
('Fernanda Castro', '982666777', 'fernanda.castro@gmail.com', 'Av. Arequipa 852 - Lince'),
('Diego Ruiz', '981777888', 'diego.ruiz@gmail.com', 'Jr. Junin 951 - Breña'),
('Patricia Vega', '980888999', 'patricia.vega@gmail.com', 'Av. La Marina 753 - San Miguel'),
('Ricardo Salas', '979999000', 'ricardo.salas@gmail.com', 'Calle Central 258 - Surquillo'),
('Lucia Navarro', '978123456', 'lucia.navarro@gmail.com', 'Av. Angamos 147 - Surco');

SELECT * FROM dbo.cliente;

-- =========================
-- TABLA PROVEEDOR
-- =========================

INSERT INTO proveedor(ruc, razon_social, telefono, correo, direccion)
VALUES
('20111111111', 'Tech Solutions SAC', '965111222', 'contacto@techsolutions.com', 'Av. Javier Prado 1200 - San Isidro'),
('20222222222', 'Innova Systems SAC', '964222333', 'ventas@innovasystems.com', 'Calle Las Begonias 450 - Surco'),
('20333333333', 'Digital Services EIRL', '963333444', 'soporte@digitalservices.com', 'Av. La Marina 800 - San Miguel'),
('20444444444', 'Global Net Peru SAC', '962444555', 'info@globalnet.pe', 'Jr. Comercio 258 - Cercado de Lima'),
('20555555555', 'Smart Business SAC', '961555666', 'contacto@smartbusiness.pe', 'Av. Brasil 951 - Jesús María'),
('20666666666', 'Data Corp SAC', '960666777', 'ventas@datacorp.pe', 'Calle Los Pinos 741 - Miraflores'),
('20777777777', 'Software House Peru', '969777888', 'admin@softwarehouse.pe', 'Av. Angamos 369 - Surquillo'),
('20888888888', 'Net Solutions Group', '968888999', 'consultas@netsolutions.pe', 'Av. Universitaria 159 - Los Olivos'),
('20999999999', 'Cloud Services SAC', '967999000', 'info@cloudservices.pe', 'Calle Central 753 - Lince'),
('20123456789', 'Peru Tech Industries', '966123456', 'contacto@perutech.pe', 'Av. Arequipa 456 - San Isidro');

SELECT * FROM dbo.proveedor;

-- =========================
-- TABLA CATEGORIA_PRODUCTO
-- =========================

INSERT INTO categoria_producto(nombre)
VALUES
('Analgesicos'),
('Antibioticos'),
('Vitaminas'),
('Antiinflamatorios'),
('Jarabes'),
('Cuidado Personal'),
('Dermatologia'),
('Pediatria'),
('Control Digestivo'),
('Primeros Auxilios');

SELECT * FROM dbo.categoria_producto;

-- =========================
-- TABLA PRODUCTO
-- =========================

INSERT INTO producto
(nombre_generico, nombre_comercial, laboratorio, precio_venta, receta_medica, estado, categoria_id)
VALUES
('Paracetamol 500mg', 'Panadol', 'GSK', 8.50, 0, 1, 1),
('Ibuprofeno 400mg', 'Advil', 'Pfizer', 12.00, 0, 1, 4),
('Amoxicilina 500mg', 'Amoxil', 'Bayer', 18.90, 1, 1, 2),
('Vitamina C 1g', 'Redoxon', 'Bayer', 15.50, 0, 1, 3),
('Loratadina 10mg', 'Clarityne', 'MSD', 9.80, 0, 1, 5),
('Omeprazol 20mg', 'Losec', 'AstraZeneca', 14.20, 1, 1, 9),
('Diclofenaco 50mg', 'Voltaren', 'Novartis', 11.40, 1, 1, 4),
('Jarabe para la tos', 'Bisolvon', 'Sanofi', 13.70, 0, 1, 5),
('Alcohol Medicinal', 'Alcohol 70', 'Medifarma', 6.00, 0, 1, 10),
('Crema Dermatologica', 'Bepanthen', 'Bayer', 22.50, 0, 1, 7);

SELECT * FROM dbo.producto;

-- =========================
-- TABLA INVENTARIO
-- =========================

INSERT INTO inventario
(producto_id, sede_id, stock, lote, fecha_vencimiento)
VALUES
(1, 1, 120, 'LT001', '2027-01-15'),
(2, 1, 80, 'LT002', '2026-11-20'),
(3, 2, 45, 'LT003', '2026-08-10'),
(4, 2, 150, 'LT004', '2027-05-30'),
(5, 3, 60, 'LT005', '2026-12-01'),
(6, 4, 35, 'LT006', '2026-09-18'),
(7, 5, 90, 'LT007', '2027-03-22'),
(8, 5, 70, 'LT008', '2026-10-14'),
(9, 6, 200, 'LT009', '2028-01-01'),
(10, 7, 40, 'LT010', '2026-07-25'),
(1, 7, 100, 'LT011', '2027-02-12'),
(2, 8, 65, 'LT012', '2026-11-05'),
(3, 9, 30, 'LT013', '2026-06-28'),
(4, 10, 110, 'LT014', '2027-04-19'),
(5, 10, 55, 'LT015', '2026-12-30');

SELECT * FROM dbo.inventario;


-- Procedimiento para registrar ventas con validaciones
CREATE TYPE DetalleVentaType AS TABLE
(
    producto_id INT,
    unidades INT
);
GO

CREATE PROCEDURE registrar_venta
    @cliente_id INT,
    @sede_id INT,
    @tipo_comprobante VARCHAR(50),
    @metodo_pago VARCHAR(50),
    @detalle DetalleVentaType READONLY
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE @venta_id INT;

        -- Validar que el detalle no esté vacío
        IF NOT EXISTS (SELECT 1 FROM @detalle)
        BEGIN
            THROW 50000, 'La venta debe tener al menos un producto.', 1;
        END;

        -- Validar que las unidades sean mayores a 0
        IF EXISTS (
            SELECT 1
            FROM @detalle
            WHERE unidades <= 0
        )
        BEGIN
            THROW 50003, 'Las unidades deben ser mayores a 0.', 1;
        END;

        -- Validar que todos los productos existan en inventario de esa sede
        IF EXISTS (
            SELECT 1
            FROM @detalle d
            LEFT JOIN inventario i
                ON i.producto_id = d.producto_id
               AND i.sede_id = @sede_id
            WHERE i.id IS NULL
        )
        BEGIN
            THROW 50002, 'Uno o más productos no existen en el inventario de esta sede.', 1;
        END;

        -- Validar stock suficiente
        IF EXISTS (
            SELECT 1
            FROM @detalle d
            INNER JOIN inventario i 
                ON i.producto_id = d.producto_id
               AND i.sede_id = @sede_id
            WHERE i.stock < d.unidades
        )
        BEGIN
            THROW 50001, 'Stock insuficiente para uno o más productos.', 1;
        END;

        -- Crear venta
        INSERT INTO venta
        (cliente_id, sede_id, fecha_venta, tipo_comprobante, metodo_pago, monto_total)
        VALUES
        (@cliente_id, @sede_id, GETDATE(), @tipo_comprobante, @metodo_pago, 0);

        SET @venta_id = SCOPE_IDENTITY();

        -- Crear detalle de venta
        INSERT INTO detalle_venta
        (venta_id, inventario_id, unidades, precio_unitario, subtotal)
        SELECT
            @venta_id,
            i.id,
            d.unidades,
            p.precio_venta,
            d.unidades * p.precio_venta
        FROM @detalle d
        INNER JOIN inventario i 
            ON i.producto_id = d.producto_id
           AND i.sede_id = @sede_id
        INNER JOIN producto p 
            ON p.id = d.producto_id;

        -- Descontar stock
        UPDATE i
        SET i.stock = i.stock - d.unidades
        FROM inventario i
        INNER JOIN @detalle d 
            ON d.producto_id = i.producto_id
        WHERE i.sede_id = @sede_id;

        -- Actualizar total
        UPDATE venta
        SET monto_total = (
            SELECT SUM(subtotal)
            FROM detalle_venta
            WHERE venta_id = @venta_id
        )
        WHERE id = @venta_id;

        COMMIT;

        SELECT @venta_id AS venta_id;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK;

        THROW;
    END CATCH
END;
GO


-- Procedimiento para registrar compras con validaciones
CREATE TYPE DetalleCompraType AS TABLE
(
    producto_id INT,
    unidades INT,
    precio_unitario DECIMAL(10,2),
    lote VARCHAR(50),
    fecha_vencimiento DATE
);
GO

CREATE PROCEDURE registrar_compra
    @proveedor_id INT,
    @sede_id INT,
    @detalle DetalleCompraType READONLY
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE @compra_id INT;

        -- Validar que el detalle no esté vacío
        IF NOT EXISTS (SELECT 1 FROM @detalle)
        BEGIN
            THROW 51000, 'La compra debe tener al menos un producto.', 1;
        END;

        -- Validar unidades
        IF EXISTS (
            SELECT 1
            FROM @detalle
            WHERE unidades <= 0
        )
        BEGIN
            THROW 51001, 'Las unidades deben ser mayores a 0.', 1;
        END;

        -- Validar precio unitario
        IF EXISTS (
            SELECT 1
            FROM @detalle
            WHERE precio_unitario <= 0
        )
        BEGIN
            THROW 51002, 'El precio unitario debe ser mayor a 0.', 1;
        END;

        -- Validar que los productos existan
        IF EXISTS (
            SELECT 1
            FROM @detalle d
            LEFT JOIN producto p ON p.id = d.producto_id
            WHERE p.id IS NULL
        )
        BEGIN
            THROW 51003, 'Uno o más productos no existen.', 1;
        END;

        -- Crear compra
        INSERT INTO compra
        (proveedor_id, sede_id, fecha_compra)
        VALUES
        (@proveedor_id, @sede_id, GETDATE());

        SET @compra_id = SCOPE_IDENTITY();

        -- Crear inventario nuevo si el producto no existe en esa sede
        INSERT INTO inventario
        (producto_id, sede_id, stock, lote, fecha_vencimiento)
        SELECT
            d.producto_id,
            @sede_id,
            0,
            d.lote,
            d.fecha_vencimiento
        FROM @detalle d
        WHERE NOT EXISTS (
            SELECT 1
            FROM inventario i
            WHERE i.producto_id = d.producto_id
              AND i.sede_id = @sede_id
        );

        -- Insertar detalle de compra
        INSERT INTO detalle_compra
        (compra_id, inventario_id, unidades, precio_unitario, subtotal)
        SELECT
            @compra_id,
            i.id,
            d.unidades,
            d.precio_unitario,
            d.unidades * d.precio_unitario
        FROM @detalle d
        INNER JOIN inventario i
            ON i.producto_id = d.producto_id
           AND i.sede_id = @sede_id;

        -- Aumentar stock
        UPDATE i
        SET i.stock = i.stock + d.unidades
        FROM inventario i
        INNER JOIN @detalle d
            ON d.producto_id = i.producto_id
        WHERE i.sede_id = @sede_id;

        COMMIT;

        SELECT @compra_id AS compra_id;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK;

        THROW;
    END CATCH
END;
GO

-- COMPRA 1
DECLARE @detalleCompra1 DetalleCompraType;

INSERT INTO @detalleCompra1
(producto_id, unidades, precio_unitario, lote, fecha_vencimiento)
VALUES
(1, 50, 5.00, 'C001', '2027-12-31'),
(2, 40, 7.50, 'C002', '2027-10-15'),
(3, 35, 12.00, 'C003', '2027-08-20'),
(4, 60, 10.00, 'C004', '2028-01-10');

EXEC registrar_compra
    @proveedor_id = 1,
    @sede_id = 1,
    @detalle = @detalleCompra1;
GO


-- COMPRA 2
DECLARE @detalleCompra2 DetalleCompraType;

INSERT INTO @detalleCompra2
(producto_id, unidades, precio_unitario, lote, fecha_vencimiento)
VALUES
(3, 45, 11.50, 'C005', '2027-09-15'),
(4, 55, 9.80, 'C006', '2028-02-20'),
(5, 40, 6.50, 'C007', '2027-11-30'),
(6, 30, 8.90, 'C008', '2027-07-25');

EXEC registrar_compra
    @proveedor_id = 2,
    @sede_id = 2,
    @detalle = @detalleCompra2;
GO


-- COMPRA 3
DECLARE @detalleCompra3 DetalleCompraType;

INSERT INTO @detalleCompra3
(producto_id, unidades, precio_unitario, lote, fecha_vencimiento)
VALUES
(7, 70, 7.20, 'C009', '2027-06-18'),
(8, 60, 8.40, 'C010', '2027-12-05'),
(9, 80, 3.50, 'C011', '2028-03-12'),
(10, 35, 15.00, 'C012', '2027-09-28');

EXEC registrar_compra
    @proveedor_id = 3,
    @sede_id = 5,
    @detalle = @detalleCompra3;
GO


-- COMPRA 4
DECLARE @detalleCompra4 DetalleCompraType;

INSERT INTO @detalleCompra4
(producto_id, unidades, precio_unitario, lote, fecha_vencimiento)
VALUES
(1, 45, 5.10, 'C013', '2027-10-10'),
(2, 50, 7.30, 'C014', '2027-11-22'),
(3, 25, 12.20, 'C015', '2027-08-14'),
(4, 40, 9.90, 'C016', '2028-04-01');

EXEC registrar_compra
    @proveedor_id = 4,
    @sede_id = 7,
    @detalle = @detalleCompra4;
GO


-- COMPRA 5
DECLARE @detalleCompra5 DetalleCompraType;

INSERT INTO @detalleCompra5
(producto_id, unidades, precio_unitario, lote, fecha_vencimiento)
VALUES
(5, 35, 6.80, 'C017', '2027-12-30'),
(6, 30, 9.10, 'C018', '2027-09-09'),
(7, 45, 7.00, 'C019', '2028-01-25'),
(8, 50, 8.20, 'C020', '2027-10-19');

EXEC registrar_compra
    @proveedor_id = 5,
    @sede_id = 10,
    @detalle = @detalleCompra5;
GO

USE Farmacia;
GO


-- VENTA 1
DECLARE @detalleVenta1 DetalleVentaType;

INSERT INTO @detalleVenta1
(producto_id, unidades)
VALUES
(1, 2),
(2, 1),
(3, 1),
(4, 2);

EXEC registrar_venta
    @cliente_id = 1,
    @sede_id = 1,
    @tipo_comprobante = 'BOLETA',
    @metodo_pago = 'EFECTIVO',
    @detalle = @detalleVenta1;
GO


-- VENTA 2
DECLARE @detalleVenta2 DetalleVentaType;

INSERT INTO @detalleVenta2
(producto_id, unidades)
VALUES
(3, 2),
(4, 1),
(5, 3),
(6, 1);

EXEC registrar_venta
    @cliente_id = 2,
    @sede_id = 2,
    @tipo_comprobante = 'FACTURA',
    @metodo_pago = 'TARJETA',
    @detalle = @detalleVenta2;
GO


-- VENTA 3
DECLARE @detalleVenta3 DetalleVentaType;

INSERT INTO @detalleVenta3
(producto_id, unidades)
VALUES
(7, 2),
(8, 2),
(9, 4),
(10, 1);

EXEC registrar_venta
    @cliente_id = 3,
    @sede_id = 5,
    @tipo_comprobante = 'BOLETA',
    @metodo_pago = 'YAPE',
    @detalle = @detalleVenta3;
GO


-- VENTA 4
DECLARE @detalleVenta4 DetalleVentaType;

INSERT INTO @detalleVenta4
(producto_id, unidades)
VALUES
(1, 3),
(2, 2),
(3, 1),
(4, 2);

EXEC registrar_venta
    @cliente_id = 4,
    @sede_id = 7,
    @tipo_comprobante = 'FACTURA',
    @metodo_pago = 'PLIN',
    @detalle = @detalleVenta4;
GO


-- VENTA 5
DECLARE @detalleVenta5 DetalleVentaType;

INSERT INTO @detalleVenta5
(producto_id, unidades)
VALUES
(5, 2),
(6, 1),
(7, 2),
(8, 3);

EXEC registrar_venta
    @cliente_id = 5,
    @sede_id = 10,
    @tipo_comprobante = 'BOLETA',
    @metodo_pago = 'EFECTIVO',
    @detalle = @detalleVenta5;
GO 
 
SELECT * FROM detalle_venta;
SELECT * FROM detalle_compra;