#!/bin/bash
WALL_CACHE="$HOME/.cache/hyprdots-wallpaper"
DEFAULT="$HOME/Pictures/wallpaper/default.jpg"
swww-daemon &
sleep 0.5
if [[ -f "$WALL_CACHE" && -f "$(cat "$WALL_CACHE")" ]]; then
    swww img "$(cat "$WALL_CACHE")" --transition-type wipe --transition-duration 1.5
elif [[ -f "$DEFAULT" ]]; then
    swww img "$DEFAULT" --transition-type wipe --transition-duration 1.5
fi
