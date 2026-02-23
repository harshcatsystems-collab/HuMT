# Dormant Dashboard — Data Digest
**Source:** Metabase Dashboard #3767 | **Tabs:** Daily, Tab 2 (dormancy age), Aggregated
**23 cards | Ingested: Feb 23, 2026**
**Note:** Tab 2 (dormancy age by HVU/MVU/LVU) and Aggregated tab cards all SIGKILL/timeout — too heavy. Analysis based on Daily tab (6 core cards, 396 rows each).

---

## Dashboard Structure

Two dormant populations tracked:
1. **Never Watched** — subscribers who never watched anything (>M0, New). These are acquisition ghosts.
2. **Previously Watched** — subscribers who watched before but went dormant (All, Resurrect4). These are lapsed users with proven intent.

Each split by value segment: **HVU** (High Value), **MVU** (Medium Value), **LVU** (Low Value)

---

## 1. Never Watched Dormants (Cards 11827-11829)

### Current Pool Size (Feb 22, 2026)
| Segment | Subscribers | Watch Conversion |
|---------|------------|-----------------|
| HVU | ~191,500 | 0.23% |
| MVU | ~109,500 | 0.23% |
| LVU | ~374,700 | 0.26% |
| **Total** | **~675,700** | **~0.24%** |

### Pool Growth (Oct '25 → Feb '26)
| Segment | Oct '25 | Feb '26 | Growth |
|---------|---------|---------|--------|
| HVU | ~148K | ~192K | +30% |
| MVU | ~54K | ~109K | +102% |
| LVU | ~470K | ~375K | -20% |

**Key:** HVU and MVU never-watched pools are GROWING. LVU shrinking (likely churn/expiry). The acquisition-without-activation problem is getting worse for high-value segments.

### Watch Conversion Trend (Never Watched)
| Date | HVU Conv | MVU Conv | LVU Conv |
|------|----------|----------|----------|
| Oct 16 | 0.14% | 0.11% | 0.16% |
| Nov 15 | 0.15% | 0.14% | 0.17% |
| Dec 15 | 0.20% | 0.16% | 0.19% |
| Jan 15 | 0.24% | 0.19% | 0.22% |
| Feb 15 | 0.19% | 0.14% | 0.18% |
| Feb 17 | 0.28% | 0.23% | 0.30% |
| Feb 22 | 0.23% | 0.23% | 0.26% |

**Conversion improving slowly** from 0.1% to 0.2-0.3% range. Still abysmally low — only 1 in 400 never-watched dormants watches on any given day.

### Watchers (Never Watched, absolute)
| Date | HVU | MVU | LVU | Total |
|------|-----|-----|-----|-------|
| Oct avg | ~250 | ~60 | ~1,100 | ~1,410 |
| Nov avg | ~350 | ~80 | ~1,100 | ~1,530 |
| Dec avg | ~600 | ~120 | ~900 | ~1,620 |
| Jan avg | ~550 | ~200 | ~900 | ~1,650 |
| Feb avg | ~450 | ~240 | ~950 | ~1,640 |

~1,600 never-watched dormants start watching per day. Against a pool of 675K, this is a trickle.

---

## 2. Previously Watched Dormants (Cards 11830-11832)

### Current Pool Size (Feb 22, 2026)
| Segment | Subscribers | Watch Conversion |
|---------|------------|-----------------|
| HVU | ~107,400 | 0.80% |
| MVU | ~107,300 | 0.40% |
| LVU | ~226,100 | 0.10% |
| **Total** | **~440,800** | **~0.39%** |

### Pool Trend (Oct '25 → Feb '26)
| Segment | Oct '25 | Feb '26 | Trend |
|---------|---------|---------|-------|
| HVU | ~113K | ~107K | -5% (shrinking — good, means some are reactivating or churning out) |
| MVU | ~108K | ~107K | Flat |
| LVU | ~266K | ~226K | -15% (churn) |

### Watch Conversion Trend (Previously Watched)
| Date | HVU Conv | MVU Conv | LVU Conv |
|------|----------|----------|----------|
| Oct 16 | 0.51% | 0.17% | 0.13% |
| Nov 15 | 0.76% | 0.28% | 0.13% |
| Dec 15 | 0.73% | 0.30% | 0.11% |
| Jan 15 | 0.72% | 0.31% | 0.09% |
| Feb 16 | 0.56% | 0.35% | 0.09% |
| Feb 17 | **1.03%** | **0.48%** | **0.12%** |
| Feb 18 | 0.90% | 0.39% | 0.10% |
| Feb 22 | 0.80% | 0.40% | 0.10% |

**Feb 17 spike across all segments** — something happened that day. Content release? Push notification? Campaign? Worth investigating.

**HVU previously-watched converts at 3-4x the rate of never-watched** (0.8% vs 0.23%). These users have proven willingness — they're the low-hanging fruit.

### Watchers (Previously Watched, absolute)
| Date | HVU | MVU | LVU | Total |
|------|-----|-----|-----|-------|
| Oct avg | ~700 | ~200 | ~350 | ~1,250 |
| Nov avg | ~900 | ~400 | ~350 | ~1,650 |
| Dec avg | ~850 | ~350 | ~300 | ~1,500 |
| Jan avg | ~750 | ~350 | ~200 | ~1,300 |
| Feb 17 | **1,260** | **556** | **284** | **2,100** |
| Feb 22 | 864 | 425 | 233 | 1,522 |

~1,300-1,500 previously-watched dormants resurrect per day. Again tiny vs 440K pool.

---

## Combined Dormant Picture

| Category | Pool | Daily Watchers | Conversion |
|----------|------|---------------|------------|
| Never Watched | 675,700 | ~1,640 | 0.24% |
| Previously Watched | 440,800 | ~1,500 | 0.39% |
| **Total Dormant** | **1,116,500** | **~3,140** | **0.28%** |

**1.1M+ dormant subscribers. 3,140 reactivate per day. That's 0.28%.**

### The Value Hierarchy
| Priority | Segment | Pool | Conversion | Why |
|----------|---------|------|-----------|-----|
| 1 | Previously Watched HVU | 107K | 0.80% | Proven watchers, high value, 4x conversion |
| 2 | Previously Watched MVU | 107K | 0.40% | Proven watchers, moderate value |
| 3 | Never Watched HVU | 192K | 0.23% | High theoretical value but never engaged |
| 4 | Never Watched MVU | 109K | 0.23% | Same |
| 5 | Previously Watched LVU | 226K | 0.10% | Proven but low value, low conversion |
| 6 | Never Watched LVU | 375K | 0.26% | Largest pool, lowest quality — likely carrier billing ghosts |

---

## Key Signals

1. **Feb 17 resurrection spike** — HVU conv jumped to 1.03% (from 0.56% day before), MVU to 0.48%. 2x normal. Something worked. FIND OUT WHAT.
2. **Never-watched HVU pool growing 30%** — acquisition is bringing in high-value subs who never watch. The M0 zero-activity problem confirmed from a different angle.
3. **Previously-watched HVU pool shrinking** — good sign, some reactivation happening organically.
4. **LVU is a graveyard** — 375K never-watched LVUs with 0.26% conversion. Likely carrier billing ghosts. Write them off for targeting purposes.
5. **Total addressable resurrection: ~214K** (HVU+MVU previously watched) with 0.4-0.8% daily conversion. If you could 5x conversion to 2-4%, that's 4,000-8,000 reactivations/day from this segment alone.

---

## Unavailable Data (cards timed out)
- Dormancy age breakdown (how long they've been dormant) — cards 13541-13543
- Playback channel breakdown (mobile vs TV vs web) — cards 13673-13678
- All Aggregated tab cards — 13640-13645

*Dashboard: https://stage.metabaseapp.com/dashboard/3767*
*Generated: Feb 23, 2026*
