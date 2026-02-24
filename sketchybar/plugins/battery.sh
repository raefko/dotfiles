#!/bin/sh

source "${CONFIG_DIR:-$HOME/.config/sketchybar}/colors.sh"

PERCENTAGE="$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)"
CHARGING="$(pmset -g batt | grep 'AC Power')"

if [ "$PERCENTAGE" = "" ]; then
  exit 0
fi

case "${PERCENTAGE}" in
  9[0-9]|100) ICON=""  ;;
  [6-8][0-9]) ICON=""  ;;
  [3-5][0-9]) ICON=""  ;;
  [1-2][0-9]) ICON=""  ;;
  *)           ICON=""  ;;
esac

if [ -n "$CHARGING" ]; then
  ICON=""
  COLOR="$BATTERY_OK"
elif [ "$PERCENTAGE" -ge 60 ]; then
  COLOR="$BATTERY_OK"
elif [ "$PERCENTAGE" -ge 20 ]; then
  COLOR="$BATTERY_WARN"
else
  COLOR="$BATTERY_CRIT"
fi

sketchybar --set "$NAME" \
    icon="$ICON" \
    icon.color="$COLOR" \
    label="${PERCENTAGE}%" \
    label.color="$COLOR"
