#!/bin/bash
# Scan tracked threads for new engagement
# Usage: bash scan-tracked-threads.sh
# Returns: JSON with new_replies, new_reactions, needs_escalation

set -e

TRACKING_FILE="/home/harsh/.openclaw/workspace/memory/presentation-tracking.json"
BOT_TOKEN=$(python3 -c "import json; print(json.load(open('/home/harsh/.openclaw/openclaw.json'))['channels']['slack']['botToken'])")

python3 << 'PYTHON_EOF'
import json
import os
import sys
from datetime import datetime
import urllib.request

TRACKING_FILE = "/home/harsh/.openclaw/workspace/memory/presentation-tracking.json"
MAP_FILE = "/home/harsh/.openclaw/workspace/memory/slack-channel-map.json"
BOT_TOKEN = os.environ.get("BOT_TOKEN")
CO_FOUNDERS = ["UEHET2Q2G", "UEJV57HQW", "UE0KTBS8P"]

with open(TRACKING_FILE) as f:
    tracking = json.load(f)

with open(MAP_FILE) as f:
    user_map = json.load(f).get("people_directory", {})

result = {"new_replies": [], "new_reactions": [], "needs_escalation": [], "scanned": 0}

for thread in tracking.get("threads", []):
    analysis = thread.get("analysis", "unknown")
    channel_id = thread.get("channelId")
    message_ts = thread.get("messageTs")
    last_check = thread.get("snapshot", {}).get("as_of", "2026-01-01T00:00:00Z")
    
    # Fetch thread
    req = urllib.request.Request(
        f"https://slack.com/api/conversations.replies?channel={channel_id}&ts={message_ts}&limit=100",
        headers={"Authorization": f"Bearer {BOT_TOKEN}"}
    )
    with urllib.request.urlopen(req) as resp:
        thread_data = json.load(resp)
    
    last_ts = datetime.fromisoformat(last_check.replace('Z', '+00:00')).timestamp()
    
    # Find new replies
    for msg in thread_data.get("messages", []):
        if float(msg["ts"]) <= last_ts:
            continue
        if msg.get("bot_id") == "B0AE09WFSSJ":
            continue
        
        user_id = msg.get("user")
        user_name = user_map.get(user_id, {}).get("real_name", user_id)
        
        reply_info = {
            "analysis": analysis,
            "user": user_id,
            "user_name": user_name,
            "ts": msg["ts"],
            "text": (msg.get("text") or "")[:200]
        }
        result["new_replies"].append(reply_info)
        
        # Check if co-founder
        if user_id in CO_FOUNDERS:
            result["needs_escalation"].append({
                "analysis": analysis,
                "reason": "co_founder_reply",
                "user": user_id,
                "user_name": user_name
            })
    
    result["scanned"] += 1

print(json.dumps(result, indent=2))
PYTHON_EOF
