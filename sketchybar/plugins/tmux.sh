#!/bin/bash

SKETCHYBAR="${SKETCHYBAR:-$(command -v sketchybar || echo '/opt/homebrew/bin/sketchybar')}"
TMUX="${TMUX:-$(command -v tmux || echo '/opt/homebrew/bin/tmux')}"

# Get active tmux sessions
SESSIONS=$($TMUX list-sessions -F "#{session_name}" 2>/dev/null | cut -c1-8 | awk 'ORS=" | "' | sed 's/ | $//')

if [ -z "$SESSIONS" ]; then
  $SKETCHYBAR --set "$NAME" label="--"
else
  $SKETCHYBAR --set "$NAME" label="$SESSIONS"
fi
