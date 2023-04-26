FROM python:3.11-slim-bullseye

ENV PYTHONUNBUFFERED=True
ENV POETRY_NO_INTERACTION=1
ENV PORT=8080

WORKDIR /app

RUN pip install poetry

COPY pyproject.toml ./
COPY poetry.lock ./

RUN \
  poetry config virtualenvs.create false \
  && poetry install --only main --no-root

COPY . /app

CMD ["bash", "-c", "uvicorn --host 0.0.0.0 --port $PORT main:app"]
