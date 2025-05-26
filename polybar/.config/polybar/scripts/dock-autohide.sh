#!/bin/bash

# Simple auto-hide dock script for polybar
# Uses polybar's built-in hide/show capabilities

# Configuration
TRIGGER_ZONE=10  # pixels from bottom edge to trigger show
HIDE_DELAY=1     # seconds to wait before hiding

# Function to get screen height
get_screen_height() {
    xrandr --current | grep -E '\*' | head -1 | awk '{print $1}' | cut -d'x' -f2
}

# Function to get mouse Y position
get_mouse_y() {
    xdotool getmouselocation --shell | grep Y= | cut -d'=' -f2
}

# Function to check if dock should be visible
should_show_dock() {
    local mouse_y=$(get_mouse_y)
    local screen_height=$(get_screen_height)
    local distance_from_bottom=$((screen_height - mouse_y))
    
    [[ $distance_from_bottom -le $TRIGGER_ZONE ]]
}

# Function to get dock polybar PID
get_dock_pid() {
    pgrep -f "polybar.*dock" | head -1
}

# Function to show dock
show_dock() {
    local dock_pid=$(get_dock_pid)
    if [[ -n "$dock_pid" ]]; then
        polybar-msg -p "$dock_pid" cmd show 2>/dev/null
    fi
}

# Function to hide dock
hide_dock() {
    local dock_pid=$(get_dock_pid)
    if [[ -n "$dock_pid" ]]; then
        polybar-msg -p "$dock_pid" cmd hide 2>/dev/null
    fi
}

# Check if required tools are available
if ! command -v xdotool &> /dev/null; then
    echo "Error: xdotool is required for auto-hide functionality"
    echo "Install with: sudo apt install xdotool"
    exit 1
fi

# Initialize dock as hidden
echo "Starting dock auto-hide daemon..."
hide_dock

dock_visible=false
last_trigger_time=0

# Main loop
while true; do
    current_time=$(date +%s)
    
    if should_show_dock; then
        if ! $dock_visible; then
            show_dock
            dock_visible=true
        fi
        last_trigger_time=$current_time
    else
        # Hide dock after delay
        if $dock_visible && [[ $((current_time - last_trigger_time)) -ge $HIDE_DELAY ]]; then
            hide_dock
            dock_visible=false
        fi
    fi
    
    sleep 0.1
done
