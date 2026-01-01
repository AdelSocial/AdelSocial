## WaaS Platform (WordPress + WooCommerce) — Laravel + Docker

This repository is an **open-source, zero-license** starting point for a **Website as a Service (WaaS)** platform (Shopify-like) that sells and automatically deploys **WordPress + WooCommerce** sites after payment.

### What’s implemented (MVP foundation)

- **Laravel 12** app skeleton
- **Docker Compose** local dev stack: nginx + php-fpm + MariaDB + Redis + queue worker + scheduler (`docker-compose.yml`)
- **Custom billing data model**:
  - `plans`, `orders`, `invoices`, `payments`, `subscriptions`
- **Stripe payment flow (extensible)**:
  - `PaymentGateway` abstraction
  - Stripe PaymentIntent creation endpoint
  - Stripe webhook handler that marks Orders/Invoices paid and dispatches provisioning
- **Provisioning foundation**:
  - `servers` + `sites` tables
  - server placement logic (shared vs dedicated)
  - queued `ProvisionSiteJob` that SSHes into a server and calls a host-agent script
- **Admin panel**:
  - Filament admin at `/admin`
  - CRUD resources for users/plans/orders/invoices/payments/subscriptions/servers/sites

### What’s NOT implemented yet (planned next)

- Domain registrar integration (search/purchase/renew) for your chosen provider
- Razorpay + PayPal gateway implementations (hooks are stubbed in config)
- Full WooCommerce “design template” pipeline (ZIP + DB import + search/replace)
- Automated renewal charging + suspension/unsuspension rules (billing scheduler commands)
- Customer-facing UI (design selection, checkout pages, customer portal)

## Local development (Docker)

1. Copy env:

```bash
cp .env.example .env
```

2. Start services:

```bash
docker compose up -d --build
```

3. Run migrations + seed:

```bash
docker compose exec app php artisan migrate
docker compose exec app php artisan db:seed
```

4. Open:

- **App**: `http://localhost:8080`
- **Admin panel**: `http://localhost:8080/admin`
  - Seeded admin: `admin@example.com` / `password`

## Checkout + Stripe (MVP endpoints)

- **List plans**: `GET /plans`
- **Create order**: `POST /checkout/orders`
- **Create Stripe PaymentIntent**: `POST /checkout/orders/{order}/stripe/payment-intent`
- **Stripe webhook**: `POST /webhooks/stripe` (CSRF exempt)

Configure these in `.env`:

- `STRIPE_SECRET`
- `STRIPE_WEBHOOK_SECRET`

## Provisioning (server-side host agent)

Provisioning is split into:

- **Laravel control plane** (this app): decides server placement, writes DB state, runs queued jobs
- **Host agent** (per server): runs Docker/Traefik/MariaDB and creates per-customer WordPress containers

Host agent files are in:

- `infra/host-agent/`

See:

- `infra/host-agent/README.md`

## Architecture docs

- `docs/ARCHITECTURE.md`
- `docs/PROVISIONING.md`
