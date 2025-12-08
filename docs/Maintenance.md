# Maintenance and Monitoring

## Backup Strategy
- **Configurations**: Daily backup of `/config` directories
- **Media**: Weekly incremental backups
- **Automation**: Cron jobs for automated backups

## Monitoring
- **Health Checks**: Docker health checks for all services
- **Logs**: Centralized logging with Dozzle or similar
- **Metrics**: Uptime monitoring with Uptime Kuma

## Updates
- **Automated**: Watchtower for container updates
- **Manual**: Test updates in staging environment
- **Backup**: Always backup before major updates

## Troubleshooting
- **Logs**: `make logs` or `docker compose logs <service>`
- **Network**: `docker network inspect plex-stack`
- **Disk Space**: Monitor storage usage
- **VPN**: Verify kill switch functionality - if qBittorrent/NZBGet are not working, check VPN connection status
- **VPN Kill Switch**: Torrent/usenet clients intentionally stop working when VPN disconnects (this is correct behavior)
- **Stop Services**: `make down`
- **Restart Services**: `make restart`

