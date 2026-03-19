#!/bin/bash
# Uses adi1090x rofi themes — make sure repo is cloned to ~/.config/rofi
DIR="$HOME/.config/rofi/launchers/type-2"
THEME="style-1"

rofi -show drun \
     -theme "$DIR/$THEME"
