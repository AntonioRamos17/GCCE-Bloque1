from dagster import ConfigurableResource, Failure
import requests


class AirbyteV2Resource(ConfigurableResource):
    host: str
    port: int

    @property
    def _base_url(self) -> str:
        return f"http://{self.host}:{self.port}/api/v1"

    @property
    def _headers(self) -> dict:
        return {
            "Content-Type": "application/json",
            "X-Airbyte-Analytic-Source": "webapp",
        }

    def _get(self, path: str, params: dict | None = None):
        url = f"{self._base_url}{path}"
        resp = requests.get(
            url,
            params=params,
            headers=self._headers,
        )

        if not resp.ok:
            raise Failure(
                f"Airbyte GET error {resp.status_code}: {resp.text}"
            )

        return resp.json()

    def _post(self, path: str, payload: dict):
        url = f"{self._base_url}{path}"
        resp = requests.post(
            url,
            json=payload,
            headers=self._headers,
        )

        if not resp.ok:
            raise Failure(
                f"Airbyte POST error {resp.status_code}: {resp.text}"
            )

        return resp.json()

    # -----------------------
    # Public API
    # -----------------------

    def list_workspaces(self):
        """
        Lista workspaces de Airbyte
        """
        return self._get("/workspaces")

    def sync_connection(self, connection_id: str):
        """
        Lanza una sincronización manual de una conexión
        """
        return self._post(
            "/connections/sync",
            {"connectionId": connection_id},
        )
