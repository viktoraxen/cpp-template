#!/bin/bash

# Check if the new repository name is provided
if [ "$#" -lt 1 ]; then
    echo "Usage: $0 <repo_name> [project_name]" 
    exit 1
fi

# Arguments
REPOSITORY_NAME=$1

PROJECT_NAME=${2:-$(echo "${REPOSITORY_NAME^}")}

echo "Creating template C++ project"
echo "Project name:    $PROJECT_NAME"
echo "Repository name: $REPOSITORY_NAME"

# Get the absolute path of the template repository
TEMPLATE_REPO=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Clone the template repository to the new location
git clone "$TEMPLATE_REPO" "$REPOSITORY_NAME" || exit 1

# Change to the new repository directory
cd "$REPOSITORY_NAME" || exit 1

# Replace the project name in the CMakeLists.txt file
sed -i "s/Template/$PROJECT_NAME/g" CMakeLists.txt
sed -i "s/Template/$PROJECT_NAME/g" test/CMakeLists.txt
sed -i "s/Template/$PROJECT_NAME/g" build.sh

rm clone.sh

rm -rf .git
git init

echo "Done! New repository initialized in $REPOSITORY_NAME."
