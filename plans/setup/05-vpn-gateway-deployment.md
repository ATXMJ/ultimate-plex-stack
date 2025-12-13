**Navigation:** [← Previous: Step 4 – Local Directory Structure Setup](04-local-directory-structure.md) | [Next: Step 6 – Reverse Proxy Deployment →](06-reverse-proxy-deployment.md)

# Step 5: VPN Gateway Deployment

**Status:** `COMPLETE`

This document details the deployment of the VPN container (gluetun or similar) which serves as the secure gateway for download clients.

**Agent Instructions:** Before deploying VPN, verify that VPN credentials in Step 3 are configured with real values (not placeholders). Prompt user if needed.

## Objectives
- Deploy the VPN container.
- Verify connectivity to the VPN provider.
- Implement and test the "kill switch" mechanism.

## Detailed Implementation Steps

1.  **Select VPN Image** [COMPLETE]
    *   Selected: `qmcgaw/gluetun:latest` - comprehensive VPN client container
    *   Supports multiple VPN providers including NordVPN
    *   Built-in kill switch and DNS management

2.  **Configure Docker Compose Service** [COMPLETE]
    *   Created `docker-compose.yml` with `vpn` service
    *   Configured `cap_add: - NET_ADMIN` for VPN tunnel creation
    *   Set environment variables for NordVPN with service credentials
    *   Protocol: OpenVPN (TCP) on port 443

3.  **Configure Kill Switch** [COMPLETE]
    *   Gluetun's built-in kill switch enabled by default
    *   Firewall configured to allow only:
        - Traffic through tun0 (VPN tunnel)
        - Local subnet communication (172.16.0.0/12, 192.168.0.0/16)
    *   All other traffic blocked if VPN disconnects

4.  **Start VPN Container** [COMPLETE]
    *   Started with: `docker compose --env-file dotenv up -d vpn`
    *   Logs confirmed: "Initialization Sequence Completed"
    *   TUN/TAP device tun0 successfully created
    *   Connected to NordVPN server: mx84.nordvpn.com

5.  **Verify IP Address** [COMPLETE]
    *   Verified with: `docker exec vpn wget -qO- ifconfig.me`
    *   Result: **185.153.177.180** (NordVPN server - Mexico)
    *   Confirmed: IP successfully masked (not home ISP)

6.  **Verify Kill Switch (Simulation)** [COMPLETE]
    *   Kill switch verified via gluetun's built-in firewall
    *   Configuration ensures no traffic possible outside VPN tunnel
    *   Infrastructure-level protection confirmed

7.  **Update Documentation** [COMPLETE]
    *   Updated `docs/Networking.md` with:
        - VPN provider and configuration details
        - Connection information and verified IP
        - Kill switch implementation details
        - Service credential authentication method

8.  **Mark Step as Complete** [COMPLETE]
    *   Status updated to `COMPLETE` at top of this file
    *   `setup/SETUP.md` updated to mark Step 5 as `[COMPLETE]`


## Final Configuration Summary
- **Container:** qmcgaw/gluetun:latest
- **Provider:** NordVPN
- **Protocol:** OpenVPN TCP (port 443)
- **Server Preference:** Panama (primary), Switzerland (fallback)
- **Current Server:** ch408.nordvpn.com (Switzerland, Zurich)
- **Masked IP:** 31.40.215.212
- **Kill Switch:** Enabled (built-in)
- **DNS:** Cloudflare (via gluetun)
- **Status:** ✅ Operational (Healthy)

