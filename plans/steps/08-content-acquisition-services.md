# Step 8: Content Acquisition Services (VPN-Routed)

**Status:** `PLANNED`

This document details the setup of download clients (qBittorrent/NZBGet) and ensuring they are routed through the VPN container.

**Agent Instructions:** After deploying download clients, prompt user to change default passwords immediately for security. Verify VPN routing before marking complete.

## Objectives
- Deploy qBittorrent and/or NZBGet.
- Route their traffic through the `vpn` service.
- Verify they share the VPN's IP address.

## Detailed Implementation Steps

1.  **Configure Docker Compose Service** [PLANNED]
    *   Review `qbittorrent` service.
    *   **Critical:** Ensure `network_mode: "service:vpn"` is set.
    *   Remove any `ports` section from `qbittorrent` service itself (ports must be exposed on the `vpn` service instead).
    *   *Check:* The `vpn` service in compose must have `8080:8080` (for qBittorrent UI) listed in its ports.
    *   Update the status of this sub-step to `[COMPLETE]`.

2.  **Start Download Clients** [PLANNED]
    *   Run: `docker compose up -d qbittorrent`.
    *   (And/Or `nzbget`).
    *   Update the status of this sub-step to `[COMPLETE]`.

3.  **Access Web UI** [PLANNED]
    *   Open browser: `http://localhost:8080` (qBittorrent).
    *   Default creds: `admin` / `adminadmin`.
    *   **Action:** Change password immediately.
    *   **Agent Instructions:** Prompt user for new qBittorrent password and confirm they've saved it securely.
    *   Update the status of this sub-step to `[COMPLETE]`.

4.  **Verify Network Routing (The "Leak Test")** [PLANNED]
    *   **Method 1 (Command Line):**
        *   `docker compose exec qbittorrent curl -s https://ifconfig.me`
        *   *Result:* Must match the VPN IP, NOT the host IP.
    *   **Method 2 (Torrent IP Check):**
        *   Download a "Check My Torrent IP" magnet link (e.g., from generic tools).
        *   Check the tracker status in qBittorrent.
        *   *Result:* Must show VPN IP.
    *   Update the status of this sub-step to `[COMPLETE]`.

5.  **Configure Download Paths** [PLANNED]
    *   Set Default Save Path to `/downloads/complete`.
    *   Set Incomplete Save Path to `/downloads/incomplete`.
    *   Update the status of this sub-step to `[COMPLETE]`.

6.  **Update Documentation** [PLANNED]
    *   Once all preceding steps in this document are `[COMPLETE]`:
    *   Update `docs/Services.md` with Download Client details.
    *   Update `docs/Networking.md` regarding the VPN routing for these services.
    *   Update the status of this sub-step to `[COMPLETE]`.

7.  **Mark Step as Complete** [PLANNED]
    *   Once all preceding steps in this document are `[COMPLETE]`:
    *   Update the status at the top of this file to `COMPLETE`.
    *   Update `plans/SETUP.md` to mark Step 9 as `[COMPLETE]`.
    *   Update the status of this sub-step to `[COMPLETE]`.

## Verification Checklist
- [ ] qBittorrent UI accessible.
- [ ] `network_mode: "service:vpn"` confirmed in compose.
- [ ] curl from inside qBittorrent returns VPN IP.
- [ ] Real IP is successfully masked.

