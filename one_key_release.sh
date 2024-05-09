#!/bin/bash

# Step 1: git management

# Prompt the user to enter the name of the release branch
read -p "Enter the release branch name: " branch_name

# Switch to the specified branch
echo "Switching to branch: $branch_name..."
git checkout $branch_name
echo

if [ $? -eq 0 ]; then
    echo "Successfully switched to $branch_name."

    # Check if there is an associated remote branch
    remote_branch=$(git rev-parse --abbrev-ref --symbolic-full-name @{u} 2>/dev/null)

    if [ -n "$remote_branch" ]; then
        # If a remote branch exists, pull the latest changes
        echo "Pulling latest changes from $remote_branch..."
        git pull
        if [ $? -eq 0 ]; then
            echo "Successfully updated $branch_name."
        else
            echo "Failed to pull from $remote_branch. Please check your network or remote repository settings."
        fi
    else
        # No associated remote branch
        echo "No remote branch associated with $branch_name. Skipping pull."
    fi
else
    echo "Failed to switch to branch $branch_name. Please check if the branch exists."
fi

# Step2: Get the latest commit log on master branch
latestCommitLog=$(git log -1)
echo
echo "Latest commit log on master branch:"
echo "$latestCommitLog"
echo

# Step3: User confirmation to proceed
read -p "Do you want to use this version to build the Docker image? (yes/no) " userConfirmation
if [ "$userConfirmation" != "yes" ]; then
    echo
    echo "User aborted the process."
    exit
fi

# Get the hash ID of the latest commit
latestCommitHash=$(git rev-parse $branch_name)

# Step4: Check for .env file and back it up if it exists
envFilePath="./.env"
backupEnvFilePath="./.env.temp"

if [ -f "$envFilePath" ]; then
    cp "$envFilePath" "$backupEnvFilePath"
    echo
    echo "Existing .env file backed up."
fi

# Step5: Create a new .env file from .env.template
templatePath="./env.template"
sed -e "s/VERSION_TAG=.*/VERSION_TAG=rel-$latestCommitHash/" "$templatePath" > "$envFilePath"

# Step6: Stop all containers using docker compose
echo
docker compose down
echo "Current docker stack down."
echo

# Step7: Build containers with no cache
echo "Start building images"
docker compose build --no-cache
echo

# Step 8: Remove dangling images if any exist
dangling_images=$(docker images -q -f "dangling=true")

if [ -n "$dangling_images" ]; then
    echo "Removing dangling Docker images..."
    docker rmi $dangling_images
else
    echo "No dangling images to remove."
fi
echo

# Step9: Restore .env file
if [ -f "$backupEnvFilePath" ]; then
    mv "$backupEnvFilePath" "$envFilePath"
    echo "Original .env file restored."
else
    rm "$envFilePath"
    echo "Temporary .env file removed."
fi
echo

# Step10: Final user message
echo "All container images are created."
echo
read -p "Press any key to exit." anyKey
