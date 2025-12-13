i# Interstellar Naming Convention

This document outlines the comprehensive naming convention for the Ultimate Plex Media Stack, themed around the movie *Interstellar*. All components, services, directories, networks, and infrastructure elements follow this consistent naming scheme to create an immersive, thematic experience.

## 🌟 **Core Theme: Cooper Station**

**Primary Domain**: `cooperstation.stream` ✅ **DECIDED**

**Theme Inspiration**: Named after Joseph Cooper (Matthew McConaughey's character) and his role as a space station commander. The domain represents the central command center for your media operations - the "station" where all your digital exploration and content management takes place.

---

## 🖥️ **Infrastructure Components**

### **Server Computer (Host Machine)**
- **Name**: `Endurance` ✅ **DECIDED**
- **Hostname**: `cooper-station`
- **Purpose**: The central command center, like Cooper's role as mission commander

### **NAS Drive/Storage System**
- **Name**: `Gargantua` ✅ **DECIDED**
- **Mount Point**: `/mnt/gargantua`
- **SMB Share**: `\\gargantua\media`
- **Purpose**: The "black hole" that consumes and stores all your media content

---

## 🌐 **Domain & Subdomain Structure**

**Base Domain**: `cooperstation.stream`

### **Service Subdomains**
```
plex.cooperstation.stream          # Main media streaming
radarr.cooperstation.stream        # Movie automation
sonarr.cooperstation.stream        # TV show automation
bazarr.cooperstation.stream        # Subtitle management
prowlarr.cooperstation.stream      # Indexer management
overseerr.cooperstation.stream     # Content requests
tars.cooperstation.stream          # Admin dashboard
qbittorrent.cooperstation.stream   # Torrent downloads
nzbget.cooperstation.stream        # Usenet downloads
tdarr.cooperstation.stream         # Media transcoding
```

---

## 🐳 **Docker Services & Containers**

### **Core Media Services**
- **Plex**: `cooper-station-plex`
- **Radarr**: `murph-movies` (Murph = Murphy Cooper, the scientist)
- **Sonarr**: `brand-tv` (Murph's full name was Brand Cooper)
- **Bazarr**: `tars-subtitles` (TARS = sarcastic robot)
- **Prowlarr**: `case-indexer` (CASE = analytical robot)
- **Overseerr**: `kipp-requests` (KIPP = third robot)

### **Content Acquisition**
- **qBittorrent**: `wormhole-torrents` (wormhole = instant access)
- **NZBGet**: `quantum-usenet` (quantum = advanced tech)

### **Media Processing**
- **Tdarr**: `mann-transcoder` (Mann = the deceptive planet)

### **Network & Security**
- **WireGuard/OpenVPN**: `edmunds-gateway` (Edmunds = promising destination)
- **Nginx Proxy Manager**: `tesseract-proxy` (tesseract = multi-dimensional space)

---

## 📁 **Directory Structure & Volumes**

### **Local Storage (Server Data)**
```
/opt/cooper-station/
├── config/
│   ├── cooper-station-plex/
│   ├── murph-movies-radarr/
│   ├── brand-tv-sonarr/
│   ├── tars-subtitles-bazarr/
│   ├── case-indexer-prowlarr/
│   ├── kipp-requests-overseerr/
│   ├── wormhole-torrents-qbittorrent/
│   ├── quantum-usenet-nzbget/
│   ├── mann-transcoder-tdarr/
│   └── tesseract-proxy-nginx/
├── downloads/
│   ├── wormhole-complete/
│   └── quantum-temp/
├── transcode/
│   └── relativity-temp/
└── temp/
    └── spacetime-cache/
```

### **NAS Storage (Media Libraries)**
```
/mnt/gargantua/
├── media/
│   ├── movies/          # Movie collection
│   ├── tv/             # TV show collection
│   └── books/          # Audiobooks (future)
└── backups/
    └── cooper-archives/
```

---

## 🌐 **Docker Networks**

- **`cooper-station-net`** - Main isolated network for core services
- **`wormhole-vpn-net`** - VPN network for secure torrenting/usenet
- **`tesseract-admin-net`** - Admin-only network for management services
- **`quantum-bridge-net`** - Bridge network for external access

---

## 🔐 **Security & Access Control**

### **VPN Configuration**
- **Provider Config**: `edmunds-vpn-config`
- **Kill Switch**: `planetary-defense-system`
- **WireGuard Interface**: `wormhole-tunnel`

### **Authentication**
- **Admin User**: `cooper` (main administrator)
- **Service Accounts**: `tars`, `case`, `kipp` (robot assistants)
- **Backup Codes**: `quantum-keys`

---

## 📊 **Monitoring & Maintenance**

### **Backup Locations**
- **Primary Backup**: `cooper-archives`
- **Offsite Backup**: `nasa-black-box`
- **Snapshot Names**: `mission-log-{date}`

### **Log Files**
- **Central Logs**: `mission-control.log`
- **Service Logs**: `{service-name}-mission.log`
- **Error Logs**: `anomaly-detection.log`

---

## 🎨 **Visual & Branding Elements**

### **Icons & Logos**
- **Server Icon**: Endurance spaceship silhouette
- **NAS Icon**: Gargantua black hole visualization
- **Service Icons**: Robot designs (TARS/CASE/KIPP)
- **Background**: Starfield with wormhole effect

### **Color Scheme**
- **Primary**: Deep space black (#0a0a0a)
- **Accent**: Cooper orange (#ff6b35)
- **Success**: Murph blue (#4a90e2)
- **Warning**: Wormhole purple (#9b59b6)

---

## 📝 **Implementation Guidelines**

### **When Adding New Services**
1. Find an Interstellar element that matches the service function
2. Use lowercase with hyphens for container names
3. Maintain the character/service association where possible
4. Update this document with new mappings

### **Naming Priority Order**
1. **Direct Character Names**: Cooper, Murph, TARS, etc.
2. **Movie Locations**: Planets (Miller, Mann, Edmunds)
3. **Sci-Fi Concepts**: Wormhole, Tesseract, Quantum
4. **Descriptive Compounds**: `cooper-station-plex`

### **Consistency Rules**
- All container names: lowercase with hyphens
- All directories: lowercase with hyphens
- All networks: end with `-net`
- All volumes: descriptive compound names
- All domains: subdomain of `cooperstation.stream`

---

## 🔄 **Migration Path**

If you're already running services with different names, here's the recommended migration approach:

1. **Phase 1**: Update domain configuration to `cooperstation.stream`
2. **Phase 2**: Rename Docker networks and volumes
3. **Phase 3**: Rename containers (requires service restart)
4. **Phase 4**: Update directory structure
5. **Phase 5**: Update documentation and scripts

---

## 📚 **Reference Materials**

### **Interstellar Elements Used**
- **Cooper**: Astronaut and mission commander
- **Murph**: Brilliant scientist daughter
- **TARS**: Sarcastic robot companion
- **CASE**: Analytical robot
- **KIPP**: Third robot assistant
- **Gargantua**: Supermassive black hole
- **Miller**: Extreme water planet
- **Mann**: Deceptive icy planet
- **Edmunds**: Potentially habitable planet
- **Tesseract**: 5-dimensional space construct
- **Wormhole**: Space-time shortcut
- **Endurance**: The spaceship

### **Why This Theme Works**
- **Cohesive**: All elements connect to the same story
- **Memorable**: Character-driven names are easy to remember
- **Functional**: Names reflect service purposes
- **Immersive**: Creates a unified sci-fi experience
- **Scalable**: Plenty of Interstellar elements for future expansion

---

*This naming convention transforms your technical infrastructure into an immersive Interstellar experience, where Cooper Station serves as mission control for your digital media exploration.* 🚀📺
