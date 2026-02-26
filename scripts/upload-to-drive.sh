#!/usr/bin/env bash
# upload-to-drive.sh — Upload an HTML file as a Google Doc to the correct Drive folder
# Usage: bash scripts/upload-to-drive.sh <filename.html> <folder: meetings|strategy|presentations>
#
# Requires: gog CLI configured, jq

set -euo pipefail

export PATH="$HOME/go/bin:$PATH"
export GOG_KEYRING_BACKEND=file
export GOG_ACCOUNT=harsh@stage.in

SERVE_DIR="/home/harsh/.openclaw/workspace/data/serve"

# Drive folder IDs
declare -A FOLDERS=(
  [meetings]="1dcMjm4NLzlyds4MEjv4Ty1N45TCvAXF3"
  [strategy]="155j3ClW1pK9FZHH6PkocG6DVkt9zeAzq"
  [presentations]="1VWodlfQ13a3Ihk0cs3a2uFlT3mMlNc1k"
)

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log() { echo -e "${GREEN}✓${NC} $1"; }
warn() { echo -e "${YELLOW}⚠${NC} $1"; }
fail() { echo -e "${RED}✗${NC} $1"; exit 1; }

# ── Args ──
FILE="${1:-}"
FOLDER_KEY="${2:-}"

[ -n "$FILE" ] || fail "Usage: upload-to-drive.sh <filename.html> <meetings|strategy|presentations>"
[ -n "$FOLDER_KEY" ] || fail "Specify folder: meetings, strategy, or presentations"
[ -f "$SERVE_DIR/$FILE" ] || fail "$FILE not found in data/serve/"
[ -n "${FOLDERS[$FOLDER_KEY]:-}" ] || fail "Unknown folder '$FOLDER_KEY'. Use: meetings, strategy, presentations"

FOLDER_ID="${FOLDERS[$FOLDER_KEY]}"

# ── Get title from HTML <title> tag ──
TITLE=$(grep -oP '(?<=<title>).*(?=</title>)' "$SERVE_DIR/$FILE" | head -1)
[ -n "$TITLE" ] || TITLE="$FILE"
log "Title: $TITLE"
log "Folder: $FOLDER_KEY ($FOLDER_ID)"

# ── Get OAuth access token ──
echo "Authenticating..."
gog auth tokens export harsh@stage.in --out /tmp/gog-token-deploy.json 2>/dev/null
REFRESH=$(jq -r '.refresh_token' /tmp/gog-token-deploy.json)
CREDS=$(cat ~/.config/gogcli/credentials.json)
CID=$(echo "$CREDS" | jq -r '.client_id')
CSEC=$(echo "$CREDS" | jq -r '.client_secret')

ACCESS=$(curl -s -X POST https://oauth2.googleapis.com/token \
  -d "client_id=$CID&client_secret=$CSEC&refresh_token=$REFRESH&grant_type=refresh_token" | jq -r '.access_token')

[ -n "$ACCESS" ] && [ "$ACCESS" != "null" ] || fail "OAuth token refresh failed"
log "Authenticated"

# ── Check for existing doc with same title (avoid duplicates) ──
EXISTING=$(curl -s -G "https://www.googleapis.com/drive/v3/files" \
  -H "Authorization: Bearer $ACCESS" \
  --data-urlencode "q=name='$TITLE' and '$FOLDER_ID' in parents and trashed=false" \
  --data-urlencode "fields=files(id,name)" | jq -r '.files[0].id // empty')

if [ -n "$EXISTING" ]; then
  warn "Doc already exists (ID: $EXISTING). Updating in-place..."
  
  # Update content
  RESULT=$(curl -s -X PATCH "https://www.googleapis.com/upload/drive/v3/files/$EXISTING?uploadType=media" \
    -H "Authorization: Bearer $ACCESS" \
    -H "Content-Type: text/html" \
    --data-binary "@$SERVE_DIR/$FILE")
  
  DOC_ID=$(echo "$RESULT" | jq -r '.id // empty')
  [ -n "$DOC_ID" ] || fail "Update failed: $(echo $RESULT | jq -r '.error.message // "unknown"')"
  log "Updated existing doc: https://docs.google.com/document/d/$DOC_ID"
else
  # Create new
  TMPDIR=$(mktemp -d)
  echo "{\"name\":\"$TITLE\",\"mimeType\":\"application/vnd.google-apps.document\",\"parents\":[\"$FOLDER_ID\"]}" > "$TMPDIR/meta.json"
  
  RESULT=$(curl -s -X POST "https://www.googleapis.com/upload/drive/v3/files?uploadType=multipart" \
    -H "Authorization: Bearer $ACCESS" \
    -F "metadata=@$TMPDIR/meta.json;type=application/json" \
    -F "file=@$SERVE_DIR/$FILE;type=text/html")
  
  rm -rf "$TMPDIR"
  
  DOC_ID=$(echo "$RESULT" | jq -r '.id // empty')
  [ -n "$DOC_ID" ] || fail "Upload failed: $(echo $RESULT | jq -r '.error.message // "unknown"')"
  log "Created new doc: https://docs.google.com/document/d/$DOC_ID"
fi

# ── Verify doc is accessible ──
VERIFY=$(curl -s -o /dev/null -w "%{http_code}" \
  "https://www.googleapis.com/drive/v3/files/$DOC_ID?fields=id" \
  -H "Authorization: Bearer $ACCESS")

if [ "$VERIFY" = "200" ]; then
  log "Verified: Doc accessible on Drive"
else
  warn "Doc created but verification returned HTTP $VERIFY"
fi

# Cleanup
rm -f /tmp/gog-token-deploy.json

echo ""
echo "── Drive Upload Complete ──"
echo "Doc ID: $DOC_ID"
echo "URL: https://docs.google.com/document/d/$DOC_ID"
