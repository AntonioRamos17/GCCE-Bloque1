from dagster import Definitions
from dagster_dbt import DbtCliResource

from .dbt import BI_project_dbt_assets
from .airbyte import airbyte_assets
from .constants import BI_project_project
from .schedules import schedules

defs = Definitions(
    assets=[BI_project_dbt_assets, airbyte_assets],
    schedules=schedules,
    resources={
        "dbt": DbtCliResource(project_dir=BI_project_project),
    },
)