FROM python:3.11-slim-bullseye

ENV PYTHONUNBUFFERED=True
ENV POETRY_NO_INTERACTION=1

WORKDIR /app

RUN pip install poetry

COPY pyproject.toml ./
COPY poetry.lock ./

RUN poetry install --only main --no-root

COPY . /app

CMD ["poetry", "run", "python", "main.py"]
