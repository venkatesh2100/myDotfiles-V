#!/bin/bash

# Get all floating window addresses
floating_windows=$(hyprctl clients -j | jq -r '.[] | select(.floating == true) | .address')

# Loop and unfloat each
for win in $floating_windows; do
    hyprctl dispatch focuswindow address:$win
    hyprctl dispatch togglefloating
done

# Focus back on first non-floating window if any
non_floating=$(hyprctl clients -j | jq -r '.[] | select(.floating == false) | .address' | head -n1)
if [ -n "$non_floating" ]; then
    hyprctl dispatch focuswindow address:$non_floating
fi
