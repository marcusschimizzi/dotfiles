#!/bin/bash

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd )"

ROFI_CMD="rofi -config ~/.config/rofi/config.rasi"

show_apps() {
  $ROFI_CMD -show drun
}

show_run() {
  $ROFI_CMD -show run
}

show_windows() {
  $ROFI_CMD -show window
}

show_powermenu() {
  local options="⏻ Shutdown\n󰜉 Reboot\n󰒲 Suspend\n Lock\n󰗽 Logout"
  local selected=$(echo -e "$options" | $ROFI_CMD -dmenu -p "Power Menu" -format s -selected-row 0)

  case "$selected" in
    *Shutdown)
      systemctl poweroff
      ;;
    *Reboot)
      systemctl reboot
      ;;
    *Suspend)
      systemctl suspend
      ;;
    *Lock)
      i3lock -c 1e1e2e
      ;;
    *Logout)
      i3-msg exit
      ;;
  esac
  
}

show_network() {
    if command -v nmcli &> /dev/null; then
        local networks=$(nmcli device wifi list | tail -n +2 | awk '{print $2}' | head -10)
        local selected=$(echo "$networks" | $ROFI_CMD -dmenu -p "WiFi Networks")
        
        if [[ -n "$selected" ]]; then
            nmcli device wifi connect "$selected"
        fi
    else
        echo "NetworkManager not available" | $ROFI_CMD -dmenu -p "Error"
    fi
}

case "${1:-apps}" in
  apps|drun)
    show_apps
    ;;
  run)
    show_run
    ;;
  window|windows)
    show_windows
    ;;
  power|powermenu)
    show_powermenu
    ;;
  network|wifi)
    show_network
    ;;
  *)
    echo "Usage: $0 [apps|run|window]"
    echo "  apps    - Application launcher (default)"
    echo "  run     - Run command"
    echo "  window  - Window switcher"
    echo "  power   - Power menu"
    echo "  network - Network selector"
    ;;

esac

