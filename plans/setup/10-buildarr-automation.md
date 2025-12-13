**Navigation:** [← Previous: Step 9 – Indexer Management](09-indexer-management.md) | [Next: Step 10.1 – Arr Configuration-as-Code (Buildarr) →](10.1-arr-configuration-as-code.md)

# Step 10: Configuration Automation (Buildarr)

**Status:** `COMPLETE`

This document details the introduction of Buildarr for declarative, version-controlled configuration of the *Arr ecosystem (Prowlarr, Radarr, Sonarr, and optionally Bazarr).

**Design Decision:** Buildarr is the **primary source of truth** for Arr configuration. The web UIs are used for **verification and one-off diagnostics only** – if you change something manually in the UI, you should later reflect that change back into `buildarr.yml` and re‑apply it.

**Agent Instructions:** Treat `buildarr.yml` as configuration-as-code. Prefer editing YAML + running Buildarr over clicking through UIs for Prowlarr/Radarr/Sonarr settings.

## Objectives

- Deploy Buildarr **as a Docker service** (container-based, no Python on host).
- Create a minimal `buildarr.yml` configuration file under version control.
- Establish a repeatable one-shot workflow for applying configuration via Buildarr.
- Introduce documentation for Buildarr and its usage.
- Defer detailed Arr configuration modelling (indexers, profiles, download clients) to **Step 10.1: Arr Configuration-as-Code (Buildarr)**.

## Detailed Implementation Steps

1.  **Decide Buildarr Deployment Mode**
    *   **Chosen Mode:** Docker container, run as a **one-shot tool** when configuration changes.
    *   Add a `buildarr` service to `docker-compose.yml` (matching the actual deployment):
        ```yaml
        buildarr:
          image: ghcr.io/buildarr/buildarr:latest
          container_name: buildarr
          profiles:
            - advanced            # run only when explicitly requested
          environment:
            - TZ=${TZ}
          volumes:
            - ./buildarr.yml:/config/buildarr.yml:ro
          networks:
            - proxy               # must be able to reach prowlarr/radarr/sonarr
          restart: "no"
        ```
    *   **Usage Pattern:** Run Buildarr on demand from the project root:
        ```powershell
        docker compose run --rm buildarr apply
        ```

2.  **Create Minimal Buildarr Configuration File**
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

3.  **Defer Full Arr Modelling to Step 10.1**
    *   Detailed modelling of:
        *   Prowlarr authentication, indexers, and Apps.
        *   Radarr/Sonarr/Bazarr root folders, quality profiles, and download clients.
        *   Buildarr apply/verify cycles against running services.
    *   Is covered in `plans/setup/10.1-arr-configuration-as-code.md`.

4.  **Update Documentation**
    *   Add or verify a Buildarr section in `docs/Configuration.md` describing:
        *   The role of `buildarr.yml` as configuration-as-code for Arr services.
        *   The `docker compose run --rm buildarr apply` workflow.
    *   Add a Buildarr entry to `docs/Services.md` under Automation/Configuration:
        *   Deployment mode (one-shot Docker tool).
        *   Config path (`buildarr.yml`).
        *   Scope (Arr/Prowlarr configuration).

5.  **Mark Step as Complete**
    *   Once the above are in place:
    *   Update the status at the top of this file to `COMPLETE`.
    *   Update `plans/setup/00-SETUP.md` to mark Step 10 as `[COMPLETE]`.

    This keeps Step 10 focused on introducing Buildarr and a minimal, working configuration, while Step 10.1 handles full Arr modelling.
