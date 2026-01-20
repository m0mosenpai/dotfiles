#!/bin/bash

# WiFi menu for wofi - scans networks and connects via nmcli

notify-send "WiFi" "Scanning networks..." -t 2000

# Get list of available WiFi networks
networks=$(nmcli -t -f SSID,SECURITY,SIGNAL device wifi list | grep -v "^--" | sort -t':' -k3 -rn | uniq)

if [ -z "$networks" ]; then
    notify-send "WiFi" "No networks found"
    exit 1
fi

# Format for wofi display
formatted=""
while IFS=':' read -r ssid security signal; do
    [ -z "$ssid" ] && continue

    # Signal strength icon
    if [ "$signal" -ge 75 ]; then
        icon="󰤨"
    elif [ "$signal" -ge 50 ]; then
        icon="󰤥"
    elif [ "$signal" -ge 25 ]; then
        icon="󰤢"
    else
        icon="󰤟"
    fi

    # Security indicator
    if [ -n "$security" ] && [ "$security" != "--" ]; then
        lock="󰌾"
    else
        lock=""
    fi

    formatted+="$icon $ssid $lock\n"
done <<< "$networks"

# Add options
formatted+="󰤭 Disconnect\n"
formatted+="󰑓 Rescan\n"

# Show wofi menu
chosen=$(echo -e "$formatted" | wofi --dmenu --prompt "WiFi" --width 300 --height 400)

[ -z "$chosen" ] && exit 0

# Handle selection
case "$chosen" in
    "󰤭 Disconnect")
        nmcli device disconnect wlan0 2>/dev/null || nmcli device disconnect wlp0s20f3 2>/dev/null
        notify-send "WiFi" "Disconnected"
        ;;
    "󰑓 Rescan")
        exec "$0"
        ;;
    *)
        # Extract SSID (remove icon and lock)
        ssid=$(echo "$chosen" | sed 's/^󰤨 \|^󰤥 \|^󰤢 \|^󰤟 //' | sed 's/ 󰌾$//')

        # Check if already a known network
        if nmcli connection show "$ssid" &>/dev/null; then
            nmcli connection up "$ssid"
            notify-send "WiFi" "Connected to $ssid"
        else
            # Need password - prompt with wofi
            password=$(echo "" | wofi --dmenu --prompt "Password for $ssid" --password --width 300)

            if [ -n "$password" ]; then
                if nmcli device wifi connect "$ssid" password "$password"; then
                    notify-send "WiFi" "Connected to $ssid"
                else
                    notify-send "WiFi" "Failed to connect to $ssid" -u critical
                fi
            fi
        fi
        ;;
esac
