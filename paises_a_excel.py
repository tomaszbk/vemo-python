from sqlalchemy import create_engine, text
import pandas as pd

engine = create_engine('postgresql://username:password@localhost:5432/paises')
conn = engine.connect() 
query = text(f""" 
            SELECT p.nombre, c.nombre as continente, p.poblacion, STRING_AGG(distinct cap.nombre, ', ') as capitales,
             STRING_AGG(distinct m.nombre,', ') as monedas, STRING_AGG(distinct l.nombre,', ') as lenguajes, p.bandera
             FROM Paises as p left join Continentes as c on p.id_continente = c.id_continente
                left join Capitales as cap on p.id_pais = cap.id_pais
                left join MonedasPorPais as mpp on p.id_pais = mpp.id_pais
                left join Monedas as m on mpp.codigo_moneda = m.codigo_moneda
                left join LenguajesPorPais as lpp on p.id_pais = lpp.id_pais 
                left join Lenguajes as l on lpp.codigo_lenguaje = l.codigo_lenguaje
            GROUP BY p.nombre, c.nombre, p.poblacion, p.bandera
             """)
df = pd.DataFrame(conn.execute(query).fetchall())
df.to_excel('example.xlsx', sheet_name='Paises')

from openpyxl import load_workbook
from openpyxl.chart import Reference, BarChart

writer = pd.ExcelWriter('example.xlsx', engine='xlsxwriter')
df.to_excel(writer, sheet_name='Paises', index=False)

continent_count = df.groupby(['continente']).count()['nombre']
continent_count.to_excel(writer, sheet_name='Metricas', startrow=0, startcol=0)

top_5_population_countries = df[['nombre','poblacion']].sort_values('poblacion',ascending=False).head()
top_5_population_countries.to_excel(writer, sheet_name='Metricas', startrow=10, startcol=0)
writer.close()

wb = load_workbook('example.xlsx')
# wb = writer.book
ws = wb['Metricas'] 

chart0 = BarChart()
chart0.title = "Paises en cada continente"  # Set the chart title
chart0.x_axis_title = "continente"  # Set the x-axis title
chart0.y_axis_title = "cantidad"  # Set the y-axis title
# data = worksheet['C12':'C16']
data = Reference(ws, min_col=2, min_row=1, max_row=8)
categories = Reference(ws, min_col=1, min_row=2, max_row=8)
chart0.add_data(data, titles_from_data=True)
chart0.set_categories(categories)
ws.add_chart(chart0, "E5")

chart0 = BarChart()
chart0.title = "Top 5 paises con mas habitantes"  # Set the chart title
chart0.x_axis_title = "pais"  # Set the x-axis title
chart0.y_axis_title = "cantidad"  # Set the y-axis title
# data = worksheet['C12':'C16']
data = Reference(ws, min_col=3, min_row=11, max_row=16)
categories = Reference(ws, min_col=2, min_row=12, max_row=16)
chart0.add_data(data, titles_from_data=True)
chart0.set_categories(categories)
ws.add_chart(chart0, "E23")
wb.save('example.xlsx')