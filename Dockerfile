FROM node:18-alpine

# Build image by copying the server/ folder from the repo root.
WORKDIR /usr/src/app

# Copy package files first for better caching
COPY server/package.json server/package-lock.json ./

# Install dependencies
RUN npm ci --only=production || true

# Copy the rest of the server app
COPY server/ ./

# Ensure start script is executable
RUN if [ -f ./start.sh ]; then chmod +x ./start.sh; fi

EXPOSE 3000

CMD ["./start.sh"]
