#!/bin/bash
# High-accuracy RAM % (App Memory + Wired + Compressed) - Activity Monitor Style

SKETCHYBAR="${SKETCHYBAR:-$(command -v sketchybar || echo '/opt/homebrew/bin/sketchybar')}"

MEM_SIZE=$(/usr/sbin/sysctl -n hw.memsize) || exit 0
PAGE_SIZE=$(/usr/sbin/sysctl -n hw.pagesize) || exit 0

VM_OUT=$(/usr/bin/vm_stat 2>/dev/null) || {
  "$SKETCHYBAR" --set "$NAME" label="--" icon.drawing=off
  exit 0
}

PERCENT=$(printf "%s\n" "$VM_OUT" | /usr/bin/awk -v mem="$MEM_SIZE" -v pg="$PAGE_SIZE" '
  /Anonymous pages/          { anon=$NF }
  /Pages purgeable/          { purg=$NF }
  /Pages wired down/         { wire=$NF }
  /Pages (occupied|used) by compressor/ { comp=$NF }
  END {
    gsub(/[^0-9]/, "", anon); gsub(/[^0-9]/, "", purg);
    gsub(/[^0-9]/, "", wire); gsub(/[^0-9]/, "", comp);
    
    # App Memory = Anonymous + Purgeable
    # Used = App Memory + Wired + Compressed
    used_bytes = (anon + purg + wire + comp) * pg;
    pct = (used_bytes * 100 + mem/2) / mem;

    if (pct < 0) pct = 0;
    if (pct > 100) pct = 100;

    printf "%2d", pct
  }
')

"$SKETCHYBAR" --set "$NAME" label="$PERCENT" icon.drawing=off
