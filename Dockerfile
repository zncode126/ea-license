FROM node:18-alpine

# Create app directory
WORKDIR /usr/src/app

# Copy package files first for better layer caching
COPY server/package*.json ./server/

# Install dependencies inside the server folder
RUN set -eux; \
	if [ -f /usr/src/app/server/package-lock.json ]; then cd /usr/src/app/server && npm ci --only=production; \
	else cd /usr/src/app/server && npm install --production; fi

# Copy server source code
COPY server/ ./server/

# Make sure start wrapper is executable
RUN if [ -f /usr/src/app/server/start.sh ]; then chmod +x /usr/src/app/server/start.sh; fi

EXPOSE 3000

WORKDIR /usr/src/app/server
CMD ["./start.sh"]
