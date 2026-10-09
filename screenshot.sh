#!/usr/bin/env bash
# ~/.config/snow/bin/screenshot.sh
DIR="$HOME/Pictures/Screenshots"
mkdir -p "$DIR"
FILE="$DIR/screenshot-$(date +%Y%m%d-%H%M%S).png"

if [ "${1:-area}" = "area" ]; then
    grim -g "$(slurp)" - | swappy -f -
else
    grim "$FILE"
    wl-copy < "$FILE"
    notify-send "Screenshot Captured" "Saved to $FILE and copied to clipboard" -i camera-photo
fi
