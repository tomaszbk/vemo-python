import requests
import json
from sqlalchemy import create_engine, text

engine = create_engine('postgresql://username:password@localhost:5432/paises')

response_API = requests.get('https://restcountries.com/v3.1/all')

data = json.loads(response_API.text)

conn = engine.connect() 

sql = text(f"""CALL insertar_pais(:p_nombre ::text, :p_poblacion ::numeric,:p_bandera ::text,
        :p_nombre_continente ::text, :p_nombres_capitales,:p_codigos_monedas,
        :p_nombres_monedas,:p_codigos_lenguajes,:p_nombres_lenguajes)""")
conn.execute(text("BEGIN;"))
try:
        for country in data:
                nombre= country['name']['common']
                poblacion= country['population']
                bandera = country['flag']
                continente = country['continents'][0]
                try:
                        capitales = country['capital']
                except:
                        capitales = []
                try:
                        codigos_monedas = list(country['currencies'].keys())
                        nombres_monedas = [x['name'] for x in list(country['currencies'].values())]
                except:
                        codigos_monedas = []
                        nombres_monedas = []
                try:
                        codigos_lenguajes = list(country['languages'].keys())
                        nombres_lenguajes = list(country['languages'].values())
                except:
                        codigos_lenguajes = []
                        nombres_lenguajes = []
                params = dict(p_nombre=nombre, p_poblacion=poblacion, p_bandera=bandera, p_nombre_continente=continente,
                              p_nombres_capitales=capitales, p_codigos_monedas= codigos_monedas, 
                                p_nombres_monedas= nombres_monedas,
                                p_codigos_lenguajes=codigos_lenguajes, p_nombres_lenguajes=nombres_lenguajes)

                conn.execute(sql, params)

except Exception as e:
        print("ocurrio un error:")
        print(e)
        conn.execute(text("ROLLBACK;"))

conn.execute(text("COMMIT;"))
conn.close()