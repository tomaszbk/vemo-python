-- CREACION DE TABLAS

create table Continentes(
    id_continente SERIAL PRIMARY KEY,
    nombre varchar(13)
);

create table Paises (
    id_pais SERIAL PRIMARY KEY,
    nombre varchar(50),
    poblacion BIGINT,
    id_continente SMALLINT,
    bandera char(2),
    constraint fk_continente foreign key (id_continente) references Continentes(id_continente)
);

create table Capitales (
    id_capital SERIAL PRIMARY KEY,
    nombre varchar(50),
    id_pais SMALLINT,
    constraint fk_pais foreign key (id_pais) references Paises(id_pais)
);

create table Monedas(
    codigo_moneda char(3) PRIMARY KEY,
    nombre varchar(40)
);

create table MonedasPorPais(
    codigo_moneda char(3),
    id_pais SMALLINT,
    constraint pk_monedas_por_pais primary key (codigo_moneda, id_pais),
    constraint fk_pais foreign key (id_pais) references Paises(id_pais),
    constraint fk_moneda foreign key (codigo_moneda) references Monedas(codigo_moneda)
);

create table Lenguajes(
    codigo_lenguaje char(3) PRIMARY KEY,
    nombre varchar(30)
);

create table LenguajesPorPais(
    codigo_lenguaje char(3),
    id_pais SMALLINT,
    constraint pk_lenguajes_por_pais primary key (codigo_lenguaje, id_pais),
    constraint fk_pais foreign key (id_pais) references Paises(id_pais),
    constraint fk_lenguaje foreign key (codigo_lenguaje) references Lenguajes(codigo_lenguaje)
);