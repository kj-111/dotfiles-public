#!/bin/bash
# CPU Usage % (Total sum / Core count)

SKETCHYBAR="${SKETCHYBAR:-$(command -v sketchybar || echo '/opt/homebrew/bin/sketchybar')}"

# Get CPU usage via top (single snapshot, no process enumeration)
CPU_PERCENT=$(/usr/bin/top -l 1 -n 0 2>/dev/null | /usr/bin/awk '/CPU usage/ {print 100 - $7}')

# Format to 2 chars with space padding
CPU_FORMAT=$(printf "%2.0f" "$CPU_PERCENT")

"$SKETCHYBAR" --set "$NAME" label="$CPU_FORMAT" icon.drawing=off
