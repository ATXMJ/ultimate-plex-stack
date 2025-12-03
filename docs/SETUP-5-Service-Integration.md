# Phase 5: Service Configuration and Integration

This phase configures each core service individually and establishes the connections between them to create a fully functional media management pipeline.

## Collaborative Implementation Notes

When working through this phase with the AI assistant:

### Agent Guidance
- **Service-by-Service Setup**: The agent will guide you through configuring each service individually
- **Web Interface Access**: Help accessing and navigating each service's web interface
- **API Integration**: Step-by-step setup of connections between services (Prowlarr to Radarr/Sonarr, etc.)
- **Pipeline Testing**: Verification that the complete media acquisition pipeline works

### What You'll Need to Provide
- **Service Preferences**: Your preferred media quality profiles, language settings, and naming conventions
- **API Keys**: Any required API keys for indexers or external services
- **Media Organization**: Your preferences for media library organization and naming
- **Quality Settings**: Your desired quality profiles and release preferences

### Interactive Process
- **Interface Navigation**: The agent will guide you through each web interface configuration
- **Credential Management**: Help securely storing and managing API keys and passwords
- **Integration Verification**: Testing each service connection as you configure it
- **Workflow Testing**: Together you'll test complete workflows (request → download → library addition)

## Service Configuration Order `PLANNED`

Configure services in this order to ensure proper integration:
1. **Plex Media Server** - Core streaming service
2. **Prowlarr** - Indexer management (needed by Radarr/Sonarr)
3. **Radarr** - Movie automation
4. **Sonarr** - TV show automation
5. **Overseerr** - Request management

## Plex Media Server Configuration `PLANNED`

### Initial Plex Setup
```bash
# Ensure Plex is running
docker compose --profile core ps plex

# Get Plex web interface URL
echo "Access Plex at: http://$(hostname -I | awk '{print $1}'):32400/web"
```

### Plex Claim and Account Setup
1. **Access Plex Web Interface**
   - Open http://your-server-ip:32400/web
   - Sign in with your Plex account
   - The claim token from your .env file should automatically activate

2. **Verify Claim Success**
```bash
# Check Plex logs for successful claim
docker compose --profile core logs plex | grep -i claim
```

### Plex Library Configuration
1. **Add Media Libraries**
   - Movies: `/movies` (maps to `./media/movies`)
   - TV Shows: `/tv` (maps to `./media/tv`)
   - Music: `/music` (maps to `./media/music`)
   - Photos: `/photos` (maps to `./media/photos`)

2. **Library Settings**
   - Enable "Scan my library automatically"
   - Enable "Run a partial scan when changes are detected"
   - Set scanner to "Plex Series Scanner" for TV shows
   - Set agent to "The Movie Database" for movies

### Plex Network Configuration
```bash
# Verify Plex can access media directories
docker compose --profile core exec plex ls -la /media/movies
docker compose --profile core exec plex ls -la /tv
```

## Prowlarr Indexer Configuration `PLANNED`

### Initial Prowlarr Setup
```bash
# Access Prowlarr web interface
echo "Access Prowlarr at: http://$(hostname -I | awk '{print $1}'):9696"

# Default credentials (change immediately)
# Username: admin
# Password: (check logs for generated password)
docker compose --profile core logs prowlarr | grep -i password
```

### Add Indexers to Prowlarr
1. **Configure Indexer Categories**
   - Go to Settings → Indexers
   - Add popular indexers (based on your region/preferences):
     - 1337x
     - RARBG
     - The Pirate Bay
     - YTS
     - EZTV (for TV)

2. **Indexer Settings**
   - Enable RSS sync
   - Set minimum seeders (recommended: 1-5)
   - Configure rate limits appropriately

3. **Test Indexers**
   - Use the test function for each indexer
   - Verify RSS feeds are working

### Prowlarr API Key Generation
```bash
# Get Prowlarr API key from Settings → General
# This will be needed for Radarr/Sonarr integration
echo "Copy the API Key from Prowlarr Settings → General"
```

## Radarr Configuration `PLANNED`

### Initial Radarr Setup
```bash
# Access Radarr web interface
echo "Access Radarr at: http://$(hostname -I | awk '{print $1}'):7878"

# Complete initial setup wizard
# - Choose your preferred language
# - Enable analytics (optional)
```

### Radarr Media Management Setup
1. **Add Root Folder**
   - Path: `/movies` (container path)
   - This maps to `./media/movies` on host

2. **Quality Profiles**
   - Create profiles for different quality preferences
   - Recommended: HD-1080p, HD-720p, SD

3. **Configure Download Client** (will be added after torrent client setup)
   - Skip for now, will configure in Phase 7

### Connect Radarr to Prowlarr
1. **Add Prowlarr as Indexer**
   - Settings → Indexers → Add Indexer
   - Choose "Prowlarr"
   - Prowlarr Server: `http://prowlarr:9696`
   - API Key: (from Prowlarr settings)

2. **Sync Indexers**
   - Settings → Indexers
   - Click "Sync" to import indexers from Prowlarr

### Radarr Categories and Paths
```bash
# Configure download paths (will be used when download clients are added)
# Movies: downloads/movies
# Completed: downloads/complete/movies
```

## Sonarr Configuration `PLANNED`

### Initial Sonarr Setup
```bash
# Access Sonarr web interface
echo "Access Sonarr at: http://$(hostname -I | awk '{print $1}'):8989"

# Complete initial setup wizard
# - Choose your preferred language
# - Enable analytics (optional)
```

### Sonarr Media Management Setup
1. **Add Root Folder**
   - Path: `/tv` (container path)
   - This maps to `./media/tv` on host

2. **Quality Profiles**
   - Create profiles for TV shows
   - Recommended: HD-1080p, HD-720p, SD, WEB-DL

3. **Configure Download Client** (will be added after torrent client setup)
   - Skip for now

### Connect Sonarr to Prowlarr
1. **Add Prowlarr as Indexer**
   - Settings → Indexers → Add Indexer
   - Choose "Prowlarr"
   - Prowlarr Server: `http://prowlarr:9696`
   - API Key: (from Prowlarr settings)

2. **Sync Indexers**
   - Settings → Indexers
   - Click "Sync" to import TV-focused indexers

### Sonarr Release Profiles (Optional)
- Configure preferred release groups
- Set up delay profiles for better quality releases

## Overseerr Configuration `PLANNED`

### Initial Overseerr Setup
```bash
# Access Overseerr web interface
echo "Access Overseerr at: http://$(hostname -I | awk '{print $1}'):5055"

# Choose authentication method:
# Option 1: Plex OAuth (recommended)
# Option 2: Local users
```

### Connect Overseerr to Plex
1. **Plex Integration**
   - Sign in with Plex account
   - Authorize Overseerr access
   - Select Plex server

2. **Configure Libraries**
   - Enable movies and TV shows libraries
   - Set appropriate permissions

### Overseerr Settings
1. **General Settings**
   - Set server name
   - Configure notifications (optional)

2. **Users and Permissions**
   - Set up user access levels
   - Configure request limits

## Service Integration Testing `PLANNED`

### Test Prowlarr Connectivity
```bash
# Test Prowlarr API from Radarr/Sonarr containers
docker compose --profile core exec radarr curl -s http://prowlarr:9696/api/v1/system/status
docker compose --profile core exec sonarr curl -s http://prowlarr:9696/api/v1/system/status

# Test indexer sync
docker compose --profile core exec radarr curl -s "http://prowlarr:9696/api/v1/indexer" -H "X-Api-Key: YOUR_API_KEY"
```

### Test Plex Integration
```bash
# Verify Plex can scan libraries
docker compose --profile core exec plex ls -la /media/

# Test Plex API (if enabled)
curl -s "http://plex:32400/library/sections" -H "X-Plex-Token: YOUR_PLEX_TOKEN" | head -5
```

### Cross-Service Communication
```bash
# Test service-to-service connectivity
docker compose --profile core exec radarr ping -c 2 plex
docker compose --profile core exec sonarr ping -c 2 overseerr
docker compose --profile core exec overseerr ping -c 2 prowlarr
```

## Media Pipeline Testing `PLANNED`

### Manual Media Addition Test
1. **Add Test Movie in Radarr**
   - Search for a popular movie
   - Add it to your library
   - Verify it appears in Plex (once download client is configured)

2. **Add Test TV Show in Sonarr**
   - Search for a popular TV series
   - Add it to your library
   - Configure season/episode monitoring

3. **Test Overseerr Request**
   - Request a movie or TV show
   - Verify it appears in Radarr/Sonarr

### Library Scanning Verification
```bash
# Manually trigger Plex library scans
curl -X POST "http://plex:32400/library/sections/1/refresh" -H "X-Plex-Token: YOUR_TOKEN"

# Check Plex logs for scan activity
docker compose --profile core logs -f plex | grep -i scan
```

## Configuration Backup `PLANNED`

### Save Service Configurations
```bash
# Create integration backup
BACKUP_DIR="temp/backups/integration-$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

# Backup service configurations
cp -r config/plex "$BACKUP_DIR/"
cp -r config/radarr "$BACKUP_DIR/"
cp -r config/sonarr "$BACKUP_DIR/"
cp -r config/prowlarr "$BACKUP_DIR/"
cp -r config/overseerr "$BACKUP_DIR/"

# Backup Docker Compose state
docker compose --profile core config > "$BACKUP_DIR/docker-compose-core.yml"

echo "Integration backup created in: $BACKUP_DIR"
```

## Performance and Resource Monitoring `PLANNED`

### Service Resource Usage
```bash
# Monitor container resources during scanning/processing
docker stats --format "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}"

# Check disk I/O during library scans
iotop -o -b -n 5

# Monitor network usage
nload
```

### Log Analysis
```bash
# Monitor for integration-related errors
docker compose --profile core logs --since "1h" | grep -i error

# Check for successful API communications
docker compose --profile core logs radarr | grep -i prowlarr
docker compose --profile core logs sonarr | grep -i prowlarr
```

## Troubleshooting Integration Issues

### Common Integration Problems

**Prowlarr connection failures:**
```bash
# Test Prowlarr API directly
curl -H "X-Api-Key: YOUR_API_KEY" http://localhost:9696/api/v1/system/status

# Check Prowlarr logs
docker compose --profile core logs prowlarr

# Verify API key
docker compose --profile core exec prowlarr cat /config/config.xml | grep ApiKey
```

**Plex library scanning issues:**
```bash
# Check Plex permissions on media directories
docker compose --profile core exec plex ls -la /media/

# Test file access
docker compose --profile core exec plex find /media/ -name "*.mkv" | head -5

# Check Plex logs for scan errors
docker compose --profile core logs plex | grep -i error
```

**Service communication failures:**
```bash
# Test internal networking
docker compose --profile core exec radarr ping prowlarr

# Check service names in /etc/hosts
docker compose --profile core exec radarr cat /etc/hosts

# Verify Docker network
docker network inspect ultimate-plex-stack_plex-stack
```

**Overseerr authentication issues:**
```bash
# Check Overseerr logs for Plex integration errors
docker compose --profile core logs overseerr | grep -i plex

# Verify Plex token permissions
# Test token validity through Plex API
```

### Recovery Procedures
```bash
# Restart services in dependency order
docker compose --profile core restart prowlarr
docker compose --profile core restart radarr sonarr
docker compose --profile core restart overseerr
docker compose --profile core restart plex

# Rebuild specific services if needed
docker compose --profile core up -d --build prowlarr

# Reset service configurations (CAUTION: loses settings)
docker compose --profile core down
sudo rm -rf config/radarr/* config/sonarr/* config/prowlarr/*
docker compose --profile core up -d
```

## Integration Validation Checklist `PLANNED`

- [ ] Plex Media Server claimed and libraries configured `PLANNED`
- [ ] Prowlarr indexers configured and tested `PLANNED`
- [ ] Radarr connected to Prowlarr and media folders set `PLANNED`
- [ ] Sonarr connected to Prowlarr and media folders set `PLANNED`
- [ ] Overseerr connected to Plex and configured `PLANNED`
- [ ] Cross-service communication verified `PLANNED`
- [ ] Manual media addition tested `PLANNED`
- [ ] Library scanning working `PLANNED`
- [ ] Service configurations backed up `PLANNED`

## Next Steps

With core services configured and integrated, proceed to [Phase 6: Security and Network Setup](../SETUP-6-Security-Network.md) to secure access and set up the reverse proxy.

## Maintenance Notes

### Regular Integration Checks
```bash
# Create integration monitoring script
cat > shared/scripts/check-integration.sh << 'EOF'
#!/bin/bash
echo "=== Service Integration Status ==="

# Test Prowlarr connectivity
if curl -s http://localhost:9696/api/v1/system/status > /dev/null; then
    echo "✓ Prowlarr: Accessible"
else
    echo "✗ Prowlarr: Not accessible"
fi

# Test Plex accessibility
if curl -s http://localhost:32400/web > /dev/null; then
    echo "✓ Plex: Accessible"
else
    echo "✗ Plex: Not accessible"
fi

# Test Radarr/Sonarr API
if curl -s http://localhost:7878/api/v3/system/status > /dev/null; then
    echo "✓ Radarr: API responding"
else
    echo "✗ Radarr: API not responding"
fi

echo "Integration check complete"
EOF

# On Windows, scripts are executable by default
```

### Update Procedures
- Regularly update indexer lists in Prowlarr
- Keep Plex libraries organized and scanned
- Monitor Overseerr for user requests
- Review and optimize quality profiles as needed
