create procedure insertar_pais(
    p_nombre varchar(50),
    p_poblacion int,
    p_bandera char(2),
    p_nombre_continente varchar(10),
    p_nombres_capitales varchar(50)[],
    p_codigos_monedas char(3)[],
    p_nombres_monedas varchar(40)[],
    p_codigos_lenguajes char(3)[],
    p_nombres_lenguajes varchar(30)[]
)
LANGUAGE plpgsql
AS $$
BEGIN

    select id_continente into id_cont from Continentes where nombre = p_nombre_continente;
    IF id_cont is null then
        INSERT into Continentes (nombre) VAlUES (p_nombre_continente) returning id_continente into id_cont;
    END if;

    insert into Paises (nombre,poblacion,id_continente,bandera) VALUES(p_nombre,p_poblacion,id_cont,p_bandera) returning id_pais into aux_id_pais;

    FOREACH i in ARRAY p_nombre_capitales LOOP
        insert into Capitales (nombre, id_pais)
        VALUES (i,aux_id_pais);

    END LOOP;

    FOR i IN 1..array_length(p_codigos_monedas, 1) LOOP
        insert into MonedasPorPais (codigo_moneda,id_pais)
        VALUES (p_codigos_monedas[i],aux_id_pais);
        IF NOT EXISTS(SELECT 1 from Monedas where codigo_moneda = p_codigos_monedas[i]) then
            insert into Monedas (codigo_moneda,nombre) VALUES (p_codigos_monedas[i], p_nombres_monedas[i]);
        END IF;
    END LOOP;

    FOR i IN 1..array_length(p_codigos_lenguajes, 1) LOOP
        insert into LenguajesPorPais (codigo_lenguaje,id_pais)
        VALUES (p_codigos_lenguajes[i],aux_id_pais);
        IF NOT EXISTS(SELECT 1 from Lenguajes where codigo_lenguaje = p_codigos_lenguajes[i]) then
            insert into Lenguajes (codigo_lenguaje,nombre) VALUES (p_codigos_lenguajes[i], p_nombres_lenguajes[i]);
        END IF;
    END LOOP;


END;
$$;

