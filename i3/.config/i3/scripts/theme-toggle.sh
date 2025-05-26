#!/bin/bash

# System-wide dark/light mode toggle for i3
# Uses xsettingsd and direct file manipulation instead of GNOME dependencies

CONFIG_DIR="$HOME/.config/theme-toggle"
STATE_FILE="$CONFIG_DIR/current_theme"
GTK2_CONFIG="$HOME/.gtkrc-2.0"
GTK3_CONFIG="$HOME/.config/gtk-3.0/settings.ini"
GTK4_CONFIG="$HOME/.config/gtk-4.0/settings.ini"
XSETTINGS_CONFIG="$HOME/.config/xsettingsd/xsettingsd.conf"

# Create config directories
mkdir -p "$CONFIG_DIR" "$(dirname "$GTK3_CONFIG")" "$(dirname "$GTK4_CONFIG")" "$(dirname "$XSETTINGS_CONFIG")"

# Initialize state file
[[ ! -f "$STATE_FILE" ]] && echo "dark" > "$STATE_FILE"

# Function to restart xsettingsd with new config
restart_xsettingsd() {
    pkill xsettingsd 2>/dev/null
    sleep 0.2
    xsettingsd &
}

# Function to set GTK theme
set_gtk_theme() {
    local theme="$1" icon_theme="$2" cursor_theme="$3"
    
    # GTK 2
    cat > "$GTK2_CONFIG" << EOF
gtk-theme-name="$theme"
gtk-icon-theme-name="$icon_theme"
gtk-cursor-theme-name="$cursor_theme"
gtk-font-name="JetBrains Mono 11"
gtk-application-prefer-dark-theme=$([ "$theme" = *"dark"* ] && echo "1" || echo "0")
EOF

    # GTK 3 & 4
    for config in "$GTK3_CONFIG" "$GTK4_CONFIG"; do
        cat > "$config" << EOF
[Settings]
gtk-theme-name=$theme
gtk-icon-theme-name=$icon_theme
gtk-cursor-theme-name=$cursor_theme
gtk-font-name=JetBrains Mono 11
gtk-application-prefer-dark-theme=$([ "$theme" = *"dark"* ] && echo "1" || echo "0")
EOF
    done
}

# Function to set xsettingsd theme
set_xsettings_theme() {
    local theme="$1" icon_theme="$2" cursor_theme="$3"
    
    cat > "$XSETTINGS_CONFIG" << EOF
Net/ThemeName "$theme"
Net/IconThemeName "$icon_theme"
Gtk/CursorThemeName "$cursor_theme"
Gtk/FontName "JetBrains Mono 11"
Net/EnableEventSounds 1
Xft/Antialias 1
Xft/Hinting 1
Xft/HintStyle "hintfull"
Xft/RGBA "rgb"
EOF
}

# Function to apply dark mode
apply_dark_mode() {
    set_gtk_theme "Adwaita-dark" "Papirus-Dark" "Adwaita"
    set_xsettings_theme "Adwaita-dark" "Papirus-Dark" "Adwaita"
    restart_xsettingsd
    
    # Signal running applications
    xrdb -merge <<< "Xcursor.theme: Adwaita"
    
    echo "dark" > "$STATE_FILE"
    notify-send "Theme Toggle" "Dark mode activated" -i weather-clear-night
}

# Function to apply light mode
apply_light_mode() {
    set_gtk_theme "Adwaita" "Papirus" "Adwaita"
    set_xsettings_theme "Adwaita" "Papirus" "Adwaita"
    restart_xsettingsd
    
    xrdb -merge <<< "Xcursor.theme: Adwaita"
    
    echo "light" > "$STATE_FILE"
    notify-send "Theme Toggle" "Light mode activated" -i weather-clear
}

# Function to toggle theme
toggle_theme() {
    local current_theme=$(cat "$STATE_FILE" 2>/dev/null || echo "dark")
    
    if [[ "$current_theme" == "dark" ]]; then
        apply_light_mode
    else
        apply_dark_mode
    fi
}

# Function to get current theme
get_current_theme() {
    cat "$STATE_FILE" 2>/dev/null || echo "dark"
}

# Function to create theme status indicator for polybar
polybar_status() {
    local current_theme=$(get_current_theme)
    [[ "$current_theme" == "dark" ]] && echo "🌙" || echo "☀️"
}

# Main execution
case "$1" in
    "toggle") toggle_theme ;;
    "dark") apply_dark_mode ;;
    "light") apply_light_mode ;;
    "status") echo "Current theme: $(get_current_theme)" ;;
    "polybar") polybar_status ;;
    *)
        echo "Usage: $0 {toggle|dark|light|status|polybar}"
        echo "  toggle  - Toggle between dark and light mode"
        echo "  dark    - Force dark mode"
        echo "  light   - Force light mode"
        echo "  status  - Show current theme"
        echo "  polybar - Show icon for polybar"
        ;;
esac