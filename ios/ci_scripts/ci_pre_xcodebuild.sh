#!/bin/sh
set -ex

export PATH="$HOME/flutter/bin:$PATH"

echo ">>> Creating Flutter build directory..."
mkdir -p "$CI_PRIMARY_REPOSITORY_PATH/build"

echo ">>> Re-running flutter build ios --config-only..."
cd "$CI_PRIMARY_REPOSITORY_PATH"
flutter build ios --config-only --suppress-analytics

echo ">>> Done."
