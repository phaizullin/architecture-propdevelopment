#!/bin/bash

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
MANIFESTS_DIR="${SCRIPT_DIR}/manifests"

CURRENT_CONTEXT=$(kubectl config current-context)
echo "Подключен к кластеру: $CURRENT_CONTEXT"
echo ""

read -p "Продолжить развертывание в кластере '$CURRENT_CONTEXT'? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Развертывание отменено пользователем."
    exit 0
fi

echo "Шаг 1/4: Создание namespace..."
kubectl apply -f "${MANIFESTS_DIR}/namespaces/propdevelopment-namespaces.yaml"
echo ""

echo "Шаг 2/4: Создание ролей RBAC..."
kubectl apply -f "${MANIFESTS_DIR}/roles/"
echo ""

echo "Шаг 3/4: Создание Service Accounts..."
kubectl apply -f "${MANIFESTS_DIR}/service-accounts/service-accounts.yaml"
echo ""

echo "Шаг 4/4: Привязка Service Accounts к ролям..."
kubectl apply -f "${MANIFESTS_DIR}/bindings/service-account-bindings.yaml"
echo ""
