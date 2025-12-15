# Configuration Management

## Configuration Overview

This stack separates **non‑secret configuration**, **secrets**, and **app‑level config/state**:

- **`.env.config`**: non‑secret, environment‑specific settings (paths, timezone, domain, VPN provider flags, feature toggles).  
  - Loaded with: `docker compose --env-file .env.config …`
- **`.env.secrets`**: sensitive values (passwords, API keys, claim tokens, VPN credentials).  
  - Never committed; referenced from `docker-compose.yml` via `env_file: .env.secrets`.
- **`.env`**: informational stub only – Docker Compose is **not** expected to read real values from this file anymore.
- **`docker-compose.yml`**: defines services, ports, volumes, and which environment variables each container consumes (via `${VAR}` and `env_file`).
- **`buildarr.yml`**: configuration‑as‑code for Prowlarr/Radarr/Sonarr (root folders, quality profiles, indexers, qBittorrent linkage, etc.).
- **`config/` directory** (e.g., `config/radarr`, `config/sonarr`, `config/prowlarr`, `config/qbittorrent`, `config/plex`, `config/tdarr`, `config/npm`, `config/vpn/servers.json`): per‑service runtime configuration and state created/managed by the applications themselves or by Buildarr.

- **Example templates** (tracked in git, safe to share):
  - `.env.config.example`: example non‑secret configuration.
  - `.env.secrets.example`: example list of required secret keys (with placeholder values only).

- **Setup plan reference**:
  - For the high‑level implementation plan and where configuration fits into the overall rollout, see `plans/setup/00-SETUP.md`.

## Environment Variables (.env.config and .env.secrets)

```bash
# .env.config  → non‑secret configuration

# User/Group IDs
PUID=1000
PGID=1000

# Timezone
TZ=America/Denver  # Mountain Time

# Media Paths (Windows absolute paths)
MEDIA_ROOT=C:/plex-server/ultimate-plex-stack/media
DOWNLOAD_ROOT=C:/plex-server/ultimate-plex-stack/downloads
CONFIG_ROOT=C:/plex-server/ultimate-plex-stack/config

# VPN Configuration (NordVPN with WireGuard/OpenVPN)
VPN_PROVIDER=nordvpn
VPN_ENABLED=true
VPN_DNS=103.86.96.100,103.86.99.100
VPN_PROTOCOL=wireguard
VPN_PORT=443
VPN_KILL_SWITCH=true
OPENVPN_FLAGS=--ping-restart 60  # Extra OpenVPN CLI flags (space-separated)

# Domain (for reverse proxy)
DOMAIN=cooperstation.stream
ACME_EMAIL=your_email@example.com  # For Let's Encrypt SSL notifications
```

```bash
# .env.secrets → sensitive values (never commit this file)

# VPN Credentials (NordVPN service credentials for gluetun/OpenVPN)
OPENVPN_USER=your_nordvpn_service_username
OPENVPN_PASSWORD=your_nordvpn_service_password

# Plex Configuration
PLEX_CLAIM=your_plex_claim_here  # Get from https://www.plex.tv/claim (valid ~4 minutes)

# Buildarr / Arr API keys & credentials
PROWLARR_API_KEY=your_prowlarr_api_key_here
PROWLARR_AUTH_USERNAME=your_prowlarr_auth_username_here
PROWLARR_AUTH_PASSWORD=your_prowlarr_auth_password_here
RADARR_API_KEY=your_radarr_api_key_here
SONARR_API_KEY=your_sonarr_api_key_here
QBITTORRENT_USERNAME=your_qbittorrent_username_here
QBITTORRENT_PASSWORD=your_qbittorrent_password_here
```

**Usage summary:**

- **Non‑secret settings** (paths, timezone, IDs, domain, VPN provider and behavior) → `.env.config`.
- **Secrets** (VPN credentials, Plex claim token, API keys, usernames/passwords, tokens) → `.env.secrets`.
- Compose commands should always specify `.env.config`, and services that need secrets also load `.env.secrets`:
  - `docker compose --env-file .env.config up -d`
  - `docker compose --env-file .env.config run --rm buildarr apply`

Additionally:

- `.env.config.example` and `.env.secrets.example` are tracked templates you can copy from:
  - `cp .env.config.example .env.config`
  - `cp .env.secrets.example .env.secrets`
- Run `make check` to validate that both env files exist and contain the expected keys (values are not printed).

## Buildarr Configuration (`buildarr.yml`)

- **Purpose**: Configuration-as-code for the Arr ecosystem (Prowlarr, Radarr, Sonarr, optionally Bazarr).
- **Location**: `buildarr.yml` in the project root (kept under version control).
- **Scope**:
  - **Prowlarr**: connectivity, authentication, indexers, and App integrations (Radarr/Sonarr).
  - **Radarr**: connectivity, `/movies` root folder, quality profiles, and download client linkage (qBittorrent).
  - **Sonarr**: connectivity, `/tv` root folder, quality profiles, and download client linkage (qBittorrent).
  - **Bazarr**: optional stub (documented preferences only until a stable Buildarr plugin is available).
- **Secrets handling**:
  - API keys and credentials are **never** hard‑coded in `buildarr.yml`.
  - Instead, `buildarr.yml` references environment variables (e.g. `${PROWLARR_API_KEY}`) that are defined only in `.env.secrets`.
- **Execution**:
  - Buildarr is run as a **one-shot Docker tool** when configuration changes:
    - `docker compose run --rm buildarr apply`
  - `buildarr.watch_config` is set to `false`; Buildarr does not run continuously.
- **Design Principle**:
  - Treat `buildarr.yml` as the **source of truth** for Arr/Prowlarr configuration.
  - Use the Arr/Prowlarr UIs mainly to **verify** that YAML has been applied, not as the primary way to configure services.

Example (high-level) structure:

```yaml
buildarr:
  watch_config: false

prowlarr:
  hostname: prowlarr
  port: 9696
  protocol: http
  api_key: ${PROWLARR_API_KEY}
  # authentication, indexers, and apps (Radarr/Sonarr) defined here;
  # secrets like PROWLARR_API_KEY come from .env.secrets

radarr:
  hostname: radarr
  port: 7878
  protocol: http
  api_key: ${RADARR_API_KEY}
  root_folders:
    - path: /movies
      default: true
  quality_profiles:
    - name: HD-1080p
  download_clients:
    - name: qbittorrent
      host: qbittorrent
      port: 8080

sonarr:
  hostname: sonarr
  port: 8989
  protocol: http
  api_key: ${SONARR_API_KEY}
  root_folders:
    - path: /tv
      default: true
  quality_profiles:
    - name: HD-1080p
  download_clients:
    - name: qbittorrent
      host: qbittorrent
      port: 8080
```

## VPN Configuration Details

- **Behavioral settings** (provider, protocol, DNS, kill switch) live in `.env.config`:
  - `VPN_PROVIDER`, `VPN_ENABLED`, `VPN_DNS`, `VPN_PROTOCOL`, `VPN_PORT`, `VPN_KILL_SWITCH`, `OPENVPN_FLAGS`.
  - `OPENVPN_FLAGS` accepts raw OpenVPN CLI arguments (space-separated). Example: `--ping-restart 60` pairs with Gluetun's default `--ping` so the tunnel automatically re-establishes if the remote peer stops responding.
- **Credentials and secrets** for the VPN live only in `.env.secrets`:
  - `OPENVPN_USER`, `OPENVPN_PASSWORD`, and any additional provider‑specific secret values.
- **Static server configuration** (if used) lives in `config/vpn/servers.json`:
  - This file can define preferred servers, countries, or other advanced routing preferences.
- For step‑by‑step deployment and verification of the VPN gateway (Gluetun), see `plans/setup/05-vpn-gateway-deployment.md`.

## Docker Compose Profiles

```yaml
services:
  # Core services (always running)
  plex:
    profiles: ["core"]
  radarr:
    profiles: ["core"]
  sonarr:
    profiles: ["core"]

  # Advanced services (optional)
  tdarr:
    profiles: ["advanced"]
  bazarr:
    profiles: ["advanced"]

  # VPN gateway (for content acquisition only)
  vpn:
    profiles: ["vpn"]
  
  # Acquisition services (route through VPN)
  qbittorrent:
    profiles: ["torrent"]
    network_mode: "service:vpn"
  nzbget:
    profiles: ["usenet"]
    network_mode: "service:vpn"
```

