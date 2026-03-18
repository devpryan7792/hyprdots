#!/bin/bash
# ── Phase 0: Pre-flight checks ───────────────────────────────
source "$SCRIPT_DIR/scripts/lib.sh"

log_section "Pre-flight Checks"

# Must be on Arch
if [[ ! -f /etc/arch-release ]]; then
    log_error "This is not an Arch Linux system. Exiting."
    exit 1
fi
log_ok "Arch Linux detected"

# Must not be root
if [[ "$EUID" -eq 0 ]]; then
    log_error "Do not run as root. Run as your normal user."
    exit 1
fi
log_ok "Running as user: $USER"

# Internet check
if ! ping -c1 -W3 archlinux.org &>/dev/null; then
    log_error "No internet connection. Please connect and retry."
    exit 1
fi
log_ok "Internet connection OK"

# Install paru if missing
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

# Backup existing configs
BACKUP_DIR="$HOME/.config-backup-$(date +%Y%m%d-%H%M%S)"
if ask "Backup existing ~/.config to $BACKUP_DIR before installing?"; then
    mkdir -p "$BACKUP_DIR"
    for d in hypr waybar rofi ghostty kitty swaync; do
        [[ -d "$HOME/.config/$d" ]] && cp -r "$HOME/.config/$d" "$BACKUP_DIR/"
    done
    log_ok "Backup saved to $BACKUP_DIR"
else
    log_warn "Skipping backup — existing configs may be overwritten"
fi

log_ok "All pre-flight checks passed"
