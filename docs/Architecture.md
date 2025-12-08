# Architecture Overview

## Core Components

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Content       │    │   Management    │    │   Streaming     │
│   Acquisition   │────│   Services      │────│   Services      │
│                 │    │                 │    │                 │
│ • Torrent       │    │ • Radarr        │    │ • Plex Media    │
│ • Usenet        │    │ • Sonarr        │    │   Server        │
│ • VPN Gateway   │    │ • Prowlarr      │    │ • Overseerr     │
└─────────────────┘    │ • Bazarr        │    └─────────────────┘
                       │ • Tdarr         │
                       └─────────────────┘
```

## Network Architecture

```
Internet ── Reverse Proxy ── Services (Plex, Radarr, Sonarr, etc.)
            │
            └── VPN Gateway ── Content Acquisition Only
                (Kill Switch)   (qBittorrent, NZBGet)
```

**VPN Usage**: Only torrent and usenet clients route through VPN. All other services (Plex, management services, reverse proxy) use direct internet connection.

