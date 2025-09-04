#!/bin/bash
set -euo pipefail

# Detect if already inside a virtual environment
if [ -n "${VIRTUAL_ENV:-}" ]; then
    echo "Already inside a virtual environment: $VIRTUAL_ENV"
    venv_created=false
else
    venv_created=false
    if [ ! -d ".venv" ]; then
        echo "Creating virtual environment..."
        uv venv --python 3.12 --seed
        venv_created=true
    else
        echo "Virtual environment .venv already exists, skipping creation."
    fi

    echo "Activating .venv..."
    source .venv/bin/activate
fi

# Install build requirements if we just created the venv
if [ "$venv_created" = true ]; then
    echo "Installing build requirements..."
    uv pip install -r requirements/build.txt -v
else
    echo "Skipping build requirements installation (venv already in use)."
fi

# Use all available CPUs for parallel jobs
if command -v nproc &>/dev/null; then
    MAX_JOBS=$(nproc)
elif [[ "$(uname)" == "Darwin" ]]; then
    MAX_JOBS=$(sysctl -n hw.ncpu)
else
    MAX_JOBS=4  # fallback
fi
export MAX_JOBS

echo "Using $MAX_JOBS parallel jobs."

CCACHE_NOHASHDIR="true" pip install -v --no-build-isolation -e .

