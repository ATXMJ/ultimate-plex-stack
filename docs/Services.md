# Service Specifications

## Media Server Core

### Plex Media Server
- **Purpose**: Primary media streaming and library management
- **Image**: `lscr.io/linuxserver/plex:latest`
- **Status**: ✅ **DEPLOYED AND CONFIGURED**
- **Access**: http://localhost:32400/web
- **Ports**:
  - `32400/tcp` - Plex Web UI and streaming
- **Volumes**:
  - `/config` - Plex configuration and metadata
  - `/movies` - Movie library (mapped to `MEDIA_ROOT/movies`)
  - `/tv` - TV show library (mapped to `MEDIA_ROOT/tv`)
  - `/transcode` - Temporary transcoding files
- **Environment Variables**:
  - `PLEX_CLAIM` - Plex account claim token (used for initial setup)
  - `PUID` - User ID for file permissions
  - `PGID` - Group ID for file permissions
  - `TZ` - Timezone
  - `VERSION` - Docker versioning
- **Libraries Configured**:
  - Movies: `/movies` folder
  - TV Shows: `/tv` folder
- **Network**: Direct internet connection (NOT via VPN)
- **Notes**:
  - Remote access not yet configured (will be added in Step 14)
  - Hardware transcoding disabled (no GPU passthrough on Windows)

## Content Management Services

### Radarr (Movie Automation)
- **Purpose**: Automated movie downloading and management
- **Image**: `linuxserver/radarr:latest`
- **Network**: Direct internet connection (NOT via VPN)
- **Ports**: `7878/tcp`
- **Volumes**:
  - `/config` - Radarr configuration
  - `/downloads/movies` - Downloaded movie files
  - `/media/movies` - Final movie library
- **Environment Variables**:
  - `PUID` - User ID for file permissions
  - `PGID` - Group ID for file permissions
  - `TZ` - Timezone

### Sonarr (TV Show Automation)
- **Purpose**: Automated TV show downloading and management
- **Image**: `linuxserver/sonarr:latest`
- **Network**: Direct internet connection (NOT via VPN)
- **Ports**: `8989/tcp`
- **Volumes**:
  - `/config` - Sonarr configuration
  - `/downloads/tv` - Downloaded TV files
  - `/media/tv` - Final TV library
- **Environment Variables**:
  - `PUID` - User ID for file permissions
  - `PGID` - Group ID for file permissions
  - `TZ` - Timezone

### Bazarr (Subtitle Management)
- **Purpose**: Automated subtitle downloading and management
- **Image**: `linuxserver/bazarr:latest`
- **Ports**: `6767/tcp`
- **Volumes**:
  - `/config` - Bazarr configuration
  - `/media/movies` - Movie library for subtitle scanning
  - `/media/tv` - TV library for subtitle scanning
- **Environment Variables**:
  - `PUID` - User ID for file permissions
  - `PGID` - Group ID for file permissions
  - `TZ` - Timezone

### Prowlarr (Indexer Manager)
- **Purpose**: Centralized indexer management for Radarr/Sonarr
- **Image**: `lscr.io/linuxserver/prowlarr:latest`
- **Status**: ✅ **DEPLOYED AND CONFIGURED**
- **Access**: http://localhost:9696
- **Ports**: `9696/tcp`
- **Volumes**:
  - `/config` - Prowlarr configuration (mapped to `CONFIG_ROOT/prowlarr`)
- **Environment Variables**:
  - `PUID` - User ID for file permissions
  - `PGID` - Group ID for file permissions
  - `TZ` - Timezone
- **Network**: Direct internet connection (NOT via VPN)
- **Authentication**: Currently set to none (local access only)
- **API Key**: Configured (available in Prowlarr settings)
- **Notes**:
  - Indexers can be added through the web interface
  - Supports both public and private torrent trackers
  - FlareSolverr integration available for Cloudflare-protected sites (not currently configured)

### Overseerr (Request Management)
- **Purpose**: User request management and media discovery
- **Image**: `linuxserver/overseerr:latest`
- **Ports**: `5055/tcp`
- **Volumes**:
  - `/config` - Overseerr configuration
- **Environment Variables**:
  - `PUID` - User ID for file permissions
  - `PGID` - Group ID for file permissions
  - `TZ` - Timezone

## Content Processing

### Tdarr (Media Transcoding)
- **Purpose**: Automated media transcoding and optimization
- **Image**: `haveagitgat/tdarr:latest`
- **Ports**:
  - `8265/tcp` - Web UI
  - `8266/tcp` - Server
- **Volumes**:
  - `/config` - Tdarr configuration
  - `/logs` - Tdarr logs
  - `/media` - Media library for processing
  - `/temp` - Temporary processing files
- **Environment Variables**:
  - `PUID` - User ID for file permissions
  - `PGID` - Group ID for file permissions
  - `TZ` - Timezone
  - `NVIDIA_VISIBLE_DEVICES` - GPU device ID (if using GPU transcoding)

## Content Acquisition

**Note**: These are the ONLY services that route through VPN. All other services use direct internet connection.

### Torrent Client (qBittorrent)
- **Purpose**: BitTorrent downloading
- **Image**: `lscr.io/linuxserver/qbittorrent:latest`
- **Status**: ✅ **DEPLOYED AND CONFIGURED**
- **Network Mode**: `service:vpn` - ALL traffic routes through VPN gateway
- **Ports**: `8080/tcp` (Web UI, exposed via VPN container)
- **Access**: http://localhost:8080 (static password configured via config file)
- **Volumes**:
  - `/config` - qBittorrent configuration (mapped to `CONFIG_ROOT/qbittorrent`)
  - `/downloads` - Download directory (mapped to `DOWNLOAD_ROOT`)
- **Environment Variables**:
  - `PUID` - User ID for file permissions
  - `PGID` - Group ID for file permissions
  - `TZ` - Timezone
  - `WEBUI_PORT` - Web UI port (8080)
  - `TORRENTING_PORT` - Torrent connection port (8694)
- **VPN Protection**: Kill switch **completely blocks ALL internet access** if VPN disconnects - client cannot operate without active VPN connection
- **Configuration Note**: VPN protection is enforced via Docker networking - **no VPN configuration needed in qBittorrent settings**
- **Password Configuration**: Static password set via PBKDF2 hash in `qBittorrent.conf` (not environment variable)
- **Download Paths**:
  - Default Save Path: `/downloads/complete/`
  - Incomplete Save Path: `/downloads/incomplete/`
- **Network**: Routes through NordVPN WireGuard (Switzerland)

### Usenet Client (NZBGet)
- **Purpose**: Usenet downloading
- **Image**: `linuxserver/nzbget:latest`
- **Network Mode**: `service:vpn` - ALL traffic routes through VPN gateway
- **Ports**: `6789/tcp` (exposed via VPN container)
- **Volumes**:
  - `/config` - NZBGet configuration
  - `/downloads` - Download directory
- **Environment Variables**:
  - `PUID` - User ID for file permissions
  - `PGID` - Group ID for file permissions
  - `TZ` - Timezone
- **VPN Protection**: Kill switch **completely blocks ALL internet access** if VPN disconnects - client cannot operate without active VPN connection
- **Configuration Note**: VPN protection is enforced via Docker networking - **no VPN configuration needed in NZBGet settings**

## Network Security

### VPN Gateway (WireGuard/OpenVPN)
- **Purpose**: Secure gateway **exclusively for torrent and usenet traffic**
- **Image**: `linuxserver/wireguard:latest` or `dperson/openvpn-client:latest`
- **Ports**:
  - `51820/udp` - WireGuard
  - `1194/udp` - OpenVPN (alternative)
- **Volumes**:
  - `/config` - VPN configuration files
- **Environment Variables**:
  - `PUID` - User ID for file permissions
  - `PGID` - Group ID for file permissions
  - `TZ` - Timezone
  - `VPN_ENDPOINT` - VPN server endpoint
  - `VPN_USERNAME` - VPN username
  - `VPN_PASSWORD` - VPN password
- **Kill Switch Configuration**: iptables rules to **completely block all traffic** when VPN disconnects
- **Kill Switch Behavior**: If VPN connection drops, torrent/usenet clients lose ALL internet access and stop working (intentional security feature to prevent IP leaks)
- **Implementation**: Docker `network_mode: "service:vpn"` - clients share VPN container's network stack
- **Configuration Location**: VPN is configured in **this container only** - download clients require NO VPN settings
- **Services Using VPN**: qBittorrent and NZBGet ONLY (via network_mode)
- **Services NOT Using VPN**: Plex, Radarr, Sonarr, Bazarr, Prowlarr, Overseerr, Tdarr, Nginx Proxy Manager

### Reverse Proxy (Nginx Proxy Manager)
- **Purpose**: SSL termination and traffic routing
- **Image**: `jc21/nginx-proxy-manager:latest`
- **Ports**:
  - `80/tcp` - HTTP
  - `81/tcp` - Admin interface
  - `443/tcp` - HTTPS
- **Volumes**:
  - `/config` - NPM configuration
  - `/data` - SSL certificates and data
  - `/letsencrypt` - Let's Encrypt certificates
- **Environment Variables**:
  - `PUID` - User ID for file permissions
  - `PGID` - Group ID for file permissions
  - `TZ` - Timezone

