#!/bin/bash
# Send message to specific Telegram topic via OpenClaw message tool

WORKSPACE_FILE="/home/harsh/.openclaw/workspace/memory/telegram-workspace.json"
GROUP_ID=$(jq -r '.group_id' "$WORKSPACE_FILE")

usage() {
    echo "Usage: bash send-telegram-topic.sh --topic <topic_key> --message <text>"
    echo ""
    echo "Topic keys:"
    echo "  general, daily_ops, growth, retention, content,"
    echo "  consumer_insights, people_culture, product_design,"
    echo "  finance, strategy, personal"
    exit 1
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --topic)
            TOPIC_KEY="$2"
            shift 2
            ;;
        --message)
            MESSAGE="$2"
            shift 2
            ;;
        *)
            echo "Unknown argument: $1"
            usage
            ;;
    esac
done

if [ -z "$TOPIC_KEY" ] || [ -z "$MESSAGE" ]; then
    usage
fi

# Get thread ID for topic
THREAD_ID=$(jq -r ".topics.${TOPIC_KEY}.thread_id" "$WORKSPACE_FILE")

# General topic uses main chat (no thread_id)
if [ "$THREAD_ID" = "null" ]; then
    if [ "$TOPIC_KEY" = "general" ]; then
        THREAD_ID=""  # Empty for main chat
    else
        echo "Error: Unknown topic key: $TOPIC_KEY"
        exit 1
    fi
fi

# Send via Telegram API
BOT_TOKEN=$(python3 -c "import json; print(json.load(open('/home/harsh/.openclaw/openclaw.json'))['channels']['telegram']['botToken'])")

# Build request data
if [ -n "$THREAD_ID" ]; then
    # Send to specific topic
    curl -s -X POST "https://api.telegram.org/bot${BOT_TOKEN}/sendMessage" \
      -d "chat_id=${GROUP_ID}" \
      -d "message_thread_id=${THREAD_ID}" \
      -d "text=${MESSAGE}" \
      -d "parse_mode=Markdown" | jq -r '{ok: .ok, message_id: .result.message_id, error: .description}'
else
    # Send to main chat (General)
    curl -s -X POST "https://api.telegram.org/bot${BOT_TOKEN}/sendMessage" \
      -d "chat_id=${GROUP_ID}" \
      -d "text=${MESSAGE}" \
      -d "parse_mode=Markdown" | jq -r '{ok: .ok, message_id: .result.message_id, error: .description}'
fi
