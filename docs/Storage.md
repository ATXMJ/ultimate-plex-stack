# Storage Architecture

## Hybrid Storage Strategy

The stack uses a hybrid approach: **server and application data remains local** while **only media libraries are stored on NAS**. This provides optimal performance for temporary operations while leveraging NAS for long-term media storage.

## Local Storage Layout (Server & Application Data)

```
/
├── docker/
│   ├── plex-stack/
│   │   ├── config/          # Application configurations (LOCAL)
│   │   │   ├── plex/
│   │   │   ├── radarr/
│   │   │   ├── sonarr/
│   │   │   ├── bazarr/
│   │   │   └── ...
│   │   ├── downloads/       # Temporary downloads (LOCAL)
│   │   │   ├── movies/
│   │   │   ├── tv/
│   │   │   └── complete/
│   │   ├── transcode/       # Plex transcode temp (LOCAL)
│   │   └── temp/            # Other temporary files (LOCAL)
│   └── shared/              # Cross-container data (LOCAL)
```

## NAS Storage Layout (Media Libraries Only)

**NAS Name:** `Gargantua`

On Windows, Gargantua will be mounted as the `G:` drive, with a `media` share:

```
G:\media\
├── movies\                 # Movie library (NAS)
├── tv\                     # TV show library (NAS)
└── books\                  # Books/Audiobooks (NAS - future)
```

## Volume Mapping Strategy

### Initial Setup (Local Media)
```yaml
volumes:
  # Application configs - LOCAL
  - ./config/plex:/config
  - ./config/radarr:/config

  # Temporary files - LOCAL (performance critical)
  - ./downloads:/downloads
  - ./transcode:/transcode

  # Media libraries - LOCAL (initially)
  - ./media/movies:/movies
  - ./media/tv:/tv
```

### NAS Migration (Media Libraries Only)
```yaml
volumes:
  # Application configs - REMAIN LOCAL
  - ./config/plex:/config
  - ./config/radarr:/config

  # Temporary files - REMAIN LOCAL (performance critical)
  - ./downloads:/downloads
  - ./transcode:/transcode

  # Media libraries - MOVED TO NAS (Gargantua G: drive on Windows)
  - G:\media\movies:/movies
  - G:\media\tv:/tv
```

### Environment Variables for Flexibility
```bash
# Media library paths (update when migrating to NAS)
MOVIES_PATH=G:\media\movies    # Change from ./media/movies
TV_PATH=G:\media\tv            # Change from ./media/tv

# Keep downloads and transcode local for performance
DOWNLOADS_PATH=./downloads           # Always local
TRANSCODE_PATH=./transcode           # Always local
```

## Storage Requirements

### Local Storage (Server & Application Data)
- **Minimum**: 500GB SSD for initial setup
  - 100GB configs and application data
  - 200GB downloads (temporary, can be cleared)
  - 200GB transcode temp files
- **Recommended**: 1TB NVMe SSD for performance
- **Purpose**: Fast access for application binaries, configs, and temporary operations

### NAS Storage (Media Libraries Only)
- **Minimum**: 2TB for initial media library
- **Recommended**: 4TB+ for growth (movies + TV)
- **RAID**: Hardware RAID 5/6 or software RAID with redundancy
- **Backup**: Multiple copies, offsite backup solution
- **Network**: Gigabit Ethernet minimum, 10GbE recommended for large libraries

