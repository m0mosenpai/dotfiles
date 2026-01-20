#!/bin/bash

# Audio device selector for wofi - handles input and output devices via wpctl/pactl

MODE="$1"  # "input" or "output"

if [ "$MODE" = "input" ]; then
    TITLE="Input Device"
    ICON_ACTIVE="󰍬"
    ICON_INACTIVE="󰍭"
    DEVICE_TYPE="Source"
    WPCTL_TYPE="@DEFAULT_AUDIO_SOURCE@"
else
    TITLE="Output Device"
    ICON_ACTIVE="󰕾"
    ICON_INACTIVE="󰖁"
    DEVICE_TYPE="Sink"
    WPCTL_TYPE="@DEFAULT_AUDIO_SINK@"
fi

# Get list of devices using pactl
# Format: index, name, description, active
get_devices() {
    if [ "$MODE" = "input" ]; then
        pactl list sources short | while read -r index name _; do
            # Skip monitors (output device monitors)
            if echo "$name" | grep -q "monitor"; then
                continue
            fi
            desc=$(pactl list sources | grep -A 20 "Name: $name" | grep "Description:" | head -1 | cut -d':' -f2- | xargs)
            default=$(pactl get-default-source)
            if [ "$name" = "$default" ]; then
                echo "$ICON_ACTIVE $desc|$name"
            else
                echo "$ICON_INACTIVE $desc|$name"
            fi
        done
    else
        pactl list sinks short | while read -r index name _; do
            desc=$(pactl list sinks | grep -A 20 "Name: $name" | grep "Description:" | head -1 | cut -d':' -f2- | xargs)
            default=$(pactl get-default-sink)
            if [ "$name" = "$default" ]; then
                echo "$ICON_ACTIVE $desc|$name"
            else
                echo "$ICON_INACTIVE $desc|$name"
            fi
        done
    fi
}

# Build device list
devices=$(get_devices)

if [ -z "$devices" ]; then
    notify-send "Audio" "No ${MODE} devices found"
    exit 1
fi

# Show wofi menu (display only the description part)
chosen=$(echo "$devices" | cut -d'|' -f1 | wofi --dmenu --prompt "$TITLE" --width 400 --height 300)

[ -z "$chosen" ] && exit 0

# Find the device name for the chosen description
chosen_desc=$(echo "$chosen" | sed "s/^$ICON_ACTIVE \|^$ICON_INACTIVE //")
device_name=$(echo "$devices" | grep "$chosen_desc" | cut -d'|' -f2)

if [ -n "$device_name" ]; then
    if [ "$MODE" = "input" ]; then
        pactl set-default-source "$device_name"
        notify-send "Audio Input" "Switched to: $chosen_desc"
    else
        pactl set-default-sink "$device_name"
        notify-send "Audio Output" "Switched to: $chosen_desc"
    fi
fi
