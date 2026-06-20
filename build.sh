#!/bin/bash
set -e

echo "=== Building KeepBluetoothSpeakerAlive App ==="

# 1. Clean previous build if any
rm -rf KeepBluetoothSpeakerAlive.app KeepBluetoothSpeakerAlive

# 2. Get macOS SDK path
SDK_PATH=$(xcrun --show-sdk-path)
echo "Using SDK: $SDK_PATH"

# 3. Compile Swift sources
echo "Compiling Swift files..."
swiftc \
    -sdk "$SDK_PATH" \
    -target arm64-apple-macos13.0 \
    -O \
    -o KeepBluetoothSpeakerAlive \
    Sources/KeepBluetoothSpeakerAliveApp.swift \
    Sources/PingManager.swift

# 4. Create App Bundle structure
echo "Creating KeepBluetoothSpeakerAlive.app bundle..."
mkdir -p KeepBluetoothSpeakerAlive.app/Contents/MacOS
mkdir -p KeepBluetoothSpeakerAlive.app/Contents/Resources

# 5. Move binary into the bundle
mv KeepBluetoothSpeakerAlive KeepBluetoothSpeakerAlive.app/Contents/MacOS/

# 6. Copy Info.plist
cp Info.plist KeepBluetoothSpeakerAlive.app/Contents/Info.plist

echo "=== Build Successful! ==="
echo "Application bundle created: KeepBluetoothSpeakerAlive.app"
