#!/bin/bash
# Pre-send filter for Slack messages
# Blocks messages containing process noise/thinking before they post
# Usage: bash scripts/slack-post-filter.sh "<message_text>"
# Exit code: 0 if safe, 1 if contains leak patterns

MESSAGE="$1"

# Leak patterns (case-insensitive)
LEAK_PATTERNS=(
    "I need to relay"
    "Let me do that"
    "I'll relay this"
    "I should"
    "checking with HMT"
    "conversations.history"
    "conversations.list"
    "Subagent.*finished"
    "✓.*agent"
    "API error"
    "Parse error"
    "executing"
    "calling tool"
)

# Check each pattern
for pattern in "${LEAK_PATTERNS[@]}"; do
    if echo "$MESSAGE" | grep -qiE "$pattern"; then
        echo "🚨 LEAK DETECTED: Message contains '$pattern'"
        echo "Message preview: ${MESSAGE:0:100}"
        exit 1
    fi
done

# Safe to send
exit 0
