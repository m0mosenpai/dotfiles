#!/bin/bash

trap '' PIPE

SCRIPT=$HOME/.config/waybar/scripts/get_spotify_status.sh

zscroll -l 30 \
        --delay 0.1 \
        -u 2 \
        --scroll-padding "  " \
        --match-command "$SCRIPT --status" \
        --match-text "Playing" "--scroll 1" \
        --match-text "Paused" "--scroll 0" \
        --update-check true "$SCRIPT" 2>/dev/null &

wait
