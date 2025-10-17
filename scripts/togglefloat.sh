#!/bin/bash

# Check if the active window is floating
is_floating=$(hyprctl activewindow -j | jq -r '.floating')

if [[ "$is_floating" == "true" ]]; then
  # If floating, revert back to tiled mode
  hyprctl --batch "dispatch togglefloating; dispatch layoutmsg dpms on"
else
  # If not floating, float it, resize and center
  hyprctl --batch "dispatch togglefloating; dispatch resizeactive exact 95% 75%; dispatch centerwindow"
fi
