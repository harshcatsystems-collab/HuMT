#!/bin/bash
# Relay HMT's approval/decision back to Slack thread
# Usage: bash scripts/slack-approval-relay.sh --thread-ts <ts> --channel <id> --user <id> --message "<decision>"

cd /home/harsh/.openclaw/workspace

# Parse args
while [[ $# -gt 0 ]]; do
    case $1 in
        --thread-ts) THREAD_TS="$2"; shift 2 ;;
        --channel) CHANNEL="$2"; shift 2 ;;
        --user) USER_ID="$2"; shift 2 ;;
        --message) MESSAGE="$2"; shift 2 ;;
        --user-name) USER_NAME="$2"; shift 2 ;;  # Optional, will lookup if missing
        *) shift ;;
    esac
done

if [ -z "$THREAD_TS" ] || [ -z "$CHANNEL" ] || [ -z "$USER_ID" ] || [ -z "$MESSAGE" ]; then
    echo "Usage: --thread-ts <ts> --channel <id> --user <id> --message <text>"
    exit 1
fi

BOT_TOKEN=$(python3 -c "import json; print(json.load(open('/home/harsh/.openclaw/openclaw.json'))['channels']['slack']['botToken'])")

# Lookup user's real ID if name was provided
if [ -z "$USER_NAME" ]; then
    # Verify user ID is valid
    VERIFIED_ID=$(curl -s -H "Authorization: Bearer $BOT_TOKEN" \
      "https://slack.com/api/users.info?user=$USER_ID" | python3 -c "
import json, sys
d = json.load(sys.stdin)
if d.get('ok'):
    print(d['user']['id'])
else:
    print('INVALID')
")
    
    if [ "$VERIFIED_ID" = "INVALID" ]; then
        echo "❌ User ID $USER_ID is invalid"
        exit 1
    fi
fi

# Post approval in thread
echo "Posting approval to thread $THREAD_TS..."

RESPONSE=$(curl -s -X POST "https://slack.com/api/chat.postMessage" \
  -H "Authorization: Bearer $BOT_TOKEN" \
  -H "Content-Type: application/json; charset=utf-8" \
  --data-raw "{\"channel\":\"$CHANNEL\",\"thread_ts\":\"$THREAD_TS\",\"text\":\"<@$USER_ID> — $MESSAGE\"}")

SUCCESS=$(echo "$RESPONSE" | python3 -c "import json,sys; d=json.load(sys.stdin); print(d.get('ok', False))")

if [ "$SUCCESS" = "True" ]; then
    MSG_TS=$(echo "$RESPONSE" | python3 -c "import json,sys; print(json.load(sys.stdin).get('ts', '?'))")
    THREAD_CHECK=$(echo "$RESPONSE" | python3 -c "import json,sys; print(json.load(sys.stdin).get('message', {}).get('thread_ts', 'NONE'))")
    
    echo "✅ Posted successfully"
    echo "   Message TS: $MSG_TS"
    echo "   In thread: $THREAD_CHECK"
    
    # Log to action tracking
    python3 << PYEOF
import json, os
from datetime import datetime

log_file = 'memory/humt-actions.jsonl'

action = {
    'timestamp': datetime.utcnow().isoformat() + 'Z',
    'type': 'approval_posted',
    'channel': '$CHANNEL',
    'thread_ts': '$THREAD_TS',
    'message_ts': '$MSG_TS',
    'user': '$USER_ID',
    'action': '$(echo "$MESSAGE" | head -c 50)',
    'status': 'posted'
}

with open(log_file, 'a') as f:
    f.write(json.dumps(action) + '\n')

print('  ✅ Logged to humt-actions.jsonl')
PYEOF
else:
    ERROR=$(echo "$RESPONSE" | python3 -c "import json,sys; print(json.load(sys.stdin).get('description', 'unknown'))")
    echo "❌ Failed: $ERROR"
    exit 1
fi
