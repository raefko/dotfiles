#!/usr/bin/env bash

# AeroSpace workspace plugin for SketchyBar
# $1 = workspace ID
# $2 = aerospace monitor ID (for per-monitor focus detection)
# $FOCUSED_WORKSPACE = globally focused workspace (set by event trigger)

export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

CONFIG_DIR="${CONFIG_DIR:-$HOME/.config/sketchybar}"
source "$CONFIG_DIR/colors.sh"

SID="$1"
MONITOR_ID="$2"

# Globally focused workspace
FOCUSED="${FOCUSED_WORKSPACE}"
if [ -z "$FOCUSED" ]; then
    FOCUSED=$(aerospace list-workspaces --focused 2>/dev/null)
fi

# Visible (active) workspace on this workspace's monitor
# This lets us highlight workspaces on inactive monitors too
MONITOR_VISIBLE=$(aerospace list-workspaces --monitor "$MONITOR_ID" --visible 2>/dev/null)

# Build app names label: unique app names, up to 3, dot-separated
APP_LABEL=$(aerospace list-windows --workspace "$SID" 2>/dev/null \
    | awk -F'|' '{gsub(/^ +| +$/, "", $2); print $2}' \
    | sort -u \
    | awk 'NR<=3 {if(NR>1) printf " · "; printf "%s", $0} END{printf "\n"}')

WIN_COUNT=$(aerospace list-windows --workspace "$SID" --count 2>/dev/null)
HAS_WINDOWS=false
if [ -n "$WIN_COUNT" ] && [ "$WIN_COUNT" -gt 0 ] 2>/dev/null; then
    HAS_WINDOWS=true
fi

if [ "$SID" = "$FOCUSED" ]; then
    # Globally focused: solid accent pill, dark text
    sketchybar --set "$NAME" \
        drawing=on \
        background.color="$WS_FOCUSED_BG" \
        icon.color="$WS_FOCUSED_FG" \
        label="$APP_LABEL" \
        label.color="$WS_FOCUSED_FG"
elif [ "$SID" = "$MONITOR_VISIBLE" ]; then
    # Visible on its monitor but not globally focused: surface pill
    sketchybar --set "$NAME" \
        drawing=on \
        background.color="$WS_VISIBLE_BG" \
        icon.color="$WS_VISIBLE_FG" \
        label="$APP_LABEL" \
        label.color="$SUBTEXT"
elif [ "$HAS_WINDOWS" = true ]; then
    # Has windows but not visible: dim pill
    sketchybar --set "$NAME" \
        drawing=on \
        background.color="$WS_WINDOWS_BG" \
        icon.color="$WS_WINDOWS_FG" \
        label="$APP_LABEL" \
        label.color="$SUBTEXT"
else
    # Empty: hidden
    sketchybar --set "$NAME" drawing=off
fi
