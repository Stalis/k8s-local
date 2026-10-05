# Local k3d

Конфигурация локального Kubernetes-кластера на базе [k3d](https://k3d.io/) для macOS.

## Что устанавливается

- кластер `dev` с одним server- и одним agent-узлом;
- Traefik для HTTP/HTTPS-маршрутизации;
- Headlamp для просмотра Kubernetes;
- NATS с включённым JetStream;
- локальное persistent storage через каталог `pvc/`.

## Требования

Установите и запустите Docker Desktop, затем установите:

- `k3d`;
- `kubectl`;
- `yq`;
- `make` и `envsubst`.

Например, через Homebrew:

```bash
brew install k3d kubectl yq gettext
```

Если `envsubst` не находится в `PATH`, добавьте GNU gettext:

```bash
export PATH="$(brew --prefix gettext)/bin:$PATH"
```

## Запуск

Из корня репозитория выполните:

```bash
make up
```

Манифесты из `manifests/` подключаются в кластер автоматически через k3s.
Проверить состояние можно командами:

```bash
kubectl get nodes
kubectl get pods -A
```

## Доступ к сервисам

Добавьте имена в `/etc/hosts`, если они не разрешаются локально:

```text
127.0.0.1 k8s.localhost traefik.localhost nats-monitor.localhost
```

После этого сервисы доступны по адресам:

- Headlamp: <http://k8s.localhost>;
- Traefik Dashboard: <http://traefik.localhost/dashboard/>;
- NATS Dashboard: <http://nats-monitor.localhost>;
- NATS: `nats://localhost:4222`.

Для получения токена Headlamp выполните:

```bash
make headlamp-token
```

Токен на 24 часа будет скопирован в буфер обмена macOS.

## Управление кластером

```bash
make down   # удалить кластер
make reset  # пересоздать кластер
```

## Структура

```text
.
├── k3d.yaml        # конфигурация кластера
├── Makefile        # команды управления
├── manifests/      # манифесты Traefik, Headlamp и NATS
└── pvc/            # локальное persistent storage, не коммитится
```
