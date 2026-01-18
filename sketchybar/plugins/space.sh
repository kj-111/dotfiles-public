#!/bin/bash

SKETCHYBAR="${SKETCHYBAR:-$(command -v sketchybar || echo '/opt/homebrew/bin/sketchybar')}"

# $FOCUSED_WORKSPACE is passed by the trigger in aerospace.toml
if [ -n "$FOCUSED_WORKSPACE" ]; then
    "$SKETCHYBAR" --set "$NAME" label="$FOCUSED_WORKSPACE"
else
    # Fallback/Initial check
    WS=$(aerospace list-workspaces --focused)
    "$SKETCHYBAR" --set "$NAME" label="$WS"
fi
