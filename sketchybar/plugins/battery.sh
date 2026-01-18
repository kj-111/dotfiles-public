#!/bin/bash
# High-accuracy Battery % — Optimized for efficiency

SKETCHYBAR="${SKETCHYBAR:-$(command -v sketchybar || echo '/opt/homebrew/bin/sketchybar')}"

PERCENTAGE=$(/usr/bin/pmset -g batt 2>/dev/null | /usr/bin/awk '{ if (match($0, /[0-9]+%/)) { print substr($0, RSTART, RLENGTH-1); exit } }')

if [ -z "$PERCENTAGE" ]; then
  "$SKETCHYBAR" --set "$NAME" label="--"
  exit 0
fi

PADDED=$(printf "%2d" "$PERCENTAGE")
"$SKETCHYBAR" --set "$NAME" label="$PADDED" icon.drawing=off
