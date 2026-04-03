#!/bin/bash
# People Activity Collector - collects Slack activity for tracked people
# Usage: bash people-activity-collector.sh <oldest_ts>

OLDEST_TS=${1:-$(( $(date +%s) - 1800 ))}
NOW_ISO=$(date -u +%Y-%m-%dT%H:%M:%SZ)
OUTPUT_FILE="/home/harsh/.openclaw/workspace/memory/people-activity-log.jsonl"

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

# Per-person accumulators (using temp files keyed by user_id)
TMPDIR_PEOPLE=$(mktemp -d)

for CHANNEL in "${CHANNELS[@]}"; do
  # Read channel messages
  RESPONSE=$(bash /home/harsh/.openclaw/workspace/scripts/slack-read-channel.sh "$CHANNEL" 100 "$OLDEST_TS" 2>/dev/null)
  
  if [ -z "$RESPONSE" ]; then
    continue
  fi
  
  # Parse messages using Python for reliable JSON handling
  python3 - <<PYEOF
import json, sys, os

response = '''$RESPONSE'''
tmpdir = "$TMPDIR_PEOPLE"
channel = "$CHANNEL"
oldest_ts = float("$OLDEST_TS")

# Tracked people
people = {
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
  "UE0KTBS8P": "Shashank Vaishnav"
}

try:
  data = json.loads(response)
except:
  sys.exit(0)

# Handle both {"messages": [...]} and direct array
if isinstance(data, list):
  messages = data
elif isinstance(data, dict):
  messages = data.get("messages", data.get("items", []))
  if not messages and "ok" in data:
    messages = data.get("messages", [])
else:
  sys.exit(0)

for msg in messages:
  if not isinstance(msg, dict):
    continue
  user = msg.get("user", "")
  if user not in people:
    continue
  
  ts_str = msg.get("ts", "0")
  try:
    ts_val = float(ts_str)
  except:
    continue
  
  if ts_val < oldest_ts:
    continue
  
  thread_ts = msg.get("thread_ts")
  is_reply = thread_ts and thread_ts != ts_str
  
  # Compute IST hour (UTC+5:30)
  import datetime
  dt = datetime.datetime.utcfromtimestamp(ts_val)
  ist_offset = datetime.timedelta(hours=5, minutes=30)
  ist_dt = dt + ist_offset
  ist_hour = ist_dt.hour
  after_hours = 1 if (ist_hour < 9 or ist_hour >= 19) else 0
  
  # Response latency for thread replies
  latency = None
  if is_reply:
    try:
      latency = ts_val - float(thread_ts)
    except:
      latency = None
  
  # Write to per-user temp file
  entry = {
    "channel": channel,
    "ts": ts_val,
    "is_reply": is_reply,
    "after_hours": after_hours,
    "latency": latency
  }
  
  user_file = os.path.join(tmpdir, user)
  with open(user_file, "a") as f:
    f.write(json.dumps(entry) + "\n")

PYEOF
done

# Aggregate per-person data and write JSONL
python3 - <<PYEOF
import json, os, glob

tmpdir = "$TMPDIR_PEOPLE"
output_file = "$OUTPUT_FILE"
now_iso = "$NOW_ISO"

people_names = {
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
  "UE0KTBS8P": "Shashank Vaishnav"
}

lines = []

for user_file in glob.glob(os.path.join(tmpdir, "*")):
  user_id = os.path.basename(user_file)
  if user_id not in people_names:
    continue
  
  messages = 0
  thread_replies = 0
  channels_active = set()
  after_hours_count = 0
  latencies = []
  
  with open(user_file) as f:
    for line in f:
      line = line.strip()
      if not line:
        continue
      try:
        entry = json.loads(line)
      except:
        continue
      
      channels_active.add(entry["channel"])
      after_hours_count += entry.get("after_hours", 0)
      
      if entry.get("is_reply"):
        thread_replies += 1
        if entry.get("latency") is not None:
          latencies.append(entry["latency"])
      else:
        messages += 1
  
  avg_latency = round(sum(latencies) / len(latencies), 1) if latencies else None
  
  record = {
    "ts": now_iso,
    "user": user_id,
    "name": people_names[user_id],
    "messages": messages,
    "thread_replies": thread_replies,
    "channels_active": len(channels_active),
    "channel_ids": list(channels_active),
    "after_hours": after_hours_count,
    "avg_response_latency_sec": avg_latency
  }
  lines.append(record)

# Run marker
run_marker = {
  "ts": now_iso,
  "_type": "logger_run",
  "people_tracked": 11
}

# Append to output file
with open(output_file, "a") as f:
  for record in lines:
    f.write(json.dumps(record) + "\n")
  f.write(json.dumps(run_marker) + "\n")

# Cleanup
import shutil
shutil.rmtree(tmpdir, ignore_errors=True)

print(f"Done: {len(lines)} active people logged, run marker written")
PYEOF
