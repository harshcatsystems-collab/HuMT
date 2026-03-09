#!/bin/bash
# Dead Man's Switch - Detects if gateway is frozen (alive but not logging)

LOG_THRESHOLD_MINUTES=10
ALERT_SCRIPT="/home/harsh/.openclaw/workspace/scripts/send-telegram-topic.sh"

# Check if gateway has logged ANYTHING in last N minutes
LAST_LOG_COUNT=$(journalctl --user -u openclaw-gateway --since "$LOG_THRESHOLD_MINUTES minutes ago" --no-pager 2>/dev/null | wc -l)

if [ "$LAST_LOG_COUNT" -eq 0 ]; then
  echo "🚨 GATEWAY FROZEN - No logs in last $LOG_THRESHOLD_MINUTES minutes"
  
  # Alert HMT
  bash "$ALERT_SCRIPT" --topic daily_ops --message "🚨 Gateway freeze detected - no logs for ${LOG_THRESHOLD_MINUTES}min. Auto-restarting..." 2>/dev/null || true
  
  # Restart gateway
  systemctl --user restart openclaw-gateway
  
  # Wait for restart
  sleep 10
  
  # Confirm it's back
  if systemctl --user is-active --quiet openclaw-gateway; then
    bash "$ALERT_SCRIPT" --topic daily_ops --message "✅ Gateway restarted successfully" 2>/dev/null || true
    echo "✅ Gateway restarted"
  else
    echo "❌ Gateway restart failed"
  fi
else
  echo "✓ Gateway healthy ($LAST_LOG_COUNT log entries in last $LOG_THRESHOLD_MINUTES min)"
fi
