#!/bin/bash

# Todo List API Docker Run Script
# This script runs the Docker container with environment parameters

set -e  # Exit on any error

# Configuration
IMAGE_NAME="todo-list-api"
IMAGE_TAG="${1:-latest}"
CONTAINER_NAME="todo-list-api"
PORT="${2:-3000}"

# Default environment variables (can be overridden)
DB_HOST="${DB_HOST:-172.22.0.2}"
DB_PORT="${DB_PORT:-5432}"
DB_USERNAME="${DB_USERNAME:-postgres}"
DB_PASSWORD="${DB_PASSWORD:-password}"
DB_DATABASE="${DB_DATABASE:-todo_list_db}"
JWT_SECRET="${JWT_SECRET:-your-super-secret-jwt-key-change-in-production}"
JWT_EXPIRES_IN="${JWT_EXPIRES_IN:-24h}"
NODE_ENV="${NODE_ENV:-production}"

echo "🚀 Running Todo List API Container..."
echo "Image: ${IMAGE_NAME}:${IMAGE_TAG}"
echo "Container: ${CONTAINER_NAME}"
echo "Port: ${PORT}"
echo ""

# Check if image exists
if ! docker image inspect "${IMAGE_NAME}:${IMAGE_TAG}" >/dev/null 2>&1; then
    echo "❌ Error: Docker image ${IMAGE_NAME}:${IMAGE_TAG} not found!"
    echo "Please build the image first using:"
    echo "   ./scripts/container-build.sh"
    exit 1
fi

# Stop and remove existing container if it exists
if docker ps -a --format "table {{.Names}}" | grep -q "^${CONTAINER_NAME}$"; then
    echo "🔄 Stopping existing container..."
    docker stop "${CONTAINER_NAME}" >/dev/null 2>&1 || true
    echo "🗑️  Removing existing container..."
    docker rm "${CONTAINER_NAME}" >/dev/null 2>&1 || true
fi

# Run the container
echo "🔧 Starting container with environment variables..."
echo "Database Host: ${DB_HOST}"
echo "Database Port: ${DB_PORT}"
echo "Database Name: ${DB_DATABASE}"
echo "Database User: ${DB_USERNAME}"
echo "JWT Expires In: ${JWT_EXPIRES_IN}"
echo "Node Environment: ${NODE_ENV}"
echo ""

docker run -d \
    --name "${CONTAINER_NAME}" \
    -p "${PORT}:3000" \
    -e DB_HOST="${DB_HOST}" \
    -e DB_PORT="${DB_PORT}" \
    -e DB_USERNAME="${DB_USERNAME}" \
    -e DB_PASSWORD="${DB_PASSWORD}" \
    -e DB_DATABASE="${DB_DATABASE}" \
    -e JWT_SECRET="${JWT_SECRET}" \
    -e JWT_EXPIRES_IN="${JWT_EXPIRES_IN}" \
    -e NODE_ENV="${NODE_ENV}" \
    --restart unless-stopped \
    "${IMAGE_NAME}:${IMAGE_TAG}"

# Check if container started successfully
if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Container started successfully!"
    echo ""
    echo "📋 Container status:"
    docker ps | grep "${CONTAINER_NAME}"
    echo ""
    echo "🔍 Container logs:"
    docker logs "${CONTAINER_NAME}"
    echo ""
    echo "🌐 API will be available at: http://localhost:${PORT}"
    echo ""
    echo "📝 Useful commands:"
    echo "   View logs: docker logs -f ${CONTAINER_NAME}"
    echo "   Stop container: docker stop ${CONTAINER_NAME}"
    echo "   Remove container: docker rm ${CONTAINER_NAME}"
    echo "   Shell access: docker exec -it ${CONTAINER_NAME} /bin/sh"
else
    echo "❌ Failed to start container!"
    exit 1
fi
