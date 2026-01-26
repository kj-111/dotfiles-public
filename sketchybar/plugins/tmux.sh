#!/bin/bash

SKETCHYBAR="${SKETCHYBAR:-$(command -v sketchybar || echo '/opt/homebrew/bin/sketchybar')}"
TMUX="${TMUX:-$(command -v tmux || echo '/opt/homebrew/bin/tmux')}"

# Get active tmux sessions
SESSIONS=$($TMUX list-sessions -F "#{session_created}:#{session_name}" 2>/dev/null | sort -n | cut -d: -f2 | cut -c1-8 | awk 'ORS=" | "' | sed 's/ | $//')

if [ -z "$SESSIONS" ]; then
  $SKETCHYBAR --set "$NAME" label="--"
else
  $SKETCHYBAR --set "$NAME" label="$SESSIONS"
fi
