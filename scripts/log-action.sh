#!/bin/bash
# Atomic append to humt-actions.jsonl
# Usage: ./log-action.sh '{"type":"approval_posted", "channel":"C123", ...}'

set -e

ACTION_LOG="/home/harsh/.openclaw/workspace/memory/humt-actions.jsonl"
LOCK_FILE="/tmp/humt-actions.lock"

# Ensure log file exists
touch "$ACTION_LOG"

# Acquire lock (timeout 5s)
exec 200>"$LOCK_FILE"
flock -w 5 200 || { echo "ERROR: Could not acquire lock" >&2; exit 1; }

# Add timestamp if not present, then append
ENTRY="$1"
if ! echo "$ENTRY" | jq -e '.ts' >/dev/null 2>&1; then
  TS=$(date +%s)
  DATE=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
  ENTRY=$(echo "$ENTRY" | jq --arg ts "$TS" --arg date "$DATE" '. + {ts: ($ts|tonumber), date: $date}')
fi

# Validate JSON
echo "$ENTRY" | jq empty || { echo "ERROR: Invalid JSON" >&2; exit 1; }

# Append
echo "$ENTRY" >> "$ACTION_LOG"

# Release lock
flock -u 200

echo "Logged: $ENTRY"
