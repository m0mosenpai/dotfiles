#!/bin/bash

# Microphone status for Waybar - Nerd Font icons

MUTED=$(wpctl get-volume @DEFAULT_AUDIO_SOURCE@ 2>/dev/null | grep -q MUTED && echo "yes" || echo "no")

if [ "$MUTED" = "yes" ]; then
    echo "<span size='large'>󰍭</span>"
else
    VOLUME=$(wpctl get-volume @DEFAULT_AUDIO_SOURCE@ 2>/dev/null | awk '{printf "%.0f", $2 * 100}')
    echo "<span size='large'>󰍬</span><span> ${VOLUME}%</span>"
fi
