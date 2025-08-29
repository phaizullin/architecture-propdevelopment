#!/bin/bash

set -e

if ! kubectl cluster-info &> /dev/null; then
    echo "Ошибка: Нет подключения к Kubernetes кластеру"
    echo "Убедитесь, что Minikube запущен: minikube start --cni=calico"
    exit 1
fi

echo "Шаг 1/3: Создание namespace..."
kubectl create namespace task5-network-policies --dry-run=client -o yaml | kubectl apply -f -
kubectl config set-context --current --namespace=task5-network-policies

echo "Шаг 2/3: Создание сервисов с nginx..."
echo "- Создание front-end-app..."
kubectl run front-end-app --image=nginx --labels role=front-end --expose --port 80

echo "- Создание back-end-api-app..."
kubectl run back-end-api-app --image=nginx --labels role=back-end-api --expose --port 80

echo "- Создание admin-front-end-app..."
kubectl run admin-front-end-app --image=nginx --labels role=admin-front-end --expose --port 80

echo "- Создание admin-back-end-api-app..."
kubectl run admin-back-end-api-app --image=nginx --labels role=admin-back-end-api --expose --port 80

echo ""
echo "Ожидание готовности pods..."
kubectl wait --for=condition=Ready pod --all --timeout=60s

echo ""
echo "Шаг 3/3: Применение сетевых политик..."
echo "- Применение default-deny-all..."
kubectl apply -f default-deny-all.yaml

echo "- Применение non-admin-api-allow..."
kubectl apply -f non-admin-api-allow.yaml

echo "- Применение admin-api-allow..."
kubectl apply -f admin-api-allow.yaml

echo "Статус ресурсов:"
kubectl get pods,svc,networkpolicies

echo "Для тестирования: ./test_network_policies.sh"
