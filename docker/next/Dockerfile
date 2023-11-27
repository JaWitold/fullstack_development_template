# Use the official lightweight Node.js 16 image.
# https://hub.docker.com/_/node
FROM node:20-alpine

# Set the working directory in the container
WORKDIR /var/www/next

# Copy package.json and package-lock.json to work directory
COPY next/package*.json ./

# Install dependencies
RUN npm install

# Start server
CMD ["npm", "run", "start"]