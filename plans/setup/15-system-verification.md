# Step 15: System Verification

**Status:** `PLANNED`

This document details the end-to-end testing of the complete stack.

**Agent Instructions:** Guide user through the full request-to-stream test. Monitor each step and help troubleshoot any issues that arise during the verification process.

## Objectives
- Perform a "Request to Stream" lifecycle test.

## Detailed Implementation Steps

1.  **The "Request to Stream" Test** [PLANNED]
    **Agent Instructions:** Walk through each stage with user, verifying each step completes successfully. This flow can be tested either:
    *   Entirely on the LAN using `http://localhost:5055` (Overseerr) and `http://localhost:32400/web` (Plex), or
    *   End‑to‑end over the internet using `https://overseerr.cooperstation.stream` and `https://plex.cooperstation.stream` after Step 14 is finished.
    1.  **Request:** User logs into Overseerr (LAN or `overseerr.cooperstation.stream`) and requests a movie.
    2.  **Approval:** (Auto-approve or Admin approves).
    3.  **Search:** Radarr picks up request, searches indexers (via Prowlarr).
    4.  **Download:** Radarr sends NZB/Magnet to qBittorrent (via VPN).
    5.  **Acquisition:** qBittorrent downloads file to `/downloads/complete`.
    6.  **Import:** Radarr detects completion, moves/renames file to `/media/movies`.
    7.  **Scan:** Plex detects new file in `/movies` and downloads metadata.
    8.  **Notification:** Overseerr sends "Available" notification.
    9.  **Stream:** User plays movie on Plex.
    *   Update the status of this sub-step to `[COMPLETE]`.

2.  **Troubleshooting Points** [PLANNED]
    *   If stuck at download: Check VPN/Seeds.
    *   If stuck at import: Check permissions/path mapping.
    *   If not appearing in Plex: Check Plex library scan settings.
    *   Update the status of this sub-step to `[COMPLETE]`.

3.  **Update Documentation** [PLANNED]
    *   Once all preceding steps in this document are `[COMPLETE]`:
    *   Update `docs/Maintenance.md` with verification procedures for future reference.
    *   Update the status of this sub-step to `[COMPLETE]`.

4.  **Mark Step as Complete** [PLANNED]
    *   Once all preceding steps in this document are `[COMPLETE]`:
    *   Update the status at the top of this file to `COMPLETE`.
    *   Update `setup/SETUP.md` to mark Step 15 as `[COMPLETE]`.
    *   Update the status of this sub-step to `[COMPLETE]`.




