#!/bin/bash
# Check if a file path should be accessible from Slack groups

FILE_PATH="$1"
CONTEXT="${2:-unknown}"  # slack-group, slack-dm, telegram, webchat

# Protected files (personal/sensitive)
PROTECTED_PATTERNS=(
  "MEMORY.md"
  "USER.md"
  "SOUL.md"
  "IDENTITY.md"
  "AGENTS.md"
  "HEARTBEAT.md"
  "BOOTSTRAP.md"
  "memory/.*\.md"
  "memory/.*\.json"
  "memory/.*\.jsonl"
  "scripts/.*"
  "research/.*"
)

# If NOT from Slack group, allow everything
if [[ "$CONTEXT" != "slack-group" ]]; then
  exit 0  # Allowed
fi

# If from Slack group, check against protected patterns
for pattern in "${PROTECTED_PATTERNS[@]}"; do
  if [[ "$FILE_PATH" =~ $pattern ]]; then
    echo "BLOCKED: $FILE_PATH is protected from Slack groups"
    exit 1  # Denied
  fi
done

exit 0  # Allowed
