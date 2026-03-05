#!/bin/bash
# Pocket Surf - Podman Quadlets Installation Script
# Installs and configures all services using systemd-managed Podman containers

set -e  # Exit on error

echo "=== Pocket Surf Podman Installation ==="
echo ""

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root (use sudo)"
    exit 1
fi

# Update package lists
echo "[1/8] Updating package lists..."
apt update

# Install required packages
echo "[2/8] Installing hostapd, dnsmasq, and podman..."
apt install -y hostapd dnsmasq podman

# Configure static IP for wlan0
echo "[3/8] Configuring static IP for wlan0..."
if ! grep -q "interface wlan0" /etc/dhcpcd.conf; then
    cat >> /etc/dhcpcd.conf << EOF

# Pocket Surf - Static IP for WiFi AP
interface wlan0
    static ip_address=192.168.4.1/24
    nohook wpa_supplicant
EOF
fi

# Deploy host-level configuration files
echo "[4/8] Deploying host configuration files..."
cp hostapd.conf /etc/hostapd/hostapd.conf
cp dnsmasq.conf /etc/dnsmasq.conf

# Set hostapd config location
sed -i 's|#DAEMON_CONF=""|DAEMON_CONF="/etc/hostapd/hostapd.conf"|' /etc/default/hostapd

# Enable IP forwarding
echo "[5/8] Enabling IP forwarding..."
sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/' /etc/sysctl.conf
sysctl -p

# Enable and start host services
echo "[6/8] Enabling host services..."
systemctl unmask hostapd
systemctl enable hostapd
systemctl enable dnsmasq
systemctl restart dhcpcd
systemctl restart hostapd
systemctl restart dnsmasq

# Setup Podman quadlets
echo "[7/8] Setting up Podman quadlets..."

# Create systemd directory for user quadlets
mkdir -p /etc/containers/systemd

# Copy quadlet files
cp quadlets/*.pod /etc/containers/systemd/
cp quadlets/*.container /etc/containers/systemd/

# Create config directory for containers
mkdir -p /etc/pocket-surf
cp Caddyfile /etc/pocket-surf/
# Create symlinks to the actual config files containers can access
ln -sf /etc/hostapd/hostapd.conf /etc/pocket-surf/hostapd.conf
ln -sf /etc/dnsmasq.conf /etc/pocket-surf/dnsmasq.conf

# Build app-home image
echo "[8/8] Building app-home container image..."
cd ../app-home
podman build -t localhost/pocket-surf-home:latest .
cd ../server-config

# Reload systemd to pick up quadlets
echo "Reloading systemd daemon..."
systemctl daemon-reload

# Enable and start the pod and all services
echo "Starting Pocket Surf services..."
systemctl enable --now pocket-surf.pod.service

# Wait a moment for pod to start
sleep 5

# Start all container services
for service in /etc/containers/systemd/pocket-surf-*.container; do
    service_name=$(basename "$service" .container).service
    echo "Enabling and starting $service_name..."
    systemctl enable --now "$service_name"
done

echo ""
echo "=== Installation Complete ==="
echo ""
echo "WiFi Network: PocketSurf"
echo "Password: PocketSurf2026"
echo "Server IP: 192.168.4.1"
echo ""
echo "Services (accessible via Caddy):"
echo "  - home.local (Dashboard)"
echo "  - files.local (File Server)"
echo "  - tasks.local (Task Manager)"
echo "  - wiki.local (Knowledge Base)"
echo "  - chat.local (Chat)"
echo ""
echo "Check pod status:"
echo "  systemctl status pocket-surf.pod.service"
echo ""
echo "Check service status:"
echo "  podman ps --pod"
echo ""
echo "View logs:"
echo "  journalctl -u pocket-surf-home.service -f"
