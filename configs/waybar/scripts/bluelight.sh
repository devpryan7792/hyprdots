#!/usr/bin/env bash
STATE_FILE="${XDG_RUNTIME_DIR:-/tmp}/bluelight_state"
current=$(cat "$STATE_FILE" 2>/dev/null || echo "off")
case "$current" in
    off)   next="3500"; hyprctl hyprsunset temperature 3500 ;;
    3500)  next="4500"; hyprctl hyprsunset temperature 4500 ;;
    4500)  next="2700"; hyprctl hyprsunset temperature 2700 ;;
    2700)  next="off";  hyprctl hyprsunset identity ;;
esac
echo "$next" > "$STATE_FILE"
pkill -SIGRTMIN+8 waybar
