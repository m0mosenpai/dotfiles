#!/usr/bin/env bash

# terminate any running instances
killall -q polybar
pkill -f scroll_spotify_status.sh
pkill -f get_spotify_status.sh

# wait for polybar processes to shut down
while pgrep -u $(id -u) -x polybar >/dev/null; do sleep 1; done

# launch polybar on all connected displays
if type "xrandr" > /dev/null 2>&1; then
  for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    MONITOR=$m polybar --reload example 2>&1 | tee -a /tmp/polybar-$m.log &
  done
else
  polybar --reload example 2>&1 | tee -a /tmp/polybar.log &
fi

echo "Bars launched..."
