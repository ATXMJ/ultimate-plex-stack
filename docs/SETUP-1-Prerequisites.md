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

## System Requirements

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

#### Operating System
- **Supported**: Ubuntu 20.04+, Debian 11+, CentOS 8+, Fedora 35+
- **Architecture**: x86_64 (AMD64)
- **Kernel**: Linux kernel 4.15 or newer

#### Required Software Packages
```bash
# Update package lists
sudo apt update

# Install essential packages
sudo apt install -y curl wget git ufw htop iotop ncdu rsync

# Install Docker and Docker Compose
sudo apt install -y docker.io docker-compose-plugin

# Optional: Install additional monitoring tools
sudo apt install -y fail2ban unattended-upgrades
```

#### Docker Version Requirements
- **Docker Engine**: 20.10.0 or newer
- **Docker Compose**: 2.0.0 or newer (plugin version)

Verify installations:
```bash
docker --version
docker compose version
```

## User and Permission Setup

### Create Dedicated Service User (Recommended)
```bash
# Create plex user with appropriate groups
sudo useradd -m -s /bin/bash plex
sudo usermod -aG docker plex
sudo usermod -aG sudo plex  # Optional: for administrative tasks

# Set password for plex user
sudo passwd plex

# Switch to plex user for remaining setup
su - plex
```

### File System Permissions
The setup requires proper permissions for Docker volume mounts and media access.

## Network and Firewall Configuration

### Firewall Setup (UFW)
```bash
# Enable UFW
sudo ufw enable

# Allow SSH (change port if using non-standard)
sudo ufw allow ssh
sudo ufw allow 22/tcp

# Allow HTTP/HTTPS for reverse proxy
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp

# Allow Plex ports (initially - will be restricted later)
sudo ufw allow 32400/tcp
sudo ufw allow 32400/udp

# Allow VPN ports (WireGuard)
sudo ufw allow 51820/udp

# Reload firewall
sudo ufw reload

# Verify status
sudo ufw status
```

### Network Interface Configuration
Ensure your network interfaces are properly configured:

```bash
# Check network interfaces
ip addr show

# Test internet connectivity
ping -c 4 8.8.8.8

# Test DNS resolution
nslookup google.com
```

## VPN Service Preparation

### VPN Requirements
- **Provider**: Mullvad, ProtonVPN, or similar no-logs provider
- **Protocol**: WireGuard (preferred) or OpenVPN
- **Features**: Kill switch support, port forwarding (for torrenting)

### VPN Credentials Setup
Prepare your VPN credentials (will be used in Phase 6):

1. **Obtain VPN Subscription**
   - Choose a reputable no-logs VPN provider
   - Ensure they support port forwarding
   - Verify Linux client compatibility

2. **Gather Required Information**
   - VPN server endpoint/hostname
   - Username/credentials
   - Protocol configuration (WireGuard preferred)
   - Kill switch configuration details

3. **Test VPN Connection** (Manual verification)
   ```bash
   # Install OpenVPN or WireGuard client for testing
   sudo apt install -y openvpn wireguard-tools

   # Test basic connectivity to VPN servers
   # (specific commands depend on your VPN provider)
   ```

## Domain and DNS Setup (Optional but Recommended)

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

## Storage Preparation

### Local Storage Assessment
```bash
# Check available disk space
df -h

# Check filesystem types
df -T

# Check mount points
mount | grep -E "(ext4|xfs|btrfs|zfs)"
```

### Storage Performance Testing
```bash
# Test write performance
dd if=/dev/zero of=/tmp/testfile bs=1M count=1000 conv=fdatasync

# Test read performance
dd if=/tmp/testfile of=/dev/null bs=1M count=1000

# Clean up
rm /tmp/testfile
```

## System Optimization

### Kernel Parameters (Optional)
For high-performance media serving:

```bash
# Increase max open files
echo "fs.file-max = 2097152" | sudo tee -a /etc/sysctl.conf

# Optimize network settings
echo "net.core.somaxconn = 65535" | sudo tee -a /etc/sysctl.conf
echo "net.ipv4.tcp_max_syn_backlog = 65535" | sudo tee -a /etc/sysctl.conf

# Apply changes
sudo sysctl -p
```

### Docker Configuration
```bash
# Create Docker daemon configuration
sudo tee /etc/docker/daemon.json > /dev/null <<EOF
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  },
  "storage-driver": "overlay2"
}
EOF

# Restart Docker
sudo systemctl restart docker
```

## Security Hardening

### SSH Configuration
```bash
# Backup original config
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.backup

# Disable root login
sudo sed -i 's/#PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config

# Disable password authentication (use keys)
sudo sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config

# Restart SSH
sudo systemctl restart ssh
```

### Automatic Updates
```bash
# Configure unattended upgrades
sudo dpkg-reconfigure --priority=low unattended-upgrades

# Verify configuration
cat /etc/apt/apt.conf.d/50unattended-upgrades
```

## Pre-Deployment Checklist

- [ ] System meets hardware requirements
- [ ] Linux distribution is supported
- [ ] Docker and Docker Compose are installed and working
- [ ] User account created with proper permissions
- [ ] Firewall configured with basic rules
- [ ] Network connectivity verified
- [ ] VPN service subscription obtained
- [ ] Domain configured (optional)
- [ ] Storage space verified and performant
- [ ] System optimized for media serving
- [ ] Security hardening applied

## Next Steps

Once all prerequisites are met, proceed to [Phase 2: Repository Setup and Initial Configuration](../SETUP-2-Repository-Setup.md).

## Troubleshooting

### Common Issues

**Docker permission denied:**
```bash
# Add user to docker group
sudo usermod -aG docker $USER
# Logout and login again
```

**Firewall blocking connections:**
```bash
# Check UFW status
sudo ufw status

# Temporarily disable for testing
sudo ufw disable
# Re-enable after testing
sudo ufw enable
```

**Storage permission issues:**
```bash
# Check current user
whoami

# Check group membership
groups

# Fix permissions if needed
sudo chown -R $USER:$USER /path/to/directory
```
