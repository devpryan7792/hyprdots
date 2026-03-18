#!/bin/bash
# ── Phase 1: Package Installation ────────────────────────────
source "$SCRIPT_DIR/scripts/lib.sh"

log_section "Package Installation"

# ── Core — always installed ───────────────────────────────────
CORE_PKGS=(
    hyprland hyprlock hypridle hyprshot hyprsession
    waybar rofi-wayland swaync
    ghostty kitty
    swww
    wlogout wl-clipboard wl-clip-persist cliphist
    matugen
    pipewire pipewire-pulse wireplumber
    brightnessctl
    grim slurp
    thunar
    polkit-kde-agent
    xdg-desktop-portal-hyprland
    qt5-wayland qt6-wayland
    noto-fonts ttf-jetbrains-mono-nerd
    zip unzip
    jq
)

log_info "Installing core packages..."
install_pkgs "${CORE_PKGS[@]}"
log_ok "Core packages installed"

# ── Optional groups ───────────────────────────────────────────

if ask "Install system monitoring tools? (btop, fastfetch, nvtop)"; then
    install_pkgs btop fastfetch nvtop
    log_ok "System monitoring tools installed"
fi

if ask "Install media tools? (playerctl, mpv, imv, ffmpeg)"; then
    install_pkgs playerctl mpv imv ffmpeg
    log_ok "Media tools installed"
fi

if ask "Install screen recording? (wf-recorder, obs-studio)"; then
    install_pkgs wf-recorder
    if ask "Install OBS Studio?"; then
        install_pkgs obs-studio
    fi
    log_ok "Screen recording tools installed"
fi

if ask "Install development tools? (git, neovim, zsh, starship, yazi)"; then
    install_pkgs git neovim zsh starship yazi eza bat fd ripgrep fzf
    log_ok "Dev tools installed"
    if ask "Set zsh as default shell?"; then
        chsh -s "$(which zsh)"
        log_ok "Default shell set to zsh — takes effect after relogin"
    fi
fi

if ask "Install bluetooth support?"; then
    install_pkgs bluez bluez-utils
    sudo systemctl enable bluetooth
    log_ok "Bluetooth installed and enabled"
fi

if ask "Install network manager?"; then
    install_pkgs networkmanager nm-connection-editor
    sudo systemctl enable NetworkManager
    log_ok "NetworkManager installed and enabled"
fi

if ask "Install fonts pack? (Noto, FiraCode, cascadia)"; then
    install_pkgs noto-fonts-emoji ttf-fira-code ttf-cascadia-code-nerd
    log_ok "Extra fonts installed"
fi

log_ok "All selected packages installed"
