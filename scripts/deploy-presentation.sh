#!/usr/bin/env bash
# deploy-presentation.sh — Single command to deploy a new/updated presentation
# Usage: bash scripts/deploy-presentation.sh [filename.html]
#   If filename given: verifies it exists, checks index.html links it, then deploys all
#   If no filename: deploys all files in data/serve/ to Netlify + uploads missing docs to Drive
#
# This is the hardened workflow. No excuses for skipping steps.

set -euo pipefail

SERVE_DIR="/home/harsh/.openclaw/workspace/data/serve"
NETLIFY_TOKEN="nfp_PwRzhCXjf6yo2bibKDf2reQs3fSVqcX9fc46"
SITE_ID="959eb730-9142-4be7-a332-29a4b80bad0c"
SITE_URL="https://humt-stage-analytics.netlify.app"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log() { echo -e "${GREEN}✓${NC} $1"; }
warn() { echo -e "${YELLOW}⚠${NC} $1"; }
fail() { echo -e "${RED}✗${NC} $1"; exit 1; }

# ── Step 0: Pre-flight checks ──
cd "$SERVE_DIR" || fail "data/serve/ directory not found"
[ -f "index.html" ] || fail "index.html missing"

# ── Step 1: If specific file given, validate it ──
if [ -n "${1:-}" ]; then
  FILE="$1"
  [ -f "$FILE" ] || fail "$FILE not found in data/serve/"
  
  # Check index.html links to it
  if ! grep -q "href=\"$FILE\"" index.html; then
    fail "$FILE exists but is NOT linked in index.html. Add it to index.html first."
  fi
  log "$FILE exists and is linked in index.html"
fi

# ── Step 2: Verify ALL html files are linked in index ──
UNLINKED=0
for f in *.html; do
  [ "$f" = "index.html" ] && continue
  [ "$f" = "TEMPLATE.html" ] && continue
  if ! grep -q "href=\"$f\"" index.html; then
    warn "$f is NOT linked in index.html"
    UNLINKED=$((UNLINKED + 1))
  fi
done
if [ $UNLINKED -gt 0 ]; then
  fail "$UNLINKED file(s) not linked in index.html. Fix index first."
fi
log "All $(ls *.html | grep -v index.html | wc -l) files linked in index.html"

# ── Step 2b: Verify ALL html files have OG tags ──
NO_OG=0
for f in *.html; do
  [ "$f" = "index.html" ] && continue
  [ "$f" = "TEMPLATE.html" ] && continue
  if ! grep -q 'og:title' "$f"; then
    warn "$f has NO Open Graph tags"
    NO_OG=$((NO_OG + 1))
  fi
done
if [ $NO_OG -gt 0 ]; then
  fail "$NO_OG file(s) missing OG tags. Use TEMPLATE.html or add og:title/og:description/og:image."
fi
log "All files have Open Graph meta tags"

# ── Step 2c: Verify ALL html files have HuMT header avatar in body ──
NO_AVATAR=0
for f in *.html; do
  [ "$f" = "index.html" ] && continue
  [ "$f" = "TEMPLATE.html" ] && continue
  # Check avatar appears in body (not just OG meta)
  if ! python3 -c "c=open('$f').read(); body=c.split('<body>')[1] if '<body>' in c else ''; exit(0 if 'humt-avatar.png' in body else 1)"; then
    warn "$f has NO header avatar stamp"
    NO_AVATAR=$((NO_AVATAR + 1))
  fi
done
if [ $NO_AVATAR -gt 0 ]; then
  fail "$NO_AVATAR file(s) missing header avatar. Use TEMPLATE.html or add the HuMT header."
fi
log "All files have HuMT header avatar"

# ── Step 3: Deploy to Netlify ──
echo ""
echo "Deploying to Netlify..."

FILES_JSON="{}"
for f in *.html *.png *.jpg *.svg 2>/dev/null; do
  [ -f "$f" ] || continue
  HASH=$(openssl dgst -sha1 "$f" | awk '{print $2}')
  FILES_JSON=$(echo "$FILES_JSON" | jq --arg path "/$f" --arg hash "$HASH" '. + {($path): $hash}')
done

DEPLOY=$(curl -s -X POST "https://api.netlify.com/api/v1/sites/$SITE_ID/deploys" \
  -H "Authorization: Bearer $NETLIFY_TOKEN" \
  -H "Content-Type: application/json" \
  -d "{\"files\": $FILES_JSON}")

DEPLOY_ID=$(echo "$DEPLOY" | jq -r '.id')
REQUIRED=$(echo "$DEPLOY" | jq -r '.required[]' 2>/dev/null || true)

if [ -z "$DEPLOY_ID" ] || [ "$DEPLOY_ID" = "null" ]; then
  fail "Netlify deploy creation failed: $(echo $DEPLOY | jq -r '.message // .error')"
fi

UPLOAD_COUNT=0
for HASH in $REQUIRED; do
  for f in *.html *.png *.jpg *.svg 2>/dev/null; do
    [ -f "$f" ] || continue
    H=$(openssl dgst -sha1 "$f" | awk '{print $2}')
    if [ "$H" = "$HASH" ]; then
      curl -s -X PUT "https://api.netlify.com/api/v1/deploys/$DEPLOY_ID/files//$f" \
        -H "Authorization: Bearer $NETLIFY_TOKEN" \
        -H "Content-Type: application/octet-stream" \
        --data-binary "@$f" > /dev/null
      UPLOAD_COUNT=$((UPLOAD_COUNT + 1))
      break
    fi
  done
done

log "Netlify deployed (ID: $DEPLOY_ID, uploaded: $UPLOAD_COUNT files)"

# ── Step 4: Verify deployment ──
sleep 2
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" "$SITE_URL/index.html")
if [ "$HTTP_CODE" = "200" ]; then
  log "Site live: $SITE_URL (HTTP $HTTP_CODE)"
else
  warn "Site returned HTTP $HTTP_CODE — may still be propagating"
fi

# ── Step 5: Check specific file if given ──
if [ -n "${1:-}" ]; then
  HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" "$SITE_URL/$1")
  if [ "$HTTP_CODE" = "200" ]; then
    log "$1 live: $SITE_URL/$1"
  else
    warn "$1 returned HTTP $HTTP_CODE"
  fi
fi

echo ""

# ── Step 6: Upload to Google Drive (if file specified + folder given) ──
DRIVE_FOLDER="${2:-}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ -n "${1:-}" ] && [ -n "$DRIVE_FOLDER" ]; then
  echo "Uploading to Google Drive..."
  bash "$SCRIPT_DIR/upload-to-drive.sh" "$1" "$DRIVE_FOLDER"
elif [ -n "${1:-}" ] && [ -z "$DRIVE_FOLDER" ]; then
  echo -e "${YELLOW}⚠${NC} No Drive folder specified. To also upload to Drive, run:"
  echo "  bash scripts/deploy-presentation.sh $1 <meetings|strategy|presentations>"
fi

echo ""
echo "── Summary ──"
echo "Files on site: $(ls *.html | wc -l)"
echo "Site URL: $SITE_URL"
echo ""
echo "Usage: bash scripts/deploy-presentation.sh <file.html> <meetings|strategy|presentations>"
echo "  Omit args to deploy-only. Add folder to deploy + upload to Drive in one command."
