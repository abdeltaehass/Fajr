#!/bin/sh
set -ex

FLUTTER_VERSION="3.41.1"

# Detect architecture and download the correct Flutter SDK
ARCH=$(uname -m)
if [ "$ARCH" = "arm64" ]; then
  FLUTTER_ZIP="flutter_macos_arm64_${FLUTTER_VERSION}-stable.zip"
else
  FLUTTER_ZIP="flutter_macos_${FLUTTER_VERSION}-stable.zip"
fi

echo ">>> Detected arch: $ARCH, downloading $FLUTTER_ZIP..."
curl -L "https://storage.googleapis.com/flutter_infra_release/releases/stable/macos/${FLUTTER_ZIP}" \
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
