#!/usr/bin/env python3
"""CMS Pipeline Dashboard — reads cms-catalog.json and outputs comprehensive report"""

import json, os, sys
from datetime import datetime, timezone, timedelta
from collections import defaultdict, Counter

DATA_FILE = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "data", "cms-catalog.json")
NOW = datetime.now(timezone.utc)

def load():
    with open(DATA_FILE) as f:
        return json.load(f)

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
    # Handle the verbose format from releaseDate
    try:
        # "Thu Feb 18 2026 09:12:03 GMT+0000 (...)"
        parts = s.split(" GMT")[0]
        d = datetime.strptime(parts, "%a %b %d %Y %H:%M:%S")
        return d.replace(tzinfo=timezone.utc)
    except:
        return None

def section(title):
    print(f"\n{'='*60}")
    print(f"  {title}")
    print(f"{'='*60}")

def main():
    catalog = load()
    items = catalog["items"]
    fetched_at = catalog.get("fetchedAt", "unknown")
    print(f"📊 CMS PIPELINE REPORT — {NOW.strftime('%Y-%m-%d %H:%M UTC')}")
    print(f"   Data from: {fetched_at} | {len(items)} items")

    # --- 1. Total content by dialect, format, status ---
    section("1. CONTENT BREAKDOWN")

    by_dialect = Counter(i.get("dialect", "unknown") for i in items)
    by_format = Counter(i.get("format", "unknown") for i in items)
    by_status = Counter(i.get("status", "unknown") for i in items)

    print("\n  By Dialect:")
    for d, c in sorted(by_dialect.items(), key=lambda x: -x[1]):
        print(f"    {d:12s} {c:5d}")

    print("\n  By Format:")
    for f, c in sorted(by_format.items(), key=lambda x: -x[1]):
        print(f"    {f:12s} {c:5d}")

    print("\n  By Status:")
    for s, c in sorted(by_status.items(), key=lambda x: -x[1]):
        print(f"    {s:12s} {c:5d}")

    # Cross-tab: dialect x format x status
    print("\n  Dialect × Format × Status:")
    print(f"    {'Dialect':10s} {'Format':12s} {'active':>7s} {'draft':>7s} {'total':>7s}")
    print(f"    {'-'*10} {'-'*12} {'-'*7} {'-'*7} {'-'*7}")
    cross = defaultdict(lambda: defaultdict(lambda: Counter()))
    for i in items:
        cross[i.get("dialect","?")][i.get("format","?")][i.get("status","?")] += 1
    for dialect in sorted(cross):
        for fmt in sorted(cross[dialect]):
            sc = cross[dialect][fmt]
            print(f"    {dialect:10s} {fmt:12s} {sc.get('active',0):7d} {sc.get('draft',0):7d} {sum(sc.values()):7d}")

    # --- 2. Drafts stuck > 7 days ---
    section("2. DRAFTS STUCK > 7 DAYS")
    cutoff_7d = NOW - timedelta(days=7)
    stuck = []
    for i in items:
        if i.get("status") == "draft":
            created = parse_date(i.get("createdAt"))
            if created and created < cutoff_7d:
                age = (NOW - created).days
                stuck.append((age, i))
    stuck.sort(key=lambda x: -x[0])
    print(f"\n  {len(stuck)} drafts older than 7 days")
    for age, i in stuck[:20]:
        print(f"    [{i.get('dialect','?'):3s}] {age:3d}d  {i.get('title','?')[:50]}")
    if len(stuck) > 20:
        print(f"    ... and {len(stuck)-20} more")

    # --- 3. Transcoding pending/failed ---
    section("3. TRANSCODING ISSUES")
    tc_issues = defaultdict(list)
    for i in items:
        ts = i.get("transcodingStatus", "")
        if ts in ("pending", "failed", "processing"):
            tc_issues[ts].append(i)
    for status, titles in sorted(tc_issues.items()):
        print(f"\n  {status.upper()}: {len(titles)}")
        for t in titles[:10]:
            created = parse_date(t.get("createdAt"))
            age = f"{(NOW - created).days}d" if created else "?"
            print(f"    [{t.get('dialect','?'):3s}] {age:>4s}  {t.get('title','?')[:50]}")
        if len(titles) > 10:
            print(f"    ... and {len(titles)-10} more")

    # --- 4. New titles last 7 days by dialect ---
    section("4. NEW TITLES (LAST 7 DAYS)")
    new_by_dialect = defaultdict(list)
    for i in items:
        created = parse_date(i.get("createdAt"))
        if created and created >= cutoff_7d:
            new_by_dialect[i.get("dialect", "?")].append(i)
    total_new = sum(len(v) for v in new_by_dialect.values())
    print(f"\n  {total_new} new titles in last 7 days")
    for d in sorted(new_by_dialect):
        titles = new_by_dialect[d]
        print(f"\n  {d} ({len(titles)}):")
        for t in titles[:5]:
            print(f"    {t.get('status','?'):6s} {t.get('format','?'):10s} {t.get('title','?')[:50]}")
        if len(titles) > 5:
            print(f"    ... and {len(titles)-5} more")

    # --- 5. Content velocity (last 4 weeks) ---
    section("5. CONTENT VELOCITY (LAST 4 WEEKS)")
    print(f"\n  {'Dialect':10s}", end="")
    week_starts = []
    for w in range(3, -1, -1):
        ws = NOW - timedelta(weeks=w+1)
        we = NOW - timedelta(weeks=w)
        week_starts.append((ws, we))
        print(f" {'Wk-'+str(w):>6s}", end="")
    print(f" {'Total':>6s}")

    all_dialects = sorted(set(i.get("dialect","?") for i in items))
    for dialect in all_dialects:
        print(f"  {dialect:10s}", end="")
        total = 0
        for ws, we in week_starts:
            count = sum(1 for i in items
                       if i.get("dialect") == dialect
                       and parse_date(i.get("createdAt")) and ws <= parse_date(i.get("createdAt")) < we)
            total += count
            print(f" {count:6d}", end="")
        print(f" {total:6d}")

    # --- 6. Creator activity ---
    section("6. CREATOR ACTIVITY")
    by_creator = Counter(i.get("createdBy", "unknown") for i in items)
    print(f"\n  Top creators (all time):")
    for creator, count in by_creator.most_common(15):
        print(f"    {count:5d}  {creator}")

    # Recent activity (last 7 days)
    recent_creator = Counter()
    for i in items:
        created = parse_date(i.get("createdAt"))
        if created and created >= cutoff_7d:
            recent_creator[i.get("createdBy", "unknown")] += 1
    if recent_creator:
        print(f"\n  Top creators (last 7 days):")
        for creator, count in recent_creator.most_common(10):
            print(f"    {count:5d}  {creator}")

    # --- 7. Dialect depth comparison ---
    section("7. DIALECT DEPTH COMPARISON")
    print(f"\n  {'Dialect':10s} {'Total':>6s} {'Active':>7s} {'Draft':>6s} {'Std':>5s} {'Micro':>6s} {'Movie':>6s} {'Show':>6s}")
    print(f"  {'-'*10} {'-'*6} {'-'*7} {'-'*6} {'-'*5} {'-'*6} {'-'*6} {'-'*6}")
    for dialect in all_dialects:
        di = [i for i in items if i.get("dialect") == dialect]
        active = sum(1 for i in di if i.get("status") == "active")
        draft = sum(1 for i in di if i.get("status") == "draft")
        std = sum(1 for i in di if i.get("format") == "standard")
        micro = sum(1 for i in di if i.get("format") == "microdrama")
        movie = sum(1 for i in di if i.get("contentType") == "movie")
        show = sum(1 for i in di if i.get("contentType") == "show")
        print(f"  {dialect:10s} {len(di):6d} {active:7d} {draft:6d} {std:5d} {micro:6d} {movie:6d} {show:6d}")

    print(f"\n{'='*60}")
    print(f"  Report generated: {NOW.strftime('%Y-%m-%d %H:%M UTC')}")
    print(f"{'='*60}")

if __name__ == "__main__":
    main()
