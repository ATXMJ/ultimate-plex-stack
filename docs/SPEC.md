# Ultimate Plex Media Stack - Technical Specifications

## Overview

This specification defines a comprehensive personal media server stack built with Docker Compose, providing automated media management, streaming, and content acquisition capabilities. The stack is designed to be initially deployed on local storage with easy migration paths to NAS systems.

This repository includes complete configuration for serving the Plex stack securely via your own custom domain name, with automatic SSL certificate management, reverse proxy setup, and remote access capabilities.

## Architecture Overview

### Core Components

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Content       │    │   Management    │    │   Streaming     │
│   Acquisition   │────│   Services      │────│   Services      │
│                 │    │                 │    │                 │
│ • Torrent       │    │ • Radarr        │    │ • Plex Media    │
│ • Usenet        │    │ • Sonarr        │    │   Server        │
│ • VPN Gateway   │    │ • Prowlarr      │    │ • Overseerr     │
└─────────────────┘    │ • Bazarr        │    └─────────────────┘
                       │ • Tdarr         │
                       └─────────────────┘
```

### Network Architecture

```
Internet ── VPN ── Reverse Proxy ── Services
                    │
                    └── Kill Switch (for torrent/usenet)
```

## Service Specifications

### Media Server Core

#### Plex Media Server
- **Purpose**: Primary media streaming and library management
- **Image**: `plexinc/pms-docker:latest`
- **Ports**:
  - `32400/tcp` - Plex Web UI
  - `32400/udp` - Plex DLNA
  - `32469/tcp` - Plex DLNA
  - `32410/udp` - GDM network discovery
  - `32412/udp` - GDM network discovery
  - `32413/udp` - GDM network discovery
  - `32414/udp` - GDM network discovery
- **Volumes**:
  - `/config` - Plex configuration and metadata
  - `/media/movies` - Movie library
  - `/media/tv` - TV show library
  - `/media/music` - Music library
  - `/media/photos` - Photo library
  - `/transcode` - Temporary transcoding files
- **Environment Variables**:
  - `PLEX_CLAIM` - Plex account claim token
  - `ADVERTISE_IP` - IP address to advertise to clients
  - `ALLOWED_NETWORKS` - Comma-separated list of allowed networks
  - `TZ` - Timezone

### Content Management Services

#### Radarr (Movie Automation)
- **Purpose**: Automated movie downloading and management
- **Image**: `linuxserver/radarr:latest`
- **Ports**: `7878/tcp`
- **Volumes**:
  - `/config` - Radarr configuration
  - `/downloads/movies` - Downloaded movie files
  - `/media/movies` - Final movie library
- **Environment Variables**:
  - `PUID` - User ID for file permissions
  - `PGID` - Group ID for file permissions
  - `TZ` - Timezone

#### Sonarr (TV Show Automation)
- **Purpose**: Automated TV show downloading and management
- **Image**: `linuxserver/sonarr:latest`
- **Ports**: `8989/tcp`
- **Volumes**:
  - `/config` - Sonarr configuration
  - `/downloads/tv` - Downloaded TV files
  - `/media/tv` - Final TV library
- **Environment Variables**:
  - `PUID` - User ID for file permissions
  - `PGID` - Group ID for file permissions
  - `TZ` - Timezone

#### Bazarr (Subtitle Management)
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

#### Prowlarr (Indexer Manager)
- **Purpose**: Centralized indexer management for Radarr/Sonarr
- **Image**: `linuxserver/prowlarr:latest`
- **Ports**: `9696/tcp`
- **Volumes**:
  - `/config` - Prowlarr configuration
- **Environment Variables**:
  - `PUID` - User ID for file permissions
  - `PGID` - Group ID for file permissions
  - `TZ` - Timezone

#### Overseerr (Request Management)
- **Purpose**: User request management and media discovery
- **Image**: `linuxserver/overseerr:latest`
- **Ports**: `5055/tcp`
- **Volumes**:
  - `/config` - Overseerr configuration
- **Environment Variables**:
  - `PUID` - User ID for file permissions
  - `PGID` - Group ID for file permissions
  - `TZ` - Timezone

### Content Processing

#### Tdarr (Media Transcoding)
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

### Content Acquisition

#### Torrent Client (qBittorrent)
- **Purpose**: BitTorrent downloading with VPN integration
- **Image**: `linuxserver/qbittorrent:latest`
- **Ports**: `8080/tcp` (Web UI)
- **Volumes**:
  - `/config` - qBittorrent configuration
  - `/downloads` - Download directory
- **Environment Variables**:
  - `PUID` - User ID for file permissions
  - `PGID` - Group ID for file permissions
  - `TZ` - Timezone
  - `WEBUI_PORT` - Web UI port

#### Usenet Client (NZBGet)
- **Purpose**: Usenet downloading with VPN integration
- **Image**: `linuxserver/nzbget:latest`
- **Ports**: `6789/tcp`
- **Volumes**:
  - `/config` - NZBGet configuration
  - `/downloads` - Download directory
- **Environment Variables**:
  - `PUID` - User ID for file permissions
  - `PGID` - Group ID for file permissions
  - `TZ` - Timezone

### Network Security

#### VPN Gateway (WireGuard/OpenVPN)
- **Purpose**: Secure gateway for torrent/usenet traffic
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
- **Kill Switch Configuration**: iptables rules to block all traffic when VPN disconnects

#### Reverse Proxy (Nginx Proxy Manager)
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

## Storage Architecture

### Hybrid Storage Strategy

The stack uses a hybrid approach: **server and application data remains local** while **only media libraries are stored on NAS**. This provides optimal performance for temporary operations while leveraging NAS for long-term media storage.

### Local Storage Layout (Server & Application Data)

```
/
├── docker/
│   ├── plex-stack/
│   │   ├── config/          # Application configurations (LOCAL)
│   │   │   ├── plex/
│   │   │   ├── radarr/
│   │   │   ├── sonarr/
│   │   │   ├── bazarr/
│   │   │   └── ...
│   │   ├── downloads/       # Temporary downloads (LOCAL)
│   │   │   ├── movies/
│   │   │   ├── tv/
│   │   │   └── complete/
│   │   ├── transcode/       # Plex transcode temp (LOCAL)
│   │   └── temp/            # Other temporary files (LOCAL)
│   └── shared/              # Cross-container data (LOCAL)
```

### NAS Storage Layout (Media Libraries Only)

```
NAS Mount Point (e.g., /mnt/nas/media/)
├── movies/                  # Movie library (NAS)
├── tv/                      # TV show library (NAS)
├── music/                   # Music library (NAS)
├── photos/                 # Photo library (NAS)
└── books/                  # Books/Audiobooks (NAS - future)
```

### Volume Mapping Strategy

#### Initial Setup (Local Media)
```yaml
volumes:
  # Application configs - LOCAL
  - ./config/plex:/config
  - ./config/radarr:/config

  # Temporary files - LOCAL (performance critical)
  - ./downloads:/downloads
  - ./transcode:/transcode

  # Media libraries - LOCAL (initially)
  - ./media/movies:/movies
  - ./media/tv:/tv
  - ./media/music:/music
  - ./media/photos:/photos
```

#### NAS Migration (Media Libraries Only)
```yaml
volumes:
  # Application configs - REMAIN LOCAL
  - ./config/plex:/config
  - ./config/radarr:/config

  # Temporary files - REMAIN LOCAL (performance critical)
  - ./downloads:/downloads
  - ./transcode:/transcode

  # Media libraries - MOVED TO NAS
  - /mnt/nas/media/movies:/movies
  - /mnt/nas/media/tv:/tv
  - /mnt/nas/media/music:/music
  - /mnt/nas/media/photos:/photos
```

#### Environment Variables for Flexibility
```bash
# Media library paths (update when migrating to NAS)
MOVIES_PATH=/mnt/nas/media/movies    # Change from ./media/movies
TV_PATH=/mnt/nas/media/tv            # Change from ./media/tv
MUSIC_PATH=/mnt/nas/media/music      # Change from ./media/music
PHOTOS_PATH=/mnt/nas/media/photos    # Change from ./media/photos

# Keep downloads and transcode local for performance
DOWNLOADS_PATH=./downloads           # Always local
TRANSCODE_PATH=./transcode           # Always local
```

#### Storage Requirements

**Local Storage (Server & Application Data):**
- **Minimum**: 500GB SSD for initial setup
  - 100GB configs and application data
  - 200GB downloads (temporary, can be cleared)
  - 200GB transcode temp files
- **Recommended**: 1TB NVMe SSD for performance
- **Purpose**: Fast access for application binaries, configs, and temporary operations

**NAS Storage (Media Libraries Only):**
- **Minimum**: 2TB for initial media library
- **Recommended**: 4TB+ for growth (movies + TV + music + photos)
- **RAID**: Hardware RAID 5/6 or software RAID with redundancy
- **Backup**: Multiple copies, offsite backup solution
- **Network**: Gigabit Ethernet minimum, 10GbE recommended for large libraries

## Networking and Security

### Internal Networking
- **Docker Network**: `plex-stack` (isolated bridge network)
- **Service Discovery**: Container names for inter-service communication
- **Port Exposure**: Only expose necessary ports to host

### VPN Integration
#### Kill Switch Implementation
```bash
# iptables rules for kill switch
iptables -I OUTPUT -s 172.20.0.0/16 -d 192.168.1.0/24 -j ACCEPT
iptables -I OUTPUT -s 172.20.0.0/16 -o tun0 -j ACCEPT
iptables -I OUTPUT -s 172.20.0.0/16 -j DROP
```

#### Service Dependencies
- Torrent and Usenet clients must route through VPN
- Media management services can use direct connection
- Reverse proxy handles external access

### Access Control

#### Authentication Overview
Each service in the stack requires individual authentication configuration. The stack is designed with security-first defaults, requiring explicit setup of credentials for all web interfaces.

**User Access Patterns:**
- **End Users**: Primarily access Plex (streaming) and Overseerr (content requests)
- **Administrators**: Access all management services (Radarr, Sonarr, Bazarr, Tdarr, Prowlarr)
- **Services without native authentication** are secured through reverse proxy authentication

#### Service Authentication Details

**Plex Media Server**
- **Authentication**: Native - Required, uses Plex account integration
- **Setup**: Claim token required during initial setup
- **User Management**: Plex account users, family sharing support
- **Remote Access**: Configurable through Plex account settings

**Overseerr**
- **Authentication**: Native - Required
- **Methods**: Plex account integration (recommended) or local accounts
- **Setup**: Must configure authentication during initial setup
- **Integration**: Seamlessly integrates with Plex user management

**Management Services (Radarr, Sonarr, Bazarr, Prowlarr)**
- **Authentication**: Reverse proxy required (no native auth)
- **Default State**: No authentication (must be secured via proxy)
- **Setup**: Configure authentication in Nginx Proxy Manager
- **Access**: Admin-only via secured subdomains

**Tdarr**
- **Authentication**: Optional native auth available
- **Default State**: No authentication
- **Setup**: Configure in web interface or secure via reverse proxy

**Content Acquisition (qBittorrent, NZBGet)**
- **Authentication**: Required
- **Setup**: Configure strong username/password during initial setup
- **Security Note**: These services handle sensitive download operations

**Tdarr**
- **Authentication**: Optional
- **Default State**: No authentication
- **Setup**: Configure in web interface if needed

**Nginx Proxy Manager**
- **Authentication**: Required for admin interface
- **Setup**: Configure admin credentials during initial setup
- **Purpose**: Manages SSL certificates and routing

#### Authentication Best Practices
- **Strong Passwords**: Use complex passwords for all services
- **Unique Credentials**: Different passwords for each service
- **Plex Integration**: Leverage Plex's built-in user management where possible
- **Network Security**: Combine authentication with network restrictions
- **Regular Updates**: Change default passwords immediately after setup
- **VPN Protection**: Route sensitive services through VPN when possible

#### Reverse Proxy Authentication for Admin Services
For services without native authentication (Radarr, Sonarr, Bazarr, Tdarr, Prowlarr), secure access through Nginx Proxy Manager:

**Setup Options:**
1. **Basic Authentication**: Username/password protection at proxy level
2. **IP Restrictions**: Limit access to specific IP addresses/networks
3. **VPN-Only Access**: Require VPN connection for admin services
4. **OAuth Integration**: Use external authentication providers

**Recommended Configuration:**
- Create separate subdomains (e.g., `radarr.yourdomain.com`, `sonarr.yourdomain.com`)
- Enable SSL certificates for each subdomain
- Configure basic auth or IP restrictions for admin-only services
- Keep Plex and Overseerr publicly accessible (with their native auth)

**Example Nginx Proxy Manager Setup:**
```
Proxy Host: radarr.yourdomain.com
- Forward to: http://radarr:7878
- SSL: Enable with Let's Encrypt
- Access List: Admin-only (basic auth or IP restriction)
```

#### Multi-User Considerations
- **Plex Accounts**: Primary user management system
- **Overseerr Integration**: Provides request management with user authentication
- **Access Levels**: Configure appropriate permissions for different users
- **Family Sharing**: Plex supports multiple user accounts with different access levels

## Configuration Management

### Environment Variables (.env file)

```bash
# User/Group IDs
PUID=1000
PGID=1000

# Timezone
TZ=America/New_York

# Media Paths
MEDIA_ROOT=/mnt/local/media
DOWNLOAD_ROOT=/mnt/local/downloads

# VPN Configuration
VPN_PROVIDER=mullvad
VPN_ENDPOINT=us-nyc-001.mullvad.net
VPN_USERNAME=user123
VPN_PASSWORD=pass456

# Plex Configuration
PLEX_CLAIM=claim-abc123def456

# Domain (for reverse proxy)
DOMAIN=plex.mydomain.com
```

### Docker Compose Profiles

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

  # Acquisition services (with VPN)
  qbittorrent:
    profiles: ["torrent"]
  nzbget:
    profiles: ["usenet"]
```

## Deployment Instructions

### Prerequisites
1. Windows 11 Pro host with Docker Desktop
2. Sufficient storage space (see storage requirements)
3. VPN service subscription
4. Domain name (optional, for reverse proxy)

### Initial Setup

1. **Clone Repository**
   ```powershell
   git clone https://github.com/DonMcD/ultimate-plex-stack.git
   cd ultimate-plex-stack
   ```

2. **Configure Environment**
   ```bash
   cp .env.example .env
   # Edit .env with your values
   ```

3. **Create Directory Structure**
   ```powershell
   # Create local directories for server data
   mkdir config, downloads, transcode -Force

   # Create initial local media directories (will migrate to NAS later)
   mkdir media\movies, media\tv, media\music, media\photos -Force
   ```

4. **Deploy Services**
   ```powershell
   # Using Makefile (recommended)
   make up-d

   # Or directly with Docker Compose
   docker compose --profile core up -d
   ```

5. **Configure Services**
   - Access each service via web UI
   - Complete initial setup wizards
   - Configure indexers and download clients

### Service Integration

1. **Connect Arr Services to Prowlarr**
   - Add Prowlarr as indexer source
   - Configure API keys

2. **Connect to Download Clients**
   - Configure qBittorrent/NZBGet credentials
   - Set up categories and paths

3. **Configure Plex Libraries**
   - Add media folders
   - Set up library scanning

### NAS Migration (Media Storage Only)

When ready to migrate media libraries to NAS while keeping server data local:

1. **Mount NAS Storage**
   ```powershell
   # Mount NAS (example using SMB/CIFS)
   # Create mount point first
   mkdir C:\mnt\nas\media -Force

   # Mount using net use (for SMB shares)
   net use Z: \\nas-server\media /persistent:yes

   # Or use PowerShell to map network drive
   New-PSDrive -Name "NASMedia" -PSProvider FileSystem -Root "\\nas-server\media" -Persist
   ```

2. **Copy Existing Media**
   ```powershell
   # Copy media to NAS (preserve structure)
   robocopy .\media\ Z:\media /MIR /COPYALL /DCOPY:T

   # Alternative using PowerShell
   Copy-Item -Path .\media\* -Destination Z:\media -Recurse -Force
   ```

3. **Update Docker Compose Volumes**
   ```yaml
   # In docker-compose.yml, change media volume mappings:
   volumes:
     # Keep these LOCAL
     - ./config:/config
     - ./downloads:/downloads
     - ./transcode:/transcode

     # Change these to NAS
     - /mnt/nas/media/movies:/movies    # was ./media/movies:/movies
     - /mnt/nas/media/tv:/tv            # was ./media/tv:/tv
     - /mnt/nas/media/music:/music      # was ./media/music:/music
     - /mnt/nas/media/photos:/photos    # was ./media/photos:/photos
   ```

4. **Update Environment Variables**
   ```bash
   # In .env file
   MOVIES_PATH=/mnt/nas/media/movies
   TV_PATH=/mnt/nas/media/tv
   MUSIC_PATH=/mnt/nas/media/music
   PHOTOS_PATH=/mnt/nas/media/photos
   ```

5. **Restart Services**
   ```powershell
   # Using Makefile
   make down
   make up-d

   # Or directly
   docker compose down
   docker compose up -d
   ```

6. **Rescan Plex Libraries**
   - Access Plex web UI
   - Navigate to each library settings
   - Trigger "Scan Library Files" and "Refresh Metadata"

**Important Notes:**
- Downloads and transcode directories **remain local** for performance
- Only media libraries move to NAS
- NAS should be mounted before starting containers
- Consider NAS backup strategy for media files

## Maintenance and Monitoring

### Backup Strategy
- **Configurations**: Daily backup of `/config` directories
- **Media**: Weekly incremental backups
- **Automation**: Cron jobs for automated backups

### Monitoring
- **Health Checks**: Docker health checks for all services
- **Logs**: Centralized logging with Dozzle or similar
- **Metrics**: Uptime monitoring with Uptime Kuma

### Updates
- **Automated**: Watchtower for container updates
- **Manual**: Test updates in staging environment
- **Backup**: Always backup before major updates

### Troubleshooting
- **Logs**: `make logs` or `docker compose logs <service>`
- **Network**: `docker network inspect plex-stack`
- **Disk Space**: Monitor storage usage
- **VPN**: Verify kill switch functionality
- **Stop Services**: `make down`
- **Restart Services**: `make restart`

## Future Enhancements

### Additional Services
- **Jellyfin/Emby**: Alternative media servers
- **Calibre**: E-book management
- **Photoprism**: Photo management
- **Home Assistant**: Smart home integration

### Advanced Features
- **GPU Transcoding**: Hardware acceleration
- **Multi-Site**: Distributed storage
- **CDN**: Content delivery network
- **Analytics**: Detailed usage statistics

### Scalability
- **Load Balancing**: Multiple instances
- **Database**: External PostgreSQL
- **Caching**: Redis for performance
- **Orchestration**: Kubernetes migration path
