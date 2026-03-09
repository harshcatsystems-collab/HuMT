#!/bin/bash
# People Activity Logger - Tracks Slack activity for key STAGE team members

OLDEST_TS=$(date -d '30 minutes ago' +%s)
NOW_ISO=$(date -u +%Y-%m-%dT%H:%M:%SZ)
OUTPUT_FILE="/home/harsh/.openclaw/workspace/memory/people-activity-log.jsonl"

# Tracked people
declare -A PEOPLE=(
  [U08L99D58PK]="Nikhil Nair"
  [U0719V1GX3Q]="Pranay Merchant"
  [U04A980D1N3]="Ashish Pandey"
  [U08UL9EHKKP]="Samir Kumar"
  [U08KBHHV9J4]="Radhika Vijay"
  [U07R906K9K5]="Nishita Banerjee"
  [U07LFSB0PM5]="Vismit Bansal"
  [U068F2RS5PV]="Nisha Ali"
  [UEHET2Q2G]="Vinay Singhal"
  [UEJV57HQW]="Parveen Singhal"
  [UE0KTBS8P]="Shashank Vaishnav"
)

CHANNELS=(
  C05NTGAB4E6 C080EJU9873 C08DR2XLBSN C068CHA84M0 C07SU3N0DFD 
  C05N93S26GJ CEN2QKR3A C08CKB38TKZ C07T7047TEZ C035F6W8DK9 
  C082Z8FUBRV C037H0GLYP4 CS75DM3KQ C084HQGH9T6 C095EKEC0LX 
  C08QC5UHQUS C09TLDLA7GE
)

# Initialize activity tracking
declare -A msg_count reply_count ah_count
declare -A channels_set latencies_sum latencies_count

# Read all channels
for CHANNEL in "${CHANNELS[@]}"; do
  bash /home/harsh/.openclaw/workspace/scripts/slack-read-channel.sh "$CHANNEL" 100 "$OLDEST_TS" 2>/dev/null | \
  jq -c '.[]? | select(.user and .ts)' 2>/dev/null | while IFS= read -r line; do
    USER=$(echo "$line" | jq -r '.user')
    TS=$(echo "$line" | jq -r '.ts')
    THREAD_TS=$(echo "$line" | jq -r '.thread_ts // ""')
    
    # Skip if not tracked person
    [[ -z "${PEOPLE[$USER]}" ]] && continue
    
    # IST hour for after-hours check
    IST_HOUR=$(TZ='Asia/Kolkata' date -d "@${TS%.*}" +%H 2>/dev/null || echo "12")
    
    # Count messages vs thread replies
    if [[ -z "$THREAD_TS" || "$THREAD_TS" == "$TS" ]]; then
      ((msg_count[$USER]++)) || msg_count[$USER]=1
    else
      ((reply_count[$USER]++)) || reply_count[$USER]=1
      # Track response latency
      LATENCY=$(echo "$TS - $THREAD_TS" | bc 2>/dev/null || echo "0")
      CURRENT_SUM=$(echo "${latencies_sum[$USER]:-0} + $LATENCY" | bc)
      latencies_sum[$USER]=$CURRENT_SUM
      ((latencies_count[$USER]++)) || latencies_count[$USER]=1
    fi
    
    # After hours check (IST)
    if [[ $IST_HOUR -lt 9 || $IST_HOUR -ge 19 ]]; then
      ((ah_count[$USER]++)) || ah_count[$USER]=1
    fi
    
    # Track unique channels (space-separated set)
    if [[ ! " ${channels_set[$USER]} " =~ " $CHANNEL " ]]; then
      channels_set[$USER]="${channels_set[$USER]} $CHANNEL"
    fi
  done
done

# Write activity records
for USER_ID in "${!PEOPLE[@]}"; do
  MSG=${msg_count[$USER_ID]:-0}
  REPLY=${reply_count[$USER_ID]:-0}
  AH=${ah_count[$USER_ID]:-0}
  
  # Skip if no activity
  [[ $MSG -eq 0 && $REPLY -eq 0 ]] && continue
  
  # Build channel array
  CHANNELS_ACTIVE=(${channels_set[$USER_ID]})
  CHANNEL_COUNT=${#CHANNELS_ACTIVE[@]}
  CHANNEL_JSON=$(printf '%s\n' "${CHANNELS_ACTIVE[@]}" | jq -R . | jq -sc .)
  
  # Calculate avg latency
  AVG_LATENCY="null"
  if [[ ${latencies_count[$USER_ID]:-0} -gt 0 ]]; then
    AVG_LATENCY=$(echo "scale=1; ${latencies_sum[$USER_ID]} / ${latencies_count[$USER_ID]}" | bc)
  fi
  
  # Write JSONL
  jq -nc \
    --arg ts "$NOW_ISO" \
    --arg user "$USER_ID" \
    --arg name "${PEOPLE[$USER_ID]}" \
    --argjson messages "$MSG" \
    --argjson thread_replies "$REPLY" \
    --argjson channels_active "$CHANNEL_COUNT" \
    --argjson channel_ids "$CHANNEL_JSON" \
    --argjson after_hours "$AH" \
    --argjson avg_response_latency_sec "$AVG_LATENCY" \
    '{ts: $ts, user: $user, name: $name, messages: $messages, thread_replies: $thread_replies, channels_active: $channels_active, channel_ids: $channel_ids, after_hours: $after_hours, avg_response_latency_sec: $avg_response_latency_sec}' \
    >> "$OUTPUT_FILE"
done

# Write run marker
jq -nc --arg ts "$NOW_ISO" --argjson people_tracked 11 \
  '{ts: $ts, _type: "logger_run", people_tracked: $people_tracked}' \
  >> "$OUTPUT_FILE"
