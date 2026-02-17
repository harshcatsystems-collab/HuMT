#!/bin/bash
# Checks this week's meeting load and writes intensity level
# Usage: slack-intensity-check.sh
# Output: writes to memory/slack-intensity.json

# Get this week's meetings (Mon-Fri)
MONDAY=$(date -d "next monday" +%Y-%m-%d 2>/dev/null || date -d "monday" +%Y-%m-%d)
FRIDAY=$(date -d "$MONDAY + 4 days" +%Y-%m-%d)

MEETINGS=$(~/go/bin/gog calendar list --from "$MONDAY" --to "$FRIDAY" 2>/dev/null | tail -n +2 | wc -l)

if [ "$MEETINGS" -lt 15 ]; then
    LEVEL="light"
elif [ "$MEETINGS" -lt 20 ]; then
    LEVEL="normal"  
elif [ "$MEETINGS" -lt 25 ]; then
    LEVEL="heavy"
else
    LEVEL="extreme"
fi

cat > /home/harsh/.openclaw/workspace/memory/slack-intensity.json << EOF
{
  "weekOf": "$MONDAY",
  "meetingCount": $MEETINGS,
  "level": "$LEVEL",
  "checkedAt": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "adjustments": {
    "light": "Full briefs + richer context, expanded evening debrief",
    "normal": "Standard format",
    "heavy": "Tighter morning (decisions+temp only), full evening (he needs it MORE)",
    "extreme": "Morning=decisions-only, evening=compressed bullets, alerts=outage-only"
  }
}
EOF

echo "Week of $MONDAY: $MEETINGS meetings → $LEVEL intensity"
