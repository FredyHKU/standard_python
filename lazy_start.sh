#!/bin/bash

# Step 1: Check if .env file exists
if [ ! -f "./.env" ]; then
    echo "The .env file does not exist. Please create it from .env.template."
    exit 1
fi

# Step 2: Run Docker Compose down
echo "Shutting down all running Docker containers..."
docker compose down

# Step 3: Build and run Docker Compose up
echo "Building and starting Docker containers..."
docker compose up -d --build

# Step 4: Remove dangling Docker images
echo "Removing dangling Docker images..."
docker rmi $(docker images -q -f "dangling=true")

# Step 5: Notify user and wait for key press to exit
echo "All services are up and running. Press any key to exit."
read -n 1 -s -r
