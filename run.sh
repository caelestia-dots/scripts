#!/usr/bin/env sh

# Utility script for running caelestia

cd "$(dirname $0)/src" || exit

python -m caelestia "$@"
