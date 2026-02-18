#!/usr/bin/env python3
"""
Slack scanner with thread expansion.
Reads top-level messages AND their thread replies for richer context.

Usage: slack-scan-threads.py [hours_back] [--tier1-only] [--threads=on|off|tier1]
Default: 24 hours, all tiers, threads on for tier1
"""

import json, sys, os, time, datetime, argparse, threading
from urllib.request import Request, urlopen
from urllib.error import HTTPError
from concurrent.futures import ThreadPoolExecutor, as_completed

# Load config
config_path = os.path.expanduser("~/.openclaw/openclaw.json")
with open(config_path) as f:
    config = json.load(f)
BOT_TOKEN = config["channels"]["slack"]["botToken"]

# Load channel map
channel_map_path = os.path.expanduser("~/.openclaw/workspace/memory/slack-channel-map.json")
with open(channel_map_path) as f:
    channel_map = json.load(f)

# Rate limiting — thread-safe
api_calls = 0
api_lock = threading.Lock()
rate_semaphore = threading.Semaphore(10)  # max 10 concurrent requests

def slack_api(endpoint, params=None):
    """Call Slack API with thread-safe rate limiting."""
    global api_calls
    
    url = f"https://slack.com/api/{endpoint}"
    if params:
        query = "&".join(f"{k}={v}" for k, v in params.items())
        url += f"?{query}"
    
    req = Request(url, headers={"Authorization": f"Bearer {BOT_TOKEN}"})
    
    with rate_semaphore:
        for attempt in range(3):
            try:
                with api_lock:
                    api_calls += 1
                time.sleep(0.05)  # 50ms between requests = ~200 req/min across 10 workers
                resp = urlopen(req, timeout=15)
                data = json.loads(resp.read())
                
                if not data.get("ok"):
                    if data.get("error") == "ratelimited":
                        retry_after = int(data.get("headers", {}).get("Retry-After", 5))
                        print(f"  [Rate limited, waiting {retry_after}s]", file=sys.stderr)
                        time.sleep(retry_after)
                        continue
                    return data
                return data
            except HTTPError as e:
                if e.code == 429:
                    time.sleep(5)
                    continue
                raise
    return {"ok": False, "error": "max_retries"}


def get_channel_messages(channel_id, oldest, limit=200):
    """Get top-level messages from a channel."""
    return slack_api("conversations.history", {
        "channel": channel_id,
        "oldest": str(oldest),
        "limit": str(limit)
    })


def get_thread_replies(channel_id, thread_ts, oldest):
    """Get replies in a thread."""
    return slack_api("conversations.replies", {
        "channel": channel_id,
        "ts": thread_ts,
        "oldest": str(oldest),
        "limit": "100"
    })


def format_time(ts):
    """Convert Slack timestamp to HH:MM."""
    return datetime.datetime.fromtimestamp(float(ts)).strftime("%H:%M")


def scan_channel(channel_id, channel_name, oldest, expand_threads=True, msg_limit=200, max_threads=15):
    """Scan a channel, optionally expanding threads."""
    
    result = get_channel_messages(channel_id, oldest, msg_limit)
    if not result.get("ok"):
        err = result.get("error", "unknown")
        if err not in ("channel_not_found", "not_in_channel"):
            print(f"  ERROR: {err}", file=sys.stderr)
        return None
    
    messages = result.get("messages", [])
    if not messages:
        return None
    
    output = {
        "channel_id": channel_id,
        "channel_name": channel_name,
        "top_level_count": len(messages),
        "thread_reply_count": 0,
        "messages": []
    }
    
    SKIP_SUBTYPES = {'channel_join','channel_leave','channel_purpose','channel_topic','channel_name','channel_archive','channel_unarchive','bot_add','bot_remove','group_join','group_leave'}
    
    # Process messages (they come newest-first, reverse for chronological)
    for msg in reversed(messages):
        if msg.get("subtype", "") in SKIP_SUBTYPES:
            continue
        ts = msg.get("ts", "0")
        user = msg.get("user", msg.get("username", "bot"))
        text = msg.get("text", "").replace("\n", " ")[:300]
        reply_count = msg.get("reply_count", 0)
        
        output["messages"].append({
            "ts": ts,
            "time": format_time(ts),
            "user": user,
            "text": text,
            "is_thread_parent": reply_count > 0,
            "reply_count": reply_count,
            "is_reply": False
        })
        
        # Expand threads if enabled and message has replies
        if expand_threads and reply_count > 0:
            thread_result = get_thread_replies(channel_id, ts, oldest)
            if thread_result and thread_result.get("ok"):
                thread_msgs = thread_result.get("messages", [])
                # Skip first message (it's the parent)
                replies = [m for m in thread_msgs if m.get("ts") != ts]
                output["thread_reply_count"] += len(replies)
                
                for reply in replies:
                    r_ts = reply.get("ts", "0")
                    r_user = reply.get("user", reply.get("username", "bot"))
                    r_text = reply.get("text", "").replace("\n", " ")[:300]
                    
                    output["messages"].append({
                        "ts": r_ts,
                        "time": format_time(r_ts),
                        "user": r_user,
                        "text": r_text,
                        "is_thread_parent": False,
                        "reply_count": 0,
                        "is_reply": True,
                        "parent_ts": ts
                    })
            
            max_threads -= 1
            if max_threads <= 0:
                break
    
    # Re-sort all messages chronologically
    output["messages"].sort(key=lambda m: float(m["ts"]))
    
    return output


def print_channel(data):
    """Print channel scan results in human-readable format."""
    if not data:
        return
    
    total = data["top_level_count"] + data["thread_reply_count"]
    thread_info = f" + {data['thread_reply_count']} thread replies" if data["thread_reply_count"] > 0 else ""
    
    print(f"\n=== {data['channel_name']} ({data['channel_id']}) — {data['top_level_count']} messages{thread_info} ===")
    
    for msg in data["messages"]:
        prefix = "    ↳ " if msg["is_reply"] else "  "
        thread_marker = f" [🧵 {msg['reply_count']} replies]" if msg["is_thread_parent"] else ""
        print(f"{prefix}{msg['time']} | {msg['user']} | {msg['text'][:200]}{thread_marker}")


def get_tier_channels(tier_keys):
    """Get channels from specified tier keys in channel map."""
    channels = {}
    for key in tier_keys:
        if key in channel_map and isinstance(channel_map[key], dict):
            channels.update(channel_map[key])
    return channels


def get_all_joined_channels():
    """Fetch ALL channels the bot is in from Slack API."""
    all_channels = {}
    for ctype in ("public_channel", "private_channel"):
        cursor = ""
        while True:
            resp = slack_api("conversations.list", {
                "types": ctype,
                "limit": "200",
                "exclude_archived": "true",
                "cursor": cursor
            })
            if not resp or not resp.get("ok"):
                break
            for ch in resp.get("channels", []):
                if ch.get("is_member"):
                    all_channels[ch["id"]] = f"#{ch['name']}"
            cursor = resp.get("response_metadata", {}).get("next_cursor", "")
            if not cursor:
                break
    return all_channels


def main():
    parser = argparse.ArgumentParser(description="Slack scanner with thread expansion")
    parser.add_argument("hours_back", nargs="?", type=int, default=24, help="Hours to look back")
    parser.add_argument("--threads", choices=["on", "off", "tier1"], default="tier1",
                       help="Thread expansion: on=all, off=none, tier1=only tier1 channels")
    parser.add_argument("--tier1-only", action="store_true", help="Only scan Tier 1")
    parser.add_argument("--all", action="store_true", help="Scan ALL 353 channels (not just mapped)")
    parser.add_argument("--json", action="store_true", help="Output JSON instead of text")
    args = parser.parse_args()
    
    oldest = int(time.time()) - args.hours_back * 3600
    
    # Define tier groups
    tier1_keys = [
        "tier1_product", "tier1_founders", "tier1_retention_lifecycle",
        "tier1_acquisition_growth", "tier1_people_culture",
        "tier1_consumer_insights", "tier1_content_strategy",
        "tier1_strategy_cross_org"
    ]
    tier2_keys = [
        "tier2_hiring", "tier2_tech", "tier2_regional", "tier2_other",
        "tier2_growth", "tier2_people"
    ]
    tier3_keys = ["tier3_key"]
    
    # Build scan plan
    scan_plan = []
    
    tier1_channels = get_tier_channels(tier1_keys)
    for ch_id, ch_name in tier1_channels.items():
        expand = args.threads in ("on", "tier1")
        scan_plan.append((ch_id, ch_name, expand, 50, 15))  # limit, max_threads
    
    if not args.tier1_only:
        tier2_channels = get_tier_channels(tier2_keys)
        for ch_id, ch_name in tier2_channels.items():
            expand = args.threads == "on"
            scan_plan.append((ch_id, ch_name, expand, 30, 5))
        
        tier3_channels = get_tier_channels(tier3_keys)
        for ch_id, ch_name in tier3_channels.items():
            scan_plan.append((ch_id, ch_name, False, 20, 0))
    
    # Execute scan
    print(f"{'=' * 50}")
    print(f"SLACK SCAN — Last {args.hours_back}h (threads: {args.threads})")
    print(f"Scanning {len(scan_plan)} channels...")
    print(f"{'=' * 50}")
    
    all_results = []
    active_channels = 0
    total_messages = 0
    total_threads = 0
    
    current_tier = ""
    tier_labels = {
        "tier1_product": "━━━ TIER 1: PRODUCT ━━━",
        "tier1_founders": "━━━ TIER 1: FOUNDERS ━━━",
        "tier1_retention_lifecycle": "━━━ TIER 1: RETENTION & LIFECYCLE ━━━",
        "tier1_acquisition_growth": "━━━ TIER 1: ACQUISITION & GROWTH ━━━",
        "tier1_people_culture": "━━━ TIER 1: PEOPLE & CULTURE ━━━",
        "tier1_consumer_insights": "━━━ TIER 1: CONSUMER INSIGHTS & RESEARCH ━━━",
        "tier1_content_strategy": "━━━ TIER 1: CONTENT STRATEGY ━━━",
        "tier1_strategy_cross_org": "━━━ TIER 1: CROSS-ORG STRATEGY ━━━",
        "tier2_hiring": "━━━ TIER 2: HIRING ━━━",
        "tier2_tech": "━━━ TIER 2: TECH ━━━",
        "tier2_regional": "━━━ TIER 2: REGIONAL & MARKETING ━━━",
        "tier2_other": "━━━ TIER 2: OTHER ━━━",
        "tier2_growth": "━━━ TIER 2: GROWTH ━━━",
        "tier2_people": "━━━ TIER 2: PEOPLE ━━━",
        "tier3_key": "━━━ TIER 3: COMPANY PULSE ━━━",
    }
    
    # Build jobs list: (tier_key, ch_id, ch_name, expand, limit, max_threads)
    jobs = []
    all_tier_keys = tier1_keys + ([] if args.tier1_only else tier2_keys + tier3_keys)
    
    for tier_key in all_tier_keys:
        if tier_key in channel_map and isinstance(channel_map[tier_key], dict):
            channels = channel_map[tier_key]
            if not channels:
                continue
            for ch_id, ch_name in channels.items():
                if tier_key.startswith("tier1"):
                    expand = args.threads in ("on", "tier1")
                    limit, max_t = 50, 15
                elif tier_key.startswith("tier2"):
                    expand = args.threads == "on"
                    limit, max_t = 30, 5
                else:
                    expand = False
                    limit, max_t = 20, 0
                jobs.append((tier_key, ch_id, ch_name, expand, limit, max_t))
    
    # Parallel scan
    results_by_tier = {}
    with ThreadPoolExecutor(max_workers=10) as executor:
        future_map = {}
        for tier_key, ch_id, ch_name, expand, limit, max_t in jobs:
            f = executor.submit(scan_channel, ch_id, ch_name, oldest, expand, limit, max_t)
            future_map[f] = (tier_key, ch_id, ch_name)
        
        for future in as_completed(future_map):
            tier_key, ch_id, ch_name = future_map[future]
            try:
                data = future.result()
                if data:
                    results_by_tier.setdefault(tier_key, []).append(data)
            except Exception as e:
                print(f"  ERROR scanning {ch_name}: {e}", file=sys.stderr)
    
    # Print in tier order
    for tier_key in all_tier_keys:
        tier_results = results_by_tier.get(tier_key, [])
        if not tier_results:
            continue
        print(f"\n{tier_labels.get(tier_key, tier_key)}")
        # Sort by channel name for consistent output
        for data in sorted(tier_results, key=lambda d: d["channel_name"]):
            print_channel(data)
            all_results.append(data)
            active_channels += 1
            total_messages += data["top_level_count"]
            total_threads += data["thread_reply_count"]
    
    # Scan remaining unmapped channels if --all
    if args.all and not args.tier1_only:
        # Get all mapped channel IDs
        mapped_ids = set()
        for tier_key, channels in channel_map.items():
            if isinstance(channels, dict) and tier_key not in ("co_founders", "hmt", "direct_reports"):
                mapped_ids.update(channels.keys())
        
        # Fetch all joined channels from API
        all_joined = get_all_joined_channels()
        unmapped = {cid: cname for cid, cname in all_joined.items() if cid not in mapped_ids}
        
        if unmapped:
            print(f"\n━━━ TIER 3: ALL OTHER CHANNELS ({len(unmapped)} channels) ━━━")
            with ThreadPoolExecutor(max_workers=10) as executor:
                future_map = {
                    executor.submit(scan_channel, ch_id, ch_name, oldest, False, 20, 0): (ch_id, ch_name)
                    for ch_id, ch_name in unmapped.items()
                }
                tier3_results = []
                for future in as_completed(future_map):
                    try:
                        data = future.result()
                        if data:
                            tier3_results.append(data)
                    except:
                        pass
                for data in sorted(tier3_results, key=lambda d: d["channel_name"]):
                    print_channel(data)
                    all_results.append(data)
                    active_channels += 1
                    total_messages += data["top_level_count"]
                    total_threads += data["thread_reply_count"]
    
    # Summary
    print(f"\n{'=' * 50}")
    scanned = "ALL 353" if args.all else f"{len(scan_plan)} mapped"
    print(f"SCAN COMPLETE ({scanned} channels): {active_channels} active, {total_messages} top-level messages, {total_threads} thread replies")
    print(f"Total messages analyzed: {total_messages + total_threads}")
    print(f"API calls made: {api_calls}")
    print(f"{'=' * 50}")


if __name__ == "__main__":
    main()
