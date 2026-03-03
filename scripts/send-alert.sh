#!/bin/bash
# Unified alert sender — routes to correct Telegram topic

usage() {
    echo "Usage: bash send-alert.sh --type <alert_type> --message <text>"
    echo ""
    echo "Alert types → Topic routing:"
    echo "  payment_approval → Finance"
    echo "  slack_dm → General (or domain-specific if can determine)"
    echo "  metabase_trials, metabase_subs, metabase_revenue → Growth"
    echo "  metabase_engagement, metabase_churn → Retention"
    echo "  meeting_reminder → Daily Ops"
    echo "  urgent → General (fallback)"
    exit 1
}

# Source router functions
source /home/harsh/.openclaw/workspace/scripts/telegram-router.sh

# Parse args
ALERT_TYPE=""
MESSAGE=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --type) ALERT_TYPE="$2"; shift 2 ;;
        --message) MESSAGE="$2"; shift 2 ;;
        *) echo "Unknown: $1"; usage ;;
    esac
done

if [ -z "$ALERT_TYPE" ] || [ -z "$MESSAGE" ]; then
    usage
fi

# Route to topic
TOPIC_KEY=$(route_message "$ALERT_TYPE" "$MESSAGE")
THREAD_ID=$(get_topic_id "$TOPIC_KEY")

echo "Routing $ALERT_TYPE → $TOPIC_KEY (thread $THREAD_ID)"

# Send message
BOT_TOKEN=$(python3 -c "import json; print(json.load(open('/home/harsh/.openclaw/openclaw.json'))['channels']['telegram']['botToken'])")

curl -s -X POST "https://api.telegram.org/bot${BOT_TOKEN}/sendMessage" \
  -H "Content-Type: application/json" \
  -d "{
    \"chat_id\": \"${GROUP_ID}\",
    \"message_thread_id\": ${THREAD_ID},
    \"text\": \"${MESSAGE}\",
    \"parse_mode\": \"Markdown\"
  }" | jq -r '{ok: .ok, message_id: .result.message_id, error: .description}'
