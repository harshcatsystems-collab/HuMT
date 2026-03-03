#!/bin/bash
# Telegram Topic Router — Routes messages to correct topic in workspace

WORKSPACE_FILE="/home/harsh/.openclaw/workspace/memory/telegram-workspace.json"
GROUP_ID=$(jq -r '.group_id' "$WORKSPACE_FILE")

# Topic ID lookup
get_topic_id() {
    local topic_key="$1"
    jq -r ".topics.${topic_key}.thread_id" "$WORKSPACE_FILE"
}

# Route message based on type/content
route_message() {
    local message_type="$1"
    local content="$2"
    
    case "$message_type" in
        # Daily scheduled
        "morning_brief"|"evening_debrief"|"calendar")
            echo "daily_ops"
            ;;
        
        # Domain-specific pulses
        "people_pulse"|"founder_pulse_people")
            echo "people_culture"
            ;;
        
        # Alerts by domain
        "metabase_trials"|"metabase_subs"|"metabase_revenue")
            echo "growth"
            ;;
        "metabase_engagement"|"metabase_churn"|"metabase_watch")
            echo "retention"
            ;;
        "payment_approval"|"finance_alert")
            echo "finance"
            ;;
        
        # Meeting prep
        "meeting_prep_growth"|"meeting_prep_nikhil")
            echo "growth"
            ;;
        "meeting_prep_retention"|"meeting_prep_vismit")
            echo "retention"
            ;;
        "meeting_prep_board"|"meeting_prep_investor")
            echo "strategy"
            ;;
        "meeting_prep_nisha"|"hiring")
            echo "people_culture"
            ;;
        "meeting_prep_pranay"|"meeting_prep_samir"|"product")
            echo "product_design"
            ;;
        "meeting_prep_nishita"|"research")
            echo "consumer_insights"
            ;;
        "content_pipeline"|"cms_alert"|"dialect")
            echo "content"
            ;;
        
        # Analysis deliverables
        "analysis_retention"|"analysis_m0"|"analysis_m1")
            echo "retention"
            ;;
        "analysis_growth"|"analysis_cac")
            echo "growth"
            ;;
        "analysis_content")
            echo "content"
            ;;
        "analysis_board"|"analysis_strategic")
            echo "strategy"
            ;;
        
        # Personal/misc
        "persona_review"|"memory_consolidation"|"personal")
            echo "personal"
            ;;
        
        # Catch-all
        *)
            echo "general"
            ;;
    esac
}

# Send message to topic
send_to_topic() {
    local topic_key="$1"
    local message="$2"
    local thread_id=$(get_topic_id "$topic_key")
    
    # Use message tool with thread_id
    echo "Routing to: $topic_key (thread: $thread_id)"
    # Actual send would use OpenClaw message tool or Telegram API
}

# Export for use in other scripts
export -f get_topic_id
export -f route_message
export -f send_to_topic
export GROUP_ID
export WORKSPACE_FILE
