#!/bin/bash

# Theme debugging and troubleshooting script

echo "=== Theme System Debugging ==="
echo

# Check if required packages are installed
echo "1. Checking installed packages:"
packages=("adwaita-qt" "papirus-icon-theme" "qt5ct" "gsettings-desktop-schemas")
for pkg in "${packages[@]}"; do
    if dpkg -l | grep -q "$pkg"; then
        echo "  ✓ $pkg installed"
    else
        echo "  ✗ $pkg missing"
    fi
done
echo

# Check current gsettings
echo "2. Current gsettings values:"
echo "  GTK theme: $(gsettings get org.gnome.desktop.interface gtk-theme)"
echo "  Icon theme: $(gsettings get org.gnome.desktop.interface icon-theme)"
echo "  Color scheme: $(gsettings get org.gnome.desktop.interface color-scheme)"
echo "  Cursor theme: $(gsettings get org.gnome.desktop.interface cursor-theme)"
echo

# Check GTK config files
echo "3. GTK configuration files:"
if [[ -f ~/.gtkrc-2.0 ]]; then
    echo "  ✓ GTK 2 config exists"
    echo "    Theme: $(grep 'gtk-theme-name' ~/.gtkrc-2.0 | cut -d'"' -f2)"
else
    echo "  ✗ GTK 2 config missing"
fi

if [[ -f ~/.config/gtk-3.0/settings.ini ]]; then
    echo "  ✓ GTK 3 config exists"
    echo "    Theme: $(grep 'gtk-theme-name' ~/.config/gtk-3.0/settings.ini | cut -d'=' -f2)"
else
    echo "  ✗ GTK 3 config missing"
fi
echo

# Check environment variables
echo "4. Environment variables:"
echo "  GTK_THEME: ${GTK_THEME:-not set}"
echo "  QT_QPA_PLATFORMTHEME: ${QT_QPA_PLATFORMTHEME:-not set}"
echo "  XDG_CURRENT_DESKTOP: ${XDG_CURRENT_DESKTOP:-not set}"
echo

# Check available themes
echo "5. Available GTK themes:"
ls /usr/share/themes/ | head -10
echo

# Check dbus/gsettings connectivity
echo "6. Testing gsettings connectivity:"
if gsettings list-schemas | grep -q "org.gnome.desktop.interface"; then
    echo "  ✓ Can access GNOME schemas"
else
    echo "  ✗ Cannot access GNOME schemas"
fi
echo

# Check Firefox about:config values
echo "7. Firefox theme detection:"
firefox_profile=$(find ~/.mozilla/firefox -name "*.default*" -type d | head -1)
if [[ -n "$firefox_profile" && -f "$firefox_profile/prefs.js" ]]; then
    echo "  Firefox profile found: $(basename "$firefox_profile")"
    if grep -q "ui.systemUsesDarkTheme" "$firefox_profile/prefs.js"; then
        echo "  Dark theme setting: $(grep "ui.systemUsesDarkTheme" "$firefox_profile/prefs.js")"
    else
        echo "  No dark theme setting found in Firefox prefs"
    fi
else
    echo "  Firefox profile not found or no prefs.js"
fi
echo

echo "=== Suggested Fixes ==="
echo

# Check if we're in the right desktop environment
if [[ "$XDG_CURRENT_DESKTOP" != *"GNOME"* ]]; then
    echo "⚠️  You're not running GNOME. Setting XDG_CURRENT_DESKTOP=GNOME might help:"
    echo "   Add 'export XDG_CURRENT_DESKTOP=GNOME' to ~/.profile"
    echo
fi

# Check for missing dbus session
if [[ -z "$DBUS_SESSION_BUS_ADDRESS" ]]; then
    echo "⚠️  DBUS session not detected. This might prevent theme changes."
    echo "   Try running: eval \$(dbus-launch --sh-syntax)"
    echo
fi

# Suggest manual gsettings test
echo "🔧 Try manual theme change:"
echo "   gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'"
echo "   gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'"
echo

echo "🔧 Try XSettings daemon:"
echo "   Install: sudo apt install xsettingsd"
echo "   This provides theme settings for non-GNOME environments"
echo