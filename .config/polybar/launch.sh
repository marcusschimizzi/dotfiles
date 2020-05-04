#!/usr/bin/env sh

# Terminate existing bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch bar for all monitors
for m in $(polybar --list-monitors | cut -d":" -f1);
do
    MONITOR=$m polybar --reload -c $HOME/.config/polybar/config.ini i3 &
done

for m in $(polybar --list-monitors | cut -d":" -f1);
do
    MONITOR=$m polybar --reload -c $HOME/.config/polybar/config.ini control &
done

MONITOR="HDMI-1" polybar --reload -c $HOME/.config/polybar/config.ini tray &

