#!/bin/bash

echo "🚀 Deploying Portfolio App to K3s Cluster..."

# Create namespace
echo "📦 Creating namespace..."
kubectl apply -f namespace.yaml

# Deploy the application
echo "📋 Deploying application..."
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
kubectl get ingress -n portfolio

echo "✅ Deployment completed!"
echo ""
echo "🌐 Access your app:"
echo "   - NodePort: http://<worker-ip>:30080"
echo "   - Or check ingress status with: kubectl get ingress -n portfolio"
echo ""
echo "📋 Useful commands:"
echo "   - View logs: kubectl logs -f deployment/portfolio-app -n portfolio"
echo "   - Check pods: kubectl get pods -n portfolio"
echo "   - Delete deployment: kubectl delete namespace portfolio" 