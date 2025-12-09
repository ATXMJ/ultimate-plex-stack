# Step 10: Configuration Automation (Buildarr)

**Status:** `PLANNED`

This document details the introduction of Buildarr for declarative, version-controlled configuration of the *Arr ecosystem (Prowlarr, Radarr, Sonarr, and optionally Bazarr).

**Agent Instructions:** Confirm with the user which services should be managed by Buildarr (Prowlarr-only vs. all Arrs). Ask where they want the `buildarr.yml` (e.g., project root) and whether Buildarr should run as a container or a one-shot CLI tool. Treat Buildarr as a source of truth: manual UI changes should eventually be reflected back into the config file.

## Objectives

- Deploy Buildarr in the stack (container or CLI).
- Create a `buildarr.yml` configuration file under version control.
- Define baseline configuration for:
  - Prowlarr (indexers, apps, authentication).
  - Radarr/Sonarr (root folders, quality profiles, download client linkage).
  - Optionally Bazarr (if/when a plugin is available/desired).

## Detailed Implementation Steps

1.  **Decide Buildarr Deployment Mode** [PLANNED]
    *   Option A: **Docker container** (preferred for this stack).
        *   Add a `buildarr` service to `docker-compose.yml`.
        *   Mount a config directory (e.g., `./config/buildarr:/config`).
    *   Option B: **Local CLI** (Python venv on host).
        *   Install via `pip install buildarr` inside a dedicated virtual environment.
    *   **Agent Instructions:** Discuss pros/cons of container vs. host-based CLI with the user and document the chosen approach here.
    *   Update the status of this sub-step to `[COMPLETE]`.

2.  **Create Buildarr Configuration File** [PLANNED]
    *   Choose a location for `buildarr.yml` (recommended: project root).
    *   Initialize `buildarr.yml` with:
        *   Global `buildarr:` settings (e.g., `watch_config: true` if using a long-running service).
        *   A `prowlarr:` section pointing at `http://prowlarr:9696` with the correct API key.
    *   Check the file into version control.
    *   Update the status of this sub-step to `[COMPLETE]`.

3.  **Model Prowlarr Configuration in Code** [PLANNED]
    *   In `buildarr.yml`, define:
        *   Authentication method and credentials (if enabled).
        *   Indexers (public and/or private) with categories and tags.
        *   Application integrations for Radarr/Sonarr (Apps in Prowlarr).
    *   Ensure the configuration matches the desired end state from Step 9.
    *   Update the status of this sub-step to `[COMPLETE]`.

4.  **Plan Radarr/Sonarr/Bazarr Automation** [PLANNED]
    *   Stub out sections in `buildarr.yml` for:
        *   `radarr:` (movie root folders, quality profiles, download clients).
        *   `sonarr:` (TV root folders, quality profiles, download clients).
        *   `bazarr:` (only if/when a suitable plugin or automation path is selected).
    *   **Note:** Actual Radarr/Sonarr/Bazarr containers are deployed in Step 11; this step focuses on defining the desired configuration up front.
    *   Update the status of this sub-step to `[COMPLETE]`.

5.  **Test Buildarr Run Against Prowlarr** [PLANNED]
    *   With Prowlarr already running from Step 9:
        *   Run Buildarr once (CLI or container) to apply the configuration.
        *   Verify that:
            *   Prowlarr authentication matches `buildarr.yml` (if configured).
            *   Indexers are created/updated as defined.
            *   App connections to Radarr/Sonarr are ready (even if the services are not yet deployed).
    *   **Agent Instructions:** Prompt the user before allowing Buildarr to overwrite any existing manual configuration.
    *   Update the status of this sub-step to `[COMPLETE]`.

6.  **Update Documentation** [PLANNED]
    *   Once all preceding steps in this document are `[COMPLETE]`:
    *   Update `docs/Configuration.md` to:
        *   Describe `buildarr.yml` and its role as configuration-as-code for Arr services.
        *   Document how to run Buildarr (one-shot vs. long-running service).
    *   Update `docs/Services.md` to:
        *   Add a Buildarr entry under Automation/Configuration (deployment mode, config path, scope).
    *   Update `docs/Deployment.md` to:
        *   Prefer Buildarr (`buildarr.yml` + run) as the primary configuration path for Prowlarr/Radarr/Sonarr (and optionally Bazarr).
        *   Reframe Arr/Prowlarr web UI steps as verification/override rather than the main configuration workflow.
    *   Update the status of this sub-step to `[COMPLETE]`.

7.  **Mark Step as Complete** [PLANNED]
    *   Once all preceding steps in this document are `[COMPLETE]`:
    *   Update the status at the top of this file to `COMPLETE`.
    *   Update `plans/SETUP.md` to mark Step 10 as `[COMPLETE]`.
    *   Update the status of this sub-step to `[COMPLETE]`.


