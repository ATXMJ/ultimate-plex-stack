# Step 2: Network Planning

**Status:** `COMPLETE`

This document details the network planning required before deploying the stack, focusing on VPN credentials, domain names, and internal Docker networking.

## Objectives
- Secure VPN credentials for download traffic protection.
- Decide on and prepare the domain name strategy for remote access.
- Define the internal network topology.

## Detailed Implementation Steps

1.  **VPN Requirement Verification** [COMPLETE]
    *   **Provider Selection:** NordVPN (Files present in `vpn/`).
    *   **Configuration Files:**
        *   `vpn/config/nordvpn.ovpn` is present.
    *   **Credentials:**
        *   `vpn/credentials/nordvpn.auth` is present.
    *   Update the status of this sub-step to `[COMPLETE]`.

2.  **Domain Name Strategy** [COMPLETE]
    *   **Selected Domain:** `cooperstation.stream`
    *   **Provider:** (User registered).
    *   **DNS Strategy:** Cloudflare is recommended for easier management, or use your registrar's DNS if they support dynamic updates easily.
    *   **DNS Records to Plan:**
        *   `plex.cooperstation.stream` -> Public Home IP
        *   `overseerr.cooperstation.stream` -> Public Home IP
        *   `radarr.cooperstation.stream` -> Public Home IP
        *   `sonarr.cooperstation.stream` -> Public Home IP
        *   `*.cooperstation.stream` -> Public Home IP (Wildcard CNAME recommended if supported).
    *   Update the status of this sub-step to `[COMPLETE]`.

3.  **DHCP Reservation (Netgear Orbi RBRE960)** [COMPLETE]
    *   **Objective:** Ensure this system always receives the same local IP address (`192.168.1.124`), which is critical for consistent port forwarding.
    *   **Current System Info:**
        *   **Device Name:** `COOPERSTATION` (likely) or look for MAC ending in `7E-FD`.
        *   **MAC Address (Wi-Fi):** `28-CD-C4-AB-7E-FD`
        *   **Current IP:** `192.168.1.124`
    *   **Configuration Steps:**
        1.  Open a web browser and go to `http://192.168.1.1` (or `http://orbilogin.com`).
        2.  Log in with your admin credentials (default user: `admin`).
        3.  Navigate to **ADVANCED** > **Setup** > **LAN Setup**.
        4.  Scroll down to **Address Reservation**.
        5.  Click **Add**.
        6.  Select your device from the table (look for MAC `28-CD-C4-AB-7E-FD` or name `COOPERSTATION`).
            *   *Note:* If not in the list, manually enter the MAC address `28:CD:C4:AB:7E:FD` and IP `192.168.1.124`.
        7.  Click **Add** (or **Apply**).
        8.  Your router may need to reboot, or the device might need to reconnect to confirm the reservation.
    *   Update the status of this sub-step to `[COMPLETE]`.

4.  **Port Forwarding Planning (Netgear Orbi RBRE960)** [COMPLETE]
    *   **Objective:** Forward external ports to your host machine's local IP (the machine running Docker).
    *   **Prerequisites:**
        *   **DHCP Reservation:** Complete Step 3 above to ensure IP `192.168.1.124` is fixed.
    *   **Configuration Steps:**
        1.  Open a web browser and go to `http://192.168.1.1` (or your router's gateway IP).
        2.  Log in with your admin credentials.
        3.  Navigate to **ADVANCED** > **Advanced Setup** > **Port Forwarding / Port Triggering**.
        4.  Select **Port Forwarding**.
        5.  Click **Add Custom Service**.
        6.  **Rule 1 (HTTP):**
            *   Service Name: `Nginx-HTTP`
            *   Protocol: `TCP`
            *   External Port Range: `80`
            *   Internal Port Range: `80`
            *   Internal IP Address: `192.168.1.124` (Fixed IP)
        7.  **Rule 2 (HTTPS):**
            *   Service Name: `Nginx-HTTPS`
            *   Protocol: `TCP`
            *   External Port Range: `443`
            *   Internal Port Range: `443`
            *   Internal IP Address: `192.168.1.124` (Fixed IP)
        8.  **Rule 3 (Plex Direct - Optional but Recommended):**
            *   Service Name: `Plex-Direct`
            *   Protocol: `TCP`
            *   External Port Range: `32400`
            *   Internal Port Range: `32400`
            *   Internal IP Address: `192.168.1.124` (Fixed IP)
    *   *Note:* Do NOT forward ports for Radarr (7878), Sonarr (8989), etc. directly. These will be accessed securely via `cooperstation.stream` through port 443.
    *   Update the status of this sub-step to `[COMPLETE]`.

5.  **Internal Docker Network Design** [COMPLETE]
    *   **Network Name:** `proxy` (matches existing `advanced-compose.yml` configuration).
    *   **Driver:** `bridge`
    *   **Subnet:** Default.
    *   *Concept:* All containers will join the `proxy` network to allow the Reverse Proxy (Nginx) to route traffic to them by container name.
    *   Update the status of this sub-step to `[COMPLETE]`.

6.  **Update Documentation** [COMPLETE]
    *   Update `docs/Networking.md` with the finalized domain, ports, and internal network details.
    *   Update the status of this sub-step to `[COMPLETE]`.

7.  **Mark Step as Complete** [COMPLETE]
    *   Update the status at the top of this file to `COMPLETE`.
    *   Update `setup/SETUP.md` to mark Step 2 as `[COMPLETE]`.
    *   Update the status of this sub-step to `[COMPLETE]`.

