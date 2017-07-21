#!/bin/sh

# Output directory
OUTPUT="Bahama Air.playgroundbook"

# Copy contents
cp "$SRCROOT/BahamaAirLoginScreen/ViewController.swift" "$OUTPUT/Contents/Sources"
cp "$SRCROOT/BahamaAirLoginScreen/AnimationViewController.swift" "$OUTPUT/Contents/Sources"

# Build storyboard & assets
cp "$CODESIGNING_FOLDER_PATH/Assets.car" "$OUTPUT/Contents/PrivateResources"
cp -r "$CODESIGNING_FOLDER_PATH/Base.lproj/Main.storyboardc" "$OUTPUT/Contents/PrivateResources"
