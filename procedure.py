# carga el procedure de insertar_pais a la db
from sqlalchemy import create_engine, text

engine = create_engine('postgresql://username:password@localhost:5432/paises')
conn = engine.connect() 
with open("db/procedure.sql") as file:
        query = text(file.read())
        conn.execute(query)
        conn.commit()
conn.close()