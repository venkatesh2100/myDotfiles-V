#!/bin/bash

# Get mic mute status with pactl
mute=$(pactl get-source-mute @DEFAULT_SOURCE@ | awk '{print $2}')

if [ "$mute" = "yes" ]; then
  # Mic is muted, print nothing to hide module
  echo ""
else
  # Mic is unmuted, show mic icon
  echo "🎤"
fi
