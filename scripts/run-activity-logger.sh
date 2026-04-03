#!/bin/bash
# People Activity Logger - runs all channel scans and writes JSONL
# Usage: bash run-activity-logger.sh

WORKSPACE="/home/harsh/.openclaw/workspace"
LOG_FILE="$WORKSPACE/memory/people-activity-log.jsonl"
SCRIPT="$WORKSPACE/scripts/slack-read-channel.sh"

# Current time and window
NOW=$(date +%s)
OLDEST_TS=$((NOW - 1800))
NOW_ISO=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# Tracked people: ID -> Name
declare -A PEOPLE
PEOPLE["U08L99D58PK"]="Nikhil Nair"
PEOPLE["U0719V1GX3Q"]="Pranay Merchant"
PEOPLE["U04A980D1N3"]="Ashish Pandey"
PEOPLE["U08UL9EHKKP"]="Samir Kumar"
PEOPLE["U08KBHHV9J4"]="Radhika Vijay"
PEOPLE["U07R906K9K5"]="Nishita Banerjee"
PEOPLE["U07LFSB0PM5"]="Vismit Bansal"
PEOPLE["U068F2RS5PV"]="Nisha Ali"
UEHET2Q2G_NAME="Vinay Singhal"
PEOPLE["UEHET2Q2G"]="Vinay Singhal"
PEOPLE["UEJV57HQW"]="Parveen Singhal"
PEOPLE["UE0KTBS8P"]="Shashank Vaishnav"

# Channels to scan
CHANNELS=(
  "CEWV0GMMG"
  "C080EJU9873"
  "C0A3N67V0G2"
  "C08HQ89S797"
  "C0A87E17UMS"
  "CEHPPGSN9"
  "GEJUR0WA2"
  "C07T7047TEZ"
  "C035F6W8DK9"
  "C082Z8FUBRV"
  "C037H0GLYP4"
  "CS75DM3KQ"
  "C084HQGH9T6"
  "C095EKEC0LX"
  "C08QC5UHQUS"
  "C09TLDLA7GE"
)

# Per-person accumulators (stored as flat vars: MSGS_UID, TREPLIES_UID, CHANNELS_UID, AH_UID, LAT_UID, LATCOUNT_UID, CHANLIST_UID)
declare -A MSGS TREPLIES AH LATSUM LATCOUNT
declare -A CHANSET  # key: UID:CHANID -> 1

echo "Activity logger starting. NOW=$NOW OLDEST=$OLDEST_TS" >&2

for CHAN in "${CHANNELS[@]}"; do
  echo "Scanning $CHAN..." >&2
  RAW=$(bash "$SCRIPT" "$CHAN" 100 "$OLDEST_TS" 2>/dev/null)
  if [ -z "$RAW" ]; then
    echo "  No output for $CHAN" >&2
    continue
  fi

  # Parse messages array - extract user, ts, thread_ts fields
  # Use python for reliable JSON parsing
  python3 - <<PYEOF
import json, sys

raw = '''$RAW'''
try:
    data = json.loads(raw)
except:
    sys.exit(0)

msgs = data.get('messages', [])
if not msgs:
    sys.exit(0)

tracked = {
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

for m in msgs:
    uid = m.get('user','')
    if uid not in tracked:
        continue
    ts_str = m.get('ts','0')
    thread_ts_str = m.get('thread_ts','')
    try:
        ts_val = float(ts_str)
        thread_ts_val = float(thread_ts_str) if thread_ts_str else None
    except:
        continue

    is_reply = thread_ts_val and (thread_ts_val != ts_val)
    latency = round(ts_val - thread_ts_val) if is_reply and thread_ts_val else None

    # IST = UTC+5:30
    import datetime
    dt_utc = datetime.datetime.utcfromtimestamp(ts_val)
    ist_hour = (dt_utc.hour * 60 + dt_utc.minute + 330) // 60 % 24
    after_hours = 1 if (ist_hour < 9 or ist_hour >= 19) else 0

    print(f"MSG|{uid}|{tracked[uid]}|{'REPLY' if is_reply else 'MSG'}|{latency if latency else ''}|{after_hours}|$CHAN")

PYEOF

done | sort | python3 - <<'AGGREGATE'
import sys, json
from datetime import datetime, timezone
from collections import defaultdict

lines = sys.stdin.read().strip().split('\n')
# Per-person data
people = {}  # uid -> {name, msgs, replies, ah, latencies, channels}

for line in lines:
    line = line.strip()
    if not line or not line.startswith('MSG|'):
        continue
    parts = line.split('|')
    if len(parts) < 7:
        continue
    _, uid, name, mtype, latency, ah, chan = parts[0], parts[1], parts[2], parts[3], parts[4], parts[5], parts[6]

    if uid not in people:
        people[uid] = {'name': name, 'msgs': 0, 'replies': 0, 'ah': 0, 'latencies': [], 'channels': set()}

    people[uid]['channels'].add(chan)
    if int(ah):
        people[uid]['ah'] += 1

    if mtype == 'REPLY':
        people[uid]['replies'] += 1
        if latency:
            try:
                people[uid]['latencies'].append(float(latency))
            except:
                pass
    else:
        people[uid]['msgs'] += 1

now_iso = datetime.now(timezone.utc).strftime('%Y-%m-%dT%H:%M:%SZ')
LOG_FILE = '/home/harsh/.openclaw/workspace/memory/people-activity-log.jsonl'

with open(LOG_FILE, 'a') as f:
    for uid, d in people.items():
        avg_lat = round(sum(d['latencies']) / len(d['latencies'])) if d['latencies'] else None
        record = {
            "ts": now_iso,
            "user": uid,
            "name": d['name'],
            "messages": d['msgs'],
            "thread_replies": d['replies'],
            "channels_active": len(d['channels']),
            "channel_ids": list(d['channels']),
            "after_hours": d['ah'],
            "avg_response_latency_sec": avg_lat
        }
        f.write(json.dumps(record) + '\n')

    # Run marker
    marker = {
        "ts": now_iso,
        "_type": "logger_run",
        "people_tracked": 11
    }
    f.write(json.dumps(marker) + '\n')

print(f"Written {len(people)} active people + run marker to {LOG_FILE}", file=sys.stderr)
AGGREGATE

echo "Done." >&2
