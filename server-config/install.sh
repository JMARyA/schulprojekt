#!/bin/bash
# Pocket Surf - Network Stack Installation Script
# Installs and configures WiFi hotspot, DNS, and reverse proxy

set -e  # Exit on error

echo "=== Pocket Surf Network Stack Installation ==="
echo ""

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root (use sudo)"
    exit 1
fi

# Update package lists
echo "[1/6] Updating package lists..."
apt update

# Install required packages
echo "[2/6] Installing hostapd, dnsmasq, and caddy..."
apt install -y hostapd dnsmasq

# Install Caddy (from official repository)
if ! command -v caddy &> /dev/null; then
    apt install -y debian-keyring debian-archive-keyring apt-transport-https curl
    curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg
    curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | tee /etc/apt/sources.list.d/caddy-stable.list
    apt update
    apt install -y caddy
fi

# Configure static IP for wlan0
echo "[3/6] Configuring static IP for wlan0..."
if ! grep -q "interface wlan0" /etc/dhcpcd.conf; then
    cat >> /etc/dhcpcd.conf << EOF

# Pocket Surf - Static IP for WiFi AP
interface wlan0
    static ip_address=192.168.4.1/24
    nohook wpa_supplicant
EOF
fi

# Deploy configuration files
echo "[4/6] Deploying configuration files..."
cp hostapd.conf /etc/hostapd/hostapd.conf
cp dnsmasq.conf /etc/dnsmasq.conf
cp Caddyfile /etc/caddy/Caddyfile

# Set hostapd config location
sed -i 's|#DAEMON_CONF=""|DAEMON_CONF="/etc/hostapd/hostapd.conf"|' /etc/default/hostapd

# Create Caddy log directory
mkdir -p /var/log/caddy
chown caddy:caddy /var/log/caddy

# Enable IP forwarding (for potential internet sharing)
echo "[5/6] Enabling IP forwarding..."
sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/' /etc/sysctl.conf
sysctl -p

# Enable and start services
echo "[6/6] Enabling and starting services..."
systemctl unmask hostapd
systemctl enable hostapd
systemctl enable dnsmasq
systemctl enable caddy

# Reload dhcpcd for static IP
systemctl restart dhcpcd

# Start services
systemctl restart hostapd
systemctl restart dnsmasq
systemctl restart caddy

echo ""
echo "=== Installation Complete ==="
echo ""
echo "WiFi Network: PocketSurf"
echo "Password: PocketSurf2026"
echo "Server IP: 192.168.4.1"
echo ""
echo "Services:"
echo "  - home.local (Dashboard)"
echo "  - files.local (File Server)"
echo "  - tasks.local (Task Manager)"
echo "  - wiki.local (Knowledge Base)"
echo "  - chat.local (Chat)"
echo ""
echo "Check service status:"
echo "  sudo systemctl status hostapd"
echo "  sudo systemctl status dnsmasq"
echo "  sudo systemctl status caddy"
