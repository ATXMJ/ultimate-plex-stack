# Step 4: Local Directory Structure Setup

**Status:** `COMPLETE`

**Agent Instructions:** Before creating directories, confirm paths from Step 3 environment configuration. If paths are not yet configured with real values, prompt user to complete Step 3 first.

## Objectives
- Create local directory hierarchy for application data, downloads, and media storage.
- Set up proper subdirectory structure for each component.
- Verify directory creation and permissions.

## Path Configuration (from Step 3)
- **CONFIG_ROOT:** `C:/plex-server/ultimate-plex-stack/config`
- **DOWNLOAD_ROOT:** `C:/plex-server/ultimate-plex-stack/downloads`
- **MEDIA_ROOT:** `C:/plex-server/ultimate-plex-stack/media`
- **Additional:** `C:/plex-server/ultimate-plex-stack/transcode` (Plex transcode buffer)

## Directory Structure to Create

### 1. Configuration Directory [COMPLETE]
```
config/
├── plex/              # Plex Media Server configuration
├── radarr/            # Radarr (movies) configuration
├── sonarr/            # Sonarr (TV shows) configuration
├── bazarr/            # Bazarr (subtitles) configuration
├── prowlarr/          # Prowlarr (indexer management) configuration
├── overseerr/         # Overseerr (request management) configuration
├── qbittorrent/       # qBittorrent configuration
├── nzbget/            # NZBGet configuration
├── tdarr/             # Tdarr (transcoding) configuration
├── npm/               # Nginx Proxy Manager configuration
└── vpn/               # VPN configuration (already exists)
```

### 2. Downloads Directory [COMPLETE]
```
downloads/
├── movies/            # Movie downloads in progress
├── tv/                # TV show downloads in progress
└── complete/          # Completed downloads before processing
```

### 3. Media Directory [COMPLETE]
```
media/
├── movies/            # Final movie library
└── tv/                # Final TV show library
```

### 4. Transcode Directory [COMPLETE]
```
transcode/             # Plex transcode temporary files
```

## Detailed Implementation Steps

1. **Create Configuration Subdirectories** [COMPLETE]
   - Created `config/plex`, `config/radarr`, `config/sonarr`, `config/bazarr`, `config/prowlarr`
   - Created `config/overseerr`, `config/qbittorrent`, `config/nzbget`, `config/tdarr`, `config/npm`
   - Verified `config/vpn` already exists
   - All 11 configuration subdirectories now in place

2. **Create Downloads Subdirectories** [COMPLETE]
   - Created `downloads/movies`, `downloads/tv`, `downloads/complete`
   - Ready for download client operations

3. **Create Media Subdirectories** [COMPLETE]
   - Created `media/movies`, `media/tv`
   - Ready for media library storage

4. **Create Transcode Directory** [COMPLETE]
   - Created `transcode/` for Plex temporary transcoding files
   - Ready for Plex operations

5. **Verify Directory Structure** [COMPLETE]
   - Verified all directories created successfully:
     - config/ with 11 subdirectories (including existing vpn/)
     - downloads/ with 3 subdirectories
     - media/ with 2 subdirectories
     - transcode/ ready for use

6. **Update Documentation** [COMPLETE]
   - No changes needed to `docs/Storage.md` - paths match documentation

7. **Mark Step as Complete** [COMPLETE]
   - All substeps completed successfully
   - Status updated to `COMPLETE`
   - `plans/SETUP.md` will be updated next


## Notes
- These directories will be bind-mounted into Docker containers.
- On Windows with Docker Desktop + WSL2, file permissions are automatically managed.
- The `config/` directory tree already partially exists (with vpn/ subdirectory).
- This is the local storage setup; NAS migration will occur in Step 16.

## Current Status Summary
- ✅ All configuration directories created (11 subdirectories)
- ✅ All downloads directories created (3 subdirectories)
- ✅ All media directories created (2 subdirectories)
- ✅ Transcode directory created
- ✅ Directory structure verified
- ✅ Ready for service deployment in subsequent steps