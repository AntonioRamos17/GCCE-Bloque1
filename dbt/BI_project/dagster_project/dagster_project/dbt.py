
import dagster as dg
from dagster import AssetExecutionContext
from dagster_dbt import DbtCliResource, dbt_assets

from .constants import BI_project_project

# Creamos un asset de DBT
@dbt_assets(manifest=BI_project_project.manifest_path)
def BI_project_dbt_assets(context: AssetExecutionContext, dbt: DbtCliResource):
    yield from dbt.cli(["build"], context=context).stream()


# Definiendo los endpoints de los datos
@dg.asset
def url_infracciones_ambientales() -> str:
  return "https://datos.canarias.es/api/estadisticas/indicators/v1.0/indicators/INFRACCIONES_AMBIENTALES/data.csv";

@dg.asset
def url_turistas_recibidos() -> str:
  return "https://datos.canarias.es/api/estadisticas/indicators/v1.0/indicators/TURISTAS/data.csv";

@dg.asset
def url_alojamientos_abiertos() -> str:
  return "https://datos.canarias.es/api/estadisticas/indicators/v1.0/indicators/ALOJATUR_ABIERTOS/data.csv"

@dg.asset
def url_valor_m2_vivienda() -> str:
  return "https://datos.canarias.es/api/estadisticas/indicators/v1.0/indicators/VIVIENDA_LIBRE_PRECIO_M2/data.csv"