“Sistema de Gestión y Monitoreo de Inventario Inteligente para Cadena de Farmacias” 💊

Contexto del negocio

La cadena de farmacias SaludPlus Perú cuenta con varias sedes en Lima y provincias. Actualmente, el control de inventario se realiza de forma semi manual, lo que genera problemas como falta de stock, vencimiento de medicamentos, exceso de productos en algunas tiendas y demoras en la reposición.

Por ello, la empresa ha decidido implementar un Sistema de Gestión y Monitoreo de Inventario Inteligente, que permita controlar productos, sedes, proveedores, compras, ventas, vencimientos y alertas de stock.

Objetivo del sistema

Diseñar una base de datos que permita:

Registrar medicamentos y productos farmacéuticos.
Controlar el stock por sede.
Gestionar compras a proveedores.
Registrar ventas a clientes.
Detectar productos próximos a vencer.
Generar alertas por bajo stock o sobrestock.
Obtener reportes para la toma de decisiones.

Alcance funcional
1. 🏪 Gestión de Sedes

La empresa cuenta con varias farmacias.

Cada sede tiene:

código de sede
nombre
dirección
distrito
ciudad
teléfono
responsable de sede

Una sede puede tener muchos productos en inventario.

2. 💊 Gestión de Productos

El sistema registra diferentes tipos de productos:

medicamentos
vitaminas
productos de cuidado personal
dispositivos médicos
productos para bebés

Cada producto tiene:

código de producto
nombre comercial
nombre genérico
laboratorio
categoría
presentación
precio de venta
requiere receta médica
estado

3. 📦 Inventario por Sede

Cada sede maneja su propio stock.

El inventario debe registrar:

producto
sede
cantidad disponible
stock mínimo
stock máximo
lote
fecha de vencimiento

Un mismo producto puede existir en varias sedes y en distintos lotes.

4. 🚚 Proveedores y Compras

La farmacia compra productos a distintos proveedores.

Cada proveedor tiene:

RUC
razón social
contacto
teléfono
correo
dirección

Cada compra incluye:

fecha de compra
proveedor
sede destino
productos comprados
cantidad
costo unitario
fecha de vencimiento del lote

5. 🧾 Ventas

Los clientes pueden comprar uno o varios productos.

Cada venta registra:

fecha de venta
sede
cliente
vendedor
tipo de comprobante
método de pago
total de venta

El detalle de venta incluye:

producto
cantidad
precio unitario
subtotal

6. 👤 Gestión de Clientes

El sistema puede registrar clientes frecuentes.

Cada cliente tiene:

DNI
nombres
apellidos
teléfono
correo
fecha de nacimiento

Un cliente puede realizar muchas compras en distintas sedes.

7. ⚠️ Alertas de Inventario

El sistema debe permitir:

identificar productos con bajo stock
detectar productos próximos a vencer
registrar productos vencidos
detectar exceso de inventario
generar alertas para reposición

Cada alerta debe tener:

fecha de alerta
tipo de alerta
producto
sede
descripción
estado
Reglas de negocio clave

Un producto puede estar disponible en muchas sedes.
Una sede puede tener muchos productos.
Un proveedor puede abastecer muchos productos.
Una compra pertenece a un solo proveedor.
Una compra puede incluir muchos productos.
Una venta pertenece a una sola sede.
Una venta puede incluir varios productos.
Un cliente puede realizar muchas ventas.
Un producto puede tener varios lotes con diferentes fechas de vencimiento.
Una alerta se genera para un producto específico en una sede específica.
El stock se actualiza cuando se registra una compra o una venta.
