# Ultimate Plex Media Stack Setup Guide

This guide provides a high-level implementation plan for setting up the Ultimate Plex Media Stack as specified in [SPEC.md](./SPEC.md). The setup process is broken down into major phases, with each phase documented in detail in separate step files.

## Major Setup Phases

### Phase 1: Prerequisites and Environment Preparation
**File**: [SETUP-1-Prerequisites.md](./SETUP-1-Prerequisites.md)
- Verify system requirements (Linux, Docker, storage)
- Configure user permissions and security settings
- Set up firewall and network access rules
- Prepare VPN service credentials

### Phase 2: Repository Setup and Initial Configuration
**File**: [SETUP-2-Repository-Setup.md](./SETUP-2-Repository-Setup.md)
- Clone the ultimate-plex-stack repository
- Create and configure environment variables (.env file)
- Set up domain configuration for reverse proxy
- Initialize basic Docker Compose configuration

### Phase 3: Directory Structure and Storage Setup
**File**: [SETUP-3-Directory-Structure.md](./SETUP-3-Directory-Structure.md)
- Create local directory structure for configs and temp files
- Set up initial local media directories
- Configure proper file permissions and ownership
- Prepare storage layout following hybrid storage strategy

### Phase 4: Core Services Deployment
**File**: [SETUP-4-Core-Services.md](./SETUP-4-Core-Services.md)
- Deploy core media management services (Plex, Radarr, Sonarr)
- Start supporting services (Bazarr, Prowlarr, Overseerr)
- Configure Docker networks and service isolation
- Verify initial service startup and basic connectivity

### Phase 5: Service Configuration and Integration
**File**: [SETUP-5-Service-Integration.md](./SETUP-5-Service-Integration.md)
- Configure Plex Media Server and claim setup
- Set up indexer connections through Prowlarr
- Integrate Radarr/Sonarr with download clients
- Configure Overseerr for request management

### Phase 6: Security and Network Setup
**File**: [SETUP-6-Security-Network.md](./SETUP-6-Security-Network.md)
- Configure VPN gateway and kill switch for torrent/usenet
- Set up Nginx Proxy Manager for SSL and reverse proxy
- Implement authentication for all services
- Configure firewall rules and network security

### Phase 7: Advanced Services (Optional)
**File**: [SETUP-7-Advanced-Services.md](./SETUP-7-Advanced-Services.md)
- Deploy Tdarr for media transcoding
- Set up content acquisition services (qBittorrent, NZBGet)
- Configure GPU acceleration for transcoding (if available)
- Integrate advanced services with existing stack

### Phase 8: NAS Migration (Optional)
**File**: [SETUP-8-NAS-Migration.md](./SETUP-8-NAS-Migration.md)
- Prepare NAS storage and mount points
- Migrate media libraries from local to NAS storage
- Update Docker volume mappings
- Verify Plex library scanning and integrity

### Phase 9: Testing and Validation
**File**: [SETUP-9-Testing-Validation.md](./SETUP-9-Testing-Validation.md)
- Perform end-to-end testing of media acquisition pipeline
- Validate streaming functionality and transcoding
- Test security configurations and access controls
- Set up monitoring and backup procedures

## Quick Start Commands

For experienced users, the basic deployment can be completed with:

```bash
# Phase 1-2: Prerequisites and Repository Setup
git clone https://github.com/DonMcD/ultimate-plex-stack.git
cd ultimate-plex-stack
cp .env.example .env
# Edit .env with your configuration

# Phase 3: Directory Structure
mkdir -p config downloads transcode media/{movies,tv,music,photos}
chown -R $USER:$USER config downloads transcode media

# Phase 4: Deploy Core Services
docker compose --profile core up -d

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
