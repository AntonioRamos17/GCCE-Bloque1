import os
from pathlib import Path

from dagster_dbt import DbtProject
from dagster.utils import file_relative_path

BI_project_project = DbtProject(
    project_dir=Path(__file__).joinpath("..", "..", "..").resolve(),
    packaged_project_dir=Path(__file__).joinpath("..", "..", "dbt-project").resolve(),
)
BI_project_project.prepare_if_dev()

# Airbyte config
AIRBYTE_CONNECTION_ID = os.environ.get("AIRBYTE_CONNECTION_ID", "56509ede-206c-46a9-a2ba-f5c506acc4ce")

AIRBYTE_CONFIG = {
  "host": os.environ.get("AIRBYTE_HOST", "localhost"),
  "port": os.environ.get("AIRBYTE_PORT", "8000"),
  "username": "admin@ull.es",
  "password": "d0ryhqDaKueIqfcsmHTi2iXbblphcY3D",
}

DBT_PROJECT_DIR = file_relative_path(__file__, "../../BI_project")
DBT_PROFILES_DIR = file_relative_path(__file__, "../../BI_project")
DBT_CONFIG = {"project_dir": DBT_PROJECT_DIR, "profiles_dir": DBT_PROFILES_DIR}