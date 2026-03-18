#!/usr/bin/env bash
# hyprdots-wallpaper — pick wallpaper and optionally apply matugen
WALL_DIR="$HOME/.local/share/wallpapers"
CHOSEN=$(find "$WALL_DIR" -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.jpeg" \) | \
    wofi --dmenu --prompt "Wallpaper" --lines 10)
[[ -z "$CHOSEN" ]] && exit 0
swww img "$CHOSEN" --transition-type fade --transition-duration 1
read -rp "Apply Matugen colors from this wallpaper? [y/N]: " apply_mat
[[ "$apply_mat" =~ ^[Yy]$ ]] && hyprdots-theme --matugen "$CHOSEN"
