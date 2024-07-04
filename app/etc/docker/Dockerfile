FROM python:3.12-alpine as base
ENV  POETRY_HOME="/opt/poetry" \
     PYSETUP_PATH="/opt/pysetup" \
     POETRY_VIRTUALENVS_IN_PROJECT=true \
     POETRY_NO_INTERACTION=1 \
     VENV_PATH="/opt/pysetup/.venv"
ENV PATH="$POETRY_HOME/bin:$VENV_PATH/bin:$PATH"

FROM base as builder

RUN apk update \
    && apk add \
        curl \
        alpine-sdk \
    && apk cache clean

# Install Poetry - respects $POETRY_VERSION & $POETRY_HOME
ENV POETRY_VERSION=1.8.3
RUN curl -sSL https://install.python-poetry.org | python3 -

WORKDIR $PYSETUP_PATH
COPY ./poetry.lock ./pyproject.toml ./README.md ./
ADD ./src ./src

RUN poetry publish --build --dry-run

FROM base as production

COPY --from=builder $PYSETUP_PATH/dist/*.whl /tmp/

RUN pip install /tmp/*.whl \
 && rm /tmp/*.whl

EXPOSE 5000

ENTRYPOINT ["quart", "run"]

CMD ["-h", "0.0.0.0"]
