#!/bin/bash

# Todo List API Docker Publish Script
# This script pushes the Docker image to Docker Hub

set -e  # Exit on any error

# Configuration
IMAGE_ORGANIZATION="aserputko"
IMAGE_NAME="roadmap-todo-list-api"
IMAGE_TAG="${1:-latest}"

echo "🚀 Publishing Todo List API Docker Image to Docker Hub..."
echo "Image: ${IMAGE_ORGANIZATION}/${IMAGE_NAME}:${IMAGE_TAG}"
echo ""

# Check if image exists locally
if ! docker image inspect "${IMAGE_ORGANIZATION}/${IMAGE_NAME}:${IMAGE_TAG}" >/dev/null 2>&1; then
    echo "❌ Error: Docker image ${IMAGE_ORGANIZATION}/${IMAGE_NAME}:${IMAGE_TAG} not found locally!"
    echo "Please build the image first using:"
    echo "   ./scripts/container-build.sh"
    exit 1
fi

# Check if user is logged in to Docker Hub
if ! docker info | grep -q "Username"; then
    echo "❌ Error: You are not logged in to Docker Hub!"
    echo "Please login first using:"
    echo "   docker login"
    exit 1
fi

# Push the image to Docker Hub
echo "📤 Pushing image to Docker Hub..."
docker push "${IMAGE_ORGANIZATION}/${IMAGE_NAME}:${IMAGE_TAG}"

# Check push result
if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Successfully pushed ${IMAGE_ORGANIZATION}/${IMAGE_NAME}:${IMAGE_TAG} to Docker Hub!"
    echo ""
    
    # If this is not the latest tag, also push as latest
    if [ "$IMAGE_TAG" != "latest" ]; then
        echo "📤 Pushing as latest tag..."
        docker tag "${IMAGE_ORGANIZATION}/${IMAGE_NAME}:${IMAGE_TAG}" "${IMAGE_ORGANIZATION}/${IMAGE_NAME}:latest"
        docker push "${IMAGE_ORGANIZATION}/${IMAGE_NAME}:latest"
        
        if [ $? -eq 0 ]; then
            echo "✅ Successfully pushed ${IMAGE_ORGANIZATION}/${IMAGE_NAME}:latest to Docker Hub!"
        else
            echo "❌ Failed to push latest tag!"
            exit 1
        fi
    fi
else
    echo "❌ Push failed!"
    exit 1
fi
