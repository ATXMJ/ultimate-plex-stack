# Step 5: VPN Gateway Deployment

**Status:** `PLANNED`

This document details the deployment of the VPN container (gluetun or similar) which serves as the secure gateway for download clients.

**Agent Instructions:** Before deploying VPN, verify that VPN credentials in Step 3 are configured with real values (not placeholders). Prompt user if needed.

## Objectives
- Deploy the VPN container.
- Verify connectivity to the VPN provider.
- Implement and test the "kill switch" mechanism.

## Detailed Implementation Steps

1.  **Select VPN Image** [PLANNED]
    *   Common choice: `qdm12/gluetun` or `linuxserver/wireguard`.
    *   For this stack, we assume a dedicated VPN container (e.g., `vpn` service in compose).
    *   Update the status of this sub-step to `[COMPLETE]`.

2.  **Configure Docker Compose Service** [PLANNED]
    *   Edit/Review `docker-compose.yml` for the `vpn` service.
    *   Ensure `cap_add: - NET_ADMIN` is present.
    *   Ensure proper environment variables match your provider (from Step 4).
    *   *If WireGuard:* Ensure `wg0.conf` is mapped to `/config/wg0.conf`.
    *   Update the status of this sub-step to `[COMPLETE]`.

3.  **Configure Kill Switch** [PLANNED]
    *   **Gluetun:** Has built-in kill switch (firewall) enabled by default. It blocks all traffic if the tunnel is down.
    *   **Manual/Other:** If using a generic OpenVPN container, ensure `iptables` rules are applied to drop non-tun0 traffic.
    *   *Action:* Verify the configuration explicitly mentions "kill switch" or firewall enabled.
    *   Update the status of this sub-step to `[COMPLETE]`.

4.  **Start VPN Container** [PLANNED]
    *   Run: `docker compose up -d vpn`.
    *   Check logs: `docker compose logs -f vpn`.
    *   *Success:* Look for "Initialization completed" or "Tunnel up".
    *   Update the status of this sub-step to `[COMPLETE]`.

5.  **Verify IP Address** [PLANNED]
    *   Run: `docker compose exec vpn curl -s https://ifconfig.me`.
    *   *Validation:* The output IP must match your VPN provider's IP, NOT your home ISP IP.
    *   Update the status of this sub-step to `[COMPLETE]`.

6.  **Verify Kill Switch (Simulation)** [PLANNED]
    *   Stop the VPN tunnel (e.g., modify config to be invalid, or internally stop the interface).
    *   Try to curl/ping out from inside the container.
    *   *Success:* The connection should TIMEOUT or fail immediately. It should NOT revert to your ISP IP.
    *   Update the status of this sub-step to `[COMPLETE]`.

7.  **Update Documentation** [PLANNED]
    *   Once all preceding steps in this document are `[COMPLETE]`:
    *   Update `docs/Networking.md` with VPN specifics (provider, protocol, kill switch verification).
    *   Update the status of this sub-step to `[COMPLETE]`.

8.  **Mark Step as Complete** [PLANNED]
    *   Once all preceding steps in this document are `[COMPLETE]`:
    *   Update the status at the top of this file to `COMPLETE`.
    *   Update `plans/SETUP.md` to mark Step 6 as `[COMPLETE]`.
    *   Update the status of this sub-step to `[COMPLETE]`.

## Verification Checklist
- [ ] VPN container running healthy.
- [ ] Public IP checked and masked.
- [ ] Kill switch verified (traffic blocks when VPN down).

