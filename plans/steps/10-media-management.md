# Step 10: Media Management (The "Arrs")

**Status:** `PLANNED`

This document details the setup of Radarr, Sonarr, and Bazarr.

**Agent Instructions:** When connecting download clients, use credentials from Step 8. For Prowlarr integration, retrieve API keys from each service. Prompt user for quality profile preferences and subtitle language preferences.

## Objectives
- Deploy Radarr (Movies), Sonarr (TV), Bazarr (Subtitles).
- Connect them to Prowlarr (for indexers).
- Connect them to Download Clients.

## Detailed Implementation Steps

1.  **Deploy Containers** [PLANNED]
    *   Run: `docker compose up -d radarr sonarr bazarr`.
    *   Ports:
        *   Radarr: `7878`
        *   Sonarr: `8989`
        *   Bazarr: `6767`
    *   Update the status of this sub-step to `[COMPLETE]`.

2.  **Radarr Setup** [PLANNED]
    *   Access `http://localhost:7878`.
    *   **Media Management:**
        *   Root Folder: `/movies` (mapped to `./media/movies`).
        *   Enable "Rename Movies".
    *   **Download Client:**
        *   Add qBittorrent.
        *   Host: `qbittorrent` (container name).
        *   Port: `8080`.
        *   Credentials: `admin`/`password` (from Step 8).
    *   **Agent Instructions:** Prompt user for quality profile preference (e.g., 1080p, 4K, Any).
    *   **Root Folder:** Add `/movies`.
    *   Update the status of this sub-step to `[COMPLETE]`.

3.  **Sonarr Setup** [PLANNED]
    *   Access `http://localhost:8989`.
    *   Similar setup to Radarr.
    *   Root Folder: `/tv` (mapped to `./media/tv`).
    *   Update the status of this sub-step to `[COMPLETE]`.

4.  **Prowlarr Integration** [PLANNED]
    *   Go to **Prowlarr > Settings > Apps**.
    *   Add Radarr:
        *   Prowlarr Server: `http://prowlarr:9696`
        *   Radarr Server: `http://radarr:7878`
        *   ApiKey: Get from Radarr Settings > General.
    *   Add Sonarr:
        *   Similar process.
    *   *Result:* Indexers in Prowlarr should automatically sync to Radarr/Sonarr.
    *   Update the status of this sub-step to `[COMPLETE]`.

5.  **Bazarr Setup** [PLANNED]
    *   Access `http://localhost:6767`.
    *   Connect to Sonarr and Radarr using their API keys and hostnames.
    *   **Agent Instructions:** Prompt user for subtitle language preferences (e.g., English, Spanish, etc.).
    *   Configure subtitle languages.
    *   Update the status of this sub-step to `[COMPLETE]`.

6.  **Update Documentation** [PLANNED]
    *   Once all preceding steps in this document are `[COMPLETE]`:
    *   Update `docs/Services.md` with Radarr/Sonarr/Bazarr details.
    *   Update the status of this sub-step to `[COMPLETE]`.

7.  **Mark Step as Complete** [PLANNED]
    *   Once all preceding steps in this document are `[COMPLETE]`:
    *   Update the status at the top of this file to `COMPLETE`.
    *   Update `plans/SETUP.md` to mark Step 11 as `[COMPLETE]`.
    *   Update the status of this sub-step to `[COMPLETE]`.


