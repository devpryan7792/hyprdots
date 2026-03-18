#!/usr/bin/env bash
# Usage: hyprdots-screenshot [region|full|window]
SAVE_DIR="$HOME/Pictures/Screenshots"
mkdir -p "$SAVE_DIR"
TIMESTAMP=$(date +%Y-%m-%d_%H-%M-%S)
FILE="$SAVE_DIR/screenshot-$TIMESTAMP.png"

case "${1:-region}" in
    region)  grim -g "$(slurp)" "$FILE" ;;
    full)    grim "$FILE" ;;
    window)  grim -g "$(hyprctl activewindow -j | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"')" "$FILE" ;;
esac

[[ -f "$FILE" ]] && {
    wl-copy < "$FILE"
    notify-send "Screenshot saved" "$FILE" -i "$FILE" -t 3000
}
