# Networking and Security

## Internal Networking
- **Docker Network**: `proxy` (isolated bridge network)
- **Service Discovery**: Container names for inter-service communication
- **Port Exposure**: Only expose necessary ports to host

## External Access and Port Forwarding

### Domain Name Strategy
- **Selected Domain**: `cooperstation.stream`
- **DNS Strategy**: Cloudflare recommended for easier management and dynamic updates.
- **DNS Records to Plan**:
    - `plex.cooperstation.stream` -> Public Home IP
    - `overseerr.cooperstation.stream` -> Public Home IP
    - `radarr.cooperstation.stream` -> Public Home IP
    - `sonarr.cooperstation.stream` -> Public Home IP
    - `*.cooperstation.stream` -> Public Home IP (Wildcard CNAME recommended if supported).

### DHCP Reservation
- **Objective**: Ensure this system always receives the same local IP address (`192.168.1.124`) for consistent port forwarding.
- **Device MAC Address (Wi-Fi)**: `28-CD-C4-AB-7E-FD`
- **Reserved IP**: `192.168.1.124`

### Port Forwarding Rules (Netgear Orbi RBRE960)
- **Objective**: Forward external ports to your host machine's local IP (`192.168.1.124`).
- **Rules**:
    - **Rule 1 (HTTP)**: External Port `80` -> Internal Port `80` -> Internal IP `192.168.1.124` (TCP)
    - **Rule 2 (HTTPS)**: External Port `443` -> Internal Port `443` -> Internal IP `192.168.1.124` (TCP)
    - **Rule 3 (Plex Direct - Optional)**: External Port `32400` -> Internal Port `32400` -> Internal IP `192.168.1.124` (TCP)
- **Important**: Do NOT forward ports for Radarr (7878), Sonarr (8989), etc., directly. These will be accessed securely via `cooperstation.stream` through port 443.

## VPN Integration

**VPN is used exclusively for content acquisition clients to protect download traffic.**

### VPN Configuration
- **Provider:** NordVPN
- **Protocol:** OpenVPN (TCP)
- **Authentication:** Service Credentials
- **Server Preference:** Panama (primary), Switzerland (fallback)
- **Container:** gluetun (qmcgaw/gluetun:latest)
- **Status:** ✅ Active and verified

### Connection Details
- **Current Server:** ch408.nordvpn.com (Switzerland, Zurich)
- **Verified Public IP:** 31.40.215.212 (Masked through NordVPN)
- **Connection Type:** TCP over port 443
- **Tunnel Interface:** tun0
- **DNS:** Cloudflare (via gluetun built-in DNS)
- **Health Status:** ✅ Healthy

### Services Using VPN
- **qBittorrent** (torrent client) - Routes ALL traffic through VPN
- **NZBGet** (usenet client) - Routes ALL traffic through VPN

### Services NOT Using VPN (Direct Internet Connection)
- **Plex Media Server** - Direct connection for streaming
- **Radarr, Sonarr** - Direct connection for indexer searches and metadata
- **Prowlarr** - Direct connection for indexer management
- **Bazarr** - Direct connection for subtitle providers
- **Tdarr** - Direct connection (no external traffic typically)
- **Overseerr** - Direct connection for user requests
- **Nginx Proxy Manager** - Direct connection for reverse proxy

### Kill Switch Implementation

**Critical Security Feature**: The kill switch ensures torrent and usenet clients **CANNOT access the internet** if the VPN connection drops. This prevents any possibility of IP address leaks during downloads.

**Implementation Method**: Infrastructure-level protection via gluetun's built-in firewall - **NOT client configuration**

**Status:** ✅ Enabled by default in gluetun

**Firewall Rules:**
- Allows outbound traffic only through tun0 (VPN tunnel)
- Allows local network communication: 172.16.0.0/12, 192.168.0.0/16
- Blocks ALL other traffic if VPN disconnects
- Automatic enforcement - no manual iptables required

**How It Works**:
1. **Docker Network Management**: Clients use `network_mode: "service:vpn"` to share VPN container's network stack
2. **Forced VPN Routing**: Clients have NO direct network access - they inherit VPN container's network interface
3. **iptables Kill Switch**: Rules on VPN container block all non-VPN traffic
4. **Automatic Enforcement**: If VPN disconnects, tunnel interface disappears and iptables blocks everything
5. **No Client Configuration Needed**: Protection is enforced at infrastructure level, clients cannot bypass it
6. **IP Leak Prevention**: NO traffic can reach your real IP address - mathematically impossible with this setup

**Key Advantages**:
- ✅ Clients cannot bypass VPN (they don't have their own network stack)
- ✅ No client configuration required (works with default settings)
- ✅ Infrastructure-level security (more reliable than client-level settings)
- ✅ Automatic protection (no manual setup per client)

### Network Architecture
- **Torrent/Usenet containers** use `network_mode: "service:vpn"` to route through VPN
  - This is **Docker Compose configuration**, not client application settings
  - Clients inherit VPN container's entire network stack automatically
- **All other services** use standard Docker bridge networking (no VPN)
- **Kill switch** completely blocks internet access for torrent/usenet if VPN disconnects
  - Enforced at infrastructure level (iptables on VPN container)
  - Clients have no ability to bypass this protection

## Access Control

### Authentication Overview
Each service in the stack requires individual authentication configuration. The stack is designed with security-first defaults, requiring explicit setup of credentials for all web interfaces.

**User Access Patterns:**
- **End Users**: Primarily access Plex (streaming) and Overseerr (content requests)
- **Administrators**: Access all management services (Radarr, Sonarr, Bazarr, Tdarr, Prowlarr)
- **Services without native authentication** are secured through reverse proxy authentication

### Service Authentication Details

**Plex Media Server**
- **Authentication**: Native - Required, uses Plex account integration
- **Setup**: Claim token required during initial setup
- **User Management**: Plex account users, family sharing support
- **Remote Access**: Configurable through Plex account settings

**Overseerr**
- **Authentication**: Native - Required
- **Methods**: Plex account integration (recommended) or local accounts
- **Setup**: Must configure authentication during initial setup
- **Integration**: Seamlessly integrates with Plex user management

**Management Services (Radarr, Sonarr, Bazarr, Prowlarr)**
- **Authentication**: Reverse proxy required (no native auth)
- **Default State**: No authentication (must be secured via proxy)
- **Setup**: Configure authentication in Nginx Proxy Manager
- **Access**: Admin-only via secured subdomains

**Tdarr**
- **Authentication**: Optional native auth available
- **Default State**: No authentication
- **Setup**: Configure in web interface or secure via reverse proxy

**Content Acquisition (qBittorrent, NZBGet)**
- **Authentication**: Required
- **Setup**: Configure strong username/password during initial setup
- **Security Note**: These services handle sensitive download operations

**Tdarr**
- **Authentication**: Optional
- **Default State**: No authentication
- **Setup**: Configure in web interface if needed

**Nginx Proxy Manager**
- **Authentication**: Required for admin interface
- **Setup**: Configure admin credentials during initial setup
- **Purpose**: Manages SSL certificates and routing

### Authentication Best Practices
- **Strong Passwords**: Use complex passwords for all services
- **Unique Credentials**: Different passwords for each service
- **Plex Integration**: Leverage Plex's built-in user management where possible
- **Network Security**: Combine authentication with network restrictions
- **Regular Updates**: Change default passwords immediately after setup
- **VPN Protection**: Torrent and usenet clients are automatically protected via VPN gateway

### Reverse Proxy Authentication for Admin Services
For services without native authentication (Radarr, Sonarr, Bazarr, Tdarr, Prowlarr), secure access through Nginx Proxy Manager:

**Setup Options:**
1. **Basic Authentication**: Username/password protection at proxy level
2. **IP Restrictions**: Limit access to specific IP addresses/networks
3. **Local Network Only**: Restrict admin services to LAN access only
4. **OAuth Integration**: Use external authentication providers

**Recommended Configuration:**
- Create separate subdomains (e.g., `radarr.cooperstation.stream`, `sonarr.cooperstation.stream`)
- Enable SSL certificates for each subdomain
- Configure basic auth or IP restrictions for admin-only services
- Keep Plex and Overseerr publicly accessible (with their native auth)

**Example Nginx Proxy Manager Setup:**
```
Proxy Host: radarr.cooperstation.stream
- Forward to: http://radarr:7878
- SSL: Enable with Let's Encrypt
- Access List: Admin-only (basic auth or IP restriction)
```

### Multi-User Considerations
- **Plex Accounts**: Primary user management system
- **Overseerr Integration**: Provides request management with user authentication
- **Access Levels**: Configure appropriate permissions for different users
- **Family Sharing**: Plex supports multiple user accounts with different access levels

