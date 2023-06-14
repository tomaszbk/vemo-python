create or replace procedure insertar_pais(
    p_nombre text,
    p_poblacion numeric,
    p_bandera text,
    p_nombre_continente text,
    p_nombres_capitales text[],
    p_codigos_monedas text[],
    p_nombres_monedas text[],
    p_codigos_lenguajes text[],
    p_nombres_lenguajes text[]
)
LANGUAGE plpgsql
AS $$
DECLARE
  id_cont INTEGER;
  aux_id_pais INTEGER;
  i INTEGER;
  capital text;
BEGIN

    select id_continente into id_cont from Continentes where nombre = p_nombre_continente;
    IF id_cont is null then
        INSERT into Continentes (nombre) VAlUES (p_nombre_continente) returning id_continente into id_cont;
    END if;

    insert into Paises (nombre,poblacion,id_continente,bandera) VALUES(p_nombre,p_poblacion,id_cont,p_bandera) returning id_pais into aux_id_pais;

    IF array_length(p_nombres_capitales,1) IS NOT NULL THEN
        FOREACH capital in ARRAY p_nombres_capitales LOOP
            insert into Capitales (nombre, id_pais)
            VALUES (capital,aux_id_pais);
        END LOOP;
    END IF;


    IF array_length(p_codigos_monedas,1) IS NOT NULL THEN
        FOR i IN 1..array_length(p_codigos_monedas, 1) LOOP
            IF NOT EXISTS(SELECT 1 from Monedas where codigo_moneda = p_codigos_monedas[i]) then
                insert into Monedas (codigo_moneda,nombre) VALUES (p_codigos_monedas[i], p_nombres_monedas[i]);
            END IF;
            insert into MonedasPorPais (codigo_moneda,id_pais)
            VALUES (p_codigos_monedas[i],aux_id_pais);  
        END LOOP;
    END IF;


    IF array_length(p_codigos_lenguajes,1) IS NOT NULL THEN
        FOR i IN 1..array_length(p_codigos_lenguajes, 1) LOOP
            IF NOT EXISTS(SELECT 1 from Lenguajes where codigo_lenguaje = p_codigos_lenguajes[i]) then
                insert into Lenguajes (codigo_lenguaje,nombre) VALUES (p_codigos_lenguajes[i], p_nombres_lenguajes[i]);
            END IF;
            insert into LenguajesPorPais (codigo_lenguaje,id_pais)
            VALUES (p_codigos_lenguajes[i],aux_id_pais);
        END LOOP;
    END IF;


END;
$$;

