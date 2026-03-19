#!/bin/bash
STATE="$HOME/.cache/waybar-tray-state"
current=$(cat "$STATE" 2>/dev/null || echo "hidden")

if [[ "$current" == "hidden" ]]; then
    echo "visible" > "$STATE"
    sed -i 's|"battery", "custom/notification", "custom/power"|"battery", "custom/notification", "tray", "custom/power"|' ~/.config/waybar/config.jsonc
else
    echo "hidden" > "$STATE"
    sed -i 's|"battery", "custom/notification", "tray", "custom/power"|"battery", "custom/notification", "custom/power"|' ~/.config/waybar/config.jsonc
fi

pkill waybar; sleep 0.2; waybar &
