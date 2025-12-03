# Phase 8: NAS Migration (Optional)

This optional phase migrates media libraries from local storage to Network Attached Storage (NAS) while keeping server configurations and temporary files local. This provides optimal performance for application data while leveraging NAS for long-term media storage.

## Collaborative Implementation Notes

When working through this phase with the AI assistant:

### Agent Guidance
- **NAS Assessment**: The agent will help evaluate your NAS setup and compatibility
- **Migration Planning**: Careful planning of the migration process with rollback options
- **Data Transfer**: Supervised transfer of media files with progress monitoring
- **Configuration Updates**: Step-by-step updates to Docker and service configurations

### What You'll Need to Provide
- **NAS Details**: Your NAS IP address, share paths, and authentication credentials
- **Migration Timeline**: Your preferred maintenance window for the migration
- **Backup Verification**: Confirmation that you have current backups of your media
- **Downtime Tolerance**: How much service downtime you can tolerate during migration

### Interactive Process
- **Pre-Migration Checks**: The agent will verify all prerequisites before starting migration
- **Phased Migration**: Breaking the migration into manageable steps with verification at each stage
- **Rollback Planning**: Ensuring you can revert changes if issues arise
- **Post-Migration Testing**: Comprehensive testing to ensure everything works with NAS storage

## Migration Prerequisites `PLANNED`

### NAS Requirements
- **Storage Capacity**: 2TB+ for initial media library
- **Network**: Gigabit Ethernet minimum, 10GbE recommended
- **File System**: SMB/CIFS (Windows file sharing), or compatible with Windows mounting
- **RAID**: Hardware RAID 5/6 or software RAID with redundancy
- **Backup**: Existing backup solution or ability to implement one

### Pre-Migration Checklist
- [ ] NAS is properly configured and accessible
- [ ] Sufficient NAS storage space available
- [ ] Network connection is stable and fast
- [ ] Current media library is backed up
- [ ] Services are running normally
- [ ] You have maintenance window planned

## NAS Preparation `PLANNED`

### Create NAS Share Structure
```bash
# On your NAS, create the following share structure:
# /volume1/media/ (or equivalent mount point)
# ├── movies/
# ├── tv/
# ├── music/
# ├── photos/
# └── books/ (future use)
```

### Configure NAS Permissions
```bash
# Ensure proper permissions for media access
# On Windows with Docker Desktop, permissions are managed automatically
# Ensure your Windows user account has access to the NAS share
```

### Test NAS Accessibility
```bash
# Test basic connectivity to NAS
ping your-nas-ip

# Test share access (adjust for your NAS type)
# SMB example:
net view \\your-nas-ip

# SMB/CIFS example:
smbclient -L your-nas-ip
```

## Mount NAS Storage `PLANNED`

### Create Mount Point
```powershell
# Create local mount directory
mkdir C:\mnt\nas\media -Force

# On Windows, permissions are managed by your user account
# Docker Desktop will handle container access
```

### SMB/CIFS Mount Configuration (Windows)
```powershell
# Mount NAS using SMB/CIFS (most common for Windows)
net use Z: \\your-nas-ip\media /persistent:yes

# Or use PowerShell for mapped drive
New-PSDrive -Name "NASMedia" -PSProvider FileSystem -Root "\\your-nas-ip\media" -Persist

# Verify mount success
Get-PSDrive | Where-Object { $_.Name -eq "Z" -or $_.Name -eq "NASMedia" }
dir Z:\

# Test write permissions
New-Item Z:\test-file -ItemType File
Remove-Item Z:\test-file
```

### Permanent Mount Configuration
```powershell
# Create a PowerShell script to mount on startup
# Save as mount-nas.ps1 in your startup folder or as a scheduled task
sudo mount -a

# Verify mount persists after reboot
sudo reboot  # Test in maintenance window
```

### SMB/CIFS Mount (Primary for Windows)
```powershell
# Windows has built-in SMB/CIFS support
# Map network drive using net use
net use Z: \\your-nas-ip\media /user:your-user your-pass /persistent:yes

# Or use PowerShell New-PSDrive
New-PSDrive -Name "NASMedia" -PSProvider FileSystem -Root "\\your-nas-ip\media" -Credential (Get-Credential) -Persist

# For permanent mounting, create a scheduled task or startup script
```

## Pre-Migration Backup `PLANNED`

### Full System Backup
```bash
# Create comprehensive backup before migration
BACKUP_DIR="temp/backups/pre-nas-migration-$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

# Backup configurations
cp -r config/ "$BACKUP_DIR/"
cp .env "$BACKUP_DIR/"
cp docker-compose.yml "$BACKUP_DIR/"

# Backup current media (optional, since we're migrating it)
# cp -r media/ "$BACKUP_DIR/media-backup/"

echo "Pre-migration backup created in: $BACKUP_DIR"
```

### Media Library Inventory
```bash
# Create inventory of current media
echo "=== Current Media Inventory ===" > temp/media-inventory.txt
echo "Generated: $(date)" >> temp/media-inventory.txt
echo >> temp/media-inventory.txt

echo "Movies:" >> temp/media-inventory.txt
find media/movies/ -type f -name "*.mkv" -o -name "*.mp4" | wc -l >> temp/media-inventory.txt
du -sh media/movies/ >> temp/media-inventory.txt

echo "TV Shows:" >> temp/media-inventory.txt
find media/tv/ -type f -name "*.mkv" -o -name "*.mp4" | wc -l >> temp/media-inventory.txt
du -sh media/tv/ >> temp/media-inventory.txt

echo "Music:" >> temp/media-inventory.txt
find media/music/ -type f -name "*.mp3" -o -name "*.flac" | wc -l >> temp/media-inventory.txt
du -sh media/music/ >> temp/media-inventory.txt

echo "Photos:" >> temp/media-inventory.txt
find media/photos/ -type f -name "*.jpg" -o -name "*.png" | wc -l >> temp/media-inventory.txt
du -sh media/photos/ >> temp/media-inventory.txt

cat temp/media-inventory.txt
```

## Media Migration `PLANNED`

### Stop Services Temporarily
```bash
# Stop all services to prevent conflicts during migration
docker compose --profile core --profile advanced down

# Verify services are stopped
docker compose ps
```

### Copy Media to NAS
```bash
# Use rsync for efficient and resumable transfer
# Preserve permissions and timestamps
rsync -avh --progress --stats media/ /mnt/nas/media/

# Alternative: Use cp with progress (simpler but less robust)
# cp -rv media/* /mnt/nas/media/
```

### Verify Migration Integrity
```bash
# Compare file counts
echo "Original files:"
find media/ -type f | wc -l

echo "Migrated files:"
find /mnt/nas/media/ -type f | wc -l

# Compare directory sizes
du -sh media/
du -sh /mnt/nas/media/

# Detailed comparison (takes time for large libraries)
diff -r media/ /mnt/nas/media/ || echo "Differences found - review manually"
```

### Test NAS File Access
```bash
# Test file access from NAS
ls -la /mnt/nas/media/movies/
ls -la /mnt/nas/media/tv/

# Test read/write permissions
touch /mnt/nas/media/test-access
rm /mnt/nas/media/test-access
```

## Update Docker Configuration `PLANNED`

### Modify docker-compose.yml
```bash
# Backup original configuration
cp docker-compose.yml docker-compose.yml.local-only

# Update volume mappings for media libraries
# Change from local paths to NAS paths
sed -i 's|./media/movies:/movies|/mnt/nas/media/movies:/movies|g' docker-compose.yml
sed -i 's|./media/tv:/tv|/mnt/nas/media/tv:/tv|g' docker-compose.yml
sed -i 's|./media/music:/music|/mnt/nas/media/music:/music|g' docker-compose.yml
sed -i 's|./media/photos:/photos|/mnt/nas/media/photos:/photos|g' docker-compose.yml

# Verify changes
grep -A 2 -B 2 "mnt/nas" docker-compose.yml
```

### Update Environment Variables
```bash
# Update .env file with NAS paths
sed -i 's|MOVIES_PATH=./media/movies|MOVIES_PATH=/mnt/nas/media/movies|g' .env
sed -i 's|TV_PATH=./media/tv|TV_PATH=/mnt/nas/media/tv|g' .env
sed -i 's|MUSIC_PATH=./media/music|MUSIC_PATH=/mnt/nas/media/music|g' .env
sed -i 's|PHOTOS_PATH=./media/photos|PHOTOS_PATH=/mnt/nas/media/photos|g' .env

# Keep these LOCAL (do not change):
# DOWNLOADS_PATH=./downloads
# TRANSCODE_PATH=./transcode
# CONFIG_PATH=./config

# Verify environment changes
grep "PATH=" .env
```

## Service Restart and Testing `PLANNED`

### Restart Services
```bash
# Start services with new NAS configuration
docker compose --profile core up -d

# Monitor startup logs
docker compose --profile core logs -f --tail=50
```

### Verify Service Access to NAS
```bash
# Test Plex access to migrated media
docker compose --profile core exec plex ls -la /movies/
docker compose --profile core exec plex ls -la /tv/

# Test Radarr/Sonarr access
docker compose --profile core exec radarr ls -la /movies/
docker compose --profile core exec sonarr ls -la /tv/
```

### Plex Library Rescan
```bash
# Access Plex web interface
echo "Access Plex at: https://plex.yourdomain.com"

# For each library:
# 1. Go to Library settings
# 2. Click "Scan Library Files"
# 3. Click "Refresh Metadata"
# 4. Verify media appears correctly
```

### Test Media Playback
```bash
# Test streaming from NAS
# Play a few files from different libraries
# Verify transcoding works if needed
# Check for any playback issues
```

## Post-Migration Validation `PLANNED`

### Functional Testing
```bash
# Test Overseerr requests
# Test Radarr/Sonarr manual additions
# Verify download/import pipeline still works
# Test all library scanning functions
```

### Performance Testing
```bash
# Test streaming performance
# Monitor NAS network throughput
# Check for any latency issues

# Test concurrent access
# Monitor system resource usage
docker stats
```

### Backup Verification
```bash
# Ensure backups still work with NAS paths
# Test backup scripts
./shared/scripts/backups/backup-config.sh

# Verify backup integrity
ls -la temp/backups/
```

## Cleanup and Optimization `PLANNED`

### Remove Local Media Files
```bash
# ONLY after verifying NAS migration is successful
# This frees up local storage

# Move local media to backup first (safety measure)
mv media/ temp/media-local-backup/

# Create symlink structure if needed (optional)
# mkdir media
# ln -s /mnt/nas/media/movies media/movies
# ln -s /mnt/nas/media/tv media/tv
# etc.
```

### Update Monitoring Scripts
```bash
# Update storage monitoring to include NAS
sed -i 's|du -sh config/ downloads/ transcode/ media/ temp/ shared/|du -sh config/ downloads/ transcode/ temp/ shared/ /mnt/nas/media|g' shared/scripts/monitor-storage.sh
```

### Update Backup Scripts
```bash
# Ensure backup scripts account for NAS paths
# Consider separate NAS backup strategy
```

## NAS Backup Strategy `PLANNED`

### Implement NAS Backup
```bash
# Set up NAS-level backups
# Options:
# 1. NAS built-in backup features
# 2. Rsync to secondary storage
# 3. Cloud backup solutions
# 4. External drive rotation

# Example rsync backup script
cat > shared/scripts/backup-nas.sh << 'EOF'
#!/bin/bash
BACKUP_DEST="/mnt/backup-drive/nas-backup"
DATE=$(date +%Y%m%d_%H%M%S)

rsync -avh --delete --backup --backup-dir="$BACKUP_DEST/archives/$DATE" \
    /mnt/nas/media/ "$BACKUP_DEST/current/"

echo "NAS backup completed: $DATE"
EOF

chmod +x shared/scripts/backup-nas.sh
```

## Troubleshooting Migration Issues

### Common Migration Problems

**Mount failures:**
```bash
# Check NAS availability
ping your-nas-ip

# Test mount manually
sudo mount -t nfs your-nas-ip:/volume1/media /mnt/nas/media

# Check /etc/fstab syntax
sudo mount -a 2>&1

# Check NAS export permissions
showmount -e your-nas-ip
```

**Permission issues:**
```bash
# Verify NAS permissions
sudo -u $PUID ls -la /mnt/nas/media/

# Check Docker access
docker compose --profile core exec plex id

# Fix permissions if needed
sudo chown -R $PUID:$PGID /mnt/nas/media/
```

**Service access issues:**
```bash
# Check if services can access NAS
docker compose --profile core exec plex ls /movies/

# Verify volume mounts in running containers
docker inspect ultimate-plex-stack_plex_1 | grep -A 10 Mounts
```

**Plex scanning issues:**
```bash
# Check Plex logs for scan errors
docker compose --profile core logs plex | grep -i error

# Manually trigger scan via API
curl -X POST "http://plex:32400/library/sections/1/refresh" \
     -H "X-Plex-Token: YOUR_PLEX_TOKEN"
```

### Recovery Procedures
```bash
# Rollback to local storage
cp docker-compose.yml.local-only docker-compose.yml
cp .env.local-only .env

# Restore local media if needed
mv temp/media-local-backup/* media/

# Restart services
docker compose --profile core down
docker compose --profile core up -d
```

## Migration Validation Checklist `PLANNED`

- [ ] NAS properly mounted and accessible `PLANNED`
- [ ] Pre-migration backup completed `PLANNED`
- [ ] Media successfully copied to NAS `PLANNED`
- [ ] File integrity verified `PLANNED`
- [ ] Docker configuration updated `PLANNED`
- [ ] Environment variables updated `PLANNED`
- [ ] Services restarted successfully `PLANNED`
- [ ] Plex libraries rescanned `PLANNED`
- [ ] Media playback tested `PLANNED`
- [ ] Download/import pipeline verified `PLANNED`
- [ ] Performance acceptable `PLANNED`
- [ ] NAS backup strategy implemented `PLANNED`
- [ ] Local storage cleaned up (optional) `PLANNED`

## Next Steps

With NAS migration complete, proceed to [Phase 9: Testing and Validation](../SETUP-9-Testing-Validation.md) to perform comprehensive end-to-end testing of your migrated media stack.

## Post-Migration Maintenance

### Ongoing NAS Tasks
- Monitor NAS storage usage
- Regular NAS backups
- Network performance monitoring
- Firmware updates for NAS
- RAID health monitoring (if applicable)

### Performance Monitoring
```bash
# Create NAS performance monitoring
cat > shared/scripts/monitor-nas.sh << 'EOF'
#!/bin/bash
echo "=== NAS Performance Report ==="

# Mount status
echo "Mount Status:"
df -h /mnt/nas/media

# Network performance test
echo -e "\nNetwork Performance:"
dd if=/dev/zero bs=1M count=100 | ssh user@nas-ip "cat > /dev/null"

# I/O performance
echo -e "\nI/O Performance:"
time dd if=/mnt/nas/media/testfile of=/dev/null bs=1M count=100 2>&1 | tail -1

echo "NAS monitoring complete"
EOF

chmod +x shared/scripts/monitor-nas.sh
```
