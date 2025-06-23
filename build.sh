#!/bin/bash

BUILD_DIR=build

RUN_MAKE=true
RUN_MAIN=false
RUN_TESTS=false
CLEAN_BUILD=false
GENERATE_MAKEFILES=false

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
NC='\033[0m'

CURRENT_ACTION=""

# Executes a command, prints its output, and returns the exit code.
function execute() {
    local temp_log
    temp_log=$(mktemp)

    "$@" &> "$temp_log"
    local exit_code=$?

    cat "$temp_log"

    rm -f "$temp_log"

    return "$exit_code"
}

# Prints a message indicating the start of an action.
function start_action() {
    CURRENT_ACTION="$1"
    printf "  ${YELLOW} ${NC} %s..." "$CURRENT_ACTION"
}

# Prints a message indicating the end of an action, along with its success or failure.
function end_action() {
    local exit_code=$1
    local output=$2

    if [ "$exit_code" -ne 0 ]; then
        printf "\r  ${RED} ${NC} %s [FAILED]\n" "$CURRENT_ACTION"

        if [ -n "$output" ]; then
            echo -e "$output"
        fi

        exit 1
    else
        printf "\r  ${GREEN} ${NC} %s [OK]\n" "$CURRENT_ACTION"
    fi
}

# Parse flags
while getopts "cgmrt" flag; do
    case $flag in
        b) RUN_MAKE=true ;;
        c) CLEAN_BUILD=true ;;
        g) GENERATE_MAKEFILES=true ;;
        r) RUN_MAIN=true ;;
        t) RUN_TESTS=true ;;
        *)
            echo "Usage: $0 [-cgmrt] [ARGS...]"
            echo "  -c: Clean build directory"
            echo "  -g: Generate makefiles"
            echo "  -m: Run make"
            echo "  -r: Run main"
            echo "  -t: Run tests"
            echo "  ARGS: Arguments to pass to the program"
            exit 1
            ;;
    esac
done

shift $((OPTIND - 1))

ADDITIONAL_ARGS="$@"

if [ "$CLEAN_BUILD" = true ]; then
    start_action "Cleaning build directory"

    output=$(execute rm -rf $BUILD_DIR)
    exit_code=$?

    GENERATE_MAKEFILES=true
    end_action $exit_code "$output"
fi

mkdir -p $BUILD_DIR

cd $BUILD_DIR || exit

if [ "$GENERATE_MAKEFILES" = true ]; then
    start_action "Generating makefiles"

    output=$(execute cmake .. -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -Wno-dev)
    exit_code=$?

    RUN_MAKE=true
    end_action $exit_code "$output"
fi

if [ "$RUN_MAKE" = true ]; then
    start_action "Building project"

    output=$(execute make -j$(nproc))
    exit_code=$?

    end_action $exit_code "$output"
fi

if [ "$RUN_TESTS" = true ]; then
    start_action "Running tests"

    output=$(execute ctest --output-on-failure)
    exit_code=$?

    end_action $exit_code "$output"
fi

if [ "$RUN_MAIN" = true ]; then
    printf "  ${CYAN} ${NC} Running main...\n"
    ./out $ADDITIONAL_ARGS
fi
