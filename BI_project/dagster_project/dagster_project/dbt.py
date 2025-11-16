from dagster import AssetExecutionContext
from dagster_dbt import DbtCliResource, dbt_assets

from .project import BI_project_project


@dbt_assets(manifest=BI_project_project.manifest_path)
def BI_project_dbt_assets(context: AssetExecutionContext, dbt: DbtCliResource):
    yield from dbt.cli(["build"], context=context).stream()
    