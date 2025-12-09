# Step 10: Configuration Automation (Buildarr)

**Status:** `PLANNED`

This document details the introduction of Buildarr for declarative, version-controlled configuration of the *Arr ecosystem (Prowlarr, Radarr, Sonarr, and optionally Bazarr).

**Design Decision:** Buildarr is the **primary source of truth** for Arr configuration. The web UIs are used for **verification and one-off diagnostics only** – if you change something manually in the UI, you should later reflect that change back into `buildarr.yml` and re‑apply it.

**Agent Instructions:** Treat `buildarr.yml` as configuration-as-code. Prefer editing YAML + running Buildarr over clicking through UIs for Prowlarr/Radarr/Sonarr settings.

## Objectives

- Deploy Buildarr **as a Docker service** (container-based, no Python on host).
- Create a `buildarr.yml` configuration file under version control.
- Define baseline configuration for:
  - Prowlarr (indexers, apps, authentication).
  - Radarr/Sonarr (root folders, quality profiles, download client linkage).
  - Optionally Bazarr (if/when a plugin is available/desired).

## Detailed Implementation Steps

1.  **Decide Buildarr Deployment Mode** [PLANNED]
    *   **Chosen Mode:** Docker container, run as a **one-shot tool** when configuration changes.
    *   Add a `buildarr` service to `docker-compose.yml` (example, adjust image/tag as needed):
        ```yaml
        buildarr:
          image: ghcr.io/buildarr/buildarr:latest
          profiles: ["advanced"]        # optional; run only when explicitly requested
          volumes:
            - ./buildarr.yml:/config/buildarr.yml:ro
          environment:
            - TZ=${TZ}
          networks:
            - proxy                     # must be able to reach prowlarr/radarr/sonarr
        ```
    *   **Usage Pattern:** Run Buildarr on demand:
        ```powershell
        docker compose run --rm buildarr apply
        ```
    *   Update the status of this sub-step to `[COMPLETE]` once the service exists in `docker-compose.yml`.

2.  **Create Buildarr Configuration File** [PLANNED]
    *   Location: project root – `./buildarr.yml` (checked into Git).
    *   Initialize `buildarr.yml` with at least:
        *   Global `buildarr:` settings, with watching **disabled** (one-shot runs):
          ```yaml
          buildarr:
            watch_config: false
          ```
        *   A `prowlarr:` section pointing at `http://prowlarr:9696` with API key placeholder:
          ```yaml
          prowlarr:
            hostname: prowlarr
            port: 9696
            protocol: http
            api_key: YOUR_PROWLARR_API_KEY_HERE
          ```
    *   Commit `buildarr.yml` to the repository.
    *   Update the status of this sub-step to `[COMPLETE]`.

3.  **Model Prowlarr Configuration in Code** [PLANNED]
    *   In `buildarr.yml`, define Prowlarr:
        *   Authentication method and credentials (if enabled).
        *   Indexers (public and/or private) with categories and tags.
        *   Application integrations for Radarr/Sonarr (Apps in Prowlarr).
    *   Ensure the configuration matches the desired end state from Step 9 (Indexer Management).
    *   After editing `buildarr.yml`, run:
        ```powershell
        docker compose run --rm buildarr apply
        ```
        and verify that Prowlarr reflects the YAML.
    *   Update the status of this sub-step to `[COMPLETE]`.

4.  **Model Radarr/Sonarr/Bazarr Configuration** [PLANNED]
    *   Add sections in `buildarr.yml` for:
        *   `radarr:` – movie root folders, quality profiles, download clients.
        *   `sonarr:` – TV root folders, quality profiles, download clients.
        *   `bazarr:` – subtitle settings (if/when supported/desired).
    *   **Path Convention:**
        *   Inside containers, Radarr/Sonarr see:
          *   Movies root folder: `/movies`
          *   TV root folder: `/tv`
        *   On the host, these paths come from environment variables such as:
          *   `MOVIES_PATH` → maps to `/movies`
          *   `TV_PATH` → maps to `/tv`
        *   **Do not change** the internal container paths (`/movies`, `/tv`) even after NAS migration – only the host side (`MOVIES_PATH`, `TV_PATH`) will change in Step 16.
    *   Configure:
        *   At least one movie quality profile and one TV quality profile.
        *   Download clients pointing at `qbittorrent:8080` (and/or NZBGet) with credentials from Step 8.
    *   Update the status of this sub-step to `[COMPLETE]` once these sections exist.

5.  **Test Buildarr Run Against Prowlarr/Radarr/Sonarr** [PLANNED]
    *   With Prowlarr already running from Step 9 and Arr services deployed from Step 11:
        *   Run Buildarr once to apply the configuration:
          ```powershell
          docker compose run --rm buildarr apply
          ```
        *   Verify that:
            *   Prowlarr authentication and indexers match `buildarr.yml`.
            *   App connections for Radarr/Sonarr are created/updated as defined.
            *   Radarr/Sonarr show expected root folders, quality profiles, and download clients.
    *   **Agent Instructions:** Before the first run, warn that Buildarr may overwrite existing manual configuration in Prowlarr/Radarr/Sonarr.
    *   Update the status of this sub-step to `[COMPLETE]`.

6.  **Update Documentation** [PLANNED]
    *   Once all preceding steps in this document are `[COMPLETE]`:
    *   Update `docs/Configuration.md` to:
        *   Describe `buildarr.yml` and its role as configuration-as-code for Arr services.
        *   Document the `docker compose run --rm buildarr apply` workflow.
    *   Update `docs/Services.md` to:
        *   Add a Buildarr entry under Automation/Configuration (deployment mode, config path, scope).
    *   Update `docs/Deployment.md` to:
        *   Prefer Buildarr (`buildarr.yml` + run) as the primary configuration path for Prowlarr/Radarr/Sonarr.
        *   Reframe Arr/Prowlarr web UI steps as verification/diagnostics rather than the main configuration workflow.
    *   Update the status of this sub-step to `[COMPLETE]`.

7.  **Mark Step as Complete** [PLANNED]
    *   Once all preceding steps in this document are `[COMPLETE]`:
    *   Update the status at the top of this file to `COMPLETE`.
    *   Update `plans/SETUP.md` to mark Step 10 as `[COMPLETE]`.
    *   Update the status of this sub-step to `[COMPLETE]`.
