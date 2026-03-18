# hyprdots — by pryan

> Arch + Hyprland dotfiles. Modular. Matugen-powered dynamic theming. Clean.

![Hyprland](https://img.shields.io/badge/WM-Hyprland-blue)
![Arch](https://img.shields.io/badge/OS-Arch_Linux-1793d1)
![Theme](https://img.shields.io/badge/Theme-Matugen_Dynamic-cba6f7)

---

## Install

```bash
git clone https://github.com/pryan/hyprdots
cd hyprdots
chmod +x install.sh
./install.sh
```

That's it. The script handles everything.

---

## What's Included

| Component | Choice |
|---|---|
| WM | Hyprland |
| Bar | Waybar (floating pill design) |
| Launcher | Rofi |
| Notifications | Swaync |
| Terminal | Ghostty + Kitty |
| Lock | Hyprlock |
| Idle | Hypridle |
| Wallpaper | swww |
| Theming | Matugen (dynamic from wallpaper) |
| Clipboard | cliphist |

---

## Dynamic Theming

```bash
wallset                        # opens rofi picker
wallset ~/Pictures/mywall.jpg  # set directly
```

Runs matugen, regenerates all colors, reloads waybar — one command.

---

## Keybinds

| Keys | Action |
|---|---|
| SUPER + Q | Terminal (ghostty) |
| SUPER + SPACE | Launcher (rofi) |
| SUPER + W | Set wallpaper |
| SUPER + L | Logout (wlogout) |
| SUPER + SHIFT+L | Lock (hyprlock) |
| SUPER + V | Clipboard history |
| SUPER + B | Firefox |
| SUPER + SHIFT+B | Brave |
| SUPER + E | File manager |
| Print | Screenshot region |
| SUPER+SHIFT+R | Screen record |
| SUPER + 1-9 | Switch workspace |
| SUPER+SHIFT + 1-9 | Move window to workspace |

---

## File Structure

```
hyprdots/
├── install.sh
├── scripts/
│   ├── lib.sh          ← shared helpers
│   ├── 00-check.sh     ← pre-flight
│   ├── 01-packages.sh  ← install packages (with optional groups)
│   ├── 02-gpu.sh       ← auto GPU detection
│   ├── 03-configs.sh   ← deploy configs
│   ├── 04-theme.sh     ← theme setup
│   └── 05-finish.sh    ← services + reboot
└── configs/
    ├── hypr/           ← modular hyprland config
    ├── waybar/         ← floating pill waybar
    ├── rofi/           ← launcher + clipboard
    ├── ghostty/        ← terminal
    ├── kitty/          ← terminal (backup)
    ├── swaync/         ← notifications
    └── matugen/        ← color templates
```

---

## GPU Support

Auto-detected on install:
- AMD → mesa + vulkan-radeon
- Intel → intel-media-driver
- NVIDIA → nvidia-dkms + proper env vars
- Hybrid Intel+NVIDIA → handled separately

---

Made with pain. The rewarding kind.
