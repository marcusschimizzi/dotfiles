#!/bin/bash

# Application dock script for polybar
# Shows running applications in current workspace with icons

# Color definitions (matching polybar config)
COLOR_ACTIVE="%{F#1e1e2e}%{B#89b4fa}"
COLOR_INACTIVE="%{F#cdd6f4}%{B-}"
COLOR_RESET="%{F-}%{B-}"

# Icon mappings for common applications
declare -A APP_ICONS=(
    ["firefox"]=""
    ["chromium"]=""
    ["google-chrome"]=""
    ["brave"]=""
    ["code"]=""
    ["code-oss"]=""
    ["vscodium"]=""
    ["vim"]=""
    ["nvim"]=""
    ["emacs"]=""
    ["ghostty"]=""
    ["alacritty"]=""
    ["kitty"]=""
    ["gnome-terminal"]=""
    ["xterm"]=""
    ["terminator"]=""
    ["thunar"]=""
    ["nautilus"]=""
    ["dolphin"]=""
    ["pcmanfm"]=""
    ["nemo"]=""
    ["spotify"]=""
    ["discord"]=""
    ["slack"]=""
    ["telegram"]=""
    ["telegram-desktop"]=""
    ["signal"]=""
    ["gimp"]=""
    ["inkscape"]=""
    ["blender"]=""
    ["obs"]=""
    ["obs-studio"]=""
    ["vlc"]=""
    ["mpv"]=""
    ["steam"]=""
    ["libreoffice"]=""
    ["writer"]=""
    ["calc"]=""
    ["impress"]=""
    ["thunderbird"]=""
    ["evolution"]=""
    ["zoom"]=""
    ["teams"]=""
    ["skype"]=""
    ["default"]=""
)

get_app_icon() {
    local app_name="$1"
    local app_lower=$(echo "$app_name" | tr '[:upper:]' '[:lower:]')
    
    # Check for partial matches in window title/class
    for key in "${!APP_ICONS[@]}"; do
        if [[ "$app_lower" == *"$key"* ]]; then
            echo "${APP_ICONS[$key]}"
            return
        fi
    done
    
    # Default icon
    echo "${APP_ICONS[default]}"
}

# Handle click events
if [[ "$1" == "--click" ]]; then
    window_index="$2"
    if [[ -n "$window_index" && "$window_index" =~ ^[0-9]+$ ]]; then
        current_workspace=$(xprop -root _NET_CURRENT_DESKTOP | cut -d' ' -f3)
        mapfile -t window_ids < <(wmctrl -l | awk -v ws="$current_workspace" '$2 == ws {print $1}')
        
        if [[ -n "${window_ids[$window_index]}" ]]; then
            wmctrl -i -a "${window_ids[$window_index]}"
        fi
    fi
    exit 0
fi

# Check if required tools are available
if ! command -v wmctrl &> /dev/null || ! command -v xprop &> /dev/null; then
    echo "%{F#f38ba8} Install wmctrl and xprop %{F-}"
    exit 1
fi

# Get current workspace
current_workspace=$(xprop -root _NET_CURRENT_DESKTOP | cut -d' ' -f3)

# Get active window
active_window=$(xprop -root _NET_ACTIVE_WINDOW | cut -d' ' -f5)

# Get windows in current workspace
output=""
counter=0

while IFS= read -r line; do
    if [[ -n "$line" ]]; then
        window_id=$(echo "$line" | awk '{print $1}')
        window_title=$(echo "$line" | cut -d' ' -f4-)
        
        # Get the application name from the window title
        icon=$(get_app_icon "$window_title")
        
        # Check if this is the active window
        if [[ "$window_id" == "$active_window" ]]; then
            output+="%{A1:~/.config/polybar/scripts/app-dock.sh --click $counter:}${COLOR_ACTIVE} $icon %{A}${COLOR_RESET}"
        else
            output+="%{A1:~/.config/polybar/scripts/app-dock.sh --click $counter:}${COLOR_INACTIVE} $icon %{A}${COLOR_RESET}"
        fi
        
        ((counter++))
    fi
done < <(wmctrl -l | awk -v ws="$current_workspace" '$2 == ws')

# If no windows, show empty state
if [[ -z "$output" ]]; then
    output="${COLOR_INACTIVE} No apps ${COLOR_RESET}"
fi

echo "$output"
