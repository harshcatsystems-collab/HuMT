#!/bin/bash
# SIGINT Leak Monitoring - Continuous validation

CHECKPOINT="$1"  # T0, T90, T2h, T6h
GATEWAY_START="2026-03-09 11:17:36"

case "$CHECKPOINT" in
  "T0")
    echo "=== T+0 CHECKPOINT (11:20 UTC) ==="
    echo "3 minutes after restart"
    ;;
  "T90")
    echo "=== T+90min CHECKPOINT (12:47 UTC) ==="
    echo "This is when SIGINT warning appeared in both previous freezes"
    ;;
  "T2h")
    echo "=== T+2h CHECKPOINT (13:17 UTC) ==="
    ;;
  "T6h")
    echo "=== T+6h CHECKPOINT (17:17 UTC) ==="
    echo "This is when event loop fully froze before"
    ;;
esac

# TEST 1: WhatsApp presence
echo -e "\n1. WhatsApp check:"
WA_LOGS=$(journalctl --user -u openclaw-gateway --since "$GATEWAY_START" --no-pager | grep -i "whatsapp" | wc -l)
if [ "$WA_LOGS" -eq 0 ]; then
  echo "   ✅ PASS: No WhatsApp activity ($WA_LOGS logs)"
else
  echo "   ❌ FAIL: WhatsApp still active ($WA_LOGS logs)"
  journalctl --user -u openclaw-gateway --since "$GATEWAY_START" --no-pager | grep -i "whatsapp" | tail -5
  exit 1
fi

# TEST 2: SIGINT warnings
echo "2. SIGINT warnings:"
SIGINT_WARNS=$(journalctl --user -u openclaw-gateway --since "$GATEWAY_START" --no-pager | grep -i "MaxListenersExceeded\|SIGINT.*warn" | wc -l)
if [ "$SIGINT_WARNS" -eq 0 ]; then
  echo "   ✅ PASS: No SIGINT warnings"
else
  echo "   ❌ FAIL: $SIGINT_WARNS SIGINT warnings detected"
  journalctl --user -u openclaw-gateway --since "$GATEWAY_START" --no-pager | grep -i "MaxListeners\|SIGINT" | tail -5
  exit 1
fi

# TEST 3: Gateway crashes
echo "3. Gateway stability:"
CRASHES=$(journalctl --user -u openclaw-gateway --since "$GATEWAY_START" --no-pager | grep -i "failed with result\|exit.*code.*1" | wc -l)
if [ "$CRASHES" -eq 0 ]; then
  UPTIME=$(( $(date +%s) - $(date -d "$GATEWAY_START" +%s) ))
  echo "   ✅ PASS: No crashes (uptime: ${UPTIME}s)"
else
  echo "   ❌ FAIL: $CRASHES crashes detected"
  exit 1
fi

# TEST 4: Telegram responsive
echo "4. Telegram health:"
TG_ACTIVITY=$(journalctl --user -u openclaw-gateway --since "10 minutes ago" --no-pager | grep -i "telegram" | wc -l)
if [ "$TG_ACTIVITY" -gt 0 ]; then
  echo "   ✅ PASS: Telegram active ($TG_ACTIVITY recent logs)"
else
  echo "   ⚠️  WARN: No recent Telegram activity"
fi

# TEST 5: Heartbeat running
echo "5. Heartbeat status:"
HB_LOGS=$(journalctl --user -u openclaw-gateway --since "$GATEWAY_START" --no-pager | grep -i "heartbeat.*started" | wc -l)
if [ "$HB_LOGS" -gt 0 ]; then
  echo "   ✅ PASS: Heartbeat initialized"
else
  echo "   ❌ FAIL: No heartbeat logs"
  exit 1
fi

echo -e "\n✅ ALL CHECKS PASSED at $CHECKPOINT"
exit 0
