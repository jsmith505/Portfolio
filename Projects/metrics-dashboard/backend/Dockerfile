# Use lightweight Node.js
FROM node:18-alpine

# Set working directory
WORKDIR /app

# Copy package.json and lock file first (for caching)
COPY package*.json ./

# Install dependencies
RUN npm install --production

# Copy the rest of the code
COPY . .

# Expose backend port
EXPOSE 4000

# Start the server
CMD ["npm", "start"]

