#!/bin/bash

# People Activity Logger - Collects per-person activity data from Slack
# Run every 30 min via cron

NOW=$(date +%s)
OLDEST=$((NOW - 1800))  # 30 min window
TIMESTAMP=$(date -u +%Y-%m-%dT%H:%M:%SZ)
LOG_FILE="/home/harsh/.openclaw/workspace/memory/people-activity-log.jsonl"

# Tracked people
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

# Channels to scan
CHANNELS=(C05NTGAB4E6 C080EJU9873 C08DR2XLBSN C068CHA84M0 C07SU3N0DFD C05N93S26GJ CEN2QKR3A C08CKB38TKZ C07T7047TEZ C035F6W8DK9 C082Z8FUBRV C037H0GLYP4 CS75DM3KQ C084HQGH9T6 C095EKEC0LX C08QC5UHQUS C09TLDLA7GE)

# Temp file for aggregation
TEMP_FILE="/tmp/activity-$$"
> "$TEMP_FILE"

# Collect messages from all channels
for CHANNEL in "${CHANNELS[@]}"; do
  bash /home/harsh/.openclaw/workspace/scripts/slack-read-channel.sh "$CHANNEL" 100 "$OLDEST" 2>/dev/null | \
  jq -c --arg ch "$CHANNEL" '.[] | select(.user != null) | {user, ts, thread_ts, channel: $ch}' 2>/dev/null >> "$TEMP_FILE"
done

# Process activity per person
for USER_ID in "${!PEOPLE[@]}"; do
  NAME="${PEOPLE[$USER_ID]}"
  
  # Extract all messages for this user
  USER_MSGS=$(grep "\"user\":\"$USER_ID\"" "$TEMP_FILE" 2>/dev/null)
  
  if [ -z "$USER_MSGS" ]; then
    continue
  fi
  
  # Count metrics
  MSG_COUNT=$(echo "$USER_MSGS" | jq -s '[.[] | select(.thread_ts == null or .thread_ts == .ts)] | length')
  THREAD_COUNT=$(echo "$USER_MSGS" | jq -s '[.[] | select(.thread_ts != null and .thread_ts != .ts)] | length')
  CHANNEL_COUNT=$(echo "$USER_MSGS" | jq -s '[.[].channel] | unique | length')
  CHANNEL_IDS=$(echo "$USER_MSGS" | jq -s '[.[].channel] | unique')
  
  # After hours count (IST hour < 9 or >= 19)
  AFTER_HOURS=$(echo "$USER_MSGS" | jq -s '[.[] | .ts | tonumber | floor | . + 19800 | gmtime | .[3]] | map(select(. < 9 or . >= 19)) | length')
  
  # Average response latency for thread replies
  AVG_LATENCY=$(echo "$USER_MSGS" | jq -s '
    [.[] | select(.thread_ts != null and .thread_ts != .ts) | 
     (.ts | tonumber) - (.thread_ts | tonumber)] |
    if length > 0 then (add / length | floor) else null end
  ')
  
  # Write JSONL entry
  jq -n \
    --arg ts "$TIMESTAMP" \
    --arg user "$USER_ID" \
    --arg name "$NAME" \
    --argjson msgs "$MSG_COUNT" \
    --argjson threads "$THREAD_COUNT" \
    --argjson chans "$CHANNEL_COUNT" \
    --argjson chan_ids "$CHANNEL_IDS" \
    --argjson after "$AFTER_HOURS" \
    --argjson latency "$AVG_LATENCY" \
    '{ts: $ts, user: $user, name: $name, messages: $msgs, thread_replies: $threads, channels_active: $chans, channel_ids: $chan_ids, after_hours: $after, avg_response_latency_sec: $latency}' \
    >> "$LOG_FILE"
done

# Write run marker
jq -n --arg ts "$TIMESTAMP" '{ts: $ts, _type: "logger_run", people_tracked: 11}' >> "$LOG_FILE"

# Cleanup
rm -f "$TEMP_FILE"
