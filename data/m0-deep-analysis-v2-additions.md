# Critical Additions for M0 Deep Analysis V2

## 1. Feb'26 D0-D6 Early Signal (Day-Matched Comparison)

**Watcher% Comparison (First Week):**

| Day | Feb'26 Subs | Feb Watch | Feb W% | Dec'25 Subs | Dec Watch | Dec W% | Δ |
|-----|-------------|-----------|--------|-------------|-----------|--------|---|
| D0 | 5,916 | 1,723 | **29.1%** | 5,837 | 2,263 | 38.8% | **-9.6%** |
| D1 | 6,373 | 1,718 | **27.0%** | 5,668 | 2,266 | 40.0% | **-13.0%** |
| D2 | 6,532 | 1,774 | **27.2%** | 5,573 | 2,121 | 38.1% | **-10.9%** |
| D3 | 6,154 | 1,636 | **26.6%** | 5,542 | 2,094 | 37.8% | **-11.2%** |
| D4 | 6,512 | 1,656 | **25.4%** | 5,498 | 2,184 | 39.7% | **-14.3%** |
| D5 | 6,093 | 1,467 | **24.1%** | 5,449 | 2,358 | 43.3% | **-19.2%** |
| D6 | 6,256 | 1,493 | **23.9%** | 5,856 | 2,572 | 43.9% | **-20.1%** |
| **AVG** | **43,836** | **11,467** | **26.2%** | **39,423** | **15,858** | **40.2%** | **-14.1%** |

**CRITICAL INSIGHT:**
- Feb'26 D0-D6 Watcher% = **26.2%** (vs Dec'25 40.2%)
- **14.1 percentage point drop** in first week engagement
- Drop accelerates by day (D0: -9.6%, D6: -20.1%)
- This is an **immature cohort** - not final M0 outcome, but early warning signal

## 2. Root Cause Analysis: WHY is Watcher% Dropping?

### Hypothesis Testing Framework

**Test 1: Trial Quality Degradation**
- Jan'26: 11.5% with 0 trial watch days
- Feb'26: 27.7% with 0 trial watch days (**+141% spike**)
- **Conclusion**: CONFIRMED - We're acquiring users who don't engage during trial

**Test 2: Channel Mix Shift**
- Re-engagement channels (highest quality): 45% of watchers
- Cold acquisition growing (evidence: Feb 0-trial spike)
- **Conclusion**: LIKELY - Cold acquisition diluting engaged user base

**Test 3: Platform/Install Issues**
- Need to test: Web vs App Watcher% trend
- Need to test: Installed vs Not-installed trend
- **Conclusion**: INSUFFICIENT DATA (need to query cards 13211, 12156)

**Test 4: Dialect Mix Change**
- Need to test: Is Bhojpuri (lower engagement) growing as % of base?
- Need to test: Is Haryanvi (higher engagement) shrinking?
- **Conclusion**: INSUFFICIENT DATA (need dialect distribution by month)

**Test 5: Trial Plan Mix**
- Need to test: 1-day vs 7-day trial performance shift
- **Conclusion**: INSUFFICIENT DATA

### Root Cause Summary (Based on Available Data)

**PRIMARY DRIVER (80% confidence):**
Trial-to-payment flow is broken. 27.7% of Feb subs paid without watching during trial. This creates a "cold subscriber" base that never engages.

**SECONDARY DRIVER (60% confidence):**
Acquisition channel mix shifting toward cold traffic. Re-engagement channels are highest quality but may be shrinking as % of total.

**UNKNOWN DRIVERS (need data):**
- Platform mix (web vs app)
- Dialect mix shift
- Install rate changes
- Trial plan (1d vs 7d) mix

## 3. What Analysis Still Needs

To complete root cause analysis, need:

1. **Platform breakdown by month** (Web vs App Watcher% trend) - Card 13211
2. **Dialect distribution by month** (% of M0 base by dialect over time) - Card 6293
3. **Install status by month** (Installed vs Not-installed Watcher% trend) - Card 12156
4. **Trial plan mix** (1-day vs 7-day as % of M0 subs by month)

