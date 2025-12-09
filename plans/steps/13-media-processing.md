# Step 13: Media Processing

**Status:** `PLANNED`

This document details the setup of Tdarr for transcoding automation (Optional).

**Agent Instructions:** This is an optional step. Ask user if they want to set up automated transcoding. If yes, prompt for preferences: target codec (H.265/H.264), quality settings, and whether they have GPU hardware acceleration available.

## Objectives
- Deploy Tdarr Server and Node.
- Configure basic transcoding plugins.

## Detailed Implementation Steps

1.  **Deploy Containers** [PLANNED]
    *   Run: `docker compose up -d tdarr`.
    *   Ports: `8265` (WebUI), `8266` (Server).
    *   Update the status of this sub-step to `[COMPLETE]`.

2.  **Initial Setup** [PLANNED]
    *   Access `http://localhost:8265`.
    *   **Nodes:** Verify the internal node is detected.
    *   Update the status of this sub-step to `[COMPLETE]`.

3.  **Library Setup** [PLANNED]
    *   **Source:** `/media/movies`.
    *   **Transcode Cache:** `/transcode` (or `/temp`).
    *   **Agent Instructions:** Ask user about transcoding preferences:
        *   Target codec (H.265 for space savings, H.264 for compatibility)
        *   Whether to remove extra audio tracks/subtitles
        *   Quality threshold (re-encode only files above certain bitrate)
    *   **Plugins:**
        *   Select a basic plugin stack (e.g., "Remove Unwanted Audio", "Video to H265").
        *   *Warning:* Transcoding is CPU/GPU intensive. Ensure hardware capability.
    *   Update the status of this sub-step to `[COMPLETE]`.

4.  **GPU Acceleration (If available)** [PLANNED]
    *   **Agent Instructions:** Ask user if they have NVIDIA GPU or Intel QuickSync available for hardware transcoding.
    *   Ensure NVIDIA drivers or QuickSync is passed through to container in `docker-compose.yml`.
    *   Enable hardware encoding in Tdarr library settings.
    *   Update the status of this sub-step to `[COMPLETE]`.

5.  **Update Documentation** [PLANNED]
    *   Once all preceding steps in this document are `[COMPLETE]`:
    *   Update `docs/Services.md` with Tdarr configuration details.
    *   Update the status of this sub-step to `[COMPLETE]`.

6.  **Mark Step as Complete** [PLANNED]
    *   Once all preceding steps in this document are `[COMPLETE]`:
    *   Update the status at the top of this file to `COMPLETE`.
    *   Update `plans/SETUP.md` to mark Step 13 as `[COMPLETE]`.
    *   Update the status of this sub-step to `[COMPLETE]`.




