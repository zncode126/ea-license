# Minimal Dockerfile for the license server
FROM node:18-alpine

# Copy entire repo into the image so we can support both build contexts
# (repo root or server/ as build context on Render)
WORKDIR /usr/src/app
COPY . /usr/src/app

# Determine where package.json is and install dependencies there
RUN set -eux; \
	if [ -f /usr/src/app/package.json ]; then APP_DIR=/usr/src/app; \
	elif [ -f /usr/src/app/server/package.json ]; then APP_DIR=/usr/src/app/server; \
	else echo "package.json not found in /usr/src/app or /usr/src/app/server" >&2; exit 1; fi; \
	echo "Installing dependencies in $APP_DIR"; \
	cd "$APP_DIR"; npm ci --only=production;

# Ensure start script is executable (it lives in server/start.sh)
RUN if [ -f /usr/src/app/server/start.sh ]; then chmod +x /usr/src/app/server/start.sh; fi

# Expose port (Render will override via $PORT)
EXPOSE 3000

# Set working dir to the app folder (server or repo root)
WORKDIR /usr/src/app/server

# Use the start wrapper
CMD ["./start.sh"]
