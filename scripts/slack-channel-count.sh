#!/bin/bash
# Returns the CORRECT count of Slack channels HuMT is a member of.
# 
# CRITICAL: Uses users.conversations (not conversations.list with is_member)
# because conversations.list has pagination bugs that cause undercounting.
#
# Fixed: 2026-03-27 after HMT caught the bug (was returning 101 instead of 361)
#
# Usage: bash scripts/slack-channel-count.sh

BOT_TOKEN=$(python3 -c "import json; print(json.load(open('/home/harsh/.openclaw/openclaw.json'))['channels']['slack']['botToken'])")

python3 << 'PYEOF'
import json, urllib.request, sys

config = json.load(open('/home/harsh/.openclaw/openclaw.json'))
token = config['channels']['slack']['botToken']

total = 0
cursor = ""
pages = 0

while True:
    url = f"https://slack.com/api/users.conversations?types=public_channel,private_channel&exclude_archived=true&limit=200"
    if cursor:
        url += f"&cursor={cursor}"
    
    req = urllib.request.Request(url, headers={"Authorization": f"Bearer {token}"})
    resp = json.loads(urllib.request.urlopen(req, timeout=15).read())
    
    if not resp.get("ok"):
        print(f"ERROR: {resp.get('error')}", file=sys.stderr)
        sys.exit(1)
    
    batch = len(resp.get("channels", []))
    total += batch
    pages += 1
    
    cursor = resp.get("response_metadata", {}).get("next_cursor", "")
    if not cursor:
        break

print(total)
PYEOF
