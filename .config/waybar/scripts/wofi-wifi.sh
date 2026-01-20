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
        icon="<span size='x-large'>󰤨</span>"
    elif [ "$signal" -ge 50 ]; then
        icon="<span size='x-large'>󰤥</span>"
    elif [ "$signal" -ge 25 ]; then
        icon="<span size='x-large'>󰤢</span>"
    else
        icon="<span size='x-large'>󰤟</span>"
    fi

    # Security indicator
    if [ -n "$security" ] && [ "$security" != "--" ]; then
        lock="<span size='small'>󰌾</span>"
    else
        lock=""
    fi

    formatted+="$icon $ssid $lock\n"
done <<< "$networks"

# Add options
formatted+="<span size='x-large'>󰤭</span> Disconnect\n"
formatted+="<span size='x-large'>󰑓</span> Rescan\n"

# Show wofi menu
chosen=$(echo -e "$formatted" | wofi --dmenu --prompt "WiFi" --width 300 --height 400 --hide-search --location=3 --xoffset=-80 --yoffset=4 --style ~/.config/wofi/waybar-style.css --allow-markup)

[ -z "$chosen" ] && exit 0

# Handle selection
case "$chosen" in
    *"Disconnect"*)
        nmcli device disconnect wlan0 2>/dev/null || nmcli device disconnect wlp0s20f3 2>/dev/null
        notify-send "WiFi" "Disconnected"
        ;;
    *"Rescan"*)
        exec "$0"
        ;;
    *)
        # Extract SSID (remove icon spans and lock)
        ssid=$(echo "$chosen" | sed "s/<span[^>]*>[^<]*<\/span> //g" | sed "s/ <span[^>]*>[^<]*<\/span>$//")

        # Check if already a known network
        if nmcli connection show "$ssid" &>/dev/null; then
            nmcli connection up "$ssid"
            notify-send "WiFi" "Connected to $ssid"
        else
            # Need password - prompt with zenity
            password=$(zenity --password --title="WiFi Password" --text="Enter password for $ssid")

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
