from dagster import Definitions
from dagster_dbt import DbtCliResource

from .dbt import BI_project_dbt_assets

from .airbyte_syncs import airbyte_ingestion
from .airbyte import AirbyteV2Resource


from .project import BI_project_project
from .schedules import schedules


defs = Definitions(
    assets=[BI_project_dbt_assets, airbyte_ingestion],
    schedules=schedules,
    resources={
        "dbt": DbtCliResource(project_dir=BI_project_project),
        "airbyte": AirbyteV2Resource(host="localhost", port=8000),
    },
)
