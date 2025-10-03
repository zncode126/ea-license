FROM node:18-bullseye-slim

# Create app directory
WORKDIR /usr/src/app

# Copy package files first for better layer caching
COPY server/package*.json ./server/

# Install OS-level build tools required by some native npm modules
RUN set -eux; \
	apt-get update; \
	apt-get install -y --no-install-recommends python3 build-essential make g++ ca-certificates; \
	rm -rf /var/lib/apt/lists/*;

# Install node dependencies inside the server folder
RUN set -eux; \
	if [ -f /usr/src/app/server/package-lock.json ]; then cd /usr/src/app/server && npm ci --only=production; \
	else cd /usr/src/app/server && npm install --production; fi

# Copy server source code
COPY server/ ./server/

# DEBUG: list files to help diagnose missing index.js during remote builds
RUN echo "==== /usr/src/app contents ====" && ls -la /usr/src/app && echo "==== /usr/src/app/server contents ====" && ls -la /usr/src/app/server || true

# Make sure start wrapper is executable
RUN if [ -f /usr/src/app/server/start.sh ]; then chmod +x /usr/src/app/server/start.sh; fi

EXPOSE 3000

WORKDIR /usr/src/app/server
CMD ["./start.sh"]
