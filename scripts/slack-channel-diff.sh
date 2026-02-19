#!/bin/bash
# Detects new channels the HuMT bot has been added to since last check.
# Outputs new channels (if any) and updates the baseline.
# Usage: bash scripts/slack-channel-diff.sh

cd /home/harsh/.openclaw/workspace
BASELINE="memory/slack-bot-channels.json"
BOT_TOKEN=$(python3 -c "import json; print(json.load(open('/home/harsh/.openclaw/openclaw.json'))['channels']['slack']['botToken'])")

# Fetch current channels to temp file
curl -s -H "Authorization: Bearer $BOT_TOKEN" \
  "https://slack.com/api/conversations.list?types=public_channel,private_channel,mpim&limit=999&exclude_archived=true" > /tmp/slack_channels_raw.json

# Compare and update
python3 << 'PYEOF'
import json, os

with open("/tmp/slack_channels_raw.json") as f:
    data = json.load(f)

current = {}
for ch in data.get("channels", []):
    if ch.get("is_member"):
        current[ch["id"]] = ch.get("name", "unknown")

baseline_path = "memory/slack-bot-channels.json"
if os.path.exists(baseline_path):
    with open(baseline_path) as f:
        baseline = json.load(f)
else:
    baseline = {}

new_channels = {cid: name for cid, name in current.items() if cid not in baseline}
removed = {cid: name for cid, name in baseline.items() if cid not in current}

if new_channels:
    print("NEW_CHANNELS")
    for cid, name in new_channels.items():
        print(f"  {cid} #{name}")
if removed:
    print("REMOVED_CHANNELS")
    for cid, name in removed.items():
        print(f"  {cid} #{name}")
if not new_channels and not removed:
    print("NO_CHANGES")

# Update baseline
with open(baseline_path, "w") as f:
    json.dump(current, f, indent=2)
PYEOF
