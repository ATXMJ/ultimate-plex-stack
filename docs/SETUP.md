# Ultimate Plex Media Stack Setup Guide

This guide provides a high-level implementation plan for setting up the Ultimate Plex Media Stack as specified in [SPEC.md](./SPEC.md). The setup process is broken down into major phases, with each phase documented in detail in separate step files.

## Major Setup Phases

### Phase 1: Prerequisites and Environment Preparation `PLANNED`
**File**: [SETUP-1-Prerequisites.md](./SETUP-1-Prerequisites.md)
- Verify system requirements (Linux, Docker, storage) `PLANNED`
- Configure user permissions and security settings `PLANNED`
- Set up firewall and network access rules `PLANNED`
- Prepare VPN service credentials `PLANNED`

**Note**: Update status to `COMPLETED` after successfully completing all prerequisites and environment preparation steps.

### Phase 2: Repository Setup and Initial Configuration `PLANNED`
**File**: [SETUP-2-Repository-Setup.md](./SETUP-2-Repository-Setup.md)
- Clone the ultimate-plex-stack repository `PLANNED`
- Create and configure environment variables (.env file) `PLANNED`
- Set up domain configuration for reverse proxy `PLANNED`
- Initialize basic Docker Compose configuration `PLANNED`

**Note**: Update status to `COMPLETED` after successfully cloning the repository, configuring environment variables, and validating Docker Compose setup.

### Phase 3: Directory Structure and Storage Setup `PLANNED`
**File**: [SETUP-3-Directory-Structure.md](./SETUP-3-Directory-Structure.md)
- Create local directory structure for configs and temp files `PLANNED`
- Set up initial local media directories `PLANNED`
- Configure proper file permissions and ownership `PLANNED`
- Prepare storage layout following hybrid storage strategy `PLANNED`

**Note**: Update status to `COMPLETED` after successfully creating all required directories, setting proper permissions, and preparing the storage layout.

### Phase 4: Core Services Deployment `PLANNED`
**File**: [SETUP-4-Core-Services.md](./SETUP-4-Core-Services.md)
- Deploy core media management services (Plex, Radarr, Sonarr) `PLANNED`
- Start supporting services (Bazarr, Prowlarr, Overseerr) `PLANNED`
- Configure Docker networks and service isolation `PLANNED`
- Verify initial service startup and basic connectivity `PLANNED`

**Note**: Update status to `COMPLETED` after successfully deploying all core services and verifying their basic connectivity and functionality.

### Phase 5: Service Configuration and Integration `PLANNED`
**File**: [SETUP-5-Service-Integration.md](./SETUP-5-Service-Integration.md)
- Configure Plex Media Server and claim setup `PLANNED`
- Set up indexer connections through Prowlarr `PLANNED`
- Integrate Radarr/Sonarr with download clients `PLANNED`
- Configure Overseerr for request management `PLANNED`

**Note**: Update status to `COMPLETED` after successfully configuring all service integrations and verifying cross-service connectivity.

### Phase 6: Security and Network Setup `PLANNED`
**File**: [SETUP-6-Security-Network.md](./SETUP-6-Security-Network.md)
- Configure VPN gateway and kill switch for torrent/usenet `PLANNED`
- Set up Nginx Proxy Manager for SSL and reverse proxy `PLANNED`
- Implement authentication for all services `PLANNED`
- Configure firewall rules and network security `PLANNED`

**Note**: Update status to `COMPLETED` after successfully configuring VPN security, reverse proxy with SSL, authentication, and network security measures.

### Phase 7: Advanced Services (Optional) `PLANNED`
**File**: [SETUP-7-Advanced-Services.md](./SETUP-7-Advanced-Services.md)
- Deploy Tdarr for media transcoding `PLANNED`
- Set up content acquisition services (qBittorrent, NZBGet) `PLANNED`
- Configure GPU acceleration for transcoding (if available) `PLANNED`
- Integrate advanced services with existing stack `PLANNED`

**Note**: Update status to `COMPLETED` after successfully deploying and configuring all advanced services and verifying their integration with the core stack.

### Phase 8: NAS Migration (Optional) `PLANNED`
**File**: [SETUP-8-NAS-Migration.md](./SETUP-8-NAS-Migration.md)
- Prepare NAS storage and mount points `PLANNED`
- Migrate media libraries from local to NAS storage `PLANNED`
- Update Docker volume mappings `PLANNED`
- Verify Plex library scanning and integrity `PLANNED`

**Note**: Update status to `COMPLETED` after successfully migrating all media to NAS storage and verifying library integrity and access.

### Phase 9: Testing and Validation `PLANNED`
**File**: [SETUP-9-Testing-Validation.md](./SETUP-9-Testing-Validation.md)
- Perform end-to-end testing of media acquisition pipeline `PLANNED`
- Validate streaming functionality and transcoding `PLANNED`
- Test security configurations and access controls `PLANNED`
- Set up monitoring and backup procedures `PLANNED`

**Note**: Update status to `COMPLETED` after successfully completing all testing procedures and establishing monitoring and backup routines.

## Quick Start Commands

For experienced users, the basic deployment can be completed with:

### Available Makefile Targets

The repository includes a Makefile with convenient targets for managing the stack:

- `make up` - Start services (attached mode)
- `make up-d` - Start services in background (detached)
- `make down` - Stop all services
- `make restart` - Restart services
- `make logs` - View service logs
- `make clean` - Clean up containers and volumes
- `make pull` - Pull latest Docker images
- `make build` - Build custom images (if modified)

```powershell
# Phase 1-2: Prerequisites and Repository Setup
git clone https://github.com/DonMcD/ultimate-plex-stack.git
cd ultimate-plex-stack
copy .env.example .env
# Edit .env with your configuration

# Phase 3: Directory Structure
mkdir config, downloads, transcode -Force
mkdir media\movies, media\tv, media\music, media\photos -Force

# Phase 4: Deploy Core Services
make up-d

# Alternative: Direct Docker Compose command
# docker compose --profile core up -d

# Phase 5-9: Follow detailed step files for configuration
```

## Collaborative Implementation Approach

When implementing each phase with the AI assistant, expect a collaborative workflow where:

### Agent Guidance During Implementation
- **Step-by-Step Guidance**: The agent will guide you through each manual step, explaining what needs to be done and why
- **Information Gathering**: The agent will prompt you for required information (API keys, credentials, preferences) before proceeding
- **Interactive Verification**: After each major step, the agent will help you verify the results and address any issues
- **Safety Checks**: The agent will include validation steps and safety precautions to prevent data loss or security issues
- **Problem Resolution**: If issues arise, the agent will work with you to diagnose and resolve them collaboratively

### What to Prepare
- **Credentials**: VPN accounts, domain registrar access, Plex account
- **System Access**: Administrative access to your server
- **Time**: Each phase requires focused attention and testing
- **Backup**: Ensure you have current backups before making configuration changes

### Communication Style
- **Clear Instructions**: The agent will provide specific commands and explain their purpose
- **Progress Confirmation**: Regular check-ins to confirm you're ready to proceed
- **Flexible Pacing**: The agent will adapt to your comfort level and experience
- **Documentation**: All changes and configurations will be documented as you proceed

## Important Notes

- **Order Matters**: Complete phases in sequence - later phases depend on earlier configurations
- **Security First**: Never skip security setup; configure authentication before exposing services
- **Testing**: Always test functionality after each major phase
- **Backups**: Create backups before making significant changes
- **Documentation**: Refer to [SPEC.md](./SPEC.md) for detailed service specifications
- **Support**: Check service logs with `docker compose logs <service>` for troubleshooting

## Estimated Timeline

- **Phase 1-3**: 30-60 minutes (environment setup)
- **Phase 4-5**: 2-4 hours (core deployment and basic configuration)
- **Phase 6**: 1-2 hours (security and networking)
- **Phase 7-8**: 1-3 hours (advanced features and NAS migration)
- **Phase 9**: 30-60 minutes (testing and validation)

**Total Time**: 6-12 hours for full setup (depending on experience level)

---

Each phase is documented in detail in the referenced step files. Start with [SETUP-1-Prerequisites.md](./SETUP-1-Prerequisites.md) and progress through each phase sequentially.
