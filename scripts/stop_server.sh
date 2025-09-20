#!/bin/bash
set -euo pipefail

echo "Stopping emergency-dashboard application"

if command -v pm2 >/dev/null 2>&1; then
  pm2 stop emergency-dashboard || true
  pm2 delete emergency-dashboard || true
  pm2 save
else
  if [ -f /var/run/emergency-dashboard.pid ]; then
    kill "$(cat /var/run/emergency-dashboard.pid)" || true
    rm -f /var/run/emergency-dashboard.pid
  else
    pkill -f "dist/emergency-dashboard/server/server.mjs" || true
  fi
fi

exit 0
