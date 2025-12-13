**Navigation:** [← Previous: Step 8 – Content Acquisition Services (VPN-Routed)](08-content-acquisition-services.md) | [Next: Step 10 – Configuration Automation (Buildarr) →](10-buildarr-automation.md)

# Step 9: Indexer Management

**Status:** `COMPLETE`

This document details the deployment of Prowlarr to manage torrent and usenet indexers.

**Agent Instructions:** Prompt user for authentication preferences (username/password). Ask if they have private tracker accounts or will use only public indexers.

## Objectives
- Deploy Prowlarr.
- Add indexers (public or private).
- Prepare for sync with Arr apps.

## Detailed Implementation Steps

1.  **Configure Docker Compose Service** [COMPLETE]
    *   Review `prowlarr` service.
    *   Ports: `9696:9696`.
    *   Volumes: `./config/prowlarr:/config`.
    *   Update the status of this sub-step to `[COMPLETE]`.

2.  **Start Prowlarr** [COMPLETE]
    *   Run: `docker compose up -d prowlarr`.
    *   Update the status of this sub-step to `[COMPLETE]`.

3.  **Initial Setup** [COMPLETE]
    *   Open browser: `http://localhost:9696`.
    *   Set up Authentication (Forms - Username/Password).
    *   **Agent Instructions:** Prompt user for username and password they want to set for Prowlarr.
    *   Update the status of this sub-step to `[COMPLETE]`.

4.  **Add Indexers** [COMPLETE]
    *   Go to **Indexers > Add Indexer**.
    *   Search for public trackers (e.g., 1337x, RARBG alternatives).
    *   **Agent Instructions:** Ask user which indexers they prefer. If they have private tracker accounts, help them configure those. Otherwise, suggest reliable public trackers.
    *   Test and Save.
    *   Update the status of this sub-step to `[COMPLETE]`.

5.  **Configure FlareSolverr (Optional)** [COMPLETE]
    *   If using public trackers with Cloudflare protection, ensure `flaresolverr` container is running.
    *   In Prowlarr, add FlareSolverr as a proxy tag or indexer proxy.
    *   Update the status of this sub-step to `[COMPLETE]`.

6.  **Update Documentation** [COMPLETE]
    *   Once all preceding steps in this document are `[COMPLETE]`:
    *   Update `docs/Services.md` with Prowlarr configuration details.
    *   Update the status of this sub-step to `[COMPLETE]`.

7.  **Mark Step as Complete** [COMPLETE]
    *   Once all preceding steps in this document are `[COMPLETE]`:
    *   Update the status at the top of this file to `COMPLETE`.
    *   Update `setup/SETUP.md` to mark Step 10 as `[COMPLETE]`.
    *   Update the status of this sub-step to `[COMPLETE]`.


