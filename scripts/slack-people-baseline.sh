#!/bin/bash
# Scans last 7 days of Slack to build per-person activity baselines
# for HMT's 8 direct reports
# Output: JSON to memory/slack-baselines.json

BOT_TOKEN=$(python3 -c "import json; print(json.load(open('/home/harsh/.openclaw/openclaw.json'))['channels']['slack']['botToken'])")
OLDEST=$(python3 -c "import time; print(int(time.time()) - 7*24*3600)")

# Channels to scan (Tier 1 + 2)
CHANNELS="CEWV0GMMG C035F6W8DK9 C0368KVCL2D C035QJ5A8G6 CS75DM3KQ C037H0GLYP4 CEHPPGSN9 C02178ASC4X C039S74GNP2 CEHPZTVD3"

# Direct reports with Slack IDs
declare -A REPORTS
REPORTS[U08L99D58PK]="Nikhil Nair"
REPORTS[U0719V1GX3Q]="Pranay Merchant"
REPORTS[U04A980D1N3]="Ashish Pandey"
REPORTS[U08UL9EHKKP]="Samir Kumar"
REPORTS[U08KBHHV9J4]="Radhika Vijay"
REPORTS[U07R906K9K5]="Nishita Banerjee"
REPORTS[U07LFSB0PM5]="Vismit Bansal"
REPORTS[U068F2RS5PV]="Nisha Ali"

# Co-founders
REPORTS[UEHET2Q2G]="Vinay Singhal"
REPORTS[UEJV57HQW]="Parveen Singhal"
REPORTS[UE0KTBS8P]="Shashank Vaishnav"

# Collect all messages
ALL_MSGS=""
for ch in $CHANNELS; do
    RESULT=$(curl -s -H "Authorization: Bearer $BOT_TOKEN" \
        "https://slack.com/api/conversations.history?channel=${ch}&limit=200&oldest=${OLDEST}")
    ALL_MSGS="${ALL_MSGS}${RESULT}\n"
done

# Count messages per person per channel
python3 -c "
import json, sys, os
from collections import defaultdict
from datetime import datetime

channels_raw = '''$ALL_MSGS'''

# Parse all messages
person_msgs = defaultdict(lambda: {'total': 0, 'channels': set(), 'days_active': set()})

reports = {
    'U08L99D58PK': 'Nikhil Nair',
    'U0719V1GX3Q': 'Pranay Merchant',
    'U04A980D1N3': 'Ashish Pandey',
    'U08UL9EHKKP': 'Samir Kumar',
    'U08KBHHV9J4': 'Radhika Vijay',
    'U07R906K9K5': 'Nishita Banerjee',
    'U07LFSB0PM5': 'Vismit Bansal',
    'U068F2RS5PV': 'Nisha Ali',
    'UEHET2Q2G': 'Vinay Singhal',
    'UEJV57HQW': 'Parveen Singhal',
    'UE0KTBS8P': 'Shashank Vaishnav'
}

# We need to parse the JSON results properly
# Each result is a full API response
import re
json_objects = re.findall(r'\{\"ok\".*?\}(?=\s*\{\"ok\"|\s*$)', channels_raw, re.DOTALL)

# Simpler approach: parse each line
for line in channels_raw.split('\n'):
    line = line.strip()
    if not line:
        continue
    try:
        data = json.loads(line)
        if data.get('ok'):
            for msg in data.get('messages', []):
                uid = msg.get('user', '')
                if uid in reports:
                    ts = float(msg.get('ts', 0))
                    day = datetime.fromtimestamp(ts).strftime('%Y-%m-%d')
                    person_msgs[uid]['total'] += 1
                    person_msgs[uid]['days_active'].add(day)
    except:
        pass

baselines = {}
for uid, name in reports.items():
    info = person_msgs.get(uid, {'total': 0, 'channels': set(), 'days_active': set()})
    baselines[name] = {
        'slackId': uid,
        'messagesLast7d': info['total'],
        'avgPerDay': round(info['total'] / 7, 1),
        'daysActive': len(info['days_active']),
        'baselinedAt': datetime.utcnow().strftime('%Y-%m-%dT%H:%M:%SZ')
    }

output = {
    'period': '7 days',
    'generatedAt': datetime.utcnow().strftime('%Y-%m-%dT%H:%M:%SZ'),
    'baselines': baselines
}

with open('/home/harsh/.openclaw/workspace/memory/slack-baselines.json', 'w') as f:
    json.dump(output, f, indent=2)

for name, data in sorted(baselines.items(), key=lambda x: x[1]['messagesLast7d'], reverse=True):
    print(f\"{name}: {data['messagesLast7d']} msgs / {data['daysActive']} days active / {data['avgPerDay']}/day avg\")
"
