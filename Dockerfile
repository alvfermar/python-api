FROM python:3.10.10-alpine3.17

LABEL maintainer="el_datero"

ENV PYTHONUNBUFFERED 1

# Setting up folder structure
COPY ./pyproject.toml /tmp
COPY ./app /app
WORKDIR /app
EXPOSE 8000

# Creating the virtual environment and enabling it
# (the same that source venv/bin/activate does, see
# https://pythonspeed.com/articles/activate-virtualenv-dockerfile/)
ENV VIRTUAL_ENV=/venv
RUN python -m venv $VIRTUAL_ENV
# Actually enabling the venv
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
RUN pip install --upgrade pip && \
    pip install poetry && \
    cd /tmp && \
    poetry install \
    cd /app && rm -rf /tmp && \
    adduser \
        --disabled-password \
        --no-create-home \
        django-user

USER django-user
