USE Farmacia ; 
GO
--Consultas Básicas
--1 Listar todos los clientes
SELECT *
FROM dbo.cliente;

--2 Listar productos con su categoría
SELECT 
    p.id,
    p.nombre_generico,
    p.nombre_comercial,
    p.laboratorio,
    p.precio_venta,
    c.nombre AS categoria
FROM producto p
INNER JOIN categoria_producto c
    ON p.categoria_id = c.id;

--3 Mostrar ventas con datos del cliente y sede
SELECT 
    v.id AS venta_id,
    c.nombre AS cliente,
    s.nombre AS sede,
    v.fecha_venta,
    v.tipo_comprobante,
    v.metodo_pago,
    v.monto_total
FROM venta v
INNER JOIN cliente c
    ON v.cliente_id = c.id
INNER JOIN sede s
    ON v.sede_id = s.id;

--4 Ver detalle de una venta específica
SELECT 
    dv.id,
    dv.venta_id,
    p.nombre_comercial,
    dv.unidades,
    dv.precio_unitario,
    dv.subtotal
FROM detalle_venta dv
INNER JOIN inventario i
    ON dv.inventario_id = i.id
INNER JOIN producto p
    ON i.producto_id = p.id
WHERE dv.venta_id = 1;

--5 Listar inventario disponible por sede
SELECT 
    s.nombre AS sede,
    p.nombre_comercial AS producto,
    i.stock,
    i.lote,
    i.fecha_vencimiento
FROM inventario i
INNER JOIN sede s
    ON i.sede_id = s.id
INNER JOIN producto p
    ON i.producto_id = p.id
ORDER BY s.nombre, p.nombre_comercial;

--6 Productos con stock menor a 10
SELECT 
    p.nombre_comercial,
    s.nombre AS sede,
    i.stock
FROM inventario i
INNER JOIN producto p
    ON i.producto_id = p.id
INNER JOIN sede s
    ON i.sede_id = s.id
WHERE i.stock < 10;

--7 Ventas realizadas en una fecha específica
SELECT 
    v.id,
    c.nombre AS cliente,
    s.nombre AS sede,
    v.fecha_venta,
    v.monto_total
FROM venta v
INNER JOIN cliente c
    ON v.cliente_id = c.id
INNER JOIN sede s
    ON v.sede_id = s.id
WHERE CAST(v.fecha_venta AS DATE) = '2026-05-29';

--8 Total vendido por cada sede
SELECT 
    s.nombre AS sede,
    SUM(v.monto_total) AS total_vendido
FROM venta v
INNER JOIN sede s
    ON v.sede_id = s.id
GROUP BY s.nombre;

--9 Cantidad total vendida por producto
SELECT 
    p.nombre_comercial,
    SUM(dv.unidades) AS unidades_vendidas
FROM detalle_venta dv
INNER JOIN inventario i
    ON dv.inventario_id = i.id
INNER JOIN producto p
    ON i.producto_id = p.id
GROUP BY p.nombre_comercial
ORDER BY unidades_vendidas DESC;

--10 Compras realizadas a proveedores
SELECT 
    c.id AS compra_id,
    p.razon_social AS proveedor,
    s.nombre AS sede,
    c.fecha_compra
FROM compra c
INNER JOIN proveedor p
    ON c.proveedor_id = p.id
INNER JOIN sede s
    ON c.sede_id = s.id;

--Consultas Avanzadas
--11 Ranking de productos más vendidos usando
SELECT 
    ROW_NUMBER() OVER (ORDER BY SUM(dv.unidades) DESC) AS ranking,
    p.nombre_comercial,
    SUM(dv.unidades) AS total_unidades_vendidas
FROM detalle_venta dv
INNER JOIN inventario i
    ON dv.inventario_id = i.id
INNER JOIN producto p
    ON i.producto_id = p.id
GROUP BY p.nombre_comercial;

--12 Ventas mensuales por sede
SELECT 
    s.nombre AS sede,
    YEAR(v.fecha_venta) AS anio,
    MONTH(v.fecha_venta) AS mes,
    SUM(v.monto_total) AS total_mensual
FROM venta v
INNER JOIN sede s
    ON v.sede_id = s.id
GROUP BY 
    s.nombre,
    YEAR(v.fecha_venta),
    MONTH(v.fecha_venta)
ORDER BY anio, mes, sede;

--13 Cliente que más ha comprado
SELECT TOP 1
    c.nombre AS cliente,
    SUM(v.monto_total) AS total_comprado
FROM venta v
INNER JOIN cliente c
    ON v.cliente_id = c.id
GROUP BY c.nombre
ORDER BY total_comprado DESC;

--14 Productos próximos a vencer en los siguientes 30 días
SELECT 
    p.nombre_comercial,
    s.nombre AS sede,
    i.lote,
    i.stock,
    i.fecha_vencimiento
FROM inventario i
INNER JOIN producto p
    ON i.producto_id = p.id
INNER JOIN sede s
    ON i.sede_id = s.id
WHERE i.fecha_vencimiento BETWEEN GETDATE() AND DATEADD(DAY, 30, GETDATE())
ORDER BY i.fecha_vencimiento;

--15 Categorías con mayor ingreso por ventas
SELECT 
    cp.nombre AS categoria,
    SUM(dv.subtotal) AS ingreso_total
FROM detalle_venta dv
INNER JOIN inventario i
    ON dv.inventario_id = i.id
INNER JOIN producto p
    ON i.producto_id = p.id
INNER JOIN categoria_producto cp
    ON p.categoria_id = cp.id
GROUP BY cp.nombre
ORDER BY ingreso_total DESC;

--16 Promedio de venta por cliente
SELECT 
    c.nombre AS cliente,
    COUNT(v.id) AS cantidad_ventas,
    AVG(v.monto_total) AS promedio_por_venta
FROM cliente c
INNER JOIN venta v
    ON c.id = v.cliente_id
GROUP BY c.nombre
ORDER BY promedio_por_venta DESC;

--17 Productos que nunca se han vendido
SELECT 
    p.id,
    p.nombre_comercial,
    p.nombre_generico
FROM producto p
WHERE NOT EXISTS (
    SELECT 1
    FROM inventario i
    INNER JOIN detalle_venta dv
        ON i.id = dv.inventario_id
    WHERE i.producto_id = p.id
);

--18 Comparar stock total comprado vs stock actual por producto
SELECT 
    p.nombre_comercial,
    ISNULL(SUM(dc.unidades), 0) AS unidades_compradas,
    ISNULL(SUM(i.stock), 0) AS stock_actual
FROM producto p
LEFT JOIN inventario i
    ON p.id = i.producto_id
LEFT JOIN detalle_compra dc
    ON i.id = dc.inventario_id
GROUP BY p.nombre_comercial
ORDER BY p.nombre_comercial;

--19 Ventas por método de pago con porcentaje del total
SELECT 
    metodo_pago,
    SUM(monto_total) AS total_por_metodo,
    CAST(
        SUM(monto_total) * 100.0 / 
        SUM(SUM(monto_total)) OVER ()
        AS DECIMAL(10,2)
    ) AS porcentaje_total
FROM venta
GROUP BY metodo_pago
ORDER BY total_por_metodo DESC;

--20 Reporte completo de rentabilidad estimada por producto
SELECT 
    p.nombre_comercial,
    cp.nombre AS categoria,
    SUM(dv.unidades) AS unidades_vendidas,
    AVG(dc.precio_unitario) AS precio_compra_promedio,
    AVG(dv.precio_unitario) AS precio_venta_promedio,
    SUM(dv.subtotal) AS ingreso_total,
    SUM(dv.unidades * dc.precio_unitario) AS costo_estimado,
    SUM(dv.subtotal) - SUM(dv.unidades * dc.precio_unitario) AS ganancia_estimada
FROM detalle_venta dv
INNER JOIN inventario i
    ON dv.inventario_id = i.id
INNER JOIN producto p
    ON i.producto_id = p.id
INNER JOIN categoria_producto cp
    ON p.categoria_id = cp.id
LEFT JOIN detalle_compra dc
    ON i.id = dc.inventario_id
GROUP BY 
    p.nombre_comercial,
    cp.nombre
ORDER BY ganancia_estimada DESC;
