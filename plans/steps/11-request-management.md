# Step 11: Request Management

**Status:** `PLANNED`

This document details the setup of Overseerr for managing media requests.

**Agent Instructions:** This step requires API keys from Radarr and Sonarr (configured in Step 10). Retrieve these from the user or guide them to find the keys in each service's settings.

## Objectives
- Deploy Overseerr.
- Link to Plex.
- Link to Radarr/Sonarr.

## Detailed Implementation Steps

1.  **Deploy Container** [PLANNED]
    *   Run: `docker compose up -d overseerr`.
    *   Port: `5055`.
    *   Update the status of this sub-step to `[COMPLETE]`.

2.  **Initial Setup** [PLANNED]
    *   Access `http://localhost:5055`.
    *   **Sign in with Plex:** Use your Plex account.
    *   **Plex Server:**
        *   Hostname: `plex`
        *   Port: `32400`
        *   Refresh Library: Enable.
    *   Update the status of this sub-step to `[COMPLETE]`.

3.  **Service Configuration** [PLANNED]
    *   **Radarr:**
        *   Hostname: `radarr`
        *   Port: `7878`
        *   API Key: (From Radarr).
        *   Quality Profile: Select one.
        *   Root Folder: `/movies`.
    *   Update the status of this sub-step to `[COMPLETE]`.
    *   **Sonarr:**
        *   Hostname: `sonarr`
        *   Port: `8989`
        *   API Key: (From Sonarr).
        *   Root Folder: `/tv`.
    *   Update the status of this sub-step to `[COMPLETE]`.

4.  **Test Request** [PLANNED]
    *   Search for a movie in Overseerr.
    *   Click "Request".
    *   Check Radarr: It should appear in the queue/monitoring list.
    *   Update the status of this sub-step to `[COMPLETE]`.

5.  **Update Documentation** [PLANNED]
    *   Once all preceding steps in this document are `[COMPLETE]`:
    *   Update `docs/Services.md` with Overseerr configuration details.
    *   Update the status of this sub-step to `[COMPLETE]`.

6.  **Mark Step as Complete** [PLANNED]
    *   Once all preceding steps in this document are `[COMPLETE]`:
    *   Update the status at the top of this file to `COMPLETE`.
    *   Update `plans/SETUP.md` to mark Step 12 as `[COMPLETE]`.
    *   Update the status of this sub-step to `[COMPLETE]`.


