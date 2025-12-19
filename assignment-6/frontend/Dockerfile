# Use lightweight Node.js slim image
FROM node:20-slim

# Set working directory
WORKDIR /app

# Copy only package files first (for caching)
COPY package*.json ./

# Install dependencies
RUN npm install --production

# Copy frontend code
COPY . .

# Expose port
EXPOSE 3000

# Run app
CMD ["node", "app.js"]
