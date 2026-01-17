# PoV-Sim Helm Chart

A Helm chart for deploying the PoV Flight Simulator application to Kubernetes.

## Overview

This chart deploys the complete PoV Flight Simulator application stack:
- **Airlines Service** - Java Spring Boot backend (port 8080)
- **Flights Service** - Python Flask backend (port 5001)
- **Frontend** - React web application (port 3000)

## Prerequisites

- Kubernetes 1.19+
- Helm 3.0+
- kubectl configured to communicate with your cluster

## Installation

### Quick Start

Install the chart with the release name `pov-sim`:

```bash
helm install pov-sim ./helm-charts/pov-sim
```

### Install with Custom Values

Create a custom values file:

```bash
helm install pov-sim ./helm-charts/pov-sim -f custom-values.yaml
```

### Install in a Specific Namespace

```bash
helm install pov-sim ./helm-charts/pov-sim --namespace pov-project --create-namespace
```

## Configuration

The following table lists the configurable parameters and their default values:

### Global Settings

| Parameter | Description | Default |
|-----------|-------------|---------|
| `global.namespace` | Kubernetes namespace | `pov-project` |

### Airlines Service

| Parameter | Description | Default |
|-----------|-------------|---------|
| `airlines.enabled` | Enable airlines service | `true` |
| `airlines.replicaCount` | Number of replicas | `1` |
| `airlines.image.repository` | Image repository | `pov-sim-airlines` |
| `airlines.image.tag` | Image tag | `latest` |
| `airlines.service.type` | Service type | `ClusterIP` |
| `airlines.service.port` | Service port | `8080` |

### Flights Service

| Parameter | Description | Default |
|-----------|-------------|---------|
| `flights.enabled` | Enable flights service | `true` |
| `flights.replicaCount` | Number of replicas | `1` |
| `flights.image.repository` | Image repository | `pov-sim-flights` |
| `flights.image.tag` | Image tag | `latest` |
| `flights.service.type` | Service type | `ClusterIP` |
| `flights.service.port` | Service port | `5001` |

### Frontend Service

| Parameter | Description | Default |
|-----------|-------------|---------|
| `frontend.enabled` | Enable frontend service | `true` |
| `frontend.replicaCount` | Number of replicas | `1` |
| `frontend.image.repository` | Image repository | `pov-sim-frontend` |
| `frontend.image.tag` | Image tag | `latest` |
| `frontend.service.type` | Service type | `LoadBalancer` |
| `frontend.service.port` | Service port | `3000` |

### Ingress

| Parameter | Description | Default |
|-----------|-------------|---------|
| `ingress.enabled` | Enable ingress | `false` |
| `ingress.className` | Ingress class name | `nginx` |
| `ingress.hosts` | Ingress hosts configuration | See values.yaml |

## Usage

### Accessing the Application

After installation, follow the instructions in the NOTES output to access the application.

For LoadBalancer service type:
```bash
kubectl get svc frontend -n pov-project
```

For port-forwarding:
```bash
kubectl port-forward -n pov-project svc/frontend 3000:3000
```

Then visit `http://localhost:3000`

### Monitoring Deployments

Check pod status:
```bash
kubectl get pods -n pov-project
```

View logs:
```bash
kubectl logs -n pov-project deployment/pov-sim-airlines
kubectl logs -n pov-project deployment/pov-sim-flights
kubectl logs -n pov-project deployment/pov-sim-frontend
```

## Upgrading

To upgrade the release:

```bash
helm upgrade pov-sim ./helm-charts/pov-sim
```

With custom values:
```bash
helm upgrade pov-sim ./helm-charts/pov-sim -f custom-values.yaml
```

## Uninstalling

To uninstall/delete the `pov-sim` deployment:

```bash
helm uninstall pov-sim
```

To also delete the namespace:
```bash
kubectl delete namespace pov-project
```

## Examples

### Enable Ingress

Create a custom values file `ingress-values.yaml`:

```yaml
ingress:
  enabled: true
  className: nginx
  hosts:
    - host: pov-sim.example.com
      paths:
        - path: /
          pathType: Prefix
          service: frontend
```

Install with ingress:
```bash
helm install pov-sim ./helm-charts/pov-sim -f ingress-values.yaml
```

### Scale Services

Scale airlines service to 3 replicas:
```yaml
airlines:
  replicaCount: 3
```

### Custom Resource Limits

```yaml
airlines:
  resources:
    requests:
      memory: "512Mi"
      cpu: "500m"
    limits:
      memory: "1Gi"
      cpu: "1000m"
```

## Troubleshooting

### Pods not starting

Check events:
```bash
kubectl describe pod <pod-name> -n pov-project
```

### Image pull errors

Ensure images are built and available:
```bash
# Build images locally for Minikube
eval $(minikube docker-env)
cd airlines && docker build -t pov-sim-airlines:latest .
cd ../flights && docker build -t pov-sim-flights:latest .
cd ../frontend && docker build -t pov-sim-frontend:latest .
```

### Service connectivity issues

Check services:
```bash
kubectl get svc -n pov-project
```

Test service connectivity:
```bash
kubectl run -it --rm debug --image=busybox --restart=Never -n pov-project -- wget -O- http://airlines:8080/actuator/health
```

## Development

### Validating Chart

Lint the chart:
```bash
helm lint ./helm-charts/pov-sim
```

Dry run installation:
```bash
helm install pov-sim ./helm-charts/pov-sim --dry-run --debug
```

Render templates:
```bash
helm template pov-sim ./helm-charts/pov-sim
```

## License

This chart is part of the PoV Flight Simulator project.
