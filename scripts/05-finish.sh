#!/bin/bash
# ── Phase 5: Final Setup ──────────────────────────────────────
source "$SCRIPT_DIR/scripts/lib.sh"

log_section "Final Setup"

# Enable services
log_info "Enabling system services..."
systemctl --user enable --now pipewire pipewire-pulse wireplumber 2>/dev/null || true
log_ok "Audio services enabled"

# Ensure PATH has ~/.local/bin
ZSHRC="$HOME/.zshrc"
if [[ -f "$ZSHRC" ]] && ! grep -q ".local/bin" "$ZSHRC"; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$ZSHRC"
    log_ok "Added ~/.local/bin to PATH in .zshrc"
fi

# Print keybind cheatsheet
echo ""
echo -e "${BOLD}${CYAN}══ Keybinds Cheatsheet ══════════════════════════════${RESET}"
echo -e "  ${BOLD}SUPER + Q${RESET}          → Open terminal (ghostty)"
echo -e "  ${BOLD}SUPER + SPACE${RESET}      → Rofi launcher"
echo -e "  ${BOLD}SUPER + B${RESET}          → Firefox"
echo -e "  ${BOLD}SUPER + SHIFT+B${RESET}    → Brave"
echo -e "  ${BOLD}SUPER + E${RESET}          → File manager (thunar)"
echo -e "  ${BOLD}SUPER + W${RESET}          → Set wallpaper (wallset)"
echo -e "  ${BOLD}SUPER + L${RESET}          → Logout menu (wlogout)"
echo -e "  ${BOLD}SUPER + SHIFT+L${RESET}    → Lock screen (hyprlock)"
echo -e "  ${BOLD}SUPER + V${RESET}          → Clipboard history"
echo -e "  ${BOLD}SUPER + T${RESET}          → Toggle float"
echo -e "  ${BOLD}SUPER + F4${RESET}         → Kill window"
echo -e "  ${BOLD}Print${RESET}              → Screenshot region"
echo -e "  ${BOLD}SHIFT+Print${RESET}        → Screenshot window"
echo -e "  ${BOLD}SUPER+SHIFT+R${RESET}      → Record screen region"
echo -e "  ${BOLD}SUPER + 1-9${RESET}        → Switch workspace"
echo -e "${CYAN}═════════════════════════════════════════════════════${RESET}"
echo ""

echo -e "${GREEN}${BOLD}"
echo "  ✓ hyprdots installation complete!"
echo "  → Set your wallpaper: wallset"
echo "  → Reload hyprland: hyprctl reload"
echo -e "${RESET}"

if ask "Reboot now? (recommended)"; then
    log_info "Rebooting in 3 seconds..."
    sleep 3
    reboot
else
    log_warn "Remember to reboot or re-login for all changes to take effect"
fi
