#!/bin/bash
set -e

# -----------------------------
# 1️⃣ Create namespaces
# -----------------------------
echo "Creating namespaces..."
kubectl create namespace argocd || echo "Namespace argocd exists"
kubectl create namespace dev || echo "Namespace dev exists"

# -----------------------------
# 2️⃣ Install ArgoCD in argocd namespace
# -----------------------------
echo "Installing ArgoCD..."
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Wait until ArgoCD pods are ready
echo "Waiting for ArgoCD pods to be ready..."
kubectl wait --for=condition=Ready pod -l app.kubernetes.io/name=argocd-server -n argocd --timeout=120s

# -----------------------------
# 3️⃣ Expose ArgoCD Server (port-forward)
# -----------------------------
echo "Port-forward ArgoCD server..."
kubectl port-forward --address 0.0.0.0 svc/argocd-server -n argocd 8080:443 &
echo "ArgoCD UI should be available at https://localhost:8080"

# -----------------------------
# 4️⃣ Deploy the dev app (v1)
# -----------------------------
echo "Deploying dev app..."
kubectl apply -n dev -f - <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: wil-playground
spec:
  replicas: 1
  selector:
    matchLabels:
      app: wil-playground
  template:
    metadata:
      labels:
        app: wil-playground
    spec:
      containers:
      - name: wil-playground
        image: wil42/playground:v1
        ports:
        - containerPort: 8888
---
apiVersion: v1
kind: Service
metadata:
  name: wil-playground-service
spec:
  selector:
    app: wil-playground
  ports:
    - protocol: TCP
      port: 8888
      targetPort: 8888
  type: NodePort
EOF

# Wait until pod is ready
echo "Waiting for dev app pod..."
kubectl wait --for=condition=Ready pod -l app=wil-playground -n dev --timeout=60s

# -----------------------------
# 5️⃣ Port-forward dev app
# -----------------------------
echo "Port-forward dev app to host..."
kubectl port-forward --address 0.0.0.0 svc/wil-playground-service -n dev 8888:8888 &
echo "Dev app should be reachable at http://localhost:8888"

echo "✅ Setup complete!"

