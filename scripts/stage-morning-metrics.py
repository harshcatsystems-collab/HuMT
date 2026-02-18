#!/usr/bin/env python3
"""STAGE Morning Metrics Brief — daily summary for Telegram with anomaly detection."""

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

def fmt(v):
    if v is None: return "—"
    if isinstance(v, float): return f"{v:,.1f}"
    if isinstance(v, (int,)) and abs(v) >= 1000: return f"{v:,}"
    return str(v)

def pct_chg(new, old):
    if not old or old == 0: return None
    return (new - old) / old * 100

def main():
    conn = snowflake.connector.connect(**CONN)
    cur = conn.cursor()
    now = datetime.utcnow()
    
    out = []
    anomalies = []
    out.append(f"🌅 STAGE Morning Brief")
    out.append(f"📅 {now.strftime('%a %d %b %Y')} | {now.strftime('%H:%M')} UTC")
    out.append("")

    # ── TRIALS ──
    try:
        rows = q(cur, """
            SELECT DATE_TRUNC('day', SUBSCRIPTION_START_AT_UTC) as dt,
                   COUNT(*) as total,
                   COUNT(CASE WHEN LOWER(COALESCE(SUBSCRIPTION_THROUGH,'')) NOT IN ('web','website') 
                              AND LOWER(COALESCE(PLATFORM,'')) != 'web' THEN 1 END) as app,
                   COUNT(CASE WHEN LOWER(COALESCE(SUBSCRIPTION_THROUGH,'')) IN ('web','website') 
                              OR LOWER(COALESCE(PLATFORM,'')) = 'web' THEN 1 END) as web
            FROM ANALYTICS_PROD.DBT_CORE.FCT_USER_SUBSCRIPTION_HISTORY
            WHERE IS_TRIAL = TRUE
              AND SUBSCRIPTION_START_AT_UTC >= DATEADD(day, -9, CURRENT_DATE())
              AND SUBSCRIPTION_START_AT_UTC < CURRENT_DATE()
            GROUP BY 1 ORDER BY 1 DESC LIMIT 8
        """)
        if rows:
            y = rows[0]
            p = rows[1] if len(rows) > 1 else None
            avg7 = sum(r['TOTAL'] for r in rows[:7]) / min(len(rows), 7)
            
            out.append(f"📲 TRIALS ({y['DT']})")
            out.append(f"  • Total: {fmt(y['TOTAL'])}")
            out.append(f"  • App: {fmt(y['APP'])} | Web: {fmt(y['WEB'])}")
            if p:
                chg = pct_chg(y['TOTAL'], p['TOTAL'])
                arrow = "🔺" if chg > 0 else "🔻"
                out.append(f"  • {arrow} {chg:+.1f}% vs prev ({fmt(p['TOTAL'])})")
                if chg < -20:
                    anomalies.append(f"🚨 Trials dropped {chg:.0f}% DoD ({fmt(p['TOTAL'])} → {fmt(y['TOTAL'])})")
            out.append(f"  • 7d avg: {fmt(avg7)}")
            dev = pct_chg(y['TOTAL'], avg7)
            if dev and abs(dev) > 15:
                out.append(f"  ⚠️ {dev:+.0f}% vs 7d avg!")
    except Exception as e:
        out.append(f"📲 TRIALS: ⚠️ {e}")

    out.append("")

    # ── D0 CONVERSION ──
    try:
        rows = q(cur, """
            SELECT TRIAL_ENDED_DAY, CONVERSION_PERCENTAGE, PAUSED_REVOKED_PERCENTAGE,
                   TRIALS_ENDED, CONVERSION_COUNT, ESTIMATED_REVENUE
            FROM ANALYTICS_PROD.DBT_MARTS.D0_TRIAL_CONVERSION
            ORDER BY TRIAL_ENDED_DAY DESC LIMIT 8
        """)
        if rows:
            y = rows[0]
            p = rows[1] if len(rows) > 1 else None
            avg7c = sum(r['CONVERSION_PERCENTAGE'] or 0 for r in rows[:7]) / min(len(rows), 7)
            avg7p = sum(r['PAUSED_REVOKED_PERCENTAGE'] or 0 for r in rows[:7]) / min(len(rows), 7)
            
            out.append(f"🎯 D0 CONVERSION ({y['TRIAL_ENDED_DAY']})")
            out.append(f"  • Conv: {float(y['CONVERSION_PERCENTAGE']):.1f}% (7d avg: {avg7c:.1f}%)")
            out.append(f"  • Cancel/Pause: {float(y['PAUSED_REVOKED_PERCENTAGE']):.1f}% (7d avg: {avg7p:.1f}%)")
            out.append(f"  • Converted: {fmt(y['CONVERSION_COUNT'])} / {fmt(y['TRIALS_ENDED'])}")
            
            rev = y['ESTIMATED_REVENUE'] or 0
            if rev >= 1e5:
                out.append(f"  • Est Revenue: ₹{rev/1e5:.1f}L")
            else:
                out.append(f"  • Est Revenue: ₹{fmt(rev)}")
            
            if p:
                chg = pct_chg(y['CONVERSION_PERCENTAGE'], p['CONVERSION_PERCENTAGE'])
                if chg:
                    arrow = "🔺" if chg > 0 else "🔻"
                    out.append(f"  • {arrow} Conv {chg:+.1f}% vs prev day")

            cr = y['CONVERSION_PERCENTAGE'] or 0
            cp = y['PAUSED_REVOKED_PERCENTAGE'] or 0
            if cr < 18:
                anomalies.append(f"🚨 D0 conversion {cr:.1f}% (below 18%)")
            if cp > 55:
                anomalies.append(f"🚨 Cancel/pause rate {cp:.1f}% (above 55%)")
    except Exception as e:
        out.append(f"🎯 D0 CONVERSION: ⚠️ {e}")

    out.append("")

    # ── MANDATES ──
    try:
        rows = q(cur, """
            SELECT COUNT(*) as active
            FROM ANALYTICS_PROD.DBT_CORE.DIM_MANDATES_HISTORY
            WHERE CURRENT_STATUS = 'mandate_active' AND IS_CURRENT = TRUE
        """)
        if rows:
            m = rows[0]['ACTIVE']
            out.append(f"💳 MANDATES: {fmt(m)} active")
    except Exception as e:
        out.append(f"💳 MANDATES: ⚠️ {e}")

    out.append("")

    # ── REVENUE RUN RATE ──
    try:
        rows = q(cur, """
            SELECT TRIAL_START_MONTH, TOTAL_REVENUE
            FROM ANALYTICS_PROD.DBT_VIZ.VIZ_MONTHLY_TRIAL_COHORT_REVENUE
            ORDER BY TRIAL_START_MONTH DESC LIMIT 3
        """)
        if rows:
            out.append(f"💰 REVENUE (cohort)")
            for r in rows:
                rev = r['TOTAL_REVENUE'] or 0
                if rev >= 1e7:
                    out.append(f"  • {r['TRIAL_START_MONTH']}: ₹{rev/1e7:.2f} Cr")
                elif rev >= 1e5:
                    out.append(f"  • {r['TRIAL_START_MONTH']}: ₹{rev/1e5:.1f}L")
    except Exception as e:
        out.append(f"💰 REVENUE: ⚠️ {e}")

    # ── ANOMALIES ──
    out.append("")
    if anomalies:
        out.append("⚠️ ANOMALIES")
        for a in anomalies:
            out.append(f"  {a}")
    else:
        out.append("✅ No anomalies detected")

    out.append("")
    out.append("—— end of brief ——")
    print("\n".join(out))

    cur.close()
    conn.close()

if __name__ == '__main__':
    main()
