#!/bin/sh

# Find the Wi-Fi interface dynamically (not always en0)
WIFI_IF=$(networksetup -listallhardwareports \
    | awk '/Wi-Fi|AirPort/{getline; print $2; exit}')
[ -z "$WIFI_IF" ] && WIFI_IF="en0"

# macOS 26+ redacts SSIDs from CLI tools; check connectivity via IP instead
IP=$(ipconfig getifaddr "$WIFI_IF" 2>/dev/null)

if [ -n "$IP" ]; then
    ICON="󰖩"
    LABEL="$IP"
else
    ICON="󰖪"
    LABEL="Off"
fi

sketchybar --set "$NAME" icon="$ICON" label="$LABEL"
