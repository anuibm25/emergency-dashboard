#!/bin/bash
set -euo pipefail

echo "Running BeforeInstall hook"
# Ensure the target directory exists
mkdir -p /var/www/emergency-dashboard
# Clean previous artifacts
rm -rf /var/www/emergency-dashboard/*

# Install system dependencies if needed (example; adapt to your AMI)
# apt-get update && apt-get install -y nginx curl

exit 0
