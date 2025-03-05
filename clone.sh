#!/bin/bash

INCLUDE_TESTS=false
INCLUDE_RESOURCES=false
INIT_GIT=false

function print_usage {
    echo "Usage: $0 [-g] [-r] [-t] <repo_name> [project_name]" 
    echo "  -g: Initialize git repository"
    echo "  -r: Initialize resource directory"
    echo "  -t: Include testing framework"
    exit 1
}

while getopts "rtg" flag; do
    case $flag in
        g) INIT_GIT=true ;;
        r) INCLUDE_RESOURCES=true ;;
        t) INCLUDE_TESTS=true ;;
        *) print_usage ;;
    esac
done

shift $((OPTIND - 1))

# Ensure REPOSITORY_NAME is provided
if [[ -z "$1" ]]; then
    print_usage
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

mkdir "$REPOSITORY_NAME" || exit 1

cd "$REPOSITORY_NAME" || exit 1

cp "$TEMPLATE_REPO/CMakeLists.txt" "."
cp "$TEMPLATE_REPO/build.sh" "."

cp -r "$TEMPLATE_REPO/src/" "."

if [ "$INCLUDE_RESOURCES" = true ]; then
    echo "Including resources directory"
    mkdir res
    echo "" >> CMakeLists.txt
    cat "$TEMPLATE_REPO/include_resources.cmake" >> CMakeLists.txt
fi

if [ "$INCLUDE_TESTS" = true ]; then
    echo "Including testing framework"
    cp -r "$TEMPLATE_REPO/test/" "."
    sed -i "s/Template/$PROJECT_NAME/g" test/CMakeLists.txt
    echo "" >> CMakeLists.txt
    cat "$TEMPLATE_REPO/test/include_tests.cmake" >> CMakeLists.txt
fi

sed -i "s/Template/$PROJECT_NAME/g" CMakeLists.txt
sed -i "s/Template/$PROJECT_NAME/g" build.sh

if [ "$INIT_GIT" = true ]; then
    echo "Initializing git repository"
    git init
    cp "$TEMPLATE_REPO/.gitignore" "."
fi

echo "Done! New repository initialized in $REPOSITORY_NAME."
