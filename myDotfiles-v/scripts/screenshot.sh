#!/usr/bin/env bash

# Directories
SAVE_DIR="/home/venky/Pictures/shots/"
mkdir -p "$SAVE_DIR"
FILENAME="$(date +'%y%m%d_%H%M%S')_screenshot.png"
SAVE_PATH="${SAVE_DIR}/${FILENAME}"
TEMP_PATH="$(mktemp -t screenshot_XXXXXX.png)"

# Annotation tool detection (optional)
ANNOTATOR=""
command -v swappy &>/dev/null && ANNOTATOR="swappy"
command -v satty &>/dev/null && ANNOTATOR="satty"

# Usage instructions
usage() {
  echo "Usage: $(basename "$0") [option]"
  echo "Options:"
  echo "  s   Select area or window to screenshot"
  echo "  m   Screenshot focused monitor"
  echo "  sf  Frozen area screenshot"
  echo "  sc  OCR selected area and copy to clipboard"
  exit 1
}

# Take screenshot function
screenshot() {
  MODE=$1
  shift
  if grim "$@" "$TEMP_PATH"; then
    cp "$TEMP_PATH" "$SAVE_PATH"
    notify-send "Screenshot saved" "$SAVE_PATH"
    [ -n "$ANNOTATOR" ] && "$ANNOTATOR" -f "$TEMP_PATH" -o "$SAVE_PATH"
  else
    notify-send "Screenshot failed"
    exit 1
  fi
}

# OCR function
ocr_clipboard() {
  command -v tesseract &>/dev/null || {
    echo "tesseract not found"
    exit 1
  }
  GEOM=$(slurp) || exit 1
  grim -g "$GEOM" "$TEMP_PATH"
  command -v magick &>/dev/null && magick "$TEMP_PATH" -sigmoidal-contrast 10,50% "$TEMP_PATH"
  tesseract "$TEMP_PATH" - | wl-copy
  notify-send "Text copied to clipboard" -i "$TEMP_PATH"
}

# Parse argument
case "$1" in
s) GEOM=$(slurp) && screenshot -g "$GEOM" ;;
sf) screenshot --freeze --cursor -g "$(slurp)" ;;
m) screenshot -o "$(hyprctl monitors -j | jq -r '.[] | select(.focused) | .name')" ;;
sc) ocr_clipboard ;;
*) usage ;;
esac

rm -f "$TEMP_PATH"
