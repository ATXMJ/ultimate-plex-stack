# Step 12: Request Management

**Status:** `PLANNED`

This document details the setup of Overseerr for managing media requests.

**Design Decision:** Only **Plex** and **Overseerr** will be remotely accessible from the internet, both of which have their own authentication. All other services (Radarr, Sonarr, Prowlarr, qBittorrent, etc.) remain **LAN-only** and are never exposed via reverse proxy.

**Agent Instructions:** This step requires API keys from Radarr and Sonarr (configured and verified via Buildarr in Step 11). Guide the user to retrieve these keys from each service's settings if needed, but prefer documenting them in `buildarr.yml` rather than manually re-entering them in UIs.

## Objectives
- Deploy Overseerr.
- Link to Plex.
- Link to Radarr/Sonarr.

## Detailed Implementation Steps

1.  **Deploy Container** [PLANNED]
    *   Run: `docker compose up -d overseerr`.
    *   Port (LAN access): `5055`.
    *   Overseerr will later be exposed externally only via Nginx Proxy Manager in Step 14 under `overseerr.cooperstation.stream`.
    *   Update the status of this sub-step to `[COMPLETE]`.

2.  **Initial Setup** [PLANNED][USER_INPUT]
    *   Access `http://localhost:5055`.
    *   **Sign in with Plex:** Use your Plex account.
    *   **Plex Server:**
        *   Hostname: `plex`
        *   Port: `32400`
        *   Refresh Library: Enable.
    *   Update the status of this sub-step to `[COMPLETE]`.

3.  **Service Configuration** [PLANNED][USER_INPUT]
    *   **Radarr:**
        *   Hostname: `radarr`
        *   Port: `7878`
        *   API Key: (From Radarr).
        *   Quality Profile: Select one.
        *   Root Folder: `/movies` (internal container path – backed by `${MOVIES_PATH}` on the host).
    *   Update the status of this sub-step to `[COMPLETE]`.
    *   **Sonarr:**
        *   Hostname: `sonarr`
        *   Port: `8989`
        *   API Key: (From Sonarr).
        *   Root Folder: `/tv` (internal container path – backed by `${TV_PATH}` on the host).
    *   Update the status of this sub-step to `[COMPLETE]`.

4.  **Test Request** [PLANNED][USER_INPUT]
    *   Search for a movie in Overseerr.
    *   Click "Request".
    *   Check Radarr: It should appear in the queue/monitoring list.
    *   Update the status of this sub-step to `[COMPLETE]`.

5.  **Update Documentation** [PLANNED]
    *   Once all preceding steps in this document are `[COMPLETE]`:
    *   Update `docs/Services.md` with Overseerr configuration details, noting that it is the only non-Plex service intended for remote user access.
    *   Update the status of this sub-step to `[COMPLETE]`.

6.  **Mark Step as Complete** [PLANNED]
    *   Once all preceding steps in this document are `[COMPLETE]`:
    *   Update the status at the top of this file to `COMPLETE`.
    *   Update `setup/SETUP.md` to mark Step 12 as `[COMPLETE]`.
    *   Update the status of this sub-step to `[COMPLETE]`.




