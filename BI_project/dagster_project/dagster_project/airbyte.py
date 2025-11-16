from dagster import EnvVar
from dagster_airbyte import airbyte_resource, load_assets_from_airbyte_instance

from .project import AIRBYTE_CONFIG

# Connect to your OSS Airbyte instance
airbyte_instance = airbyte_resource.configured(AIRBYTE_CONFIG)

airbyte_assets = load_assets_from_airbyte_instance(airbyte_instance, key_prefix=["infrazion"])