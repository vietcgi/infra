#!/bin/bash
set -euo pipefail

echo "📦 Installing ArgoCD..."
kubectl create namespace argocd || true
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

echo "⏳ Waiting for ArgoCD server to be ready..."
kubectl rollout status deployment argocd-server -n argocd --timeout=180s

# 🚀 Auto-apply ArgoCD bootstrap app
BOOTSTRAP_FILE="apps/system/bootstrap-system-apps.yaml"
if [ -f "$BOOTSTRAP_FILE" ]; then
  echo "🚀 Applying ArgoCD bootstrap app: $BOOTSTRAP_FILE"
  kubectl apply -f "$BOOTSTRAP_FILE"
else
  echo "⚠️  Warning: $BOOTSTRAP_FILE not found, skipping bootstrap"
fi
