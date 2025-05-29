#!/bin/bash

# Directory containing wallpapers
WALL_DIR="$HOME/Pictures/walls"
# File to store current wallpaper index
INDEX_FILE="$HOME/.cache/current_wall_index"

# Get list of wallpapers
WALLS=("$WALL_DIR"/*)

# Read the last index or start at 0
if [ -f "$INDEX_FILE" ]; then
    INDEX=$(cat "$INDEX_FILE")
else
    INDEX=0
fi

# Calculate next index
NEXT_INDEX=$(((INDEX + 1) % ${#WALLS[@]}))

# Set wallpaper
swaybg -i "${WALLS[$NEXT_INDEX]}" -m fill &

# Save new index
echo $NEXT_INDEX >"$INDEX_FILE"
