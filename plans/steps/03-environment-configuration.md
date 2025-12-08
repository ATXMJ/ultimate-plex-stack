# Step 3: Environment Configuration

**Status:** `COMPLETE`

This document details the configuration of the environment variables that control the stack.

**Agent Instructions:** When implementing this step, prompt the user for actual configuration values. Do not mark sub-steps as complete until real values are provided and confirmed by the user.

**Note:** Plex claim token configuration has been moved to Step 7 (Plex Media Server deployment) due to its 4-minute expiration window.

## Objectives
- Create the production `.dotenv` file.
- Configure user permissions, timezone, and paths.
- Set up VPN and security credentials.

## Detailed Implementation Steps

1.  **Create dotenv** [COMPLETE]
    *   Copy example: `cp .env.example dotenv` (PowerShell: `Copy-Item .env.example dotenv`).
    *   **Note:** Due to globalignore, we are using `dotenv` temporarily instead of `.env`.
    *   Update the status of this sub-step to `[COMPLETE]`.

2.  **Configure User & Group IDs** [COMPLETE]
    *   **Concept:** Docker on Windows via WSL2 usually handles permissions well, but setting PUID/PGID helps Linux containers map file ownership.
    *   **Action:** typically `PUID=1000`, `PGID=1000` is standard for the first user.
    *   *Tip:* You generally don't need to change this on Windows Docker Desktop unless you have specific permission issues, but setting it is good practice for container consistency.
    *   **Current Value:** `PUID=1000`, `PGID=1000` (default)
    *   Update the status of this sub-step to `[COMPLETE]`.

3.  **Configure Timezone** [COMPLETE]
    *   Set `TZ` to your local timezone (e.g., `America/New_York`, `Europe/London`).
    *   *Reference:* [List of tz database time zones](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones).
    *   **Current Value:** `America/Denver` (Mountain Time)
    *   **Agent Instructions:** Prompt user to confirm or update timezone.
    *   Update the status of this sub-step to `[COMPLETE]` once confirmed.

4.  **Configure Paths** [COMPLETE]
    *   **MEDIA_ROOT:** Set to local path initially (e.g., `./media` or absolute path `C:/plex-server/ultimate-plex-stack/media`).
    *   **DOWNLOAD_ROOT:** Set to local path (e.g., `./downloads`).
    *   **CONFIG_ROOT:** Set to local path (e.g., `./config`).
    *   **Current Values:**
        *   `MEDIA_ROOT=C:/plex-server/ultimate-plex-stack/media`
        *   `DOWNLOAD_ROOT=C:/plex-server/ultimate-plex-stack/downloads`
        *   `CONFIG_ROOT=C:/plex-server/ultimate-plex-stack/config`
    *   Update the status of this sub-step to `[COMPLETE]`.

5.  **Configure VPN Credentials** [COMPLETE]
    *   **VPN_PROVIDER:** (e.g., `airvpn`, `custom`, `wireguard`, `nordvpn`).
    *   **VPN_TOKEN:** NordVPN access token (recommended for WireGuard).
    *   **Note:** When using NordVPN with WireGuard and access token, `VPN_USERNAME` is not required.
    *   *Crucial:* Ensure `VPN_ENABLED=true` or equivalent profile activation is planned.
    *   **Current Values:**
        *   `VPN_PROVIDER=nordvpn`
        *   `VPN_TOKEN=********` (configured) ✓
        *   `VPN_PROTOCOL=wireguard`
        *   `VPN_ENABLED=true`
    *   **Agent Instructions:** Prompt user for NordVPN access token (from NordVPN dashboard). For WireGuard protocol, only the access token is needed, not username.
    *   Update the status of this sub-step to `[COMPLETE]` once real credentials are provided.

6.  **Configure Domain** [COMPLETE]
    *   Set `DOMAIN` variable (e.g., `cooperstation.stream`).
    *   Set `ACME_EMAIL` for Let's Encrypt notifications.
    *   **Current Values:**
        *   `DOMAIN=cooperstation.stream` ✓
        *   `ACME_EMAIL=txaggiemichael@gmail.com` ✓
    *   **Note:** ACME_EMAIL is used by Let's Encrypt for SSL certificate expiration warnings and account recovery. Using your personal email is fine and recommended.
    *   **Agent Instructions:** Prompt user to confirm domain (`cooperstation.stream`) and provide email for SSL certificates.
    *   Update the status of this sub-step to `[COMPLETE]` once real values are provided.

7.  **Update Documentation** [COMPLETE]
    *   Once all preceding steps in this document are `[COMPLETE]`:
    *   Update `docs/Configuration.md` with any new environment variable keys or default values used.
    *   Updated `docs/Configuration.md` with:
        *   NordVPN WireGuard configuration
        *   Windows absolute paths
        *   Mountain Time timezone
        *   cooperstation.stream domain
        *   ACME_EMAIL for SSL certificates
    *   **Note:** Plex claim token configuration moved to Step 7 (to be completed immediately before deployment).
    *   Update the status of this sub-step to `[COMPLETE]`.

8.  **Mark Step as Complete** [COMPLETE]
    *   Once all preceding steps in this document are `[COMPLETE]`:
    *   Update the status at the top of this file to `COMPLETE`.
    *   Update `plans/SETUP.md` to mark Step 3 as `[COMPLETE]`.
    *   Update the status of this sub-step to `[COMPLETE]`.

## Verification Checklist
- [x] `dotenv` file exists.
- [x] `TZ` confirmed (America/Denver - Mountain Time).
- [x] PUID/PGID set.
- [x] VPN credentials configured (NordVPN access token).
- [x] Domain details entered (cooperstation.stream).
- [x] ACME_EMAIL configured (txaggiemichael@gmail.com).
- [x] Documentation updated.

## Current Status Summary
- ✅ File created with structure
- ✅ Paths configured (Windows absolute paths)
- ✅ PUID/PGID set (1000/1000)
- ✅ Timezone confirmed (America/Denver)
- ✅ VPN credentials configured (NordVPN with WireGuard)
- ✅ Domain and email configured (cooperstation.stream)
- ✅ Documentation updated
- ℹ️ Plex claim token moved to Step 7 (to be configured immediately before deployment)

