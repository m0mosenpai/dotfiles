#!/bin/bash

sleep 1

# Move apps to their assigned workspaces
hyprctl dispatch movetoworkspacesilent 1,class:^(firefox)$
hyprctl dispatch movetoworkspacesilent 1,class:^(Firefox)$
hyprctl dispatch movetoworkspacesilent 2,class:^(ghostty)$
hyprctl dispatch movetoworkspacesilent 2,class:^(Alacritty)$

# Check if an external monitor is connected
EXTERNAL=$(hyprctl monitors -j | jq -r '.[] | select(.name != "eDP-1") | .name' | head -n1)

# Move primary workspaces to external monitor
if [ -n "$EXTERNAL" ]; then
    hyprctl dispatch moveworkspacetomonitor 1 "$EXTERNAL"
    hyprctl dispatch moveworkspacetomonitor 2 "$EXTERNAL"
    hyprctl dispatch moveworkspacetomonitor 3 "$EXTERNAL"
fi

# Focus on terminal workspace
hyprctl dispatch workspace 2
