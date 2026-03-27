#!/bin/bash
# Reviews gaps between tier-1 channels and scan script
# Run weekly to catch important channels not being scanned
# Usage: bash scripts/slack-scan-gap-review.sh

cd /home/harsh/.openclaw/workspace

# Extract channel IDs from slack-scan-all.sh
grep -oP 'read_channel "\K[A-Z0-9]+' scripts/slack-scan-all.sh | sort -u > /tmp/scanned_channels.txt

python3 << 'PYEOF'
import json

# Load tier 1 channels
data = json.load(open('memory/slack-channel-map.json'))
tier1 = data['tiers']['tier1']

# Load scanned channels
with open('/tmp/scanned_channels.txt') as f:
    scanned_ids = set(line.strip() for line in f if line.strip())

# Known noise - channels that are tier1 by pattern but don't need scanning
KNOWN_NOISE = {
    'CE8TGJHC4',   # team1 - Hackathon
    'CEAF06RGE',   # v9-onefeed-dashboard - legacy
    'C05LT4FT4A3', # product-invoices - not strategic
}

# Find real gaps
gaps = []
for ch_id, ch_data in tier1.items():
    if ch_id not in scanned_ids and ch_id not in KNOWN_NOISE:
        gaps.append((ch_id, ch_data['name']))

if gaps:
    print("GAPS_FOUND")
    print(f"Tier 1 channels not in scan script ({len(gaps)}):")
    for ch_id, name in sorted(gaps, key=lambda x: x[1]):
        print(f"  #{name} ({ch_id})")
    print()
    print("Action: Review if these should be added to slack-scan-all.sh")
else:
    print("NO_GAPS")
    print("All important tier-1 channels are being scanned.")
PYEOF
