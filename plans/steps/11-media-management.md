# Step 11: Media Management (The "Arrs")

**Status:** `PLANNED`

This document details the setup of Radarr, Sonarr, and Bazarr.

**Design Decision:** Buildarr (Step 10) is the **primary configuration path** for Radarr/Sonarr (and, if supported, Bazarr). The web UIs are used mainly to **verify** that the YAML was applied correctly and to perform occasional diagnostics.

**Agent Instructions:** When connecting download clients and defining root folders, prefer modelling everything in `buildarr.yml` and re-running Buildarr. Use the UIs to confirm state, not as the main way to configure Arr services. Prompt user for quality profile and subtitle language preferences and express those in `buildarr.yml` where possible.

## Objectives
- Deploy Radarr (Movies), Sonarr (TV), Bazarr (Subtitles).
- Connect them to Prowlarr (for indexers).
- Connect them to Download Clients.

## Detailed Implementation Steps

1.  **Deploy Containers** [PLANNED]
    *   Run: `docker compose up -d radarr sonarr bazarr`.
    *   Ports (for local access/verification):
        *   Radarr: `7878`
        *   Sonarr: `8989`
        *   Bazarr: `6767`
    *   These ports are for **LAN-only** access; they are **not exposed via reverse proxy** in Step 14.
    *   Update the status of this sub-step to `[COMPLETE]`.

2.  **Apply Buildarr Configuration** [PLANNED]
    *   Ensure `buildarr.yml` from Step 10 includes sections for `radarr:` and `sonarr:` with:
        *   Root folders:
            *   Movies: internal path `/movies`
            *   TV: internal path `/tv`
        *   Download clients:
            *   qBittorrent at `qbittorrent:8080` (and/or NZBGet) with credentials from Step 8.
        *   At least one quality profile for movies and one for TV.
    *   **Path Mapping Convention:**
        *   Inside Radarr/Sonarr containers:
            *   Movies root: `/movies`
            *   TV root: `/tv`
        *   On the Windows host:
            *   These internal paths are backed by `${MOVIES_PATH}` and `${TV_PATH}` in the environment.
            *   During initial setup, they point to local folders (e.g., `C:\plex-server\ultimate-plex-stack\media\movies`).
            *   After NAS migration (Step 16), they will point to NAS folders (e.g., `G:\media\movies`) but **still map into the containers as `/movies` and `/tv`**.
    *   Run Buildarr to apply configuration:
        ```powershell
        docker compose run --rm buildarr apply
        ```
    *   Update the status of this sub-step to `[COMPLETE]`.

3.  **Radarr Verification (Do NOT reconfigure by hand)** [PLANNED]
    *   Access Radarr on the LAN: `http://localhost:7878`.
    *   Verify (without changing settings unless debugging):
        *   **Root Folder:** `/movies` is configured as the primary root.
        *   **Download Client:** qBittorrent (and/or NZBGet) present with host `qbittorrent`, port `8080`, and correct credentials.
        *   **Quality Profiles:** At least one profile matches your desired baseline (e.g., 1080p, 4K).
    *   **If something is wrong:** Fix it in `buildarr.yml`, run `docker compose run --rm buildarr apply` again, and then refresh the UI – do not rely on manual UI changes as the long-term fix.
    *   Update the status of this sub-step to `[COMPLETE]`.

4.  **Sonarr Verification (Do NOT reconfigure by hand)** [PLANNED]
    *   Access Sonarr on the LAN: `http://localhost:8989`.
    *   Verify:
        *   **Root Folder:** `/tv` is configured as the primary root.
        *   **Download Client:** Same pattern as Radarr (host `qbittorrent`, port `8080`).
        *   **Quality Profiles:** At least one profile appropriate for TV.
    *   As with Radarr, correct any discrepancies in `buildarr.yml`, not via long-term UI tweaks.
    *   Update the status of this sub-step to `[COMPLETE]`.

5.  **Prowlarr Integration (via Buildarr, then Verify in UI)** [PLANNED]
    *   In `buildarr.yml`, ensure Prowlarr apps are configured to point at:
        *   Radarr: `http://radarr:7878` with API key from Radarr.
        *   Sonarr: `http://sonarr:8989` with API key from Sonarr.
    *   Re‑run Buildarr to apply any Prowlarr app changes.
    *   Verify in Prowlarr UI (`http://localhost:9696` on LAN):
        *   Apps for Radarr and Sonarr exist and are healthy.
        *   Indexers are configured and attached to those apps.
    *   *Result:* Indexers in Prowlarr automatically sync to Radarr/Sonarr.
    *   Update the status of this sub-step to `[COMPLETE]`.

6.  **Bazarr Setup (Primarily via UI for now)** [PLANNED]
    *   Access Bazarr on the LAN: `http://localhost:6767`.
    *   Connect to Sonarr and Radarr using their hostnames and API keys:
        *   Sonarr host: `sonarr`, port `8989`
        *   Radarr host: `radarr`, port `7878`
    *   **Agent Instructions:** Prompt user for subtitle language preferences (e.g., English only, English + Spanish, etc.).
    *   Configure subtitle languages and providers according to user preferences.
    *   (Optional) If/when a stable Buildarr integration for Bazarr is available, move these settings into `buildarr.yml` and update this step.
    *   Update the status of this sub-step to `[COMPLETE]`.

7.  **Update Documentation** [PLANNED]
    *   Once all preceding steps in this document are `[COMPLETE]`:
    *   Update `docs/Services.md` with Radarr/Sonarr/Bazarr details that match the Buildarr‑driven configuration (roots, paths, clients).
    *   Update the status of this sub-step to `[COMPLETE]`.

8.  **Mark Step as Complete** [PLANNED]
    *   Once all preceding steps in this document are `[COMPLETE]`:
    *   Update the status at the top of this file to `COMPLETE`.
    *   Update `plans/SETUP.md` to mark Step 11 as `[COMPLETE]`.
    *   Update the status of this sub-step to `[COMPLETE]`.
