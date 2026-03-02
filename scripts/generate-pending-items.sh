#!/bin/bash
# Generate list of OPEN items with automatic verification
# Scans commitments.md, delegations.md, and recent @HuMT mentions
# Returns ONLY verified-open items

set -e

VERIFY_SCRIPT="/home/harsh/.openclaw/workspace/scripts/verify-item-status.sh"
OUTPUT_JSON="/tmp/pending-items.json"

echo '{"pending_items": [], "verified_count": 0, "closed_count": 0}' > "$OUTPUT_JSON"

# Function to check and add item
check_and_add() {
  local item_name="$1"
  local thread_ts="$2"
  local channel_id="$3"
  local source="$4"
  
  if [ -z "$thread_ts" ] || [ -z "$channel_id" ]; then
    # Can't verify without thread info — skip
    return
  fi
  
  STATUS=$("$VERIFY_SCRIPT" "$thread_ts" "$channel_id" 2>/dev/null || echo "UNKNOWN")
  
  if [ "$STATUS" = "OPEN" ]; then
    # Add to pending list
    jq --arg name "$item_name" --arg ts "$thread_ts" --arg ch "$channel_id" --arg src "$source" '
      .pending_items += [{name: $name, thread_ts: $ts, channel: $ch, source: $src}] |
      .verified_count += 1
    ' "$OUTPUT_JSON" > "${OUTPUT_JSON}.tmp" && mv "${OUTPUT_JSON}.tmp" "$OUTPUT_JSON"
  else
    # Increment closed count
    jq '.closed_count += 1' "$OUTPUT_JSON" > "${OUTPUT_JSON}.tmp" && mv "${OUTPUT_JSON}.tmp" "$OUTPUT_JSON"
  fi
}

# Scan recent @HuMT mentions (last 20)
USER_TOKEN=$(python3 -c "import json; print(json.load(open('/home/harsh/.openclaw/openclaw.json'))['channels']['slack']['userToken'])")
MENTIONS=$(curl -s -H "Authorization: Bearer $USER_TOKEN" \
  "https://slack.com/api/search.messages?query=%3C%40U0AE6043BB6%3E&sort=timestamp&sort_dir=desc&count=20")

echo "$MENTIONS" | jq -r '.messages.matches[] | 
  "\(.text | .[0:80])|\(.ts)|\(.channel.id)|\(.username)"
' | while IFS='|' read -r text ts channel user; do
  check_and_add "$user: $text" "$ts" "$channel" "@HuMT_mention"
done

# Output final list
cat "$OUTPUT_JSON"
