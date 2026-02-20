#!/bin/bash
# verify-active-items.sh — Pre-brief stale item detector
# Runs before morning brief / evening debrief
# Checks: are any "Active" items actually resolved?
# Output: JSON with stale suspects + reason
#
# Two checks:
# 1. STRUCTURAL: Items marked ✅ but still in Active section (should be in Completed)
# 2. EVIDENCE: Active items whose keywords match resolution evidence in daily logs, 
#    capability-status, TOOLS.md, scripts/, research/

WORKSPACE="$HOME/.openclaw/workspace"
COMMITMENTS="$WORKSPACE/memory/commitments.md"
DELEGATIONS="$WORKSPACE/memory/delegations.md"
TODAY=$(date -u +%Y-%m-%d)
YESTERDAY=$(date -u -d "yesterday" +%Y-%m-%d)

# Build evidence corpus (only from sources that prove resolution)
EVIDENCE=$(mktemp)
for f in \
  "$WORKSPACE/memory/capability-status.md" \
  "$WORKSPACE/TOOLS.md" \
  "$WORKSPACE/memory/$TODAY.md" \
  "$WORKSPACE/memory/$YESTERDAY.md"; do
  [ -f "$f" ] && cat "$f" >> "$EVIDENCE"
done
# Add script/research file names as evidence
ls "$WORKSPACE/scripts/" 2>/dev/null >> "$EVIDENCE"
ls "$WORKSPACE/research/" 2>/dev/null >> "$EVIDENCE"

echo '{"checked_at":"'"$(date -u +%Y-%m-%dT%H:%M:%SZ)"'","stale":['

FIRST=true
emit() {
  [ "$FIRST" = true ] && FIRST=false || printf ","
  printf '{"file":"%s","item":"%s","what":"%s","reason":"%s"}' "$1" "$2" "$3" "$4"
}

# --- CHECK 1: Structural — ✅ items still in Active ---
for FILE in "$COMMITMENTS" "$DELEGATIONS"; do
  [ -f "$FILE" ] || continue
  BASENAME=$(basename "$FILE")
  awk '/^## Active/,/^## (Completed|Parked|---)/' "$FILE" | grep "^|" | grep "✅" | while IFS='|' read -r _ num rest; do
    num=$(echo "$num" | xargs)
    [ -z "$num" ] && continue
    # Extract "what" field
    what=$(echo "$rest" | cut -d'|' -f1 | xargs | sed 's/"/\\"/g')
    emit "$BASENAME" "$num" "$what" "Marked ✅ but still in Active section — move to Completed"
  done
done

# --- CHECK 2: Evidence-based — keyword matching ---
# Only check items that are NOT already marked ✅ or 📌 Earmarked
for FILE in "$COMMITMENTS" "$DELEGATIONS"; do
  [ -f "$FILE" ] || continue
  BASENAME=$(basename "$FILE")
  awk '/^## Active/,/^## (Completed|Parked|---)/' "$FILE" | grep "^|" | grep -v "✅" | grep -v "📌" | grep -v "^|---|" | grep -v "^| #" | while IFS='|' read -r _ num what rest; do
    num=$(echo "$num" | xargs)
    what=$(echo "$what" | xargs)
    [ -z "$num" ] && continue
    [ -z "$what" ] && continue
    
    what_lower=$(echo "$what" | tr '[:upper:]' '[:lower:]')
    MATCH=""
    
    # Specific capability checks (high confidence)
    echo "$what_lower" | grep -qi "snowflake" && grep -qi "snowflake.*\(72 tables\|brief.*live\|connected\)" "$EVIDENCE" 2>/dev/null && MATCH="Snowflake is live (72 tables, brief running)"
    echo "$what_lower" | grep -qi "cms.*api\|cms.*access" && grep -qi "stageapi\|cms.*1,256\|cms.*operational" "$EVIDENCE" 2>/dev/null && MATCH="CMS API is live (stageapi.stage.in)"
    echo "$what_lower" | grep -qi "metabase.*api\|metabase.*access" && grep -qi "metabase.*api.*key\|mb_TFdiv" "$EVIDENCE" 2>/dev/null && MATCH="Metabase API key exists"
    echo "$what_lower" | grep -qi "figma.*seat\|figma.*approval" && grep -qi "figma.*approved" "$EVIDENCE" 2>/dev/null && MATCH="Figma seat approved"
    
    # Don't flag other people's delegations as stale just because a keyword matches
    # Only flag if evidence is VERY specific (exact item reference)
    
    if [ -n "$MATCH" ]; then
      what_escaped=$(echo "$what" | sed 's/"/\\"/g')
      emit "$BASENAME" "$num" "$what_escaped" "$MATCH"
    fi
  done
done

echo ']}'
rm -f "$EVIDENCE"
