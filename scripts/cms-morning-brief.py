#!/usr/bin/env python3
"""CMS Morning Brief — outputs 3-4 line summary for injection into morning brief"""

import json, os
from datetime import datetime, timezone, timedelta
from collections import Counter

DATA_FILE = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "data", "cms-catalog.json")
NOW = datetime.now(timezone.utc)

def parse_date(s):
    if not s:
        return None
    for fmt in ["%Y-%m-%dT%H:%M:%S.%fZ", "%Y-%m-%dT%H:%M:%S.%f%z"]:
        try:
            d = datetime.strptime(s, fmt)
            if d.tzinfo is None:
                d = d.replace(tzinfo=timezone.utc)
            return d
        except ValueError:
            continue
    try:
        parts = s.split(" GMT")[0]
        d = datetime.strptime(parts, "%a %b %d %Y %H:%M:%S")
        return d.replace(tzinfo=timezone.utc)
    except:
        return None

def main():
    with open(DATA_FILE) as f:
        catalog = json.load(f)
    items = catalog["items"]
    cutoff_7d = NOW - timedelta(days=7)
    cutoff_48h = NOW - timedelta(hours=48)

    # New this week
    new_this_week = [i for i in items if parse_date(i.get("createdAt")) and parse_date(i.get("createdAt")) >= cutoff_7d]
    new_by_dialect = Counter(i.get("dialect") for i in new_this_week)
    new_active = sum(1 for i in new_this_week if i.get("status") == "active")

    # Pipeline health
    total_active = sum(1 for i in items if i.get("status") == "active")
    total_draft = sum(1 for i in items if i.get("status") == "draft")
    tc_stuck = sum(1 for i in items
                   if i.get("transcodingStatus") in ("pending", "processing")
                   and parse_date(i.get("createdAt")) and parse_date(i.get("createdAt")) < cutoff_48h)
    tc_failed = sum(1 for i in items if i.get("transcodingStatus") == "failed")

    # Alert count
    alert_items = []
    if tc_stuck > 0:
        alert_items.append(f"{tc_stuck} transcoding stuck")
    if tc_failed > 0:
        alert_items.append(f"{tc_failed} failed")

    # Draft pileup per dialect
    drafts_by_d = Counter(i.get("dialect") for i in items if i.get("status") == "draft")
    pileups = [f"{d}:{c}" for d, c in drafts_by_d.items() if c > 10]
    if pileups:
        alert_items.append(f"draft pileup: {', '.join(pileups)}")

    # Build brief
    dialect_str = ", ".join(f"{d}:{c}" for d, c in sorted(new_by_dialect.items(), key=lambda x: -x[1]))
    lines = [
        f"📺 CMS: {len(new_this_week)} new titles this week ({dialect_str}), {new_active} already active.",
        f"📦 Pipeline: {total_active} active / {total_draft} drafts across {len(set(i.get('dialect') for i in items))} dialects.",
    ]
    if alert_items:
        lines.append(f"⚠️ Alerts: {'; '.join(alert_items)}.")
    else:
        lines.append("✅ No CMS alerts.")

    print("\n".join(lines))

if __name__ == "__main__":
    main()
