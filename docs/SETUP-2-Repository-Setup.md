# Phase 2: Repository Setup and Initial Configuration

This phase clones the Ultimate Plex Media Stack repository and configures the basic environment variables and Docker Compose setup.

## Collaborative Implementation Notes

When working through this phase with the AI assistant:

### Agent Guidance
- **Repository Setup**: The agent will guide you through cloning and initial project setup
- **Environment Configuration**: Step-by-step help with creating and configuring your .env file
- **Plex Claim Process**: The agent will walk you through obtaining and configuring your Plex claim token
- **Domain Setup**: Guidance for configuring domain settings if using reverse proxy

### What You'll Need to Provide
- **Plex Account**: Access to your Plex account for claim token generation
- **Domain Information**: Your domain name and any subdomain preferences
- **VPN Credentials**: Your VPN provider details (username, password, endpoint)
- **System Details**: Your timezone and user ID information

### Interactive Process
- **Information Gathering**: The agent will prompt you for each required configuration value
- **Validation Steps**: Verification that your .env file is correctly formatted
- **Testing**: The agent will help test Docker Compose configuration before proceeding
- **Backup Creation**: The agent will ensure you have backups of initial configurations

## Repository Cloning `PLANNED`

### Clone the Repository
```powershell
# Navigate to your desired installation directory
cd C:\path\to\installation\directory

# Clone the repository
git clone https://github.com/DonMcD/ultimate-plex-stack.git

# Navigate into the project directory
cd ultimate-plex-stack

# Verify the clone was successful
dir
```

### Repository Structure
After cloning, verify the following structure exists:
```
ultimate-plex-stack/
├── docker-compose.yml      # Main Docker Compose configuration
├── .env.example           # Environment variables template
├── config/                # Service configuration templates
├── docs/                  # Documentation
└── scripts/               # Setup and utility scripts
```

## Environment Variables Configuration `PLANNED`

### Create Environment File
```powershell
# Copy the example environment file
copy .env.example .env

# Note: Windows NTFS permissions will protect the file
# Ensure only your user account has access to the .env file
```

### Configure User and System Variables
Edit the `.env` file with your specific values:

```bash
# Open .env file for editing
nano .env
```

#### Required Variables

**User/Group IDs:**
```powershell
# Get your user information
whoami /user

# On Windows, PUID and PGID are not required for Docker Desktop
# These can be set to default values or omitted
PUID=1000          # Default value (not used on Windows)
PGID=1000          # Default value (not used on Windows)
```

**Timezone:**
```bash
# Set your timezone (list available timezones with: timedatectl list-timezones)
TZ=America/New_York
```

**Domain Configuration:**
```bash
# Your domain name (used for reverse proxy SSL certificates)
DOMAIN=yourdomain.com

# Optional: Subdomain prefix if using a subdomain
SUBDOMAIN=plex    # Results in plex.yourdomain.com
```

### Plex Configuration
**Obtain Plex Claim Token:**
1. Visit https://www.plex.tv/claim/
2. Sign in to your Plex account
3. Copy the claim token

```bash
# Add to .env
PLEX_CLAIM=claim-your-plex-claim-token-here
```

**Plex Network Configuration:**
```bash
# IP address to advertise to Plex clients (usually your public IP)
ADVERTISE_IP=your.public.ip.address

# Comma-separated list of allowed networks (e.g., local network)
ALLOWED_NETWORKS=192.168.1.0/24,10.0.0.0/8
```

### VPN Configuration
Configure VPN settings for torrent and usenet services:

```bash
# VPN Provider settings
VPN_PROVIDER=mullvad
VPN_ENDPOINT=us-nyc-001.mullvad.net
VPN_USERNAME=your-vpn-username
VPN_PASSWORD=your-vpn-password

# WireGuard specific (if using WireGuard)
VPN_PORT=51820
VPN_PROTOCOL=wireguard
```

### Media Paths Configuration
Set up initial local paths (these can be migrated to NAS later):

```bash
# Local media directories (initial setup - will migrate to NAS)
MOVIES_PATH=./media/movies
TV_PATH=./media/tv
MUSIC_PATH=./media/music
PHOTOS_PATH=./media/photos

# Downloads and temp directories (always stay local for performance)
DOWNLOADS_PATH=./downloads
TRANSCODE_PATH=./transcode

# Configuration directory
CONFIG_PATH=./config
```

### Complete .env Template
Your `.env` file should look like this:

```bash
# User/Group Configuration
PUID=1000
PGID=1000
TZ=America/New_York

# Domain Configuration
DOMAIN=yourdomain.com
SUBDOMAIN=plex

# Plex Configuration
PLEX_CLAIM=claim-your-plex-claim-token-here
ADVERTISE_IP=123.456.789.0
ALLOWED_NETWORKS=192.168.1.0/24

# VPN Configuration
VPN_PROVIDER=mullvad
VPN_ENDPOINT=us-nyc-001.mullvad.net
VPN_USERNAME=your-username
VPN_PASSWORD=your-password
VPN_PORT=51820
VPN_PROTOCOL=wireguard

# Media Paths (Local initially)
MOVIES_PATH=./media/movies
TV_PATH=./media/tv
MUSIC_PATH=./media/music
PHOTOS_PATH=./media/photos

# System Paths (Always Local)
DOWNLOADS_PATH=./downloads
TRANSCODE_PATH=./transcode
CONFIG_PATH=./config

# Optional: GPU Configuration (for Tdarr transcoding)
NVIDIA_VISIBLE_DEVICES=all
```

## Docker Compose Configuration `PLANNED`

### Verify Docker Compose File
```powershell
# Check that docker-compose.yml exists and is valid
dir docker-compose.yml

# Validate the Docker Compose configuration
docker compose config
```

### Review Service Profiles
The stack uses Docker Compose profiles to organize services:

- **core**: Essential services (Plex, Radarr, Sonarr, Prowlarr, Overseerr)
- **advanced**: Optional services (Bazarr, Tdarr)
- **torrent**: Torrent downloading (qBittorrent + VPN)
- **usenet**: Usenet downloading (NZBGet + VPN)
- **proxy**: Reverse proxy (Nginx Proxy Manager)

### Initial Deployment Profile
For initial setup, you'll use the `core` profile:
```bash
# List available profiles
docker compose config --profiles

# Validate core profile configuration
docker compose --profile core config
```

## Domain and SSL Preparation `PLANNED`

### DNS Verification
Ensure your domain DNS is properly configured:

```powershell
# Test DNS resolution for your domain
Resolve-DnsName yourdomain.com

# If using subdomains, test those too
Resolve-DnsName plex.yourdomain.com
```

### SSL Certificate Preparation
The reverse proxy (Nginx Proxy Manager) will handle SSL certificates via Let's Encrypt. Ensure:

1. **Port 80 is accessible** from the internet (for HTTP-01 challenge)
2. **Port 443 is accessible** from the internet (for HTTPS)
3. **Domain DNS** resolves to your server's public IP

Test SSL challenge accessibility:
```powershell
# Test HTTP access (should work if firewall is configured correctly)
Invoke-WebRequest -Uri http://yourdomain.com -Method Head
```

## Initial Configuration Validation `PLANNED`

### Environment Variables Check
```bash
# Source the environment file to test variables
source .env

# Verify key variables are set
echo "PUID: $PUID"
echo "PGID: $PGID"
echo "DOMAIN: $DOMAIN"
echo "PLEX_CLAIM: $PLEX_CLAIM"
```

### Docker Compose Validation
```bash
# Test Docker Compose can read the configuration
docker compose --profile core config --quiet

# Check for any configuration errors
if [ $? -eq 0 ]; then
    echo "Docker Compose configuration is valid"
else
    echo "Docker Compose configuration has errors"
fi
```

### Network Configuration Test
```powershell
# Test that required ports are available
Get-NetTCPConnection | Where-Object { $_.LocalPort -in 80,443,32400 } | Select LocalPort, State

# Verify Docker network can be created
docker network ls | Select-String plex-stack
if ($LASTEXITCODE -ne 0) { Write-Host "Network will be created on first run" }
```

## Backup Configuration `PLANNED`
```bash
# Create a backup of your initial configuration
cp .env .env.backup
cp docker-compose.yml docker-compose.yml.backup

# Optional: Create a git commit for version control
git add .
git commit -m "Initial configuration setup"
```

## Configuration Checklist `PLANNED`

- [ ] Repository cloned successfully `PLANNED`
- [ ] .env file created from .env.example `PLANNED`
- [ ] User/Group IDs (PUID/PGID) configured `PLANNED`
- [ ] Timezone (TZ) set correctly `PLANNED`
- [ ] Domain configuration completed `PLANNED`
- [ ] Plex claim token obtained and configured `PLANNED`
- [ ] VPN credentials configured `PLANNED`
- [ ] Media paths set up for local storage `PLANNED`
- [ ] Docker Compose configuration validated `PLANNED`
- [ ] DNS resolution verified `PLANNED`
- [ ] SSL ports accessible for Let's Encrypt `PLANNED`

## Next Steps

With the repository cloned and environment configured, proceed to [Phase 3: Directory Structure and Storage Setup](../SETUP-3-Directory-Structure.md).

## Troubleshooting

### Common Issues

**Environment variables not loading:**
```bash
# Check .env file syntax
cat .env | grep -v '^#' | grep -v '^$'

# Source the file explicitly
set -a; source .env; set +a
```

**Docker Compose validation fails:**
```bash
# Check for YAML syntax errors
python3 -c "import yaml; yaml.safe_load(open('docker-compose.yml'))"

# Validate with specific profile
docker compose --profile core config --verbose
```

**DNS not resolving:**
```powershell
# Check DNS servers
Get-DnsClientServerAddress | Select ServerAddresses

# Test with different DNS
Resolve-DnsName yourdomain.com -Server 8.8.8.8
```

**Permission issues:**
```powershell
# Check .env file permissions
Get-Acl .env | Format-List

# Windows handles permissions differently - ensure only your user has access
# Docker Desktop will manage container permissions automatically
```
