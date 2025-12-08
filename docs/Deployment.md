# Deployment Instructions

## Prerequisites
1. Windows 11 Pro host with Docker Desktop
2. Sufficient storage space (see [Storage Architecture](Storage.md))
3. VPN service subscription (required only if using torrent/usenet clients)
4. Domain name (optional, for reverse proxy)

## Initial Setup

### 1. Clone Repository
```powershell
git clone https://github.com/DonMcD/ultimate-plex-stack.git
cd ultimate-plex-stack
```

### 2. Configure Environment
```bash
cp .env.example .env
# Edit .env with your values
```

### 3. Create Directory Structure
```powershell
# Create local directories for server data
mkdir config, downloads, transcode -Force

# Create initial local media directories (will migrate to NAS later)
mkdir media\movies, media\tv -Force
```

### 4. Deploy Services
```powershell
# Using Makefile (recommended)
make up-d

# Or directly with Docker Compose
docker compose --profile core up -d
```

### 5. Configure Services
- Access each service via web UI
- Complete initial setup wizards
- Configure indexers and download clients

## Service Integration

### 1. VPN Configuration (if using torrent/usenet)
- Configure VPN credentials in `.env` file or VPN container config
- VPN is configured **once in the VPN container only**
- qBittorrent and NZBGet require **NO VPN configuration** - they automatically route through VPN via Docker networking
- Verify VPN connection before starting download clients

### 2. Connect Arr Services to Prowlarr
- Add Prowlarr as indexer source
- Configure API keys

### 3. Connect to Download Clients
- Configure qBittorrent/NZBGet credentials in Radarr/Sonarr
- Set up categories and paths
- **Note**: Radarr/Sonarr connect to clients via VPN container's exposed ports
- No VPN settings needed in arr services or download clients

### 4. Configure Plex Libraries
- Add media folders
- Set up library scanning

## NAS Migration (Media Storage Only)

When ready to migrate media libraries to NAS while keeping server data local:

### 1. Mount NAS Storage
```powershell
# Mount NAS (example using SMB/CIFS)
# Create mount point first
mkdir C:\mnt\nas\media -Force

# Mount using net use (for SMB shares)
net use Z: \\nas-server\media /persistent:yes

# Or use PowerShell to map network drive
New-PSDrive -Name "NASMedia" -PSProvider FileSystem -Root "\\nas-server\media" -Persist
```

### 2. Copy Existing Media
```powershell
# Copy media to NAS (preserve structure)
robocopy .\media\ Z:\media /MIR /COPYALL /DCOPY:T

# Alternative using PowerShell
Copy-Item -Path .\media\* -Destination Z:\media -Recurse -Force
```

### 3. Update Docker Compose Volumes
```yaml
# In docker-compose.yml, change media volume mappings:
volumes:
  # Keep these LOCAL
  - ./config:/config
  - ./downloads:/downloads
  - ./transcode:/transcode

  # Change these to NAS
  - /mnt/gargantua/media/movies:/movies    # was ./media/movies:/movies
  - /mnt/gargantua/media/tv:/tv            # was ./media/tv:/tv
```

### 4. Update Environment Variables
```bash
# In .env file
MOVIES_PATH=/mnt/gargantua/media/movies
TV_PATH=/mnt/gargantua/media/tv
```

### 5. Restart Services
```powershell
# Using Makefile
make down
make up-d

# Or directly
docker compose down
docker compose up -d
```

### 6. Rescan Plex Libraries
- Access Plex web UI
- Navigate to each library settings
- Trigger "Scan Library Files" and "Refresh Metadata"

**Important Notes:**
- Downloads and transcode directories **remain local** for performance
- Only media libraries move to NAS
- NAS should be mounted before starting containers
- Consider NAS backup strategy for media files

