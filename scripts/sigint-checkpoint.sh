#!/bin/bash
# Run checkpoint and alert HMT

CHECKPOINT="$1"
RESULT=$(bash /home/harsh/.openclaw/workspace/scripts/sigint-monitor.sh "$CHECKPOINT" 2>&1)
EXIT_CODE=$?

if [ $EXIT_CODE -eq 0 ]; then
  # Success - only alert on critical checkpoints
  if [ "$CHECKPOINT" = "T90" ] || [ "$CHECKPOINT" = "T6h" ]; then
    bash /home/harsh/.openclaw/workspace/scripts/send-telegram-topic.sh \
      --topic daily_ops \
      --message "✅ $CHECKPOINT checkpoint PASSED

No SIGINT warnings
No WhatsApp activity  
Gateway stable
Telegram responsive"
  fi
  echo "$RESULT" >> /home/harsh/.openclaw/workspace/memory/sigint-monitoring.log
else
  # Failure - IMMEDIATE alert
  bash /home/harsh/.openclaw/workspace/scripts/send-telegram-topic.sh \
    --topic daily_ops \
    --message "❌ $CHECKPOINT checkpoint FAILED

$RESULT

HMT: The SIGINT leak is back."
  echo "FAIL: $RESULT" >> /home/harsh/.openclaw/workspace/memory/sigint-monitoring.log
fi
