#!/usr/bin/env bash

# terminate any running instances
killall -9 polybar

# wait for polybar processes to shut down
while pgrep -u $(id -u) -x polybar >/dev/null; do sleep 0.1; done
sleep 1

# launch polybar on all connected displays
if type "xrandr" > /dev/null 2>&1; then
  for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    MONITOR=$m polybar --reload example 2>&1 | tee -a /tmp/polybar-$m.log &
  done
else
  polybar --reload example 2>&1 | tee -a /tmp/polybar.log &
fi

echo "Bars launched..."
