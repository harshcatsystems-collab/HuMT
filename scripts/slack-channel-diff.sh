#!/bin/bash
# Detects new channels HuMT has been added to since last check.
# Uses BOT TOKEN with full pagination.
# Outputs new/removed channels and updates baseline.
# Usage: bash scripts/slack-channel-diff.sh

cd /home/harsh/.openclaw/workspace
BASELINE="memory/slack-bot-channels.json"

BOT_TOKEN=$(python3 -c "import json; print(json.load(open('/home/harsh/.openclaw/openclaw.json'))['channels']['slack']['botToken'])")

python3 << 'PYEOF'
import json, os, sys, urllib.request

config = json.load(open('/home/harsh/.openclaw/openclaw.json'))
bot_token = config['channels']['slack']['botToken']

def fetch_all_member_channels(token):
    """Paginate through ALL channels where bot is a member."""
    all_channels = {}
    cursor = ""
    page = 0
    
    for _ in range(50):  # safety limit
        url = f"https://slack.com/api/conversations.list?types=public_channel,private_channel,mpim&exclude_archived=true&limit=200&cursor={cursor}"
        req = urllib.request.Request(url, headers={"Authorization": f"Bearer {token}"})
        try:
            resp = json.loads(urllib.request.urlopen(req, timeout=15).read())
        except Exception as e:
            print(f"ERROR: API request failed on page {page}: {e}", file=sys.stderr)
            break
        
        if not resp.get("ok"):
            print(f"ERROR: Slack API returned error: {resp.get('error')}", file=sys.stderr)
            break
        
        batch = resp.get("channels", [])
        for ch in batch:
            if ch.get("is_member"):
                all_channels[ch["id"]] = ch.get("name", "unknown")
        
        page += 1
        cursor = resp.get("response_metadata", {}).get("next_cursor", "")
        if not cursor:
            break
    
    # Verify pagination completed
    if cursor:
        print(f"WARNING: Pagination incomplete - stopped at page {page} with cursor still active", file=sys.stderr)
    
    return all_channels

# Fetch current state
current = fetch_all_member_channels(bot_token)

if len(current) == 0:
    print("ERROR: No channels returned - bot might be disconnected", file=sys.stderr)
    sys.exit(1)

# Load baseline
baseline_path = "memory/slack-bot-channels.json"
if os.path.exists(baseline_path):
    with open(baseline_path) as f:
        baseline = json.load(f)
else:
    baseline = {}

# Sanity check: is baseline corrupt?
baseline_count = len(baseline)
current_count = len(current)

if baseline_count < 100 and current_count > 300:
    print(f"BASELINE_CORRUPT: baseline={baseline_count}, current={current_count}", file=sys.stderr)
    print(f"Rebuilding baseline silently (not alerting on {current_count - baseline_count} 'new' channels)", file=sys.stderr)
    # Save current as new baseline without alerting
    with open(baseline_path, "w") as f:
        json.dump(current, f, indent=2, sort_keys=True)
    print("BASELINE_REBUILT")
    sys.exit(0)

# Normal diff
new_channels = {cid: name for cid, name in current.items() if cid not in baseline}
removed = {cid: name for cid, name in baseline.items() if cid not in current}

# Alert thresholds
ALERT_ON_REMOVAL_COUNT = 20  # Alert if >20 channels lost at once
ALERT_ON_ADDITION_COUNT = 30  # Alert if >30 channels added at once (suspicious)

if removed and len(removed) > ALERT_ON_REMOVAL_COUNT:
    print(f"🚨 ALERT: {len(removed)} channels REMOVED (threshold: {ALERT_ON_REMOVAL_COUNT})")
    print("REMOVED_CHANNELS")
    for cid, name in sorted(removed.items(), key=lambda x: x[1]):
        print(f"  {cid} #{name}")
elif removed:
    print(f"REMOVED_CHANNELS (minor: {len(removed)})")
    for cid, name in sorted(removed.items(), key=lambda x: x[1]):
        print(f"  {cid} #{name}")

if new_channels and len(new_channels) > ALERT_ON_ADDITION_COUNT:
    print(f"⚠️ UNUSUAL: {len(new_channels)} channels ADDED at once", file=sys.stderr)
    
if new_channels:
    print("NEW_CHANNELS")
    for cid, name in sorted(new_channels.items(), key=lambda x: x[1]):
        print(f"  {cid} #{name}")

if not new_channels and not removed:
    print("NO_CHANGES")

# Update baseline
with open(baseline_path, "w") as f:
    json.dump(current, f, indent=2, sort_keys=True)
PYEOF
