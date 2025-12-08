# Step 16: NAS Migration

**Status:** `PLANNED`

This document details the procedure to migrate the media library to a NAS after the initial setup.

**Agent Instructions:** This is a future step. Prompt user for NAS details when they're ready to migrate: NAS IP address, share name, credentials if required. Recommend backup before migration.

## Objectives
- Mount NAS storage to host.
- Move media files.
- Reconfigure Docker volumes.

## Detailed Implementation Steps

1.  **Mount NAS on Host** [PLANNED]
    *   **Agent Instructions:** Prompt user for NAS IP address, share name, and any required credentials.
    *   Create mount point: `mkdir C:\mnt\nas\media`.
    *   Map Network Drive (Persistent):
        ```powershell
        New-PSDrive -Name "Z" -PSProvider FileSystem -Root "\\nas-ip\share" -Persist
        ```
        *Note:* Docker Desktop for Windows requires the drive to be mounted or accessible via UNC paths. Using UNC `\\nas-ip\share` directly in docker-compose is sometimes tricky on Windows; often better to mount to a drive letter or directory link.
    *   Update the status of this sub-step to `[COMPLETE]`.

2.  **Copy Media** [PLANNED]
    *   Stop containers: `docker compose down`.
    *   Move data: `Robocopy C:\plex-server\media Z:\media /MIR`.
    *   Update the status of this sub-step to `[COMPLETE]`.

3.  **Update Docker Compose** [PLANNED]
    *   Edit `docker-compose.yml`.
    *   Change volumes for Plex, Radarr, Sonarr:
        *   Old: `- ./media/movies:/movies`
        *   New: `- //nas-ip/share/movies:/movies` (Check Docker Desktop syntax for UNC) OR mapped drive.
    *   *Best Practice:* Update `.env` variable `MEDIA_ROOT` to point to the new location, if you used variables.
    *   Update the status of this sub-step to `[COMPLETE]`.

4.  **Restart & Verify** [PLANNED]
    *   `docker compose up -d`.
    *   Check Plex: Files should be available.
    *   *Note:* If paths changed inside the container (e.g., `/movies` mapped to a different underlying set of files but same internal path), Plex might just work. If internal paths change, disable "Empty trash automatically" before scan to prevent metadata loss.
    *   Update the status of this sub-step to `[COMPLETE]`.

5.  **Update Documentation** [PLANNED]
    *   Once all preceding steps in this document are `[COMPLETE]`:
    *   Update `docs/Storage.md` and `docs/Configuration.md` to reflect the final NAS storage paths.
    *   Update the status of this sub-step to `[COMPLETE]`.

6.  **Mark Step as Complete** [PLANNED]
    *   Once all preceding steps in this document are `[COMPLETE]`:
    *   Update the status at the top of this file to `COMPLETE`.
    *   Update `plans/SETUP.md` to mark Step 17 as `[COMPLETE]`.
    *   Update the status of this sub-step to `[COMPLETE]`.

## Verification Checklist
- [ ] NAS mounted.
- [ ] Media copied.
- [ ] Containers restarted with new volumes.
- [ ] Library intact.

