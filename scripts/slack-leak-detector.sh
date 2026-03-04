#!/bin/bash
# Daily leak detector - scans HuMT's Slack posts for process noise
# Run at end of day to catch leaks before they compound
# Usage: bash scripts/slack-leak-detector.sh [hours_back]

HOURS=${1:-24}
cd /home/harsh/.openclaw/workspace

BOT_ID="U0AE6043BB6"
NOW=$(date +%s)
CUTOFF=$((NOW - HOURS * 3600))

echo "=== SLACK LEAK DETECTOR (last ${HOURS}h) ==="
echo ""

# Channels to audit (high-traffic + sensitive)
CHANNELS=(
    "C08PGK8CM32:#finance-department"
    "C07KWTTB98W:#stage_maino"
    "C080EJU9873:#growth-pod"
    "C06QTJMKLUA:#retention"
    "GEJUR0WA2:#founders_sync"
    "C0ABCG0RV1N:#homepage-personalisation"
)

TOTAL_LEAKS=0

for chan in "${CHANNELS[@]}"; do
    CHANNEL_ID="${chan%:*}"
    CHANNEL_NAME="${chan#*:}"
    
    # Read recent messages
    MESSAGES=$(bash scripts/slack-read-channel.sh "$CHANNEL_ID" 100 2>/dev/null)
    
    if echo "$MESSAGES" | grep -q '"ok":true'; then
        # Find HuMT messages and check for leak patterns
        LEAKS=$(echo "$MESSAGES" | python3 -c "
import json, sys

data = json.load(sys.stdin)
messages = data.get('messages', [])
humt_msgs = [m for m in messages if m.get('user') == '$BOT_ID']

leak_patterns = [
    'I need to relay',
    'Let me do',
    'I should',
    'I\\'ll relay',
    'conversations.',
    'Subagent',
    '✓.*finished',
    'API error',
    'checking with HMT',
    'executing',
]

leaks = []
for m in humt_msgs:
    text = m.get('text', '')
    ts = float(m.get('ts', 0))
    
    # Check if recent
    if ts < $CUTOFF:
        continue
    
    # Check for leak patterns
    import re
    for pattern in leak_patterns:
        if re.search(pattern, text, re.IGNORECASE):
            leaks.append({
                'ts': m.get('ts'),
                'preview': text[:80],
                'pattern': pattern
            })
            break

if leaks:
    print(json.dumps(leaks))
" 2>/dev/null)
        
        if [ -n "$LEAKS" ] && [ "$LEAKS" != "[]" ]; then
            COUNT=$(echo "$LEAKS" | python3 -c "import json,sys; print(len(json.load(sys.stdin)))")
            echo "🚨 $CHANNEL_NAME: $COUNT leak(s) found"
            echo "$LEAKS" | python3 -c "
import json, sys
for leak in json.load(sys.stdin):
    print(f\"  [{leak['ts']}] Pattern: {leak['pattern']}\")
    print(f\"    {leak['preview']}\")
"
            TOTAL_LEAKS=$((TOTAL_LEAKS + COUNT))
        fi
    fi
done

echo ""
if [ $TOTAL_LEAKS -eq 0 ]; then
    echo "✅ No leaks detected in last ${HOURS}h"
else:
    echo "🚨 TOTAL LEAKS: $TOTAL_LEAKS"
    echo ""
    echo "→ Review and delete these messages"
    echo "→ Update leak patterns in scripts/slack-post-filter.sh"
    echo "→ Log to daily memory under '### Slack Leak Alert'"
fi

exit $TOTAL_LEAKS
