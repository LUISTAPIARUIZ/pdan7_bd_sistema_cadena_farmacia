
USE Farmacia;
GO

/*
Ejercicio 1. Listar todos los clientes registrados.
*/
SELECT id, nombre, telefono, correo, direccion
FROM cliente;
GO

/*
Ejercicio 2. Mostrar los productos con su categoría.
*/
SELECT
    p.id,
    p.nombre_generico,
    p.nombre_comercial,
    c.nombre AS categoria,
    p.precio_venta
FROM producto p
INNER JOIN categoria_producto c ON c.id = p.categoria_id;
GO

/*
Ejercicio 3. Listar los productos que requieren receta médica.
*/
SELECT id, nombre_generico, nombre_comercial, laboratorio
FROM producto
WHERE receta_medica = 1;
GO

/*
Ejercicio 4. Mostrar las sedes ubicadas en el distrito de Independencia.
*/
SELECT id, nombre, direccion, distrito
FROM sede
WHERE distrito = 'Independencia';
GO

/*
Ejercicio 5. Mostrar el stock actual por producto y sede.
*/
SELECT
    s.nombre AS sede,
    p.nombre_generico AS producto,
    i.stock,
    i.lote,
    i.fecha_vencimiento
FROM inventario i
INNER JOIN producto p ON p.id = i.producto_id
INNER JOIN sede s ON s.id = i.sede_id
ORDER BY s.nombre, p.nombre_generico;
GO

/*
NIVEL INTERMEDIO
Ejercicio 6. Calcular el total vendido por cada sede.
*/
SELECT
    s.nombre AS sede,
    SUM(v.monto_total) AS total_vendido
FROM venta v
INNER JOIN sede s ON s.id = v.sede_id
GROUP BY s.nombre
ORDER BY total_vendido DESC;
GO

/*
Ejercicio 7. Mostrar los 5 productos más vendidos por unidades.
*/
SELECT TOP 5
    p.nombre_generico AS producto,
    SUM(dv.unidades) AS unidades_vendidas
FROM detalle_venta dv
INNER JOIN inventario i ON i.id = dv.inventario_id
INNER JOIN producto p ON p.id = i.producto_id
GROUP BY p.nombre_generico
ORDER BY unidades_vendidas DESC;
GO

/*
Ejercicio 8. Mostrar productos con stock menor a 50 unidades.
*/
SELECT
    s.nombre AS sede,
    p.nombre_generico AS producto,
    i.stock
FROM inventario i
INNER JOIN producto p ON p.id = i.producto_id
INNER JOIN sede s ON s.id = i.sede_id
WHERE i.stock < 50
ORDER BY i.stock ASC;
GO

/*
Ejercicio 9. Calcular el precio promedio de venta por categoría.
*/
SELECT
    c.nombre AS categoria,
    AVG(p.precio_venta) AS precio_promedio
FROM producto p
INNER JOIN categoria_producto c ON c.id = p.categoria_id
GROUP BY c.nombre
ORDER BY precio_promedio DESC;
GO

/*
Ejercicio 10. Calcular el total comprado por proveedor.
*/
SELECT
    pr.razon_social AS proveedor,
    SUM(dc.subtotal) AS total_comprado
FROM compra c
INNER JOIN proveedor pr ON pr.id = c.proveedor_id
INNER JOIN detalle_compra dc ON dc.compra_id = c.id
GROUP BY pr.razon_social
ORDER BY total_comprado DESC;
GO

/*
Ejercicio 11 Calcular el total de ventas por método de pago.
*/
SELECT
    metodo_pago,
    COUNT(*) AS cantidad_ventas,
    SUM(monto_total) AS total_vendido
FROM venta
GROUP BY metodo_pago
ORDER BY total_vendido DESC;
GO

/*
Ejercicio 12. Mostrar productos que vencen antes del 31/12/2026.
*/
SELECT
    p.nombre_generico AS producto,
    s.nombre AS sede,
    i.lote,
    i.fecha_vencimiento,
    i.stock
FROM inventario i
INNER JOIN producto p ON p.id = i.producto_id
INNER JOIN sede s ON s.id = i.sede_id
WHERE i.fecha_vencimiento < '2026-12-31'
ORDER BY i.fecha_vencimiento ASC;
GO

/*
NIVEL AVANZADO
Ejercicio 13. Mostrarr clientes que compraron productos con receta médica.
*/
SELECT DISTINCT
    c.id,
    c.nombre,
    c.correo
FROM cliente c
INNER JOIN venta v ON v.cliente_id = c.id
INNER JOIN detalle_venta dv ON dv.venta_id = v.id
INNER JOIN inventario i ON i.id = dv.inventario_id
INNER JOIN producto p ON p.id = i.producto_id
WHERE p.receta_medica = 1;
GO

/*
Ejercicio 14. Comparar unidades compradas vs unidades vendidas por producto
*/
SELECT
    p.nombre_generico AS producto,
    ISNULL(SUM(dc.unidades), 0) AS unidades_compradas,
    ISNULL(vv.unidades_vendidas, 0) AS unidades_vendidas,
    ISNULL(SUM(dc.unidades), 0) - ISNULL(vv.unidades_vendidas, 0) AS diferencia
FROM producto p
LEFT JOIN inventario i ON i.producto_id = p.id
LEFT JOIN detalle_compra dc ON dc.inventario_id = i.id
LEFT JOIN (
    SELECT
        i2.producto_id,
        SUM(dv.unidades) AS unidades_vendidas
    FROM detalle_venta dv
    INNER JOIN inventario i2 ON i2.id = dv.inventario_id
    GROUP BY i2.producto_id
) vv ON vv.producto_id = p.id
GROUP BY p.nombre_generico, vv.unidades_vendidas
ORDER BY diferencia DESC;
GO

/*
Ejercicio 15. Ranking de ventas por sede usando ROW_NUMBER
*/
SELECT
    s.nombre AS sede,
    v.id AS venta_id,
    v.fecha_venta,
    v.monto_total,
    ROW_NUMBER() OVER(PARTITION BY s.id ORDER BY v.monto_total DESC) AS ranking_en_sede
FROM venta v
INNER JOIN sede s ON s.id = v.sede_id
ORDER BY s.nombre, ranking_en_sede;
GO

/*
Ejercicio 16. Calcular el valor de inventario por sede segun precio de venta.
*/
SELECT
    s.nombre AS sede,
    SUM(i.stock * p.precio_venta) AS valor_inventario
FROM inventario i
INNER JOIN producto p ON p.id = i.producto_id
INNER JOIN sede s ON s.id = i.sede_id
GROUP BY s.nombre
ORDER BY valor_inventario DESC;
GO

/*
Ejercicio 17. Calcular ventas mensuales
*/
SELECT
    YEAR(fecha_venta) AS anio,
    MONTH(fecha_venta) AS mes,
    COUNT(*) AS cantidad_ventas,
    SUM(monto_total) AS total_vendido
FROM venta
GROUP BY YEAR(fecha_venta), MONTH(fecha_venta)
ORDER BY anio, mes;
GO

/*
Ejercicio 18. Estimar utilidad por producto usando costo promedio de compra
*/
WITH costo_promedio AS (
    SELECT
        i.producto_id,
        AVG(dc.precio_unitario) AS costo_promedio
    FROM detalle_compra dc
    INNER JOIN inventario i ON i.id = dc.inventario_id
    GROUP BY i.producto_id
)
SELECT
    p.nombre_generico AS producto,
    SUM(dv.unidades) AS unidades_vendidas,
    SUM(dv.subtotal) AS ingresos,
    SUM(dv.unidades * ISNULL(cp.costo_promedio, 0)) AS costo_estimado,
    SUM(dv.subtotal) - SUM(dv.unidades * ISNULL(cp.costo_promedio, 0)) AS utilidad_estimada
FROM detalle_venta dv
INNER JOIN inventario i ON i.id = dv.inventario_id
INNER JOIN producto p ON p.id = i.producto_id
LEFT JOIN costo_promedio cp ON cp.producto_id = p.id
GROUP BY p.nombre_generico
ORDER BY utilidad_estimada DESC;
GO

/*
Ejercicio 19. Mostrare productos que todavía no se han vendido.
*/
SELECT
    p.id,
    p.nombre_generico,
    p.nombre_comercial
FROM producto p
WHERE NOT EXISTS (
    SELECT 1
    FROM detalle_venta dv
    INNER JOIN inventario i ON i.id = dv.inventario_id
    WHERE i.producto_id = p.id
);
GO

/*
Ejercicio 20. Crear un historial de movimientos de inventario: compras y ventas
*/
SELECT
    'COMPRA' AS tipo_movimiento,
    c.fecha_compra AS fecha,
    s.nombre AS sede,
    p.nombre_generico AS producto,
    dc.unidades AS unidades,
    dc.precio_unitario,
    dc.subtotal
FROM detalle_compra dc
INNER JOIN compra c ON c.id = dc.compra_id
INNER JOIN inventario i ON i.id = dc.inventario_id
INNER JOIN producto p ON p.id = i.producto_id
INNER JOIN sede s ON s.id = c.sede_id

UNION ALL

SELECT
    'VENTA' AS tipo_movimiento,
    v.fecha_venta AS fecha,
    s.nombre AS sede,
    p.nombre_generico AS producto,
    dv.unidades * -1 AS unidades,
    dv.precio_unitario,
    dv.subtotal
FROM detalle_venta dv
INNER JOIN venta v ON v.id = dv.venta_id
INNER JOIN inventario i ON i.id = dv.inventario_id
INNER JOIN producto p ON p.id = i.producto_id
INNER JOIN sede s ON s.id = v.sede_id
ORDER BY fecha, tipo_movimiento;
GO

-- ============================================================
-- 7. EJERCICIOS DE VISTAS, PROCEDIMIENTOS Y FUNCIONES
-- ============================================================

/*
Ejercicio 1. Crear una vista para consultar el stock actual.
*/
CREATE VIEW vw_stock_actual AS
SELECT
    i.id AS inventario_id,
    s.nombre AS sede,
    s.distrito,
    p.nombre_generico AS producto,
    p.nombre_comercial,
    c.nombre AS categoria,
    i.stock,
    i.lote,
    i.fecha_vencimiento
FROM inventario i
INNER JOIN sede s ON s.id = i.sede_id
INNER JOIN producto p ON p.id = i.producto_id
INNER JOIN categoria_producto c ON c.id = p.categoria_id;
GO

SELECT * FROM vw_stock_actual;
GO

/*
Ejercicio 2. Crear una vista de ventas detalladas.
*/
CREATE VIEW vw_ventas_detalladas AS
SELECT
    v.id AS venta_id,
    v.fecha_venta,
    c.nombre AS cliente,
    s.nombre AS sede,
    s.distrito,
    p.nombre_generico AS producto,
    cat.nombre AS categoria,
    dv.unidades,
    dv.precio_unitario,
    dv.subtotal,
    v.tipo_comprobante,
    v.metodo_pago
FROM venta v
INNER JOIN cliente c ON c.id = v.cliente_id
INNER JOIN sede s ON s.id = v.sede_id
INNER JOIN detalle_venta dv ON dv.venta_id = v.id
INNER JOIN inventario i ON i.id = dv.inventario_id
INNER JOIN producto p ON p.id = i.producto_id
INNER JOIN categoria_producto cat ON cat.id = p.categoria_id;
GO

SELECT * FROM vw_ventas_detalladas;
GO

/*
Ejercicio  3. Crear una vista de compras detalladas.
*/
CREATE VIEW vw_compras_detalladas AS
SELECT
    c.id AS compra_id,
    c.fecha_compra,
    pr.razon_social AS proveedor,
    s.nombre AS sede,
    p.nombre_generico AS producto,
    dc.unidades,
    dc.precio_unitario,
    dc.subtotal
FROM compra c
INNER JOIN proveedor pr ON pr.id = c.proveedor_id
INNER JOIN sede s ON s.id = c.sede_id
INNER JOIN detalle_compra dc ON dc.compra_id = c.id
INNER JOIN inventario i ON i.id = dc.inventario_id
INNER JOIN producto p ON p.id = i.producto_id;
GO

SELECT * FROM vw_compras_detalladas;
GO

/*
Ejercicio 4. Crear una vista de resumen de ventas por sede.
*/
CREATE VIEW vw_resumen_ventas_sede AS
SELECT
    s.id AS sede_id,
    s.nombre AS sede,
    COUNT(DISTINCT v.id) AS cantidad_ventas,
    SUM(dv.unidades) AS unidades_vendidas,
    SUM(dv.subtotal) AS total_vendido
FROM sede s
LEFT JOIN venta v ON v.sede_id = s.id
LEFT JOIN detalle_venta dv ON dv.venta_id = v.id
GROUP BY s.id, s.nombre;
GO

SELECT * FROM vw_resumen_ventas_sede;
GO

/*
Ejercicio 5. Crear un procedimiento para reportar ventas por rango de fechas.
*/
CREATE PROCEDURE sp_reporte_ventas_por_fecha
    @fecha_inicio DATE,
    @fecha_fin DATE
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        v.fecha_venta,
        v.id AS venta_id,
        c.nombre AS cliente,
        s.nombre AS sede,
        v.metodo_pago,
        v.monto_total
    FROM venta v
    INNER JOIN cliente c ON c.id = v.cliente_id
    INNER JOIN sede s ON s.id = v.sede_id
    WHERE v.fecha_venta BETWEEN @fecha_inicio AND @fecha_fin
    ORDER BY v.fecha_venta, v.id;
END;
GO

EXEC sp_reporte_ventas_por_fecha '2026-01-01', '2026-12-31';
GO

/*
Ejercicio 6. Crear un procedimiento para listar productos bajo stock mínimo.
*/
CREATE PROCEDURE sp_productos_bajo_stock
    @stock_minimo INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        s.nombre AS sede,
        p.nombre_generico AS producto,
        i.stock
    FROM inventario i
    INNER JOIN sede s ON s.id = i.sede_id
    INNER JOIN producto p ON p.id = i.producto_id
    WHERE i.stock <= @stock_minimo
    ORDER BY i.stock ASC;
END;
GO

EXEC sp_productos_bajo_stock 50;
GO

/*
Ejercicio 7. Crear un procedimiento para mostrar historial de compras de un cliente.
*/
CREATE PROCEDURE sp_historial_cliente
    @cliente_id INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        v.id AS venta_id,
        v.fecha_venta,
        p.nombre_generico AS producto,
        dv.unidades,
        dv.precio_unitario,
        dv.subtotal,
        v.metodo_pago
    FROM venta v
    INNER JOIN detalle_venta dv ON dv.venta_id = v.id
    INNER JOIN inventario i ON i.id = dv.inventario_id
    INNER JOIN producto p ON p.id = i.producto_id
    WHERE v.cliente_id = @cliente_id
    ORDER BY v.fecha_venta DESC;
END;
GO

EXEC sp_historial_cliente 1;
GO

/*
Ejercicio  8. Crear una funció escalar para calcular el total vendido a un cliente.
*/
CREATE FUNCTION fn_total_ventas_cliente
(
    @cliente_id INT
)
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @total DECIMAL(10,2);

    SELECT @total = ISNULL(SUM(monto_total), 0)
    FROM venta
    WHERE cliente_id = @cliente_id;

    RETURN @total;
END;
GO

SELECT dbo.fn_total_ventas_cliente(1) AS total_cliente_1;
GO

/*
Ejercicio  9. Crear una función escalar que devuelva el stock de un producto en una sede.
*/
CREATE FUNCTION fn_stock_producto_sede
(
    @producto_id INT,
    @sede_id INT
)
RETURNS INT
AS
BEGIN
    DECLARE @stock INT;

    SELECT @stock = ISNULL(stock, 0)
    FROM inventario
    WHERE producto_id = @producto_id
      AND sede_id = @sede_id;

    RETURN ISNULL(@stock, 0);
END;
GO

SELECT dbo.fn_stock_producto_sede(1, 1) AS stock_producto_1_sede_1;
GO

/*
Ejercicio 10. Crear una función escalar para calcular el monto promedio de venta por sede.
*/
CREATE FUNCTION fn_monto_promedio_venta_sede
(
    @sede_id INT
)
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @promedio DECIMAL(10,2);

    SELECT @promedio = ISNULL(AVG(monto_total), 0)
    FROM venta
    WHERE sede_id = @sede_id;

    RETURN @promedio;
END;
GO

SELECT dbo.fn_monto_promedio_venta_sede(1) AS promedio_venta_sede_1;
GO

-- ============================================================
-- 8. MODELO DIMENSIONoAL CON DATOS
-- ============================================================
/*
Modelo estrella:
- dw.dim_tiempo
- dw.dim_cliente
- dw.dim_producto
- dw.dim_sede
- dw.dim_proveedor
- dw.fact_ventas
- dw.fact_compras

*/

IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'dw')
    EXEC('CREATE SCHEMA dw');
GO

CREATE TABLE dw.dim_tiempo (
    tiempo_key INT IDENTITY(1,1) PRIMARY KEY,
    fecha DATE NOT NULL UNIQUE,
    anio INT NOT NULL,
    trimestre INT NOT NULL,
    mes INT NOT NULL,
    nombre_mes VARCHAR(20) NOT NULL,
    dia INT NOT NULL,
    dia_semana VARCHAR(20) NOT NULL
);
GO

CREATE TABLE dw.dim_cliente (
    cliente_key INT IDENTITY(1,1) PRIMARY KEY,
    cliente_id INT NOT NULL UNIQUE,
    nombre VARCHAR(100) NOT NULL,
    correo VARCHAR(100) NULL,
    telefono VARCHAR(20) NULL,
    direccion VARCHAR(150) NULL
);
GO

CREATE TABLE dw.dim_producto (
    producto_key INT IDENTITY(1,1) PRIMARY KEY,
    producto_id INT NOT NULL UNIQUE,
    nombre_generico VARCHAR(100) NOT NULL,
    nombre_comercial VARCHAR(100) NULL,
    laboratorio VARCHAR(100) NULL,
    categoria VARCHAR(100) NOT NULL,
    receta_medica BIT NOT NULL,
    precio_venta DECIMAL(10,2) NULL,
    estado VARCHAR(50) NULL
);
GO

CREATE TABLE dw.dim_sede (
    sede_key INT IDENTITY(1,1) PRIMARY KEY,
    sede_id INT NOT NULL UNIQUE,
    nombre VARCHAR(100) NOT NULL,
    ciudad VARCHAR(100) NULL,
    distrito VARCHAR(100) NULL,
    direccion VARCHAR(150) NULL
);
GO

CREATE TABLE dw.dim_proveedor (
    proveedor_key INT IDENTITY(1,1) PRIMARY KEY,
    proveedor_id INT NOT NULL UNIQUE,
    ruc VARCHAR(20) NOT NULL,
    razon_social VARCHAR(150) NOT NULL,
    telefono VARCHAR(20) NULL,
    correo VARCHAR(100) NULL
);
GO

CREATE TABLE dw.fact_ventas (
    fact_venta_key INT IDENTITY(1,1) PRIMARY KEY,
    tiempo_key INT NOT NULL,
    cliente_key INT NOT NULL,
    producto_key INT NOT NULL,
    sede_key INT NOT NULL,
    venta_id INT NOT NULL,
    detalle_venta_id INT NOT NULL,
    unidades INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL,

    CONSTRAINT FK_fact_ventas_tiempo
        FOREIGN KEY (tiempo_key) REFERENCES dw.dim_tiempo(tiempo_key),

    CONSTRAINT FK_fact_ventas_cliente
        FOREIGN KEY (cliente_key) REFERENCES dw.dim_cliente(cliente_key),

    CONSTRAINT FK_fact_ventas_producto
        FOREIGN KEY (producto_key) REFERENCES dw.dim_producto(producto_key),

    CONSTRAINT FK_fact_ventas_sede
        FOREIGN KEY (sede_key) REFERENCES dw.dim_sede(sede_key)
);
GO

CREATE TABLE dw.fact_compras (
    fact_compra_key INT IDENTITY(1,1) PRIMARY KEY,
    tiempo_key INT NOT NULL,
    proveedor_key INT NOT NULL,
    producto_key INT NOT NULL,
    sede_key INT NOT NULL,
    compra_id INT NOT NULL,
    detalle_compra_id INT NOT NULL,
    unidades INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL,

    CONSTRAINT FK_fact_compras_tiempo
        FOREIGN KEY (tiempo_key) REFERENCES dw.dim_tiempo(tiempo_key),

    CONSTRAINT FK_fact_compras_proveedor
        FOREIGN KEY (proveedor_key) REFERENCES dw.dim_proveedor(proveedor_key),

    CONSTRAINT FK_fact_compras_producto
        FOREIGN KEY (producto_key) REFERENCES dw.dim_producto(producto_key),

    CONSTRAINT FK_fact_compras_sede
        FOREIGN KEY (sede_key) REFERENCES dw.dim_sede(sede_key)
);
GO

-- Cargar dimensión tiempo desde compras y ventas
INSERT INTO dw.dim_tiempo(fecha, anio, trimestre, mes, nombre_mes, dia, dia_semana)
SELECT DISTINCT
    fechas.fecha,
    YEAR(fechas.fecha) AS anio,
    DATEPART(QUARTER, fechas.fecha) AS trimestre,
    MONTH(fechas.fecha) AS mes,
    DATENAME(MONTH, fechas.fecha) AS nombre_mes,
    DAY(fechas.fecha) AS dia,
    DATENAME(WEEKDAY, fechas.fecha) AS dia_semana
FROM (
    SELECT fecha_venta AS fecha FROM venta
    UNION
    SELECT fecha_compra AS fecha FROM compra
) fechas;
GO

INSERT INTO dw.dim_cliente(cliente_id, nombre, correo, telefono, direccion)
SELECT id, nombre, correo, telefono, direccion
FROM cliente;
GO

INSERT INTO dw.dim_producto
(producto_id, nombre_generico, nombre_comercial, laboratorio, categoria, receta_medica, precio_venta, estado)
SELECT
    p.id,
    p.nombre_generico,
    p.nombre_comercial,
    p.laboratorio,
    c.nombre AS categoria,
    p.receta_medica,
    p.precio_venta,
    p.estado
FROM producto p
INNER JOIN categoria_producto c ON c.id = p.categoria_id;
GO

INSERT INTO dw.dim_sede(sede_id, nombre, ciudad, distrito, direccion)
SELECT id, nombre, ciudad, distrito, direccion
FROM sede;
GO

INSERT INTO dw.dim_proveedor(proveedor_id, ruc, razon_social, telefono, correo)
SELECT id, ruc, razon_social, telefono, correo
FROM proveedor;
GO

INSERT INTO dw.fact_ventas
(tiempo_key, cliente_key, producto_key, sede_key, venta_id, detalle_venta_id, unidades, precio_unitario, subtotal)
SELECT
    dt.tiempo_key,
    dc.cliente_key,
    dp.producto_key,
    ds.sede_key,
    v.id AS venta_id,
    dv.id AS detalle_venta_id,
    dv.unidades,
    dv.precio_unitario,
    dv.subtotal
FROM detalle_venta dv
INNER JOIN venta v ON v.id = dv.venta_id
INNER JOIN inventario i ON i.id = dv.inventario_id
INNER JOIN dw.dim_tiempo dt ON dt.fecha = v.fecha_venta
INNER JOIN dw.dim_cliente dc ON dc.cliente_id = v.cliente_id
INNER JOIN dw.dim_producto dp ON dp.producto_id = i.producto_id
INNER JOIN dw.dim_sede ds ON ds.sede_id = v.sede_id;
GO

INSERT INTO dw.fact_compras
(tiempo_key, proveedor_key, producto_key, sede_key, compra_id, detalle_compra_id, unidades, precio_unitario, subtotal)
SELECT
    dt.tiempo_key,
    dpv.proveedor_key,
    dpr.producto_key,
    ds.sede_key,
    c.id AS compra_id,
    dc.id AS detalle_compra_id,
    dc.unidades,
    dc.precio_unitario,
    dc.subtotal
FROM detalle_compra dc
INNER JOIN compra c ON c.id = dc.compra_id
INNER JOIN inventario i ON i.id = dc.inventario_id
INNER JOIN dw.dim_tiempo dt ON dt.fecha = c.fecha_compra
INNER JOIN dw.dim_proveedor dpv ON dpv.proveedor_id = c.proveedor_id
INNER JOIN dw.dim_producto dpr ON dpr.producto_id = i.producto_id
INNER JOIN dw.dim_sede ds ON ds.sede_id = c.sede_id;
GO

-- Consultas de prueba del modelo dimensional

-- Total vendido por mes
SELECT
    dt.anio,
    dt.mes,
    dt.nombre_mes,
    SUM(fv.subtotal) AS total_vendido
FROM dw.fact_ventas fv
INNER JOIN dw.dim_tiempo dt ON dt.tiempo_key = fv.tiempo_key
GROUP BY dt.anio, dt.mes, dt.nombre_mes
ORDER BY dt.anio, dt.mes;
GO

-- Total vendido por categoría
SELECT
    dp.categoria,
    SUM(fv.unidades) AS unidades_vendidas,
    SUM(fv.subtotal) AS total_vendido
FROM dw.fact_ventas fv
INNER JOIN dw.dim_producto dp ON dp.producto_key = fv.producto_key
GROUP BY dp.categoria
ORDER BY total_vendido DESC;
GO

-- Total comprado por proveedor
SELECT
    dpv.razon_social AS proveedor,
    SUM(fc.unidades) AS unidades_compradas,
    SUM(fc.subtotal) AS total_comprado
FROM dw.fact_compras fc
INNER JOIN dw.dim_proveedor dpv ON dpv.proveedor_key = fc.proveedor_key
GROUP BY dpv.razon_social
ORDER BY total_comprado DESC;
GO

-- Ventas por sede y distrito
SELECT
    ds.distrito,
    ds.nombre AS sede,
    SUM(fv.unidades) AS unidades_vendidas,
    SUM(fv.subtotal) AS total_vendido
FROM dw.fact_ventas fv
INNER JOIN dw.dim_sede ds ON ds.sede_key = fv.sede_key
GROUP BY ds.distrito, ds.nombre
ORDER BY total_vendido DESC;
GO

-- Validación de cantidad de filas cargadas al modelo dimensional
SELECT 'dw.dim_tiempo' AS tabla, COUNT(*) AS filas FROM dw.dim_tiempo
UNION ALL
SELECT 'dw.dim_cliente', COUNT(*) FROM dw.dim_cliente
UNION ALL
SELECT 'dw.dim_producto', COUNT(*) FROM dw.dim_producto
UNION ALL
SELECT 'dw.dim_sede', COUNT(*) FROM dw.dim_sede
UNION ALL
SELECT 'dw.dim_proveedor', COUNT(*) FROM dw.dim_proveedor
UNION ALL
SELECT 'dw.fact_ventas', COUNT(*) FROM dw.fact_ventas
UNION ALL
SELECT 'dw.fact_compras', COUNT(*) FROM dw.fact_compras;
GO
