# Pocket Surf Architecture

## Overview

Pocket Surf is a self-contained mobile server running on a Raspberry Pi 5. It provides essential business services offline through a WiFi hotspot, with all applications running in Podman containers managed by systemd.

## System Layers

### 1. Hardware Layer
- **Raspberry Pi 5** (8 GB RAM)
- **M.2 SSD** via HAT for fast storage
- **PowerBank** (10,000 mAh) for mobile operation
- **WiFi** built-in for hotspot functionality

### 2. Operating System
- **Raspberry Pi OS** (Debian-based)
- Chosen for comprehensive Pi-specific tools and firmware management

### 3. Network Infrastructure (Host Services)

These run directly on the host OS for network access:

#### hostapd
- Creates WiFi access point "PocketSurf"
- WPA2 security
- Channel 7 (2.4 GHz)
- Configuration: `/etc/hostapd/hostapd.conf`
- Managed by: systemd (`hostapd.service`)

#### dnsmasq
- **DHCP Server**: Assigns IPs (192.168.4.10-50)
- **DNS Server**: Resolves `*.local` domains to 192.168.4.1
- Configuration: `/etc/dnsmasq.conf`
- Managed by: systemd (`dnsmasq.service`)

### 4. Application Layer (Containerized)

All applications run in a single Podman pod with shared network namespace.

#### Podman Pod
- **Pod Name**: `pocket-surf`
- **Network**: pasta (rootless networking)
- **Management**: systemd via quadlets
- **Auto-healing**: Health checks + automatic restarts

#### Services in Pod

**Home Dashboard** (port 3000)
- Technology: Rust + Actix Web + Maud + HTMX
- Purpose: Central dashboard and system configuration
- Features:
  - App launcher with service links
  - WiFi hotspot configuration
  - Settings management
  - Beautiful Apple-inspired UI
- Container: `pocket-surf-home`
- Volumes: Config files mounted for read/write

**Caddy Reverse Proxy** (ports 80, 443)
- Technology: Caddy 2
- Purpose: Routes domains to services
- Routing:
  - `home.local` → Dashboard (3000)
  - `files.local` → SFTPGo (8080)
  - `tasks.local` → Vikunja (3456)
  - `wiki.local` → BookStack (6875)
  - `chat.local` → Chat (8000)
- Container: `pocket-surf-caddy`

**SFTPGo** (port 8080, 2022)
- Technology: SFTPGo
- Purpose: File server with web UI and SFTP access
- Features:
  - Web-based file management
  - SFTP/FTP protocols
  - User management
  - Quota limits
- Container: `pocket-surf-sftpgo`

**Vikunja** (port 3456)
- Technology: Vikunja (API + Frontend)
- Purpose: Task and project management
- Features:
  - Kanban boards
  - Task lists
  - Deadlines and time tracking
  - SQLite database (offline-first)
- Containers: `pocket-surf-vikunja-api`, `pocket-surf-vikunja-frontend`

**BookStack** (port 6875)
- Technology: BookStack + MariaDB
- Purpose: Knowledge base and documentation
- Features:
  - Structured documentation (books/chapters/pages)
  - WYSIWYG editor
  - Search functionality
  - Version history
- Containers: `pocket-surf-bookstack`, `pocket-surf-bookstack-db`

**Local Chat** (port 8000)
- Technology: TBD (placeholder currently)
- Purpose: Local team messaging
- Features:
  - Real-time messaging
  - No internet dependency
  - File sharing
- Container: `pocket-surf-chat`

## Data Flow

### User Connection Flow
```
1. User connects to "PocketSurf" WiFi
2. hostapd authenticates user
3. dnsmasq assigns IP (192.168.4.x)
4. User navigates to home.local
5. dnsmasq resolves home.local → 192.168.4.1
6. Request hits Caddy on port 80
7. Caddy reverse proxies to home dashboard (3000)
8. User sees app launcher
```

### Configuration Management Flow
```
1. User opens WiFi settings in dashboard
2. Dashboard reads /config/hostapd.conf (mounted volume)
3. User updates SSID/password
4. Dashboard validates and writes to /config/hostapd.conf
5. Host file at /etc/hostapd/hostapd.conf updated (symlink)
6. User or system restarts hostapd service
7. New WiFi settings active
```

## Deployment Model

### Container Management
- **Podman quadlets**: Systemd-native container definitions
- **Location**: `/etc/containers/systemd/`
- **Format**: `.container` and `.pod` files
- **Benefits**:
  - Native systemd integration
  - Auto-restart on failure
  - Health checking
  - Dependency management
  - Journal logging

### Volume Strategy
- **Named volumes**: For persistent data (databases, files)
- **Bind mounts**: For configuration files
- **Shared pod network**: All containers on `localhost` within pod

### Auto-Healing
Each container includes:
- Health check command
- Health check interval (30s)
- Automatic restart on failure
- Exponential backoff (RestartSec=10s)

## File Structure

```
pocket-surf/
├── app-home/                    # Home dashboard application
│   ├── src/
│   │   ├── main.rs             # Actix web server
│   │   ├── routes.rs           # HTTP routes
│   │   ├── templates.rs        # Maud HTML templates
│   │   ├── config.rs           # Config file management
│   │   └── styles.css          # CSS styling
│   ├── Dockerfile              # Container build definition
│   ├── Cargo.toml              # Rust dependencies
│   └── README.md
│
├── server-config/               # System configuration
│   ├── quadlets/               # Podman systemd units
│   │   ├── pocket-surf.pod
│   │   ├── pocket-surf-home.container
│   │   ├── pocket-surf-caddy.container
│   │   ├── pocket-surf-sftpgo.container
│   │   ├── pocket-surf-vikunja-*.container
│   │   ├── pocket-surf-bookstack*.container
│   │   └── pocket-surf-chat.container
│   ├── hostapd.conf            # WiFi AP configuration
│   ├── dnsmasq.conf            # DHCP/DNS configuration
│   ├── Caddyfile               # Reverse proxy routing
│   ├── install-podman.sh       # Installation script
│   └── README.md
│
├── documentation.typ            # Project documentation (Typst)
├── presentation.typ             # Presentation slides (Typst)
└── ARCHITECTURE.md              # This file
```

## Security Considerations

1. **Network Isolation**: Services isolated in pod
2. **Non-root containers**: All containers run as non-root users
3. **WPA2 encryption**: WiFi traffic encrypted
4. **Local-only**: No external internet exposure required
5. **Config file permissions**: Proper ownership and permissions
6. **Health monitoring**: Failed services detected and restarted

## Offline-First Design

All services are designed to work without internet:
- **SQLite databases**: No external DB server needed
- **Embedded frontends**: No CDN dependencies
- **Local authentication**: No external auth providers
- **Self-contained**: All assets bundled

## Performance Considerations

- **Low memory footprint**: Rust + Alpine containers
- **Efficient reverse proxy**: Caddy with minimal overhead
- **SSD storage**: Fast read/write operations
- **Compiled binaries**: app-home is pre-compiled Rust
- **Pod networking**: Shared network namespace reduces overhead

## Maintenance

### Updating Services
```bash
# Pull new image
podman pull docker.io/library/caddy:2-alpine

# Restart service (systemd pulls new image)
systemctl restart pocket-surf-caddy.service
```

### Viewing Logs
```bash
# Specific service
journalctl -u pocket-surf-home.service -f

# All pod services
journalctl -u 'pocket-surf-*' -f

# Host services
journalctl -u hostapd -u dnsmasq -f
```

### Backup
Important data volumes:
- `vikunja-files` - Tasks and projects
- `bookstack-config` - Wiki content
- `bookstack-db-data` - Wiki database
- `sftpgo-data` - User files

```bash
# Backup volumes
podman volume export vikunja-files > vikunja-backup.tar
```

## Future Enhancements

1. **Chat Implementation**: Replace placeholder with actual chat service (e.g., Zulip, Mattermost)
2. **Backup Automation**: Scheduled backups to external storage
3. **VPN Integration**: WireGuard for remote access
4. **Monitoring Dashboard**: Resource usage graphs in home dashboard
5. **Service Status**: Real-time service health in dashboard
6. **Mobile App**: Native mobile apps for iOS/Android
