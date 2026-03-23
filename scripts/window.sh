#!/bin/bash

# Redirect all errors to /dev/null and ignore SIGPIPE
exec 2>/dev/null
trap '' PIPE
set -o pipefail

# Function to get icon
get_icon() {
  local class="$1"
  local icon=""

  case "$class" in
  *kitty* | *Kitty*) icon="" ;;
  *firefox* | *Firefox*) icon="" ;;
  *chrome* | *Chrome* | *chromium*) icon="" ;;
  *code* | *Code* | *VSCode*) icon="󰨞" ;;
  *thunar* | *Thunar* | *nautilus*) icon="" ;;
  *discord* | *Discord*) icon="󰙯" ;;
  *spotify* | *Spotify*) icon="" ;;
  *steam* | *Steam*) icon="" ;;
  *telegram* | *Telegram*) icon="" ;;
  *obsidian* | *Obsidian*) icon="" ;;
  "") icon="" ;;
  *) icon="" ;;
  esac

  echo "$icon"
}

# Main loop
while true; do
  class=$(hyprctl activewindow -j 2>/dev/null | jq -r '.class // ""' 2>/dev/null) || class=""
  icon=$(get_icon "$class")

  # Try to output, if it fails, exit gracefully
  printf '{"text":"%s", "class":"%s"}\n' "$icon" "$class" || exit 0

  sleep 0.5
done
