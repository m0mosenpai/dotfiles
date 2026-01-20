#!/bin/bash

# Bluetooth menu for wofi - manages bluetooth devices via bluetoothctl

# Check if bluetooth is powered on
power_status=$(bluetoothctl show | grep "Powered:" | awk '{print $2}')

# Build menu options
options=""

if [ "$power_status" = "yes" ]; then
    options+="󰂲 Power Off\n"
    options+="󰑓 Scan for devices\n"
    options+="───────────────\n"

    # Get paired devices
    paired=$(bluetoothctl devices Paired | cut -d' ' -f2-)

    if [ -n "$paired" ]; then
        while read -r line; do
            mac=$(echo "$line" | awk '{print $1}')
            name=$(echo "$line" | cut -d' ' -f2-)

            # Check if connected
            info=$(bluetoothctl info "$mac" 2>/dev/null)
            if echo "$info" | grep -q "Connected: yes"; then
                options+="󰂱 $name (connected)\n"
            else
                options+="󰂯 $name\n"
            fi
        done <<< "$paired"
    else
        options+="No paired devices\n"
    fi
else
    options+="󰂯 Power On\n"
fi

# Show wofi menu
chosen=$(echo -e "$options" | wofi --dmenu --prompt "Bluetooth" --width 300 --height 400 --hide-search --location=3 --xoffset=-80 --yoffset=4 --style ~/.config/wofi/waybar-style.css)

[ -z "$chosen" ] && exit 0

# Handle selection
case "$chosen" in
    "󰂲 Power Off")
        bluetoothctl power off
        notify-send "Bluetooth" "Powered off"
        ;;
    "󰂯 Power On")
        bluetoothctl power on
        notify-send "Bluetooth" "Powered on"
        ;;
    "󰑓 Scan for devices")
        notify-send "Bluetooth" "Scanning for 10 seconds..."

        # Start scanning
        bluetoothctl --timeout 10 scan on &>/dev/null &

        sleep 10

        # Get all discovered devices
        devices=$(bluetoothctl devices | cut -d' ' -f2-)

        if [ -z "$devices" ]; then
            notify-send "Bluetooth" "No devices found"
            exit 0
        fi

        # Build device list
        device_list=""
        while read -r line; do
            mac=$(echo "$line" | awk '{print $1}')
            name=$(echo "$line" | cut -d' ' -f2-)
            device_list+="$name|$mac\n"
        done <<< "$devices"

        # Show device selection
        selected=$(echo -e "$device_list" | cut -d'|' -f1 | wofi --dmenu --prompt "Select device" --width 300 --height 400 --hide-search --location=3 --xoffset=-80 --yoffset=4 --style ~/.config/wofi/waybar-style.css)

        [ -z "$selected" ] && exit 0

        # Get MAC address for selected device
        mac=$(echo -e "$device_list" | grep "^$selected|" | cut -d'|' -f2)

        if [ -n "$mac" ]; then
            notify-send "Bluetooth" "Pairing with $selected..."

            # Try to pair and connect
            bluetoothctl pair "$mac" && \
            bluetoothctl trust "$mac" && \
            bluetoothctl connect "$mac" && \
            notify-send "Bluetooth" "Connected to $selected" || \
            notify-send "Bluetooth" "Failed to connect to $selected" -u critical
        fi
        ;;
    "───────────────"|"No paired devices")
        # Separator or empty, do nothing
        ;;
    *)
        # Device selected - toggle connection
        # Extract device name
        name=$(echo "$chosen" | sed 's/^󰂱 \|^󰂯 //' | sed 's/ (connected)$//')

        # Find MAC address
        mac=$(bluetoothctl devices Paired | grep "$name" | awk '{print $2}')

        if [ -z "$mac" ]; then
            notify-send "Bluetooth" "Device not found"
            exit 1
        fi

        # Check current connection status
        if echo "$chosen" | grep -q "(connected)"; then
            # Disconnect
            bluetoothctl disconnect "$mac"
            notify-send "Bluetooth" "Disconnected from $name"
        else
            # Connect
            notify-send "Bluetooth" "Connecting to $name..."
            if bluetoothctl connect "$mac"; then
                notify-send "Bluetooth" "Connected to $name"
            else
                notify-send "Bluetooth" "Failed to connect to $name" -u critical
            fi
        fi
        ;;
esac
