#!/usr/bin/env bash
# Continuous monitoring + alerting demo for the production container.
# Usage (run on the host):  DISCORD_WEBHOOK="https://discord.com/api/webhooks/xxx" ./monitor.sh
#
# It polls the production health endpoint every 10 seconds and sends a Discord
# alert when the service goes DOWN and again when it RECOVERS. Use it in the demo
# video: start it, then `docker stop app-prod` to trigger a DOWN alert, then
# `docker start app-prod` to trigger a RECOVERY alert.

URL="${HEALTH_URL:-http://localhost:3002/health}"
WEBHOOK="${DISCORD_WEBHOOK:?Set DISCORD_WEBHOOK first}"
state="up"

notify () {
  curl -s -H "Content-Type: application/json" -X POST \
    -d "{\"content\": \"$1\"}" "$WEBHOOK" >/dev/null 2>&1 || true
}

echo "Monitoring $URL every 10s. Press Ctrl+C to stop."
notify "MONITOR STARTED: watching production health at $URL"

while true; do
  if curl -m 5 -fsS "$URL" >/dev/null 2>&1; then
    if [ "$state" = "down" ]; then
      echo "$(date '+%H:%M:%S') RECOVERED"
      notify "RECOVERY: production health check is passing again at $URL"
      state="up"
    else
      echo "$(date '+%H:%M:%S') OK"
    fi
  else
    if [ "$state" = "up" ]; then
      echo "$(date '+%H:%M:%S') DOWN"
      notify "ALERT: production is DOWN - health check failing at $URL. On-call team notified."
      state="down"
    else
      echo "$(date '+%H:%M:%S') still DOWN"
    fi
  fi
  sleep 10
done
