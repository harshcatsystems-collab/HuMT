#!/usr/bin/env python3
"""STAGE Metrics Live Scorecard — pulls all 19 whiteboard metrics."""

import snowflake.connector
from datetime import datetime

CONN = dict(
    account='KOCWHRB-LQ59958', user='BMAD_USER', password='STAGE@2025',
    warehouse='WH_ANALYSIS', role='METABASE_ROLE', database='ANALYTICS_PROD'
)

def q(cur, sql):
    cur.execute(sql)
    cols = [c[0] for c in cur.description]
    return [dict(zip(cols, r)) for r in cur.fetchall()]

def fmt_pct(v): return f"{v:.1f}%" if v is not None else "—"
def fmt_num(v):
    if v is None: return "—"
    v = float(v)
    if abs(v) >= 1e6: return f"{v/1e6:.1f}M"
    if abs(v) >= 1000: return f"{v/1000:.1f}K"
    return f"{v:,.0f}"
def fmt_inr(v):
    if v is None: return "—"
    v = float(v)
    if abs(v) >= 1e7: return f"₹{v/1e7:.2f} Cr"
    if abs(v) >= 1e5: return f"₹{v/1e5:.1f}L"
    return f"₹{v:,.0f}"

def safe(fn, fallback="—"):
    try: return fn()
    except Exception as e: return f"⚠️ {e}"

def main():
    conn = snowflake.connector.connect(**CONN)
    cur = conn.cursor()
    now = datetime.utcnow()
    print(f"📊 STAGE LIVE SCORECARD")
    print(f"⏰ As of: {now.strftime('%Y-%m-%d %H:%M UTC')}")
    print(f"{'='*50}\n")

    # ── CONTENT ──
    print("🎬 CONTENT")
    try:
        rows = q(cur, """
            SELECT SUM(CASE WHEN COMPLETION_BUCKET IN ('80','90','100') THEN USER_COUNT ELSE 0 END) as completed,
                   SUM(USER_COUNT) as total
            FROM ANALYTICS_PROD.DBT_CORE.FCT_COMPLETION_RATIO
        """)
        if rows and rows[0]['TOTAL'] and rows[0]['TOTAL'] > 0:
            cr = rows[0]['COMPLETED'] / rows[0]['TOTAL'] * 100
            print(f"  • Completion Rate (all time): {fmt_pct(cr)}")
        else:
            print(f"  • Completion Rate: — (no data)")
    except Exception as e:
        print(f"  • Completion Rate: ⚠️ {e}")
    print(f"  • Watch-Through Rate: N/A — no pre-aggregated WTR column; requires session-level calc")

    # ── GROWTH ──
    print(f"\n📈 GROWTH")
    try:
        rows = q(cur, """
            SELECT MIN(SPEND_DATE_UTC) as first_date, MAX(SPEND_DATE_UTC) as last_date, SUM(DAILY_SPEND) as total
            FROM ANALYTICS_PROD.DBT_CORE.FCT_MARKETING_AD_SPENDS_DAILY
        """)
        if rows and rows[0]['TOTAL']:
            print(f"  • Historical Ad Spend: {fmt_inr(rows[0]['TOTAL'])} ({rows[0]['FIRST_DATE']} to {rows[0]['LAST_DATE']})")
        else:
            print(f"  • Ad Spend: ₹0")
    except Exception as e:
        print(f"  • Ad Spend: ⚠️ {e}")
    print(f"  • Reach/CPM: N/A — ad spend data stops Jun 2025")
    print(f"  • Traffic/CTR: N/A — ad attribution data stale")

    # ── APP FUNNEL ──
    print(f"\n📱 APP FUNNEL")

    # Trial Rate
    try:
        rows = q(cur, """
            SELECT SUM(TOTAL_PAYWALL_VIEWED) as pw, SUM(TOTAL_TRIAL_ACTIVATED) as tr,
                   AVG(TRIAL_RATE_PCT) as tr_pct
            FROM ANALYTICS_PROD.DBT_MARTS.PLANID_ANALYSIS
            WHERE DATE_ >= DATEADD(day, -14, CURRENT_DATE())
              AND TOTAL_PAYWALL_VIEWED > 0
        """)
        if rows and rows[0]['PW'] and rows[0]['PW'] > 0:
            print(f"  • Trial Rate (14d): {fmt_pct(rows[0]['TR_PCT'])} ({fmt_num(rows[0]['TR'])} / {fmt_num(rows[0]['PW'])} paywall views)")
    except Exception as e:
        print(f"  • Trial Rate: ⚠️ {e}")

    # D0 Trial Conversion
    try:
        rows = q(cur, """
            SELECT TRIAL_ENDED_DAY, CONVERSION_PERCENTAGE, PAUSED_REVOKED_PERCENTAGE,
                   TRIALS_ENDED, CONVERSION_COUNT, ESTIMATED_REVENUE
            FROM ANALYTICS_PROD.DBT_MARTS.D0_TRIAL_CONVERSION
            ORDER BY TRIAL_ENDED_DAY DESC LIMIT 7
        """)
        if rows:
            latest = rows[0]
            avg7 = sum(r['CONVERSION_PERCENTAGE'] or 0 for r in rows) / len(rows)
            print(f"  • D0 Conv Rate ({latest['TRIAL_ENDED_DAY']}): {fmt_pct(latest['CONVERSION_PERCENTAGE'])}")
            print(f"  • D0 Cancel/Pause Rate: {fmt_pct(latest['PAUSED_REVOKED_PERCENTAGE'])}")
            print(f"  • D0 Conv 7d Avg: {fmt_pct(avg7)}")
            print(f"  • Est. Revenue: {fmt_inr(latest['ESTIMATED_REVENUE'])}")
    except Exception as e:
        print(f"  • D0 Conversion: ⚠️ {e}")

    # D1 Retention from PLANID_ANALYSIS
    try:
        rows = q(cur, """
            SELECT AVG(D1_RETENTION_RATE_PCT) as d1
            FROM ANALYTICS_PROD.DBT_MARTS.PLANID_ANALYSIS
            WHERE DATE_ >= DATEADD(day, -14, CURRENT_DATE())
              AND D1_RETENTION_RATE_PCT IS NOT NULL
        """)
        if rows and rows[0]['D1']:
            print(f"  • D1 Retention (14d avg): {fmt_pct(rows[0]['D1'])}")
    except Exception as e:
        print(f"  • D1 Retention: ⚠️ {e}")

    # AHA Moment Rate
    try:
        rows = q(cur, """
            SELECT SUM(AHA_ACHIEVED_USERS) as aha, SUM(TOTAL_TRIAL_USERS) as trials
            FROM ANALYTICS_PROD.DBT_VIZ.VIZ_AHA_MOMENT_ACHIEVED_TREND
            WHERE TRIAL_START_DATE >= DATEADD(day, -30, CURRENT_DATE())
        """)
        if rows and rows[0]['TRIALS'] and rows[0]['TRIALS'] > 0:
            print(f"  • AHA Moment Rate (30d): {fmt_pct(rows[0]['AHA'] / rows[0]['TRIALS'] * 100)} ({fmt_num(rows[0]['AHA'])} / {fmt_num(rows[0]['TRIALS'])})")
    except Exception as e:
        print(f"  • AHA Moment: ⚠️ {e}")

    # Success Rate
    try:
        rows = q(cur, """
            SELECT AVG(SUCCESS_RATE) as sr
            FROM ANALYTICS_PROD.DBT_MARTS.MSR_TRIAL_PLAN_SUCCESS_RATE
            WHERE TRIAL_END_DATE >= DATEADD(day, -30, CURRENT_DATE())
        """)
        if rows and rows[0]['SR']:
            print(f"  • Mandate Success Rate (30d): {fmt_pct(float(rows[0]['SR']) * 100)}")
    except Exception as e:
        print(f"  • Success Rate: ⚠️ {e}")

    # Reactivation
    try:
        rows = q(cur, """
            SELECT COUNT(DISTINCT USER_ID) as cnt
            FROM ANALYTICS_PROD.DBT_CORE.FCT_USER_SUBSCRIPTION_HISTORY
            WHERE SUBSCRIPTION_START_AT_UTC >= DATEADD(day, -30, CURRENT_DATE())
              AND IS_TRIAL = FALSE
              AND SUBSCRIPTION_USER_TYPE = 'trial_returning_user'
        """)
        if rows:
            print(f"  • Repeat Subscribers (30d, non-trial): {fmt_num(rows[0]['CNT'])}")
    except Exception as e:
        print(f"  • Reactivation: ⚠️ {e}")

    # ── WEB FUNNEL ──
    print(f"\n🌐 WEB FUNNEL")
    try:
        rows = q(cur, """
            SELECT SUM(TOTAL_PAYWALL_VIEWED) as pw, SUM(TOTAL_TRIAL_ACTIVATED) as tr,
                   AVG(TRIAL_RATE_PCT) as tr_pct
            FROM ANALYTICS_PROD.DBT_MARTS.PLANID_ANALYSIS
            WHERE DATE_ >= DATEADD(day, -14, CURRENT_DATE())
              AND PLAN_ID ILIKE '%web%'
              AND TOTAL_PAYWALL_VIEWED > 0
        """)
        if rows and rows[0]['PW'] and rows[0]['PW'] > 0:
            print(f"  • Trial Rate (Web, 14d): {fmt_pct(rows[0]['TR_PCT'])}")
        else:
            print(f"  • Trial Rate (Web): — (no web-specific plans in PLANID_ANALYSIS)")
    except Exception as e:
        print(f"  • Trial Rate (Web): ⚠️ {e}")
    print(f"  • Install Rate: N/A — can't measure web→app install")

    # ── RETENTION ──
    print(f"\n🔄 RETENTION")

    # M0 Watchers %
    try:
        rows = q(cur, """
            SELECT DATE_TRUNC('month', SUBSCRIPTION_START_DATE) as mo,
                   COUNT(DISTINCT USER_ID) as total_subs,
                   COUNT(DISTINCT CASE WHEN WATCH_TIME_MIN > 0 THEN USER_ID END) as watched
            FROM ANALYTICS_PROD.DBT_VIZ.VIZ_NEW_SUBSCRIBER_M0_WATCH_ACTIVITY
            WHERE SUBSCRIPTION_START_DATE >= DATEADD(month, -3, CURRENT_DATE())
            GROUP BY 1 ORDER BY 1 DESC LIMIT 3
        """)
        for r in rows:
            if r['TOTAL_SUBS'] > 0:
                pct = r['WATCHED'] / r['TOTAL_SUBS'] * 100
                print(f"  • M0 Watchers ({r['MO']}): {fmt_pct(pct)} ({fmt_num(r['WATCHED'])}/{fmt_num(r['TOTAL_SUBS'])})")
    except Exception as e:
        print(f"  • M0 Watchers: ⚠️ {e}")

    # Habit Formation
    try:
        rows = q(cur, """
            SELECT DATE_TRUNC('month', SUBSCRIPTION_START_DATE) as mo,
                   SUM(TOTAL_SUBSCRIBED_USERS) as subs,
                   SUM(HABIT_ACHIEVED_USERS) as habit
            FROM ANALYTICS_PROD.DBT_VIZ.VIZ_HABIT_MOMENT_ACHIEVED
            WHERE SUBSCRIPTION_START_DATE >= DATEADD(month, -3, CURRENT_DATE())
            GROUP BY 1 ORDER BY 1 DESC LIMIT 3
        """)
        for r in rows:
            if r['SUBS'] and r['SUBS'] > 0:
                pct = r['HABIT'] / r['SUBS'] * 100
                print(f"  • Habit Formation ({r['MO']}): {fmt_pct(pct)} ({fmt_num(r['HABIT'])}/{fmt_num(r['SUBS'])})")
    except Exception as e:
        print(f"  • Habit Formation: ⚠️ {e}")

    # W4 Watchers (Day 28 retention) from cohort watch data
    try:
        rows = q(cur, """
            SELECT COHORT_MONTH,
                   COUNT(DISTINCT USER_ID) as total_users,
                   COUNT(DISTINCT CASE WHEN DAYS_SINCE_START = 28 AND WATCHED_TIME_SEC > 0 THEN USER_ID END) as w4_watchers
            FROM ANALYTICS_PROD.DBT_VIZ.VIZ_NEW_SUBSCRIBER_COHORT_WATCH_RETENTION_ENGAGEMENT
            WHERE COHORT_MONTH >= DATEADD(month, -3, CURRENT_DATE())
            GROUP BY 1 ORDER BY 1 DESC LIMIT 3
        """)
        for r in rows:
            if r['TOTAL_USERS'] > 0:
                pct = r['W4_WATCHERS'] / r['TOTAL_USERS'] * 100
                print(f"  • W4 Watchers ({r['COHORT_MONTH']}): {fmt_pct(pct)} ({fmt_num(r['W4_WATCHERS'])}/{fmt_num(r['TOTAL_USERS'])})")
    except Exception as e:
        print(f"  • W4 Watchers: ⚠️ {e}")

    # Renewal / Mandate Survival
    try:
        rows = q(cur, """
            SELECT TRIAL_START_MONTH, TOTAL_TRIALS_STARTING, ACTIVE_MANDATES_AS_OF_TODAY,
                   ROUND(ACTIVE_MANDATES_AS_OF_TODAY * 100.0 / NULLIF(TOTAL_TRIALS_STARTING, 0), 1) as survival_pct,
                   TOTAL_REVENUE
            FROM ANALYTICS_PROD.DBT_VIZ.VIZ_MONTHLY_TRIAL_COHORT_REVENUE
            ORDER BY TRIAL_START_MONTH DESC LIMIT 6
        """)
        for r in rows:
            print(f"  • Cohort {r['TRIAL_START_MONTH']}: {r['SURVIVAL_PCT']}% survival — {fmt_num(r['ACTIVE_MANDATES_AS_OF_TODAY'])} mandates / {fmt_num(r['TOTAL_TRIALS_STARTING'])} trials — Rev: {fmt_inr(r['TOTAL_REVENUE'])}")
    except Exception as e:
        print(f"  • Cohort Survival: ⚠️ {e}")

    # Active Mandates
    try:
        rows = q(cur, """
            SELECT COUNT(*) as active
            FROM ANALYTICS_PROD.DBT_CORE.DIM_MANDATES_HISTORY
            WHERE CURRENT_STATUS = 'mandate_active' AND IS_CURRENT = TRUE
        """)
        if rows:
            print(f"  • Total Active Mandates: {fmt_num(rows[0]['ACTIVE'])}")
    except Exception as e:
        print(f"  • Active Mandates: ⚠️ {e}")

    # Dormants
    try:
        rows = q(cur, """
            SELECT SEGMENT, COUNT(DISTINCT USER_ID) as cnt
            FROM ANALYTICS_PROD.DBT_MARTS.NEVER_WATCHED_USER_TAGGING
            GROUP BY SEGMENT ORDER BY cnt DESC LIMIT 5
        """)
        total = sum(r['CNT'] for r in rows)
        print(f"  • Dormants (never watched): {fmt_num(total)}")
        for r in rows:
            print(f"    └ {r['SEGMENT']}: {fmt_num(r['CNT'])}")
    except Exception as e:
        print(f"  • Dormants: ⚠️ {e}")

    # Re-acquisition pool
    try:
        rows = q(cur, """
            SELECT SEGMENT, COUNT(DISTINCT USER_ID) as cnt
            FROM ANALYTICS_PROD.DBT_MARTS.PREVIOUSLY_WATCHED_USER_TAGGING
            GROUP BY SEGMENT ORDER BY cnt DESC LIMIT 5
        """)
        total = sum(r['CNT'] for r in rows)
        print(f"  • Re-acquisition Pool (prev watched): {fmt_num(total)}")
        for r in rows:
            print(f"    └ {r['SEGMENT']}: {fmt_num(r['CNT'])}")
    except Exception as e:
        print(f"  • Re-acquisition: ⚠️ {e}")

    # ── CAC ──
    print(f"\n💰 CAC")
    print(f"  • Amazing CAC: N/A — ad spend data stops Jun 2025")

    print(f"\n{'='*50}")
    print(f"✅ Scorecard complete")
    cur.close()
    conn.close()

if __name__ == '__main__':
    main()
