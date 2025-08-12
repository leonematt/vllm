#!/bin/bash

venv_created=false
if [ ! -d ".venv" ]; then
    echo "Creating virtual environment..."
    uv venv --python 3.12 --seed
    venv_created=true
else
    echo "Virtual environment .venv already exists, skipping creation."
fi

source .venv/bin/activate

if [ -n "$VIRTUAL_ENV" ] && [ "$venv_created" = true ]; then
    echo "Installing build requirements..."
    uv pip install -r requirements/build.txt -v
elif [ -n "$VIRTUAL_ENV" ]; then
    echo "Already in virtual environment, skipping requirements installation."
else
    echo "Warning: Not in a virtual environment!"
fi

export MAX_JOBS=8
CCACHE_NOHASHDIR="true" pip install -v --no-build-isolation -e .
