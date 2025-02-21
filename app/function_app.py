import logging
import json
import azure.functions as func
from utils import generate_container_sas_url

app = func.FunctionApp(http_auth_level=func.AuthLevel.FUNCTION)


@app.function_name("func-blob-upload-url")
@app.route(route="getUploadURL")
def get_upload_url(req: func.HttpRequest):
    logging.info("HTTP TRIGGER HIT")
    filename = req.params.get("filename")
    if not filename:
        return func.HttpResponse(
            json.dumps({"detail": "'filename' query parameter is required"}),
            status_code=400,
            mimetype="application/json",
        )
    upload_url = generate_container_sas_url(filename)
    return func.HttpResponse(
        json.dumps({"uploadURL": upload_url}),
        status_code=200,
        mimetype="application/json",
    )
