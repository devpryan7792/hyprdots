#!/bin/bash
# ── Phase 0: Pre-flight checks ───────────────────────────────
source "$SCRIPT_DIR/scripts/lib.sh"

log_section "Pre-flight Checks"

if [[ ! -f /etc/arch-release ]]; then
    log_error "This is not an Arch Linux system. Exiting."
    exit 1
fi
log_ok "Arch Linux detected"

if [[ "$EUID" -eq 0 ]]; then
    log_error "Do not run as root. Run as your normal user."
    exit 1
fi
log_ok "Running as user: $USER"

if ! ping -c1 -W3 archlinux.org &>/dev/null; then
    log_error "No internet connection. Please connect and retry."
    exit 1
fi
log_ok "Internet connection OK"

if ! command -v paru &>/dev/null; then
    log_warn "paru not found — installing it now..."
    sudo pacman -S --needed --noconfirm base-devel git
    git clone https://aur.archlinux.org/paru.git /tmp/paru-build
    (cd /tmp/paru-build && makepkg -si --noconfirm)
    rm -rf /tmp/paru-build
    log_ok "paru installed"
else
    log_ok "paru found: $(paru --version | head -1)"
fi

BACKUP_DIR="$HOME/.config/hyprdots-backup"
MANIFEST="$BACKUP_DIR/manifest.txt"

HYPRLAND_EXISTS=false
command -v hyprland &>/dev/null && HYPRLAND_EXISTS=true

EXISTING_CONFIGS=()
for d in hypr waybar rofi ghostty kitty swaync; do
    [[ -d "$HOME/.config/$d" ]] && EXISTING_CONFIGS+=("$d")
done

if [[ ${#EXISTING_CONFIGS[@]} -gt 0 ]] || $HYPRLAND_EXISTS; then
    echo ""
    $HYPRLAND_EXISTS && log_warn "Hyprland is already installed on this system"
    [[ ${#EXISTING_CONFIGS[@]} -gt 0 ]] && log_warn "Existing configs found: ${EXISTING_CONFIGS[*]}"
    echo ""

    if ask "Backup existing configs before installing? (recommended)"; then
        mkdir -p "$BACKUP_DIR"
        > "$MANIFEST"
        for d in "${EXISTING_CONFIGS[@]}"; do
            cp -r "$HOME/.config/$d" "$BACKUP_DIR/$d"
            echo "$d" >> "$MANIFEST"
            log_ok "Backed up: ~/.config/$d"
        done
        $HYPRLAND_EXISTS && echo "__hyprland_preinstalled__" >> "$MANIFEST"
        log_ok "Backup saved to $BACKUP_DIR"
        log_info "Run ./uninstall.sh anytime to restore your original setup"
    else
        log_warn "Skipping backup — existing configs will be overwritten"
    fi
else
    log_info "No existing Hyprland configs found — fresh install"
fi

log_ok "All pre-flight checks passed"
