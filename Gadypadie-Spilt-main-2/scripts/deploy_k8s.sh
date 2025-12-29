#!/usr/bin/env bash
set -euo pipefail
BACK_IMG="${1:-}"
FRONT_IMG="${2:-}"
NS="gpsplit"

echo "[deploy] Using images:"
echo "  backend: $BACK_IMG"
echo "  frontend: $FRONT_IMG"

kubectl get ns $NS >/dev/null 2>&1 || kubectl create ns $NS
kubectl apply -f infra/k8s/mysql.yaml
kubectl apply -f infra/k8s/backend.yaml
kubectl apply -f infra/k8s/frontend.yaml
kubectl apply -f infra/k8s/ingress.yaml

# Roll deployments to the new images
kubectl -n $NS set image deployment/backend backend="$BACK_IMG" --record=true
kubectl -n $NS set image deployment/frontend frontend="$FRONT_IMG" --record=true

echo "[deploy] Waiting for rollout..."
kubectl -n $NS rollout status deployment/backend --timeout=120s
kubectl -n $NS rollout status deployment/frontend --timeout=120s

echo "[deploy] Done. Access:"
echo "  http://app.local  (frontend)"
echo "  http://api.local  (backend)"
