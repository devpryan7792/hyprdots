#!/bin/bash
# ── Phase 4: Theme Setup ──────────────────────────────────────
source "$SCRIPT_DIR/scripts/lib.sh"

log_section "Theme Setup"

WALLPAPER_DIR="$HOME/Pictures/wallpaper"
DEFAULT_WALL="$SCRIPT_DIR/assets/default.jpg"

# Copy default wallpaper
mkdir -p "$WALLPAPER_DIR/hypridle"
if [[ -f "$DEFAULT_WALL" ]]; then
    cp "$DEFAULT_WALL" "$WALLPAPER_DIR/default.jpg"
    cp "$DEFAULT_WALL" "$WALLPAPER_DIR/hypridle/back.jpg"
    log_ok "Default wallpaper copied"
else
    log_warn "No default wallpaper found in assets/ — you'll need to set one manually"
fi

# ── GTK theme (catppuccin mocha fallback) ─────────────────────
if ask "Install Catppuccin GTK theme as fallback?"; then
    install_pkgs catppuccin-gtk-theme-mocha papirus-icon-theme
    mkdir -p "$HOME/.config/gtk-3.0" "$HOME/.config/gtk-4.0"

    cat > "$HOME/.config/gtk-3.0/settings.ini" << GTKEOF
[Settings]
gtk-theme-name=catppuccin-mocha-blue-standard
gtk-icon-theme-name=Papirus-Dark
gtk-font-name=JetBrains Mono Nerd Font 11
gtk-cursor-theme-name=Adwaita
gtk-cursor-theme-size=24
GTKEOF

    cp "$HOME/.config/gtk-3.0/settings.ini" "$HOME/.config/gtk-4.0/settings.ini"
    log_ok "GTK Catppuccin theme applied"
fi

# ── Matugen wallpaper script ──────────────────────────────────
cat > "$HOME/.local/bin/wallset" << 'WALLEOF'
#!/bin/bash
# wallset — set wallpaper and regenerate matugen colors
# Usage: wallset [path/to/image]
#        wallset (opens rofi file picker)

set -e

WALLPAPER_DIR="$HOME/Pictures/wallpaper"

if [[ -n "$1" && -f "$1" ]]; then
    WALL="$1"
else
    # Rofi file picker fallback
    WALL=$(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.jpeg" -o -name "*.webp" \) | \
           rofi -dmenu -i -p "Wallpaper")
fi

[[ -z "$WALL" ]] && { echo "No wallpaper selected."; exit 1; }

echo "Setting wallpaper: $WALL"
swww img "$WALL" \
    --transition-type wipe \
    --transition-angle 30 \
    --transition-duration 1.5

echo "Generating colors with matugen..."
matugen image "$WALL"

# Reload everything
hyprctl reload
pkill -SIGUSR2 waybar   2>/dev/null || true
pkill -SIGUSR1 waybar   2>/dev/null || true
pkill waybar            2>/dev/null || true
sleep 0.3
waybar &

echo "Done! Theme updated."
WALLEOF

mkdir -p "$HOME/.local/bin"
chmod +x "$HOME/.local/bin/wallset"
log_ok "wallset script installed at ~/.local/bin/wallset"
log_info "Make sure ~/.local/bin is in your PATH (add to ~/.zshrc if missing)"

log_ok "Theme setup complete"
