# Server Configuration Files

Configuration files for the Pocket Surf mobile server network stack.

## Architecture

Pocket Surf uses a hybrid approach:
- **Host Services**: hostapd and dnsmasq run directly on the host for network infrastructure
- **Application Services**: All apps run in Podman containers managed by systemd

## Network Architecture

```
Client Device
    |
    | WiFi: PocketSurf
    |
[Raspberry Pi - 192.168.4.1]
    |
    +-- hostapd (WiFi AP) [Host]
    +-- dnsmasq (DHCP + DNS) [Host]
    |       |
    |       +-- Assigns IPs: 192.168.4.10-50
    |       +-- Resolves *.local to 192.168.4.1
    |
    +-- Podman Pod (systemd-managed)
            |
            +-- Caddy (Reverse Proxy :80/:443)
            +-- Home Dashboard (:3000)
            +-- SFTPGo (:8080)
            +-- Vikunja (:3456)
            +-- BookStack (:6875)
            +-- Chat (:8000)
```

## Files

### Host Configuration
- `hostapd.conf` - WiFi hotspot configuration (managed by app-home)
- `dnsmasq.conf` - DHCP and DNS with local domain rewrites
- `install.sh` - Legacy installation script
- `install-podman.sh` - **Podman installation script** (recommended)

### Container Configuration
- `Caddyfile` - Reverse proxy routing
- `quadlets/*.pod` - Podman pod definition
- `quadlets/*.container` - Systemd-managed container definitions

## Service Management

All services are managed by systemd via Podman quadlets:

### Pod Management
```bash
# Start/stop all services
sudo systemctl start pocket-surf.pod.service
sudo systemctl stop pocket-surf.pod.service

# View pod status
podman pod ps
podman ps --pod
```

### Individual Services
```bash
# Check service status
systemctl status pocket-surf-home.service
systemctl status pocket-surf-caddy.service

# View logs
journalctl -u pocket-surf-home.service -f

# Restart a service
systemctl restart pocket-surf-home.service
```

### Host Services
```bash
# WiFi and DNS
systemctl status hostapd
systemctl status dnsmasq
systemctl restart hostapd
```

## Service Ports

| Service | Port | Domain | Type |
|---------|------|--------|------|
| Home Dashboard | 3000 | home.local | Container |
| SFTPGo | 8080 | files.local | Container |
| Vikunja | 3456 | tasks.local | Container |
| BookStack | 6875 | wiki.local | Container |
| Chat | 8000 | chat.local | Container |
| Caddy | 80/443 | * | Container |

## Auto-Healing

All containers include:
- **Health checks**: Periodic checks to ensure service is responding
- **Auto-restart**: Containers restart automatically on failure
- **Systemd integration**: Full systemd lifecycle management
- **Dependency management**: Services start in correct order

## Installation

Run the Podman installation script:
```bash
sudo ./install-podman.sh
```

This will:
1. Install hostapd, dnsmasq, and podman
2. Configure WiFi hotspot
3. Deploy systemd quadlets
4. Build app-home container
5. Start all services
