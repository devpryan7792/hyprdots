#!/usr/bin/env bash
STATUS=$(playerctl status 2>/dev/null) || exit 1
ARTIST=$(playerctl metadata artist 2>/dev/null)
TITLE=$(playerctl metadata title 2>/dev/null)
[[ -z "$TITLE" ]] && exit 1
ICON="󰎈"
[ "$STATUS" = "Paused" ] && ICON="󰏤"
LABEL="$ICON  ${ARTIST:+$ARTIST – }$TITLE"
printf '{"text":"%s","tooltip":"%s"}\n' "${LABEL:0:42}" "$TITLE"
