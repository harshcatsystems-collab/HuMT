#!/bin/bash
# Send morning brief to Daily Ops topic

# Generate brief content (placeholder - actual brief generation happens elsewhere)
BRIEF_CONTENT="$1"

if [ -z "$BRIEF_CONTENT" ]; then
    echo "Usage: bash send-morning-brief.sh '<brief_content>'"
    exit 1
fi

# Send to Daily Ops topic
bash /home/harsh/.openclaw/workspace/scripts/send-telegram-topic.sh \
    --topic daily_ops \
    --message "$BRIEF_CONTENT"
