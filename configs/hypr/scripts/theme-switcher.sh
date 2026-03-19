#!/bin/bash
# ── theme-switcher.sh — matugen wallpaper + full theme reload ──
# Usage: theme-switcher.sh [path]   → set specific wallpaper
#        theme-switcher.sh          → open rofi picker

WALL_DIR="$HOME/Pictures/wallpaper"
WALL_CACHE="$HOME/.cache/hyprdots-wallpaper"

# ── Pick wallpaper ────────────────────────────────────────────
if [[ -n "$1" && -f "$1" ]]; then
    WALL="$1"
else
    WALL=$(find "$WALL_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) \
        | while read -r f; do echo "$f"; done \
        | rofi -dmenu -i \
               -p "  Wallpaper" \
               -theme ~/.config/rofi/launchers/type-2/style.rasi \
               -theme-str 'window {width: 700px;}')
fi

[[ -z "$WALL" ]] && exit 0

# ── Set wallpaper with swww ───────────────────────────────────
swww img "$WALL" \
    --transition-type wipe \
    --transition-angle 30 \
    --transition-duration 1 \
    --transition-fps 60

echo "$WALL" > "$WALL_CACHE"

# ── Generate colors with matugen ─────────────────────────────
matugen image "$WALL" -c ~/.config/matugen/config.toml

# ── Reload everything ─────────────────────────────────────────

# Hyprland border colors
hyprctl reload

# Waybar
pkill waybar 2>/dev/null; sleep 0.3; waybar &

# Swaync
pkill swaync 2>/dev/null; sleep 0.2; swaync &

# Ghostty — send reload signal if running
pkill -SIGUSR1 ghostty 2>/dev/null || true

# Kitty — reload all windows
for pid in $(pgrep kitty); do
    kill -SIGUSR1 "$pid" 2>/dev/null || true
done

# GTK — reload gtk theme
gsettings set org.gnome.desktop.interface gtk-theme ''
sleep 0.1
gsettings set org.gnome.desktop.interface gtk-theme 'catppuccin-mocha-blue-standard' 2>/dev/null || true

echo "Theme updated from: $WALL"
