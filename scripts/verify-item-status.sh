#!/bin/bash
# Verify if a Slack thread item is closed or still open
# Usage: ./verify-item-status.sh <thread_ts> <channel_id>
# Returns: CLOSED | OPEN | UNKNOWN

set -e

THREAD_TS="$1"
CHANNEL_ID="$2"
ACTION_LOG="/home/harsh/.openclaw/workspace/memory/humt-actions.jsonl"

if [ -z "$THREAD_TS" ] || [ -z "$CHANNEL_ID" ]; then
  echo "Usage: $0 <thread_ts> <channel_id>"
  exit 1
fi

# Check 1: Action log
if [ -f "$ACTION_LOG" ]; then
  LOG_STATUS=$(jq -r --arg ts "$THREAD_TS" '
    select(.thread_ts == $ts and .status == "closed") | 
    .status
  ' "$ACTION_LOG" | tail -1)
  
  if [ "$LOG_STATUS" = "closed" ]; then
    echo "CLOSED"
    exit 0
  fi
fi

# Check 2: Thread replies (look for approval message from HuMT bot)
BOT_TOKEN=$(python3 -c "import json; print(json.load(open('/home/harsh/.openclaw/openclaw.json'))['channels']['slack']['botToken'])")
THREAD_RESP=$(curl -s -H "Authorization: Bearer $BOT_TOKEN" \
  "https://slack.com/api/conversations.replies?channel=${CHANNEL_ID}&ts=${THREAD_TS}&limit=50")

HAS_APPROVAL=$(echo "$THREAD_RESP" | jq -r '
  .messages[] | 
  select(.bot_id == "B0AE09WFSSJ") | 
  select(.text | test("approved|Approved"; "i")) | 
  .text
' | head -1)

if [ -n "$HAS_APPROVAL" ]; then
  echo "CLOSED"
  exit 0
fi

# Check 3: Any checkmark/done reaction from founders
FOUNDER_REACTION=$(echo "$THREAD_RESP" | jq -r '
  .messages[0].reactions[]? | 
  select(.name == "white_check_mark" or .name == "heavy_check_mark") | 
  select(.users[] | . == "UEHET2Q2G" or . == "UE0KTBS8P" or . == "UEJV57HQW" or . == "U05QMQHCVNY") | 
  .name
' | head -1)

if [ -n "$FOUNDER_REACTION" ]; then
  echo "CLOSED"
  exit 0
fi

# If none of the above
echo "OPEN"
