## Architecture (High-level)

### Control plane (Laravel)

- **Entities**
  - **Billing**: `Plan`, `Order`, `Invoice`, `Payment`, `Subscription`
  - **Hosting**: `Server`, `Site`
- **Flow (happy path)**
  - Customer selects plan/design/domain → creates `Order` + open `Invoice`
  - Customer pays (Stripe PaymentIntent) → webhook marks `Order` + `Invoice` paid
  - Webhook dispatches `ProvisionSiteJob`
  - Provisioner selects a `Server` (shared vs dedicated) and calls the host agent by SSH

### Data plane (per hosting server)

- **Traefik** for reverse proxy + Let’s Encrypt
- **Shared MariaDB** (one per server)
- **One WordPress container per customer** (connects to the shared MariaDB)

### Multi-server strategy

- **Shared plans**: deployed to `servers.type = shared`
- **Dedicated plans**: deployed to `servers.type = dedicated` (can represent a separate VPS per customer, or a pool)

Placement logic lives in:

- `app/Services/Provisioning/ServerPlacementService.php`

