#!/usr/bin/env python3
"""
Metabase Anomaly Detection — Daily KPI Check
Pulls key metrics, compares recent trend, outputs alerts + summary.
"""

import json
import urllib.request
from datetime import datetime

API_BASE = "https://stage.metabaseapp.com/api"
API_KEY = "mb_TFdivJ3ePUe5v9xeA77Xphanlq+n0BiKVGXhmT3H1o4="

def query_card(card_id, timeout=20):
    url = f"{API_BASE}/card/{card_id}/query/json"
    req = urllib.request.Request(url, data=b'', headers={
        "x-api-key": API_KEY, "Content-Type": "application/json"
    })
    try:
        resp = urllib.request.urlopen(req, timeout=timeout)
        return json.loads(resp.read())
    except Exception as e:
        return None

# Define KPIs with expected data shapes
KPIS = [
    # Time-series cards (have date + value columns, we want last 8 days)
    {"card_id": 4637, "name": "Trial Count", "type": "timeseries", "val_col": "Trial Count Past 24 Hours", "threshold": 20, "direction": "drop"},
    {"card_id": 4646, "name": "New Subscriptions", "type": "timeseries", "val_col": "New Subscribers Today", "threshold": 20, "direction": "drop"},
    {"card_id": 4658, "name": "Revenue (Rs)", "type": "timeseries", "val_col": "Sum of Paying Price (Rs)", "threshold": 15, "direction": "drop"},
    # ML Widget conversion (dashboard 4699, card 14726)
    {"card_id": 14726, "name": "Thumbnail→Playback Conversion %", "type": "ml_widget", "threshold": 10, "direction": "both"},
    # Scalar cards (single value, no trend — just report)
    {"card_id": 4644, "name": "Data Freshness", "type": "scalar"},
    {"card_id": 3283, "name": "Distinct Users Watched (all-time)", "type": "scalar"},
    {"card_id": 3289, "name": "Total Hours Watched (all-time)", "type": "scalar"},
]

def process_timeseries(kpi, data):
    if not data or len(data) < 2:
        return None, f"⚠️ {kpi['name']}: insufficient data"
    
    val_col = kpi["val_col"]
    # Get last 8 rows (sorted by date typically)
    recent = data[-8:] if len(data) >= 8 else data
    
    values = []
    for row in recent:
        v = row.get(val_col)
        if isinstance(v, (int, float)):
            values.append(v)
    
    if len(values) < 2:
        return None, f"⚠️ {kpi['name']}: no numeric values found"
    
    latest = values[-1]
    avg_prev = sum(values[:-1]) / len(values[:-1])
    
    if avg_prev == 0:
        return None, f"📊 {kpi['name']}: {latest:,.0f} (avg=0)"
    
    pct = ((latest - avg_prev) / avg_prev) * 100
    arrow = "📈" if pct > 0 else "📉"
    sign = "+" if pct > 0 else ""
    line = f"{arrow} {kpi['name']}: {latest:,.0f} ({sign}{pct:.1f}% vs {len(values)-1}d avg {avg_prev:,.0f})"
    
    is_alert = False
    t = kpi["threshold"]
    d = kpi["direction"]
    if d == "drop" and pct < -t:
        is_alert = True
    elif d == "spike" and pct > t:
        is_alert = True
    elif d == "both" and abs(pct) > t:
        is_alert = True
    
    return is_alert, f"🚨 {line}" if is_alert else line

def process_ml_widget(kpi, data):
    if not data:
        return None, f"⚠️ {kpi['name']}: no data"
    
    # Separate ML vs Non-ML
    ml_rows = [r for r in data if r.get("Widget Segment") == "ML Widget"]
    nonml_rows = [r for r in data if r.get("Widget Segment") == "Non-ML Widget"]
    
    lines = []
    if ml_rows:
        latest_ml = ml_rows[-1]
        lines.append(f"  ML Widget: {latest_ml.get('Conversion Rate %', '?')}% ({latest_ml.get('Date', '?')})")
    if nonml_rows:
        latest_nonml = nonml_rows[-1]
        lines.append(f"  Non-ML: {latest_nonml.get('Conversion Rate %', '?')}% ({latest_nonml.get('Date', '?')})")
    
    if ml_rows and nonml_rows:
        ml_val = ml_rows[-1].get("Conversion Rate %", 0)
        nonml_val = nonml_rows[-1].get("Conversion Rate %", 0)
        delta = ml_val - nonml_val
        lines.append(f"  Delta: +{delta:.1f}pp")
    
    summary = f"📊 {kpi['name']}:\n" + "\n".join(lines)
    return None, summary

def process_scalar(kpi, data):
    if not data or len(data) == 0:
        return None, f"⚠️ {kpi['name']}: no data"
    row = data[0]
    val = list(row.values())[0]
    if isinstance(val, float):
        return None, f"📊 {kpi['name']}: {val:,.0f}"
    return None, f"📊 {kpi['name']}: {val}"

def main():
    alerts = []
    metrics = []
    
    for kpi in KPIS:
        data = query_card(kpi["card_id"])
        
        if data is None:
            metrics.append(f"⚠️ {kpi['name']}: query timeout/error")
            continue
        
        if kpi["type"] == "timeseries":
            is_alert, line = process_timeseries(kpi, data)
        elif kpi["type"] == "ml_widget":
            is_alert, line = process_ml_widget(kpi, data)
        elif kpi["type"] == "scalar":
            is_alert, line = process_scalar(kpi, data)
        else:
            continue
        
        if is_alert:
            alerts.append(line)
        else:
            metrics.append(line)
    
    now = datetime.utcnow().strftime("%Y-%m-%d %H:%M UTC")
    
    print(f"📊 DAILY METRICS CHECK — {now}")
    print()
    if alerts:
        print("🚨 ALERTS")
        for a in alerts:
            print(a)
        print()
    else:
        print("✅ No anomalies detected")
        print()
    
    print("📈 METRICS SNAPSHOT")
    for m in metrics:
        print(m)

if __name__ == "__main__":
    main()
