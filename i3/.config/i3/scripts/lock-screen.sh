#!/bin/bash

# Screen lock script for i3
# Locks screen and manages power states

# Take screenshot for blurred background
if command -v convert &> /dev/null; then
    scrot /tmp/screen_locked.png
    convert /tmp/screen_locked.png -scale 10% -scale 1000% /tmp/screen_locked.png
    LOCK_IMAGE="/tmp/screen_locked.png"
else
    echo "ImageMagick not installed. Skipping screenshot."
    LOCK_IMAGE=""
fi

# Lock the screen using i3lock
if [[ -n "$LOCK_IMAGE" ]]; then
    i3lock -i "$LOCK_IMAGE" -c 121218 --ignore-empty-password --show-failed-attempts
else
    i3lock -c 121218 --ignore-empty-password --show-failed-attempts
fi

# Clean up
rm -f /tmp/screen_locked.png
