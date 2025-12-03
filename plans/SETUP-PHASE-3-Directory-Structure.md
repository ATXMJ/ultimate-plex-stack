# Phase 3: Directory Structure and Storage Setup

This phase creates the complete directory structure following the hybrid storage strategy: local storage for server data and temporary files, with initial local storage for media libraries (migration to NAS in a later phase).

## Collaborative Implementation Notes

When working through this phase with the AI assistant:

### Agent Guidance
- **Directory Creation**: The agent will guide you through creating each directory with proper permissions
- **Storage Assessment**: Help evaluating your available storage and performance characteristics
- **Permission Setup**: Step-by-step configuration of user and group permissions
- **Performance Testing**: Guidance through storage performance validation

### What You'll Need to Provide
- **Storage Confirmation**: Verification of available disk space and filesystem types
- **User Preferences**: Your preferred user/group IDs for file ownership
- **Performance Expectations**: Your requirements for storage speed and capacity

### Interactive Process
- **Safety Checks**: The agent will verify existing files won't be overwritten
- **Permission Validation**: Testing that Docker containers can access created directories
- **Backup Planning**: The agent will help set up initial backup scripts
- **Progress Monitoring**: Regular verification of directory creation and permissions

## Storage Strategy Overview `PLANNED`

The Ultimate Plex Media Stack uses a **hybrid storage approach**:

- **Local Storage (Always)**: Application configurations, downloads, and temporary files
- **Local Storage (Initial)**: Media libraries (will migrate to NAS later)
- **NAS Storage (Future)**: Media libraries only (after migration)

**Note**: Update status to `COMPLETED` after understanding the hybrid storage strategy and confirming available storage meets requirements.

## Directory Structure Creation `PLANNED`

### Navigate to Project Directory
```powershell
# Ensure you're in the ultimate-plex-stack directory
cd C:\path\to\ultimate-plex-stack

# Verify current location
pwd
```

### Create Core Directory Structure
```powershell
# Create main directories following the hybrid storage strategy
mkdir config -Force
mkdir downloads\movies, downloads\tv, downloads\music, downloads\photos, downloads\complete -Force
mkdir transcode -Force
mkdir media\movies, media\tv, media\music, media\photos -Force
mkdir temp, shared -Force

# Verify structure creation
tree /F /A
```

### Detailed Directory Breakdown

#### Application Configurations (Local - Always)
```powershell
# Create service-specific config directories
mkdir config\plex -Force
         config/radarr \
         config/sonarr \
         config/bazarr \
         config/prowlarr \
         config/overseerr \
         config/tdarr \
         config/qbittorrent \
         config/nzbget \
         config/nginx-proxy-manager \
         config/wireguard
```

#### Downloads Directory Structure (Local - Always)
```powershell
# Create organized download directories
mkdir downloads\movies, downloads\tv, downloads\music, downloads\photos -Force
mkdir downloads\complete, downloads\incomplete, downloads\torrents, downloads\usenet -Force
```

#### Media Libraries (Local Initially - NAS Later)
```powershell
# Create initial local media library structure
mkdir media\movies, media\tv, media\music, media\photos -Force
mkdir media\books, media\audiobooks -Force
```

#### Temporary and Shared Directories (Local - Always)
```powershell
# Create temporary processing directories
mkdir transcode\temp, transcode\cache -Force
mkdir temp\logs, temp\backups -Force
mkdir shared\scripts, shared\ssl -Force
```

**Note**: Update status to `COMPLETED` after successfully creating all required directories following the hybrid storage strategy.

## File Permissions and Ownership `PLANNED`

### Windows Permissions
```powershell
# Get your user information
whoami
whoami /user

# On Windows with Docker Desktop, permissions are managed automatically
# Ensure your user account has full control over the project directories
# Docker Desktop will handle container access permissions

# Verify permissions on key directories
Get-Acl config | Format-List
Get-Acl downloads | Format-List
Get-Acl media | Format-List

# Ensure download directories are writable
chmod -R 775 downloads/
```

### Verify Permissions
```powershell
# Check directory structure
dir

# Check permissions for key directories
Get-Acl config | Select Path, Owner
Get-Acl downloads | Select Path, Owner
Get-Acl media | Select Path, Owner
Get-Acl transcode | Select Path, Owner
```

**Note**: Update status to `COMPLETED` after configuring proper file permissions and ownership for all created directories.

## Storage Space Verification `PLANNED`

### Check Available Storage
```bash
# Check overall disk usage
df -h

# Check current directory disk usage
du -sh *

# Check filesystem types
df -T
```

### Storage Requirements Validation
```bash
# Verify minimum space requirements
REQUIRED_SPACE=500  # GB
AVAILABLE_SPACE=$(df . | tail -1 | awk '{print int($4/1024/1024)}')

if [ $AVAILABLE_SPACE -ge $REQUIRED_SPACE ]; then
    echo "✓ Sufficient storage available: ${AVAILABLE_SPACE}GB"
else
    echo "✗ Insufficient storage. Required: ${REQUIRED_SPACE}GB, Available: ${AVAILABLE_SPACE}GB"
fi
```

### Directory-Specific Space Allocation
```bash
# Check space in each major directory
du -sh config/
du -sh downloads/
du -sh transcode/
du -sh media/
du -sh temp/
du -sh shared/
```

**Note**: Update status to `COMPLETED` after verifying sufficient storage space is available for all directories and planned media libraries.

## Storage Optimization `PLANNED`

### Filesystem Considerations
```bash
# Check filesystem type for performance
df -T . | tail -1

# Recommended filesystems for media storage:
# - ext4: Good balance of performance and features
# - xfs: Excellent for large files and high performance
# - btrfs: Advanced features but higher overhead
# - zfs: Enterprise-grade but complex setup
```

### Storage Performance Testing
```bash
# Test write performance (simulate media file operations)
echo "Testing write performance..."
dd if=/dev/zero of=temp/performance_test bs=1M count=1000 conv=fdatasync 2>&1 | tail -1

# Test read performance
echo "Testing read performance..."
dd if=temp/performance_test of=/dev/null bs=1M count=1000 2>&1 | tail -1

# Clean up test file
rm temp/performance_test
```

### Docker Volume Preparation
```bash
# Test Docker volume mount permissions
docker run --rm \
  -v "$(pwd)/config:/test_config" \
  -v "$(pwd)/downloads:/test_downloads" \
  -v "$(pwd)/media:/test_media" \
  -v "$(pwd)/transcode:/test_transcode" \
  --user $PUID:$PGID \
  alpine sh -c "touch /test_config/test && touch /test_downloads/test && touch /test_media/test && touch /test_transcode/test && echo 'Volume mounts working correctly'"
```

**Note**: Update status to `COMPLETED` after optimizing storage settings and verifying Docker volume mount permissions.

## Backup and Recovery Preparation `PLANNED`

### Create Backup Scripts Directory
```powershell
# Create backup script location
mkdir shared\scripts\backups -Force

# Create basic backup script template
cat > shared/scripts/backups/backup-config.sh << 'EOF'
#!/bin/bash
# Configuration backup script
BACKUP_DIR="../backups/$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

# Backup configurations
cp -r ../config "$BACKUP_DIR/"
cp ../.env "$BACKUP_DIR/"
cp ../docker-compose.yml "$BACKUP_DIR/"

echo "Backup created in: $BACKUP_DIR"
EOF

# Make backup script executable
chmod +x shared/scripts/backups/backup-config.sh
```

### Initial Backup Creation
```bash
# Run initial backup
./shared/scripts/backups/backup-config.sh
```

**Note**: Update status to `COMPLETED` after creating backup scripts and performing initial backup of configuration files.

## Directory Structure Validation `PLANNED`

### Complete Structure Verification
```bash
# Create expected structure list
cat > .directory_structure << 'EOF'
config/
config/plex/
config/radarr/
config/sonarr/
config/bazarr/
config/prowlarr/
config/overseerr/
config/tdarr/
config/qbittorrent/
config/nzbget/
config/nginx-proxy-manager/
config/wireguard/
downloads/
downloads/movies/
downloads/tv/
downloads/music/
downloads/photos/
downloads/complete/
downloads/incomplete/
downloads/torrents/
downloads/usenet/
media/
media/movies/
media/tv/
media/music/
media/photos/
media/books/
media/audiobooks/
transcode/
transcode/temp/
transcode/cache/
temp/
temp/logs/
temp/backups/
shared/
shared/scripts/
shared/ssl/
EOF

# Verify all directories exist
echo "Verifying directory structure..."
MISSING_DIRS=0
while IFS= read -r dir; do
    if [ ! -d "$dir" ]; then
        echo "✗ Missing: $dir"
        MISSING_DIRS=$((MISSING_DIRS + 1))
    fi
done < .directory_structure

if [ $MISSING_DIRS -eq 0 ]; then
    echo "✓ All directories created successfully"
else
    echo "✗ $MISSING_DIRS directories missing"
fi

# Clean up
rm .directory_structure
```

### Permission Validation Script
```bash
# Create permission validation script
cat > shared/scripts/validate-permissions.sh << 'EOF'
#!/bin/bash
echo "Validating directory permissions..."

# Check ownership
if [ "$(stat -c '%u:%g' config/)" = "$PUID:$PGID" ]; then
    echo "✓ Config ownership correct"
else
    echo "✗ Config ownership incorrect"
fi

# Check permissions
if [ "$(stat -c '%a' config/)" = "755" ]; then
    echo "✓ Config permissions correct"
else
    echo "✗ Config permissions incorrect"
fi

echo "Permission validation complete"
EOF

chmod +x shared/scripts/validate-permissions.sh
./shared/scripts/validate-permissions.sh
```

**Note**: Update status to `COMPLETED` after validating the complete directory structure, permissions, and storage allocation.

## Storage Monitoring Setup `PLANNED`

### Create Storage Monitoring Script
```bash
# Create disk usage monitoring script
cat > shared/scripts/monitor-storage.sh << 'EOF'
#!/bin/bash
echo "=== Storage Usage Report ==="
echo "Generated: $(date)"
echo

echo "Overall disk usage:"
df -h . | tail -1
echo

echo "Directory usage:"
du -sh config/ downloads/ transcode/ media/ temp/ shared/ 2>/dev/null
echo

echo "Docker system usage:"
docker system df 2>/dev/null || echo "Docker not running"
EOF

chmod +x shared/scripts/monitor-storage.sh

# Run initial report
./shared/scripts/monitor-storage.sh
```

**Note**: Update status to `COMPLETED` after setting up storage monitoring scripts and generating initial storage reports.

## Setup Checklist `PLANNED`

- [ ] All required directories created `PLANNED`
- [ ] Proper ownership set (PUID:PGID) `PLANNED`
- [ ] Correct permissions applied `PLANNED`
- [ ] Sufficient storage space verified `PLANNED`
- [ ] Storage performance tested `PLANNED`
- [ ] Docker volume mounts validated `PLANNED`
- [ ] Backup scripts created `PLANNED`
- [ ] Directory structure validated `PLANNED`
- [ ] Storage monitoring configured `PLANNED`

**Note**: Update status to `COMPLETED` after verifying all checklist items are satisfied and the complete directory structure is ready for service deployment.

## Next Steps

With the directory structure and storage properly configured, proceed to [Phase 4: Core Services Deployment](../SETUP-4-Core-Services.md).

## Troubleshooting

### Common Issues

**Permission denied errors:**
```powershell
# Check current permissions
Get-Acl C:\path\to\directory | Format-List

# On Windows with Docker Desktop, ensure your user has full control
# Docker Desktop manages container permissions automatically
# Check if Docker Desktop can access the directories
```

**Insufficient storage space:**
```bash
# Check largest directories
Get-ChildItem | Sort-Object Length -Descending | Select-Object Name, @{Name="Size(GB)";Expression={[math]::Round($_.Length/1GB,2)}} | Select-Object -First 10

# Free up space if needed
# Option 1: Windows Disk Cleanup
cleanmgr.exe /d C: /VERYLOWDISK

# Option 2: Clear Docker cache
docker system prune -a
```

**Docker volume mount failures:**
```powershell
# Test individual mounts
docker run --rm -v "${PWD}/config:/test" alpine ls -la /test

# On Windows, ensure directories are shared in Docker Desktop settings
# Check Docker Desktop file sharing settings
```

**Performance issues:**
```bash
# Check filesystem mount options
mount | grep $(pwd)

# Test filesystem performance
fio --name=randwrite --rw=randwrite --bs=4k --size=1g --numjobs=1 --runtime=60
```
