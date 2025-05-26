#!/bin/bash

# Dynamic wallpaper manager for i3

WALLPAPER_DIR="$HOME/Pictures/wallpapers"
CONFIG_FILE="$HOME/.config/wallpaper.conf"

# Create config if it doesn't exist
if [[ ! -f "$CONFIG_FILE" ]]; then
  cat > "$CONFIG_FILE" << EOF
# Wallpaper configuration
MODE="single"           # single,rotate,time_based,workspace
ROTATE_INTERVAL=300     # seconds between rotations
CURRENT_WALLPAPER=""
EOF
fi

source "$CONFIG_FILE"

# Function to set the wallpaper
set_wallpaper() {
  local wallpaper="$1"
  if [[ -f "$wallpaper" ]]; then
    feh --bg-scale "$wallpaper"
    echo "CURRENT_WALLPAPER=\"$wallpaper\"" > "$CONFIG_FILE.tmp"
    grep -v "CURRENT_WALLPAPER" "$CONFIG_FILE" >> "$CONFIG_FILE.tmp"
    mv "$CONFIG_FILE.tmp" "$CONFIG_FILE"
    notify-send "Wallpaper" "Set to $(basename "$wallpaper")"
  fi
}

get_random_wallpaper() {
  find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" \) | shuf -n 1 
}

get_time_wallpaper() {
  local hour=$(date +%H)
  if [[ $hour -ge 6 && $hour -lt 12 ]]; then
    find "$WALLPAPER_DIR/morning" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" \) | shuf -n 1 2>/dev/null || get_random_wallpaper
  elif [[ $hour -ge 12 && $hour -lt 18 ]]; then
    find "$WALLPAPER_DIR/afternoon" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" \) | shuf -n 1 2>/dev/null || get_random_wallpaper
  elif [[ $hour -ge 18 && $hour -lt 22 ]]; then
    find "$WALLPAPER_DIR/evening" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" \) | shuf -n 1 2>/dev/null || get_random_wallpaper
  else
    find "$WALLPAPER_DIR/night" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" \) | shuf -n 1 2>/dev/null || get_random_wallpaper
  fi
}

# Main logic
case "$1" in
  "next")
    wallpaper=$(get_random_wallpaper)
    set_wallpaper "$wallpaper"
    ;;
  "time")
    wallpaper=$(get_time_wallpaper)
    set_wallpaper "$wallpaper"
    ;;
  "select")
    wallpaper=$(find "$WALLPAPER_DIR" -type f  \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" \) | sed "s|$WALLPAPER_DIR/||" | rofi -dmenu -p "Select wallpaper")
    if [[ -n "$wallpaper" ]]; then
      set_wallpaper "$WALLPAPER_DIR/$wallpaper"
    fi
    ;;
  "restore")
    if [[ -n "$CURRENT_WALLPAPER" && -f "$CURRENT_WALLPAPER" ]]; then
      feh --bg-scale "$CURRENT_WALLPAPER"
    else
      wallpaper=$(get_random_wallpaper)
      set_wallpaper "$wallpaper"
    fi
    ;;
  *)
    echo "Usage: $0 {next|time|select|restore}"
    echo "  next    - Set random wallpaper"
    echo "  time    - Set time-based wallpaper"
    echo "  select  - Choose wallpaper via rofi"
    echo "  restore - Restore last wallpaper"
    ;;
esac
