#!/bin/bash

# Check if the new repository name is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <new_repo_name>"
    exit 1
fi

# Arguments
NEW_REPO_NAME=$1

# Get the absolute path of the template repository
TEMPLATE_REPO=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Clone the template repository to the new location
echo "Cloning $TEMPLATE_REPO into $NEW_REPO_NAME..."
git clone "$TEMPLATE_REPO" "$NEW_REPO_NAME" || exit 1

# Change to the new repository directory
cd "$NEW_REPO_NAME" || exit 1

rm clone.sh

echo "Reinitializing Git repository..."
rm -rf .git
git init

echo "Done! New repository initialized in $NEW_REPO_NAME."
