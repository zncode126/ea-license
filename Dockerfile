FROM node:18-alpine

# Copy entire repo into the image so we can support multiple build contexts
WORKDIR /usr/src/app
COPY . /usr/src/app

# Determine where package.json is and install dependencies there
RUN set -eux; \
	if [ -f /usr/src/app/package.json ]; then APP_DIR=/usr/src/app; \
	elif [ -f /usr/src/app/server/package.json ]; then APP_DIR=/usr/src/app/server; \
	else echo "package.json not found in /usr/src/app or /usr/src/app/server" >&2; exit 1; fi; \
	echo "Installing dependencies in $APP_DIR"; \
	cd "$APP_DIR"; npm ci --only=production;

# Ensure start script is executable
RUN if [ -f /usr/src/app/server/start.sh ]; then chmod +x /usr/src/app/server/start.sh; fi

EXPOSE 3000

WORKDIR /usr/src/app/server
CMD ["./start.sh"]
