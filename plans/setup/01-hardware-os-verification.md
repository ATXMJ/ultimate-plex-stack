**Navigation:** [← Previous: Overview – High-Level Implementation Plan](00-SETUP.md) | [Next: Step 2 – Network Planning →](02-network-planning.md)

# Step 1: Hardware & OS Verification

**Status:** `COMPLETE`

This document details the verification steps for the host hardware and operating system to ensure they meet the requirements for the Ultimate Plex Stack.

## Objectives
- Confirm Windows 11 Pro specifications.
- Verify Docker Desktop installation and backend configuration.
- Ensure adequate local storage performance and capacity.

## Detailed Implementation Steps

1.  **Verify Windows Version** [COMPLETE]
    *   Open PowerShell as Administrator.
    *   Run `Get-ComputerInfo | Select-Object WindowsProductName, WindowsVersion, OsHardwareAbstractionLayer`.
    *   Confirm `WindowsProductName` includes "Pro" or "Enterprise" (required for optimal Docker Desktop/Hyper-V support, though Home works with WSL2, Pro is recommended in specs).
    *   *Validation:* Output must confirm Windows 11.
    *   Update the status of this sub-step to `[COMPLETE]`.

2.  **Verify Docker Desktop Installation** [COMPLETE]
    *   Check if Docker is installed: `docker --version`.
    *   If not installed, download from [Docker Hub](https://www.docker.com/products/docker-desktop/).
    *   Run Docker Desktop.
    *   Go to **Settings > General** and ensure "Use the WSL 2 based engine" is checked.
    *   Go to **Settings > Resources > WSL Integration** and ensure your default distro (usually Ubuntu or similar, if installed) is enabled, or just that the integration is active for the main backend.
    *   *Validation:* Run `docker run --rm hello-world` in PowerShell. It should download and run successfully.
    *   Update the status of this sub-step to `[COMPLETE]`.

3.  **Check Hardware Resources** [COMPLETE]
    *   **CPU:** Ensure modern CPU (Intel 8th Gen+ recommended for QuickSync, though not strictly required if not transcoding heavily).
    *   **RAM:** Minimum 16GB recommended for full stack stability. Check `Get-ComputerInfo | Select-Object OsTotalVisibleMemorySize`.
    *   **Virtualization:** Verify Virtualization is enabled in BIOS/Task Manager.
        *   Task Manager > Performance > CPU > "Virtualization: Enabled".
    *   Update the status of this sub-step to `[COMPLETE]`.

4.  **Storage Verification** [COMPLETE]
    *   Identify the drive for the installation (e.g., `C:`).
    *   Check free space: `Get-PSDrive C`.
    *   **Requirement:** At least 500GB SSD recommended (NVMe preferred) for application data, databases, and temporary download cache.
    *   *Validation:* Free space > 200GB (minimum for safe operation with downloads).
    *   Update the status of this sub-step to `[COMPLETE]`.

5.  **Update Documentation** [PLANNED]
    *   Once all preceding steps in this document are `[COMPLETE]`:
    *   Update `docs/` with any new findings or configuration details.
    *   Reflect any hardware or OS specifics in `docs/Specs.md` or `docs/Deployment.md`.
    *   Update the status of this sub-step to `[COMPLETE]`.

6.  **Mark Step as Complete** [PLANNED]
    *   Once all preceding steps in this document are `[COMPLETE]`:
    *   Update the status at the top of this file to `COMPLETE`.
    *   Update `setup/SETUP.md` to mark Step 1 as `[COMPLETE]`.
    *   Update the status of this sub-step to `[COMPLETE]`.

