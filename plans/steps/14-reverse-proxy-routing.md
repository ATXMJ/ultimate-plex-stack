# Step 14: Reverse Proxy Routing

**Status:** `PLANNED`

This document details the configuration of Nginx Proxy Manager to expose services securely.

**Design Decision:** Only **Plex** and **Overseerr** are intended to be accessible from the public internet, and both already require authentication. All other services (Radarr, Sonarr, Prowlarr, qBittorrent, NZBGet, Tdarr, NPM admin, etc.) remain **LAN-only** and are not proxied externally.

**Agent Instructions:** Use the domain from Step 3 (`cooperstation.stream`). Do not expose admin/automation services publicly. If the user later insists on remote admin access, treat that as an advanced, opt-in change with strict access controls.

## Objectives
- Configure Proxy Hosts for all services.
- Issue SSL certificates.

## Detailed Implementation Steps

1.  **Create Proxy Hosts** [PLANNED]
    *   Login to NPM (`localhost:81`).
    *   **Add Proxy Host – Plex (Public, Auth via Plex):**
        *   **Domain Names:** `plex.cooperstation.stream`
        *   **Forward Hostname/IP:** `plex` (Docker container name on `proxy` network).
        *   **Forward Port:** `32400`.
        *   **Scheme:** `http`.
        *   **SSL:** Request a new Let's Encrypt certificate.
            *   Enable "Force SSL".
            *   Enable "HTTP/2 Support".
    *   **Add Proxy Host – Overseerr (Public, Auth via Plex/Overseerr):**
        *   **Domain Names:** `overseerr.cooperstation.stream`
        *   **Forward Hostname/IP:** `overseerr`
        *   **Forward Port:** `5055`.
        *   **Scheme:** `http`.
        *   **SSL:** Request a new Let's Encrypt certificate.
            *   Enable "Force SSL".
            *   Enable "HTTP/2 Support".
    *   **Do NOT create public proxy hosts** for Radarr/Sonarr/Prowlarr/qBittorrent/NZBGet/Tdarr/NPM admin. These remain accessible only on the LAN (e.g., `http://localhost:7878`).
    *   Update the status of this sub-step to `[COMPLETE]`.

2.  **Security Hardening** [PLANNED]
    *   **NPM Admin UI (`localhost:81`):**
        *   Ensure the admin interface is **not** proxied publicly.
        *   Access it only via LAN (host browser or VPN into home network).
    *   **Plex & Overseerr Hosts:**
        *   Rely on Plex and Overseerr’s own authentication for user login.
        *   Optionally enable NPM rate limiting or IP allow‑lists if desired, but not required for baseline.
    *   **If, in the future, admin services must be remote:**
        *   Treat as an advanced change:
            *   Create proxy hosts only for required tools.
            *   Protect them with NPM Access Lists (Basic Auth + IP allow‑lists or VPN-only).
        *   Document these changes clearly when they are made.
    *   Update the status of this sub-step to `[COMPLETE]`.

3.  **DNS Verification** [PLANNED]
    *   Ensure public DNS records point `*.mydomain.com` (or specific subdomains) to your home IP.
    *   Update the status of this sub-step to `[COMPLETE]`.

4.  **Update Documentation** [PLANNED]
    *   Once all preceding steps in this document are `[COMPLETE]`:
    *   Update `docs/Networking.md` with the full list of exposed services and subdomains.
    *   Update the status of this sub-step to `[COMPLETE]`.

5.  **Mark Step as Complete** [PLANNED]
    *   Once all preceding steps in this document are `[COMPLETE]`:
    *   Update the status at the top of this file to `COMPLETE`.
    *   Update `plans/SETUP.md` to mark Step 14 as `[COMPLETE]`.
    *   Update the status of this sub-step to `[COMPLETE]`.




