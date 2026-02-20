#!/usr/bin/env python3
"""CMS Data Puller — fetches all pages from STAGE CMS API and saves to data/cms-catalog.json"""

import json, os, sys, time, urllib.request
from datetime import datetime, timezone

API = "https://stageapi.stage.in/nest/cms/content/all"
PER_PAGE = 10
OUT_DIR = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "data")
OUT_FILE = os.path.join(OUT_DIR, "cms-catalog.json")

def fetch_page(page):
    url = f"{API}?page={page}&perPage={PER_PAGE}"
    for attempt in range(3):
        try:
            with urllib.request.urlopen(url, timeout=15) as r:
                return json.loads(r.read())
        except Exception as e:
            if attempt == 2:
                print(f"  ✗ Page {page} failed after 3 attempts: {e}", file=sys.stderr)
                return None
            time.sleep(1 * (attempt + 1))

def main():
    os.makedirs(OUT_DIR, exist_ok=True)
    print(f"[CMS Fetch] Starting at {datetime.now(timezone.utc).isoformat()}")

    # Get total pages from first request
    first = fetch_page(1)
    if not first:
        print("Failed to fetch page 1", file=sys.stderr)
        sys.exit(1)

    total = first["total"]
    total_pages = (total + PER_PAGE - 1) // PER_PAGE
    print(f"[CMS Fetch] Total items: {total}, pages: {total_pages}")

    all_items = list(first["items"])

    for page in range(2, total_pages + 1):
        data = fetch_page(page)
        if data and "items" in data:
            all_items.extend(data["items"])
        if page % 20 == 0:
            print(f"  ... fetched {page}/{total_pages} pages ({len(all_items)} items)")

    catalog = {
        "fetchedAt": datetime.now(timezone.utc).isoformat(),
        "total": total,
        "itemsFetched": len(all_items),
        "items": all_items
    }

    with open(OUT_FILE, "w") as f:
        json.dump(catalog, f, indent=2)

    print(f"[CMS Fetch] Done. {len(all_items)} items saved to {OUT_FILE}")

if __name__ == "__main__":
    main()
