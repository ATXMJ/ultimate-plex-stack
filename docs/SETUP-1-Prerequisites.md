# Phase 1: Prerequisites and Environment Preparation

This phase ensures your system meets all requirements for running the Ultimate Plex Media Stack and prepares the environment for secure deployment.

## Collaborative Implementation Notes

When working through this phase with the AI assistant:

### Agent Guidance
- **System Assessment**: The agent will help you evaluate your current system's hardware and software against requirements
- **Installation Guidance**: Step-by-step guidance for installing Docker, configuring users, and setting up security
- **Information Collection**: The agent will ask for your VPN service preferences and help prepare credentials
- **Validation**: The agent will verify each component installation and configuration

### What You'll Need to Provide
- **System Access**: Administrative/sudo access to your server
- **VPN Information**: Your preferred VPN provider and account details
- **Domain Details**: Your domain name (if planning reverse proxy setup)
- **Hardware Specs**: Confirmation of your system's CPU, RAM, and storage

### Interactive Process
- **Step Verification**: After each major step, the agent will help you verify the results
- **Troubleshooting**: If issues arise, the agent will guide you through diagnosis and resolution
- **Safety First**: The agent will include precautions to avoid disrupting existing services

## System Requirements `PLANNED`

### Hardware Requirements

#### Minimum Hardware
- **CPU**: Quad-core processor (Intel i3/AMD Ryzen 3 or equivalent)
- **RAM**: 8GB system memory
- **Storage**: 500GB SSD for local storage (server data and temporary files)
- **Network**: Gigabit Ethernet connection

#### Recommended Hardware
- **CPU**: Hexa-core or better (Intel i5/AMD Ryzen 5 or equivalent)
- **RAM**: 16GB+ system memory
- **Storage**: 1TB NVMe SSD for optimal performance
- **Network**: 10GbE connection (especially for large media libraries)

#### Optional Hardware (for Advanced Features)
- **GPU**: NVIDIA GPU with CUDA support (for hardware transcoding in Tdarr)
- **NAS**: Network Attached Storage (2TB+ for media libraries)

### Software Requirements

**Note**: Update status to `COMPLETED` after verifying all system requirements are met and Docker is properly installed and configured.

#### Operating System
- **Supported**: Windows 11 Pro (version 21H2 or newer)
- **Architecture**: x86_64 (AMD64)
- **Requirements**: Windows Subsystem for Linux (WSL2) disabled, Hyper-V enabled

#### Required Software Packages
```powershell
# Install Docker Desktop for Windows
# Download and install from: https://www.docker.com/products/docker-desktop
# Ensure Hyper-V and WSL2 features are enabled in Windows Features

# Install additional tools via Winget or Chocolatey
winget install Git.Git
winget install Microsoft.PowerShell
```

#### Docker Version Requirements
- **Docker Desktop**: 4.0.0 or newer
- **Docker Engine**: 20.10.0 or newer
- **Docker Compose**: 2.0.0 or newer (included with Docker Desktop)

Verify installations:
```powershell
docker --version
docker compose version

# Test basic functionality
make --version  # Verify Make is available
```

## User and Permission Setup `PLANNED`

### Windows User Account
Docker Desktop on Windows runs services under the current user account. No additional user creation is required.

### File System Permissions
Windows NTFS permissions will be managed automatically by Docker Desktop. Ensure your user account has full control over the project directory and media folders.

```powershell
# Verify current user permissions
whoami

# Check current directory permissions
Get-Acl . | Format-List
```

**Note**: Update status to `COMPLETED` after configuring user accounts and verifying proper file system permissions are in place.

## Network and Firewall Configuration `PLANNED`

### Windows Firewall Setup
Windows Firewall is configured automatically by Docker Desktop. Additional rules may need to be added for specific services.

```powershell
# Check current firewall status
Get-NetFirewallProfile | Select Name, Enabled

# Allow HTTP/HTTPS for reverse proxy (if needed)
New-NetFirewallRule -DisplayName "HTTP" -Direction Inbound -LocalPort 80 -Protocol TCP -Action Allow
New-NetFirewallRule -DisplayName "HTTPS" -Direction Inbound -LocalPort 443 -Protocol TCP -Action Allow

# Allow Plex ports (initially - will be restricted later)
New-NetFirewallRule -DisplayName "Plex TCP" -Direction Inbound -LocalPort 32400 -Protocol TCP -Action Allow
New-NetFirewallRule -DisplayName "Plex UDP" -Direction Inbound -LocalPort 32400 -Protocol UDP -Action Allow

# Allow VPN ports (WireGuard)
New-NetFirewallRule -DisplayName "WireGuard" -Direction Inbound -LocalPort 51820 -Protocol UDP -Action Allow
```

### Network Interface Configuration
Ensure your network interfaces are properly configured:

```powershell
# Check network interfaces
Get-NetAdapter | Select Name, Status, MacAddress

# Test internet connectivity
Test-NetConnection -ComputerName 8.8.8.8 -InformationLevel Detailed

# Test DNS resolution
Resolve-DnsName google.com
```

**Note**: Update status to `COMPLETED` after configuring firewall rules and verifying network connectivity and DNS resolution.

## VPN Service Preparation `PLANNED`

### VPN Requirements
- **Provider**: Mullvad, ProtonVPN, or similar no-logs provider
- **Protocol**: WireGuard (preferred) or OpenVPN
- **Features**: Kill switch support, port forwarding (for torrenting)

### VPN Credentials Setup
Prepare your VPN credentials (will be used in Phase 6):

1. **Obtain VPN Subscription**
   - Choose a reputable no-logs VPN provider
   - Ensure they support port forwarding
   - Verify WireGuard/OpenVPN configuration files available

2. **Gather Required Information**
   - VPN server endpoint/hostname
   - Username/credentials or configuration files
   - Protocol configuration (WireGuard preferred)
   - Kill switch configuration details

3. **Test VPN Connection** (Manual verification)
   ```powershell
   # Install WireGuard client for Windows (if needed for testing)
   # Download from: https://www.wireguard.com/install/

   # Test basic connectivity to VPN servers
   # (specific commands depend on your VPN provider)
   # Note: Docker containers will handle VPN connections
   ```

**Note**: Update status to `COMPLETED` after obtaining VPN subscription and preparing all required credentials and configuration details.

## Domain and DNS Setup (Optional but Recommended) `PLANNED`

### Domain Requirements
- **Registrar**: Any ICANN-accredited registrar
- **DNS**: Ability to create subdomains (A records)
- **SSL**: Let's Encrypt compatibility

### DNS Configuration
Set up these subdomains (example for `yourdomain.com`):
- `plex.yourdomain.com` → Plex Media Server
- `overseerr.yourdomain.com` → Overseerr
- `radarr.yourdomain.com` → Radarr
- `sonarr.yourdomain.com` → Sonarr
- `bazarr.yourdomain.com` → Bazarr
- `prowlarr.yourdomain.com` → Prowlarr
- `tdarr.yourdomain.com` → Tdarr (optional)
- `proxy.yourdomain.com` → Nginx Proxy Manager admin

### DNS Propagation Check
```bash
# Check DNS propagation
nslookup plex.yourdomain.com
nslookup proxy.yourdomain.com
```

**Note**: Update status to `COMPLETED` after configuring domain DNS records and verifying DNS propagation for all required subdomains.

## Storage Preparation `PLANNED`

### Local Storage Assessment
```powershell
# Check available disk space
Get-WmiObject -Class Win32_LogicalDisk | Select-Object Size, FreeSpace, DeviceID

# Check filesystem types
Get-Volume | Select-Object DriveLetter, FileSystemType, Size, SizeRemaining

# Check mount points
Get-WmiObject -Class Win32_MappedLogicalDisk | Select-Object Name, ProviderName
```

### Storage Performance Testing
```powershell
# Test write performance
$testFile = "$env:TEMP\testfile.tmp"
$stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
1..1000 | ForEach-Object { $null | Out-File -FilePath $testFile -Append }
$stopwatch.Stop()
Write-Host "Write performance: $($stopwatch.Elapsed.TotalSeconds) seconds"

# Test read performance
$stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
Get-Content $testFile | Out-Null
$stopwatch.Stop()
Write-Host "Read performance: $($stopwatch.Elapsed.TotalSeconds) seconds"

# Clean up
Remove-Item $testFile -Force
```

**Note**: Update status to `COMPLETED` after assessing storage capacity and performance, ensuring adequate space for media libraries and temporary files.

## System Optimization `PLANNED`

### Windows Performance Tuning
For high-performance media serving on Windows:

```powershell
# Optimize Windows for file sharing
Set-SmbServerConfiguration -EnableMultiChannel $true -Force

# Increase TCP connection limits (requires admin privileges)
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" -Name "MaxUserPort" -Value 65534
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" -Name "TcpTimedWaitDelay" -Value 30
```

### Docker Desktop Configuration
Docker Desktop settings are configured through the GUI:

1. **Resources**: Allocate sufficient CPU and RAM to Docker Desktop
2. **File Sharing**: Ensure project directories are shared with Docker
3. **Advanced**: Enable experimental features if needed
4. **Network**: Configure proxy settings if behind corporate firewall

```powershell
# Verify Docker Desktop is running and accessible
docker system info
```

**Note**: Update status to `COMPLETED` after applying system optimizations and configuring Docker Desktop for optimal media serving performance.

## Security Hardening `PLANNED`

### Windows Security Configuration
```powershell
# Enable Windows Defender real-time protection
Set-MpPreference -DisableRealtimeMonitoring $false

# Configure Windows Update for automatic updates
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" -Name "AUOptions" -Value 4

# Enable Windows Firewall
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled True
```

### Remote Desktop Security (if using RDP)
```powershell
# Configure RDP security settings
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" -Name "SecurityLayer" -Value 2
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" -Name "UserAuthentication" -Value 1
```

### Automatic Updates
Windows Update handles automatic updates. Ensure your system is set to download and install updates automatically.

**Note**: Update status to `COMPLETED` after implementing all security hardening measures and configuring automatic updates.

## Pre-Deployment Checklist `PLANNED`

- [ ] System meets hardware requirements `PLANNED`
- [ ] Linux distribution is supported `PLANNED`
- [ ] Docker and Docker Compose are installed and working `PLANNED`
- [ ] User account created with proper permissions `PLANNED`
- [ ] Firewall configured with basic rules `PLANNED`
- [ ] Network connectivity verified `PLANNED`
- [ ] VPN service subscription obtained `PLANNED`
- [ ] Domain configured (optional) `PLANNED`
- [ ] Storage space verified and performant `PLANNED`
- [ ] System optimized for media serving `PLANNED`
- [ ] Security hardening applied `PLANNED`

**Note**: Update status to `COMPLETED` after verifying all checklist items are satisfied and all prerequisites are properly configured.

## Next Steps

Once all prerequisites are met, proceed to [Phase 2: Repository Setup and Initial Configuration](../SETUP-2-Repository-Setup.md).

## Troubleshooting

### Common Issues

**Docker Desktop not starting:**
```powershell
# Check if Hyper-V is enabled
Get-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V

# Restart Docker Desktop service
Restart-Service com.docker.service

# Check Docker Desktop logs in Windows Event Viewer
```

**Firewall blocking connections:**
```powershell
# Check Windows Firewall status
Get-NetFirewallProfile

# Temporarily disable for testing
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False
# Re-enable after testing
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled True
```

**Storage permission issues:**
```powershell
# Check current user
whoami

# Check current directory permissions
Get-Acl . | Format-List

# Fix permissions if needed (run as administrator)
icacls "C:\path\to\directory" /grant "USERNAME:(OI)(CI)F" /T
```
