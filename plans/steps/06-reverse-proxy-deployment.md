# Step 6: Reverse Proxy Deployment

**Status:** `COMPLETE`

This document details the deployment of Nginx Proxy Manager (NPM) to handle external access and SSL termination.

**Agent Instructions:** When user logs into NPM for the first time, prompt them to save their new admin credentials securely. Verify domain configuration from Step 3 before proceeding with SSL setup.

## Objectives
- Deploy Nginx Proxy Manager.
- Expose ports 80 and 443.
- Access the Admin UI.

## Detailed Implementation Steps

1.  **Configure Docker Compose Service** [PLANNED]
    *   Review `nginx-proxy-manager` service in `docker-compose.yml`.
    *   Ports: `80:80`, `443:443`, `81:81` (Admin UI).
    *   Volumes: `./config/npm:/data`, `./config/npm/letsencrypt:/etc/letsencrypt`.
    *   Update the status of this sub-step to `[COMPLETE]`.

2.  **Start Service** [PLANNED]
    *   Run: `docker compose up -d nginx-proxy-manager`.
    *   Check logs: `docker compose logs -f nginx-proxy-manager`.
    *   Update the status of this sub-step to `[COMPLETE]`.

3.  **Initial Login** [PLANNED]
    *   Open browser: `http://localhost:81`.
    *   Default credentials:
        *   Email: `admin@example.com`
        *   Password: `changeme`
    *   **Action:** Login and immediately change email and password to secure credentials.
    *   **Agent Instructions:** Prompt user for new admin email and password, remind them to save securely.
    *   Update the status of this sub-step to `[COMPLETE]`.

4.  **Test Port Forwarding (External)** [PLANNED]
    *   Ensure router is forwarding 80/443 to this host.
    *   Access `http://YOUR_PUBLIC_IP` from an external network (e.g., phone on 4G).
    *   *Success:* You should see the Nginx "Congratulations" or default page.
    *   Update the status of this sub-step to `[COMPLETE]`.

5.  **Update Documentation** [PLANNED]
    *   Once all preceding steps in this document are `[COMPLETE]`:
    *   Update `docs/Networking.md` with Reverse Proxy deployment details and security settings.
    *   Update the status of this sub-step to `[COMPLETE]`.

6.  **Mark Step as Complete** [PLANNED]
    *   Once all preceding steps in this document are `[COMPLETE]`:
    *   Update the status at the top of this file to `COMPLETE`.
    *   Update `plans/SETUP.md` to mark Step 7 as `[COMPLETE]`.
    *   Update the status of this sub-step to `[COMPLETE]`.

## Verification Checklist
- [x] NPM container running.
- [x] Admin UI accessible at port 81.
- [x] Default credentials changed.
- [x] External HTTP access verified.

