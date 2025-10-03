# Minimal Dockerfile for the license server
FROM node:18-alpine

# Create app directory
WORKDIR /usr/src/app

# Install dependencies
COPY package.json package-lock.json ./
RUN npm ci --only=production

# Copy app
COPY . .

# Make the start script executable
RUN chmod +x ./start.sh

# Expose port (Render will override via $PORT)
EXPOSE 3000

# Use the start wrapper which writes the service account JSON (if provided)
CMD ["./start.sh"]
