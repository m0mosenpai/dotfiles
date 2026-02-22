#!/bin/bash

# Bluetooth menu for wofi - manages bluetooth devices via bluetoothctl

# Helper to run bluetoothctl commands (piped for non-interactive mode)
btctl() {
    echo "$1" | bluetoothctl 2>/dev/null
}

# Check if bluetooth is powered on
power_status=$(btctl "show" | grep "Powered:" | awk '{print $2}')

# Build menu options
options=""

if [ "$power_status" = "yes" ]; then
    options+="<span size='large'>󰂲</span>  Power Off\n"
    options+="<span size='x-large'>󰑓</span>  Scan for devices\n"
    options+="───────────────\n"

    # Get paired devices
    paired=$(btctl "devices Paired" | grep "^Device" | sed 's/^Device //')

    if [ -n "$paired" ]; then
        while read -r line; do
            mac=$(echo "$line" | awk '{print $1}')
            name=$(echo "$line" | cut -d' ' -f2-)

            # Check if connected
            info=$(btctl "info $mac")
            if echo "$info" | grep -q "Connected: yes"; then
                options+="<span size='x-large'>󰂱</span>  $name (connected)\n"
            else
                options+="<span size='large'>󰂯</span>  $name\n"
            fi
        done <<< "$paired"
    else
        options+="No paired devices\n"
    fi
else
    options+="<span size='large'>󰂯</span>  Power On\n"
fi

# Show wofi menu
chosen=$(echo -e "$options" | wofi --dmenu --prompt "Bluetooth" --width 300 --height 400 --hide-search --location=3 --xoffset=-80 --yoffset=4 --style ~/.config/wofi/waybar-style.css --allow-markup)

[ -z "$chosen" ] && exit 0

# Handle selection
case "$chosen" in
    *"Power Off"*)
        btctl "power off"
        notify-send "Bluetooth" "Powered off"
        ;;
    *"Power On"*)
        btctl "power on"
        notify-send "Bluetooth" "Powered on"
        ;;
    *"Scan for devices"*)
        notify-send "Bluetooth" "Scanning for 10 seconds..."

        bluetoothctl --timeout 10 scan on &>/dev/null &
        sleep 10

        # Get all discovered devices
        devices=$(btctl "devices" | grep "^Device" | sed 's/^Device //')

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
            bluetoothctl pair "$mac" && \
            bluetoothctl trust "$mac" && \
            bluetoothctl connect "$mac" && \
            notify-send "Bluetooth" "Connected to $selected" || \
            notify-send "Bluetooth" "Failed to connect to $selected" -u critical
        fi
        ;;
    "───────────────"|"No paired devices")
        ;;
    *)
        # Device selected - toggle connection
        name=$(echo "$chosen" | sed 's/^[^ ]* *//' | sed 's/ (connected)$//')

        # Find MAC address
        mac=$(btctl "devices Paired" | grep "$name" | awk '{print $2}')

        if [ -z "$mac" ]; then
            notify-send "Bluetooth" "Device not found"
            exit 1
        fi

        if echo "$chosen" | grep -q "(connected)"; then
            bluetoothctl disconnect "$mac"
            notify-send "Bluetooth" "Disconnected from $name"
        else
            notify-send "Bluetooth" "Connecting to $name..."
            if bluetoothctl connect "$mac"; then
                notify-send "Bluetooth" "Connected to $name"
            else
                notify-send "Bluetooth" "Failed to connect to $name" -u critical
            fi
        fi
        ;;
esac
