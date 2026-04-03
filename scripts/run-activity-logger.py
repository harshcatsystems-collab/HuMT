#!/usr/bin/env python3
"""People Activity Logger - collects per-person Slack activity data."""

import json
import time
import urllib.request
import urllib.parse
import datetime
import os

# Load config
with open('/home/harsh/.openclaw/openclaw.json') as f:
    config = json.load(f)

BOT_TOKEN = config['channels']['slack']['botToken']
LOG_FILE = '/home/harsh/.openclaw/workspace/memory/people-activity-log.jsonl'

TRACKED_USERS = {
    "U08L99D58PK": "Nikhil Nair",
    "U0719V1GX3Q": "Pranay Merchant",
    "U04A980D1N3": "Ashish Pandey",
    "U08UL9EHKKP": "Samir Kumar",
    "U08KBHHV9J4": "Radhika Vijay",
    "U07R906K9K5": "Nishita Banerjee",
    "U07LFSB0PM5": "Vismit Bansal",
    "U068F2RS5PV": "Nisha Ali",
    "UEHET2Q2G": "Vinay Singhal",
    "UEJV57HQW": "Parveen Singhal",
    "UE0KTBS8P": "Shashank Vaishnav",
}

CHANNELS = [
    "CEWV0GMMG",
    "C080EJU9873",
    "C0A3N67V0G2",
    "C08HQ89S797",
    "C0A87E17UMS",
    "CEHPPGSN9",
    "GEJUR0WA2",
    "C07T7047TEZ",
    "C035F6W8DK9",
    "C082Z8FUBRV",
    "C037H0GLYP4",
    "CS75DM3KQ",
    "C084HQGH9T6",
    "C095EKEC0LX",
    "C08QC5UHQUS",
    "C09TLDLA7GE",
]

def slack_get(channel_id, oldest_ts):
    url = f"https://slack.com/api/conversations.history?channel={channel_id}&limit=100&oldest={oldest_ts}"
    req = urllib.request.Request(url, headers={"Authorization": f"Bearer {BOT_TOKEN}"})
    with urllib.request.urlopen(req, timeout=10) as resp:
        return json.loads(resp.read())

def ist_hour(ts_float):
    dt = datetime.datetime.utcfromtimestamp(ts_float)
    ist_minutes = dt.hour * 60 + dt.minute + 330
    return (ist_minutes // 60) % 24

now = int(time.time())
oldest_ts = now - 1800
now_iso = datetime.datetime.utcnow().strftime("%Y-%m-%dT%H:%M:%SZ")

# Per-person data
p_messages = {}
p_replies = {}
p_channels = {}
p_after_hours = {}
p_latencies = {}

for uid in TRACKED_USERS:
    p_messages[uid] = 0
    p_replies[uid] = 0
    p_channels[uid] = set()
    p_after_hours[uid] = 0
    p_latencies[uid] = []

for chan in CHANNELS:
    try:
        data = slack_get(chan, oldest_ts)
        messages = data.get("messages", [])
    except Exception:
        continue

    for msg in messages:
        uid = msg.get("user", "")
        if uid not in TRACKED_USERS:
            continue

        ts_str = msg.get("ts", "0")
        thread_ts = msg.get("thread_ts", "")
        ts_float = float(ts_str)

        is_reply = bool(thread_ts and thread_ts != ts_str)

        hour = ist_hour(ts_float)
        after = 1 if (hour < 9 or hour >= 19) else 0
        p_after_hours[uid] += after
        p_channels[uid].add(chan)

        if is_reply:
            p_replies[uid] += 1
            try:
                latency = int(ts_float - float(thread_ts))
                p_latencies[uid].append(latency)
            except Exception:
                pass
        else:
            p_messages[uid] += 1

    time.sleep(0.2)  # rate limit courtesy

# Write JSONL
lines = []
for uid, name in TRACKED_USERS.items():
    total = p_messages[uid] + p_replies[uid]
    if total == 0:
        continue

    lats = p_latencies[uid]
    avg_lat = round(sum(lats) / len(lats), 1) if lats else None

    entry = {
        "ts": now_iso,
        "user": uid,
        "name": name,
        "messages": p_messages[uid],
        "thread_replies": p_replies[uid],
        "channels_active": len(p_channels[uid]),
        "channel_ids": list(p_channels[uid]),
        "after_hours": p_after_hours[uid],
        "avg_response_latency_sec": avg_lat,
    }
    lines.append(json.dumps(entry))

# Run marker always appended
lines.append(json.dumps({"ts": now_iso, "_type": "logger_run", "people_tracked": 11}))

os.makedirs(os.path.dirname(LOG_FILE), exist_ok=True)
with open(LOG_FILE, 'a') as f:
    for line in lines:
        f.write(line + "\n")

print(f"DONE: {now_iso} | active_people={len(lines)-1} | run_marker_written=1")
