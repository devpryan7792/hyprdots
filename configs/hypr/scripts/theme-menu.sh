#!/bin/bash
THEMES_DIR="$HOME/.config/hypr/themes"

# Build menu from theme names
MENU=""
for dir in "$THEMES_DIR"/*/; do
    [[ -f "$dir/theme.conf" ]] || continue
    name=$(grep "^name=" "$dir/theme.conf" | cut -d= -f2)
    MENU+="$name\n"
done
MENU+="Dynamic (from wallpaper)"

CHOICE=$(printf "$MENU" | rofi -dmenu -p "  Theme" -theme ~/.config/rofi/launchers/type-2/style.rasi)
[[ -z "$CHOICE" ]] && exit 0

[[ "$CHOICE" == "Dynamic (from wallpaper)" ]] && {
    ~/.config/hypr/scripts/theme-switcher.sh
    exit 0
}

# Find matching theme dir
THEME_DIR=""
for dir in "$THEMES_DIR"/*/; do
    name=$(grep "^name=" "$dir/theme.conf" 2>/dev/null | cut -d= -f2)
    [[ "$name" == "$CHOICE" ]] && THEME_DIR="$dir" && break
done

[[ -z "$THEME_DIR" ]] && exit 1

# Read theme values
declare -A C
while IFS='=' read -r k v; do
    [[ -z "$k" ]] && continue
    C["$k"]="$v"
done < "$THEME_DIR/theme.conf"

# Copy hyprland colors
cp "$THEME_DIR/hyprland-colors.conf" "$HOME/.config/hypr/colors.conf"

# Waybar
cat > "$HOME/.config/waybar/colors.css" << WAYCSS
/* Theme: ${C[name]} */
@define-color primary          #${C[accent]};
@define-color onPrimary        #${C[base]};
@define-color primaryContainer #${C[surface0]};
@define-color secondary        #${C[teal]};
@define-color tertiary         #${C[purple]};
@define-color background       #${C[base]};
@define-color surface          #${C[surface0]};
@define-color surfaceVariant   #${C[surface1]};
@define-color onSurface        #${C[text]};
@define-color onSurfaceVariant #${C[subtext]};
@define-color error            #${C[red]};
@define-color outline          #${C[surface2]};
@define-color main-bg          #${C[base]};
@define-color main-fg          #${C[text]};
@define-color accent           #${C[accent]};
WAYCSS

# Rofi
cat > "$HOME/.config/rofi/colors.rasi" << ROFIEOF
* {
    ro-bg:     #${C[base]};
    ro-bg-alt: #${C[surface0]};
    ro-fg:     #${C[text]};
    ro-ac:     #${C[accent]};
    ro-se:     #${C[surface1]};
    ro-ur:     #${C[red]};
    ro-bo:     #${C[surface2]};
}
ROFIEOF

# Ghostty
cat > "$HOME/.config/ghostty/theme" << GHOSTEOF
foreground = #${C[text]}
background = #${C[base]}
cursor-color = #${C[accent]}
palette = 0=#${C[base]}
palette = 1=#${C[red]}
palette = 2=#${C[green]}
palette = 3=#${C[yellow]}
palette = 4=#${C[blue]}
palette = 5=#${C[purple]}
palette = 6=#${C[teal]}
palette = 7=#${C[text]}
palette = 8=#${C[surface2]}
palette = 15=#${C[subtext]}
GHOSTEOF

# Kitty
cat > "$HOME/.config/kitty/current-theme.conf" << KITTYEOF
foreground            #${C[text]}
background            #${C[base]}
cursor                #${C[accent]}
selection_foreground  #${C[base]}
selection_background  #${C[accent]}
color0  #${C[base]}
color1  #${C[red]}
color2  #${C[green]}
color3  #${C[yellow]}
color4  #${C[blue]}
color5  #${C[purple]}
color6  #${C[teal]}
color7  #${C[text]}
color8  #${C[surface2]}
color15 #${C[subtext]}
KITTYEOF

# Reload
hyprctl reload
pkill waybar 2>/dev/null; sleep 0.3; waybar &
pkill swaync 2>/dev/null; sleep 0.2; swaync &
for pid in $(pgrep kitty); do kill -SIGUSR1 "$pid" 2>/dev/null; done
pkill -SIGUSR1 ghostty 2>/dev/null || true
notify-send "Theme" "Switched to ${C[name]}" -t 2000
