import dagster as dg

# Vamos a definir nuestras tablas, recursos entre otros..
@dg.asset
def infracciones_ambientales() -> str:
  return "https://datos.canarias.es/api/estadisticas/indicators/v1.0/indicators/INFRACCIONES_AMBIENTALES/data.csv";

@dg.asset
def turistas_recibidos() -> str:
  return "https://datos.canarias.es/api/estadisticas/indicators/v1.0/indicators/TURISTAS/data.csv";

@dg.asset
def alojamientos_abiertos() -> str:
  return "https://datos.canarias.es/api/estadisticas/indicators/v1.0/indicators/ALOJATUR_ABIERTOS/data.csv"

@dg.asset
def valor_m2_vivienda() -> str:
  return "https://datos.canarias.es/api/estadisticas/indicators/v1.0/indicators/VIVIENDA_LIBRE_PRECIO_M2/data.csv"


