# Use a lightweight Node.js image
FROM node:18-alpine

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json first (better caching)
COPY package*.json ./

# Ensure user has correct permissions (avoids permission errors)
RUN adduser -D appuser && chown -R appuser /app
USER appuser

# Install dependencies
RUN npm install

# Copy the rest of the project
COPY --chown=appuser . .

# Build the React app
RUN npm run build

# Switch back to root for serving
USER root

# Install a lightweight HTTP server
RUN npm install -g serve

# Expose the port
EXPOSE 3000

# Start the server
CMD ["serve", "-s", "build", "-l", "3000"]
