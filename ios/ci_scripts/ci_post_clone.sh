#!/bin/sh
set -e

# Install Flutter
FLUTTER_VERSION="3.41.1"
FLUTTER_DIR="$HOME/flutter"

git clone https://github.com/flutter/flutter.git "$FLUTTER_DIR" --branch "$FLUTTER_VERSION" --depth 1
export PATH="$FLUTTER_DIR/bin:$PATH"

# Get dependencies and generate Generated.xcconfig
cd "$CI_PRIMARY_REPOSITORY_PATH"
flutter pub get

# Install CocoaPods dependencies
cd ios
pod install

