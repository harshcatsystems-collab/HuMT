#!/bin/bash
# Usage: slack-read-channel.sh <channel_id> [limit] [oldest_ts]
# Reads messages from a Slack channel using bot token
# Returns JSON with messages

CHANNEL_ID="$1"
LIMIT="${2:-20}"
OLDEST="${3:-}"

BOT_TOKEN=$(python3 -c "import json; print(json.load(open('/home/harsh/.openclaw/openclaw.json'))['channels']['slack']['botToken'])")

URL="https://slack.com/api/conversations.history?channel=${CHANNEL_ID}&limit=${LIMIT}"
if [ -n "$OLDEST" ]; then
    URL="${URL}&oldest=${OLDEST}"
fi

curl -s -H "Authorization: Bearer $BOT_TOKEN" "$URL"
