#!/bin/bash

set -e

read -p "Удалить все ресурсы (namespace, pods, services, policies)? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Очистка отменена."
    exit 0
fi

if kubectl get namespace task5-network-policies &>/dev/null; then
    kubectl config set-context --current --namespace=task5-network-policies
    
    echo "Удаление сетевых политик..."
    kubectl delete networkpolicy --all --ignore-not-found=true
    
    echo "Удаление сервисов..."
    kubectl delete svc --all --ignore-not-found=true
    
    echo "Удаление pods..."
    kubectl delete pod --all --ignore-not-found=true
    
    echo "Удаление namespace..."
    kubectl delete namespace task5-network-policies --ignore-not-found=true
    
    kubectl config set-context --current --namespace=default
else
    echo "Namespace task5-network-policies не найден."
fi
