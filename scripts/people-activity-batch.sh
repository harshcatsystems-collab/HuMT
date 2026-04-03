#!/bin/bash
# People Activity Logger - batch run
# Usage: bash people-activity-batch.sh <oldest_ts>

OLDEST_TS="${1:-1743605640}"
LOG_FILE="/home/harsh/.openclaw/workspace/memory/people-activity-log.jsonl"

# Tracked people: SLACK_ID=Name
declare -A PEOPLE=(
  ["U08L99D58PK"]="Nikhil Nair"
  ["U0719V1GX3Q"]="Pranay Merchant"
  ["U04A980D1N3"]="Ashish Pandey"
  ["U08UL9EHKKP"]="Samir Kumar"
  ["U08KBHHV9J4"]="Radhika Vijay"
  ["U07R906K9K5"]="Nishita Banerjee"
  ["U07LFSB0PM5"]="Vismit Bansal"
  ["U068F2RS5PV"]="Nisha Ali"
  ["UEHET2Q2G"]="Vinay Singhal"
  ["UEJV57HQW"]="Parveen Singhal"
  ["UE0KTBS8P"]="Shashank Vaishnav"
)

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

# Per-person accumulators (stored as temp files for simplicity)
TMP_DIR=$(mktemp -d)

# Initialize per-person data
for uid in "${!PEOPLE[@]}"; do
  echo "0 0 0 0 0" > "$TMP_DIR/$uid.dat"  # messages thread_replies after_hours latency_sum latency_count
  > "$TMP_DIR/$uid.channels"
done

# Read each channel and process messages
for CHANNEL in "${CHANNELS[@]}"; do
  RESULT=$(bash /home/harsh/.openclaw/workspace/scripts/slack-read-channel.sh "$CHANNEL" 100 "$OLDEST_TS" 2>/dev/null)
  
  # Check if valid JSON array
  if echo "$RESULT" | python3 -c "import sys,json; data=json.load(sys.stdin); [None for _ in data]" 2>/dev/null; then
    # Process each message
    echo "$RESULT" | python3 -c "
import sys, json, os

data = json.load(sys.stdin)
channel = '$CHANNEL'
tmp_dir = '$TMP_DIR'

people_ids = set([
  'U08L99D58PK','U0719V1GX3Q','U04A980D1N3','U08UL9EHKKP','U08KBHHV9J4',
  'U07R906K9K5','U07LFSB0PM5','U068F2RS5PV','UEHET2Q2G','UEJV57HQW','UE0KTBS8P'
])

for msg in data:
  uid = msg.get('user','')
  if uid not in people_ids:
    continue
  
  ts_val = float(msg.get('ts', 0))
  thread_ts_val = float(msg.get('thread_ts', 0)) if msg.get('thread_ts') else ts_val
  
  is_thread_reply = msg.get('thread_ts') and msg.get('thread_ts') != msg.get('ts')
  
  # IST = UTC+5:30, check after hours
  import datetime
  dt_utc = datetime.datetime.utcfromtimestamp(ts_val)
  dt_ist = dt_utc.replace(tzinfo=None)
  ist_hour = (dt_utc.hour * 60 + dt_utc.minute + 330) // 60 % 24
  after_hours = 1 if (ist_hour < 9 or ist_hour >= 19) else 0
  
  # Read current stats
  dat_file = os.path.join(tmp_dir, uid + '.dat')
  with open(dat_file) as f:
    parts = f.read().strip().split()
  msgs, replies, ah, lat_sum, lat_cnt = int(parts[0]), int(parts[1]), int(parts[2]), float(parts[3]), int(parts[4])
  
  if is_thread_reply:
    replies += 1
    latency = ts_val - thread_ts_val
    lat_sum += latency
    lat_cnt += 1
  else:
    msgs += 1
  
  ah += after_hours
  
  with open(dat_file, 'w') as f:
    f.write(f'{msgs} {replies} {ah} {lat_sum} {lat_cnt}')
  
  # Track channel
  ch_file = os.path.join(tmp_dir, uid + '.channels')
  with open(ch_file) as f:
    chs = set(f.read().strip().split()) if f.read().strip() else set()
  # Re-read properly
  with open(ch_file) as f:
    content = f.read().strip()
  chs = set(content.split()) if content else set()
  chs.add(channel)
  with open(ch_file, 'w') as f:
    f.write(' '.join(chs))
" 2>/dev/null
  fi
done

# Now write JSONL output
NOW_ISO=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

declare -A PEOPLE_NAMES=(
  ["U08L99D58PK"]="Nikhil Nair"
  ["U0719V1GX3Q"]="Pranay Merchant"
  ["U04A980D1N3"]="Ashish Pandey"
  ["U08UL9EHKKP"]="Samir Kumar"
  ["U08KBHHV9J4"]="Radhika Vijay"
  ["U07R906K9K5"]="Nishita Banerjee"
  ["U07LFSB0PM5"]="Vismit Bansal"
  ["U068F2RS5PV"]="Nisha Ali"
  ["UEHET2Q2G"]="Vinay Singhal"
  ["UEJV57HQW"]="Parveen Singhal"
  ["UE0KTBS8P"]="Shashank Vaishnav"
)

for uid in "${!PEOPLE_NAMES[@]}"; do
  dat_file="$TMP_DIR/$uid.dat"
  ch_file="$TMP_DIR/$uid.channels"
  
  read msgs replies ah lat_sum lat_cnt < "$dat_file"
  
  total_active=$((msgs + replies))
  if [ "$total_active" -eq 0 ]; then
    continue
  fi
  
  ch_content=$(cat "$ch_file" 2>/dev/null)
  ch_count=0
  ch_array="[]"
  if [ -n "$ch_content" ]; then
    ch_list=($ch_content)
    ch_count=${#ch_list[@]}
    ch_array="[\"$(echo "$ch_content" | sed 's/ /","/g')\"]"
  fi
  
  # Calculate avg latency
  if [ "$lat_cnt" -gt 0 ]; then
    avg_latency=$(echo "scale=1; $lat_sum / $lat_cnt" | bc 2>/dev/null || echo "null")
  else
    avg_latency="null"
  fi
  
  name="${PEOPLE_NAMES[$uid]}"
  
  echo "{\"ts\":\"$NOW_ISO\",\"user\":\"$uid\",\"name\":\"$name\",\"messages\":$msgs,\"thread_replies\":$replies,\"channels_active\":$ch_count,\"channel_ids\":$ch_array,\"after_hours\":$ah,\"avg_response_latency_sec\":$avg_latency}" >> "$LOG_FILE"
done

# Run marker
echo "{\"ts\":\"$NOW_ISO\",\"_type\":\"logger_run\",\"people_tracked\":11}" >> "$LOG_FILE"

# Cleanup
rm -rf "$TMP_DIR"

echo "Done. Log: $LOG_FILE"
