# Phase 7: Advanced Services (Optional)

This phase adds optional advanced services including torrent and usenet download capabilities, media transcoding, and subtitle management. These services enhance your media stack but are not required for basic functionality.

## Collaborative Implementation Notes

When working through this phase with the AI assistant:

### Agent Guidance
- **Service Evaluation**: The agent will help you decide which advanced services fit your needs
- **Content Acquisition Setup**: Guidance for configuring torrent/Usenet clients with VPN protection
- **Transcoding Configuration**: Help setting up media transcoding with hardware acceleration if available
- **Integration Testing**: Verification that advanced services work with your existing stack

### What You'll Need to Provide
- **Content Sources**: Your preferences for torrent vs Usenet or both
- **Hardware Capabilities**: Information about GPU availability for transcoding acceleration
- **Quality Requirements**: Your transcoding quality and format preferences
- **Resource Allocation**: How much CPU/memory you're willing to allocate to advanced services

### Interactive Process
- **Requirements Assessment**: The agent will help evaluate if your system can handle advanced services
- **VPN Integration**: Careful setup of VPN protection for download services
- **Performance Tuning**: Together you'll optimize settings based on your hardware capabilities
- **Usage Monitoring**: The agent will help monitor resource usage and adjust configurations

## Advanced Services Overview `PLANNED`

Optional services to consider:
- **qBittorrent**: Torrent downloading with VPN integration
- **NZBGet**: Usenet downloading with VPN integration
- **Tdarr**: Automated media transcoding and optimization
- **Bazarr**: Automated subtitle downloading

**Note**: Update status to `COMPLETED` after reviewing available advanced services and deciding which ones to implement.

## Content Acquisition Services `PLANNED`

### qBittorrent with VPN Integration

#### Deploy qBittorrent
```bash
# Deploy torrent services with VPN
docker compose --profile torrent up -d

# Verify services are running
docker compose --profile torrent ps

# Expected services: qbittorrent, wireguard (VPN)
```

#### qBittorrent Initial Configuration
```bash
# Access qBittorrent web interface
echo "qBittorrent: http://$(hostname -I | awk '{print $1}'):8080"
echo "Default credentials: admin / adminadmin"

# IMPORTANT: Change default password immediately
```

#### qBittorrent Settings
1. **Web UI Configuration**
   - Change default username/password
   - Set web UI port (8080)
   - Enable HTTPS if desired

2. **Download Directories**
   - Default save path: `/downloads`
   - Create subdirectories for organization:
     - `/downloads/movies`
     - `/downloads/tv`
     - `/downloads/music`

3. **Connection Settings**
   - Global maximum number of connections: 500
   - Maximum number of connections per torrent: 100
   - Global upload slots: 20

4. **Speed Limits** (adjust based on your internet)
   - Upload: 80-90% of max speed
   - Download: Unlimited (or set to 90% of max)

5. **Privacy Settings**
   - Enable IP filtering
   - Enable peer cache
   - Disable DHT, PeX, and LSD (if privacy is priority)

#### VPN Integration Testing
```bash
# Verify qBittorrent uses VPN
docker compose --profile torrent exec qbittorrent curl -s https://ipinfo.io/ip

# Check if IP matches your VPN endpoint
# Should NOT be your real IP address
```

#### qBittorrent Reverse Proxy Setup
```bash
# Add to Nginx Proxy Manager
# Domain: qbittorrent.yourdomain.com
# Forward to: http://qbittorrent:8080
# SSL: Enable
# Access List: Admin Only (basic auth)
```

### NZBGet with VPN Integration (Alternative to Torrents)

#### Deploy NZBGet
```bash
# Deploy usenet services with VPN
docker compose --profile usenet up -d

# Verify services are running
docker compose --profile usenet ps
```

#### NZBGet Configuration
```bash
# Access NZBGet web interface
echo "NZBGet: http://$(hostname -I | awk '{print $1}'):6789"

# Default credentials: nzbget / tegbzn6789
```

#### NZBGet Settings
1. **Security Settings**
   - Change default password
   - Set control username/password

2. **Path Configuration**
   - MainDir: `/downloads`
   - DestDir: `${MainDir}/complete`
   - InterDir: `${MainDir}/intermediate`

3. **News Server Configuration**
   - Add your Usenet provider details
   - Configure multiple servers for redundancy
   - Set appropriate connection limits

4. **Download Categories**
   - Movies: `/downloads/movies`
   - TV: `/downloads/tv`
   - Music: `/downloads/music`

**Note**: Update status to `COMPLETED` after configuring qBittorrent and/or NZBGet with VPN integration and initial settings.

## Connect Download Clients to Management Services `PLANNED`

### Configure qBittorrent in Radarr/Sonarr

#### Radarr Download Client Setup
1. **Add qBittorrent**
   - Settings → Download Clients → Add qBittorrent
   - Host: `qbittorrent`
   - Port: `8080`
   - Username/Password: (your configured credentials)

2. **Download Client Settings**
   - Category: `movies`
   - Recent Priority: Enable
   - Older Priority: Enable
   - Initial State: Forced

#### Sonarr Download Client Setup
1. **Add qBittorrent**
   - Settings → Download Clients → Add qBittorrent
   - Same configuration as Radarr

2. **Category Settings**
   - Category: `tv`
   - Season Folder: Yes
   - Series Folder: Yes

### Configure NZBGet in Radarr/Sonarr (if using Usenet)

#### Radarr NZBGet Setup
```bash
# Settings → Download Clients → Add NZBGet
# Host: nzbget
# Port: 6789
# Username/Password: (your NZBGet credentials)
# Category: movies
```

#### Sonarr NZBGet Setup
```bash
# Same configuration as Radarr but with TV category
# Category: tv
```

**Note**: Update status to `COMPLETED` after connecting qBittorrent and NZBGet to Radarr and Sonarr for automated downloading.

## Media Processing Services `PLANNED`

### Tdarr Media Transcoding

#### Deploy Tdarr
```bash
# Deploy transcoding services
docker compose --profile advanced up -d tdarr

# Verify Tdarr is running
docker compose --profile advanced ps tdarr
```

#### Tdarr Initial Setup
```bash
# Access Tdarr web interfaces
echo "Tdarr Web UI: http://$(hostname -I | awk '{print $1}'):8265"
echo "Tdarr Server: http://$(hostname -I | awk '{print $1}'):8266"

# Complete initial setup wizard
```

#### Tdarr Library Configuration
1. **Add Media Libraries**
   - Movies: `/media/movies`
   - TV: `/media/tv`

2. **Create Transcode Libraries**
   - Set up different quality profiles
   - Configure codecs (H.264/H.265)
   - Set size limits

3. **Worker Configuration**
   - Number of workers: Based on CPU cores
   - GPU acceleration: Enable if NVIDIA GPU available
   - Temporary files: `/temp`

#### Tdarr Reverse Proxy
```bash
# Add to Nginx Proxy Manager
# Domain: tdarr.yourdomain.com
# Forward to: http://tdarr:8265
# SSL: Enable
# Access List: Admin Only
```

### Bazarr Subtitle Management

#### Deploy Bazarr (if not already included)
```bash
# Deploy subtitle services
docker compose --profile advanced up -d bazarr

# Verify Bazarr is running
docker compose --profile advanced ps bazarr
```

#### Bazarr Configuration
```bash
# Access Bazarr web interface
echo "Bazarr: http://$(hostname -I | awk '{print $1}'):6767"

# Complete setup wizard
```

#### Bazarr Settings
1. **Add Media Libraries**
   - Movies: `/media/movies`
   - TV: `/media/tv`

2. **Language Configuration**
   - Set preferred subtitle languages
   - Configure audio languages

3. **Subtitle Providers**
   - Add OpenSubtitles, Addic7ed, etc.
   - Configure API keys if required

4. **Integration Settings**
   - Enable Sonarr/Radarr integration
   - Set up automatic subtitle searching

**Note**: Update status to `COMPLETED` after configuring Tdarr for transcoding and Bazarr for subtitle management.

## Service Integration Testing `PLANNED`

### Download Pipeline Testing

#### Test Torrent Download
1. **Manual Torrent Download**
   - Add a test torrent in qBittorrent
   - Verify download completes
   - Check file appears in correct directory

2. **Radarr Torrent Integration**
   - Add a movie in Radarr
   - Verify torrent is sent to qBittorrent
   - Confirm download and import work

3. **Sonarr Torrent Integration**
   - Add a TV show in Sonarr
   - Test episode download
   - Verify proper categorization

#### Test Usenet Download (if configured)
1. **Manual NZB Download**
   - Add test NZB in NZBGet
   - Verify download and extraction

2. **Integration Testing**
   - Test with Radarr/Sonarr
   - Verify proper file handling

### Transcoding Pipeline Testing

#### Tdarr Testing
1. **Add Test File**
   - Place a test video file in media library
   - Configure Tdarr to process it
   - Monitor transcoding progress

2. **Quality Verification**
   - Check output file quality
   - Verify Plex recognizes transcoded file

### Subtitle Testing

#### Bazarr Integration
1. **Test Subtitle Download**
   - Ensure media files have embedded subtitles or none
   - Trigger Bazarr scan
   - Verify subtitles are downloaded and attached

**Note**: Update status to `COMPLETED` after testing download pipelines, transcoding, and subtitle functionality.

## Performance and Resource Management `PLANNED`

### Resource Monitoring
```bash
# Monitor advanced services resource usage
docker stats $(docker compose --profile advanced --profile torrent --profile usenet ps -q)

# Check disk space during downloads/transcoding
df -h

# Monitor CPU/GPU usage during transcoding
nvidia-smi  # If using GPU
```

### Service Optimization

#### qBittorrent Performance Tuning
```bash
# Optimize for your hardware
# Settings → Advanced:
# - Disk write cache: Increase if SSD
# - Disk cache: 64-128 MB
# - Disk queue size: 1024-2048
```

#### Tdarr Performance Configuration
```bash
# Adjust based on hardware:
# - CPU workers: Number of CPU cores - 1
# - GPU workers: 1 (if GPU available)
# - Concurrent limits: Based on RAM
```

**Note**: Update status to `COMPLETED` after configuring performance settings and resource management for advanced services.

## Security Considerations for Advanced Services `PLANNED`

### VPN Kill Switch Verification
```bash
# Test kill switch functionality
# Temporarily disable VPN and verify no traffic leaks

# Check iptables rules
sudo iptables -L | grep wg0

# Monitor network traffic
sudo tcpdump -i any port 6881 2>/dev/null | head -10  # Bittorrent port
```

### Access Control
```bash
# Ensure download clients are not exposed publicly
# Only accessible through VPN or behind authentication

# Verify firewall rules
sudo ufw status | grep 8080  # qBittorrent
sudo ufw status | grep 6789  # NZBGet
```

### API Security
```bash
# Use strong passwords for download clients
# Enable IP filtering in qBittorrent
# Configure proper authentication in NZBGet
```

**Note**: Update status to `COMPLETED` after implementing security measures for advanced services including VPN protection and access controls.

## Backup Advanced Configurations `PLANNED`

```bash
# Create advanced services backup
BACKUP_DIR="temp/backups/advanced-$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

# Backup service configurations
cp -r config/qbittorrent "$BACKUP_DIR/" 2>/dev/null || true
cp -r config/nzbget "$BACKUP_DIR/" 2>/dev/null || true
cp -r config/tdarr "$BACKUP_DIR/" 2>/dev/null || true
cp -r config/bazarr "$BACKUP_DIR/" 2>/dev/null || true

echo "Advanced services backup created in: $BACKUP_DIR"
```

## Troubleshooting Advanced Services

### Common Issues

**Download client connection failures:**
```bash
# Test connectivity from Radarr/Sonarr
docker compose --profile core exec radarr curl http://qbittorrent:8080

# Check service logs
docker compose --profile torrent logs qbittorrent

# Verify credentials and network
```

**VPN issues with downloads:**
```bash
# Check VPN status
docker compose --profile torrent logs wireguard

# Test VPN connectivity
docker compose --profile torrent exec qbittorrent ping 8.8.8.8

# Verify kill switch rules
sudo iptables -L | grep DROP
```

**Transcoding failures:**
```bash
# Check Tdarr logs
docker compose --profile advanced logs tdarr

# Verify hardware acceleration
docker compose --profile advanced exec tdarr nvidia-smi

# Test file permissions
docker compose --profile advanced exec tdarr ls -la /media/
```

**Subtitle download issues:**
```bash
# Check Bazarr logs
docker compose --profile advanced logs bazarr

# Test subtitle provider connectivity
docker compose --profile advanced exec bazarr curl https://www.opensubtitles.org/

# Verify file permissions for subtitle writing
```

### Recovery Procedures
```bash
# Restart download services
docker compose --profile torrent restart

# Reset download client configurations
docker compose --profile torrent down
sudo rm -rf config/qbittorrent/*
docker compose --profile torrent up -d

# Rebuild transcoding services
docker compose --profile advanced up -d --build tdarr
```

**Note**: Update status to `COMPLETED` after creating backups of all advanced service configurations.

## Advanced Services Validation Checklist `PLANNED`

- [ ] qBittorrent deployed and VPN-integrated `PLANNED`
- [ ] NZBGet configured (if using Usenet) `PLANNED`
- [ ] Download clients connected to Radarr/Sonarr `PLANNED`
- [ ] Tdarr transcoding configured `PLANNED`
- [ ] Bazarr subtitle management set up `PLANNED`
- [ ] Download pipeline tested end-to-end `PLANNED`
- [ ] Transcoding functionality verified `PLANNED`
- [ ] VPN kill switch working `PLANNED`
- [ ] Security configurations applied `PLANNED`
- [ ] Resource usage monitored `PLANNED`

**Note**: Update status to `COMPLETED` after verifying all advanced services checklist items are satisfied and all optional services are properly configured.

## Next Steps

With advanced services configured, your media stack is feature-complete. Proceed to [Phase 8: NAS Migration (Optional)](../SETUP-8-NAS-Migration.md) if you want to move media storage to NAS, or go directly to [Phase 9: Testing and Validation](../SETUP-9-Testing-Validation.md).

## Advanced Services Maintenance

### Regular Tasks
- Monitor download client performance
- Clean up completed downloads
- Review transcoding quality settings
- Update subtitle language preferences
- Monitor VPN connection stability

### Performance Tuning
```bash
# Create performance monitoring script
cat > shared/scripts/monitor-advanced.sh << 'EOF'
#!/bin/bash
echo "=== Advanced Services Performance ==="

# Download client status
echo "Download Clients:"
docker compose --profile torrent ps --format "table {{.Name}}\t{{.Status}}"

# Transcoding status
echo -e "\nTranscoding Status:"
docker compose --profile advanced ps tdarr --format "table {{.Name}}\t{{.Status}}"

# Resource usage
echo -e "\nResource Usage:"
docker stats --no-stream --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}"

# VPN status
echo -e "\nVPN Status:"
if docker compose --profile torrent exec -T wireguard wg show | grep -q "latest handshake"; then
    echo "✓ VPN connected"
else
    echo "✗ VPN connection issue"
fi
EOF

chmod +x shared/scripts/monitor-advanced.sh
```
