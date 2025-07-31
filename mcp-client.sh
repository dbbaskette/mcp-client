#!/bin/bash

# MCP Client - A Spring AI MCP Client Tool for Testing MCP Servers
# Usage: ./mcp-client [options]

set -e

# Default values
PROFILE="stdio"
JAR_NAME="mcp-starter-webflux-client-0.0.1-SNAPSHOT.jar"
VERBOSE=false

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print usage
usage() {
    echo "MCP Client - An interactive tool for testing MCP servers."
    echo ""
    echo "USAGE:"
    echo "    ./mcp-client.sh [OPTIONS]"
    echo ""
    echo "OPTIONS:"
    echo "    -p, --profile PROFILE       Transport profile: stdio, sse, streamable (default: stdio)"
    echo "    -h, --help                  Show this help message"
    echo "    -v, --verbose               Enable verbose output (sets logging to DEBUG)"

}

# Function to log messages
log() {
    if [[ "$VERBOSE" == "true" ]]; then
        echo -e "${BLUE}[INFO]${NC} $1"
    fi
}

error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -p|--profile)
            PROFILE="$2"
            shift 2
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        -v|--verbose)
            VERBOSE=true
            shift
            ;;
        *)
            error "Unknown option: $1"
            usage
            exit 1
            ;;
    esac
done

# Validate profile
case $PROFILE in
    stdio|sse|streamable)
        ;;
    *)
        error "Invalid profile: $PROFILE. Must be one of: stdio, sse, streamable"
        exit 1
        ;;
esac

# Build the application if needed
build_if_needed() {
    local jar_path="target/$JAR_NAME"
    
    if [[ ! -f "$jar_path" ]]; then
        echo "JAR not found. Building application..."
        if ! ./mvnw clean install; then
            error "Build failed."
            exit 1
        fi
        success "Build completed successfully"
    else
        log "Using existing JAR: $jar_path"
    fi
}

echo "🤖 MCP Client - Direct MCP Server Testing"
echo

build_if_needed

jar_path="target/$JAR_NAME"
java_props="-Dspring.profiles.active=$PROFILE"

if [[ "$VERBOSE" == "true" ]]; then
    java_props="$java_props -Dlogging.level.org.springframework.ai.mcp=DEBUG"
fi

echo "Starting Interactive MCP Client..."
echo "Profile: $PROFILE"
echo

# Run the application
log "Executing: java $java_props -jar $jar_path"

java $java_props -jar "$jar_path"