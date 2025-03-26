# Step 1: Build the app
FROM node:18-alpine AS builder

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY app/package.json app/package-lock.json ./

# Install dependencies
RUN npm install

# Copy only the necessary files (avoid copying fleet/ or unwanted files)
COPY app ./

# Build the app
RUN npm run build

# Step 2: Create the final production container
FROM node:18-alpine

# Set working directory
WORKDIR /app

# Copy built files from the builder stage
COPY --from=builder /app/dist /app/dist
COPY --from=builder /app/package.json /app/package.json
COPY --from=builder /app/node_modules /app/node_modules

# Expose the port the app runs on
EXPOSE 3000

# Start the app
CMD ["npx", "serve", "-s", "dist"]
