#!/bin/bash
# Foolproof Slack posting with auto-verification and logging
# Usage: ./slack-post.sh --channel C123 --message "text" [--thread 123.456] [--tags "U123,U456" OR --tag-names "Name1,Name2"]

set -e

CHANNEL=""
MESSAGE=""
THREAD=""
TAGS=""
TAG_NAMES=""
VERIFY_SCRIPT="/home/harsh/.openclaw/workspace/scripts/slack-verify-user.sh"
ACTION_LOG="/home/harsh/.openclaw/workspace/memory/humt-actions.jsonl"

# Parse arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    --channel) CHANNEL="$2"; shift 2 ;;
    --message) MESSAGE="$2"; shift 2 ;;
    --thread) THREAD="$2"; shift 2 ;;
    --tags) TAGS="$2"; shift 2 ;;
    --tag-names) TAG_NAMES="$2"; shift 2 ;;
    *) echo "Unknown option: $1"; exit 1 ;;
  esac
done

if [ -z "$CHANNEL" ] || [ -z "$MESSAGE" ]; then
  echo "Usage: $0 --channel C123 --message 'text' [--thread 123.456] [--tags 'U123,U456' OR --tag-names 'Name1,Name2']"
  exit 1
fi

# Verify user IDs if tag-names provided
if [ -n "$TAG_NAMES" ]; then
  VERIFIED_IDS=""
  IFS=',' read -ra NAMES <<< "$TAG_NAMES"
  for NAME in "${NAMES[@]}"; do
    USER_ID=$("$VERIFY_SCRIPT" "$NAME" 2>/dev/null || echo "")
    if [ -z "$USER_ID" ]; then
      echo "ERROR: Could not verify user ID for '$NAME'" >&2
      exit 1
    fi
    VERIFIED_IDS="${VERIFIED_IDS}${USER_ID},"
  done
  TAGS="${VERIFIED_IDS%,}"
fi

# Verify user IDs if tags provided (check they exist in directory)
if [ -n "$TAGS" ]; then
  IFS=',' read -ra IDS <<< "$TAGS"
  for ID in "${IDS[@]}"; do
    EXISTS=$(jq -r --arg id "$ID" '.people_directory[$id] // empty' /home/harsh/.openclaw/workspace/memory/slack-channel-map.json)
    if [ -z "$EXISTS" ]; then
      echo "WARNING: User ID $ID not in directory (may be invalid)" >&2
    fi
  done
fi

# Build final message with tags
if [ -n "$TAGS" ]; then
  IFS=',' read -ra IDS <<< "$TAGS"
  TAG_STRING=""
  for ID in "${IDS[@]}"; do
    TAG_STRING="${TAG_STRING}<@${ID}> "
  done
  FINAL_MESSAGE="${TAG_STRING}${MESSAGE}"
else
  FINAL_MESSAGE="$MESSAGE"
fi

# Post to Slack
BOT_TOKEN=$(python3 -c "import json; print(json.load(open('/home/harsh/.openclaw/openclaw.json'))['channels']['slack']['botToken'])")

if [ -n "$THREAD" ]; then
  RESPONSE=$(curl -s -X POST "https://slack.com/api/chat.postMessage" \
    -H "Authorization: Bearer $BOT_TOKEN" \
    -H "Content-Type: application/json" \
    -d "{\"channel\":\"$CHANNEL\",\"text\":\"$FINAL_MESSAGE\",\"thread_ts\":\"$THREAD\"}")
else
  RESPONSE=$(curl -s -X POST "https://slack.com/api/chat.postMessage" \
    -H "Authorization: Bearer $BOT_TOKEN" \
    -H "Content-Type: application/json" \
    -d "{\"channel\":\"$CHANNEL\",\"text\":\"$FINAL_MESSAGE\"}")
fi

OK=$(echo "$RESPONSE" | jq -r '.ok')
if [ "$OK" != "true" ]; then
  echo "ERROR: Slack post failed: $(echo $RESPONSE | jq -r '.error')" >&2
  exit 1
fi

MESSAGE_TS=$(echo "$RESPONSE" | jq -r '.ts')
echo "✓ Posted to Slack: $MESSAGE_TS"

# Log action
LOG_ENTRY=$(jq -n \
  --arg channel "$CHANNEL" \
  --arg thread "${THREAD:-}" \
  --arg msg_ts "$MESSAGE_TS" \
  --arg message "${MESSAGE:0:100}" \
  --arg tags "$TAGS" \
  '{
    type: "slack_post",
    channel: $channel,
    thread_ts: $thread,
    message_ts: $msg_ts,
    message_preview: $message,
    tagged_users: ($tags | split(","))
  }')

bash /home/harsh/.openclaw/workspace/scripts/log-action.sh "$LOG_ENTRY"

echo "$MESSAGE_TS"
