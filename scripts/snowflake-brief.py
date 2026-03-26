#!/usr/bin/env python3
"""
Snowflake metrics for morning brief — via Metabase API.
Outputs a formatted text block for injection into the morning brief.
Also writes cache to /tmp/snowflake-brief-cache.json.
"""

import json, sys, os, datetime
import urllib.request

API_KEY = "mb_TFdivJ3ePUe5v9xeA77Xphanlq+n0BiKVGXhmT3H1o4="
BASE = "https://stage.metabaseapp.com/api"
DB_ID = 299

def query(sql):
    """Run SQL against Snowflake via Metabase API."""
    data = json.dumps({"database": DB_ID, "type": "native", "native": {"query": sql}}).encode()
    req = urllib.request.Request(f"{BASE}/dataset", data=data, headers={
        "x-api-key": API_KEY,
        "Content-Type": "application/json"
    })
    try:
        with urllib.request.urlopen(req, timeout=60) as resp:
            result = json.loads(resp.read())
            cols = [c["name"] for c in result["data"]["cols"]]
            rows = result["data"]["rows"]
            return [dict(zip(cols, row)) for row in rows]
    except Exception as e:
        return {"error": str(e)}

def fmt_num(n):
    """Format number with commas."""
    if n is None: return "N/A"
    if isinstance(n, str): return n
    if isinstance(n, float): n = int(n)
    try:
        return f"{n:,}"
    except (TypeError, ValueError):
        return str(n)

def main():
    results = {}
    errors = []

    # Q1: Yesterday's trials + new paid + renewals
    q1 = query("""
        SELECT PLAN_CATEGORY, COUNT(*) AS COUNT
        FROM ANALYTICS_PROD.DBT_CORE.FCT_USER_SUBSCRIPTION_HISTORY
        WHERE CREATED_AT_IST::DATE = CURRENT_DATE - 1
          AND PLAN_CATEGORY IN ('Trial', 'New Subscription', 'Renewal')
        GROUP BY 1
    """)
    if isinstance(q1, dict) and "error" in q1:
        errors.append(f"Q1 (subs): {q1['error']}")
    else:
        results["subs"] = {r.get("PLAN_CATEGORY", r.get("plan_category", "?")): r.get("COUNT", r.get("count", 0)) for r in q1}

    # Q1b: Previous day for comparison
    q1b = query("""
        SELECT PLAN_CATEGORY, COUNT(*) AS COUNT
        FROM ANALYTICS_PROD.DBT_CORE.FCT_USER_SUBSCRIPTION_HISTORY
        WHERE CREATED_AT_IST::DATE = CURRENT_DATE - 2
          AND PLAN_CATEGORY IN ('Trial', 'New Subscription', 'Renewal')
        GROUP BY 1
    """)
    if isinstance(q1b, dict) and "error" in q1b:
        errors.append(f"Q1b (prev subs): {q1b['error']}")
    else:
        results["prev_subs"] = {r.get("PLAN_CATEGORY", r.get("plan_category", "?")): r.get("COUNT", r.get("count", 0)) for r in q1b}

    # Q2: D0 engagement
    # Q2a: D0 engagement (active on day 0 of trial — aha removed, it's a 7-day metric)
    q2a = query("""
        SELECT 
          COUNT(DISTINCT USER_ID) AS TOTAL,
          COUNT(DISTINCT CASE WHEN ACTIVE_FLAG = 1 THEN USER_ID END) AS ACTIVE
        FROM ANALYTICS_PROD.DBT_VIZ.D0_USER_BUCKETS
        WHERE TRIAL_START_DATE = CURRENT_DATE - 1
          AND DATE_IN_TRIAL = TRIAL_START_DATE
    """)
    if isinstance(q2a, dict) and "error" in q2a:
        errors.append(f"Q2a (D0): {q2a['error']}")
    else:
        results["d0"] = q2a[0] if q2a else {}

    # Q2b: Aha rate for trial cohort that ended yesterday (aha = active ≥4 days across full trial)
    q2b = query("""
        SELECT
          COUNT(DISTINCT USER_ID) AS TRIAL_COMPLETERS,
          COUNT(DISTINCT CASE WHEN AHA_FLAG = 1 THEN USER_ID END) AS AHA_ACHIEVED
        FROM ANALYTICS_PROD.DBT_VIZ.D0_USER_BUCKETS
        WHERE TRIAL_START_DATE = CURRENT_DATE - 8
          AND DATE_IN_TRIAL = TRIAL_START_DATE
    """)
    if isinstance(q2b, dict) and "error" in q2b:
        errors.append(f"Q2b (Aha): {q2b['error']}")
    else:
        results["aha_cohort"] = q2b[0] if q2b else {}

    # Q3: Active mandates
    q3 = query("""
        SELECT COUNT(DISTINCT USER_ID) AS ACTIVE_MANDATES
        FROM ANALYTICS_PROD.DBT_CORE.DIM_MANDATES_SCD
        WHERE CURRENT_STATUS = 'mandate_active'
    """)
    if isinstance(q3, dict) and "error" in q3:
        errors.append(f"Q3 (mandates): {q3['error']}")
    else:
        results["mandates"] = q3[0] if q3 else {}

    # Q4: Yesterday's revocations
    q4 = query("""
        SELECT STATUS_VALUE, COUNT(*) AS COUNT
        FROM ANALYTICS_PROD.DBT_CORE.DIM_MANDATES_HISTORY
        WHERE STATUS_CHANGED_AT_IST::DATE = CURRENT_DATE - 1
          AND STATUS_VALUE IN ('revoked_psp', 'paused_in_app', 'paused_psp')
        GROUP BY 1
    """)
    if isinstance(q4, dict) and "error" in q4:
        errors.append(f"Q4 (churn): {q4['error']}")
    else:
        results["churn"] = {r.get("STATUS_VALUE", r.get("status_value", "?")): r.get("COUNT", r.get("count", 0)) for r in q4}

    # Q5: Top trial-driving shows (7d)
    q5 = query("""
        SELECT FINAL_SHOW_SLUG, DIALECT, SUM(TOTAL_TRIALS_ACQUIRED) AS TRIALS
        FROM ANALYTICS_PROD.DBT_MARTS.AGG_TRIAL_COUNTS_BY_CONTENT
        WHERE GRANULARITY = 'daily' AND PERIOD_START_DATE >= CURRENT_DATE - 7
        GROUP BY 1, 2
        ORDER BY 3 DESC
        LIMIT 5
    """)
    if isinstance(q5, dict) and "error" in q5:
        errors.append(f"Q5 (top shows): {q5['error']}")
    else:
        results["top_shows"] = q5

    # Cache results
    cache = {"timestamp": datetime.datetime.utcnow().isoformat(), "results": results, "errors": errors}
    with open("/tmp/snowflake-brief-cache.json", "w") as f:
        json.dump(cache, f, indent=2, default=str)

    # Format output
    lines = []
    lines.append("📊 STAGE Metrics (Yesterday)")
    lines.append("━━━━━━━━━━━━━━━━━━━━")

    # Subs
    subs = results.get("subs", {})
    prev = results.get("prev_subs", {})
    trials = subs.get("Trial", subs.get("trial", 0))
    prev_trials = prev.get("Trial", prev.get("trial", 0))
    new_paid = subs.get("New Subscription", subs.get("new subscription", 0))
    prev_paid = prev.get("New Subscription", prev.get("new subscription", 0))
    renewals = subs.get("Renewal", subs.get("renewal", 0))

    trial_chg = f" ({'+' if trials > prev_trials else ''}{((trials-prev_trials)/prev_trials*100):.0f}%)" if prev_trials else ""
    paid_chg = f" ({'+' if new_paid > prev_paid else ''}{((new_paid-prev_paid)/prev_paid*100):.0f}%)" if prev_paid else ""

    lines.append(f"Trials: {fmt_num(trials)}{trial_chg}")
    lines.append(f"New Paid: {fmt_num(new_paid)}{paid_chg}")
    lines.append(f"Renewals: {fmt_num(renewals)}")

    # Mandates
    mandates = results.get("mandates", {})
    active_m = mandates.get("ACTIVE_MANDATES", mandates.get("active_mandates", "?"))
    if isinstance(active_m, (int, float)) and active_m > 1000000:
        lines.append(f"Active Mandates: {active_m/1000000:.2f}M")
    else:
        lines.append(f"Active Mandates: {fmt_num(active_m)}")

    # D0
    d0 = results.get("d0", {})
    total = d0.get("TOTAL", d0.get("total", 0))
    active = d0.get("ACTIVE", d0.get("active", 0))
    if total and total > 0:
        active_pct = active / total * 100
        lines.append(f"\nD0 Engagement:")
        lines.append(f"• Active: {active_pct:.1f}% ({fmt_num(active)}/{fmt_num(total)})")
        if active_pct < 55:
            lines.append(f"  🔴 D0 active critically low (<55%)")

    # Aha (trial cohort that completed 7 days ago)
    aha_data = results.get("aha_cohort", {})
    aha_total = aha_data.get("TRIAL_COMPLETERS", aha_data.get("trial_completers", 0))
    aha_achieved = aha_data.get("AHA_ACHIEVED", aha_data.get("aha_achieved", 0))
    if aha_total and aha_total > 0:
        aha_pct = aha_achieved / aha_total * 100
        lines.append(f"• Aha (7d cohort): {aha_pct:.1f}% ({fmt_num(aha_achieved)}/{fmt_num(aha_total)})")
        if aha_pct < 25:
            lines.append(f"  🟡 Aha rate below threshold (<25%)")

    # Churn
    churn = results.get("churn", {})
    if churn:
        revoked = churn.get("revoked_psp", 0)
        paused_app = churn.get("paused_in_app", 0)
        paused_psp = churn.get("paused_psp", 0)
        total_churn = revoked + paused_app + paused_psp
        lines.append(f"\nChurn: {fmt_num(total_churn)} (revoked: {fmt_num(revoked)}, paused: {fmt_num(paused_app + paused_psp)})")
        if total_churn > 20000:
            lines.append(f"  🟡 Elevated churn (>20K)")

    # Anomaly: trial volume crash
    if prev_trials and trials and prev_trials > 0:
        drop = (prev_trials - trials) / prev_trials * 100
        if drop > 30:
            lines.append(f"\n🔴 Trial volume dropped {drop:.0f}% day-over-day — check ads")
    if new_paid and new_paid < 5000:
        lines.append(f"🟡 New paid subs below 5K threshold")

    # Top shows
    top = results.get("top_shows", [])
    if top:
        lines.append(f"\nTop Shows (7d trials):")
        for i, s in enumerate(top[:5]):
            slug = s.get("FINAL_SHOW_SLUG", s.get("final_show_slug", "?"))
            dialect = s.get("DIALECT", s.get("dialect", "?"))
            t = s.get("TRIALS", s.get("trials", 0))
            lines.append(f"  {i+1}. {slug} ({dialect}) — {fmt_num(t)}")

    # Errors
    if errors:
        lines.append(f"\n⚠️ Data issues: {'; '.join(errors)}")

    output = "\n".join(lines)
    print(output)
    return output

if __name__ == "__main__":
    main()
