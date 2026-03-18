#!/usr/bin/env bash
STATE_FILE="${XDG_RUNTIME_DIR:-/tmp}/bluelight_state"
current=$(cat "$STATE_FILE" 2>/dev/null || echo "off")
case "$current" in
    off)   echo '{"text":"󱠿  off","tooltip":"Off → click for 3500K","class":"off"}' ;;
    3500)  echo '{"text":"󱠿 3500K","tooltip":"Warm → click for 4500K","class":"warm"}' ;;
    4500)  echo '{"text":"󱠿 4500K","tooltip":"Mild → click for 2700K","class":"mild"}' ;;
    2700)  echo '{"text":"󱠿 2700K","tooltip":"Night → click to turn off","class":"night"}' ;;
esac
