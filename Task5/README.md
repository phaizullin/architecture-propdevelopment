# Управление трафиком в Kubernetes

## Описание

Разделить трафик между сервисами так, чтобы:
- `front-end` мог общаться только с `back-end-api`
- `admin-front-end` мог общаться только с `admin-back-end-api`
- Все остальные соединения были запрещены

## Разворачивание

```bash
./deploy.sh

kubectl get pods,svc,networkpolicies -n task5-network-policies

./test_network_policies.sh
```

## Сетевые политики

### 1. default-deny-all.yaml
Запрещает весь трафик по умолчанию.

### 2. non-admin-api-allow.yaml
Разрешает трафик между:
- front-end ↔ back-end-api

### 3. admin-api-allow.yaml  
Разрешает трафик между:
- admin-front-end ↔ admin-back-end-api

## Minikube

### Для работы NetworkPolicies нужен **Calico**: `minikube start --cni=calico`


## Тестирование

### Команды для ручного тестирования:

```bash
# Проверка разрешенного соединения
kubectl run test-$RANDOM --rm -i -t --image=alpine -- sh
/ # wget -qO- --timeout=2 http://back-end-api-app

# Проверка запрещенного соединения  
kubectl run test-$RANDOM --rm -i -t --image=alpine -- sh
/ # wget -qO- --timeout=2 http://admin-back-end-api-app
```

## Очистка

```bash
./cleanup.sh
```