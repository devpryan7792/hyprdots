# hyprdots — by pryan

> Arch + Hyprland dotfiles. Modular. Multi-theme preset switcher + Matugen dynamic theming. One script install.

![Hyprland](https://img.shields.io/badge/WM-Hyprland_0.54+-blue)
![Arch](https://img.shields.io/badge/OS-Arch_Linux-1793d1)
![Theme](https://img.shields.io/badge/Themes-6_presets_+_Dynamic-cba6f7)
![License](https://img.shields.io/badge/License-MIT-green)

---

## Install
```bash
git clone https://github.com/devpryan7792/hyprdots
cd hyprdots
chmod +x install.sh
./install.sh
```

The installer handles everything — packages, GPU detection, configs, theme setup.

---

## Features

### Theme Switcher
Press `ALT + T` to open the theme menu. Pick any preset and everything updates instantly — waybar, rofi, ghostty, kitty, hyprland borders.

**Built-in presets:**
| Theme | Accent |
|---|---|
| Catppuccin Mocha | Mauve |
| Catppuccin Latte | Lavender |
| Tokyo Night | Blue |
| One Dark | Blue |
| Gruvbox Dark | Yellow |
| Nord | Cyan |
| Dynamic (from wallpaper) | Matugen generated |

### Dynamic Wallpaper Theming
Press `SUPER + W` to open the wallpaper picker. Pick any image — matugen generates a full color scheme from it and applies it everywhere.

### Wallpaper Picker
Grid-based rofi picker with live thumbnails. Scroll through your wallpapers visually.

### Waybar
Floating pill design. Every module is its own pill. Includes:
- Workspaces with icons
- Clock, update counter, blue light filter, idle inhibitor
- Media player (center)
- System tray (toggleable with the tray button)
- Audio, network, bluetooth
- CPU, RAM, disk, temperature
- Battery, notifications, power

### Modular Hyprland Config
Split into separate files — edit only what you need:
```
~/.config/hypr/
├── hyprland.conf    ← main, sources everything
├── env.conf         ← GPU env vars (auto-generated)
├── monitors.conf    ← display setup
├── rules.conf       ← window rules
├── colors.conf      ← active theme colors
└── scripts/
    ├── theme-menu.sh      ← ALT+T theme switcher
    ├── theme-switcher.sh  ← SUPER+W wallpaper + matugen
    └── wallpaper.sh       ← autostart wallpaper
```

---

## Keybinds

| Keys | Action |
|---|---|
| SUPER + Q | Terminal (ghostty) |
| SUPER + SPACE | App launcher (rofi) |
| SUPER + W | Wallpaper picker + dynamic theme |
| ALT + T | Theme preset menu |
| SUPER + V | Clipboard history |
| SUPER + B | Firefox |
| SUPER + SHIFT+B | Brave |
| SUPER + E | File manager (thunar) |
| SUPER + L | Logout (wlogout) |
| SUPER + SHIFT+L | Lock screen (hyprlock) |
| SUPER + T | Toggle float |
| SUPER + F4 | Kill window |
| SUPER + J | Toggle split |
| Print | Screenshot region |
| SHIFT + Print | Screenshot window |
| SUPER + SHIFT + Print | Screenshot output |
| SUPER + SHIFT + R | Screen record region |
| SUPER + 1-9 | Switch workspace |
| SUPER + SHIFT + 1-9 | Move window to workspace |

---

## Stack

| Component | Tool |
|---|---|
| WM | Hyprland 0.54+ |
| Bar | Waybar |
| Launcher | Rofi-wayland |
| Notifications | Swaync |
| Terminal | Ghostty + Kitty |
| Lock | Hyprlock |
| Idle | Hypridle |
| Wallpaper | swww |
| Dynamic theming | Matugen |
| Clipboard | cliphist |
| Logout | wlogout |
| Screenshots | hyprshot |
| Screen record | wf-recorder |

---

## GPU Support

Auto-detected on install:
- AMD → mesa + vulkan-radeon
- Intel → intel-media-driver
- NVIDIA → nvidia-dkms + proper env vars
- Hybrid Intel+NVIDIA → handled separately

---

## Uninstall
```bash
./uninstall.sh
```

Goes through every installed package individually and asks before removing. Restores your original configs from backup if available, or generates a minimal working hyprland config.

---

## Adding Custom Themes

1. Create a folder in `~/.config/hypr/themes/yourtheme/`
2. Add `theme.conf` with these keys:
```
accent=hexcolor
text=hexcolor
subtext=hexcolor
base=hexcolor
mantle=hexcolor
surface0=hexcolor
surface1=hexcolor
surface2=hexcolor
red=hexcolor
green=hexcolor
yellow=hexcolor
blue=hexcolor
purple=hexcolor
teal=hexcolor
name=Your Theme Name
```
3. Add `hyprland-colors.conf` with the hyprland variable definitions
4. Press `ALT + T` — your theme appears in the list automatically

---

Made with pain. The rewarding kind. — pryan
