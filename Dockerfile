# Step 1: Build the app
FROM node:18-alpine AS builder

WORKDIR /app

# Copy package.json and package-lock.json first (better caching for dependencies)
COPY app/package.json app/package-lock.json ./

RUN npm install --production

# Copy the rest of the app
COPY app ./

# Build the app
RUN npm run build

# Step 2: Create the final production container
FROM node:18-alpine

WORKDIR /app

# Install serve for static file serving
RUN npm install -g serve

# Copy built files from the builder stage
COPY --from=builder /app/dist /app/dist
COPY --from=builder /app/package.json /app/package.json

# Expose the port the app runs on
EXPOSE 3000

# Start the app
CMD ["serve", "-s", "dist"]
