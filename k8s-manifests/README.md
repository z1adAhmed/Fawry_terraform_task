# Portfolio App Deployment

This directory contains Kubernetes manifests for deploying the React portfolio application to the K3s cluster.

## 🚀 Quick Deployment

### Option 1: Automated GitHub Actions (Recommended)
Push to the `pre-prod` branch and the GitHub Actions workflow will automatically:
1. Build the Docker image
2. Push to ECR
3. Deploy to K3s cluster

### Option 2: Manual Deployment
```bash
# Make scripts executable
chmod +x *.sh

# Build and deploy everything
./build-and-deploy.sh
```

## 📁 Files

- **namespace.yaml** - Creates the `portfolio` namespace
- **deployment.yaml** - Deploys the portfolio app (2 replicas)
- **service.yaml** - Exposes the app on NodePort 30080
- **ingress.yaml** - Ingress configuration for external access
- **deploy.sh** - Simple deployment script
- **push-to-ecr.sh** - Push image to ECR only
- **build-and-deploy.sh** - Complete build and deployment script

## 🌐 Access Points

- **NodePort**: `http://34.245.1.110:30080`
- **ECR Repository**: `600865703207.dkr.ecr.eu-west-1.amazonaws.com/pre-prod-webapp`

## 📋 Useful Commands

```bash
# Check deployment status
kubectl get pods -n portfolio
kubectl get services -n portfolio
kubectl get ingress -n portfolio

# View logs
kubectl logs -f deployment/portfolio-app -n portfolio

# Delete deployment
kubectl delete namespace portfolio

# Scale deployment
kubectl scale deployment portfolio-app --replicas=3 -n portfolio
```

## 🔧 Configuration

The deployment uses:
- **2 replicas** for high availability
- **NodePort service** on port 30080
- **Resource limits**: 128Mi memory, 100m CPU
- **Health checks** for liveness and readiness

## 🚨 Troubleshooting

If the deployment fails:
1. Check if the ECR image exists: `aws ecr describe-images --repository-name pre-prod-webapp`
2. Verify K3s cluster is running: `kubectl get nodes`
3. Check pod logs: `kubectl logs -f deployment/portfolio-app -n portfolio` 