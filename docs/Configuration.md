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
  - **Prowlarr**: connectivity, authentication, indexers, and App integrations (Radarr/Sonarr).
  - **Radarr**: connectivity, `/movies` root folder, quality profiles, and download client linkage (qBittorrent).
  - **Sonarr**: connectivity, `/tv` root folder, quality profiles, and download client linkage (qBittorrent).
  - **Bazarr**: optional stub (documented preferences only until a stable Buildarr plugin is available).
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
  api_key: YOUR_PROWLARR_API_KEY_HERE
  # authentication, indexers, and apps (Radarr/Sonarr) defined here

radarr:
  hostname: radarr
  port: 7878
  protocol: http
  api_key: YOUR_RADARR_API_KEY_HERE
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
  api_key: YOUR_SONARR_API_KEY_HERE
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

