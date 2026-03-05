# Pocket Surf Home Dashboard

Central dashboard and configuration interface for the Pocket Surf mobile server.

## Features

- **Home Screen**: Quick access to all services via beautiful app cards
- **Apple-Inspired Design**: Clean, minimal interface with frosted glass effects
- **WiFi Configuration**: Manage hotspot settings (SSID, password, channel)
- **Settings Management**: Dedicated settings page accessible via dropdown menu
- **Smooth Animations**: Polished hover effects and transitions
- **Responsive Design**: Works perfectly on desktop and mobile devices
- **Background Images**: Beautiful Unsplash photography

## Tech Stack

- **Rust** - Safe, fast backend
- **Actix Web** - High-performance web framework
- **Maud** - Compile-time checked HTML templates
- **HTMX** - Dynamic HTML without complex JS frameworks

## Development

```bash
# Build
cargo build

# Run development server
cargo run

# Build optimized release binary
cargo build --release
```

The application runs on port 3000 and is accessible via `home.local` when routed through Caddy.

## Configuration Management

The app reads and updates configuration files mounted from the host:
- `/config/hostapd.conf` - WiFi hotspot configuration (via volume mount)
- `/config/dnsmasq.conf` - DNS/DHCP configuration

Configuration files are mounted from `/etc/pocket-surf/` on the host system.

Changes to WiFi settings update the host files and require restarting `hostapd`:
```bash
sudo systemctl restart hostapd
```

## Container Deployment

### Build Container Image
```bash
podman build -t localhost/pocket-surf-home:latest .
```

### Run Standalone (for testing)
```bash
podman run -d \
  --name pocket-surf-home \
  -p 3000:3000 \
  -v /etc/pocket-surf/hostapd.conf:/config/hostapd.conf:Z \
  -v /etc/pocket-surf/dnsmasq.conf:/config/dnsmasq.conf:Z \
  localhost/pocket-surf-home:latest
```

### Production Deployment

The app is deployed via systemd Podman quadlets. See `../server-config/quadlets/pocket-surf-home.container`.

Install the full stack:
```bash
cd ../server-config
sudo ./install-podman.sh
```

Manage the service:
```bash
# Check status
systemctl status pocket-surf-home.service

# View logs
journalctl -u pocket-surf-home.service -f

# Restart
systemctl restart pocket-surf-home.service
```
