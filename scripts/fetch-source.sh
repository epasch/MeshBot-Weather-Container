#!/bin/bash

# Script to fetch the latest source code from the original Meshbot_weather repository
# This script should be run before building the Docker image

set -e

echo "Fetching Meshbot_weather source code..."

# Create a temporary directory
TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR"

# Clone the repository
git clone https://github.com/oasis6212/Meshbot_weather.git

# Copy the source files to the current directory
echo "Copying source files..."
cp -r Meshbot_weather/* ../
cp Meshbot_weather/.* ../ 2>/dev/null || true

# Go back to the original directory
cd ..

# Clean up
cd ..
rm -rf "$TEMP_DIR"

echo "Source code fetched successfully!"
echo "You can now build the Docker image with: docker build -t meshbot-weather ." 