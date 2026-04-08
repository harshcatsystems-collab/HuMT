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
    exit 1
fi

BOT_TOKEN=$(python3 -c "import json; print(json.load(open('/home/harsh/.openclaw/openclaw.json'))['channels']['slack']['botToken'])")

# STEP 1: React with 👀 (silent)
curl -s -X POST "https://slack.com/api/reactions.add" \
  -H "Authorization: Bearer $BOT_TOKEN" \
  -H "Content-Type: application/json" \
  -d "{\"channel\":\"$CHANNEL\",\"timestamp\":\"$THREAD_TS\",\"name\":\"eyes\"}" > /dev/null

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

# STEP 3: Post written acknowledgment in thread (silent)
curl -s -X POST "https://slack.com/api/chat.postMessage" \
  -H "Authorization: Bearer $BOT_TOKEN" \
  -H "Content-Type: application/json; charset=utf-8" \
  --data-raw "{\"channel\":\"$CHANNEL\",\"thread_ts\":\"$THREAD_TS\",\"text\":\"<@$USER_ID> Noted — checking with HMT.\"}" > /dev/null

# STEP 4: Relay to HMT on Telegram
CHANNEL_NAME=$(python3 -c "
import json, os
try:
    data = json.load(open('memory/slack-bot-channels.json'))
    print(data.get('$CHANNEL', '$CHANNEL'))
except:
    print('$CHANNEL')
")

# Route to correct Telegram topic based on channel
case "$CHANNEL" in
  C08PGK8CM32) TOPIC="finance" ;;         # #finance-department
  C06L5FQL3GU) TOPIC="finance" ;;         # #credit_card_invoices
  C080EJU9873) TOPIC="growth" ;;          # #growth-pod
  C0A3N67V0G2) TOPIC="retention" ;;       # #retention-pod
  C092XDNSDB9) TOPIC="retention" ;;       # #full-funnel-solver
  CEHPPGSN9)   TOPIC="daily_ops" ;;       # #tech-mates
  C082Z8FUBRV) TOPIC="people_culture" ;;  # #all-things-people-and-culture
  C086EJ905FB) TOPIC="people_culture" ;;  # #team-hr
  C035F6W8DK9) TOPIC="product_design" ;;  # #product-design
  CEWV0GMMG)   TOPIC="product_design" ;;  # #product
  C08HQ89S797) TOPIC="content" ;;         # #content_strategy
  C08PY53QYSU) TOPIC="content" ;;         # #ai-at-stage
  GEJUR0WA2)   TOPIC="strategy" ;;        # #founders_sync
  *)            TOPIC="daily_ops" ;;      # default
esac

bash scripts/send-telegram-topic.sh --topic "$TOPIC" --message "🏷️ @HuMT tagged in #$CHANNEL_NAME by $USER_NAME

${TEXT:0:200}

Thread: https://stagedotin.slack.com/archives/$CHANNEL/p${THREAD_TS//.}" > /dev/null 2>&1

# STEP 5: Add to tracking + mark processed
export _HUMT_CHANNEL="$CHANNEL"
export _HUMT_THREAD_TS="$THREAD_TS"
python3 - << 'PYEOF'
import json, os, sys

channel = os.environ.get('_HUMT_CHANNEL', '')
thread_ts = os.environ.get('_HUMT_THREAD_TS', '')

# Tracking
tracking_file = 'memory/presentation-tracking.json'
try:
    with open(tracking_file) as f:
        tracking = json.load(f)
except:
    tracking = {'threads': []}

thread_key = f"{channel}:{thread_ts}"
if thread_key not in [t.get('key') for t in tracking.get('threads', [])]:
    tracking.setdefault('threads', []).append({
        'key': thread_key,
        'channel': channel,
        'thread_ts': thread_ts,
        'added_at': __import__('datetime').datetime.utcnow().isoformat() + 'Z',
        'context': 'HuMT mentioned'
    })
    with open(tracking_file, 'w') as f:
        json.dump(tracking, f, indent=2)

# Mark processed
state_file = 'memory/slack-digest-state.json'
try:
    with open(state_file) as f:
        state = json.load(f)
except:
    state = {}

processed = set(state.get('processedMentions', []))
processed.add(thread_ts)
state['processedMentions'] = list(processed)[-100:]

with open(state_file, 'w') as f:
    json.dump(state, f, indent=2)
PYEOF
