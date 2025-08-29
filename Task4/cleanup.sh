#!/bin/bash

set -e

read -p "Это удалит ВСЕ созданные RBAC ресурсы. Продолжить? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Очистка отменена пользователем."
    exit 0
fi

echo "Начинаем очистку..."
echo ""

echo "Удаление RoleBindings для Service Accounts..."
kubectl delete rolebinding developer-sa-dev-binding -n propdevelopment-dev --ignore-not-found=true
kubectl delete rolebinding developer-sa-staging-binding -n propdevelopment-staging --ignore-not-found=true
kubectl delete rolebinding developer-sa-prod-binding -n propdevelopment-prod --ignore-not-found=true

echo "Удаление ClusterRoleBindings для Service Accounts..."
BINDINGS=(
    "security-admin-sa-binding"
    "devops-engineer-sa-binding" 
    "cluster-viewer-sa-binding"
)

for binding in "${BINDINGS[@]}"; do
    kubectl delete clusterrolebinding "$binding" --ignore-not-found=true
done

echo "Удаление Service Accounts..."
kubectl delete serviceaccount security-admin-sa -n propdevelopment-security --ignore-not-found=true
kubectl delete serviceaccount devops-engineer-sa -n default --ignore-not-found=true
kubectl delete serviceaccount devops2-sa -n default --ignore-not-found=true
kubectl delete serviceaccount developer-sa -n propdevelopment-dev --ignore-not-found=true
kubectl delete serviceaccount developer2-sa -n propdevelopment-dev --ignore-not-found=true
kubectl delete serviceaccount viewer-sa -n default --ignore-not-found=true

echo "Удаление ClusterRoles..."
ROLES=(
    "security-admin"
    "devops-engineer"
    "developer"
    "cluster-viewer"
)

for role in "${ROLES[@]}"; do
    kubectl delete clusterrole "$role" --ignore-not-found=true
done

echo "Удаление namespace..."
NAMESPACES=(
    "propdevelopment-dev"
    "propdevelopment-staging"
    "propdevelopment-prod"
    "propdevelopment-security"
)

for ns in "${NAMESPACES[@]}"; do
    kubectl delete namespace "$ns" --ignore-not-found=true
done

