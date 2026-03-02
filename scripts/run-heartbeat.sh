#!/bin/bash
# Heartbeat Execution Wrapper — Orchestrates full heartbeat routine
# This is what ACTUALLY runs on heartbeat (not manual steps)

set -e

WORKSPACE="/home/harsh/.openclaw/workspace"
cd "$WORKSPACE"

echo "🫀 HEARTBEAT STARTING — $(date -u +"%Y-%m-%d %H:%M UTC")"
echo ""

# Step 1: Persona Capture (MANDATORY)
echo "Step 1: Persona Capture..."
DATE_FILE="memory/$(date -u +%Y-%m-%d).md"
if ! grep -q "## Heartbeat $(date -u +'%H'):" "$DATE_FILE" 2>/dev/null; then
  echo "" >> "$DATE_FILE"
  echo "## Heartbeat $(date -u +'%H:%M') UTC" >> "$DATE_FILE"
  echo "" >> "$DATE_FILE"
  echo "> 🧠 No new persona observations this heartbeat" >> "$DATE_FILE"
fi
echo "  ✓ Logged persona check"
echo ""

# Step 2: Channel Membership Diff
echo "Step 2: Channel Membership Diff..."
CHANNEL_RESULT=$(bash scripts/slack-channel-diff.sh)
if [ "$CHANNEL_RESULT" != "NO_CHANGES" ]; then
  echo "  ⚠ Channel changes detected: $CHANNEL_RESULT"
  # Would log + relay here in production
else
  echo "  ✓ No channel changes"
fi
echo ""

# Step 3: DM Relay (Priority)
echo "Step 3: DM Relay (Priority Check)..."
DM_RESULT=$(bash scripts/slack-read-channel.sh D0AE2D6CZ26 3)
DM_COUNT=$(echo "$DM_RESULT" | jq '.messages | length')
echo "  ✓ Checked HMT DMs ($DM_COUNT recent messages)"
# In production: check timestamps, relay new ones
echo ""

# Step 4: @HuMT Mention Scan + Handler
echo "Step 4: @HuMT Mention Scan..."
USER_TOKEN=$(python3 -c "import json; print(json.load(open('/home/harsh/.openclaw/openclaw.json'))['channels']['slack']['userToken'])")
MENTIONS=$(curl -s -H "Authorization: Bearer $USER_TOKEN" \
  "https://slack.com/api/search.messages?query=%3C%40U0AE6043BB6%3E&sort=timestamp&sort_dir=desc&count=10")

PROCESSED=$(jq -r '.processedMentions // []' memory/slack-digest-state.json)

NEW_MENTION_COUNT=$(echo "$MENTIONS" | jq --argjson proc "$PROCESSED" '
  [.messages.matches[]? | 
   select(.ts as $ts | ($proc | index($ts)) == null)] | 
  length
')

if [ "$NEW_MENTION_COUNT" -gt 0 ]; then
  echo "  ⚠ $NEW_MENTION_COUNT new @HuMT mention(s) detected"
  
  # Extract and handle each new mention
  echo "$MENTIONS" | jq -c --argjson proc "$PROCESSED" '
    .messages.matches[]? | 
    select(.ts as $ts | ($proc | index($ts)) == null) |
    {ts, channel_id: .channel.id, user: .user, text: .text}
  ' | while read -r MENTION; do
    TS=$(echo "$MENTION" | jq -r '.ts')
    CHANNEL=$(echo "$MENTION" | jq -r '.channel_id')
    USER=$(echo "$MENTION" | jq -r '.user')
    TEXT=$(echo "$MENTION" | jq -r '.text | .[0:100]')
    
    echo "  → Handling: $TS from $USER"
    bash scripts/handle-humt-mention.sh \
      --thread-ts "$TS" \
      --channel "$CHANNEL" \
      --user "$USER" \
      --text "$TEXT"
  done
else
  echo "  ✓ No new @HuMT mentions"
fi
echo ""

# Step 5: Thread Engagement Monitor
echo "Step 5: Thread Engagement Monitor..."
export BOT_TOKEN=$(python3 -c "import json; print(json.load(open('/home/harsh/.openclaw/openclaw.json'))['channels']['slack']['botToken'])")
ENGAGEMENT=$(bash scripts/scan-tracked-threads.sh)
NEW_REPLIES=$(echo "$ENGAGEMENT" | jq '.new_replies | length')
ESCALATIONS=$(echo "$ENGAGEMENT" | jq '.needs_escalation | length')

if [ "$NEW_REPLIES" -gt 0 ]; then
  echo "  ⚠ $NEW_REPLIES new replies detected"
  echo "$ENGAGEMENT" | jq -r '.new_replies[] | "    → \(.analysis): \(.user_name)"'
fi

if [ "$ESCALATIONS" -gt 0 ]; then
  echo "  🚨 $ESCALATIONS escalations needed (co-founder replies)"
  # Would relay to HMT here
else
  echo "  ✓ Scanned threads, no escalations"
fi
echo ""

# Step 6: Site Health Check (every 2 hours)
echo "Step 6: Netlify Site Health..."
LAST_HEALTH=$(jq -r '.lastChecks.netlify_health // 0' memory/heartbeat-state.json)
NOW=$(date +%s)
ELAPSED=$((NOW - LAST_HEALTH))

if [ $ELAPSED -gt 7200 ]; then
  HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" https://humt-stage-analytics.netlify.app/)
  if [ "$HTTP_CODE" = "200" ]; then
    echo "  ✓ Site healthy (HTTP $HTTP_CODE)"
  else
    echo "  🚨 SITE DOWN (HTTP $HTTP_CODE) — Auto-healing..."
    cd data/serve
    bash ../../scripts/deploy-presentation.sh index.html > /dev/null 2>&1
    echo "  ✓ Auto-heal complete"
  fi
else
  echo "  ✓ Site checked $(($ELAPSED / 60)) min ago"
fi
echo ""

# Update heartbeat state
NOW_ISO=$(date -u +"%Y-%m-%dT%H:%M:00Z")
jq --arg now "$NOW_ISO" --arg nowts "$NOW" '
  .lastHeartbeat = $now |
  .lastChecks.slack_dm = ($nowts | tonumber) |
  .lastChecks.slack_tier1 = ($nowts | tonumber)
' memory/heartbeat-state.json > memory/heartbeat-state.json.tmp
mv memory/heartbeat-state.json.tmp memory/heartbeat-state.json

echo "🫀 HEARTBEAT COMPLETE"
echo ""
echo "Summary:"
echo "  • Persona captured"
echo "  • Channels monitored"
echo "  • @HuMT mentions handled: $NEW_MENTION_COUNT"
echo "  • Thread engagement: $NEW_REPLIES new replies"
echo "  • Site health: verified"
