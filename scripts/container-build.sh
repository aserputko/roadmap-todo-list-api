#!/bin/bash

# Todo List API Docker Build Script
# This script builds the Docker image for the Todo List API

set -e  # Exit on any error

# Source environment variables
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ -f "$SCRIPT_DIR/../.env" ]]; then
    source "$SCRIPT_DIR/../.env"
else
    echo "❌ Error: docker.env file not found!"
    echo "Please create docker.env file based on docker.env.example"
    exit 1
fi

# Override IMAGE_TAG with command line argument if provided
IMAGE_TAG="${1:-$IMAGE_TAG}"

# Dynamically determine Dockerfile path based on current directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ "$PWD" == "$SCRIPT_DIR" ]]; then
    # Running from scripts folder
    DOCKERFILE_PATH="../Dockerfile"
    BUILD_CONTEXT="../"
else
    # Running from root folder
    DOCKERFILE_PATH="./Dockerfile"
    BUILD_CONTEXT="./"
fi

echo "🐳 Building Todo List API Docker Image..."
echo "Image: ${IMAGE_ORGANIZATION}/${IMAGE_NAME}:${IMAGE_TAG}"
echo "Dockerfile: ${DOCKERFILE_PATH}"
echo ""

# Check if Dockerfile exists
if [ ! -f "$DOCKERFILE_PATH" ]; then
    echo "❌ Error: Dockerfile not found at $DOCKERFILE_PATH"
    echo "Make sure you're running this script from the scripts/ directory"
    exit 1
fi

# Build the Docker image
echo "🔨 Building image..."
docker build \
    -f "$DOCKERFILE_PATH" \
    -t "${IMAGE_ORGANIZATION}/${IMAGE_NAME}:${IMAGE_TAG}" \
    -t "${IMAGE_ORGANIZATION}/${IMAGE_NAME}:latest" \
    "$BUILD_CONTEXT"

# Check build result
if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Successfully built ${IMAGE_ORGANIZATION}/${IMAGE_NAME}:${IMAGE_TAG}"
    echo ""
else
    echo "❌ Build failed!"
    exit 1
fi
