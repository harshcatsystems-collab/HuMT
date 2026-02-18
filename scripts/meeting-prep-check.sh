#!/bin/bash
# meeting-prep-check.sh — Check if any meeting starts in next 30-45 min that hasn't been prepped
# Called by the meeting-prep-scheduler cron every 30 min during work hours

PREP_STATE="/home/harsh/.openclaw/workspace/memory/meeting-prep-state.json"

# Initialize state file if it doesn't exist
if [ ! -f "$PREP_STATE" ]; then
    echo '{"preppedToday": [], "date": ""}' > "$PREP_STATE"
fi

# Get today's date
TODAY=$(date -u +%Y-%m-%d)

# Reset state if it's a new day
STORED_DATE=$(python3 -c "import json; print(json.load(open('$PREP_STATE')).get('date',''))" 2>/dev/null)
if [ "$STORED_DATE" != "$TODAY" ]; then
    echo "{\"preppedToday\": [], \"date\": \"$TODAY\"}" > "$PREP_STATE"
fi

# Get calendar for today
~/go/bin/gog calendar list --from today --to tomorrow 2>&1
