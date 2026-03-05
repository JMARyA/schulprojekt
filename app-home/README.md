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

The app reads and updates configuration files in `../server-config/`:
- `hostapd.conf` - WiFi hotspot configuration

Changes to WiFi settings require restarting the `hostapd` service (requires root privileges).

## Production Deployment

```bash
# Build release binary
cargo build --release

# Copy binary to /usr/local/bin
sudo cp target/release/pocket-surf-home /usr/local/bin/

# Create systemd service (see systemd/ directory)
sudo systemctl enable pocket-surf-home
sudo systemctl start pocket-surf-home
```
