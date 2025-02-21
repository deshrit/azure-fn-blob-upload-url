import os
import datetime
from azure.identity import DefaultAzureCredential
from azure.storage.blob import (
    ContainerClient,
    generate_container_sas,
    ContainerSasPermissions,
)
from urllib.parse import quote


CONTAINER_URL = os.environ["CONTAINER_URL"]
ACCOUNT_KEY = os.environ["ACCOUNT_KEY"]
credential = DefaultAzureCredential()


def generate_container_sas_token(container_client: ContainerClient) -> str:
    """
    Generage SAS token that is valid for 3 hrs
    """
    start_time = datetime.datetime.now(datetime.timezone.utc)
    expiry_time = start_time + datetime.timedelta(hours=3)
    sas_token = generate_container_sas(
        account_name=container_client.account_name,  # type: ignore
        container_name=container_client.container_name,
        account_key=ACCOUNT_KEY,
        permission=ContainerSasPermissions(write=True),
        expiry=expiry_time,
        start=start_time,
    )

    return sas_token


def generate_container_sas_url(filename: str) -> str:
    """
    Generate SAS file upload URL string
    """
    container_client = ContainerClient.from_container_url(CONTAINER_URL, credential)
    sas_token = generate_container_sas_token(container_client)
    return f"{container_client.url}/{quote(filename)}?{sas_token}"
