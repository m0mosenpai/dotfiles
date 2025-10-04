#!/bin/bash

# primary windows - firefox, terminal, spotify
# set primary windows to their assigned places
i3-msg '[class="firefox"] move to workspace number 1'
i3-msg '[class="ghostty|Alacritty|kitty|wezterm"] move to workspace number 2'
for_window [class="Spotify"] move --no-auto-back-and-forth container to workspace "3"

# check if an external monitor was connected
EXTERNAL=$(xrandr --query | grep " connected" | grep -v "eDP" | cut -d" " -f1 | head -n1)

# move primary windows to external monitor
if [ -n "$EXTERNAL" ]; then
    i3-msg "workspace 1; move workspace to output $EXTERNAL"
    i3-msg "workspace 2; move workspace to output $EXTERNAL"
    i3-msg "workspace 3; move workspace to output $EXTERNAL"
fi

# focus on the terminal
i3-msg 'workspace number 2'

# relaunch polybar
~/.config/polybar/launch.sh &
