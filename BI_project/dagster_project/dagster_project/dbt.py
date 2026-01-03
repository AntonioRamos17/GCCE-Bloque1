from dagster import AssetExecutionContext, AssetKey
from dagster_dbt import DbtCliResource, dbt_assets, DagsterDbtTranslator
from .project import BI_project_project

class CustomTranslator(DagsterDbtTranslator):
    def get_asset_key(self, node_info):
        key = super().get_asset_key(node_info)
        cleaned = [
            p.replace("ñ", "n").replace("á", "a").replace("é", "e")
             .replace("í", "i").replace("ó", "o").replace("ú", "u")
            for p in key.path
        ]
        return AssetKey(cleaned)

    def get_deps_for_resource(self, node_info):
        deps = super().get_deps_for_resource(node_info)

        if node_info["resource_type"] == "model":
            deps.append(AssetKey("airbyte_ingestion"))

        return deps

@dbt_assets(
    manifest=BI_project_project.manifest_path,
    dagster_dbt_translator=CustomTranslator()
)
def BI_project_dbt_assets(context: AssetExecutionContext, dbt: DbtCliResource):
    yield from dbt.cli(["build"], context=context).stream()
