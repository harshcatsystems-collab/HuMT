#!/usr/bin/env python3
"""CMS Alerts Module — checks for actionable issues in CMS catalog"""

import json, os, sys
from datetime import datetime, timezone, timedelta
from collections import defaultdict, Counter

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
    alerts = []

    # 1. Transcoding stuck > 48 hours
    cutoff_48h = NOW - timedelta(hours=48)
    stuck_tc = []
    for i in items:
        if i.get("transcodingStatus") in ("pending", "processing"):
            created = parse_date(i.get("createdAt"))
            if created and created < cutoff_48h:
                age_h = int((NOW - created).total_seconds() / 3600)
                stuck_tc.append((age_h, i))
    if stuck_tc:
        stuck_tc.sort(key=lambda x: -x[0])
        alert = f"🔴 TRANSCODING STUCK: {len(stuck_tc)} titles pending/processing > 48h"
        for age_h, i in stuck_tc[:5]:
            alert += f"\n   [{i.get('dialect','?')}] {age_h}h — {i.get('title','?')[:40]}"
        if len(stuck_tc) > 5:
            alert += f"\n   ... and {len(stuck_tc)-5} more"
        alerts.append(alert)

    # 2. Transcoding failed
    failed_tc = [i for i in items if i.get("transcodingStatus") == "failed"]
    if failed_tc:
        alert = f"🔴 TRANSCODING FAILED: {len(failed_tc)} titles"
        for i in failed_tc[:5]:
            alert += f"\n   [{i.get('dialect','?')}] {i.get('title','?')[:40]}"
        alerts.append(alert)

    # 3. Dialect with < 20 active titles
    active_by_dialect = Counter()
    for i in items:
        if i.get("status") == "active":
            active_by_dialect[i.get("dialect", "?")] += 1
    for dialect, count in sorted(active_by_dialect.items()):
        if count < 20:
            alerts.append(f"🟡 LOW DEPTH: {dialect} has only {count} active titles (< 20 threshold)")

    # 4. No new content in 7+ days for a dialect
    cutoff_7d = NOW - timedelta(days=7)
    all_dialects = set(i.get("dialect") for i in items)
    for dialect in sorted(all_dialects):
        recent = [i for i in items if i.get("dialect") == dialect
                  and parse_date(i.get("createdAt")) and parse_date(i.get("createdAt")) >= cutoff_7d]
        if not recent:
            alerts.append(f"🟡 STALE DIALECT: No new content for '{dialect}' in 7+ days")

    # 5. Draft pileup (> 10 drafts per dialect)
    drafts_by_dialect = Counter()
    for i in items:
        if i.get("status") == "draft":
            drafts_by_dialect[i.get("dialect", "?")] += 1
    for dialect, count in sorted(drafts_by_dialect.items()):
        if count > 10:
            alerts.append(f"🟠 DRAFT PILEUP: {dialect} has {count} drafts (> 10 threshold)")

    # Output
    if alerts:
        print(f"⚠️  CMS ALERTS — {NOW.strftime('%Y-%m-%d %H:%M UTC')}")
        print(f"   {len(alerts)} alert(s) found\n")
        for a in alerts:
            print(a)
            print()
    else:
        print(f"✅ CMS CLEAR — {NOW.strftime('%Y-%m-%d %H:%M UTC')} — No alerts")

    # Machine-readable output for piping
    if "--json" in sys.argv:
        print(json.dumps({"timestamp": NOW.isoformat(), "alertCount": len(alerts), "alerts": alerts}, indent=2))

    return len(alerts)

if __name__ == "__main__":
    sys.exit(0 if main() == 0 else 1)
