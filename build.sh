#!/bin/bash

BUILD_DIR=build

RUN_MAIN=false
RUN_TESTS=false
CLEAN_BUILD=false

function print_title {
    printf "\n=== $1 ===\n\n"
}

# Parse flags
while getopts "rtc" flag; do
    case $flag in
        c) CLEAN_BUILD=true ;;
        r) RUN_MAIN=true ;;
        t) RUN_TESTS=true ;;
        *)
            echo "Usage: $0 [-r] [-t] [-c]"
            echo "  -r: Run main"
            echo "  -t: Run tests"
            echo "  -c: Clean build directory"
            exit 1
            ;;
    esac
done

if [ "$CLEAN_BUILD" = true ]; then
    echo "Cleaning build directory"
    rm -rf $BUILD_DIR
fi

mkdir -p $BUILD_DIR

cd $BUILD_DIR

cmake -S ..
make

if [ "$RUN_TESTS" = true ]; then
    print_title "Running tests"
    ctest
fi

if [ "$RUN_MAIN" = true ]; then
    print_title "Running main"
    ./Template
fi
