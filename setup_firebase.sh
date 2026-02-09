#!/bin/bash

# Check if .firebase directory exists
if [ ! -d ".firebase" ]; then
    echo "Error: .firebase directory not found. Exiting."
    exit 1
fi

# Define environments
envs=("integration" "uat" "qa" "prod" "dev")

# Loop through each environment
for env in "${envs[@]}"; do
    FIREBASE_DIR=".firebase/$env"
    ANDROID_DEST="android/app/src/$env/google-services.json"
    IOS_DEST="ios/Runner/$env/GoogleService-Info.plist"

    # Create destination directories if they don't exist
    mkdir -p "$(dirname "$ANDROID_DEST")"
    mkdir -p "$(dirname "$IOS_DEST")"

    # Ensure source files exist before copying
    if [ -f "$FIREBASE_DIR/google-services.json" ]; then
        cp "$FIREBASE_DIR/google-services.json" "$ANDROID_DEST"
        echo "Copied google-services.json to $ANDROID_DEST"
    else
        echo "Error: google-services.json not found in $FIREBASE_DIR"
    fi

    if [ -f "$FIREBASE_DIR/GoogleService-Info.plist" ]; then
        cp "$FIREBASE_DIR/GoogleService-Info.plist" "$IOS_DEST"
        echo "Copied GoogleService-Info.plist to $IOS_DEST"
    else
        echo "Error: GoogleService-Info.plist not found in $FIREBASE_DIR"
    fi

done

# Copy integration file to Runner destination
RUNNER_DEST="ios/Runner/GoogleService-Info.plist"
integration_source=".firebase/integration/GoogleService-Info.plist"
if [ -f "$integration_source" ]; then
    cp "$integration_source" "$RUNNER_DEST"
    echo "Copied GoogleService-Info.plist to $RUNNER_DEST"
else
    echo "Error: GoogleService-Info.plist not found in $integration_source"
fi
