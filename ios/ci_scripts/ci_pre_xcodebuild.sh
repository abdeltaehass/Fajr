#!/bin/sh
set -ex

export PATH="$HOME/flutter/bin:$PATH"

echo ">>> Re-running flutter build ios --config-only..."
cd "$CI_PRIMARY_REPOSITORY_PATH"
flutter build ios --config-only --suppress-analytics

echo ">>> Done."
