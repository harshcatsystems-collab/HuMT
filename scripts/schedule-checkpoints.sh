#!/bin/bash
# Schedule all SIGINT monitoring checkpoints

# T+90min checkpoint (12:47 UTC) - CRITICAL (when warning appeared before)
echo "0 47 12 9 3 * bash /home/harsh/.openclaw/workspace/scripts/sigint-checkpoint.sh T90" >> /tmp/checkpoints.cron

# T+2h checkpoint (13:17 UTC)
echo "0 17 13 9 3 * bash /home/harsh/.openclaw/workspace/scripts/sigint-checkpoint.sh T2h" >> /tmp/checkpoints.cron

# T+6h checkpoint (17:17 UTC) - FINAL (when freeze completed before)
echo "0 17 17 9 3 * bash /home/harsh/.openclaw/workspace/scripts/sigint-checkpoint.sh T6h" >> /tmp/checkpoints.cron

# Install
crontab -l 2>/dev/null > /tmp/current.cron
cat /tmp/checkpoints.cron >> /tmp/current.cron
crontab /tmp/current.cron

echo "✅ Checkpoints scheduled:"
crontab -l | grep sigint-checkpoint
