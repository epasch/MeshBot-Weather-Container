#!/bin/bash

# Startup script for Meshbot_weather that automatically detects the Meshtastic device

echo "Detecting Meshtastic device..."

# Check if device is specified via environment variable
if [ -n "$MESHTASTIC_DEVICE" ]; then
    if [ -e "$MESHTASTIC_DEVICE" ]; then
        echo "Using device from environment variable: $MESHTASTIC_DEVICE"
        exec python meshbot.py --port "$MESHTASTIC_DEVICE"
    else
        echo "Device specified in MESHTASTIC_DEVICE not found: $MESHTASTIC_DEVICE"
        echo "Available devices:"
        ls -la /dev/tty* 2>/dev/null | grep -E "(USB|ACM|usb)" || echo "No USB devices found"
        echo ""
        echo "Trying network mode..."
        exec python meshbot.py --host localhost
    fi
fi

# Look for common Meshtastic device patterns
DEVICE_PATHS=(
    "/dev/ttyUSB0"
    "/dev/ttyUSB1"
    "/dev/ttyACM0"
    "/dev/ttyACM1"
    "/dev/tty.usbmodem*"
    "/dev/tty.usbserial*"
    "/dev/tty.usb*"
)

FOUND_DEVICE=""

# Check each possible device path
for pattern in "${DEVICE_PATHS[@]}"; do
    for device in $pattern; do
        if [ -e "$device" ]; then
            echo "Found device: $device"
            FOUND_DEVICE="$device"
            break 2
        fi
    done
done

if [ -z "$FOUND_DEVICE" ]; then
    echo "No Meshtastic device found. Available serial devices:"
    ls -la /dev/tty* 2>/dev/null | grep -E "(USB|ACM|usb)" || echo "No USB devices found"
    echo ""
    echo "Trying network mode..."
    exec python meshbot.py --host localhost
fi

echo "Starting Meshbot_weather with device: $FOUND_DEVICE"
exec python meshbot.py --port "$FOUND_DEVICE" 