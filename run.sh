#!/bin/bash

cd /tmp/host
source ~/.poetry/env

#poetry config installer.parallel false
while true; do
    rm -rf /root/.cache/pypoetry
    poetry install --no-interaction
done