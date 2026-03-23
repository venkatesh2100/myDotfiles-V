#!/bin/bash

if pgrep -x "nmgui" >/dev/null; then
  hyprctl dispatch focuswindow "nmgui"
else
  nmgui &
fi
