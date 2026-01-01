# Host Agent (Server-side)

This folder contains the **server-side scripts** that run on each hosting server (AWS EC2 / Lightsail).

The Laravel app provisions sites by SSHing into a server and calling:

- `/opt/waas/bin/provision-site.sh`

## What this host agent sets up

- **Traefik** reverse proxy with **Let’s Encrypt** (HTTP-01)
- A **shared MariaDB** instance (one per server)
- A per-customer **WordPress container** connected to the shared DB

## Install on a server (Ubuntu)

1. Copy this folder to the server:

   - `/opt/waas`

2. Run:

   - `/opt/waas/bin/bootstrap.sh`

3. Verify:

   - `docker ps` shows `traefik` and `mariadb`

> Note: Hardening (UFW, Fail2Ban) is intentionally left as a separate step so you can align it with your baseline images and SSH policies.

