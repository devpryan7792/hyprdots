#!/bin/bash
# ── Shared helpers for all hyprdots scripts ──────────────────

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

log_info()    { echo -e "${CYAN}[  INFO ]${RESET} $*"; }
log_ok()      { echo -e "${GREEN}[    OK ]${RESET} $*"; }
log_warn()    { echo -e "${YELLOW}[  WARN ]${RESET} $*"; }
log_error()   { echo -e "${RED}[ ERROR ]${RESET} $*"; }
log_section() { echo -e "\n${BOLD}${BLUE}══ $* ══${RESET}\n"; }

# Ask yes/no — returns 0 for yes, 1 for no
ask() {
    local prompt="$1"
    local default="${2:-y}"
    local yn
    if [[ "$default" == "y" ]]; then
        read -rp "$(echo -e "${YELLOW}[  ASK  ]${RESET} $prompt [Y/n]: ")" yn
        [[ -z "$yn" || "$yn" =~ ^[Yy]$ ]]
    else
        read -rp "$(echo -e "${YELLOW}[  ASK  ]${RESET} $prompt [y/N]: ")" yn
        [[ "$yn" =~ ^[Yy]$ ]]
    fi
}

# Install packages via paru — skips already installed ones
install_pkgs() {
    local pkgs=("$@")
    local to_install=()
    for pkg in "${pkgs[@]}"; do
        if ! pacman -Qi "$pkg" &>/dev/null; then
            to_install+=("$pkg")
        else
            log_info "Already installed: $pkg"
        fi
    done
    if [[ ${#to_install[@]} -gt 0 ]]; then
        paru -S --needed --noconfirm "${to_install[@]}"
    fi
}

export RED GREEN YELLOW BLUE CYAN BOLD RESET
export -f log_info log_ok log_warn log_error log_section ask install_pkgs
