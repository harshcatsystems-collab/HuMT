#!/bin/bash
# M0 V4 Analysis Execution Script
# Systematically pulls data across 7 dimensions from Metabase

API_KEY="mb_TFdivJ3ePUe5v9xeA77Xphanlq+n0BiKVGXhmT3H1o4="
BASE_URL="https://stage.metabaseapp.com/api"
OUTPUT_DIR="/home/harsh/.openclaw/workspace/data/m0-v4-data"

mkdir -p $OUTPUT_DIR

echo "Starting M0 V4 data collection..."
echo "$(date): Execution begins" > $OUTPUT_DIR/execution.log

# Dimension 1: Platform (Web/App)
echo "Pulling platform data..."
curl -s -X POST -H "x-api-key: $API_KEY" "$BASE_URL/card/13211/query" > $OUTPUT_DIR/platform.json

# Dimension 2: Trial Activity (Engagement Tier)
echo "Pulling trial activity segmentation..."
curl -s -X POST -H "x-api-key: $API_KEY" "$BASE_URL/card/6203/query" > $OUTPUT_DIR/trial_watcher_pct.json
curl -s -X POST -H "x-api-key: $API_KEY" "$BASE_URL/card/12980/query" > $OUTPUT_DIR/trial_daily_conversion.json

# Dimension 4: Dialect
echo "Pulling dialect segmentation..."
curl -s -X POST -H "x-api-key: $API_KEY" "$BASE_URL/card/6188/query" > $OUTPUT_DIR/dialect.json

# Dimension 7: App Install Status  
echo "Pulling install status data..."
curl -s -X POST -H "x-api-key: $API_KEY" "$BASE_URL/card/12992/query" > $OUTPUT_DIR/install_status.json 2>/dev/null || echo "Card not found, skipping"

echo "$(date): Base data collection complete" >> $OUTPUT_DIR/execution.log
echo "Data files created in $OUTPUT_DIR"
ls -lh $OUTPUT_DIR/
