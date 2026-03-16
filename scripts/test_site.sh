#!/bin/bash

# Hugo Site Test Suite
# Starts Hugo server, tests all pages and assets, then stops the server

set -u  # Exit on undefined variables
set -o pipefail  # Exit on pipe failures

# Configuration
TEST_PORT=13199
HUGO_CMD="${HUGO:-hugo}"
MAX_WAIT=30
WAIT_INTERVAL=1
BASE_PATH="/"

# Get the project root directory
SCRIPT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
CONFIG_FILE="${SCRIPT_DIR}/config.toml"

# Extract baseURL path from config.toml
# baseURL format: "https://domain.com/path/" -> extract "/path/"
if [ -f "$CONFIG_FILE" ]; then
    # Extract baseURL value (may include quotes)
    BASE_URL_RAW=$(grep -E '^baseURL\s*=' "$CONFIG_FILE" | awk '{print $3}')

    # Remove surrounding quotes if present (strip both double and single quotes)
    # Use tr to remove quotes, or sed with a more permissive pattern
    BASE_URL_RAW=$(echo "$BASE_URL_RAW" | sed 's/^"//' | sed 's/"$//' | sed "s/^'//" | sed "s/'$//")

    # Extract path portion (everything after the domain)
    # Pattern: https://domain.com/path/ -> extract /path/
    BASE_PATH=$(echo "$BASE_URL_RAW" | sed -E 's|^https?://[^/]+(/.*)$|\1|')

    # If no path found (root domain or pattern didn't match), default to /
    if [ -z "$BASE_PATH" ] || [ "$BASE_PATH" = "$BASE_URL_RAW" ]; then
        BASE_PATH="/"
    fi

    # Ensure path ends with / if it doesn't already (and isn't just "/")
    if [ "$BASE_PATH" != "/" ] && [ "${BASE_PATH: -1}" != "/" ]; then
        BASE_PATH="${BASE_PATH}/"
    fi
fi

# Construct BASE_URL with the path from config
BASE_URL="http://localhost:${TEST_PORT}${BASE_PATH}"

# Colors for output (optional, will work without them)
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Track errors
ERRORS=0

# Cleanup function
cleanup() {
    if [ -n "$HUGO_PID" ]; then
        echo "Stopping Hugo server (PID: $HUGO_PID)..."
        kill "$HUGO_PID" 2>/dev/null || true
        wait "$HUGO_PID" 2>/dev/null || true
    fi
}

# Set trap to cleanup on exit
trap cleanup EXIT

# Function to check if server is ready
wait_for_server() {
    local attempts=0
    # Remove trailing slash to avoid double slashes
    local check_url="${BASE_URL%/}"
    while [ $attempts -lt $MAX_WAIT ]; do
        if curl -s -o /dev/null -w "%{http_code}" "${check_url}/" | grep -q "200"; then
            return 0
        fi
        sleep $WAIT_INTERVAL
        attempts=$((attempts + 1))
    done
    return 1
}

# Function to test a URL
test_url() {
    local url=$1
    local name=$2
    local status_code
    # Remove leading slash from url if BASE_PATH already provides one
    # BASE_URL already ends with /, so we need to avoid double slashes
    local test_url_path="${url#/}"  # Remove leading slash
    local full_url="${BASE_URL%/}/${test_url_path}"  # Remove trailing slash from BASE_URL, then add /

    echo "Testing: ${full_url}"
    status_code=$(curl -s -o /dev/null -w "%{http_code}" "${full_url}" || echo "000")

    if [ "$status_code" != "200" ]; then
        echo -e "${RED}ERROR:${NC} ${name} (${url}) returned status code ${status_code}"
        ERRORS=$((ERRORS + 1))
        return 1
    fi
    return 0
}

# Start Hugo server in background
echo "Starting Hugo server on port ${TEST_PORT}..."
echo "Using base path: ${BASE_PATH}"
cd "$SCRIPT_DIR" || exit 1
$HUGO_CMD server --port ${TEST_PORT} --bind 127.0.0.1 > /dev/null 2>&1 &
HUGO_PID=$!

# Wait for server to be ready
echo "Waiting for server to start..."
if ! wait_for_server; then
    echo -e "${RED}ERROR:${NC} Hugo server failed to start within ${MAX_WAIT} seconds"
    exit 1
fi

echo "Server is ready. Running tests..."

# Test pages
test_url "/" "Home page"
test_url "/our_tech_story/" "Our Tech Story"
test_url "/using_the_api/" "Using the API"
test_url "/our_customers/" "Our Customers"
test_url "/meet_the_team/" "Meet the Team"
test_url "/alice_lee/" "Alice Lee"
test_url "/bob_johnson/" "Bob Johnson"
test_url "/jane_smith/" "Jane Smith"
test_url "/john_doe/" "John Doe"

# Test static assets
test_url "/assets/css/style.css" "CSS file"
test_url "/assets/js/main.js" "JavaScript file"

# Report results
if [ $ERRORS -eq 0 ]; then
    echo -e "${GREEN}All tests passed!${NC}"
    exit 0
else
    echo -e "${RED}${ERRORS} test(s) failed${NC}"
    exit 1
fi
