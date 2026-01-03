from dagster import asset

@asset(
    required_resource_keys={"airbyte"}
)
def airbyte_ingestion(context):
    airbyte = context.resources.airbyte
    return airbyte.sync_connection("cce057da-3ac0-47ab-9d30-c6a12f867f28")
