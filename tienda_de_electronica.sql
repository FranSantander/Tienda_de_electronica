--Creación de las tablas
CREATE TABLE clientes(
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(50),
    rut VARCHAR(12),
    direccion VARCHAR(50)
);

CREATE TABLE categorias(
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(50),
    descripcion VARCHAR(50)
);

CREATE TABLE productos(
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(50),
    descripcion VARCHAR(50),
    valor FLOAT,
    stock INT CHECK (stock >= 0),
    id_categoria INT,
    FOREIGN KEY (id_categoria) REFERENCES categorias (id)
);

CREATE TABLE facturas(
    id SERIAL PRIMARY KEY,
    fecha DATE,
    subtotal FLOAT,
    id_cliente INT,
    FOREIGN KEY (id_cliente) REFERENCES clientes (id)
);

CREATE TABLE producto_factura(
    id_producto INT,
    id_factura INT,
    cantidad INT,
    FOREIGN KEY (id_producto) REFERENCES productos (id),
    FOREIGN KEY (id_factura) REFERENCES facturas (id)
);

--Inicio requerimientos Parte II

--Ingresi de 3 clientes

INSERT INTO clientes (nombre, rut, direccion) VALUES
('Jocelyn', '22.465.748-7', 'direccion 1');
INSERT INTO clientes (nombre, rut, direccion) VALUES
('Diego', '20.785.123-4', 'direccion 3');
INSERT INTO clientes (nombre, rut, direccion) VALUES
('Ignacia', '26.852.741-3', 'direccion 2');

--Ingreso Categorías

INSERT INTO categorias (nombre, descripcion) VALUES ('Computadora',
'descripcion categoria 1');
INSERT INTO categorias (nombre, descripcion) VALUES ('Audio y Video',
'descripcion categoria 2');

--Insertar 5 productos

INSERT INTO productos (nombre, descripcion, valor, stock, id_categoria)
VALUES ('Mouse', 'descripcion producto 1', 15, 10, 1);
INSERT INTO productos (nombre, descripcion, valor, stock, id_categoria)
VALUES ('Teclado', 'descripcion producto 2', 30, 10, 1);
INSERT INTO productos (nombre, descripcion, valor, stock, id_categoria)
VALUES ('Monitor', 'descripcion producto 3', 80, 10, 1);
INSERT INTO productos (nombre, descripcion, valor, stock, id_categoria)
VALUES ('Audifonos', 'descripcion producto 4', 50, 10, 2);
INSERT INTO productos (nombre, descripcion, valor, stock, id_categoria)
VALUES ('Cable HDMI', 'descripcion producto 5', 15, 10, 2);

--Ingresar de las facturas

BEGIN;
INSERT INTO facturas (id_cliente, fecha) VALUES (1, '2020-07-28');
INSERT INTO producto_factura (id_producto, id_factura, cantidad) VALUES
(1, 1, 1);
INSERT INTO producto_factura (id_producto, id_factura, cantidad) VALUES
(2, 1, 3);
INSERT INTO producto_factura (id_producto, id_factura, cantidad) VALUES
(3, 1, 2);
UPDATE facturas SET subtotal = 265 WHERE id = 1;
UPDATE productos SET stock = stock -1 where id = 1;
UPDATE productos SET stock = stock -3 where id = 2;
UPDATE productos SET stock = stock -2 where id = 3;
COMMIT;

BEGIN;
INSERT INTO facturas (id_cliente, fecha) VALUES (2, '2020-11-04');
INSERT INTO producto_factura (id_producto, id_factura, cantidad) VALUES
(4, 2, 1);
INSERT INTO producto_factura (id_producto, id_factura, cantidad) VALUES
(5, 2, 1);
UPDATE facturas SET subtotal = 60 WHERE id = 2;
UPDATE productos SET stock = stock -1 where id = 4;
UPDATE productos SET stock = stock -1 where id = 5;
COMMIT;

BEGIN;
INSERT INTO facturas (id_cliente, fecha) VALUES (3, '2020-12-12');
INSERT INTO producto_factura (id_producto, id_factura, cantidad) VALUES
(5, 3, 8);
UPDATE facturas SET subtotal = 80 WHERE id = 3;
UPDATE productos SET stock = stock -8 where id = 5;

COMMIT;


--Consultas SQL

--¿Cuál es el nombre del cliente que realizó la compra más cara?
SELECT nombre from clientes WHERE id in (SELECT id_cliente FROM
facturas ORDER BY subtotal DESC LIMIT 1);

--¿Cuáles son los nombres de los clientes que pagaron más de 60$?
--Considerar el IVA del 19%
SELECT nombre FROM clientes WHERE id IN(SELECT id_cliente 
FROM facturas WHERE subtotal > 60 * 1.19);

--¿Cuántos clientes han compraod más de 5 productos? 
--Considere la cantidad por producto comprado
SELECT COUNT(nombre) FROM clientes WHERE id IN
(SELECT id_cliente FROM facturas WHERE id IN
(SELECT id_factura FROM
(SELECT SUM(cantidad) AS cantidad_productos, id_factura FROM
producto_factura GROUP BY id_factura) AS cant_prod_table
WHERE cantidad_productos > 5));