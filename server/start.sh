#!/usr/bin/env sh
set -e

# If SERVICE_ACCOUNT_JSON is set (base64 or raw), write it to /tmp/service-account.json
if [ -n "$SERVICE_ACCOUNT_JSON" ]; then
  echo "$SERVICE_ACCOUNT_JSON" > /tmp/service-account.json
  export GOOGLE_APPLICATION_CREDENTIALS=/tmp/service-account.json
fi

# Default port fallback
PORT=${PORT:-3000}

node index.js
