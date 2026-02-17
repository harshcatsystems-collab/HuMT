#!/bin/bash
# Usage: slack-search.sh "search query" [count]
# Searches Slack messages using user token (has search:read scope)

QUERY="$1"
COUNT="${2:-20}"

USER_TOKEN=$(python3 -c "import json; print(json.load(open('/home/harsh/.openclaw/openclaw.json'))['channels']['slack']['userToken'])")

curl -s -H "Authorization: Bearer $USER_TOKEN" \
  "https://slack.com/api/search.messages?query=$(python3 -c "import urllib.parse; print(urllib.parse.quote('$QUERY'))")&count=${COUNT}"
