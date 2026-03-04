#!/bin/bash
# Wrapper to send messages to correct Telegram topic based on content type
# Usage: bash scripts/send-to-topic.sh <type> <message>
# Types: morning-brief, evening-debrief, email-triage, meeting-prep-growth, meeting-prep-retention, etc.

TYPE=$1
MESSAGE=$2

if [ -z "$TYPE" ] || [ -z "$MESSAGE" ]; then
    echo "Usage: bash scripts/send-to-topic.sh <type> <message>"
    exit 1
fi

cd /home/harsh/.openclaw/workspace

# Routing map
case "$TYPE" in
    morning-brief|evening-debrief|email-triage|healthcheck|capabilities|calendar-alert)
        TOPIC="daily_ops"
        ;;
    meeting-prep-growth|growth-pod|acquisition|trials|cac)
        TOPIC="growth"
        ;;
    meeting-prep-retention|engagement-pod|m0|m1|churn|lifecycle)
        TOPIC="retention"
        ;;
    meeting-prep-sprint|sprint-retro|sprint-start|product-review|design-review|hp-personalisation)
        TOPIC="product_design"
        ;;
    content-pipeline|cms-alert|regional-content|shows)
        TOPIC="content"
        ;;
    research|insights|field-study)
        TOPIC="consumer_insights"
        ;;
    people|hr|leave|appraisals|pip|culture)
        TOPIC="people_culture"
        ;;
    payment|invoice|budget|finance-alert)
        TOPIC="finance"
        ;;
    board|investors|strategy|series-b|fundraising)
        TOPIC="strategy"
        ;;
    personal|health|sick-leave|weekend)
        TOPIC="personal"
        ;;
    *)
        TOPIC="general"
        echo "Unknown type '$TYPE', routing to General" >&2
        ;;
esac

# Send to topic
bash scripts/send-telegram-topic.sh --topic "$TOPIC" --message "$MESSAGE"
