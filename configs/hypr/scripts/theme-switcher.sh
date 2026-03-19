#!/bin/bash
WALL_DIR="$HOME/Pictures/wallpaper"
WALL_CACHE="$HOME/.cache/hyprdots-wallpaper"
THUMB_DIR="$HOME/.cache/hyprdots-thumbs"

mkdir -p "$THUMB_DIR"

# Step 1: Generate thumbnails in parallel (much faster)
find "$WALL_DIR" -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) | while read -r img; do
    name=$(basename "$img")
    thumb="$THUMB_DIR/$name.png"
    if [[ ! -f "$thumb" || "$img" -nt "$thumb" ]]; then
        # Run conversion in background to speed up startup
        convert "$img" -thumbnail 300x200^ -gravity center -extent 300x200 "$thumb" 2>/dev/null &
    fi
done
wait # Wait for all thumbnails to finish

# Step 2: Launch Rofi with the grid layout
if [[ -z "$1" ]]; then
    WALL=$(find "$WALL_DIR" -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) \
        | while read -r img; do
            name=$(basename "$img")
            thumb="$THUMB_DIR/$name.png"
            echo -en "$name\0icon\x1f$thumb\n"
          done \
        | rofi -dmenu \
               -p " Wallpaper" \
               -show-icons \
               -theme-str 'listview { columns: 3; lines: 3; } element { orientation: vertical; }' \
               -theme ~/.config/rofi/wallpaper.rasi)

    [[ -z "$WALL" ]] && exit 0
    WALL="$WALL_DIR/$WALL"
else
    WALL="$1"
fi

[[ ! -f "$WALL" ]] && exit 1

# Step 3: Apply changes
swww img "$WALL" --transition-type wipe --transition-angle 30 --transition-duration 1 --transition-fps 60
echo "$WALL" > "$WALL_CACHE"
matugen image "$WALL" -c ~/.config/matugen/config.toml
hyprctl reload
pkill waybar 2>/dev/null; sleep 0.3; waybar &
pkill swaync 2>/dev/null; sleep 0.2; swaync &
echo "Done — $(basename "$WALL")"