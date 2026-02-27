#!/bin/bash
# Detects new channels HuMT has been added to since last check.
# Uses USER TOKEN (not bot token) to catch private channels.
# Paginates fully. Outputs new/removed channels and updates baseline.
# Usage: bash scripts/slack-channel-diff.sh

cd /home/harsh/.openclaw/workspace
BASELINE="memory/slack-bot-channels.json"

# Use user token for full visibility (private channels, MPIMs, etc.)
USER_TOKEN=$(python3 -c "import json; print(json.load(open('/home/harsh/.openclaw/openclaw.json'))['channels']['slack']['userToken'])")
# Fallback to bot token if user token fails
BOT_TOKEN=$(python3 -c "import json; print(json.load(open('/home/harsh/.openclaw/openclaw.json'))['channels']['slack']['botToken'])")

python3 << 'PYEOF'
import json, os, urllib.request

config = json.load(open('/home/harsh/.openclaw/openclaw.json'))
user_token = config['channels']['slack']['userToken']
bot_token = config['channels']['slack']['botToken']

def fetch_all_member_channels(token):
    """Paginate through all channels where we're a member."""
    all_channels = {}
    cursor = ""
    for _ in range(50):  # safety limit
        url = f"https://slack.com/api/conversations.list?types=public_channel,private_channel,mpim&exclude_archived=true&limit=200&cursor={cursor}"
        req = urllib.request.Request(url, headers={"Authorization": f"Bearer {token}"})
        try:
            resp = json.loads(urllib.request.urlopen(req, timeout=15).read())
        except:
            break
        if not resp.get("ok"):
            break
        for ch in resp.get("channels", []):
            if ch.get("is_member"):
                all_channels[ch["id"]] = ch.get("name", "unknown")
        cursor = resp.get("response_metadata", {}).get("next_cursor", "")
        if not cursor:
            break
    return all_channels

# Try bot token first (shows bot membership), then supplement with user token for private channels
bot_channels = fetch_all_member_channels(bot_token)

# For private channel detection: also check user token
# The bot might be in a channel but bot token API doesn't list it yet (caching)
user_channels = fetch_all_member_channels(user_token)

# Merge: bot channels + any user channels that the bot was recently added to
# We care about channels where the BOT (@HuMT) is a member
# But use user token as a supplement for channels the bot API misses
current = bot_channels.copy()

# Check if any user-visible channels have the bot as member (via conversations.info)
for cid, name in user_channels.items():
    if cid not in current:
        # Check if bot is actually in this channel
        try:
            url = f"https://slack.com/api/conversations.info?channel={cid}"
            req = urllib.request.Request(url, headers={"Authorization": f"Bearer {bot_token}"})
            resp = json.loads(urllib.request.urlopen(req, timeout=5).read())
            if resp.get("ok") and resp.get("channel", {}).get("is_member"):
                current[cid] = name
        except:
            pass

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
    for cid, name in sorted(new_channels.items(), key=lambda x: x[1]):
        print(f"  {cid} #{name}")
if removed:
    print("REMOVED_CHANNELS")
    for cid, name in sorted(removed.items(), key=lambda x: x[1]):
        print(f"  {cid} #{name}")
if not new_channels and not removed:
    print("NO_CHANGES")

# Update baseline
with open(baseline_path, "w") as f:
    json.dump(current, f, indent=2)
PYEOF
