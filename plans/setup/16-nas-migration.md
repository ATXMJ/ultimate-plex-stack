# Step 16: NAS Migration

**Status:** `PLANNED`

This document details the procedure to migrate the media library to a NAS after the initial setup.

**Agent Instructions:** This is a future step. Prompt user for NAS details when they're ready to migrate: NAS IP address, share name, credentials if required. Recommend backup before migration.

## Objectives
- Mount NAS storage to host.
- Move media files.
- Reconfigure Docker volumes.

## Detailed Implementation Steps

1.  **Mount NAS on Host** [PLANNED][USER_INPUT]
    *   **Agent Instructions:** Prompt user for NAS IP address or hostname (e.g., `gargantua`), share name (e.g., `media`), and any required credentials.
    *   NAS Name: `Gargantua`.
    *   Map NAS `media` share to **drive G:** on Windows (persistent mapping):
        ```powershell
        # Example – adjust hostname/share if needed
        New-PSDrive -Name "G" -PSProvider FileSystem -Root "\\gargantua\media" -Persist
        ```
    *   Ensure Docker Desktop is configured to share the `G:` drive under **Settings > Resources > File Sharing** so containers can mount it.
    *   Update the status of this sub-step to `[COMPLETE]`.

2.  **Copy Media** [PLANNED]
    *   Stop containers: `docker compose down`.
    *   Move data from local media folder to Gargantua `G:` drive:
        ```powershell
        Robocopy C:\plex-server\ultimate-plex-stack\media G:\media /MIR
        ```
    *   This preserves the `movies/` and `tv/` subfolder structure under `G:\media`.
    *   Update the status of this sub-step to `[COMPLETE]`.

3.  **Update Docker Compose** [PLANNED][USER_INPUT]
    *   Edit `docker-compose.yml`.
    *   Change volumes for Plex, Radarr, Sonarr:
        *   Old (local):
            *   `- ./media/movies:/movies`
            *   `- ./media/tv:/tv`
        *   New (NAS via Gargantua G: drive):
            *   `- G:\media\movies:/movies`
            *   `- G:\media\tv:/tv`
        *   Inside containers, the paths **remain** `/movies` and `/tv`. Only the host side changes from `./media/...` to `G:\media\...`.
    *   *Best Practice:* Update environment variables (if used) to point to the new location:
        *   `MOVIES_PATH=G:\media\movies`
        *   `TV_PATH=G:\media\tv`
    *   Update the status of this sub-step to `[COMPLETE]`.

4.  **Restart & Verify** [PLANNED]
    *   `docker compose up -d`.
    *   Check Plex: Files should be available.
    *   *Note:* Because the internal container paths (`/movies`, `/tv`) did **not** change, Plex and the Arr services should continue to work without reconfiguration. You are only changing where those folders live on the Windows host (now Gargantua `G:` instead of local disk).
    *   If you do need to rescan, consider disabling "Empty trash automatically" in Plex before the first scan to avoid accidental metadata loss.
    *   Update the status of this sub-step to `[COMPLETE]`.

5.  **Update Documentation** [PLANNED]
    *   Once all preceding steps in this document are `[COMPLETE]`:
    *   Update `docs/Storage.md` and `docs/Configuration.md` to reflect the final NAS storage paths.
    *   Update the status of this sub-step to `[COMPLETE]`.

6.  **Mark Step as Complete** [PLANNED]
    *   Once all preceding steps in this document are `[COMPLETE]`:
    *   Update the status at the top of this file to `COMPLETE`.
    *   Update `setup/SETUP.md` to mark Step 16 as `[COMPLETE]`.
    *   Update the status of this sub-step to `[COMPLETE]`.




