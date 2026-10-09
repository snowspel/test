#!/usr/bin/env bash
# ~/.config/snow/bin/apply-kitty.sh
THEME_FILE="$HOME/.config/snow/theme.json"
KITTY_CONF="$HOME/.config/kitty/snow-theme.conf"

if [ -f "$THEME_FILE" ]; then
    BG=$(jq -r '.bg' "$THEME_FILE")
    FG=$(jq -r '.text' "$THEME_FILE")
    ACCENT=$(jq -r '.accent' "$THEME_FILE")
    
    cat << EOF > "$KITTY_CONF"
background $BG
foreground $FG
selection_background $ACCENT
selection_foreground $BG
cursor $ACCENT
cursor_text_color $BG
active_border_color $ACCENT
inactive_border_color $BG
EOF
    killall -SIGUSR1 kitty 2>/dev/null || true
fi
