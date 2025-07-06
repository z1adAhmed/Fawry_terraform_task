#!/bin/bash

# Configuration
ECR_REPO="600865703207.dkr.ecr.eu-west-1.amazonaws.com/pre-prod-webapp"
AWS_REGION="eu-west-1"
IMAGE_TAG="latest"
PORTFOLIO_DIR="/media/mythicalcell/6E547ABF547A899B/portfolio"

echo "🚀 Building and Deploying Portfolio App..."

# Step 1: Build Docker image
echo "🔨 Building Docker image..."
cd $PORTFOLIO_DIR
docker build -t portfolio-app:latest .

# Step 2: Login to ECR
echo "🔐 Logging in to ECR..."
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_REPO

# Step 3: Tag and push to ECR
echo "🏷️ Tagging image for ECR..."
docker tag portfolio-app:latest $ECR_REPO:$IMAGE_TAG

echo "📤 Pushing image to ECR..."
docker push $ECR_REPO:$IMAGE_TAG

# Step 4: Deploy to K3s
echo "📋 Deploying to K3s cluster..."
cd /media/mythicalcell/6E547ABF547A899B/Work/Courses/Fawry_internship/Terraform_task/terraform-landing-zone/k8s-manifests

# Create namespace
kubectl apply -f namespace.yaml

# Deploy the application
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
kubectl apply -f ingress.yaml

# Wait for deployment to be ready
echo "⏳ Waiting for deployment to be ready..."
kubectl wait --for=condition=available --timeout=300s deployment/portfolio-app -n portfolio

# Show deployment status
echo "📊 Deployment status:"
kubectl get pods -n portfolio
kubectl get services -n portfolio

echo "✅ Build and deployment completed!"
echo ""
echo "🌐 Access your app:"
echo "   - NodePort: http://34.245.1.110:30080"
echo "   - Or check ingress status with: kubectl get ingress -n portfolio"
echo ""
echo "📋 Useful commands:"
echo "   - View logs: kubectl logs -f deployment/portfolio-app -n portfolio"
echo "   - Check pods: kubectl get pods -n portfolio"
echo "   - Delete deployment: kubectl delete namespace portfolio" 