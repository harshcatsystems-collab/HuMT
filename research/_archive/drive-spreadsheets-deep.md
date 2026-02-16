# Google Drive Spreadsheets - Deep Dive
*Extracted: 2026-02-16*

## Summary of Access

| File | Type | Accessible | Method |
|------|------|-----------|--------|
| STAGE_Captable_20.06.2024 | Google Sheet | ✅ | Sheets API |
| Bills for Reimbursement | Google Sheet | ✅ | Sheets API |
| Captable_31.07.2024.xlsx | XLSX | ✅ | Download + openpyxl |
| CapTable_stepwise_28.06.24.xlsx | XLSX | ✅ | Download + openpyxl |
| CapTable_vModel_v2.xlsx | XLSX | ✅ | Download + openpyxl |
| BuyBack_24.08.2024.xlsx | XLSX | ✅ | Download + openpyxl |
| Revenue_Buildup.xlsx | XLSX | ✅ | Download + openpyxl |
| ShareCapital_working.xlsx | XLSX | ✅ | Download + openpyxl |
| ActionPlan_12.07.2024.xlsx | XLSX | ✅ | Download + openpyxl |
| ActionPlan_14.05.2024.xlsx | XLSX | ✅ | Download + openpyxl |
| Most other "file" entries | Google Docs/Slides | ❌ 404 via Sheets API | Not spreadsheets |

**Note:** Most files listed as "file" in Drive that returned 404 on Sheets API are actually Google Docs, Slides, or PDFs — not Google Sheets. Only 2 native Google Sheets exist: Captable_20.06.2024 and Bills for Reimbursement.

---

## 1. CAP TABLE — STAGE_Captable_20.06.2024 (Google Sheet)

**Total shares: 215,185** (pre-Neeraj/Nene, with ESOP)
Header row totals: Equity 130,545 | CCPS 43,204 | Pre-Series A 15,560 | Series A 24,315 | Series A1 1,186 | Series A2 174 | Series A4 201

### Top Shareholders (by total shares)

| # | Shareholder | Equity | CCPS | Pre-A | Series A | A1 | A2 | A4 | Total | % |
|---|-----------|--------|------|-------|----------|-----|-----|-----|-------|-----|
| 1 | Vinay Kumar Singhal | 29,234 | - | - | - | - | - | - | 29,234 | 13.59% |
| 2 | Parveen Singhal | 29,233 | - | - | - | - | - | - | 29,233 | 13.59% |
| 3 | Shashank Vaishnav | 28,905 | - | - | - | - | - | - | 28,905 | 13.43% |
| 4 | **Harsh Mani Tripathi** | **23,060** | - | - | - | - | - | - | **23,060** | **10.72%** |
| 5 | Blume Ventures (Fund IV) | 10 | 1,658 | 10,541 | 10,482 | - | - | - | 22,691 | 10.54% |
| 6 | Torino Enterprises Ltd | - | 8,283 | - | - | - | - | - | 8,283 | 3.85% |
| 7 | ESOP Pool | 8,400 | - | - | - | - | - | - | 8,400 | 3.90% |
| 8 | Ganesh Krishnan | - | 3,751 | - | - | - | - | - | 3,751 | 1.74% |
| 9 | Blu Network (Blume affiliate) | 3,676 | - | - | - | - | - | - | 3,676 | 1.71% |
| 10 | AL Trust (Alteria) | - | - | 1,756 | 1,871 | - | - | - | 3,627 | 1.69% |
| 11 | NB Ventures Limited | - | 415 | - | 2,448 | - | - | - | 2,863 | 1.33% |
| 12 | Dholakia Ventures FZ-LLC | - | - | - | 2,414 | - | - | - | 2,414 | 1.12% |
| 13 | LV Angel Fund | - | 994 | - | 1,221 | - | - | - | 2,215 | 1.03% |
| 14 | Manoj Sadhuram Shivnani | 732 | - | - | 1,398 | - | - | - | 2,130 | 0.99% |
| 15 | Beacon/FirstPort Capital | - | 1,515 | - | 325 | - | - | - | 1,840 | 0.86% |
| 16 | IA Growth Opportunities | 883 | 415 | - | 349 | - | - | - | 1,647 | 0.77% |
| 17 | Sujeet Kumar | - | 1,317 | - | - | - | - | - | 1,317 | 0.61% |
| 18 | Rohit Ajmani / IDEA CLAN | - | - | 1,317 | - | - | - | - | 1,317 | 0.61% |
| 19 | Y.Meera Reddy | - | 878 | - | 384 | - | - | - | 1,262 | 0.59% |
| 20 | Janarthanan B. | - | 1,386 | - | - | - | - | - | 1,386 | 0.64% |

**Full cap table has 185 shareholders.**

Additional notable shareholders:
- VSS Investco: 963 shares (0.45%) — Equity 0, CCPS 264, Series A1 699
- IPV Advisors: 956 shares (0.44%)
- Vel Sports/Neeraj Chopra: 874 shares (0.41%)
- Brew Opportunities Fund: 882 shares (0.41%)
- ZNL Growth Fund: 755 shares (0.35%)
- TSM Ventures Pte Ltd: 559 shares (0.26%)
- Shriram Madhav Nene (Dr. Nene): 201 shares (0.09%) — Series A4
- VentureSailthrough LLP: 174 shares (0.08%) — Series A1
- Thapar Vision LLP: 174 shares (0.08%) — Series A1
- Alteria Capital Fund II: 174 shares (0.08%) — Series A2

### Founder Group Summary
| Founder | Shares | % |
|---------|--------|---|
| Vinay Kumar Singhal | 29,234 | 13.59% |
| Parveen Singhal | 29,233 | 13.59% |
| Shashank Vaishnav | 28,905 | 13.43% |
| Harsh Mani Tripathi | 23,060 | 10.72% |
| **Total Founders** | **110,432** | **51.32%** |

---

## 2. CAP TABLE — Captable_31.07.2024 (XLSX)

**Total shares: 216,471** (includes HMT's additional 278 shares via rights issue vs June version)
Header: Equity 131,831 | CCPS 43,204 | Pre-A 15,560 | Series A 24,315 | A1 1,186 | A2 174 | A4 201

Key differences from 20.06.2024:
- Vinay: 29,570 (+336), Parveen: 29,569 (+336), Shashank: 29,241 (+336)
- HMT: 23,338 (+278) — **This is the 23,338 figure referenced in the task**
- Total equity shares increased from 130,545 → 131,831 (+1,286)

---

## 3. CAP TABLE vModel_v2 (Series B Modeling)

### Scenario: "Goodwater" (Two-tranche Series B)

**Series B-1:**
- Goodwater check: $6M, Other investors: $3M
- Post-valuation: $79M
- Round PPS: ₹308.77
- Additional ESOP pool: 4%

**Series B-2:**
- Goodwater check: $6M (total $12M across both)
- Post-valuation: $100M
- Round PPS: ₹367.40

Post-Series B dilution for founders:
| Founder | Pre-B % | Post-B1 % | Post-B2 % |
|---------|---------|-----------|-----------|
| Vinay | 13.66% | 11.56% | 10.86% |
| Parveen | 13.66% | 11.56% | 10.86% |
| Shashank | 13.51% | 11.43% | 10.74% |
| HMT | 10.78% | 9.12% | 8.57% |
| **All 4 founders** | **~51.6%** | **~43.7%** | **~41.0%** |

### Scenario: "Other Lead"
- New Lead: $13M, Other: $2M
- Post-valuation: $85M
- Round PPS: ₹307.66
- HMT post-round: 8.45%

---

## 4. BUYBACK CALCULATION (24.08.2024)

**Only equity shareholders eligible for buyback.**

Total equity shares: 130,261
Maximum buyback allowed: 12,393 shares (based on 10% of paid-up + free reserves)

**Proposed buyback:**
| Shareholder | Equity | Shares for Buyback | % Buyback |
|------------|--------|-------------------|-----------|
| Vinay Kumar Singhal | 31,846 | 2,276 | 7.15% |
| Parveen Singhal | 31,846 | 2,277 | 7.15% |
| Shashank Vaishnav | 31,518 | 2,277 | 7.22% |
| **HMT** | **23,338** | **0** | **0%** |
| Total proposed | — | 6,830 | 21.52% |

**Financial basis:**
- Paid-up equity capital (31.03.2024): ₹1,00,688
- Securities Premium Reserve: ₹67,57,29,410
- Free Reserves: -₹65,53,32,000
- **Net for buyback calculation: ₹2,04,98,098**
- Max shares at 10%: 12,393
- Share nominal value: ₹165.40

**Note:** HMT opted for 0 buyback — all buyback from VSP (original 3 founders).

---

## 5. REVENUE BUILDUP MODEL

### Revenue Projections by Language (INR Crores)

| Language | FY24 | FY25 | FY26 | FY27 | FY28 | FY29 |
|----------|------|------|------|------|------|------|
| Haryanvi | — | 56.16 | 79.04 | 106.83 | 137.92 | 168.91 |
| Rajasthani | — | 17.92 | 29.38 | 45.71 | 70.00 | 105.50 |
| Marathi | — | — | 8.00 | 13.20 | 27.96 | 52.53 |
| Gujarati | — | — | — | 8.00 | 13.20 | 27.96 |
| Bhojpuri | — | — | — | — | 8.00 | 13.20 |
| **Total** | — | **74.08** | **116.42** | **173.73** | **257.08** | **368.10** |

**Growth rate:** ~49% CAGR

### Key Assumptions
- Subscription price: ₹800/year across all languages
- Install-to-subscription rate: 20%
- YoY addition growth: 20-50% depending on language maturity
- Churn: 65-70% of opening active subscribers annually
- Annual user retention: ~28% (M12 retention at 90% monthly = 28.2% annual)
- LTV: ₹1,106 | CAC: ₹300 | LTV/CAC: 3.7x

### TAM by Dialect (Steady State Revenue Potential)
| Dialect | Revenue Potential (INR Cr) |
|---------|--------------------------|
| Haryanvi | 120 |
| Rajasthani | 220 |
| Marathi | 250 |
| Gujarati | 200 |
| Bhojpuri | 350 |
| **Total** | **1,140** |

### Investor Commentary (from spreadsheet)
- "Difficult to reach revenue scale beyond ~INR 350-400 Cr during 3-5 year investment horizon"
- Each dialect caps at ₹120-350 Cr due to household penetration limits
- "Would be helpful if you could help us bridge the gap to ~INR 1,000 Cr revenue pool per dialect"
- Netflix comparison: Monthly churn 3.5% → 42% annual. Stage at 72% annual churn = "treadmill business"

### Subscriber Projections
| Metric | FY25 | FY26 | FY27 | FY28 | FY29 |
|--------|------|------|------|------|------|
| Active subscribers | 1.13M | 1.68M | 2.56M | 3.76M | 5.44M |
| Lifetime subscribers | 1.97M | 3.33M | 5.35M | 8.26M | 12.40M |

---

## 6. SHARE CAPITAL WORKING (18.04.2024)

| Category | Authorized | Issued | Subscribed | Paid-up |
|----------|-----------|--------|-----------|---------|
| Equity (₹1 face) | 2,00,000 shares | 1,00,688 | 1,00,688 | 1,00,688 |
| Pref A (₹1 face) | 9,00,000 shares | 65,792 | 65,792 | 65,792 |
| Pref B (₹10 face) | 1,00,000 shares | 25,675 | 25,675 | 25,518.4* |
| **Total (₹)** | **₹21,00,000** | **₹4,23,230** | **₹4,23,230** | **₹4,21,664** |

*Pref B slight difference: ₹2,56,750 subscribed vs ₹2,55,184 paid-up

---

## 7. ACTION PLAN (Latest: 12.07.2024)

### 4-Step Corporate Restructuring Plan

**Step 1: Selective Conversion of CCPS → Equity**
- Convert 1,667 seed CCPS (held for HMT) to equity at 1:1
- Legal basis: SSHA Clause 8 allows holder discretion
- No EGM needed per original SSHA

**Step 2: Private Placement (NC/SNMD)**
- KYC capture, valuation, investor consent
- Board meeting → EGM → MGT-14 filing → Call for Money → PAS-3
- Timeline: May-June 2024

**Step 3: Rights Issue (HMT/NC)**
- Ratio 12.83:1 (or 13:1 in some versions)
- All existing shareholders offered; only HMT accepts
- HMT gets 21,671 shares via rights issue → total 23,338
- Neeraj Chopra: 874 shares (₹1.25 Cr at ₹14,296/share)
  - 68 via private placement, 806 via rights issue
- Dr. Nene: 201 shares (₹15L commitment, ₹14,296/share)
  - Total fund infusion ₹28.73L, ₹13.73L refunded as advisory income
- **Authorized capital increase needed** — Completed by 25 June 2024

**Step 4: Buyback from VSP (Original Founders)**
- 6,830 shares bought back (per V2 calculation)
- Vinay: 2,276, Parveen: 2,277, Shashank: 2,277
- Escrow account, RTA coordination, letter of offer
- Tax on buyback paid by Stage within 14 days
- 6-month restriction on same-kind share issuance after buyback
- Timeline: July-August 2024

### Cap Table Evolution (from stepwise workings)

| Stage | VSP Founders | HMT | ESOP | Others | Total |
|-------|-------------|-----|------|--------|-------|
| Before | 95,210 (47.5%) | 0 | 8,400 (4.2%) | 96,771 (48.3%) | 200,381 |
| After Step 1 (conversion) | 95,210 | 1,667 | 8,400 | 94,704* | 200,381 |
| After Step 2 (rights issue) | 95,210 | 23,338 (10.5%) | 8,400 | 94,704* | 222,052 |
| After Step 3 (buyback) | 88,380 (41.1%) | 23,338 (10.8%) | 8,400 (3.9%) | 94,704* | 215,222 |

*Others includes all investors (CCPS + preference)

---

## 8. BILLS FOR REIMBURSEMENT (tarang@stage.in)

Transport/airport transfers for Tarang, Feb-Mar 2025:
- **Total: ₹8,111**
- Period: 24 Feb - 7 Mar 2025
- Mostly daily transport (₹200-500 range) + 3 airport transfers (₹969-1,200)

---

## 9. KEY FINANCIAL METRICS SUMMARY

| Metric | Value |
|--------|-------|
| Valuation (last round) | ~₹150 Cr ($18M) at Series A |
| Series B target valuation | $79-100M (Goodwater model) |
| Per share value (2024) | ₹14,296 |
| FY25 Revenue projection | ₹74.08 Cr |
| FY29 Revenue projection | ₹368.10 Cr |
| Revenue CAGR | ~49% |
| Total shareholders | 185 |
| Total shares outstanding | 215,185-216,471 (depending on version) |
| Founder group ownership | ~51% |
| HMT ownership | 10.5-10.8% (23,338 shares) |
| ESOP pool | 8,400 shares (3.9%) |
| Annual subscriber churn | ~72% |
| LTV/CAC ratio | 3.7x |
| Subscription price | ₹800/year |
