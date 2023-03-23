FROM python:3.10.10-slim-bullseye

LABEL maintainer="el_datero"

ENV PYTHONUNBUFFERED 1

# Setting up folder structure
ENV HOME=/home/django-user
ENV WORKDIR=$HOME/python-api
ENV VIRTUAL_ENV=$WORKDIR/venv
COPY ./pyproject.toml $WORKDIR/pyproject.toml
COPY ./.pre-commit-config.yaml $WORKDIR/.pre-commit-config.yaml
COPY ./app $WORKDIR/app
WORKDIR $WORKDIR
EXPOSE 8000

# Creating the virtual environment and enabling it
# (the same that source venv/bin/activate does, see
# https://pythonspeed.com/articles/activate-virtualenv-dockerfile/)
RUN python -m venv $VIRTUAL_ENV
# Actually enabling the venv
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
RUN \
    # To install psycopg2
    apt-get -y update && \
    apt-get install -y postgresql-client && \
    apt-get install -y build-essential python3-dev libpq-dev && \
    # Installing venv
    pip install --upgrade pip && \
    pip install poetry && \
    poetry install && \
    # Purging build packages
    apt-get purge -y --auto-remove build-essential python3-dev libpq-dev && \
    # Adding new user
    adduser \
        --disabled-password \
        --no-create-home \
        django-user && \
    # Changing ownership such that django user can act on its own  home directory
    chown -R django-user $HOME

USER django-user
