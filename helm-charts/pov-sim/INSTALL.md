# Installation Guide - PoV-Sim Helm Chart

## Quick Installation

### 1. Ensure images are available

If using Minikube, build images in Minikube's Docker environment:

```bash
# Point to Minikube's Docker daemon
eval $(minikube docker-env)

# Build all images
cd airlines && docker build -t pov-sim-airlines:latest .
cd ../flights && docker build -t pov-sim-flights:latest .
cd ../frontend && docker build -t pov-sim-frontend:latest .
cd ..
```

### 2. Install the Helm chart

```bash
# Install with default values
helm install pov-sim ./helm-charts/pov-sim

# Or install with custom release name
helm install my-release ./helm-charts/pov-sim
```

### 3. Verify installation

```bash
# Check all resources
kubectl get all -n pov-project

# Watch pods starting up
kubectl get pods -n pov-project --watch

# Check pod logs if needed
kubectl logs -n pov-project deployment/pov-sim-airlines
kubectl logs -n pov-project deployment/pov-sim-flights
kubectl logs -n pov-project deployment/pov-sim-frontend
```

### 4. Access the application

#### Option A: LoadBalancer (default)
```bash
# Get the LoadBalancer IP (may take a minute)
kubectl get svc frontend -n pov-project

# For Minikube, use:
minikube service frontend -n pov-project
```

#### Option B: Port-Forward
```bash
# Forward frontend port
kubectl port-forward -n pov-project svc/frontend 3000:3000

# Visit http://localhost:3000
```

#### Option C: NodePort
If you want to use NodePort instead of LoadBalancer, create a custom values file:

```yaml
# custom-values.yaml
frontend:
  service:
    type: NodePort
```

Then install:
```bash
helm install pov-sim ./helm-charts/pov-sim -f custom-values.yaml

# Get the NodePort
export NODE_PORT=$(kubectl get svc frontend -n pov-project -o jsonpath='{.spec.ports[0].nodePort}')
export NODE_IP=$(minikube ip)
echo "Visit: http://$NODE_IP:$NODE_PORT"
```

## Advanced Configuration

### Custom Resource Limits

Create a `production-values.yaml`:

```yaml
airlines:
  replicaCount: 2
  resources:
    requests:
      memory: "512Mi"
      cpu: "500m"
    limits:
      memory: "1Gi"
      cpu: "1000m"

flights:
  replicaCount: 2
  resources:
    requests:
      memory: "256Mi"
      cpu: "250m"
    limits:
      memory: "512Mi"
      cpu: "500m"

frontend:
  replicaCount: 2
  resources:
    requests:
      memory: "256Mi"
      cpu: "250m"
    limits:
      memory: "512Mi"
      cpu: "500m"
```

Install with custom values:
```bash
helm install pov-sim ./helm-charts/pov-sim -f production-values.yaml
```

### Enable Ingress

Create an `ingress-values.yaml`:

```yaml
ingress:
  enabled: true
  className: nginx
  hosts:
    - host: pov-sim.local
      paths:
        - path: /
          pathType: Prefix
          service: frontend

frontend:
  service:
    type: ClusterIP  # Change from LoadBalancer when using Ingress
```

Install with Ingress:
```bash
helm install pov-sim ./helm-charts/pov-sim -f ingress-values.yaml

# Add to /etc/hosts
echo "$(minikube ip) pov-sim.local" | sudo tee -a /etc/hosts

# Visit http://pov-sim.local
```

### Disable Specific Services

To deploy only specific services:

```yaml
# Only airlines and flights
airlines:
  enabled: true
flights:
  enabled: true
frontend:
  enabled: false
```

## Upgrading

To upgrade an existing release:

```bash
# Upgrade with default values
helm upgrade pov-sim ./helm-charts/pov-sim

# Upgrade with custom values
helm upgrade pov-sim ./helm-charts/pov-sim -f custom-values.yaml

# Force pod recreation
helm upgrade pov-sim ./helm-charts/pov-sim --force
```

## Uninstalling

```bash
# Uninstall the release
helm uninstall pov-sim

# Delete the namespace (optional)
kubectl delete namespace pov-project
```

## Troubleshooting

### Pods in ImagePullBackOff

This usually means the images aren't available. For Minikube:
```bash
eval $(minikube docker-env)
# Rebuild images as shown in step 1
```

### Services not accessible

Check service endpoints:
```bash
kubectl get endpoints -n pov-project
```

Test internal connectivity:
```bash
kubectl run -it --rm debug --image=busybox --restart=Never -n pov-project -- sh
# Inside the pod:
wget -O- http://airlines:8080/actuator/health
wget -O- http://flights:5001/health
```

### View detailed pod information

```bash
kubectl describe pod <pod-name> -n pov-project
kubectl logs <pod-name> -n pov-project --tail=100 -f
```

## Validation Commands

```bash
# Lint the chart
helm lint ./helm-charts/pov-sim

# Dry-run installation
helm install pov-sim ./helm-charts/pov-sim --dry-run --debug

# Template rendering
helm template pov-sim ./helm-charts/pov-sim

# Check chart values
helm show values ./helm-charts/pov-sim
```
