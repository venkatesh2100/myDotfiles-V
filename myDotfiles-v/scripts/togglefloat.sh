#!/usr/bin/env bash

LAYOUT_FILE="$HOME/.config/hyprland/last_layout.json"

# Check if the focused window is floating
is_floating=$(hyprctl activewindow | grep -q "floating: true" && echo yes || echo no)

if [[ "$is_floating" == "no" ]]; then
  # 1) Save the current layout
  hyprctl --batch "dispatch savelayout $LAYOUT_FILE"

  # 2) Toggle floating on, resize & center
  hyprctl --batch "dispatch togglefloating; dispatch resizeactive exact 95% 95%; dispatch centerwindow"
else
  # 3) Toggle floating off, then restore layout
  hyprctl --batch "dispatch togglefloating"
  sleep 0.05
  hyprctl --batch "dispatch loadlayout $LAYOUT_FILE"
fi

