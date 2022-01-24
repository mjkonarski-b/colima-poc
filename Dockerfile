#syntax = docker/dockerfile:experimental

arg PYTHON_VERSION=3.8.12
from python:${PYTHON_VERSION}-slim-buster

env DEBIAN_FRONTEND noninteractive
env TERM linux

run --mount=type=cache,target=/var/cache/apt --mount=type=cache,target=/var/lib/apt \
    apt update -qy && apt install -qy \
        tini \
        sudo \
        libpq-dev libffi-dev libssl-dev libsasl2-dev libkrb5-dev freetds-dev \
        freetds-bin build-essential apt-utils curl rsync netcat wget locales

run curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python -

entrypoint ["/usr/bin/tini", "--"]
