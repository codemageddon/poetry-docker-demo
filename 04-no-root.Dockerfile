FROM python:3.12-bookworm AS build
RUN pip install poetry
WORKDIR /usr/src/app
ENV POETRY_VIRTUALENVS_CREATE=true \
    POETRY_VIRTUALENVS_IN_PROJECT=true
COPY . .
RUN poetry install --no-root --only main

FROM python:3.12-slim-bookworm AS runtime
ENV PATH="/usr/src/app/.venv/bin:${PATH}"
COPY --from=build /usr/src/app /usr/src/app
RUN useradd -g nogroup -M app
USER app
WORKDIR /usr/src/app
ENTRYPOINT ["python", "hello_world/main.py"]
