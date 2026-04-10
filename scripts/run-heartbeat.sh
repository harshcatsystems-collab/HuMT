#!/bin/bash
# Heartbeat Execution Wrapper — Orchestrates full heartbeat routine
# SILENT: zero stdout. All output suppressed. No leaks possible.

WORKSPACE="/home/harsh/.openclaw/workspace"
cd "$WORKSPACE"

# Step 1: Persona Capture — log stub to daily file
DATE_FILE="memory/$(date -u +%Y-%m-%d).md"
if ! grep -q "## Heartbeat $(date -u +'%H'):" "$DATE_FILE" 2>/dev/null; then
  echo "" >> "$DATE_FILE"
  echo "## Heartbeat $(date -u +'%H:%M') UTC" >> "$DATE_FILE"
  echo "" >> "$DATE_FILE"
  echo "> 🧠 No new persona observations this heartbeat" >> "$DATE_FILE"
fi

# Step 2: Channel Membership Diff
bash scripts/slack-channel-diff.sh > /dev/null 2>&1

# Step 3: DM Relay (Priority)
bash scripts/slack-read-channel.sh D0AE2D6CZ26 3 > /dev/null 2>&1

# Step 4: @HuMT Mention Scan + Handler
USER_TOKEN=$(python3 -c "import json; print(json.load(open('/home/harsh/.openclaw/openclaw.json'))['channels']['slack']['userToken'])" 2>/dev/null)
MENTIONS=$(curl -s -H "Authorization: Bearer $USER_TOKEN" \
  "https://slack.com/api/search.messages?query=%3C%40U0AE6043BB6%3E&sort=timestamp&sort_dir=desc&count=10" 2>/dev/null)

PROCESSED=$(jq -r '.processedMentions // []' memory/slack-digest-state.json 2>/dev/null || echo "[]")

NEW_MENTION_COUNT=$(echo "$MENTIONS" | jq --argjson proc "$PROCESSED" '
  [.messages.matches[]? |
   select(.ts as $ts | ($proc | index($ts)) == null)] |
  length
' 2>/dev/null || echo "0")

if [ "$NEW_MENTION_COUNT" -gt 0 ] 2>/dev/null; then
  echo "$MENTIONS" | jq -c --argjson proc "$PROCESSED" '
    .messages.matches[]? |
    select(.ts as $ts | ($proc | index($ts)) == null) |
    {ts, channel_id: .channel.id, user: .user, text: .text}
  ' 2>/dev/null | while read -r MENTION; do
    TS=$(echo "$MENTION" | jq -r '.ts')
    CHANNEL=$(echo "$MENTION" | jq -r '.channel_id')
    USER=$(echo "$MENTION" | jq -r '.user')
    TEXT=$(echo "$MENTION" | jq -r '.text | .[0:200]')
    bash scripts/handle-humt-mention.sh \
      --thread-ts "$TS" \
      --channel "$CHANNEL" \
      --user "$USER" \
      --text "$TEXT" > /dev/null 2>&1
  done
fi

# Step 5: Thread Engagement Monitor
export BOT_TOKEN=$(python3 -c "import json; print(json.load(open('/home/harsh/.openclaw/openclaw.json'))['channels']['slack']['botToken'])" 2>/dev/null)
bash scripts/scan-tracked-threads.sh > /dev/null 2>&1

# Step 6: Netlify Site Health (every 2 hours)
LAST_HEALTH=$(jq -r '.lastChecks.netlify_health // 0' memory/heartbeat-state.json 2>/dev/null || echo "0")
NOW=$(date +%s)
ELAPSED=$((NOW - LAST_HEALTH))

if [ "$ELAPSED" -gt 7200 ]; then
  HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" https://humt-stage-analytics.netlify.app/ 2>/dev/null)
  if [ "$HTTP_CODE" != "200" ]; then
    cd data/serve
    bash ../../scripts/deploy-presentation.sh index.html > /dev/null 2>&1
    cd "$WORKSPACE"
  fi
fi

# Update heartbeat state
NOW_ISO=$(date -u +"%Y-%m-%dT%H:%M:00Z")
jq --arg now "$NOW_ISO" --arg nowts "$NOW" '
  .lastHeartbeat = $now |
  .lastChecks.slack_dm = ($nowts | tonumber) |
  .lastChecks.slack_tier1 = ($nowts | tonumber)
' memory/heartbeat-state.json > memory/heartbeat-state.json.tmp 2>/dev/null && \
mv memory/heartbeat-state.json.tmp memory/heartbeat-state.json 2>/dev/null

exit 0
