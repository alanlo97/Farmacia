-- Creación de esquema:
create schema if not exists farmacia;

-- Para mostrar los esquemas existentes en la BD:
show schemas;

-- Para eliminar un esquema:
drop schema farmacia;

create schema if not exists farmacia;

-- Para establecer el esquema sobre el que trabajamos:
use farmacia;

-- Para consultar cual es el esquema en uso:
select schema();

-- Creamos la tabla obra_social en el esquema activo:
create table obra_social(
	codigo int primary key,
	nombre varchar(45) not null,
	descripcion varchar(100) not null
);

-- Para mostrar la definición de la tabla:
show create table obra_social;

-- para mostrar las tablas definidas en el esquema 
-- activo:
show tables;

-- para eliminar una tabla
drop table obra_social;

-- Para renombrar una tabla:
create table obra_social(
	codigo int primary key,
	nombre varchar(45) not null,
	descripcion varchar(100) not null
);
alter table obra_social rename to obra;
alter table obra rename to obra_social;

-- Para cambiar la columna descripcion a descr
-- (hay que indicar todos los datos de la columna):
alter table obra_social change column descripcion descr varchar(100);
alter table obra_social change column descr descripcion varchar(100);

-- Insertamos datos en la tabla:
insert into obra_social 
	values(1,"PAMI","Programa de Atención Médica Integral");
-- Intentamos insertar con la misma PK:
insert into obra_social 
	values(1,"IOMA","Instituto de Obra Medico Asistencial");

insert into obra_social (codigo, nombre, descripcion) 
	values(2,"IOMA","Instituto de Obra Medico Asistencial");

insert into obra_social (codigo, nombre, descripcion) 
	values(3,"OSECAC","Obra Social de Empleados de Comercio");

-- Consultamos los registos insertados
select * from obra_social;

-- CREACION DE TABLAS CALLE, LOCALIDAD Y PROVINCIA

create table calle(
	idcalle int primary key,
	nombre varchar(45) not null
    );
create table localidad(
	idLocalidad int primary key,
    nombre varchar(45) not null
    );
create table provincia(
	idProvincia int primary key,
    nombre varchar(45) not null
	);
    
-- ELIMINACIÓN Y RECREACIÓN

drop table calle;
drop table localidad;
drop table provincia;

create table calle(
	idcalle int primary key,
	nombre varchar(45) not null
    );
create table localidad(
	idLocalidad int primary key,
    nombre varchar(45) not null
    );
create table provincia(
	idProvincia int primary key,
    nombre varchar(45) not null
	);

-- CAMBIO DE NOMBRE Y RENOMBRAR AL ORIGINAL

alter table calle rename to calleFalsa;
alter table localidad rename to localidadFalsa;
alter table provincia rename to provinciaFalsa;

alter table calleFalsa rename to calle;
alter table localidadFalsa rename to localidad;
alter table provinciaFalsa rename to provincia;

-- CAMBIO NOMBRE DE COLUMNA Y RENOMBRAR AL ORIGINAL

alter table calle change column idCalle idC int;
alter table localidad change column idLocalidad idL int;
alter table provincia change column idProvincia idP int;

alter table calle change column idC idCalle int;
alter table localidad change column idL idLocalidad int;
alter table provincia change column idP idProvincia int;

-- AGREGAR CONJUNTO DE DATOS

insert into calle
	values(1, "9 de Julio");
insert into calle
	values(2, "Hipólito Yrigoyen");
insert into calle
	values(3, "Mitre");
insert into calle
	values(4, "Saenz");
    
insert into localidad
	values(1, "Lanús");
insert into localidad
	values(2, "Pompeya");
insert into localidad
	values(3, "Avellaneda");
    
insert into provincia
	values(1, "Buenos Aires");
insert into provincia
	values(2, "CABA");

select * from calle;
select * from localidad;
select * from provincia;

/*****************************************************************
Intro BD 2020 - Sintaxis básica de dialecto SQL MySQL:
Manual de consulta MySQL: https://dev.mysql.com/doc/refman/8.0/en/
Apunte 4-Elementos de SQL 2
******************************************************************/

-- Creamos la tabla cliente:

create table cliente(
	dni int primary key,
	apellido varchar(45) not null,
	nombre varchar(45)not null,
	calle_idcalle int not null,
	localidad_idlocalidad int not null,
	provincia_idprovincia int not null,
    numero_calle int not null,
	foreign key (calle_idcalle) references calle(idcalle),
    foreign key (localidad_idlocalidad) references localidad(idlocalidad),
    foreign key (provincia_idprovincia) references provincia(idprovincia)
);

-- Mostramos definición:
show create table cliente;

-- Agregamos registros:
insert into cliente values(12345678, "Belgrano", "Manuel", 1,1,1,2345);
insert into cliente values(23456789, "Saavedra", "Cornelio",1,1,1,1234); 
insert into cliente values(44444444, "Moreno", "Mariano", 3,3,1,3333);
insert into cliente values(33333333, "Larrea", "Juan", 4,2,2,2345);
insert into cliente values(22222222, "Moreno", "Manuel", 4,2,2,7777);

-- Mostramos clientes:
select * from cliente; -- todos los clientes
select dni,apellido from cliente;-- solo dni y apellido

-- Consultamos registros por dni:
select apellido,nombre from cliente where dni=12345678;

-- Consultamos registros por apellido:
select * from cliente where cliente.apellido="Saavedra";

-- Consultamos clientes de la calle 9 de julio
select * from cliente where calle_idcalle=1;

-- Consultamos clientes de la calle 9 de Julio con el número 2345
select * from cliente where calle_idcalle=1 and numero_calle=2345;

-- Consultamos clientes que vivan en la calle 9 de Julio 
-- o en la calle Mitre
select * from cliente where calle_idcalle=1 or calle_idcalle=3;

-- agregamos obras sociales a los clientes
-- creamos la tabla intermedia que representa la relación opcional 1:n entre cliente y obra social 
create table cliente_tiene_obra_social(
	cliente_dni int primary key,
	obra_social_codigo int not null,
	nro_afiliado int not null,
	foreign key (cliente_dni) references cliente(dni),
    foreign key (obra_social_codigo) references obra_social(codigo)
);

-- Insertamos datos en la tabla. El cliente Cornelio Saavedra no tiene obra social
-- por ello no existe un registro con su dni en la misma
insert into cliente_tiene_obra_social values (22222222, 2, 11223344);
insert into cliente_tiene_obra_social values (33333333, 2, 33445566);
insert into cliente_tiene_obra_social values (44444444, 2, 12356987);
insert into cliente_tiene_obra_social values (12345678, 1, 87654321);


-- Consultas más complejas (joins)

-- Consultamos todos los clientes con su calle usando alias de tabla
-- Inner join: todos los registros de una tabla con correlato en la otra
select c.dni, c.apellido, c.nombre, ca.nombre, c.numero_calle from 
cliente c inner join calle ca on c.calle_idcalle=ca.idcalle;

-- igual, definiendo un alias para el campo c.nombre y numero_calle (con as)
select c.dni, c.apellido, c.nombre, ca.nombre as calle, c.numero_calle as numero from cliente c 
	inner join calle ca on c.calle_idcalle=ca.idcalle;

-- inner join con filtro por nombre de localidad
select c.dni, c.apellido, c.nombre, l.nombre as Localidad from cliente c 
	inner join localidad l on c.localidad_idlocalidad=l.idlocalidad
where l.nombre="Avellaneda";

-- Left join: Todos los registros de la izquierda y sólo los de la 
-- derecha que participan en la relación.
select ca.nombre as calle, dni, apellido, c.nombre from calle ca
	left join cliente c on ca.idcalle=c.calle_idcalle;

-- Right join: Todos los registros de la derecha y los de la izquierda que 
-- participan en la relación.
select cos.nro_afiliado, dni, apellido, c.nombre from cliente_tiene_obra_social cos
	right join cliente c on c.dni=cos.cliente_dni;

-- Vemos como un right join se puede escribir como un left join y viceversa.
-- esta consulta es similar a la anterior
select cos.nro_afiliado, dni, apellido, c.nombre from cliente c 
	left join cliente_tiene_obra_social cos on c.dni=cos.cliente_dni;

-- Traemos a los clientes sin obra social
select cos.nro_afiliado, dni, apellido, c.nombre from cliente c
    left join cliente_tiene_obra_social cos on c.dni=cos.cliente_dni
    where isnull(cos.nro_afiliado);

-- Traemos a los clientes con obra social
select cos.nro_afiliado, dni, apellido, c.nombre from cliente c
    left join cliente_tiene_obra_social cos on c.dni=cos.cliente_dni
    where not isnull(cos.nro_afiliado);

-- Consultas aún más complejas:
-- joins múltiples: Queremos consultar todos los clientes de IOMA:
select c.dni, c.apellido, c.nombre, o.nombre
	from cliente c 
    inner join cliente_tiene_obra_social co on c.dni=co.cliente_dni
	inner join obra_social o on co.obra_social_codigo=o.codigo
	where o.nombre="IOMA";

/*****************************************************************
Práctica:
consultar por:
Todos los clientes con la siguiente forma:
dni, apellido,nombre,calle,numero,localidad,provincia :
12345678, Belgrano, Manuel, 9 de julio, 2345, Lanús, Buenos Aires
...etc.

Igual que la anterior pero sólo de la provincia de Buenos Aires
Igual que la primera pero sólo de la calle 9 de julio
Igual que la primera pero sólo el dni 33333333 
Igual que la primera pero sólo de las localidades de avellaneda y lanus (filtrar por "Avellaneda" y "Lanús")
Igual que la primera pero sólo los clientes de PAMI y IOMA (filtrar por "PAMI" y "IOMA")
Igual que la primera pero sólo los clientes de IOMA que vivan en la calle Mitre (filtrar por "PAMI" y "Mitre")


Crear las tablas laboratorio y producto
insertar los siguientes datos:
laboratorio:
codigo, nombre
1, 'Bayer'
2, 'Roemmers'
3, 'Farma'
4, 'Elea'

producto:
codigo, nombre, descripcion, precio, laboratorio_codigo
1, 'Bayaspirina', 'Aspirina por tira de 10 unidades', 10, 1
2, 'Ibuprofeno', 'Ibuprofeno por tira de 6 unidades', 20, 3
3, 'Amoxidal 500', 'Antibiótico de amplio espectro', 300, 2
4, 'Redoxon', 'Complemento vitamínico', 120, '1'
5, 'Atomo', 'Crema desinflamante', 90, 3

Crear tabla venta. Insertar los siguientes datos:
numero, fecha, cliente_dni
1, '20-08-20', 12345678
2, '20-08-20', 33333333
3, '20-08-22', 22222222
4, '20-08-22', 44444444
5, '20-08-22', 22222222
6, '20-08-23', 12345678

Realizar las siguientes consultas:
- Todas las ventas, indicando número, fecha, apellido y nombre del cliente
- Igual que la anterior, pero que traiga sólo las del cliente con dni 12345678
- Todos (pero todos) los clientes con sus ventas
- Los clientes que no tienen ventas registradas
- Todos los laboratorios
- Todos los productos, indicando a que laboratorio pertencen
- Todos (pero todos) los laboratorios con los productos que elaboran
- Los laboratorios que no tienen productos registrados

******************************************************************/

-- Igual que la anterior pero sólo de la provincia de Buenos Aires
select c.dni, c.apellido, c.nombre, ca.nombre as calle, c.numero_calle as numero, l.nombre as localidad, p.nombre as provincia 
	from cliente c 
	inner join calle ca on c.calle_idCalle = ca.idCalle
    inner join localidad l on c.localidad_idLocalidad = l.idLocalidad
    inner join provincia p on c.provincia_idProvincia = p.idProvincia;
 
-- Igual que la primera pero sólo de la calle 9 de julio
select c.dni, c.apellido, c.nombre, ca.nombre as calle, c.numero_calle as numero, l.nombre as localidad, p.nombre as provincia 
	from cliente c 
	inner join calle ca on c.calle_idCalle = ca.idCalle
    inner join localidad l on c.localidad_idLocalidad = l.idLocalidad
    inner join provincia p on c.provincia_idProvincia = p.idProvincia
    where p.nombre="Buenos Aires";

-- Igual que la primera pero sólo el dni 33333333 
select c.dni, c.apellido, c.nombre, ca.nombre as calle, c.numero_calle as numero, l.nombre as localidad, p.nombre as provincia 
	from cliente c 
	inner join calle ca on c.calle_idCalle = ca.idCalle
    inner join localidad l on c.localidad_idLocalidad = l.idLocalidad
    inner join provincia p on c.provincia_idProvincia = p.idProvincia
    where c.dni=33333333;
    
-- Igual que la primera pero sólo de las localidades de avellaneda y lanus (filtrar por "Avellaneda" y "Lanús")
select c.dni, c.apellido, c.nombre, ca.nombre as calle, c.numero_calle as numero, l.nombre as localidad, p.nombre as provincia 
	from cliente c 
	inner join calle ca on c.calle_idCalle = ca.idCalle
    inner join localidad l on c.localidad_idLocalidad = l.idLocalidad
    inner join provincia p on c.provincia_idProvincia = p.idProvincia
    where l.nombre="Avellaneda" or  l.nombre="Lanús";
    
-- Igual que la primera pero sólo los clientes de PAMI y IOMA (filtrar por "PAMI" y "IOMA")
select c.dni, c.apellido, c.nombre, ca.nombre as calle, c.numero_calle as numero, l.nombre as localidad, p.nombre as provincia, o.nombre as obra_social
	from cliente c 
	inner join calle ca on c.calle_idCalle = ca.idCalle
    inner join localidad l on c.localidad_idLocalidad = l.idLocalidad
    inner join provincia p on c.provincia_idProvincia = p.idProvincia
    inner join cliente_tiene_obra_social co on c.dni = co.cliente_dni
    inner join obra_social o on co.obra_social_codigo = o.codigo
    where o.nombre="PAMI" or  o.nombre="IOMA";
    
-- Igual que la primera pero sólo los clientes de IOMA que vivan en la calle Mitre (filtrar por "OIMA" y "Mitre")
select c.dni, c.apellido, c.nombre, ca.nombre as calle, c.numero_calle as numero, l.nombre as localidad, p.nombre as provincia, o.nombre as obra_social
	from cliente c 
	inner join calle ca on c.calle_idCalle = ca.idCalle
    inner join localidad l on c.localidad_idLocalidad = l.idLocalidad
    inner join provincia p on c.provincia_idProvincia = p.idProvincia
    inner join cliente_tiene_obra_social co on c.dni = co.cliente_dni
    inner join obra_social o on co.obra_social_codigo = o.codigo
    where o.nombre="IOMA" and ca.nombre="Mitre";

-- Creacion tabla laboratorio
create table laboratorio(
	codigo int primary key,
    nombre varchar(45) not null
    );

-- Creacion tabla producto
create table producto(
	codigo int primary key,
    nombre varchar(45) not null,
    descripcion varchar(60) not null,
    precio int not null,
    laboratorio_codigo int not null,
    foreign key (laboratorio_codigo) references laboratorio(codigo)
    );
 
 -- Insertando datos en laboratorio
insert into laboratorio values (1,'Bayer');
insert into laboratorio values (2,'Roemmers');
insert into laboratorio values (3,'Farma');
insert into laboratorio values (4,'Elea');

-- Insertando datos en productos
insert into producto values (1, 'Bayaspirina', 'Aspirina por tira de 10 unidades', 10, 1);
insert into producto values (2, 'Ibuprofeno', 'Ibuprofeno por tira de 6 unidades', 20, 3);
insert into producto values (3, 'Amoxidal 500', 'Antibiótico de amplio espectro', 300, 2);
insert into producto values (4, 'Redoxon', 'Complemento vitamínico', 120, 1);
insert into producto values (5, 'Atomo', 'Crema desinflamante', 90, 3);

-- Crear tabla venta
create table venta(
	numero int primary key,
    fecha date not null,
    cliente_dni int not null,
    foreign key (cliente_dni) references cliente(dni)
    );
    
-- Insertando datos en venta
insert into venta values (1, '20-08-20', 12345678);
insert into venta values (2, '20-08-20', 33333333);
insert into venta values (3, '20-08-22', 22222222);
insert into venta values (4, '20-08-22', 44444444);
insert into venta values (5, '20-08-22', 22222222);
insert into venta values (6, '20-08-23', 12345678);

-- Todas las ventas, indicando número, fecha, apellido y nombre del cliente
select v.numero, v.fecha, c.apellido, c.nombre from venta v inner join cliente c on v.cliente_dni = c.dni;

-- Igual que la anterior, pero que traiga sólo las del cliente con dni 12345678
select v.numero, v.fecha, c.apellido, c.nombre from venta v inner join cliente c on v.cliente_dni = c.dni where c.dni = 12345678;

-- Todos (pero todos) los clientes con sus ventas
select c.dni, c.apellido, c.nombre, v.numero, v.fecha
	from cliente c
	left join venta v on c.dni=v.cliente_dni;
    
-- Los clientes que no tienen ventas registradas
select dni, apellido, c.nombre, v.numero, v.fecha from cliente c
    left join venta v on c.dni=v.cliente_dni
    where isnull(v.cliente_dni);
    
-- Todos los laboratorios
select * from laboratorio;

-- Todos los productos, indicando a que laboratorio pertencen
select p.codigo as codigo_prod, p.nombre as nombre_prod, p.descripcion, p.precio, l.codigo as codigo_lab, l.nombre as nombre_lab
	from producto p
    inner join laboratorio l on p.laboratorio_codigo = l.codigo;
    
-- Todos (pero todos) los laboratorios con los productos que elaboran
select l.codigo as codigo_lab, l.nombre as nombre_lab, p.codigo as codigo_prod, p.nombre as nombre_prod, p.descripcion, p.precio
	from laboratorio l
	left join producto p on l.codigo = p.laboratorio_codigo;

-- Los laboratorios que no tienen productos registrados
select l.codigo as codigo_lab, l.nombre as nombre_lab, p.codigo as codigo_prod, p.nombre as nombre_prod, p.descripcion, p.precio from laboratorio l
    left join producto p on l.codigo = p.laboratorio_codigo
    where isnull(p.laboratorio_codigo);
    
/***************************************************************************************
Intro BD 2020 - Sintaxis básica de dialecto SQL MySQL:
Manual de consulta MySQL: https://dev.mysql.com/doc/refman/8.0/en/
Apunte 5-Elementos de SQL 3
***************************************************************************************/

-- creamos la tabla detalle_venta (¿Qué representa esta tabla?)
-- Creación tabla detalle_venta
create table detalle_venta(
	venta_numero int,
	producto_codigo int,
	precio_unitario decimal(10,2),
	cantidad int,
	primary key (venta_numero, producto_codigo),
	foreign key (venta_numero) references venta(numero),
	foreign key (producto_codigo) references producto(codigo)
);

/***************************************************************************************
Práctica:
Agregar el detalle de las ventas en detalle_venta de la siguiente manera:
# venta_numero, producto_codigo, precio_unitario, cantidad
1, 2, 20.00, 3
1, 3, 300.00, 1
2, 1, 10.00, 2
2, 4, 120.00, 1
3, 2, 20.00, 3
3, 5, 90.00, 2
4, 2, 20.00, 2
5, 1, 8.00, 4
5, 5, 70.00, 1
6, 2, 20.00, 2
6, 3, 300.00, 1
6, 4, 120.00, 1

Intentar agregar el siguiente registro y ver que ocurre:
7, 4, 120.00, 2 

Intentar agregar el siguiente registro y ver que ocurre:
4, 2, 20.00, 2
***************************************************************************************/

-- Insertando datos en detalle_venta
insert into detalle_venta values (1, 2, 20.00, 3);
insert into detalle_venta values (1, 3, 300.00, 1);
insert into detalle_venta values (2, 1, 10.00, 2);
insert into detalle_venta values (2, 4, 120.00, 1);
insert into detalle_venta values (3, 2, 20.00, 3);
insert into detalle_venta values (3, 5, 90.00, 2);
insert into detalle_venta values (4, 2, 20.00, 2);
insert into detalle_venta values (5, 1, 8.00, 4);
insert into detalle_venta values (5, 5, 70.00, 1);
insert into detalle_venta values (6, 2, 20.00, 2);
insert into detalle_venta values (6, 3, 300.00, 1);
insert into detalle_venta values (6, 4, 120.00, 1);

-- Intentar agregar el siguiente registro:
insert into detalle_venta values (7, 4, 120.00, 2);

-- Intentar agregar el siguiente registro:
insert into detalle_venta values (4, 2, 20.00, 2);

-- Consultas con operaciones y agregación
-- Total facturado para un item determinado de una venta:
select precio_unitario*cantidad as total from detalle_venta
where venta_numero=1 and producto_codigo=2;


-- Total facturado por la farmacia
select sum(precio_unitario*cantidad) as total from detalle_venta;


-- Total facturado en una venta (sum)
select sum(precio_unitario*cantidad) as total from detalle_venta 
where venta_numero=1;


-- Total facturado discriminado venta por venta (sum con group by):
select venta_numero, sum(precio_unitario*cantidad) as total from detalle_venta
group by venta_numero;


-- cantidad de ventas total (count)
select count(*) as cant_ventas from venta;


-- cantidad de ventas por dia total (count con group by)
select fecha, count(*) as cant_ventas from venta
group by fecha;


-- Total facturado por día: (inner join, sum, group by)
select v.fecha, sum(precio_unitario*cantidad) as total 
from detalle_venta d
inner join venta v on d.venta_numero=v.numero
group by v.fecha;


-- precio promedio de productos vendidos por producto (inner join, avg, group by)
select p.nombre, avg(dv.precio_unitario) as precio_promedio, p.precio as precio_lista 
from producto p 
inner join detalle_venta dv on p.codigo=dv.producto_codigo
group by p.codigo;


-- precio promedio de productos vendidos entre fecha (inner join, avg, group by, between)
select p.nombre, avg(dv.precio_unitario) as precio_promedio, p.precio as precio_lista 
from producto p 
inner join detalle_venta dv on p.codigo=dv.producto_codigo
inner join venta v on dv.venta_numero=v.numero 
where v.fecha between '2020-08-22' and '2020-08-23'
group by p.codigo;


-- precio promedio de productos vendidos entre fecha (inner join, avg, group by, filtro)
select p.nombre, avg(dv.precio_unitario) as precio_promedio, p.precio as precio_lista 
from producto p 
inner join detalle_venta dv on p.codigo=dv.producto_codigo
inner join venta v on dv.venta_numero=v.numero 
where v.fecha >= '2020-08-22' and v.fecha<='2020-08-23'
group by p.codigo;


-- artículos vendidos más baratos que el precio de lista
select v.numero, p.nombre, p.descripcion, p.precio as precio_lista, 
dv.precio_unitario as precio_venta, dv.precio_unitario-p.precio as diferencia
from venta v 
inner join detalle_venta dv on v.numero=dv.venta_numero
inner join producto p on dv.producto_codigo=p.codigo
where dv.precio_unitario-p.precio<0;


-- total facturado en el año (inner join, sum, where)
select year(v.fecha) as año, sum(precio_unitario*cantidad) as total 
from detalle_venta d
inner join venta v on d.venta_numero=v.numero
group by year(v.fecha);

-- también: group by año;

-- Total facturado mayor a $100 (sum con group by y having):
select venta_numero, sum(precio_unitario*cantidad) as total from detalle_venta
group by venta_numero
having total>100;


-- Total facturado mayor a $100 (sum con group by y having, ordenado por total):
select venta_numero, sum(precio_unitario*cantidad) as total from detalle_venta
group by venta_numero
having total>100
order by total;


-- Total facturado mayor a $100 (sum con group by y having, ordenado por total):
select venta_numero, sum(precio_unitario*cantidad) as total from detalle_venta
group by venta_numero
having total>100
order by total desc;


/***************************************************************************************
Práctica:
Realizar una consulta que devuelva el total facturado del
producto 'Amoxidal 500' pero eligiendo el producto por nombre 
(no por código). 

Realizar una consulta que devuelva el total facturado al cliente con dni 
22222222 (dni, total)

Realizar una consulta que devuelva la cantidad de ventas realizadas al 
cliente con dni 12345678. Cantidad de ventas es cada ticket emitido, no cada 
producto vendido. (dni, cantidad)

Realizar una consulta que devuelva las ventas realizadas a los clientes con apellido
'Belgrano', discriminado venta por venta. (apellido, numero de venta, total)

Realizar una consulta que devuelva la cantidad de ventas realizadas a los clientes 
con apellido 'Moreno'. (apellido, cantidad)

Traer el total facturado por obra social. (nombre de obra social, total)

Idem a la anterior, pero filtrando desde el 1/1/2020 hasta el 30/8/2020. 

Traer el total facturado a clientes que no tienen obra social
(sólo mostrar total)

Realizar una consulta que devuelva el total de las ventas realizadas a 
clientes de la calle Sáenz (se debe filtrar por nombre de calle="Sáenz").
(apellido, nombre, total vendido)

Realizar una consulta que devuelva las ventas realizadas a clientes de la 
calle Sáenz (se debe filtrar por nombre de calle="Sáenz", discriminada 
venta por venta (apellido, nombre, venta_numero, total)

Realizar una consulta que devuelva los productos vendidos. Se debe mostrar cada 
producto una sola vez (Ayuda: hay que agrupar por producto)
(código, nombre, descripcion)

Realizar una consulta que devuelva el total de ventas sin detallar realizadas 
a clientes de la obra social IOMA que vivan en la provincia de Buenos Aires. 
Consultar por nombre de obra social y de provincia
(nombre provincia, nombre obra social, total)

Realizar una consulta que devuelva cuántas son las ventas de la consulta anterior
(nombre provincia, nombre obra social, cantidad)
***************************************************************************************/

-- Consulta que devuelve el total facturado del producto 'Amoxidal 500'
select p.nombre, sum(dv.precio_unitario*dv.cantidad) as total_facturado
from producto p
inner join detalle_venta dv on p.codigo = dv.producto_codigo
where p.nombre = "Amoxidal 500"
group by p.codigo;

-- Consulta que devuelve el total facturado al cliente con dni 22222222
select v.cliente_dni as dni, sum(dv.precio_unitario*dv.cantidad) as total
from venta v
inner join detalle_venta dv on v.numero = dv.venta_numero
where v.cliente_dni = 22222222
group by v.cliente_dni;

-- Consulta que devuelve la cantidad de ventas realizadas al cliente con dni 12345678
select v.cliente_dni as dni, count(v.numero) as cantidad
from venta v
where v.cliente_dni = 12345678;

-- Consulta que devuelve las ventas realizadas a los clientes con apellido 'Belgrano', discriminado venta por venta.
select cl.apellido, v.numero as numero_venta, sum(dv.precio_unitario*dv.cantidad) as total
from venta v
inner join detalle_venta dv on v.numero = dv.venta_numero
inner join cliente cl on cl.dni = v.cliente_dni
where cl.apellido = "Belgrano"
group by v.numero;

-- Consulta que devuelve la cantidad de ventas realizadas a los clientes con apellido 'Moreno'
select cl.apellido, count(v.numero) as cantidad
from venta v
inner join cliente cl on cl.dni = v.cliente_dni
where cl.apellido = "Moreno";

-- Traer el total facturado por obra social.
select o.nombre as nombre_obra_social, sum(dv.precio_unitario*dv.cantidad) as total
from obra_social o
inner join cliente_tiene_obra_social cos on o.codigo = cos.obra_social_codigo
inner join cliente c on cos.cliente_dni = c.dni
inner join venta v on c.dni = v.cliente_dni
inner join detalle_venta dv on v.numero = dv.venta_numero
group by o.codigo;

-- Idem a la anterior, pero filtrando desde el 1/1/2020 hasta el 30/8/2020. 
select o.nombre as nombre_obra_social, sum(dv.precio_unitario*dv.cantidad) as total
from obra_social o
inner join cliente_tiene_obra_social cos on o.codigo = cos.obra_social_codigo
inner join cliente c on cos.cliente_dni = c.dni
inner join venta v on c.dni = v.cliente_dni
inner join detalle_venta dv on v.numero = dv.venta_numero
where v.fecha between '2020-01-01' and '2020-08-30'
group by o.codigo;

-- Traer el total facturado a clientes que no tienen obra social (sólo mostrar total)
select sum(dv.precio_unitario*dv.cantidad) as total
from venta v
inner join detalle_venta dv on v.numero = dv.venta_numero
inner join cliente cl on cl.dni = v.cliente_dni
inner join cliente_tiene_obra_social cos on cos.cliente_dni = cl.dni
where isnull(cos.nro_afiliado);

-- Consulta que devuelve el total de las ventas realizadas a clientes de la calle Sáenz
select cl.apellido, cl.nombre, sum(dv.precio_unitario*dv.cantidad) as total_vendido
from venta v
inner join detalle_venta dv on v.numero = dv.venta_numero
inner join cliente cl on cl.dni = v.cliente_dni
inner join calle c on c.idCalle = calle_idCalle
where c.nombre = "Sáenz"
group by cl.dni;

-- Realizar una consulta que devuelva las ventas realizadas a clientes de la calle Sáenz
select cl.apellido, cl.nombre, v.numero as venta_numero, sum(dv.precio_unitario*dv.cantidad) as total
from venta v
inner join detalle_venta dv on v.numero = dv.venta_numero
inner join cliente cl on cl.dni = v.cliente_dni
inner join calle c on c.idCalle = calle_idCalle
where c.nombre = "Sáenz"
group by v.numero;

-- Consulta que devuelve los productos vendidos. Se debe mostrar cada producto una sola vez
select p.codigo, p.nombre, p.descripcion
from producto p
inner join detalle_venta dv on dv.producto_codigo = p.codigo
where not isnull(dv.producto_codigo)
group by p.codigo;

-- Consulta que devuelve el total de ventas sin detallar realizadas a clientes de la obra social IOMA que vivan en la provincia de Buenos Aires.
select p.nombre as nombre_provincia, o.nombre as nombre_obra_social, sum(dv.precio_unitario*dv.cantidad) as total
from obra_social o
inner join cliente_tiene_obra_social cos on o.codigo = cos.obra_social_codigo
inner join cliente c on cos.cliente_dni = c.dni
inner join provincia p on p.idProvincia = c.provincia_idProvincia
inner join venta v on c.dni = v.cliente_dni
inner join detalle_venta dv on v.numero = dv.venta_numero
where p.nombre = 'Buenos Aires' and o.nombre = 'IOMA'
group by o.codigo;

-- Consulta que devuelve cuántas son las ventas de la consulta anterior (nombre provincia, nombre obra social, cantidad)
select p.nombre as nombre_provincia, o.nombre as nombre_obra_social, count(*) as cantidad
from obra_social o
inner join cliente_tiene_obra_social cos on o.codigo = cos.obra_social_codigo
inner join cliente c on cos.cliente_dni = c.dni
inner join provincia p on p.idProvincia = c.provincia_idProvincia
inner join venta v on c.dni = v.cliente_dni
inner join detalle_venta dv on v.numero = dv.venta_numero
where p.nombre = 'Buenos Aires' and o.nombre = 'IOMA'
group by o.codigo;

/***************************************************************************************
Apunte 6-Elementos de SQL 4
***************************************************************************************/

-- Problema con group by en MySQL (consulta incorrecta):
select venta_numero, venta.fecha, sum(precio_unitario*cantidad) as total 
from detalle_venta
inner join venta on venta.numero=detalle_venta.venta_numero;

-- Campos en select con dependencias funcionales con un campo en group by:
select c.dni,sum(precio_unitario*cantidad) as total_facturado, c.nombre, c.apellido
from detalle_venta dv
inner join venta v on dv.venta_numero=v.numero
inner join cliente c on v.cliente_dni=c.dni
group by c.dni;

-- Campos en select sin dependencia funcional con algún campo en group by (incorrecta)
-- debe devolver error, si no es así, verificar sql_mode:
select c.dni,sum(precio_unitario*cantidad) as total_facturado, c.nombre, c.apellido, v.fecha
from detalle_venta dv
inner join venta v on dv.venta_numero=v.numero
inner join cliente c on v.cliente_dni=c.dni
group by c.dni;


-- Campos en select sin dependencia funcional con alguno en group by,
-- pero en función de agregación:
select c.dni,sum(precio_unitario*cantidad) as total_facturado, c.nombre, c.apellido,
max(v.fecha) as fecha_ultima_venta
from detalle_venta dv
inner join venta v on dv.venta_numero=v.numero
right join cliente c on v.cliente_dni=c.dni
left join cliente_tiene_obra_social cos on c.dni=cos.cliente_dni
group by c.dni;

SET@@session.sql_mode = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

/***************************************************************************************
Modificamos (update) registros
******************************************************************/
-- agregamos 20% al precio de todos los productos
update producto set precio=precio*1.2; 

select * from producto;

-- agregamos 15% al precio de los productos Bayer
update producto set precio=precio*1.15 
	where laboratorio_codigo=1;

select * from producto;

-- agregamos 10% a un producto determinado
update producto set precio=precio*1.1 
	where nombre="Amoxidal 500";

select * from producto;

-- agregamos 10% a los productos cuyo precio sea >150
update producto set precio=precio*1.1 
	where precio>150;

select * from producto;

-- podemos actualizar varios campos a la vez separando con comas.
-- aquí utilizamos una función de MySQL para concatenar dos strings
-- year, sum, count, avg también son funciones. 
-- Listado de funciones de MySQL:
-- https://dev.mysql.com/doc/refman/8.0/en/sql-function-reference.html
update producto set precio=precio*1.1, descripcion=concat(descripcion," nueva fórmula")
	where nombre="Amoxidal 500";

select * from producto;

/***************************************************************************************
Eliminamos (delete) registros
***************************************************************************************/

-- damos de alta una obra social para luego eliminarla
insert into obra_social (codigo, nombre, descripcion) 
	values(4,"OSPAPEL","Obra Social del personal del papel");

select * from obra_social;

-- la eliminamos
delete from obra_social where codigo=4;

select * from obra_social;

-- si no especificamos filtro, podemos borrar todas las 
-- obras sociales
delete from obra_social;
-- Se pudo? Por qué?

/***************************************************************************************
Práctica:

Realizar una consulta que traiga el total de las ventas de un cliente, indicando apellido, 
nombre, dni, localidad y total de ventas.

Realizar una consulta que traiga el total de las ventas por provincia, indicando provincia, 
total de ventas.

Realizar una consulta que devuelva el promedio de precio de venta por producto, mostrando 
producto, precio promedio. El precio de venta es el precio con que se vendió, no el precio 
de lista.

Realizar una consulta que traiga totales de venta por provincia y obra social, indicando
provincia, codigo de obra social, nombre de obra social, descripcion de obra social, 
total venta.

Realizar una consulta que le cambie la obra social al cliente con dni 22222222.

Realizar una consulta que retorne la obra social del cliente con dni 22222222 a la 
original (IOMA).

Realizar las consultas necesarias para retornar los precios de lista de los productos 
a sus valores originales

Realizar una consulta que modifique al cliente Mariano Moreno para que quede sin obra
social

Realizar una consulta que asigne nuevamente al cliente Mariano Moreno su obra social
original y su número de afiliado (IOMA, 12356987)

Crear una venta número 7, de fecha  25/08/2020, al cliente Cornelio Saavedra, con los 
siguientes productos (producto, cantidad):

Amoxidal 500, 3
Bayaspirina, 10
Redoxon, 1

Los precios deben ser los precios de lista

Crear una consulta que Modifique el precio del artículo Redoxon de la venta 7 a $200

Crear las consultas necesarias para eliminar completamente la venta 7, incluyendo su
detalle. 

***************************************************************************************/

-- Consulta que traiga el total de las ventas de un cliente, indicando apellido, nombre, dni, localidad y total de ventas.
select cl.apellido, cl.nombre, cl.dni, l.nombre as localidad, sum(dv.precio_unitario*dv.cantidad) as total_ventas
from detalle_venta dv
inner join venta v on dv.venta_numero=v.numero
inner join cliente cl on v.cliente_dni=cl.dni
inner join localidad l on l.idlocalidad=cl.localidad_idlocalidad
group by cl.dni;

-- Consulta que traiga el total de las ventas por provincia, indicando provincia, total de ventas.
select p.nombre as provincia, sum(dv.precio_unitario*dv.cantidad) as total_ventas
from detalle_venta dv
inner join venta v on dv.venta_numero=v.numero
inner join cliente cl on v.cliente_dni=cl.dni
inner join provincia p on p.idprovincia=cl.provincia_idprovincia
group by p.idprovincia;

-- Consulta que devuelva el promedio de precio de venta por producto, mostrando producto, precio promedio. El precio de venta es el precio con que se vendió, no el precio de lista.
select p.nombre, avg(dv.precio_unitario*dv.cantidad) as precio_promedio
from detalle_venta dv
inner join producto p on p.codigo = dv.producto_codigo
group by p.codigo;

-- Consulta que traiga totales de venta por provincia y obra social, indicando provincia, codigo de obra social, nombre de obra social, descripcion de obra social, total venta.
select p.nombre as provincia, os.codigo as codigo_obra_social, os.nombre as nombre_obra_social, os.descripcion as descripcion, sum(dv.precio_unitario*dv.cantidad) as total_venta
from detalle_venta dv
inner join venta v on v.numero = dv.venta_numero
inner join cliente cl on v.cliente_dni = cl.dni
inner join provincia p on p.idprovincia = cl.provincia_idprovincia
inner join cliente_tiene_obra_social tos on tos.cliente_dni = cl.dni
inner join obra_social os on os.codigo = tos.obra_social_codigo
group by os.codigo, p.idprovincia;

-- Consulta que le cambie la obra social al cliente con dni 22222222.    
update cliente_tiene_obra_social set obra_social_codigo = 1
	where cliente_dni = 22222222;
    
-- Consulta que retorne la obra social del cliente con dni 22222222 a la original (IOMA).
update cliente_tiene_obra_social set obra_social_codigo = 2
	where cliente_dni = 22222222;
    
-- Consultas necesarias para retornar los precios de lista de los productos a sus valores originales
update producto set precio=precio/1.2;

update producto set precio=precio/1.15 
	where laboratorio_codigo=1;
    
update producto set precio=precio/1.1 
	where nombre="Amoxidal 500" and precio>150;
    
-- Consulta que modifique al cliente Mariano Moreno para que quede sin obra social 
delete cos from cliente_tiene_obra_social cos
inner join cliente c on c.dni = cos.cliente_dni
	where c.nombre = "Mariano" and c.apellido = "Moreno";

-- Consulta que asigne nuevamente al cliente Mariano Moreno su obra social original y su número de afiliado (IOMA, 12356987)
insert into cliente_tiene_obra_social values (44444444, 2, 12356987);

-- Crear una venta número 7, de fecha  25/08/2020, al cliente Cornelio Saavedra, con los siguientes productos (producto, cantidad):
-- Amoxidal 500, 3
-- Bayaspirina, 10
-- Redoxon, 1
insert into venta values(7, '2020/08/25', 23456789);
insert into detalle_venta values(7, 3, 300.00, 3);
insert into detalle_venta values(7, 1, 10.00, 10);
insert into detalle_venta values(7, 4, 120.00, 1);

-- Consulta que Modifique el precio del artículo Redoxon de la venta 7 a $200
update detalle_venta dv set precio_unitario = 200.00
where venta_numero = 7 and producto_codigo = 4;

-- Crear las consultas necesarias para eliminar completamente la venta 7, incluyendo su detalle.
delete dv from detalle_venta dv
where venta_numero = 7;
delete v from venta v
where v.numero = 7;
