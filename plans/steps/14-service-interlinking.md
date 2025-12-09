# Step 14: Service Interlinking

**Status:** `PLANNED`

This document serves as a checklist and guide to finalize the connections between all services, ensuring the flow of data is correct.

**Agent Instructions:** This is a verification and finalization step. Retrieve API keys from previous steps. If user wants notifications, prompt for Discord webhook URL or email settings.

## Objectives
- Verify complete end-to-end connectivity.
- Finalize "Remote Path Mappings" if needed (crucial for Docker setups).

## Detailed Implementation Steps

1.  **API Key Audit** [PLANNED]
    *   Ensure Prowlarr has valid keys for Radarr/Sonarr.
    *   Ensure Overseerr has valid keys for Radarr/Sonarr.
    *   Ensure Bazarr has valid keys for Radarr/Sonarr.
    *   Update the status of this sub-step to `[COMPLETE]`.

2.  **Path Mapping Verification** [PLANNED]
    *   **Concept:** Download client sees `/downloads`, Radarr sees `/downloads`.
    *   If they are mapped identically in Docker Compose (e.g., both `- ./downloads:/downloads`), no remote path mapping is needed.
    *   *Check:* If Radarr says "File not found" after download, verify the internal paths match perfectly.
    *   Update the status of this sub-step to `[COMPLETE]`.

3.  **Naming Formats** [PLANNED]
    *   **Agent Instructions:** Ask user if they have specific naming format preferences or use recommended standard.
    *   Configure Radarr/Sonarr standard movie format (e.g., `{Movie Title} ({Release Year}) {Quality Full}`).
    *   This ensures clean file names for Plex.
    *   Update the status of this sub-step to `[COMPLETE]`.

4.  **Notification Agents (Optional)** [PLANNED]
    *   **Agent Instructions:** Ask user if they want notifications. If yes, prompt for Discord webhook URL or email SMTP settings.
    *   Set up Discord/Email notifications in Radarr/Sonarr/Overseerr for "On Download" or "On Request".
    *   Update the status of this sub-step to `[COMPLETE]`.

5.  **Update Documentation** [PLANNED]
    *   Once all preceding steps in this document are `[COMPLETE]`:
    *   Update `docs/Configuration.md` or `docs/Services.md` with final interlinking details (API keys, path mappings).
    *   Update the status of this sub-step to `[COMPLETE]`.

6.  **Mark Step as Complete** [PLANNED]
    *   Once all preceding steps in this document are `[COMPLETE]`:
    *   Update the status at the top of this file to `COMPLETE`.
    *   Update `plans/SETUP.md` to mark Step 14 as `[COMPLETE]`.
    *   Update the status of this sub-step to `[COMPLETE]`.




