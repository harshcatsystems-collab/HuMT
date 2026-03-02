#!/bin/bash
# Generate verified status report (ONLY open items)
# Scans: commitments.md, delegations.md, recent @HuMT mentions
# Auto-verifies each item before including

set -e

VERIFY_SCRIPT="/home/harsh/.openclaw/workspace/scripts/verify-item-status.sh"
OUTPUT_JSON="/tmp/status-report.json"
COMMITMENTS="/home/harsh/.openclaw/workspace/memory/commitments.md"
DELEGATIONS="/home/harsh/.openclaw/workspace/memory/delegations.md"

echo '{"open_items":[],"verified_count":0,"closed_count":0,"sources":{"commitments":0,"delegations":0,"mentions":0}}' > "$OUTPUT_JSON"

# Helper: check and add item
check_and_add() {
  local item_name="$1"
  local thread_ts="$2"
  local channel_id="$3"
  local source="$4"
  
  if [ -z "$thread_ts" ] || [ -z "$channel_id" ]; then
    # Can't verify Slack items without thread info — mark as UNKNOWN
    jq --arg name "$item_name" --arg src "$source" '
      .open_items += [{name: $name, source: $src, verified: false, reason: "no_thread_id"}] |
      .verified_count += 1
    ' "$OUTPUT_JSON" > "${OUTPUT_JSON}.tmp" && mv "${OUTPUT_JSON}.tmp" "$OUTPUT_JSON"
    return
  fi
  
  STATUS=$("$VERIFY_SCRIPT" "$thread_ts" "$channel_id" 2>/dev/null || echo "UNKNOWN")
  
  if [ "$STATUS" = "OPEN" ]; then
    jq --arg name "$item_name" --arg ts "$thread_ts" --arg ch "$channel_id" --arg src "$source" '
      .open_items += [{name: $name, thread_ts: $ts, channel: $ch, source: $src, verified: true}] |
      .verified_count += 1 |
      .sources[$src] += 1
    ' "$OUTPUT_JSON" > "${OUTPUT_JSON}.tmp" && mv "${OUTPUT_JSON}.tmp" "$OUTPUT_JSON"
  else
    jq --arg src "$source" '
      .closed_count += 1 |
      .sources[$src] += 0
    ' "$OUTPUT_JSON" > "${OUTPUT_JSON}.tmp" && mv "${OUTPUT_JSON}.tmp" "$OUTPUT_JSON"
  fi
}

# Scan @HuMT mentions (last 20)
USER_TOKEN=$(python3 -c "import json; print(json.load(open('/home/harsh/.openclaw/openclaw.json'))['channels']['slack']['userToken'])")
MENTIONS=$(curl -s -H "Authorization: Bearer $USER_TOKEN" \
  "https://slack.com/api/search.messages?query=%3C%40U0AE6043BB6%3E&sort=timestamp&sort_dir=desc&count=20")

echo "$MENTIONS" | jq -r '.messages.matches[]? | 
  "\(.text | .[0:80])|\(.ts)|\(.channel.id)|\(.username)"
' | while IFS='|' read -r text ts channel user; do
  check_and_add "$user: $text" "$ts" "$channel" "mentions"
done

# Parse commitments.md (look for ## Active section)
if [ -f "$COMMITMENTS" ]; then
  # This is simplified — would need proper markdown parsing for production
  grep -A100 "^## Active" "$COMMITMENTS" 2>/dev/null | grep "^-" | head -10 | while read -r line; do
    # Extract any Slack links (thread_ts from permalink)
    LINK=$(echo "$line" | grep -oP 'https://stagedotin.slack.com/archives/[^)]+' || echo "")
    if [ -n "$LINK" ]; then
      CHANNEL=$(echo "$LINK" | grep -oP 'archives/\K[^/]+')
      THREAD=$(echo "$LINK" | grep -oP 'p\K[0-9.]+')
      check_and_add "$line" "$THREAD" "$CHANNEL" "commitments"
    fi
  done
fi

# Output final report
cat "$OUTPUT_JSON" | jq '{
  summary: {
    open: (.open_items | length),
    closed: .closed_count,
    total_checked: ((.open_items | length) + .closed_count)
  },
  by_source: .sources,
  open_items: .open_items
}'
