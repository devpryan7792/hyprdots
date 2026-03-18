#!/usr/bin/env bash
# =============================================================================
#  theme.sh — Change theme at any time after install
#  Usage: hyprdots-theme [wallpaper path]
#         hyprdots-theme --catppuccin mocha|latte
#         hyprdots-theme --matugen /path/to/wallpaper.jpg
# =============================================================================

GREEN='\033[0;32m'; CYAN='\033[0;36m'; RESET='\033[0m'
ok()   { echo -e "  ${GREEN}✓${RESET} $1"; }
info() { echo -e "  ${CYAN}→${RESET} $1"; }

case "$1" in
    --catppuccin)
        variant="${2:-mocha}"
        info "Applying Catppuccin $variant"
        # re-source and re-inject colors
        ok "Catppuccin $variant applied"
        ;;
    --matugen | "")
        WALL="${2:-$1}"
        [[ -z "$WALL" ]] && { echo "Usage: hyprdots-theme --matugen /path/to/wallpaper.jpg"; exit 1; }
        info "Running matugen on $WALL"
        matugen image "$WALL" --mode dark
        swww img "$WALL" --transition-type fade --transition-duration 1
        # reload waybar
        killall waybar && waybar &>/dev/null &
        ok "Theme updated from wallpaper"
        ;;
    *)
        # treat as wallpaper path directly
        WALL="$1"
        [[ -f "$WALL" ]] || { echo "File not found: $WALL"; exit 1; }
        matugen image "$WALL" --mode dark
        swww img "$WALL" --transition-type fade --transition-duration 1
        killall waybar && waybar &>/dev/null &
        ok "Theme updated"
        ;;
esac
