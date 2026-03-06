#!/bin/bash
# People Activity Logger - Collect per-person activity data from Slack

ISO_NOW=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
NOW=$(date +%s)
OLDEST=$((NOW - 1800))

# Tracked people map (Slack ID -> Name)
declare -A PEOPLE_MAP=(
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
CHANNELS=(
  "C05NTGAB4E6" "C080EJU9873" "C08DR2XLBSN" "C068CHA84M0"
  "C07SU3N0DFD" "C05N93S26GJ" "CEN2QKR3A" "C08CKB38TKZ"
  "C07T7047TEZ" "C035F6W8DK9" "C082Z8FUBRV" "C037H0GLYP4"
  "CS75DM3KQ" "C084HQGH9T6" "C095EKEC0LX" "C08QC5UHQUS" "C09TLDLA7GE"
)

# Temp directory
TMPDIR="/tmp/people_activity_$$"
mkdir -p "$TMPDIR"

# Read all channels and collect messages
for CHANNEL in "${CHANNELS[@]}"; do
  JSON=$(bash /home/harsh/.openclaw/workspace/scripts/slack-read-channel.sh "$CHANNEL" 100 "$OLDEST" 2>/dev/null)
  
  if [[ -n "$JSON" && "$JSON" != "[]" ]]; then
    echo "$JSON" | jq -c '.[]?' 2>/dev/null | while IFS= read -r msg; do
      USER=$(echo "$msg" | jq -r '.user // ""')
      TS=$(echo "$msg" | jq -r '.ts // ""')
      THREAD_TS=$(echo "$msg" | jq -r '.thread_ts // ""')
      
      if [[ -n "$USER" && -n "${PEOPLE_MAP[$USER]}" ]]; then
        # Write message record
        echo "$USER|$TS|$THREAD_TS|$CHANNEL" >> "$TMPDIR/all_messages.txt"
      fi
    done
  fi
done

# Process collected messages
if [[ -f "$TMPDIR/all_messages.txt" ]]; then
  for USER_ID in "${!PEOPLE_MAP[@]}"; do
    NAME="${PEOPLE_MAP[$USER_ID]}"
    
    # Filter messages for this user
    grep "^${USER_ID}|" "$TMPDIR/all_messages.txt" > "$TMPDIR/user_${USER_ID}.txt" 2>/dev/null || continue
    
    if [[ ! -s "$TMPDIR/user_${USER_ID}.txt" ]]; then
      continue
    fi
    
    MSG_COUNT=0
    REPLY_COUNT=0
    AH_COUNT=0
    declare -A CHANNELS_SEEN
    LATENCIES=()
    
    while IFS='|' read -r uid ts thread_ts channel; do
      # Count channels
      CHANNELS_SEEN["$channel"]=1
      
      # Categorize message type
      if [[ -z "$thread_ts" || "$thread_ts" == "$ts" ]]; then
        ((MSG_COUNT++))
      else
        ((REPLY_COUNT++))
        # Calculate latency
        TS_EPOCH=$(echo "$ts" | cut -d. -f1)
        THREAD_TS_EPOCH=$(echo "$thread_ts" | cut -d. -f1)
        LATENCY=$((TS_EPOCH - THREAD_TS_EPOCH))
        LATENCIES+=("$LATENCY")
      fi
      
      # Check after hours (IST = UTC + 5:30)
      TS_EPOCH=$(echo "$ts" | cut -d. -f1)
      UTC_HOUR=$(date -u -d "@$TS_EPOCH" +%H 2>/dev/null || echo 0)
      UTC_MIN=$(date -u -d "@$TS_EPOCH" +%M 2>/dev/null || echo 0)
      IST_HOUR=$(( (UTC_HOUR * 60 + UTC_MIN + 330) / 60 % 24 ))
      
      if [[ $IST_HOUR -lt 9 || $IST_HOUR -ge 19 ]]; then
        ((AH_COUNT++))
      fi
    done < "$TMPDIR/user_${USER_ID}.txt"
    
    # Build channel list
    CHANNEL_IDS=$(printf '%s\n' "${!CHANNELS_SEEN[@]}" | jq -R . | jq -s .)
    CHANNEL_COUNT=${#CHANNELS_SEEN[@]}
    
    # Calculate average latency
    if [[ ${#LATENCIES[@]} -gt 0 ]]; then
      TOTAL_LATENCY=0
      for lat in "${LATENCIES[@]}"; do
        TOTAL_LATENCY=$((TOTAL_LATENCY + lat))
      done
      AVG_LATENCY=$((TOTAL_LATENCY / ${#LATENCIES[@]}))
    else
      AVG_LATENCY="null"
    fi
    
    # Build and append JSONL
    jq -n \
      --arg ts "$ISO_NOW" \
      --arg user "$USER_ID" \
      --arg name "$NAME" \
      --argjson messages "$MSG_COUNT" \
      --argjson thread_replies "$REPLY_COUNT" \
      --argjson channels_active "$CHANNEL_COUNT" \
      --argjson channel_ids "$CHANNEL_IDS" \
      --argjson after_hours "$AH_COUNT" \
      --argjson avg_response_latency_sec "$AVG_LATENCY" \
      '{ts:$ts, user:$user, name:$name, messages:$messages, thread_replies:$thread_replies, channels_active:$channels_active, channel_ids:$channel_ids, after_hours:$after_hours, avg_response_latency_sec:$avg_response_latency_sec}' \
      >> /home/harsh/.openclaw/workspace/memory/people-activity-log.jsonl
  done
fi

# Add run marker
jq -n \
  --arg ts "$ISO_NOW" \
  --argjson people_tracked 11 \
  '{ts:$ts, _type:"logger_run", people_tracked:$people_tracked}' \
  >> /home/harsh/.openclaw/workspace/memory/people-activity-log.jsonl

# Cleanup
rm -rf "$TMPDIR"
