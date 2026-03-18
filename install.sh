#!/bin/bash
# ╔══════════════════════════════════════════════════════════╗
# ║           hyprdots — by pryan                           ║
# ║     Hyprland dotfiles installer for Arch Linux          ║
# ╚══════════════════════════════════════════════════════════╝

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export SCRIPT_DIR
source "$SCRIPT_DIR/scripts/lib.sh"

print_banner() {
    echo -e "${BOLD}${BLUE}"
    cat << 'EOF'
 _                         _       _       
| |__  _   _ _ __  _ __ __| | ___ | |_ ___ 
| '_ \| | | | '_ \| '__/ _` |/ _ \| __/ __|
| | | | |_| | |_) | | | (_| | (_) | |_\__ \
|_| |_|\__, | .__/|_|  \__,_|\___/ \__|___/
        |___/|_|         by pryan
EOF
    echo -e "${RESET}"
}

main() {
    print_banner
    log_info "Starting hyprdots installation..."
    echo ""

    bash "$SCRIPT_DIR/scripts/00-check.sh"
    bash "$SCRIPT_DIR/scripts/01-packages.sh"
    bash "$SCRIPT_DIR/scripts/02-gpu.sh"
    bash "$SCRIPT_DIR/scripts/03-configs.sh"
    bash "$SCRIPT_DIR/scripts/04-theme.sh"
    bash "$SCRIPT_DIR/scripts/05-finish.sh"
}

main "$@"
