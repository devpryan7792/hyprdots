#!/bin/bash
# theme-switcher.sh — wallpaper + full matugen theme reload

WALL_DIR="$HOME/Pictures/wallpaper"
WALL_CACHE="$HOME/.cache/hyprdots-wallpaper"

# Pick wallpaper
if [[ -n "$1" && -f "$1" ]]; then
    WALL="$1"
else
    WALL=$(find "$WALL_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) | rofi -dmenu -i -p "Wallpaper")
fi

[[ -z "$WALL" ]] && exit 0

# Set wallpaper
swww img "$WALL" \
    --transition-type wipe \
    --transition-angle 30 \
    --transition-duration 1 \
    --transition-fps 60

echo "$WALL" > "$WALL_CACHE"

# Generate colors
matugen image "$WALL" -c ~/.config/matugen/config.toml

# Reload everything
hyprctl reload
pkill waybar 2>/dev/null; sleep 0.3; waybar &
pkill swaync 2>/dev/null; sleep 0.2; swaync &

echo "Done — theme updated from: $WALL"
