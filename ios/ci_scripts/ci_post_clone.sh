#!/bin/sh
set -ex

export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

echo ">>> Downloading Flutter SDK..."
curl -L "https://storage.googleapis.com/flutter_infra_release/releases/stable/macos/flutter_macos_arm64_3.41.1-stable.zip" \
  -o "$HOME/flutter.zip"

echo ">>> Extracting Flutter SDK..."
unzip -q "$HOME/flutter.zip" -d "$HOME"
export PATH="$HOME/flutter/bin:$PATH"

echo ">>> Flutter version..."
flutter --version --suppress-analytics

echo ">>> Running flutter pub get..."
cd "$CI_PRIMARY_REPOSITORY_PATH"
flutter pub get --suppress-analytics

echo ">>> Running pod install..."
cd "$CI_PRIMARY_REPOSITORY_PATH/ios"
pod install

echo ">>> Done."
