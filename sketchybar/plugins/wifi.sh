#!/bin/bash

SKETCHYBAR="${SKETCHYBAR:-$(command -v sketchybar || echo '/opt/homebrew/bin/sketchybar')}"

# Get active network interface dynamically
IFACE=$(/sbin/route -n get default 2>/dev/null | /usr/bin/awk '/interface:/ {print $2}')

if [ -n "$IFACE" ] && /usr/sbin/ipconfig getifaddr "$IFACE" >/dev/null 2>&1; then
  # Connected - Circle
  "$SKETCHYBAR" --set "$NAME" label="●" icon.drawing=off
else
  # Disconnected - Minus
  "$SKETCHYBAR" --set "$NAME" label="-" icon.drawing=off
fi
