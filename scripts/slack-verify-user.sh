#!/bin/bash
# Verify Slack user ID by name
# Usage: ./slack-verify-user.sh "Saloni Goyal"

set -e

NAME="$1"
MAP_FILE="/home/harsh/.openclaw/workspace/memory/slack-channel-map.json"

if [ -z "$NAME" ]; then
  echo "Usage: $0 \"User Name\""
  exit 1
fi

# Load bot token from openclaw.json
BOT_TOKEN=$(python3 -c "import json; print(json.load(open('/home/harsh/.openclaw/openclaw.json'))['channels']['slack']['botToken'])")

# Check if user exists in our map
USER_ID=$(jq -r --arg name "$NAME" '
  .people_directory // {} | 
  to_entries[] | 
  select(.value.real_name == $name or .value.name == $name) | 
  .key
' "$MAP_FILE" | head -1)

if [ -n "$USER_ID" ]; then
  echo "$USER_ID"
  exit 0
fi

# Not in map — fetch from API
RESPONSE=$(curl -s -H "Authorization: Bearer $BOT_TOKEN" "https://slack.com/api/users.list")

# Extract user_id matching the name
USER_ID=$(echo "$RESPONSE" | jq -r --arg name "$NAME" '
  .members[] | 
  select(.deleted == false) |
  select(.real_name == $name or .name == $name or .profile.display_name == $name) |
  .id
' | head -1)

if [ -z "$USER_ID" ]; then
  echo "ERROR: User '$NAME' not found in workspace" >&2
  exit 1
fi

# Add to map
REAL_NAME=$(echo "$RESPONSE" | jq -r --arg id "$USER_ID" '.members[] | select(.id == $id) | .real_name')
USERNAME=$(echo "$RESPONSE" | jq -r --arg id "$USER_ID" '.members[] | select(.id == $id) | .name')
EMAIL=$(echo "$RESPONSE" | jq -r --arg id "$USER_ID" '.members[] | select(.id == $id) | .profile.email // ""')

# Update the map
jq --arg id "$USER_ID" --arg name "$USERNAME" --arg real_name "$REAL_NAME" --arg email "$EMAIL" '
  .people_directory[$id] = {
    "name": $name,
    "real_name": $real_name,
    "email": $email
  }
' "$MAP_FILE" > "${MAP_FILE}.tmp" && mv "${MAP_FILE}.tmp" "$MAP_FILE"

echo "$USER_ID"
