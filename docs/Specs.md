# Ultimate Plex Media Stack - Technical Specifications

## Overview

This specification defines a comprehensive personal media server stack built with Docker Compose, providing automated media management, streaming, and content acquisition capabilities. The stack is designed to be initially deployed on local storage with easy migration paths to NAS systems.

This repository includes complete configuration for serving the Plex stack securely via your own custom domain name, with automatic SSL certificate management, reverse proxy setup, and remote access capabilities.

## Documentation Structure

This specification is organized into focused sections for easy navigation and reference. Each section provides detailed information about specific aspects of the stack:

### 📐 [Architecture Overview](Architecture.md)
High-level system design, component relationships, and network topology. Start here to understand how the stack is structured and how services interact.

**Key Topics:**
- Core component layout
- Network architecture diagram
- VPN usage strategy

### 🔧 [Service Specifications](Services.md)
Complete details for each Docker container in the stack, including ports, volumes, environment variables, and configuration notes.

**Services Covered:**
- Media Server: Plex
- Content Management: Radarr, Sonarr, Readarr, Lidarr, Prowlarr, Bazarr, Overseerr, Plex Meta Manager, Plex Auto Languages, Membarr, Wizarr, Recyclarr
- Processing: Tdarr, Unpackerr
- Acquisition: qBittorrent, Autobrr, Cross Seed
- Infrastructure: Flaresolverr, Dozzle (Note: VPN functionality is integrated with qBittorrent. Nginx Proxy Manager is external but implied by network configuration.)

### 💾 [Storage Architecture](Storage.md)
Hybrid storage strategy, volume mappings, and migration paths between local and NAS storage.

**Key Topics:**
- Local vs NAS storage strategy
- Directory structure and layouts
- Volume mapping patterns
- Storage requirements and recommendations
- NAS migration procedures

### 🌐 [Networking and Security](Networking.md)
Network configuration, VPN integration, kill switch implementation, and access control policies.

**Key Topics:**
- Internal Docker networking
- VPN integration (download clients only)
- Kill switch implementation and behavior
- Authentication strategies per service
- Reverse proxy security
- Multi-user access control

### ⚙️ [Configuration Management](Configuration.md)
Environment variables, Docker Compose profiles, and configuration patterns.

**Key Topics:**
- `.env` file structure
- Docker Compose profiles for different deployment scenarios
- Configuration best practices

### 🚀 [Deployment Instructions](Deployment.md)
Step-by-step setup procedures from initial installation to NAS migration.

**Key Topics:**
- Prerequisites and requirements
- Initial setup steps
- Service integration procedures
- NAS migration guide
- VPN configuration workflow

### 🔧 [Maintenance and Monitoring](Maintenance.md)
Ongoing operations, backup strategies, monitoring solutions, and troubleshooting procedures.

**Key Topics:**
- Backup strategies
- Monitoring and health checks
- Update procedures
- Troubleshooting common issues

### 🔮 [Future Enhancements](Future.md)
Planned features, potential integrations, and scalability options.

**Key Topics:**
- Additional service integrations
- Advanced features (GPU transcoding, CDN)
- Scalability and orchestration options

## Quick Reference

### Key Design Principles

1. **Hybrid Storage**: Application data stays local (fast), media libraries on NAS (capacity)
2. **Selective VPN**: Only torrent/usenet clients route through VPN with kill switch protection
3. **Security First**: Multi-layer authentication, infrastructure-level VPN enforcement
4. **Modular Design**: Docker Compose profiles for flexible deployment scenarios
5. **Migration Ready**: Easy path from local storage to NAS without service reconfiguration

### Technology Stack

- **Containerization**: Docker & Docker Compose
- **Media Server**: Plex Media Server
- **Automation**: Radarr, Sonarr, Prowlarr, Bazarr
- **Downloads**: qBittorrent (torrents), NZBGet (usenet)
- **Processing**: Tdarr (transcoding)
- **Requests**: Overseerr
- **Networking**: Nginx Proxy Manager, WireGuard/OpenVPN
- **Platform**: Windows 11 Pro with Docker Desktop

### Critical Security Features

- **VPN Kill Switch**: Torrent and usenet clients completely blocked if VPN disconnects
- **Infrastructure-Level Protection**: VPN enforcement via Docker networking (not client config)
- **Reverse Proxy Authentication**: Secure admin services behind authenticated proxy
- **Isolated Networks**: Dedicated Docker bridge network for service isolation

## Getting Started

1. **New Users**: Start with [Deployment Instructions](Deployment.md) → [Architecture Overview](Architecture.md) → [Service Specifications](Services.md)
2. **Migration Planning**: Review [Storage Architecture](Storage.md) → [Deployment Instructions](Deployment.md#nas-migration)
3. **Security Setup**: Read [Networking and Security](Networking.md) for VPN and authentication configuration
4. **Troubleshooting**: Check [Maintenance and Monitoring](Maintenance.md#troubleshooting)

## Contributing

This is a personal media server project. If you're using this as a template for your own setup, feel free to fork and customize to your needs.

## License

See [LICENSE](../LICENSE) for details.
