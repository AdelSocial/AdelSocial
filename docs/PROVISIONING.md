## Provisioning (Docker + SSH)

### What happens after payment

1. Stripe webhook receives `payment_intent.succeeded`
2. App marks:
   - `orders.status = paid`
   - `invoices.status = paid`
3. App dispatches:
   - `App\Jobs\ProvisionSiteJob`
4. Job creates (or reuses) a `Site` record and selects a `Server`
5. Job SSHes into the server and runs:
   - `/opt/waas/bin/provision-site.sh ...`

### Host agent install (on each server)

Copy `infra/host-agent/` to:

- `/opt/waas`

Then run:

```bash
sudo /opt/waas/bin/bootstrap.sh
```

Update `/opt/waas/.env` with:

- `LETSENCRYPT_EMAIL`
- `MARIADB_ROOT_PASSWORD`

### Host agent provisioning script

The provisioning script:

- creates a DB + DB user in the shared MariaDB
- creates a WordPress container with Traefik routing labels
- installs WordPress core and WooCommerce via `wordpress:cli`

Script:

- `infra/host-agent/bin/provision-site.sh`

### Requirements on the server

- Docker Engine
- Docker Compose plugin
- Ports `80` and `443` open to the internet
- DNS A record pointing your domain to the server IP (for Let’s Encrypt HTTP-01)

### Hardening (open-source only)

Not automated in this MVP yet (but intended):

- UFW allow `22`, `80`, `443`
- Fail2Ban on SSH
- regular OS patching + unattended-upgrades

