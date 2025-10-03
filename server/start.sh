#!/usr/bin/env sh
set -e

# If SERVICE_ACCOUNT_JSON is set (base64 or raw), write it to /tmp/service-account.json
if [ -n "$SERVICE_ACCOUNT_JSON" ]; then
  echo "$SERVICE_ACCOUNT_JSON" > /tmp/service-account.json
  export GOOGLE_APPLICATION_CREDENTIALS=/tmp/service-account.json
fi

# Default port fallback
PORT=${PORT:-3000}

# Prefer absolute path so different build contexts / WORKDIRs still work inside containers
if [ -f "/usr/src/app/server/index.js" ]; then
  exec node /usr/src/app/server/index.js
elif [ -f "/usr/src/app/index.js" ]; then
  exec node /usr/src/app/index.js
elif [ -f "./index.js" ]; then
  exec node ./index.js
else
  echo "Error: index.js not found in /usr/src/app/server, /usr/src/app, or current directory" >&2
  exit 1
fi
