#!/usr/bin/env python3
"""
Resolve Slack user IDs to names.
Reads from stdin (pipe slack-scan-all.sh output) or use as library.
Caches user lookups to avoid repeated API calls.

Usage: ./slack-scan-all.sh | python3 slack-resolve-users.py
"""

import json, sys, os, re

CONFIG_PATH = os.path.expanduser("~/.openclaw/openclaw.json")
CACHE_PATH = os.path.expanduser("~/.openclaw/workspace/memory/slack-user-cache.json")

def load_cache():
    try:
        with open(CACHE_PATH) as f:
            return json.load(f)
    except:
        return {}

def save_cache(cache):
    with open(CACHE_PATH, 'w') as f:
        json.dump(cache, f, indent=2)

def get_bot_token():
    with open(CONFIG_PATH) as f:
        return json.load(f)['channels']['slack']['botToken']

def resolve_user(user_id, token, cache):
    if user_id in cache:
        return cache[user_id]
    
    import urllib.request
    req = urllib.request.Request(
        f"https://slack.com/api/users.info?user={user_id}",
        headers={"Authorization": f"Bearer {token}"}
    )
    try:
        resp = urllib.request.urlopen(req, timeout=5)
        data = json.loads(resp.read())
        if data.get('ok'):
            name = data['user'].get('real_name', data['user'].get('name', user_id))
            cache[user_id] = name
            return name
    except:
        pass
    return user_id

def main():
    cache = load_cache()
    token = get_bot_token()
    
    # Read all input
    text = sys.stdin.read()
    
    # Find all user IDs (U followed by alphanumeric)
    user_ids = set(re.findall(r'U[A-Z0-9]{8,}', text))
    
    # Resolve all
    for uid in user_ids:
        name = resolve_user(uid, token, cache)
        text = text.replace(uid, f"{name}")
    
    save_cache(cache)
    print(text)

if __name__ == "__main__":
    main()
