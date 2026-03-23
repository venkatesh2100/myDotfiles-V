#!/bin/bash
# Save as ~/.config/waybar/scripts/control-center.sh
# Make executable: chmod +x ~/.config/waybar/scripts/control-center.sh

# Check if wofi is running, if so kill it, otherwise launch control center
if pgrep -x wofi >/dev/null; then
  pkill wofi
  exit 0
fi

# Get system information
get_battery() {
  if [ -d /sys/class/power_supply/BAT* ]; then
    BATTERY=$(cat /sys/class/power_supply/BAT*/capacity 2>/dev/null | head -1)
    STATUS=$(cat /sys/class/power_supply/BAT*/status 2>/dev/null | head -1)
    if [ "$STATUS" = "Charging" ]; then
      echo "󰂄 Battery: ${BATTERY}% (Charging)"
    else
      echo "󰁹 Battery: ${BATTERY}%"
    fi
  else
    echo "󱉝 No Battery"
  fi
}

get_volume() {
  VOLUME=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -Po '\d+(?=%)' | head -1)
  MUTED=$(pactl get-sink-mute @DEFAULT_SINK@ | grep -o 'yes')
  if [ "$MUTED" = "yes" ]; then
    echo "󰝟 Volume: Muted"
  else
    echo " Volume: ${VOLUME}%"
  fi
}

get_brightness() {
  if command -v brightnessctl &>/dev/null; then
    BRIGHTNESS=$(brightnessctl g)
    MAX=$(brightnessctl m)
    PERCENT=$((BRIGHTNESS * 100 / MAX))
    echo " Brightness: ${PERCENT}%"
  else
    echo " Brightness: N/A"
  fi
}

get_network() {
  if command -v nmcli &>/dev/null; then
    CONNECTION=$(nmcli -t -f NAME connection show --active | head -1)
    if [ -n "$CONNECTION" ]; then
      echo "󰤨 Network: $CONNECTION"
    else
      echo "󰤭 Network: Disconnected"
    fi
  else
    echo "󰤨 Network: Unknown"
  fi
}

get_cpu() {
  CPU=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1)
  echo " CPU: ${CPU}%"
}

get_memory() {
  MEM=$(free | grep Mem | awk '{printf "%.0f", $3/$2 * 100}')
  echo " Memory: ${MEM}%"
}

get_uptime() {
  UPTIME=$(uptime -p | sed 's/up //')
  echo "󰔟 Uptime: $UPTIME"
}

get_date_time() {
  DATE=$(date '+%A, %B %d, %Y')
  TIME=$(date '+%I:%M %p')
  echo "📅 $DATE"
  echo "🕐 $TIME"
}

# Build the menu
MENU="$(
  cat <<EOF
$(get_date_time)
────────────────────────
$(get_battery)
$(get_volume)
$(get_brightness)
$(get_network)
────────────────────────
$(get_cpu)
$(get_memory)
$(get_uptime)
────────────────────────
 System Settings
 Power Menu
 Lock Screen
 Logout
EOF
)"

# Show menu with wofi
CHOICE=$(echo "$MENU" | wofi -dmenu -i -p "Control Center" \
  -theme-str 'window {width: 800px; location: north east; anchor: north east; x-offset: -10px; y-offset: 10px;}' \
  -theme-str 'listview {lines: 16;}' \
  -theme-str 'element {padding: 8px;}' \
  -theme-str 'element-text {font: "Inter 11";}')

# Handle actions
case "$CHOICE" in
*"System Settings"*)
  gnome-control-center &
  ;;
*"Power Menu"*)
  ~/.config/waybar/scripts/power-menu.sh
  ;;
*"Lock Screen"*)
  swaylock
  ;;
*"Logout"*)
  hyprctl dispatch exit
  ;;
*"Volume"*)
  pavucontrol &
  ;;
*"Brightness"*)
  # Open brightness control (you can customize this)
  notify-send "Brightness" "Use keyboard shortcuts to adjust"
  ;;
*"Network"*)
  nm-connection-editor &
  ;;
esac
