#!/bin/bash
# Check for new @HuMT mentions workspace-wide
# Outputs JSON: {new_mentions: [...], count: N}

set -e

STATE_FILE="/home/harsh/.openclaw/workspace/memory/slack-digest-state.json"
USER_TOKEN=$(python3 -c "import json; print(json.load(open('/home/harsh/.openclaw/openclaw.json'))['channels']['slack']['userToken'])")

# Search for @HuMT mentions
RESPONSE=$(curl -s -H "Authorization: Bearer $USER_TOKEN" "https://slack.com/api/search.messages?query=%3C%40U0AE6043BB6%3E&sort=timestamp&sort_dir=desc&count=10")

# Load processed mentions from state
PROCESSED=$(jq -r '.processedMentions // [] | @json' "$STATE_FILE")

# Extract new mentions (not in processed list)
NEW_MENTIONS=$(echo "$RESPONSE" | jq --argjson processed "$PROCESSED" '
  .messages.matches // [] |
  map({
    ts: .ts,
    channel_id: .channel.id,
    channel_name: .channel.name,
    user_id: .user,
    username: .username,
    text: .text,
    permalink: .permalink
  }) |
  map(select(.ts as $ts | ($processed | index($ts)) == null))
')

COUNT=$(echo "$NEW_MENTIONS" | jq 'length')

echo "{\"new_mentions\": $NEW_MENTIONS, \"count\": $COUNT}"
