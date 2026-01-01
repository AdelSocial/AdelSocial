#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="/opt/waas"

if [[ ! -f "${ROOT_DIR}/docker-compose.base.yml" ]]; then
  echo "Expected ${ROOT_DIR}/docker-compose.base.yml to exist."
  echo "Copy infra/host-agent/* to /opt/waas first."
  exit 1
fi

if ! command -v docker >/dev/null 2>&1; then
  echo "Docker is not installed. Install Docker Engine first."
  exit 1
fi

if ! docker compose version >/dev/null 2>&1; then
  echo "Docker Compose plugin is not installed. Install docker-compose-plugin."
  exit 1
fi

mkdir -p "${ROOT_DIR}/bin"

if [[ ! -f "${ROOT_DIR}/.env" ]]; then
  cat > "${ROOT_DIR}/.env" <<'EOF'
LETSENCRYPT_EMAIL=admin@example.com
MARIADB_ROOT_PASSWORD=change-me
EOF
  echo "Created ${ROOT_DIR}/.env (update LETSENCRYPT_EMAIL and MARIADB_ROOT_PASSWORD)."
fi

echo "Starting base services (Traefik + MariaDB)..."
docker compose --env-file "${ROOT_DIR}/.env" -f "${ROOT_DIR}/docker-compose.base.yml" up -d

echo "Done."
