from sqlalchemy import create_engine, text
import pandas as pd

engine = create_engine('postgresql://username:password@localhost:5432/paises')
conn = engine.connect() 
query = text(f""" 
            SELECT p.nombre, c.nombre as continente, p.poblacion, STRING_AGG(cap.nombre, ',') as capitales,
             STRING_AGG(m.nombre,',') as monedas, STRING_AGG(l.nombre,',') as lenguajes, p.bandera
             FROM Paises as p left join Continentes as c on p.id_continente = c.id_continente
                left join Capitales as cap on p.id_pais = cap.id_pais
                left join MonedasPorPais as mpp on p.id_pais = mpp.id_pais
                left join Monedas as m on mpp.codigo_moneda = m.codigo_moneda
                left join LenguajesPorPais as lpp on p.id_pais = lpp.id_pais 
                left join Lenguajes as l on lpp.codigo_lenguaje = l.codigo_lenguaje
            GROUP BY p.nombre, c.nombre, p.poblacion, p.bandera
             """)
df = pd.DataFrame(conn.execute(query).fetchall())

