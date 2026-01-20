#!/bin/bash

PLAYER="spotify"
STATUS=$(playerctl --player=$PLAYER status 2>/dev/null)

if [ "$STATUS" = "Playing" ]; then
    echo "󰏤"
elif [ "$STATUS" = "Paused" ]; then
    echo "󰐊"
else
    echo "󰐊"
fi
