#!/bin/bash

# ECR Repository details
ECR_REPO="600865703207.dkr.ecr.eu-west-1.amazonaws.com/pre-prod-webapp"
AWS_REGION="eu-west-1"
IMAGE_TAG="latest"

echo "🚀 Pushing Portfolio App to ECR..."

# Login to ECR
echo "🔐 Logging in to ECR..."
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_REPO

# Tag the image for ECR
echo "🏷️ Tagging image for ECR..."
docker tag portfolio-app:latest $ECR_REPO:$IMAGE_TAG

# Push to ECR
echo "📤 Pushing image to ECR..."
docker push $ECR_REPO:$IMAGE_TAG

echo "✅ Image pushed successfully to ECR!"
echo "📦 ECR Repository: $ECR_REPO"
echo "🏷️ Image Tag: $IMAGE_TAG" 