#!/bin/bash
# ── Phase 3: Drop Configs ─────────────────────────────────────
source "$SCRIPT_DIR/scripts/lib.sh"

log_section "Deploying Configs"

CONFIG_SRC="$SCRIPT_DIR/configs"
CONFIG_DST="$HOME/.config"

# Ensure dirs exist
mkdir -p \
    "$CONFIG_DST/hypr/scripts" \
    "$CONFIG_DST/waybar/scripts" \
    "$CONFIG_DST/waybar/colors" \
    "$CONFIG_DST/rofi/launchers" \
    "$CONFIG_DST/ghostty" \
    "$CONFIG_DST/kitty" \
    "$CONFIG_DST/swaync" \
    "$CONFIG_DST/matugen/templates" \
    "$HOME/Pictures/Screenshots" \
    "$HOME/Pictures/wallpaper/hypridle" \
    "$HOME/Videos/Screencasts"

# ── Deploy function ───────────────────────────────────────────
deploy() {
    local src="$1"
    local dst="$2"
    if [[ -f "$src" ]]; then
        cp "$src" "$dst"
        log_ok "Deployed: $dst"
    elif [[ -d "$src" ]]; then
        cp -r "$src/." "$dst/"
        log_ok "Deployed dir: $dst"
    else
        log_warn "Source not found, skipping: $src"
    fi
}

# Replace hardcoded username with actual user
sed_user() {
    local file="$1"
    sed -i "s|/home/pryan|$HOME|g" "$file"
}

# ── Hyprland ──────────────────────────────────────────────────
log_info "Deploying Hyprland configs..."
deploy "$CONFIG_SRC/hypr/hyprland.conf"   "$CONFIG_DST/hypr/hyprland.conf"
deploy "$CONFIG_SRC/hypr/hypridle.conf"   "$CONFIG_DST/hypr/hypridle.conf"
deploy "$CONFIG_SRC/hypr/hyprlock.conf"   "$CONFIG_DST/hypr/hyprlock.conf"
deploy "$CONFIG_SRC/hypr/monitors.conf"   "$CONFIG_DST/hypr/monitors.conf"
deploy "$CONFIG_SRC/hypr/workspaces.conf" "$CONFIG_DST/hypr/workspaces.conf"
deploy "$CONFIG_SRC/hypr/env.conf"        "$CONFIG_DST/hypr/env.conf"  # written by gpu script
deploy "$CONFIG_SRC/hypr/scripts"         "$CONFIG_DST/hypr/scripts"
sed_user "$CONFIG_DST/hypr/hyprlock.conf"
sed_user "$CONFIG_DST/hypr/hypridle.conf"
chmod +x "$CONFIG_DST/hypr/scripts/"* 2>/dev/null || true

# ── Waybar ────────────────────────────────────────────────────
log_info "Deploying Waybar configs..."
deploy "$CONFIG_SRC/waybar/config.jsonc"    "$CONFIG_DST/waybar/config.jsonc"
deploy "$CONFIG_SRC/waybar/style.css"       "$CONFIG_DST/waybar/style.css"
deploy "$CONFIG_SRC/waybar/colors.css"      "$CONFIG_DST/waybar/colors.css"
deploy "$CONFIG_SRC/waybar/colors"          "$CONFIG_DST/waybar/colors"
deploy "$CONFIG_SRC/waybar/scripts"         "$CONFIG_DST/waybar/scripts"
chmod +x "$CONFIG_DST/waybar/scripts/"*

# ── Rofi ──────────────────────────────────────────────────────
log_info "Deploying Rofi configs..."
deploy "$CONFIG_SRC/rofi" "$CONFIG_DST/rofi"
find "$CONFIG_DST/rofi" -name "*.sh" -exec chmod +x {} \;

# ── Ghostty ───────────────────────────────────────────────────
log_info "Deploying Ghostty config..."
deploy "$CONFIG_SRC/ghostty/config" "$CONFIG_DST/ghostty/config"
deploy "$CONFIG_SRC/ghostty/theme"  "$CONFIG_DST/ghostty/theme"

# ── Kitty ─────────────────────────────────────────────────────
log_info "Deploying Kitty config..."
deploy "$CONFIG_SRC/kitty/kitty.conf"          "$CONFIG_DST/kitty/kitty.conf"
deploy "$CONFIG_SRC/kitty/current-theme.conf"  "$CONFIG_DST/kitty/current-theme.conf"

# ── Swaync ────────────────────────────────────────────────────
log_info "Deploying Swaync config..."
deploy "$CONFIG_SRC/swaync" "$CONFIG_DST/swaync"

# ── Matugen templates ─────────────────────────────────────────
log_info "Deploying Matugen templates..."
deploy "$CONFIG_SRC/matugen" "$CONFIG_DST/matugen"
sed_user "$CONFIG_DST/matugen/config.toml" 2>/dev/null || true

log_ok "All configs deployed"
