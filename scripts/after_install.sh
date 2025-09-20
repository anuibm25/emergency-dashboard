#!/bin/bash
set -euo pipefail

echo "Running AfterInstall hook"
# Copy application files to target directory
rsync -a --delete ./ /var/www/emergency-dashboard/
cd /var/www/emergency-dashboard

# Install Node dependencies
if command -v npm >/dev/null 2>&1; then
  npm ci --production || npm install --production
else
  echo "npm is not available on PATH"
fi

# Build the Angular app for production
if command -v npm >/dev/null 2>&1; then
  npm run build --silent || true
fi

exit 0
