# Configuration Management

## Environment Variables (.env file)

```bash
# User/Group IDs
PUID=1000
PGID=1000

# Timezone
TZ=America/Denver  # Mountain Time

# Media Paths (Windows absolute paths)
MEDIA_ROOT=C:/plex-server/ultimate-plex-stack/media
DOWNLOAD_ROOT=C:/plex-server/ultimate-plex-stack/downloads
CONFIG_ROOT=C:/plex-server/ultimate-plex-stack/config

# VPN Configuration (NordVPN with WireGuard)
VPN_PROVIDER=nordvpn
VPN_TOKEN=your_nordvpn_access_token_here
VPN_ENABLED=true
VPN_DNS=103.86.96.100,103.86.99.100
VPN_PROTOCOL=wireguard
VPN_PORT=51820
VPN_KILL_SWITCH=true

# Plex Configuration
PLEX_CLAIM=your_plex_claim_here  # Get from https://www.plex.tv/claim (valid 4 minutes)

# Domain (for reverse proxy)
DOMAIN=cooperstation.stream
ACME_EMAIL=your_email@example.com  # For Let's Encrypt SSL notifications
```

## Buildarr Configuration (`buildarr.yml`)

- **Purpose**: Configuration-as-code for the Arr ecosystem (Prowlarr, Radarr, Sonarr, optionally Bazarr).
- **Location**: `buildarr.yml` in the project root (kept under version control).
- **Scope**:
  - Prowlarr: indexers, authentication, app (Radarr/Sonarr) integrations.
  - Radarr/Sonarr: root folders, quality profiles, download client linkage.
  - Bazarr: optional, if a suitable plugin or automation path is used.
- **Execution Modes**:
  - As a **Docker service** (`buildarr` container) that watches the config file.
  - As a **one-shot CLI** (Python venv on the host) run manually when config changes.

Example (conceptual) structure:

```yaml
buildarr:
  watch_config: false

prowlarr:
  hostname: prowlarr
  port: 9696
  protocol: http
  api_key: YOUR_PROWLARR_API_KEY

radarr:
  hostname: radarr
  port: 7878
  protocol: http

sonarr:
  hostname: sonarr
  port: 8989
  protocol: http
```

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

