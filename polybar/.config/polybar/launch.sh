#!/usr/bin/env bash

# Terminate already running bar instances
# If all your bars have ipc enabled, you can use 
polybar-msg cmd quit
# Otherwise you can use the nuclear option:
# killall -q polybar

# Kill existing auto-hide script
pkill -f "dock-autohide.sh"

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch main bar
echo "---" | tee -a /tmp/polybar1.log
polybar main 2>&1 | tee -a /tmp/polybar1.log & disown

# Launch dock bar
echo "---" | tee -a /tmp/polybar2.log
polybar dock 2>&1 | tee -a /tmp/polybar2.log & disown

# Wait a moment for polybar to start
sleep 2

# Launch auto-hide script for dock
if [[ -f ~/.config/polybar/scripts/dock-autohide.sh ]]; then
    echo "Starting dock auto-hide..."
    ~/.config/polybar/scripts/dock-autohide.sh &
    echo $! > /tmp/dock_autohide.pid
fi

echo "Polybar launched with auto-hide dock..."  

