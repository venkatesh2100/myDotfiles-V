#!/bin/bash
WALLDIR="$HOME/Pictures/walls/"
CACHEDIR="$HOME/.cache/wall-thumbs"
LAST="$HOME/.cache/last_wallpaper"
mkdir -p "$CACHEDIR"

# Ensure swww running
swww-daemon 2>/dev/null &
sleep 0.5

generate_thumbnail() {
  file="$1"
  base=$(basename "$file")
  thumb="$CACHEDIR/${base%.*}.png"
  if [ ! -f "$thumb" ] || [ "$file" -nt "$thumb" ]; then
    ext="${file##*.}"
    if [[ "$ext" == "mp4" ]]; then
      ffmpeg -y -i "$file" -vf "thumbnail,scale=400:400:force_original_aspect_ratio=increase,crop=400:400" -frames:v 1 "$thumb" 2>/dev/null
    else
      convert "$file[0]" -resize 400x400^ -gravity center -crop 400x400+0+0 +repage "$thumb" 2>/dev/null
    fi
  fi
  echo "$thumb"
}

menu() {
  find "$WALLDIR" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.webp" -o -iname "*.mp4" \) -print0 |
    while IFS= read -r -d '' file; do
      name=$(basename "$file")
      thumb=$(generate_thumbnail "$file")
      printf "%s\0icon\x1f%s\n" "$name" "$thumb"
    done
}

# Restore wallpaper on boot
if [ "$1" = "restore" ]; then
  if [ -f "$LAST" ]; then
    wp=$(cat "$LAST")
    ext="${wp##*.}"
    if [[ "$ext" == "mp4" ]]; then
      gslapper "*" "$wp" -o loop &
    else
      swww img "$wp" --transition-type grow --transition-duration 0.5 &
    fi
  fi
  exit 0
fi

# Select wallpaper with rofi
selected=$(menu | rofi -dmenu -i -p "Wallpaper" -show-icons)
[ -z "$selected" ] && exit 0

wp="$WALLDIR/$selected"
echo "$wp" >"$LAST"
ext="${wp##*.}"

# Generate colors using matugen
matugen image "$wp" &
sleep 0.3
killall dunst 2>/dev/null
dunst &

# Apply wallpaper
if [[ "$ext" == "mp4" ]]; then
  notify-send "Wallpaper" "Applying animated wallpaper: $selected"
  gslapper "*" "$wp" -o loop &
else
  notify-send "Wallpaper" "Applying wallpaper: $selected"
  swww img "$wp" --transition-type grow --transition-duration 0.5 &
fi
