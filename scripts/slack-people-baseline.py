#!/usr/bin/env python3
"""Build activity baselines for HMT's direct reports + co-founders."""

import json, time, os
from collections import defaultdict
from datetime import datetime
from urllib.request import Request, urlopen

CONFIG = os.path.expanduser("~/.openclaw/openclaw.json")
OUTPUT = os.path.expanduser("~/.openclaw/workspace/memory/slack-baselines.json")

CHANNELS = [
    "CEWV0GMMG", "C035F6W8DK9", "C0368KVCL2D", "C035QJ5A8G6",
    "CS75DM3KQ", "C037H0GLYP4", "CEHPPGSN9", "C02178ASC4X",
    "C039S74GNP2", "CEHPZTVD3", "CDZFAJLBV"
]

CHANNEL_NAMES = {
    "CEWV0GMMG": "#product", "C035F6W8DK9": "#product-design",
    "C0368KVCL2D": "#product-analytics", "C035QJ5A8G6": "#product_prd",
    "CS75DM3KQ": "#feedback", "C037H0GLYP4": "#marketing",
    "CEHPPGSN9": "#tech-mates", "C02178ASC4X": "#haryanvi",
    "C039S74GNP2": "#rajasthani", "CEHPZTVD3": "#krantikaari",
    "CDZFAJLBV": "#announcements"
}

PEOPLE = {
    "U08L99D58PK": "Nikhil Nair",
    "U0719V1GX3Q": "Pranay Merchant",
    "U04A980D1N3": "Ashish Pandey",
    "U08UL9EHKKP": "Samir Kumar",
    "U08KBHHV9J4": "Radhika Vijay",
    "U07R906K9K5": "Nishita Banerjee",
    "U07LFSB0PM5": "Vismit Bansal",
    "U068F2RS5PV": "Nisha Ali",
    "UEHET2Q2G": "Vinay Singhal",
    "UEJV57HQW": "Parveen Singhal",
    "UE0KTBS8P": "Shashank Vaishnav"
}

def get_token():
    with open(CONFIG) as f:
        return json.load(f)["channels"]["slack"]["botToken"]

def fetch_channel(token, ch_id, oldest):
    url = f"https://slack.com/api/conversations.history?channel={ch_id}&limit=200&oldest={oldest}"
    req = Request(url, headers={"Authorization": f"Bearer {token}"})
    resp = urlopen(req, timeout=10)
    return json.loads(resp.read())

def main():
    token = get_token()
    oldest = int(time.time()) - 7 * 24 * 3600
    
    stats = {uid: {"total": 0, "channels": set(), "days": set()} for uid in PEOPLE}
    
    for ch_id in CHANNELS:
        try:
            data = fetch_channel(token, ch_id, oldest)
            if data.get("ok"):
                for msg in data.get("messages", []):
                    uid = msg.get("user", "")
                    if uid in PEOPLE:
                        ts = float(msg.get("ts", 0))
                        day = datetime.fromtimestamp(ts).strftime("%Y-%m-%d")
                        stats[uid]["total"] += 1
                        stats[uid]["channels"].add(CHANNEL_NAMES.get(ch_id, ch_id))
                        stats[uid]["days"].add(day)
        except Exception as e:
            print(f"Error scanning {ch_id}: {e}")
    
    baselines = {}
    for uid, name in PEOPLE.items():
        s = stats[uid]
        baselines[name] = {
            "slackId": uid,
            "messagesLast7d": s["total"],
            "avgPerDay": round(s["total"] / 7, 1),
            "daysActive": len(s["days"]),
            "channelsActive": sorted(list(s["channels"])),
            "baselinedAt": datetime.utcnow().strftime("%Y-%m-%dT%H:%M:%SZ")
        }
    
    output = {
        "period": "7 days",
        "generatedAt": datetime.utcnow().strftime("%Y-%m-%dT%H:%M:%SZ"),
        "baselines": baselines
    }
    
    with open(OUTPUT, "w") as f:
        json.dump(output, f, indent=2)
    
    print("People baselines (last 7 days):")
    for name, data in sorted(baselines.items(), key=lambda x: x[1]["messagesLast7d"], reverse=True):
        chs = ", ".join(data["channelsActive"]) or "none"
        print(f"  {name}: {data['messagesLast7d']} msgs, {data['daysActive']}/7 days, {data['avgPerDay']}/day — channels: {chs}")

if __name__ == "__main__":
    main()
