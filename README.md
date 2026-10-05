# Local k3d

Конфигурация локального Kubernetes-кластера на базе [k3d](https://k3d.io/) для macOS.

## Что устанавливается

- кластер `dev` с одним server- и одним agent-узлом;
- Traefik для HTTP/HTTPS-маршрутизации;
- Headlamp для просмотра Kubernetes;
- NATS с включённым JetStream;
- локальное persistent storage через каталог `pvc/`.

## Prerequisites

Для macOS нужны Homebrew и Docker CLI. Docker Desktop не используется: Docker
daemon запускается в Colima.

Подготовить окружение одной командой можно из корня репозитория:

```bash
make deps
```

Target устанавливает недостающие Homebrew-пакеты и безопасно повторяется:

- `colima` — Docker runtime;
- `docker` — Docker CLI;
- `kubectl` — Kubernetes CLI;
- `k3d` — локальный Kubernetes-кластер;
- `helm` — управление Helm-чартами;
- `yq` — чтение имени кластера из `k3d.yaml`;
- `gettext` — предоставляет `envsubst`, используемый при запуске.

Затем `make deps` запускает Colima и проверяет доступность Docker daemon.
Если `envsubst` не находится в `PATH`, добавьте GNU gettext:

```bash
export PATH="$(brew --prefix gettext)/bin:$PATH"
```

Эквивалентные команды вручную:

```bash
brew install colima docker kubectl k3d helm yq gettext
colima start
docker info
```

NATS CLI в текущем проекте не используется и отдельно не устанавливается.

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
