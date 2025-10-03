#!/usr/bin/env bash
# start_local_ngrok.sh
# Usage: NGROK_AUTH_TOKEN=yourtoken ./start_local_ngrok.sh
set -euo pipefail

cd "$(dirname "$0")"

if [ -z "${NGROK_AUTH_TOKEN:-}" ]; then
  echo "Set NGROK_AUTH_TOKEN env var (or NGROK_TOKEN) with your ngrok auth token"
  exit 1
fi

# Install npm deps if needed
if [ ! -d node_modules ]; then
  npm install
fi

# Run the helper
node run_with_ngrok.js
