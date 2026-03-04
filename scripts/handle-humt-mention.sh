#!/bin/bash
# Unified @HuMT mention handler
# Called when @HuMT is detected in Slack
# Executes all 5 steps atomically without creating agent turns
# Usage: bash scripts/handle-humt-mention.sh --thread-ts <ts> --channel <channel> --user <user_id> --text "<preview>"

cd /home/harsh/.openclaw/workspace

# Parse args
while [[ $# -gt 0 ]]; do
    case $1 in
        --thread-ts) THREAD_TS="$2"; shift 2 ;;
        --channel) CHANNEL="$2"; shift 2 ;;
        --user) USER_ID="$2"; shift 2 ;;
        --text) TEXT="$2"; shift 2 ;;
        *) shift ;;
    esac
done

if [ -z "$THREAD_TS" ] || [ -z "$CHANNEL" ] || [ -z "$USER_ID" ]; then
    echo "Usage: --thread-ts <ts> --channel <id> --user <id> --text <preview>"
    exit 1
fi

BOT_TOKEN=$(python3 -c "import json; print(json.load(open('/home/harsh/.openclaw/openclaw.json'))['channels']['slack']['botToken'])")

echo "=== HANDLING @HuMT MENTION ==="
echo "Channel: $CHANNEL"
echo "Thread: $THREAD_TS"
echo "User: $USER_ID"
echo ""

# STEP 1: React with 👀
echo "Step 1: Reacting with 👀..."
curl -s -X POST "https://slack.com/api/reactions.add" \
  -H "Authorization: Bearer $BOT_TOKEN" \
  -H "Content-Type: application/json" \
  -d "{\"channel\":\"$CHANNEL\",\"timestamp\":\"$THREAD_TS\",\"name\":\"eyes\"}" | python3 -c "
import json, sys
d = json.load(sys.stdin)
if d.get('ok') or d.get('error') == 'already_reacted':
    print('  ✅ Reacted')
else:
    print(f\"  ⚠️ {d.get('error')}\")
"

# STEP 2: Look up user's real name
USER_NAME=$(curl -s -H "Authorization: Bearer $BOT_TOKEN" \
  "https://slack.com/api/users.info?user=$USER_ID" | python3 -c "
import json, sys
d = json.load(sys.stdin)
if d.get('ok'):
    print(d['user']['real_name'])
else:
    print('Unknown User')
")

# STEP 2: Post written acknowledgment
echo "Step 2: Posting acknowledgment..."
curl -s -X POST "https://slack.com/api/chat.postMessage" \
  -H "Authorization: Bearer $BOT_TOKEN" \
  -H "Content-Type: application/json; charset=utf-8" \
  --data-raw "{\"channel\":\"$CHANNEL\",\"thread_ts\":\"$THREAD_TS\",\"text\":\"<@$USER_ID> Noted — checking with HMT.\"}" | python3 -c "
import json, sys
d = json.load(sys.stdin)
if d.get('ok'):
    print(f\"  ✅ Posted: {d.get('ts')}\")
else:
    print(f\"  ❌ {d.get('error')}\")
"

# STEP 3: Relay to HMT on Telegram
echo "Step 3: Relaying to HMT..."
CHANNEL_NAME=$(python3 -c "
import json
baseline = json.load(open('memory/slack-bot-channels.json'))
print(baseline.get('$CHANNEL', '?'))
")

bash scripts/send-telegram-topic.sh --topic general --message "🏷️ @HuMT mentioned in #$CHANNEL_NAME by $USER_NAME

Preview: ${TEXT:0:150}

Thread: https://stagedotin.slack.com/archives/$CHANNEL/p${THREAD_TS//.}" | python3 -c "
import json, sys
d = json.load(sys.stdin)
if d.get('ok'):
    print('  ✅ Relayed to Telegram')
else:
    print(f\"  ❌ {d.get('error')}\")
"

# STEP 4: Add to presentation tracking
echo "Step 4: Adding to tracking..."
python3 << PYEOF
import json, os

tracking_file = 'memory/presentation-tracking.json'
if os.path.exists(tracking_file):
    with open(tracking_file) as f:
        tracking = json.load(f)
else:
    tracking = {'threads': []}

# Add this thread if not already tracked
thread_key = f"$CHANNEL:{$THREAD_TS}"
if thread_key not in [t.get('key') for t in tracking.get('threads', [])]:
    tracking['threads'].append({
        'key': thread_key,
        'channel': '$CHANNEL',
        'thread_ts': '$THREAD_TS',
        'added_at': '$(date -u +%Y-%m-%dT%H:%M:%SZ)',
        'context': 'HuMT mentioned'
    })
    
    with open(tracking_file, 'w') as f:
        json.dump(tracking, f, indent=2)
    print('  ✅ Added to tracking')
else:
    print('  ℹ️ Already tracked')
PYEOF

# STEP 5: Mark as processed (prevent re-alerting)
echo "Step 5: Marking processed..."
python3 << PYEOF
import json, os

state_file = 'memory/slack-digest-state.json'
if os.path.exists(state_file):
    with open(state_file) as f:
        state = json.load(f)
else:
    state = {}

processed = set(state.get('processedMentions', []))
processed.add('$THREAD_TS')
state['processedMentions'] = list(processed)[-100:]  # Keep last 100

with open(state_file, 'w') as f:
    json.dump(state, f, indent=2)
print('  ✅ Marked processed')
PYEOF

echo ""
echo "✅ All 5 steps complete"
echo ""
echo "Next: Wait for HMT's decision, then call this script again with:"
echo "  bash scripts/slack-approval-relay.sh --thread-ts $THREAD_TS --channel $CHANNEL --user $USER_ID --message '<approval>'"
