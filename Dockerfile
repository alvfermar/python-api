FROM python:3.10.10-alpine3.17

LABEL maintainer="el_datero"

ENV PYTHONUNBUFFERED 1

# Setting up folder structure
ENV HOME=/home/django-user \
    VIRTUAL_ENV=/$HOME/venv
COPY ./pyproject.toml $HOME/pyproject.toml
COPY ./app $HOME/app
WORKDIR $HOME
EXPOSE 8000

# Creating the virtual environment and enabling it
# (the same that source venv/bin/activate does, see
# https://pythonspeed.com/articles/activate-virtualenv-dockerfile/)
RUN python -m venv $VIRTUAL_ENV
# Actually enabling the venv
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
RUN pip install --upgrade pip && \
    pip install poetry && \
    poetry install && \
    adduser \
        --disabled-password \
        --no-create-home \
        django-user && \
    # Changing ownership such that django user can act on its own  home directory
    chown -R django-user $HOME

USER django-user


# You need to use this to test and lint in your development environment as well. Start here!!
