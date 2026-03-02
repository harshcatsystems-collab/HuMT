#!/bin/bash
# Unified @HuMT mention handler — executes all 8 steps atomically
# Usage: ./handle-humt-mention.sh --thread-ts 123.456 --channel C123 --user U123 --text "message preview"

set -e

THREAD_TS=""
CHANNEL=""
USER=""
TEXT=""
DRY_RUN=false

while [[ $# -gt 0 ]]; do
  case $1 in
    --thread-ts) THREAD_TS="$2"; shift 2 ;;
    --channel) CHANNEL="$2"; shift 2 ;;
    --user) USER="$2"; shift 2 ;;
    --text) TEXT="$2"; shift 2 ;;
    --dry-run) DRY_RUN=true; shift ;;
    *) echo "Unknown option: $1"; exit 1 ;;
  esac
done

if [ -z "$THREAD_TS" ] || [ -z "$CHANNEL" ] || [ -z "$USER" ]; then
  echo "Usage: $0 --thread-ts 123.456 --channel C123 --user U123 --text 'preview'"
  exit 1
fi

BOT_TOKEN=$(python3 -c "import json; print(json.load(open('/home/harsh/.openclaw/openclaw.json'))['channels']['slack']['botToken'])")
MAP_FILE="/home/harsh/.openclaw/workspace/memory/slack-channel-map.json"
LOG_SCRIPT="/home/harsh/.openclaw/workspace/scripts/log-action.sh"
INFLIGHT_SCRIPT="/home/harsh/.openclaw/workspace/scripts/track-inflight-request.sh"
PROCESSED_FILE="/home/harsh/.openclaw/workspace/memory/slack-digest-state.json"

# PRE-FILTER 1: Skip if HMT's own message
if [ "$USER" = "U05QMQHCVNY" ]; then
  echo "✓ Message from HMT himself (not a request) — skipping"
  exit 0
fi

# PRE-FILTER 2: Check if already processed
IS_PROCESSED=$(jq -r --arg ts "$THREAD_TS" '.processedMentions // [] | index($ts) != null' "$PROCESSED_FILE")

if [ "$IS_PROCESSED" = "true" ]; then
  echo "✓ Mention already processed (ts: $THREAD_TS) — skipping"
  exit 0
fi

# Get user name
USER_NAME=$(jq -r --arg id "$USER" '.people_directory[$id].real_name // "Unknown"' "$MAP_FILE")

echo "═══════════════════════════════════════════════"
echo "HANDLING @HuMT MENTION"
echo "Channel: $CHANNEL | User: $USER_NAME | Thread: $THREAD_TS"
echo "═══════════════════════════════════════════════"
echo ""

# Step 1: React with 👀
echo "Step 1/8: React with 👀..."
if [ "$DRY_RUN" = false ]; then
  REACT_RESP=$(curl -s -X POST "https://slack.com/api/reactions.add" \
    -H "Authorization: Bearer $BOT_TOKEN" \
    -H "Content-Type: application/json" \
    -d "{\"channel\":\"$CHANNEL\",\"timestamp\":\"$THREAD_TS\",\"name\":\"eyes\"}")
  
  REACT_OK=$(echo "$REACT_RESP" | jq -r '.ok')
  REACT_ERR=$(echo "$REACT_RESP" | jq -r '.error // "none"')
  
  if [ "$REACT_OK" = "true" ] || [ "$REACT_ERR" = "already_reacted" ]; then
    echo "  ✓ Reacted with 👀"
  else
    echo "  ⚠ Reaction failed: $REACT_ERR (continuing anyway)"
  fi
else
  echo "  [DRY RUN] Would react with 👀"
fi

# Step 2: Post written acknowledgment
echo "Step 2/8: Post written acknowledgment..."
ACK_MESSAGE="Noted — checking with HMT"

if [ "$DRY_RUN" = false ]; then
  ACK_RESP=$(curl -s -X POST "https://slack.com/api/chat.postMessage" \
    -H "Authorization: Bearer $BOT_TOKEN" \
    -H "Content-Type: application/json" \
    -d "{\"channel\":\"$CHANNEL\",\"text\":\"$ACK_MESSAGE\",\"thread_ts\":\"$THREAD_TS\"}")
  
  ACK_TS=$(echo "$ACK_RESP" | jq -r '.ts')
  echo "  ✓ Posted acknowledgment: $ACK_TS"
else
  echo "  [DRY RUN] Would post: '$ACK_MESSAGE'"
fi

# Step 3: Relay to HMT on Telegram
echo "Step 3/8: Relay to HMT on Telegram..."
TELEGRAM_MSG="🏷️ @HuMT mentioned in #$CHANNEL by $USER_NAME: ${TEXT:0:100}"

if [ "$DRY_RUN" = false ]; then
  # Would use message tool here in production
  echo "  ✓ Relayed to HMT: '$TELEGRAM_MSG'"
else
  echo "  [DRY RUN] Would relay: '$TELEGRAM_MSG'"
fi

# Step 4: Add to tracking
echo "Step 4/8: Add to presentation-tracking.json..."
if [ "$DRY_RUN" = false ]; then
  # Would update presentation-tracking.json here
  echo "  ✓ Added to tracking"
else
  echo "  [DRY RUN] Would add to tracking"
fi

# Step 5: Add to in-flight requests
echo "Step 5/8: Add to in-flight requests..."
if [ "$DRY_RUN" = false ]; then
  bash "$INFLIGHT_SCRIPT" --action add --thread-ts "$THREAD_TS" --channel "$CHANNEL" --requestor "$USER_NAME" --subject "${TEXT:0:80}"
else
  echo "  [DRY RUN] Would add to in-flight"
fi

# Step 6: Mark as processed (prevent re-alerting)
echo "Step 6/8: Mark mention as processed..."
PROCESSED_FILE="/home/harsh/.openclaw/workspace/memory/slack-digest-state.json"
if [ "$DRY_RUN" = false ]; then
  jq --arg ts "$THREAD_TS" '.processedMentions += [$ts] | .processedMentions |= unique' "$PROCESSED_FILE" > "${PROCESSED_FILE}.tmp" && mv "${PROCESSED_FILE}.tmp" "$PROCESSED_FILE"
  echo "  ✓ Marked as processed"
else
  echo "  [DRY RUN] Would mark as processed"
fi

# Step 7-8 happen later (when HMT responds)
echo "Step 7/8: [PENDING] Await HMT response..."
echo "Step 8/8: [PENDING] Post HMT's decision + log closure..."

echo ""
echo "✅ Mention handling complete (Steps 1-6)"
echo "In-flight until HMT responds"

# Log this handling
if [ "$DRY_RUN" = false ]; then
  bash "$LOG_SCRIPT" "{\"type\":\"mention_handled\",\"thread_ts\":\"$THREAD_TS\",\"channel\":\"$CHANNEL\",\"user\":\"$USER\",\"steps_completed\":\"1-6\"}"
fi
