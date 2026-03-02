#!/bin/bash
# Track in-flight requests (relayed to HMT, awaiting response)
# Usage: ./track-inflight-request.sh --action [add|update|close] --thread-ts 123.456 --channel C123 [--status awaiting|received|closed]

set -e

ACTION=""
THREAD_TS=""
CHANNEL=""
STATUS=""
REQUESTOR=""
SUBJECT=""

while [[ $# -gt 0 ]]; do
  case $1 in
    --action) ACTION="$2"; shift 2 ;;
    --thread-ts) THREAD_TS="$2"; shift 2 ;;
    --channel) CHANNEL="$2"; shift 2 ;;
    --status) STATUS="$2"; shift 2 ;;
    --requestor) REQUESTOR="$2"; shift 2 ;;
    --subject) SUBJECT="$2"; shift 2 ;;
    *) echo "Unknown option: $1"; exit 1 ;;
  esac
done

INFLIGHT_FILE="/home/harsh/.openclaw/workspace/memory/in-flight-requests.json"
LOCK_FILE="/tmp/inflight-requests.lock"

# Acquire lock
exec 200>"$LOCK_FILE"
flock -w 5 200 || { echo "ERROR: Could not acquire lock" >&2; exit 1; }

case "$ACTION" in
  add)
    # Add new in-flight request
    jq --arg ts "$THREAD_TS" --arg ch "$CHANNEL" --arg req "$REQUESTOR" --arg subj "$SUBJECT" --arg now "$(date -u +%Y-%m-%dT%H:%M:%SZ)" '
      .requests += [{
        thread_ts: $ts,
        channel: $ch,
        requestor: $req,
        subject: $subj,
        relayed_at: $now,
        status: "awaiting_response"
      }] |
      .last_updated = $now
    ' "$INFLIGHT_FILE" > "${INFLIGHT_FILE}.tmp" && mv "${INFLIGHT_FILE}.tmp" "$INFLIGHT_FILE"
    echo "✓ Added to in-flight: $THREAD_TS"
    ;;
    
  update)
    # Update status of existing request
    jq --arg ts "$THREAD_TS" --arg status "$STATUS" --arg now "$(date -u +%Y-%m-%dT%H:%M:%SZ)" '
      .requests |= map(
        if .thread_ts == $ts then 
          . + {status: $status, updated_at: $now}
        else . end
      ) |
      .last_updated = $now
    ' "$INFLIGHT_FILE" > "${INFLIGHT_FILE}.tmp" && mv "${INFLIGHT_FILE}.tmp" "$INFLIGHT_FILE"
    echo "✓ Updated: $THREAD_TS → $STATUS"
    ;;
    
  close)
    # Remove from in-flight (mark closed)
    jq --arg ts "$THREAD_TS" --arg now "$(date -u +%Y-%m-%dT%H:%M:%SZ)" '
      .requests |= map(select(.thread_ts != $ts)) |
      .last_updated = $now
    ' "$INFLIGHT_FILE" > "${INFLIGHT_FILE}.tmp" && mv "${INFLIGHT_FILE}.tmp" "$INFLIGHT_FILE"
    echo "✓ Closed: $THREAD_TS"
    ;;
    
  list)
    # List all in-flight requests
    jq -r '.requests[] | "\(.thread_ts) | \(.channel) | \(.requestor) | \(.subject) | \(.status)"' "$INFLIGHT_FILE"
    ;;
    
  *)
    echo "Usage: $0 --action [add|update|close|list] --thread-ts 123.456 --channel C123 [options]"
    exit 1
    ;;
esac

flock -u 200
