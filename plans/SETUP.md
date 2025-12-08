# Ultimate Plex Stack - High-Level Implementation Plan

This document outlines the high-level step-by-step plan for implementing the Ultimate Plex Media Stack as specified in `docs/Specs.md`. 

**Note:** We will create individual detailed comprehensive plans for each phase of this high-level setup plan in separate documents.

## Phase 1: Preparation & Infrastructure

1.  **Hardware & OS Verification** [COMPLETE] ([Detail](steps/01-hardware-os-verification.md))
    *   Confirm Windows 11 Pro host requirements.
    *   Verify Docker Desktop installation and configuration (WSL2 backend).
    *   Ensure sufficient local storage availability (SSD for configs/cache).

2.  **Network Planning** [COMPLETE] ([Detail](steps/02-network-planning.md))
    *   Verify VPN subscription and credentials (for download clients).
    *   Determine domain name strategy (custom domain vs. local IP).
    *   Plan internal Docker network structure (`plex-stack`).

## Phase 2: Environment & Storage Configuration

3.  **Environment Configuration** [COMPLETE] ([Detail](steps/03-environment-configuration.md))
    *   Create `dotenv` from `.env.example`.
    *   **Note:** Due to globalignore, we are using `dotenv` temporarily instead of `.env`.
    *   Populate critical variables:
        *   User/Group IDs (`PUID`, `PGID`).
        *   Timezone (`TZ`).
        *   VPN credentials (NordVPN access token).
        *   Media and download paths.
        *   Domain and ACME email.
    *   **Note:** Plex Claim Token moved to Step 7 (4-minute expiration).
    *   **Agent Instructions:** Prompt user for all configuration values before marking complete.

4.  **Local Directory Structure Setup** [COMPLETE] ([Detail](steps/04-local-directory-structure.md))
    *   Create host directory hierarchy for persistence:
        *   `config/` (Application data) - 11 subdirectories created.
        *   `downloads/` (Temporary download cache) - 3 subdirectories created.
        *   `transcode/` (Plex transcode buffer) - created.
        *   `media/` (Initial local media library roots) - 2 subdirectories created.

## Phase 3: Networking & Security Layer

5.  **VPN Gateway Deployment** [COMPLETE] ([Detail](steps/05-vpn-gateway-deployment.md))
    *   Deploy VPN container (gluetun with NordVPN OpenVPN).
    *   Configure firewall/iptables "kill switch" rules (built-in).
    *   Verify secure connection and IP masking (185.153.177.180).

6.  **Reverse Proxy Deployment** [COMPLETE] ([Detail](steps/06-reverse-proxy-deployment.md))
    *   Deploy Nginx Proxy Manager.
    *   Configure initial admin access.
    *   Set up SSL certificate generation (Let's Encrypt).

## Phase 4: Core Services Deployment

7.  **Plex Media Server** [COMPLETE] ([Detail](steps/07-plex-media-server.md))
    *   Deploy Plex container (`core` profile).
    *   Verify Web UI access.
    *   Claim server and configure initial libraries.

8.  **Content Acquisition Services (VPN-Routed)** [COMPLETE] ([Detail](steps/08-content-acquisition-services.md))
    *   Deploy qBittorrent and/or NZBGet.
    *   **Crucial:** Verify routing through VPN container (`network_mode: service:vpn`).
    *   Test kill switch functionality.

## Phase 5: Management & Automation

9.  **Indexer Management** [PLANNED] ([Detail](steps/10-indexer-management.md))
    *   Deploy Prowlarr.
    *   Configure indexers (torrent/usenet sites).

10. **Media Management (The "Arrs")** [PLANNED] ([Detail](steps/11-media-management.md))
    *   Deploy Radarr (Movies) and Sonarr (TV).
    *   Deploy Bazarr (Subtitles).
    *   Connect them to Prowlarr.
    *   Connect them to Download Clients (qBittorrent/NZBGet).

11. **Request Management** [PLANNED] ([Detail](steps/12-request-management.md))
    *   Deploy Overseerr.
    *   Connect to Plex for authentication.
    *   Connect to Radarr/Sonarr for fulfillment.

## Phase 6: Optimization & Processing

12. **Media Processing** [PLANNED] ([Detail](steps/13-media-processing.md))
    *   Deploy Tdarr (optional/advanced).
    *   Configure transcoding nodes/plugins.

## Phase 7: Integration & Final Polish

13. **Service Interlinking** [PLANNED] ([Detail](steps/14-service-interlinking.md))
    *   Finalize API key exchanges between services.
    *   Configure download paths and categories (mappings).

14. **Reverse Proxy Routing** [PLANNED] ([Detail](steps/15-reverse-proxy-routing.md))
    *   Set up subdomains/hosts in Nginx Proxy Manager for all services.
    *   Enable SSL for all external-facing endpoints.

15. **System Verification** [PLANNED] ([Detail](steps/16-system-verification.md))
    *   End-to-end test: Request -> Download -> Process -> Stream.

## Phase 8: Future Migration (Post-Setup)

16. **NAS Migration** [PLANNED] ([Detail](steps/17-nas-migration.md))
    *   Mount NAS storage to host.
    *   Migrate media files.
    *   Update volume mappings in Docker Compose.
    *   Restart stack and rescan libraries.
