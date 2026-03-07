#!/bin/sh
set -e

export PATH="/opt/homebrew/bin:$PATH"

# Install Flutter
brew install --cask flutter

# Add Flutter to PATH
export PATH="/opt/homebrew/Caskroom/flutter/$(ls /opt/homebrew/Caskroom/flutter)/flutter/bin:$PATH"

# Get pub dependencies (generates Generated.xcconfig)
cd "$CI_PRIMARY_REPOSITORY_PATH"
flutter pub get

# Install CocoaPods dependencies
cd "$CI_PRIMARY_REPOSITORY_PATH/ios"
pod install
