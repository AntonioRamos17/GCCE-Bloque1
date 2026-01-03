from dagster import AssetExecutionContext, AssetKey, AssetIn
from dagster_dbt import DbtCliResource, dbt_assets, DagsterDbtTranslator

from .project import BI_project_project


class CustomTranslator(DagsterDbtTranslator):
    def get_asset_key(self, node_info):
        key = super().get_asset_key(node_info)

        cleaned = [
            p.replace("ñ", "n")
             .replace("á", "a")
             .replace("é", "e")
             .replace("í", "i")
             .replace("ó", "o")
             .replace("ú", "u")
            for p in key.path
        ]

        return AssetKey(cleaned)


@dbt_assets(
    manifest=BI_project_project.manifest_path,
    dagster_dbt_translator=CustomTranslator(),
    required_resource_keys={"dbt"}
)
def BI_project_dbt_assets(context):
    yield from context.resources.dbt.cli(["build"], context=context).stream()
