# Phase 4: Core Services Deployment

This phase deploys the core media management services using Docker Compose, starting with essential services and verifying their proper startup and connectivity.

## Collaborative Implementation Notes

When working through this phase with the AI assistant:

### Agent Guidance
- **Service Deployment**: The agent will guide you through deploying services with Docker Compose profiles
- **Startup Monitoring**: Real-time monitoring of service startup and log analysis
- **Connectivity Testing**: Help verifying inter-service communication and network connectivity
- **Health Validation**: Step-by-step health checks for each deployed service

### What You'll Need to Provide
- **Deployment Preferences**: Whether you want to include optional services initially
- **Resource Monitoring**: Confirmation that your system can handle the deployed services
- **Access Preferences**: Your preferences for initial service access (local vs remote)

### Interactive Process
- **Paced Deployment**: The agent will deploy services incrementally, allowing you to verify each step
- **Log Analysis**: Together you'll review service logs for any issues or required configurations
- **Performance Monitoring**: The agent will help monitor system resources during deployment
- **Troubleshooting**: If services fail to start, the agent will guide you through diagnosis and fixes

## Core Services Overview `PLANNED`

The core profile includes essential services for media streaming and management:

- **Plex Media Server**: Primary media streaming and library management
- **Radarr**: Automated movie downloading and management
- **Sonarr**: Automated TV show downloading and management
- **Prowlarr**: Centralized indexer management
- **Overseerr**: User request management and media discovery

## Pre-Deployment Verification `PLANNED`

### Environment Validation
```bash
# Ensure you're in the project directory
cd /path/to/ultimate-plex-stack

# Source environment variables
source .env

# Verify key variables are set
echo "PUID: $PUID, PGID: $PGID, TZ: $TZ"
echo "PLEX_CLAIM: ${PLEX_CLAIM:0:20}..."
echo "DOMAIN: $DOMAIN"
```

### Docker Status Check
```bash
# Verify Docker is running
docker --version
docker compose version

# Check Docker Desktop status
# Docker Desktop runs as a Windows service

# Verify Docker can run containers
docker run --rm hello-world
```

### Volume Mount Verification
```bash
# Test that all required directories exist and have correct permissions
ls -la config/ downloads/ media/ transcode/

# Quick permission test
docker run --rm \
  -v "$(pwd)/config:/test_config" \
  -v "$(pwd)/downloads:/test_downloads" \
  -v "$(pwd)/media:/test_media" \
  --user $PUID:$PGID \
  alpine touch /test_config/test /test_downloads/test /test_media/test
```

## Core Services Deployment `PLANNED`

### Deploy Core Services
```powershell
# Deploy services using the core profile
make up-d

# Alternative: Direct Docker Compose command
# docker compose --profile core up -d

# Monitor deployment progress
make logs

# Alternative: Direct command
# docker compose --profile core logs -f --tail=50
```

### Expected Services
After deployment, verify these services are running:
```bash
# List running core services
docker compose --profile core ps

# Expected output should show:
# - plex
# - radarr
# - sonarr
# - prowlarr
# - overseerr
```

## Service Startup Verification `PLANNED`

### Health Check Script
```bash
# Create health check script
cat > shared/scripts/health-check.sh << 'EOF'
#!/bin/bash
echo "=== Core Services Health Check ==="
echo "Timestamp: $(date)"
echo

SERVICES=("plex" "radarr" "sonarr" "prowlarr" "overseerr")
ALL_HEALTHY=true

for service in "${SERVICES[@]}"; do
    if docker compose --profile core ps $service | grep -q "Up"; then
        echo "✓ $service: RUNNING"
        # Get container IP for connectivity testing
        CONTAINER_IP=$(docker compose --profile core exec -T $service hostname -i 2>/dev/null || echo "N/A")
        echo "  Container IP: $CONTAINER_IP"
    else
        echo "✗ $service: NOT RUNNING"
        ALL_HEALTHY=false
    fi
    echo
done

if $ALL_HEALTHY; then
    echo "✓ All core services are healthy"
    exit 0
else
    echo "✗ Some services are not healthy"
    exit 1
fi
EOF

# On Windows, scripts are executable by default
# Run health check
.\shared\scripts\health-check.sh
```

### Service Logs Review
```bash
# Check for any startup errors in logs
echo "Checking for errors in service logs..."

# Plex logs
docker compose --profile core logs plex 2>&1 | grep -i error | tail -5

# Radarr logs
docker compose --profile core logs radarr 2>&1 | grep -i error | tail -5

# Sonarr logs
docker compose --profile core logs sonarr 2>&1 | grep -i error | tail -5

# Prowlarr logs
docker compose --profile core logs prowlarr 2>&1 | grep -i error | tail -5

# Overseerr logs
docker compose --profile core logs overseerr 2>&1 | grep -i error | tail -5
```

## Network Connectivity Testing `PLANNED`

### Internal Network Verification
```bash
# Verify Docker network creation
docker network ls | grep plex-stack

# Inspect network configuration
docker network inspect ultimate-plex-stack_plex-stack

# Test inter-service connectivity
docker compose --profile core exec plex ping -c 2 radarr
docker compose --profile core exec radarr ping -c 2 sonarr
```

### Port Availability Check
```bash
# Check that services are listening on expected ports
echo "Checking service ports..."

# Plex (32400)
docker compose --profile core exec -T plex netstat -tln | grep 32400

# Radarr (7878)
docker compose --profile core exec -T radarr netstat -tln | grep 7878

# Sonarr (8989)
docker compose --profile core exec -T sonarr netstat -tln | grep 8989

# Prowlarr (9696)
docker compose --profile core exec -T prowlarr netstat -tln | grep 9696

# Overseerr (5055)
docker compose --profile core exec -T overseerr netstat -tln | grep 5055
```

## Initial Service Access Testing `PLANNED`

### Web Interface Availability
```bash
# Test local access to web interfaces
echo "Testing web interface availability..."

# Plex (may require claim token setup first)
curl -I http://localhost:32400/web 2>/dev/null | head -1

# Radarr
curl -I http://localhost:7878 2>/dev/null | head -1

# Sonarr
curl -I http://localhost:8989 2>/dev/null | head -1

# Prowlarr
curl -I http://localhost:9696 2>/dev/null | head -1

# Overseerr
curl -I http://localhost:5055 2>/dev/null | head -1
```

### DNS Resolution Testing
```bash
# Test internal DNS resolution
docker compose --profile core exec plex nslookup radarr
docker compose --profile core exec radarr nslookup plex
docker compose --profile core exec sonarr nslookup prowlarr
```

## Configuration Directory Verification `PLANNED`

### Service Configuration Creation
```bash
# Check that configuration directories are populated
echo "Checking configuration directories..."

ls -la config/plex/
ls -la config/radarr/
ls -la config/sonarr/
ls -la config/prowlarr/
ls -la config/overseerr/

# Verify configuration files exist
find config/ -name "*.xml" -o -name "*.json" -o -name "*.db" | head -10
```

### Volume Mount Effectiveness
```bash
# Test that volume mounts are working by creating test files
docker compose --profile core exec plex touch /config/test_plex
docker compose --profile core exec radarr touch /config/test_radarr
docker compose --profile core exec sonarr touch /config/test_sonarr

# Verify files exist on host
ls -la config/plex/test_plex
ls -la config/radarr/test_radarr
ls -la config/sonarr/test_sonarr

# Clean up test files
rm config/plex/test_plex config/radarr/test_radarr config/sonarr/test_sonarr
```

## Resource Usage Monitoring `PLANNED`

### Initial Resource Check
```bash
# Check container resource usage
docker stats --no-stream --format "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}"

# Check Docker system resource usage
docker system df

# Check host system resources
echo "Host CPU/Memory usage:"
top -bn1 | head -5
```

### Log Size Monitoring
```bash
# Check log sizes (should be reasonable initially)
echo "Container log sizes:"
docker compose --profile core ps -q | xargs docker inspect --format='{{.Name}}: {{.LogPath}}' | xargs ls -lh | awk '{print $5, $9}'
```

## Service-Specific Initial Setup `PLANNED`

### Plex Media Server
```bash
# Check Plex claim status
docker compose --profile core logs plex | grep -i claim

# Verify Plex directories are accessible
docker compose --profile core exec plex ls -la /config
docker compose --profile core exec plex ls -la /media
```

### Radarr/Sonarr Initial State
```bash
# Check if services are ready for configuration
curl -s http://localhost:7878/api/v3/system/status | head -5
curl -s http://localhost:8989/api/v3/system/status | head -5
```

### Prowlarr Indexer Setup
```bash
# Verify Prowlarr is accessible
curl -s http://localhost:9696/api/v1/system/status | head -5
```

## Troubleshooting Deployment Issues

### Common Startup Problems

**Service fails to start:**
```bash
# Check specific service logs
docker compose --profile core logs <service_name>

# Check for port conflicts
netstat -tln | grep <port_number>

# Verify environment variables
docker compose --profile core exec <service_name> env | grep <VARIABLE>
```

**Permission errors:**
```bash
# Check volume mount permissions
docker compose --profile core exec <service_name> ls -la /config

# Verify PUID/PGID
docker compose --profile core exec <service_name> id
```

**Network connectivity issues:**
```bash
# Test internal networking
docker compose --profile core exec <service_name> ping <other_service>

# Check Docker network
docker network inspect ultimate-plex-stack_plex-stack
```

### Recovery Commands
```bash
# Restart specific service
docker compose --profile core restart <service_name>

# Rebuild and restart service
docker compose --profile core up -d --build <service_name>

# Complete redeployment
docker compose --profile core down
docker compose --profile core up -d

# Clean restart (removes volumes - use carefully)
docker compose --profile core down -v
docker compose --profile core up -d
```

## Deployment Validation Checklist `PLANNED`

- [ ] Core services deployed successfully `PLANNED`
- [ ] All containers are in running state `PLANNED`
- [ ] No critical errors in service logs `PLANNED`
- [ ] Network connectivity between services verified `PLANNED`
- [ ] Web interfaces accessible locally `PLANNED`
- [ ] Configuration directories populated `PLANNED`
- [ ] Volume mounts working correctly `PLANNED`
- [ ] Resource usage within acceptable limits `PLANNED`

## Next Steps

With core services deployed and verified, proceed to [Phase 5: Service Configuration and Integration](../SETUP-5-Service-Integration.md) for detailed service setup and inter-service connections.

## Monitoring and Maintenance

### Ongoing Health Monitoring
```bash
# Set up periodic health checks (add to cron)
echo "*/5 * * * * /path/to/ultimate-plex-stack/shared/scripts/health-check.sh" | crontab -

# Monitor resource usage
docker stats --no-stream
```

### Log Management
```bash
# View all logs
docker compose --profile core logs -f

# Follow specific service logs
docker compose --profile core logs -f <service_name>

# Clean old logs
docker compose --profile core exec <service_name> truncate -s 0 /config/logs/*.log
```
