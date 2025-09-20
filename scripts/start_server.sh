#!/bin/bash
set -euo pipefail

echo "Starting emergency-dashboard application"
cd /var/www/emergency-dashboard

# Prefer PM2 if installed for process management
if command -v pm2 >/dev/null 2>&1; then
  pm2 stop emergency-dashboard || true
  pm2 start --name emergency-dashboard --interpreter node --node-args="" dist/emergency-dashboard/server/server.mjs -- -p ${PORT:-4000}
  pm2 save
else
  # Fallback: start node in the background and record PID
  pkill -f "dist/emergency-dashboard/server/server.mjs" || true
  PORT=${PORT:-4000}
  node dist/emergency-dashboard/server/server.mjs &
  echo $! > /var/run/emergency-dashboard.pid
fi

exit 0
