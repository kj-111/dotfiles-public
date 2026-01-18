#!/bin/bash

SKETCHYBAR="${SKETCHYBAR:-$(command -v sketchybar || echo '/opt/homebrew/bin/sketchybar')}"

# Format: HH:MM (e.g., 14:30)
"$SKETCHYBAR" --set "$NAME" label="$(date '+%H:%M')"
