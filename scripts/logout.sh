#!/usr/bin/env bash

# Exit if wlogout is already running
if pgrep -x "wlogout" >/dev/null; then
    pkill -x "wlogout"
    exit 0
fi

# Set default layout and style (no theming)
LAYOUT="$HOME/.config/wlogout/layout_1"
STYLE="$HOME/.config/wlogout/style_1.css"

# Fallback if not found
if [ ! -f "$LAYOUT" ]; then
    echo "Missing layout file: $LAYOUT"
    exit 1
fi

if [ ! -f "$STYLE" ]; then
    echo "Missing style file: $STYLE"
    exit 1
fi

# Launch wlogout with default options
wlogout -b 6 --layout "$LAYOUT" --css "$STYLE" --protocol layer-shell

