#!/usr/bin/env python3
"""Dialect Expansion Readiness Checker — scores a dialect vs Haryanvi launch benchmarks"""

import json, os, sys
from datetime import datetime, timezone, timedelta
from collections import Counter

DATA_FILE = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "data", "cms-catalog.json")
NOW = datetime.now(timezone.utc)

# Haryanvi at launch benchmarks (baseline for readiness scoring)
BENCHMARKS = {
    "min_active_titles": 50,
    "min_standard": 20,
    "min_microdrama": 10,
    "min_shows": 5,
    "min_weekly_velocity": 3,  # titles/week average over 4 weeks
}

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
    if len(sys.argv) < 2:
        print("Usage: cms-dialect-readiness.py <dialect_code> [dialect_code...]")
        print("       cms-dialect-readiness.py all")
        print("Example: cms-dialect-readiness.py mar")
        print("         cms-dialect-readiness.py har bho guj raj")
        sys.exit(1)

    with open(DATA_FILE) as f:
        catalog = json.load(f)
    items = catalog["items"]

    all_dialects = sorted(set(i.get("dialect") for i in items))
    requested = all_dialects if sys.argv[1] == "all" else sys.argv[1:]

    for dialect in requested:
        di = [i for i in items if i.get("dialect") == dialect]
        if not di:
            print(f"\n❌ Dialect '{dialect}' — not found in catalog (0 titles). Not launched yet.\n")
            # Score as 0
            print_readiness(dialect, 0, {}, {}, 0)
            continue

        active = [i for i in di if i.get("status") == "active"]
        active_count = len(active)
        format_mix = Counter(i.get("format", "unknown") for i in active)
        type_mix = Counter(i.get("contentType", "unknown") for i in active)

        # Velocity: titles created per week, last 4 weeks
        weekly_counts = []
        for w in range(4):
            ws = NOW - timedelta(weeks=w+1)
            we = NOW - timedelta(weeks=w)
            count = sum(1 for i in di if parse_date(i.get("createdAt")) and ws <= parse_date(i.get("createdAt")) < we)
            weekly_counts.append(count)
        avg_velocity = sum(weekly_counts) / len(weekly_counts) if weekly_counts else 0

        print(f"\n{'='*50}")
        print(f"  DIALECT READINESS: {dialect.upper()}")
        print(f"{'='*50}")
        print(f"  Total titles:    {len(di)}")
        print(f"  Active titles:   {active_count}")
        print(f"  Draft titles:    {len(di) - active_count}")
        print(f"\n  Format mix (active):")
        for fmt, c in format_mix.most_common():
            print(f"    {fmt:15s} {c:4d}")
        print(f"\n  Content type (active):")
        for ct, c in type_mix.most_common():
            print(f"    {ct:15s} {c:4d}")
        print(f"\n  Velocity (last 4 weeks): {weekly_counts} → avg {avg_velocity:.1f}/week")

        # Velocity trend
        if len(weekly_counts) >= 2:
            recent = sum(weekly_counts[:2]) / 2
            older = sum(weekly_counts[2:]) / 2
            if older > 0:
                trend = ((recent - older) / older) * 100
                trend_str = f"{'📈' if trend > 0 else '📉'} {trend:+.0f}%"
            else:
                trend_str = "📈 new activity" if recent > 0 else "⏸️ flat"
            print(f"  Velocity trend:  {trend_str}")

        print_readiness(dialect, active_count, format_mix, type_mix, avg_velocity)

def print_readiness(dialect, active_count, format_mix, type_mix, avg_velocity):
    B = BENCHMARKS
    scores = {}
    scores["active_titles"] = min(active_count / B["min_active_titles"], 1.0)
    scores["standard"] = min(format_mix.get("standard", 0) / B["min_standard"], 1.0)
    scores["microdrama"] = min(format_mix.get("microdrama", 0) / B["min_microdrama"], 1.0)
    scores["shows"] = min(type_mix.get("show", 0) / B["min_shows"], 1.0)
    scores["velocity"] = min(avg_velocity / B["min_weekly_velocity"], 1.0)

    overall = sum(scores.values()) / len(scores) * 100

    print(f"\n  📊 READINESS SCORE: {overall:.0f}/100")
    print(f"  {'Component':20s} {'Score':>6s} {'Actual':>8s} {'Benchmark':>10s}")
    print(f"  {'-'*20} {'-'*6} {'-'*8} {'-'*10}")
    print(f"  {'Active titles':20s} {scores['active_titles']*100:5.0f}% {active_count:>8d} {B['min_active_titles']:>10d}")
    print(f"  {'Standard format':20s} {scores['standard']*100:5.0f}% {format_mix.get('standard',0):>8d} {B['min_standard']:>10d}")
    print(f"  {'Microdramas':20s} {scores['microdrama']*100:5.0f}% {format_mix.get('microdrama',0):>8d} {B['min_microdrama']:>10d}")
    print(f"  {'Shows':20s} {scores['shows']*100:5.0f}% {type_mix.get('show',0):>8d} {B['min_shows']:>10d}")
    print(f"  {'Weekly velocity':20s} {scores['velocity']*100:5.0f}% {avg_velocity:>8.1f} {B['min_weekly_velocity']:>10d}")

    if overall >= 80:
        verdict = "✅ READY for launch"
    elif overall >= 50:
        verdict = "🟡 APPROACHING — needs more content"
    else:
        verdict = "🔴 NOT READY — significant gaps"
    print(f"\n  Verdict: {verdict}")
    print()

if __name__ == "__main__":
    main()
