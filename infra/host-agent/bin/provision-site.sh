#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  provision-site.sh --site-id=123 --domain=example.com \
    --wp-admin-user=admin --wp-admin-password=... --wp-admin-email=... \
    --db-name=... --db-user=... --db-password=...
EOF
}

SITE_ID=""
DOMAIN=""
WP_ADMIN_USER=""
WP_ADMIN_PASSWORD=""
WP_ADMIN_EMAIL=""
DB_NAME=""
DB_USER=""
DB_PASSWORD=""

for arg in "$@"; do
  case "$arg" in
    --site-id=*) SITE_ID="${arg#*=}" ;;
    --domain=*) DOMAIN="${arg#*=}" ;;
    --wp-admin-user=*) WP_ADMIN_USER="${arg#*=}" ;;
    --wp-admin-password=*) WP_ADMIN_PASSWORD="${arg#*=}" ;;
    --wp-admin-email=*) WP_ADMIN_EMAIL="${arg#*=}" ;;
    --db-name=*) DB_NAME="${arg#*=}" ;;
    --db-user=*) DB_USER="${arg#*=}" ;;
    --db-password=*) DB_PASSWORD="${arg#*=}" ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown argument: $arg"; usage; exit 1 ;;
  esac
done

if [[ -z "${SITE_ID}" || -z "${DOMAIN}" || -z "${WP_ADMIN_USER}" || -z "${WP_ADMIN_PASSWORD}" || -z "${WP_ADMIN_EMAIL}" || -z "${DB_NAME}" || -z "${DB_USER}" || -z "${DB_PASSWORD}" ]]; then
  usage
  exit 1
fi

ROOT_DIR="/opt/waas"
SITE_DIR="${ROOT_DIR}/sites/${SITE_ID}"
STACK_FILE="${SITE_DIR}/docker-compose.yml"
ENV_FILE="${ROOT_DIR}/.env"

if [[ ! -f "${ENV_FILE}" ]]; then
  echo "Missing ${ENV_FILE}. Run ${ROOT_DIR}/bin/bootstrap.sh first."
  exit 1
fi

mkdir -p "${SITE_DIR}"

# Ensure shared network exists (created by base stack)
docker network inspect waas >/dev/null 2>&1 || docker network create waas >/dev/null

# Create DB + user in shared MariaDB container
MARIADB_ROOT_PASSWORD="$(grep -E '^MARIADB_ROOT_PASSWORD=' "${ENV_FILE}" | cut -d= -f2- || true)"
if [[ -z "${MARIADB_ROOT_PASSWORD}" ]]; then
  echo "MARIADB_ROOT_PASSWORD not set in ${ENV_FILE}"
  exit 1
fi

echo "Creating database and user in shared MariaDB..."
docker exec -i mariadb sh -lc "mysql -uroot -p\"${MARIADB_ROOT_PASSWORD}\"" <<SQL
CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${DB_NAME}\`.* TO '${DB_USER}'@'%';
FLUSH PRIVILEGES;
SQL

WP_VOLUME="waas_site_${SITE_ID}_wp"
docker volume inspect "${WP_VOLUME}" >/dev/null 2>&1 || docker volume create "${WP_VOLUME}" >/dev/null

cat > "${STACK_FILE}" <<EOF
services:
  wordpress:
    image: wordpress:6.5.6-apache
    container_name: waas-site-${SITE_ID}
    environment:
      WORDPRESS_DB_HOST: mariadb:3306
      WORDPRESS_DB_NAME: ${DB_NAME}
      WORDPRESS_DB_USER: ${DB_USER}
      WORDPRESS_DB_PASSWORD: ${DB_PASSWORD}
    volumes:
      - ${WP_VOLUME}:/var/www/html
    networks:
      - waas
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.waas-site-${SITE_ID}.rule=Host(\`${DOMAIN}\`)"
      - "traefik.http.routers.waas-site-${SITE_ID}.entrypoints=web,websecure"
      - "traefik.http.routers.waas-site-${SITE_ID}.tls=true"
      - "traefik.http.routers.waas-site-${SITE_ID}.tls.certresolver=le"

networks:
  waas:
    external: true
EOF

echo "Starting WordPress container..."
docker compose -f "${STACK_FILE}" up -d

# Wait briefly for container to initialize files
sleep 5

echo "Installing WordPress core + WooCommerce via wp-cli..."
docker run --rm --network waas \
  -v "${WP_VOLUME}:/var/www/html" \
  wordpress:cli \
  wp core install \
    --path=/var/www/html \
    --url="https://${DOMAIN}" \
    --title="WooCommerce Store" \
    --admin_user="${WP_ADMIN_USER}" \
    --admin_password="${WP_ADMIN_PASSWORD}" \
    --admin_email="${WP_ADMIN_EMAIL}" \
    --skip-email

docker run --rm --network waas \
  -v "${WP_VOLUME}:/var/www/html" \
  wordpress:cli \
  wp plugin install woocommerce --activate --path=/var/www/html

echo "Provisioning complete for site ${SITE_ID} (${DOMAIN})."
