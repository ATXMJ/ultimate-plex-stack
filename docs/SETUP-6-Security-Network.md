# Phase 6: Security and Network Setup

This phase establishes secure access to your media stack through VPN protection for download services, SSL certificates for web access, and proper authentication controls.

## Collaborative Implementation Notes

When working through this phase with the AI assistant:

### Agent Guidance
- **Security Assessment**: The agent will help evaluate your current security posture
- **VPN Configuration**: Step-by-step setup of VPN gateway and kill switch functionality
- **SSL Certificate Management**: Guidance through obtaining and configuring SSL certificates
- **Authentication Setup**: Help configuring secure access controls for all services

### What You'll Need to Provide
- **Security Preferences**: Your requirements for access control and authentication methods
- **Domain Access**: Administrative access to your domain registrar for DNS configuration
- **VPN Details**: Your VPN provider configuration and kill switch preferences
- **Certificate Preferences**: Whether you prefer Let's Encrypt or custom certificates

### Interactive Process
- **Security Planning**: The agent will help you design appropriate security measures for your use case
- **DNS Configuration**: Guidance for setting up domain records and SSL challenges
- **Testing Security**: Together you'll test authentication, SSL, and VPN functionality
- **Access Verification**: The agent will help verify that security measures work without blocking legitimate access

## Security Architecture Overview `PLANNED`

The security setup includes:
- **VPN Gateway**: Protects torrent and usenet traffic
- **Reverse Proxy**: SSL termination and traffic routing
- **Authentication**: Secure access to management services
- **Firewall Rules**: Network access control

## VPN Gateway Setup `PLANNED`

### Deploy VPN Services
```bash
# Add VPN profile to running services
docker compose --profile core --profile proxy up -d

# Deploy VPN gateway (WireGuard)
docker compose --profile torrent up -d

# Note: Start with proxy profile, VPN will be added in Phase 7
```

### WireGuard VPN Configuration
1. **Access WireGuard Web Interface**
```bash
# WireGuard UI (if available) or configure via config files
echo "WireGuard may be accessible at: http://$(hostname -I | awk '{print $1}'):51820"
```

2. **VPN Configuration Files**
```bash
# VPN config files are stored in config/wireguard/
ls -la config/wireguard/

# Typical WireGuard configuration structure:
# wg0.conf - Main configuration
# peer1.conf, peer2.conf - Client configurations
```

3. **VPN Kill Switch Setup**
```bash
# Create kill switch script
cat > shared/scripts/vpn-killswitch.sh << 'EOF'
#!/bin/bash
# VPN Kill Switch for torrent traffic
# This ensures no torrent traffic leaks if VPN disconnects

# iptables rules for kill switch
iptables -F
iptables -X
iptables -t nat -F
iptables -t nat -X
iptables -t mangle -F
iptables -t mangle -X

# Allow local traffic
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

# Allow established connections
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -A OUTPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# Allow SSH (adjust port if changed)
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
iptables -A OUTPUT -p tcp --sport 22 -j ACCEPT

# Allow VPN traffic
iptables -A INPUT -i wg0 -j ACCEPT
iptables -A OUTPUT -o wg0 -j ACCEPT

# Allow Plex traffic (direct)
iptables -A INPUT -p tcp --dport 32400 -j ACCEPT
iptables -A OUTPUT -p tcp --sport 32400 -j ACCEPT

# Block all other torrent/usenet ports when VPN down
# This will be managed by the VPN container

echo "VPN kill switch rules applied"
EOF

chmod +x shared/scripts/vpn-killswitch.sh
```

## Nginx Proxy Manager Setup `PLANNED`

### Initial NPM Configuration
```bash
# Deploy Nginx Proxy Manager
docker compose --profile proxy up -d

# Access NPM admin interface
echo "Nginx Proxy Manager: http://$(hostname -I | awk '{print $1}'):81"
echo "Default credentials: admin@example.com / changeme"
```

### NPM Initial Setup
1. **Change Default Password**
   - Access http://your-server:81
   - Login with default credentials
   - Change password immediately

2. **SSL Certificate Configuration**
   - Go to SSL Certificates → Add SSL Certificate
   - Choose "Let's Encrypt"
   - Domain: `yourdomain.com`
   - Email: your-email@yourdomain.com

### Create Proxy Hosts

#### Plex Media Server
```bash
# Create proxy host for Plex
# Domain: plex.yourdomain.com
# Forward to: http://plex:32400
# SSL: Enable with Let's Encrypt
# Websockets: Enable (required for Plex)
```

#### Overseerr
```bash
# Create proxy host for Overseerr
# Domain: overseerr.yourdomain.com (or requests.yourdomain.com)
# Forward to: http://overseerr:5055
# SSL: Enable
# Authentication: None (uses Plex auth)
```

#### Management Services (Protected)
```bash
# Create proxy hosts for admin services with authentication

# Radarr
# Domain: radarr.yourdomain.com
# Forward to: http://radarr:7878
# SSL: Enable
# Access List: Admin Only (create auth list)

# Sonarr
# Domain: sonarr.yourdomain.com
# Forward to: http://sonarr:8989
# SSL: Enable
# Access List: Admin Only

# Prowlarr
# Domain: prowlarr.yourdomain.com
# Forward to: http://prowlarr:9696
# SSL: Enable
# Access List: Admin Only
```

### Access List Configuration
1. **Create Admin Access List**
   - Access Lists → Add Access List
   - Name: "Admin Only"
   - Authorization: Basic Auth
   - Create admin user with strong password

2. **IP-Based Access (Optional)**
   - Add IP restrictions for admin services
   - Allow only trusted networks

## Service Authentication Configuration `PLANNED`

### Update Service URLs

Now that services are behind the reverse proxy, update internal service configurations:

#### Radarr External URL
```bash
# In Radarr Settings → General
# URL Base: (leave blank if using subdomain)
# Or configure for reverse proxy if needed
```

#### Sonarr External URL
```bash
# In Sonarr Settings → General
# URL Base: (leave blank)
```

#### Overseerr External URL
```bash
# In Overseerr Settings → General
# Overseerr URL: https://overseerr.yourdomain.com
```

### Plex Remote Access
1. **Enable Remote Access in Plex**
   - Settings → Remote Access
   - Enable remote access
   - Configure custom certificate if needed

2. **Plex Claim Token**
   - Ensure claim token is still valid
   - Re-claim if necessary

## Firewall Configuration `PLANNED`

### Update UFW Rules
```bash
# Allow HTTPS and HTTP for reverse proxy
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp

# Allow SSH (restrict to specific IPs if possible)
sudo ufw allow ssh

# Allow Plex direct access (optional, can be removed later)
sudo ufw allow 32400/tcp

# Deny all other incoming traffic by default
sudo ufw default deny incoming
sudo ufw default allow outgoing

# Reload firewall
sudo ufw reload

# Verify rules
sudo ufw status
```

### Advanced Firewall Rules
```bash
# Create advanced firewall script
cat > shared/scripts/configure-firewall.sh << 'EOF'
#!/bin/bash
# Advanced firewall configuration for media stack

# Allow VPN traffic
ufw allow 51820/udp

# Allow Nginx Proxy Manager admin (temporary)
ufw allow 81/tcp

# Rate limiting for SSH
ufw limit ssh/tcp

# Allow Docker container communication
ufw allow from 172.20.0.0/16 to any

# Allow specific service ports (if not using reverse proxy exclusively)
# ufw allow 7878/tcp  # Radarr (if direct access needed)
# ufw allow 8989/tcp  # Sonarr (if direct access needed)

ufw reload
echo "Advanced firewall rules applied"
EOF

chmod +x shared/scripts/configure-firewall.sh
./shared/scripts/configure-firewall.sh
```

## SSL Certificate Management `PLANNED`

### Let's Encrypt Automation
```bash
# NPM handles SSL automatically, but monitor certificates:
# - Certificates expire in 90 days
# - NPM renews automatically
# - Check SSL status in NPM dashboard
```

### Custom SSL Certificates (Optional)
```bash
# If using custom certificates:
# - Place .key and .crt files in shared/ssl/
# - Import into NPM SSL Certificates section
# - Update proxy hosts to use custom certificates
```

## Network Security Testing `PLANNED`

### SSL Certificate Validation
```bash
# Test SSL certificates
echo "Testing SSL certificates..."

# Test main domain
openssl s_client -connect yourdomain.com:443 -servername yourdomain.com < /dev/null 2>/dev/null | openssl x509 -noout -dates

# Test subdomains
openssl s_client -connect plex.yourdomain.com:443 -servername plex.yourdomain.com < /dev/null 2>/dev/null | openssl x509 -noout -dates

# Test with curl
curl -I https://plex.yourdomain.com
curl -I https://radarr.yourdomain.com
```

### Authentication Testing
```bash
# Test basic auth for protected services
curl -u admin:password https://radarr.yourdomain.com/api/v3/system/status

# Test Plex token authentication
curl -H "X-Plex-Token: YOUR_TOKEN" https://plex.yourdomain.com/library/sections
```

### VPN Leak Testing
```bash
# Test VPN connectivity (after Phase 7)
# Use services like ipleak.net or dnsleaktest.com
# Verify torrent traffic routes through VPN
```

## Service Security Hardening `PLANNED`

### Disable Unnecessary Services
```bash
# Disable direct service ports (force reverse proxy usage)
# Comment out direct port exposures in docker-compose.yml

# Example: Disable direct Radarr access
# sed -i 's/7878:7878/# 7878:7878/' docker-compose.yml
```

### API Key Security
```bash
# Ensure API keys are complex and unique
# Store securely (not in plain text configs)

# Generate strong API keys
openssl rand -hex 32

# Update service configurations with strong keys
```

### Log Security
```bash
# Monitor logs for security events
docker compose --profile core logs | grep -i "unauthorized\|forbidden\|error"

# Set up log rotation
# Configure in docker-compose.yml logging section
```

## Backup Security Configurations `PLANNED`

```bash
# Create security backup
BACKUP_DIR="temp/backups/security-$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

# Backup configurations
cp -r config/nginx-proxy-manager "$BACKUP_DIR/"
cp -r config/wireguard "$BACKUP_DIR/"

# Backup firewall rules
sudo ufw status > "$BACKUP_DIR/ufw-rules.txt"

# Backup SSL certificates (if custom)
cp -r shared/ssl "$BACKUP_DIR/"

echo "Security backup created in: $BACKUP_DIR"
```

## Monitoring and Alerts `PLANNED`

### Security Monitoring Script
```bash
# Create security monitoring script
cat > shared/scripts/security-monitor.sh << 'EOF'
#!/bin/bash
echo "=== Security Status Report ==="
echo "Generated: $(date)"
echo

# Check firewall status
echo "Firewall Status:"
sudo ufw status | grep -E "(Status|80|443|32400)"

# Check VPN status
echo -e "\nVPN Status:"
if pgrep -f "wireguard\|openvpn" > /dev/null; then
    echo "✓ VPN processes running"
else
    echo "✗ No VPN processes found"
fi

# Check SSL certificates
echo -e "\nSSL Certificate Status:"
if openssl s_client -connect yourdomain.com:443 < /dev/null 2>/dev/null | openssl x509 -noout -checkend 2592000 > /dev/null; then
    echo "✓ SSL certificate valid (>30 days)"
else
    echo "✗ SSL certificate expires soon or invalid"
fi

# Check service accessibility
echo -e "\nService Access Status:"
if curl -s --max-time 5 https://plex.yourdomain.com > /dev/null; then
    echo "✓ Plex accessible via HTTPS"
else
    echo "✗ Plex not accessible via HTTPS"
fi

echo "Security check complete"
EOF

chmod +x shared/scripts/security-monitor.sh
```

## Troubleshooting Security Issues

### Common Security Problems

**SSL Certificate Issues:**
```bash
# Check Let's Encrypt logs in NPM
docker compose --profile proxy logs nginx-proxy-manager

# Test domain DNS
nslookup yourdomain.com

# Check firewall blocking port 80
sudo ufw status | grep 80
```

**VPN Connection Problems:**
```bash
# Check VPN logs
docker compose --profile torrent logs wireguard

# Test VPN connectivity
ping -c 4 8.8.8.8

# Check kill switch rules
sudo iptables -L | grep wg0
```

**Authentication Failures:**
```bash
# Test basic auth manually
curl -u username:password https://radarr.yourdomain.com

# Check NPM access list configuration
# Verify username/password in NPM admin
```

**Reverse Proxy Issues:**
```bash
# Check NPM logs
docker compose --profile proxy logs nginx-proxy-manager

# Test backend connectivity
docker compose --profile core exec nginx-proxy-manager curl http://plex:32400

# Verify proxy host configuration
```

### Recovery Procedures
```bash
# Emergency direct access (if reverse proxy fails)
# Temporarily expose service ports directly
docker compose --profile core up -d --scale nginx-proxy-manager=0

# Restore from backup
cp -r temp/backups/security-*/* config/

# Reset firewall to basic rules
sudo ufw reset
sudo ufw enable
sudo ufw allow ssh
sudo ufw allow 80,443/tcp
```

## Security Validation Checklist `PLANNED`

- [ ] VPN gateway configured with kill switch `PLANNED`
- [ ] Nginx Proxy Manager deployed and configured `PLANNED`
- [ ] SSL certificates obtained and working `PLANNED`
- [ ] Proxy hosts created for all services `PLANNED`
- [ ] Authentication configured for admin services `PLANNED`
- [ ] Firewall rules updated and secure `PLANNED`
- [ ] Service URLs updated for reverse proxy `PLANNED`
- [ ] SSL certificate validation passing `PLANNED`
- [ ] Authentication working correctly `PLANNED`
- [ ] Security configurations backed up `PLANNED`

## Next Steps

With security and networking configured, proceed to [Phase 7: Advanced Services (Optional)](../SETUP-7-Advanced-Services.md) to add torrent/usenet capabilities and other advanced features.

## Ongoing Security Maintenance

### Regular Security Tasks
- Monitor SSL certificate expiration
- Update VPN credentials regularly
- Review access logs for suspicious activity
- Keep services updated with security patches
- Rotate API keys and passwords periodically

### Security Monitoring
```bash
# Add to cron for regular security checks
echo "0 */6 * * * /path/to/ultimate-plex-stack/shared/scripts/security-monitor.sh" | crontab -

# Monitor failed authentication attempts
docker compose --profile proxy logs nginx-proxy-manager | grep -i "auth"
```
