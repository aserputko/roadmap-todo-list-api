#!/bin/bash

# Todo List API Docker Run Script
# This script runs the Docker container with environment parameters

set -e  # Exit on any error

# Configuration
IMAGE_ORGANIZATION="aserputko"
IMAGE_NAME="roadmap-todo-list-api"
IMAGE_TAG="${1:-latest}"
CONTAINER_NAME="roadmap-todo-list-api"
PORT="${2:-3000}"

# Default environment variables (can be overridden)
# DATABASE_HOST="${DATABASE_HOST}"
# DATABASE_PORT="${DATABASE_PORT}"
# DATABASE_USER="${DATABASE_USER}"
# DATABASE_PASSWORD="${DATABASE_PASSWORD}"
# DATABASE_NAME="${DATABASE_NAME}"
# JWT_SECRET="${JWT_SECRET}"
# JWT_EXPIRES_IN="${JWT_EXPIRES_IN}"
# NODE_ENV="${NODE_ENV}"

DATABASE_HOST="aserputko-database-1.c43060suq64k.us-east-1.rds.amazonaws.com"
DATABASE_PORT="5432"
DATABASE_USER="postgres"
DATABASE_PASSWORD="Aprel1988!"
DATABASE_NAME="postgres"
JWT_SECRET="your-super-secret-jwt-key-here"
JWT_EXPIRES_IN="24h"
NODE_ENV="production"

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
