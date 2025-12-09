# Step 14: Reverse Proxy Routing

**Status:** `PLANNED`

This document details the configuration of Nginx Proxy Manager to expose services securely.

**Agent Instructions:** Use domain from Step 3 configuration. Prompt user which services they want publicly accessible vs. LAN-only. For admin services (Radarr/Sonarr), recommend additional authentication.

## Objectives
- Configure Proxy Hosts for all services.
- Issue SSL certificates.

## Detailed Implementation Steps

1.  **Create Proxy Hosts** [PLANNED]
    *   Login to NPM (`localhost:81`).
    *   **Add Proxy Host:**
        *   **Domain Names:** `plex.cooperstation.stream` (use domain from Step 3)
        *   **Forward Hostname:** `plex` (use container name).
        *   **Forward Port:** `32400`.
        *   **SSL:** Request a new Let's Encrypt certificate.
            *   Enable "Force SSL".
            *   Enable "HTTP/2 Support".
    *   **Agent Instructions:** Prompt user which services to expose:
        *   Typically public: Plex, Overseerr
        *   Typically restricted: Radarr, Sonarr, Prowlarr, qBittorrent
    *   **Repeat for each service user wants exposed:**
        *   `overseerr.cooperstation.stream` -> `overseerr:5055`
        *   `radarr.cooperstation.stream` -> `radarr:7878` (Enable Basic Auth or restricted access!)
        *   `sonarr.cooperstation.stream` -> `sonarr:8989` (Enable Basic Auth!)
    *   Update the status of this sub-step to `[COMPLETE]`.

2.  **Security Hardening** [PLANNED]
    *   **Access Lists:** Create an Access List in NPM for Admin tools (Radarr, Sonarr, etc.).
        *   Allow only LAN IPs or require Basic Auth.
    *   **Agent Instructions:** If user wants admin services exposed externally, help them set up Basic Auth with strong credentials.
    *   *Note:* Overseerr and Plex are generally safe to expose publicly with their native auth, but Radarr/Sonarr should have an extra layer.
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
    *   Update `plans/SETUP.md` to mark Step 15 as `[COMPLETE]`.
    *   Update the status of this sub-step to `[COMPLETE]`.


