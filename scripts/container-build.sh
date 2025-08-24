#!/bin/bash

# Todo List API Docker Build Script
# This script builds the Docker image for the Todo List API

set -e  # Exit on any error

# Configuration
IMAGE_NAME="todo-list-api"
IMAGE_TAG="${1:-latest}"
DOCKERFILE_PATH="../Dockerfile"

echo "🐳 Building Todo List API Docker Image..."
echo "Image: ${IMAGE_NAME}:${IMAGE_TAG}"
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
    -t "${IMAGE_NAME}:${IMAGE_TAG}" \
    -t "${IMAGE_NAME}:latest" \
    ../

# Check build result
if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Successfully built ${IMAGE_NAME}:${IMAGE_TAG}"
    echo ""
    echo "📋 Available images:"
    docker images | grep "$IMAGE_NAME"
    echo ""
    echo "🚀 To run the container, use:"
    echo "   ./scripts/container-run.sh"
    echo ""
    echo "💡 Or manually with:"
    echo "   docker run -d --name todo-list-api -p 3000:3000 \\"
    echo "     -e DATABASE_HOST=localhost \\"
    echo "     -e DATABASE_PORT=5432 \\"
    echo "     -e DATABASE_USERNAME=postgres \\"
    echo "     -e DATABASE_PASSWORD=password \\"
    echo "     -e DATABASE_NAME=todo_list_db \\"
    echo "     -e JWT_SECRET=your-jwt-secret \\"
    echo "     ${IMAGE_NAME}:${IMAGE_TAG}"
else
    echo "❌ Build failed!"
    exit 1
fi
