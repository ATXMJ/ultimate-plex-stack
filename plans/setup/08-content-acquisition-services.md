# Step 8: Content Acquisition Services (VPN-Routed)

**Status:** `COMPLETE`

This document details the setup of download clients (qBittorrent/NZBGet) and ensuring they are routed through the VPN container.

**Agent Instructions:** After deploying download clients, prompt user to change default passwords immediately for security. Verify VPN routing before marking complete.

## Objectives
- Deploy qBittorrent and/or NZBGet.
- Route their traffic through the `vpn` service.
- Verify they share the VPN's IP address.

## Implementation Notes
- **Password Configuration**: LinuxServer qBittorrent container does not support `WEBUI_PASSWORD` environment variable. Password must be set via manual PBKDF2 hash in `qBittorrent.conf`.
- **Hash Generation**: Use Python script with PBKDF2-SHA256, 10000 iterations, 32-byte salt/hash, base64 encoded.

## Detailed Implementation Steps

1.  **Configure Docker Compose Service** [COMPLETE]
    *   Review `qbittorrent` service.
    *   **Critical:** Ensure `network_mode: "service:vpn"` is set.
    *   Remove any `ports` section from `qbittorrent` service itself (ports must be exposed on the `vpn` service instead).
    *   *Check:* The `vpn` service in compose must have `8080:8080` (for qBittorrent UI) listed in its ports.
    *   Update the status of this sub-step to `[COMPLETE]`.

2.  **Start Download Clients** [COMPLETE]
    *   Run: `docker compose up -d qbittorrent`.
    *   (And/Or `nzbget`).
    *   Update the status of this sub-step to `[COMPLETE]`.

3.  **Access Web UI** [COMPLETE]
    *   Open browser: `http://localhost:8080` (qBittorrent).
    *   Credentials: `admin` / `izSgN3sh88mpZx` (statically configured via config file).
    *   **Note:** Password is permanently set via PBKDF2 hash in qBittorrent.conf, not environment variables.
    *   Update the status of this sub-step to `[COMPLETE]`.

4.  **Verify Network Routing (The "Leak Test")** [COMPLETE]
    *   **Method 1 (Command Line):**
        *   `docker compose exec qbittorrent curl -s https://ifconfig.me`
        *   *Result:* Must match the VPN IP, NOT the host IP.
    *   **Method 2 (Torrent IP Check):**
        *   Download a "Check My Torrent IP" magnet link (e.g., from generic tools).
        *   Check the tracker status in qBittorrent.
        *   *Result:* Must show VPN IP.
    *   Update the status of this sub-step to `[COMPLETE]`.

5.  **Configure Download Paths** [COMPLETE]
    *   Set Default Save Path to `/downloads/complete`.
    *   Set Incomplete Save Path to `/downloads/incomplete`.
    *   Update the status of this sub-step to `[COMPLETE]`.

6.  **Update Documentation** [COMPLETE]
    *   Once all preceding steps in this document are `[COMPLETE]`:
    *   Update `docs/Services.md` with Download Client details.
    *   Update `docs/Networking.md` regarding the VPN routing for these services.
    *   Update the status of this sub-step to `[COMPLETE]`.

7.  **Mark Step as Complete** [COMPLETE]
    *   Once all preceding steps in this document are `[COMPLETE]`:
    *   Update the status at the top of this file to `COMPLETE`.
    *   Update `setup/SETUP.md` to mark Step 9 as `[COMPLETE]`.
    *   Update the status of this sub-step to `[COMPLETE]`.


