"""
Script para obtener datos de la web de datos abiertos del ISTAC

"""

import requests, psycopg2, io

def fetchData(url, target_table, cursor):
    request = requests.get(url)
    if request.status_code != 200:
        print(f"[-] Error al obtener datos de {url}: {request.status_code}")
        return
    print(f"[+] Datos obtenidos de {url}")
    csv_data = request.text
    # Aquí he tenido que hacer un replace porque los datos no están bien formateados
    f = io.StringIO(csv_data.replace(",.", ","))
    # Borrar tabla y meter solo los datos nuevos
    cursor.execute(f"DELETE FROM {target_table};")
    cursor.copy_expert(f"COPY {target_table} FROM STDIN WITH CSV HEADER", f)
    print(f"[+] Datos insertados en {target_table}")
    return



urls = [
    ["https://datos.canarias.es/api/estadisticas/indicators/v1.0/indicators/INFRACCIONES_AMBIENTALES/data.csv", "infracciones_ambientales"],
    ["https://datos.canarias.es/api/estadisticas/indicators/v1.0/indicators/TURISTAS/data.csv", "turistas_recibidos"],
    ["https://datos.canarias.es/api/estadisticas/indicators/v1.0/indicators/ALOJATUR_ABIERTOS/data.csv", "alojamientos_abiertos"],
    ["https://datos.canarias.es/api/estadisticas/indicators/v1.0/indicators/VIVIENDA_LIBRE_PRECIO_M2/data.csv", "valor_m2_vivienda"]
]


# Definimos la conexión a la base de datos
conn = psycopg2.connect(
    dbname="erp_db",
    user="postgres",
    password="admin123",
    host="localhost"
)
cur = conn.cursor()
for url, target_table in urls:
    fetchData(url, target_table, cur)
cur.close()
conn.commit()
conn.close()

print(f"[+] Datos nuevos insertados correctamente en {target_table}.")