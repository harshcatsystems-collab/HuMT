#!/bin/bash
# CMS morning brief snippet — runs cms-morning-brief.py and outputs formatted text
cd /home/harsh/.openclaw/workspace

# Refresh catalog first (silent)
python3 scripts/cms-fetch-all.py > /dev/null 2>&1

# Generate brief snippet
python3 scripts/cms-morning-brief.py 2>/dev/null

# Run alerts
echo ""
python3 scripts/cms-alerts.py 2>/dev/null | grep -E "^(⚠️|🔴|📉)" | head -5
