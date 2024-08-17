FROM python:3.12-slim-bookworm AS build
RUN pip install poetry==1.8.3
WORKDIR /usr/src/app
ENV POETRY_VIRTUALENVS_CREATE=true \
    POETRY_VIRTUALENVS_IN_PROJECT=true \
    POETRY_CACHE_DIR=/tmp/poetry_cache
COPY pyproject.toml poetry.lock ./
RUN --mount=type=cache,target=$POETRY_CACHE_DIR poetry install --no-root --only main

FROM python:3.12-slim-bookworm AS runtime
ENV PATH="/usr/src/app/.venv/bin:${PATH}"
COPY --from=build /usr/src/app/.venv /usr/src/app/.venv
RUN useradd -U -M -d /nonexistent app
USER app
WORKDIR /usr/src/app
COPY hello_world ./hello_world
ENTRYPOINT ["python", "hello_world/main.py"]
