FROM python:3.12-bookworm
RUN pip install poetry
WORKDIR /usr/src/app
COPY . .
RUN poetry install --no-root
ENTRYPOINT ["poetry", "run", "python", "hello_world/main.py"]
