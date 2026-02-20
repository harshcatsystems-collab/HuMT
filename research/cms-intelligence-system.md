# CMS Intelligence System

**Built:** 2026-02-20 | **API:** `https://stageapi.stage.in/nest/cms/content/all`

## Scripts

All in `/home/harsh/.openclaw/workspace/scripts/`:

| Script | Purpose | Usage |
|--------|---------|-------|
| `cms-fetch-all.py` | Pull all CMS data | `python3 cms-fetch-all.py` → saves `data/cms-catalog.json` |
| `cms-pipeline-report.py` | Full dashboard | `python3 cms-pipeline-report.py` |
| `cms-alerts.py` | Actionable alerts | `python3 cms-alerts.py` (exit 1 if alerts) |
| `cms-morning-brief.py` | 3-line summary | `python3 cms-morning-brief.py` |
| `cms-dialect-readiness.py` | Expansion checker | `python3 cms-dialect-readiness.py <dialect>` or `all` |

## Architecture

```
cms-fetch-all.py → data/cms-catalog.json → { pipeline-report, alerts, morning-brief, dialect-readiness }
```

Run the fetcher first (or on cron), then any report script reads from the cached catalog.

## API Notes

- **No auth required** — open endpoint
- **Pagination:** `?page=N&perPage=10` (max 10/page)
- **Total:** 1,256 items across 126 pages (as of 2026-02-20)
- **Instability:** Pages 79, 101-115, 125-126 returned 500 errors. Tail pages unreliable.
- **transcodingStatus:** ALL items return "pending" — field appears unpopulated/default. Transcoding alerts will be noisy until CMS team fixes this.

## Key Fields

| Field | Values Observed |
|-------|----------------|
| dialect | har, bho, guj, raj |
| format | standard, microdrama |
| contentType | movie, show |
| status | active, publish, draft, preview-published, comingSoon |
| transcodingStatus | pending (all items — likely default) |

## Sample Output

### Morning Brief
```
📺 CMS: 9 new titles this week (har:3, guj:3, raj:2, bho:1), 7 already active.
📦 Pipeline: 771 active / 125 drafts across 4 dialects.
⚠️ Alerts: 1077 transcoding stuck; draft pileup: har:64, raj:42, bho:16.
```

### Alerts
```
⚠️  CMS ALERTS — 2026-02-20 07:07 UTC
   4 alert(s) found

🔴 TRANSCODING STUCK: 1077 titles pending/processing > 48h
🟠 DRAFT PILEUP: bho has 16 drafts (> 10 threshold)
🟠 DRAFT PILEUP: har has 64 drafts (> 10 threshold)
🟠 DRAFT PILEUP: raj has 42 drafts (> 10 threshold)
```

### Content Breakdown (from Pipeline Report)
```
By Dialect:     har: 595 | raj: 308 | bho: 124 | guj: 53
By Format:      standard: 960 | microdrama: 120
By Status:      active: 771 | publish: 158 | draft: 125
```

### Dialect Readiness (all dialects)
```
bho: 92/100 ✅ READY  (98 active, velocity 1.8/wk 📈+33%)
guj: 94/100 ✅ READY  (50 active, velocity 6.8/wk 📉-88%)
har: 93/100 ✅ READY  (391 active, velocity 2.0/wk)
raj: 93/100 ✅ READY  (232 active, velocity 2.0/wk 📉-40%)
```

## Observations (2026-02-20)

1. **Haryanvi dominates** with 55% of all content (595/1080)
2. **Gujarati is smallest** at 53 titles but readiness score is high (94%) — quality over quantity
3. **Gujarati velocity crashed** from 20/wk → 3/wk — initial burst over, needs sustained pipeline
4. **Draft pileup in Haryanvi** (64 drafts) — many are 175+ day old "Preview Link" items, likely test/legacy
5. **transcodingStatus is meaningless** — all items show "pending". CMS team should fix this field.
6. **"publish" status** exists alongside "active" (158 items) — unclear distinction, needs CMS team clarification
7. **Standard:Microdrama ratio is 8:1** — microdramas underrepresented given their acquisition role
8. **9 titles added this week** — modest velocity across all dialects

## Cron Setup

```bash
# Fetch CMS data daily at 5:30 AM IST (midnight UTC)
30 0 * * * cd /home/harsh/.openclaw/workspace && python3 scripts/cms-fetch-all.py >> /tmp/cms-fetch.log 2>&1
```

## Benchmarks (Haryanvi at Launch)

Used for dialect readiness scoring:
- Min 50 active titles
- Min 20 standard format
- Min 10 microdramas  
- Min 5 shows
- Min 3 titles/week velocity
