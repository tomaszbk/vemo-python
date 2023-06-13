-- CREACION DE TABLAS

create table Paises (
    id_pais SERIAL PRIMARY KEY,
    nombre varchar(50),
    poblacion int,
    id_continente int,
    bandera char(2),
);

create table Continentes(
    id_continente SERIAL PRIMARY KEY,
    nombre varchar(10)
)

create table Capitales (
    id_capital SERIAL PRIMARY KEY,
    nombre varchar(50),
    id_pais int --foreign key
)

create table MonedasPorPais(
    codigo_moneda char(3),
    id_pais int
)

create table LenguajesPorPais(
    codigo_lenguaje char(3),
    id_pais int
)

create table Lenguajes(
    codigo_lenguaje char(3),
    nombre varchar(30)
)

create table Monedas(
    codigo_moneda char(3) PRIMARY KEY,
    nombre varchar(40)
)