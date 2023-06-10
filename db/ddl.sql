-- CREACION DE TABLAS

create table Paises (
    id_pais int PRIMARY KEY,
    nombre varchar(50),
    poblacion int,
    id_continente int,
    bandera char(2),
    lenguaje char(30),
    codigo_moneda char(3)
);

create table Continentes(
    id_continente int PRIMARY KEY,
    nombre varchar(10)
)

create table Capitales (
    id_capital int PRIMARY KEY,
    nombre varchar(50),
    id_pais int --foreign key
)

create table Monedas(
    codigo_moneda char(3) PRIMARY KEY,
    nombre varchar(40)
)