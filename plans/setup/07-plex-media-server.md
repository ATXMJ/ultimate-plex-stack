# Step 7: Plex Media Server

**Status:** `COMPLETE`

**Agent Instructions:** Before deploying Plex, prompt user to obtain a fresh Plex claim token from https://www.plex.tv/claim (valid for 4 minutes only). Update the PLEX_CLAIM variable in dotenv immediately before starting the container.

This document details the deployment and initial configuration of Plex Media Server.

## Objectives
- Obtain Plex claim token and configure environment.
- Deploy Plex Media Server container.
- Verify Web UI access and claim server.
- Configure initial media libraries.

## Detailed Implementation Steps

1.  **Configure Plex Claim Token** [COMPLETE]
    *   **CRITICAL:** This must be done immediately before deploying Plex (token expires in 4 minutes).
    *   Visit [plex.tv/claim](https://www.plex.tv/claim).
    *   Sign in with your Plex account.
    *   Copy the claim token (format: `claim-xxxxxxxxxx`).
    *   **Agent Instructions:** Prompt user to get fresh token from plex.tv/claim and update immediately.
    *   Update `PLEX_CLAIM` variable in `dotenv`:
        ```bash
        PLEX_CLAIM=claim-xxxxxxxxxx
        ```
    *   Update the status of this sub-step to `[COMPLETE]`.

2.  **Deploy Plex Container** [COMPLETE]
    *   Run: `docker compose up -d plex`.
    *   Check logs: `docker compose logs -f plex`.
    *   *Success:* Look for "Plex Media Server" startup messages.
    *   Update the status of this sub-step to `[COMPLETE]`.

3.  **Initial Access & Server Claim** [COMPLETE]
    *   Open browser: `http://localhost:32400/web`.
    *   If claim token was valid, server should automatically be claimed to your account.
    *   Complete the initial setup wizard.
    *   Update the status of this sub-step to `[COMPLETE]`.

4.  **Configure Media Libraries** [COMPLETE]
    *   **Add Library - Movies:**
        *   Name: `Movies`
        *   Type: `Movies`
        *   Folder: `/movies` (mapped to `MEDIA_ROOT/movies`)
    *   **Add Library - TV Shows:**
        *   Name: `TV Shows`
        *   Type: `TV Shows`
        *   Folder: `/tv` (mapped to `MEDIA_ROOT/tv`)
    *   **Agent Instructions:** Ask user if they want additional libraries (Music, Photos, etc.).
    *   Update the status of this sub-step to `[COMPLETE]`.

5.  **Verify Remote Access (Optional)** [COMPLETE]
    *   Go to **Settings > Remote Access**.
    *   Ensure port 32400 is accessible (port forwarding configured in Step 2).
    *   *Note:* Full domain-based access will be configured in Step 14.
    *   Update the status of this sub-step to `[COMPLETE]`.

6.  **Update Documentation** [COMPLETE]
    *   Once all preceding steps in this document are `[COMPLETE]`:
    *   Update `docs/Services.md` with Plex configuration details.
    *   Update the status of this sub-step to `[COMPLETE]`.

7.  **Mark Step as Complete** [COMPLETE]
    *   Once all preceding steps in this document are `[COMPLETE]`:
    *   Update the status at the top of this file to `COMPLETE`.
    *   Update `setup/SETUP.md` to mark Step 7 as `[COMPLETE]`.
    *   Update the status of this sub-step to `[COMPLETE]`.


## Important Notes
- **Claim Token Expiration:** The Plex claim token is only valid for 4 minutes after generation. If deployment fails or takes too long, you'll need to generate a new token.
- **After Claiming:** Once the server is claimed, you can remove or leave the `PLEX_CLAIM` variable in dotenv - it's only needed for the initial claim.
- **Hardware Transcoding:** If you have Intel QuickSync or NVIDIA GPU, hardware transcoding can be enabled in Settings > Transcoder (requires Plex Pass for GPU transcoding).
