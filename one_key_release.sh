#!/bin/bash

# Step1: Switch to master branch and pull the latest changes
echo "Switching to master branch and updating..."
git checkout master
git pull

# Step2: Get the latest commit log on master branch
latestCommitLog=$(git log -1)
echo "Latest commit log on master branch:"
echo "$latestCommitLog"

# Step3: User confirmation to proceed
read -p "Do you want to use this version to build the Docker image? (yes/no) " userConfirmation
if [ "$userConfirmation" != "yes" ]; then
    echo "User aborted the process."
    exit
fi

# Get the hash ID of the latest commit
latestCommitHash=$(git rev-parse HEAD)

# Step4: Check for .env file and back it up if it exists
envFilePath="./.env"
backupEnvFilePath="./.env.temp"

if [ -f "$envFilePath" ]; then
    cp "$envFilePath" "$backupEnvFilePath"
    echo "Existing .env file backed up."
fi

# Step5: Create a new .env file from .env.template
templatePath="./.env.template"
sed -e "s/VERSION_TAG=.*/VERSION_TAG=rel-$latestCommitHash/" "$templatePath" > "$envFilePath"
echo "New .env file has been created."

# Step6: Stop all containers using docker compose
docker compose down

# Step7: Build containers with no cache
docker compose build --no-cache

# Step8: Remove dangling images
docker rmi $(docker images -q -f "dangling=true")

# Step9: Restore .env file
if [ -f "$backupEnvFilePath" ]; then
    mv "$backupEnvFilePath" "$envFilePath"
    echo "Original .env file restored."
else
    rm "$envFilePath"
    echo "Temporary .env file removed."
fi

# Step10: Final user message
echo "All container images are created."
read -p "Press any key to exit." anyKey
