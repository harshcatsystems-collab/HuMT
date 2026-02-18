#!/usr/bin/env python3
"""STAGE Anomaly Detection — standalone critical metric checks."""

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

def main():
    conn = snowflake.connector.connect(**CONN)
    cur = conn.cursor()
    now = datetime.utcnow()
    anomalies = []

    # 1. Trials drop >20% DoD
    try:
        rows = q(cur, """
            SELECT DATE_TRUNC('day', SUBSCRIPTION_START_AT_UTC) as dt, COUNT(*) as cnt
            FROM ANALYTICS_PROD.DBT_CORE.FCT_USER_SUBSCRIPTION_HISTORY
            WHERE IS_TRIAL = TRUE
              AND SUBSCRIPTION_START_AT_UTC >= DATEADD(day, -3, CURRENT_DATE())
              AND SUBSCRIPTION_START_AT_UTC < CURRENT_DATE()
            GROUP BY 1 ORDER BY 1 DESC LIMIT 2
        """)
        if len(rows) >= 2:
            curr, prev = rows[0]['CNT'], rows[1]['CNT']
            if prev > 0:
                chg = (curr - prev) / prev * 100
                if chg < -20:
                    anomalies.append(f"🚨 TRIALS dropped {chg:.0f}% DoD ({prev:,} → {curr:,})")
    except Exception as e:
        anomalies.append(f"⚠️ Trial check failed: {e}")

    # 2. D0 conversion below 18%
    try:
        rows = q(cur, """
            SELECT CONVERSION_PERCENTAGE, TRIAL_ENDED_DAY
            FROM ANALYTICS_PROD.DBT_MARTS.D0_TRIAL_CONVERSION
            ORDER BY TRIAL_ENDED_DAY DESC LIMIT 1
        """)
        if rows and rows[0]['CONVERSION_PERCENTAGE'] is not None:
            cr = rows[0]['CONVERSION_PERCENTAGE']
            if cr < 18:
                anomalies.append(f"🚨 D0 CONVERSION at {cr:.1f}% (below 18%) on {rows[0]['TRIAL_ENDED_DAY']}")
    except Exception as e:
        anomalies.append(f"⚠️ D0 conv check failed: {e}")

    # 3. Cancellation rate above 55%
    try:
        rows = q(cur, """
            SELECT PAUSED_REVOKED_PERCENTAGE, TRIAL_ENDED_DAY
            FROM ANALYTICS_PROD.DBT_MARTS.D0_TRIAL_CONVERSION
            ORDER BY TRIAL_ENDED_DAY DESC LIMIT 1
        """)
        if rows and rows[0]['PAUSED_REVOKED_PERCENTAGE'] is not None:
            cp = rows[0]['PAUSED_REVOKED_PERCENTAGE']
            if cp > 55:
                anomalies.append(f"🚨 CANCELLATION at {cp:.1f}% (above 55%) on {rows[0]['TRIAL_ENDED_DAY']}")
    except Exception as e:
        anomalies.append(f"⚠️ Cancel check failed: {e}")

    # 4. Mandate count drop >2% (vs 7d ago snapshot approximation)
    try:
        rows = q(cur, """
            SELECT COUNT(*) as active
            FROM ANALYTICS_PROD.DBT_CORE.DIM_MANDATES_HISTORY
            WHERE CURRENT_STATUS = 'mandate_active' AND IS_CURRENT = TRUE
        """)
        if rows:
            current = rows[0]['ACTIVE']
            # Compare against known baseline ~2.09M from schema
            baseline = 2090000
            chg = (current - baseline) / baseline * 100
            if chg < -2:
                anomalies.append(f"🚨 MANDATES at {current:,} — dropped {chg:.1f}% vs baseline {baseline:,}")
    except Exception as e:
        anomalies.append(f"⚠️ Mandate check failed: {e}")

    # Output
    print(f"🔍 STAGE Anomaly Check — {now.strftime('%Y-%m-%d %H:%M UTC')}")
    print()
    if anomalies:
        for a in anomalies:
            print(f"  {a}")
    else:
        print("  ✅ No anomalies detected")
    print()

    cur.close()
    conn.close()

if __name__ == '__main__':
    main()
