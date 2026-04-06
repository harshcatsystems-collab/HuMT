#!/bin/bash
# Pregnancy week calculator - AUTHORITATIVE source
# EDD: September 4, 2026 (USG dating)
# Reference point: November 28, 2025 = Day 0

# Get today's date or use provided date
if [ -n "$1" ]; then
    TODAY="$1"
else
    TODAY=$(date +%Y-%m-%d)
fi

# Reference date (Day 0 for USG-adjusted dating)
REF_DATE="2025-11-28"
EDD="2026-09-04"

# Calculate days since reference
DAYS_SINCE=$(( ($(date -d "$TODAY" +%s) - $(date -d "$REF_DATE" +%s)) / 86400 ))
DAYS_TO_EDD=$(( ($(date -d "$EDD" +%s) - $(date -d "$TODAY" +%s)) / 86400 ))

# Calculate weeks and days
WEEKS=$((DAYS_SINCE / 7))
DAYS=$((DAYS_SINCE % 7))
WEEKS_TO_GO=$((DAYS_TO_EDD / 7))

# Determine trimester
if [ $WEEKS -lt 14 ]; then
    TRIMESTER="First"
elif [ $WEEKS -lt 28 ]; then
    TRIMESTER="Second"
else
    TRIMESTER="Third"
fi

# Determine month (approximate)
MONTH=$(( (WEEKS / 4) + 1 ))
if [ $MONTH -gt 10 ]; then MONTH=10; fi

echo "=== PREGNANCY CALCULATOR ==="
echo "Date: $TODAY"
echo "Reference (Day 0): $REF_DATE"
echo "EDD: $EDD"
echo ""
echo "Days since reference: $DAYS_SINCE"
echo "Current: Week $((WEEKS + 1)) (${WEEKS}w+${DAYS}d)"
echo "Trimester: $TRIMESTER"
echo "Approx Month: $MONTH"
echo ""
echo "Days to EDD: $DAYS_TO_EDD"
echo "Weeks to go: ~$WEEKS_TO_GO"
