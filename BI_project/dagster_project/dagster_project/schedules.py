from dagster import AssetSelection, define_asset_job, ScheduleDefinition
from .dbt import BI_project_dbt_assets

# 1. Definimos el Job solo para Airbyte
airbyte_job = define_asset_job(
    name="airbyte_ingestion_job",
    selection=AssetSelection.assets("airbyte_ingestion")
)

# 2. Definimos el Job solo para dbt
dbt_job = define_asset_job(
    name="dbt_transformation_job",
    selection=AssetSelection.assets(BI_project_dbt_assets)
)

schedules = [
    # Schedule para Airbyte a las 00:00
    ScheduleDefinition(
        job=airbyte_job,
        cron_schedule="0 0 * * *",
    ),
    # Schedule para dbt a las 00:10
    ScheduleDefinition(
        job=dbt_job,
        cron_schedule="10 0 * * *",
    ),
]
