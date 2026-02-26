#!/usr/bin/env bash
# verify-netlify-drive-sync.sh — Detect drift between Netlify HTML files and Google Drive docs
# Run on heartbeat or manually. Outputs JSON: { "in_sync": true/false, "missing": [...] }
#
# Checks every HTML file in data/serve/ (except index.html) has a matching Google Doc
# in one of the three Drive folders (meetings, strategy, presentations).

set -euo pipefail

export PATH="$HOME/go/bin:$PATH"
export GOG_KEYRING_BACKEND=file
export GOG_ACCOUNT=harsh@stage.in

SERVE_DIR="/home/harsh/.openclaw/workspace/data/serve"

# All three Drive folder IDs
FOLDER_IDS=(
  "1dcMjm4NLzlyds4MEjv4Ty1N45TCvAXF3"
  "155j3ClW1pK9FZHH6PkocG6DVkt9zeAzq"
  "1VWodlfQ13a3Ihk0cs3a2uFlT3mMlNc1k"
)

# ── Auth ──
gog auth tokens export harsh@stage.in --out /tmp/gog-token-sync.json 2>/dev/null
REFRESH=$(jq -r '.refresh_token' /tmp/gog-token-sync.json)
CREDS=$(cat ~/.config/gogcli/credentials.json)
CID=$(echo "$CREDS" | jq -r '.client_id')
CSEC=$(echo "$CREDS" | jq -r '.client_secret')
ACCESS=$(curl -s -X POST https://oauth2.googleapis.com/token \
  -d "client_id=$CID&client_secret=$CSEC&refresh_token=$REFRESH&grant_type=refresh_token" | jq -r '.access_token')

[ -n "$ACCESS" ] && [ "$ACCESS" != "null" ] || { echo '{"error":"auth_failed"}'; exit 1; }

# ── Collect all Drive doc titles across all 3 folders ──
ALL_TITLES=""
for FID in "${FOLDER_IDS[@]}"; do
  PAGE=""
  while true; do
    PARAMS="q='$FID'+in+parents+and+trashed%3Dfalse&fields=files(name),nextPageToken&pageSize=100"
    [ -n "$PAGE" ] && PARAMS="$PARAMS&pageToken=$PAGE"
    RESP=$(curl -s "https://www.googleapis.com/drive/v3/files?$PARAMS" \
      -H "Authorization: Bearer $ACCESS")
    TITLES=$(echo "$RESP" | jq -r '.files[].name // empty')
    ALL_TITLES="$ALL_TITLES"$'\n'"$TITLES"
    PAGE=$(echo "$RESP" | jq -r '.nextPageToken // empty')
    [ -n "$PAGE" ] || break
  done
done

# ── Check each HTML file has a matching doc (by <title> tag) ──
MISSING="[]"
CHECKED=0
cd "$SERVE_DIR"
for f in *.html; do
  [ "$f" = "index.html" ] && continue
  CHECKED=$((CHECKED + 1))
  
  TITLE=$(grep -oP '(?<=<title>).*(?=</title>)' "$f" 2>/dev/null | head -1)
  [ -z "$TITLE" ] && TITLE="$f"
  
  if ! echo "$ALL_TITLES" | grep -qF "$TITLE"; then
    MISSING=$(echo "$MISSING" | jq --arg f "$f" --arg t "$TITLE" '. + [{"file": $f, "title": $t}]')
  fi
done

rm -f /tmp/gog-token-sync.json

MISSING_COUNT=$(echo "$MISSING" | jq 'length')
IN_SYNC=$([ "$MISSING_COUNT" -eq 0 ] && echo "true" || echo "false")

echo "{\"in_sync\": $IN_SYNC, \"checked\": $CHECKED, \"missing_count\": $MISSING_COUNT, \"missing\": $MISSING}"
