#!/bin/bash
# Full 353-channel scan with tier1 thread expansion
# Single pass — parallelized internally (10 concurrent workers)
# Usage: slack-full-scan.sh [hours_back]

HOURS="${1:-24}"
DIR="/home/harsh/.openclaw/workspace"

python3 "$DIR/scripts/slack-scan-threads.py" "$HOURS" --all --threads tier1
