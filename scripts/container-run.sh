#!/bin/bash

# Todo List API Docker Run Script
# This script runs the Docker container with environment parameters

set -e  # Exit on any error

# Source environment variables if .env file exists
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ -f "$SCRIPT_DIR/../.env" ]]; then
    source "$SCRIPT_DIR/../.env"
else
    echo "⚠️  Warning: .env file not found, using default values"
    # Set default values
    IMAGE_ORGANIZATION="${IMAGE_ORGANIZATION}"
    IMAGE_NAME="${IMAGE_NAME}"
    IMAGE_TAG="${IMAGE_TAG}"
    
    # Check if required environment variables are set
    if [[ -z "${DATABASE_HOST}" || -z "${DATABASE_PASSWORD}" || -z "${JWT_SECRET}" ]]; then
        echo "❌ Error: Required environment variables not set!"
        echo "Please create a .env file with the following variables:"
        echo "   DATABASE_HOST, DATABASE_PASSWORD, JWT_SECRET"
        echo "Or set them in your shell environment"
        exit 1
    fi
fi

# Configuration
CONTAINER_NAME=${IMAGE_NAME}
PORT="${2:-3000}"

# Override IMAGE_TAG with command line argument if provided
IMAGE_TAG="${1:-$IMAGE_TAG}"

echo "🚀 Running Todo List API Container..."
echo "Image: ${IMAGE_ORGANIZATION}/${IMAGE_NAME}:${IMAGE_TAG}"
echo "Container: ${CONTAINER_NAME}"
echo "Port: ${PORT}"
echo ""

# Check if image exists
if ! docker image inspect "${IMAGE_ORGANIZATION}/${IMAGE_NAME}:${IMAGE_TAG}" >/dev/null 2>&1; then
    echo "❌ Error: Docker image ${IMAGE_ORGANIZATION}/${IMAGE_NAME}:${IMAGE_TAG} not found!"
    echo "Please build the image first using:"
    echo "   ./scripts/container-build.sh"
    exit 1
fi

# Stop and remove existing container if it exists
if docker ps -a --format "table {{.Names}}" | grep -q "^${IMAGE_ORGANIZATION}_${CONTAINER_NAME}$"; then
    echo "🔄 Stopping existing container..."
    docker stop "${IMAGE_ORGANIZATION}_${CONTAINER_NAME}" >/dev/null 2>&1 || true
    echo "🗑️  Removing existing container..."
    docker rm "${IMAGE_ORGANIZATION}_${CONTAINER_NAME}" >/dev/null 2>&1 || true
fi

# Run the container
echo "🔧 Starting container with environment variables..."
echo "Database Host: ${DATABASE_HOST}"
echo "Database Port: ${DATABASE_PORT}"
echo "Database Name: ${DATABASE_NAME}"
echo "Database User: ${DATABASE_USER}"
echo "JWT Expires In: ${JWT_EXPIRES_IN}"
echo "Node Environment: ${NODE_ENV}"
echo ""

docker run -d \
    --name "${IMAGE_ORGANIZATION}_${CONTAINER_NAME}" \
    -p "${PORT}:3000" \
    -e DATABASE_HOST="${DATABASE_HOST}" \
    -e DATABASE_PORT="${DATABASE_PORT}" \
    -e DATABASE_USER="${DATABASE_USER}" \
    -e DATABASE_PASSWORD="${DATABASE_PASSWORD}" \
    -e DATABASE_NAME="${DATABASE_NAME}" \
    -e JWT_SECRET="${JWT_SECRET}" \
    -e JWT_EXPIRES_IN="${JWT_EXPIRES_IN}" \
    -e NODE_TLS_REJECT_UNAUTHORIZED=0 \
    -e NODE_ENV="${NODE_ENV}" \
    --restart unless-stopped \
    "${IMAGE_ORGANIZATION}/${IMAGE_NAME}:${IMAGE_TAG}"

# Check if container started successfully
if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Container started successfully!"
    echo ""
else
    echo "❌ Failed to start container!"
    exit 1
fi
