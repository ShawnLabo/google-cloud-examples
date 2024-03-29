import os
from io import BytesIO
from tempfile import NamedTemporaryFile

import cv2
from fastapi import FastAPI
from google.cloud import storage
from pydantic import BaseModel


client = storage.Client()


def download_video(video_uri: str, local_path: str):
    bucket_name, blob_name = video_uri[5:].split("/", maxsplit=1)
    bucket = client.bucket(bucket_name)
    video_blob = bucket.blob(blob_name)
    video_blob.download_to_filename(local_path)


def upload_frames(video: cv2.VideoCapture, output_root: str):
    bucket_name, base = output_root[5:].split("/", maxsplit=1)
    bucket = client.bucket(bucket_name)

    num_frames = video.get(cv2.CAP_PROP_FRAME_COUNT)
    digits = len(str(num_frames))

    n = 0

    while True:
        ret, frame = video.read()
        if not ret:
            break

        success, cv_buf = cv2.imencode(".png", frame)
        if not success:
            raise Exception(f"encode error: frame={n}")

        buf = BytesIO(cv_buf)

        blob = bucket.blob(os.path.join(base, f"{n:0{digits}}.png"))
        blob.upload_from_file(buf)

        n += 1


def slice_video(video_uri: str, output_root: str) -> None:
    with NamedTemporaryFile() as temp:
        download_video(video_uri=video_uri, local_path=temp.name)
        video = cv2.VideoCapture(temp.name)

        if not video.isOpened():
            raise Exception("video is not opened")

        upload_frames(video=video, output_root=output_root)


app = FastAPI()


class RequestBody(BaseModel):
    input_video_uri: str
    output_root_uri: str


class ResponseBody(BaseModel):
    success: bool


@app.post("/")
def root(req: RequestBody) -> ResponseBody:
    slice_video(req.input_video_uri, req.output_root_uri)
    return ResponseBody(success=True)
