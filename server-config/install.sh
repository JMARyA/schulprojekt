#!/bin/bash
# Pocket Surf - Installation Script
# Installs all system dependencies, builds custom apps, and activates all services.
# Must be run as root from the server-config/ directory.

set -e

echo "=== Pocket Surf Installation ==="
echo ""

if [ "$EUID" -ne 0 ]; then
    echo "Please run as root (sudo bash install.sh)"
    exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ---------------------------------------------------------------------------
# [1/8] Install system packages
# ---------------------------------------------------------------------------
echo "[1/8] Installing required packages..."
apt update
apt install -y hostapd dnsmasq podman build-essential pkg-config libssl-dev curl
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
export PATH="$HOME/.cargo/bin:$PATH"

# ---------------------------------------------------------------------------
# [2/8] Configure static IP on wlan0
# ---------------------------------------------------------------------------
echo "[2/8] Configuring static IP for wlan0..."
if ! grep -q "interface wlan0" /etc/dhcpcd.conf; then
    cat >> /etc/dhcpcd.conf << 'EOF'

# Pocket Surf - Static IP for WiFi AP
interface wlan0
    static ip_address=192.168.4.1/24
    nohook wpa_supplicant
EOF
fi

# ---------------------------------------------------------------------------
# [3/8] Deploy configuration files to /etc/pocket-surf/
# ---------------------------------------------------------------------------
echo "[3/8] Deploying configuration files..."
mkdir -p /etc/pocket-surf

# Copy initial hostapd.conf if it doesn't exist (app will manage it)
if [ ! -f /etc/pocket-surf/hostapd.conf ]; then
    cp "$SCRIPT_DIR/hostapd.conf" /etc/pocket-surf/hostapd.conf
    echo "    Installed initial hostapd.conf (app-managed)"
fi

cp "$SCRIPT_DIR/dnsmasq.conf"  /etc/pocket-surf/dnsmasq.conf
cp "$SCRIPT_DIR/Caddyfile"     /etc/pocket-surf/Caddyfile

# Point hostapd to app-managed config file
if ! grep -q "^DAEMON_CONF=" /etc/default/hostapd; then
    sed -i 's|#DAEMON_CONF=""|DAEMON_CONF="/etc/pocket-surf/hostapd.conf"|' /etc/default/hostapd
else
    sed -i 's|^DAEMON_CONF=.*|DAEMON_CONF="/etc/pocket-surf/hostapd.conf"|' /etc/default/hostapd
fi
echo "    hostapd configured to use /etc/pocket-surf/hostapd.conf"

# Override dnsmasq to use our config file instead of /etc/dnsmasq.conf
mkdir -p /etc/systemd/system/dnsmasq.service.d
cat > /etc/systemd/system/dnsmasq.service.d/pocket-surf.conf << 'EOF'
[Service]
ExecStart=
ExecStart=/usr/sbin/dnsmasq --keep-in-foreground --conf-file=/etc/pocket-surf/dnsmasq.conf
EOF

# ---------------------------------------------------------------------------
# [4/8] Enable IP forwarding
# ---------------------------------------------------------------------------
echo "[4/8] Enabling IP forwarding..."
echo "net.ipv4.ip_forward = 1" | sudo tee /etc/sysctl.d/99-ipforward.conf
sysctl -p

# ---------------------------------------------------------------------------
# [5/8] Build and install the Home Dashboard (Rust, runs natively)
# ---------------------------------------------------------------------------
echo "[5/8] Building Home Dashboard..."
cd "$SCRIPT_DIR/../app-home"
cargo build --release
install -m 755 target/release/pocket-surf-home /usr/local/bin/pocket-surf-home
cd "$SCRIPT_DIR"

cp "$SCRIPT_DIR/pocket-surf-home.service" /etc/systemd/system/pocket-surf-home.service

# ---------------------------------------------------------------------------
# [6/8] Enable and start host-level services
# ---------------------------------------------------------------------------
echo "[6/8] Enabling host services..."
systemctl daemon-reload
systemctl unmask hostapd
systemctl enable hostapd dnsmasq pocket-surf-home
systemctl restart dhcpcd
systemctl restart hostapd
systemctl restart dnsmasq
systemctl restart pocket-surf-home

# ---------------------------------------------------------------------------
# [7/8] Build chat container image and install Podman quadlets
# ---------------------------------------------------------------------------

# TODO : Integrate ; Not Avail Right Now

#echo "[7/8] Building Chat container image..."
#cd "$SCRIPT_DIR/../app-chat"
#podman build -t localhost/pocket-surf-chat:latest .
#cd "$SCRIPT_DIR"

echo "      Installing Podman quadlets..."
mkdir -p /etc/containers/systemd
cp "$SCRIPT_DIR/quadlets/"*.pod       /etc/containers/systemd/
cp "$SCRIPT_DIR/quadlets/"*.container /etc/containers/systemd/

# ---------------------------------------------------------------------------
# [8/8] Start container services via systemd
# ---------------------------------------------------------------------------
echo "[8/8] Starting container services..."
systemctl daemon-reload
systemctl enable --now pocket-surf.pod.service

sleep 5

for service_file in /etc/containers/systemd/pocket-surf-*.container; do
    service_name="$(basename "$service_file" .container).service"
    echo "  Starting $service_name..."
    systemctl enable --now "$service_name"
done

echo ""
echo "=== Installation Complete ==="
echo ""
echo "WiFi:      PocketSurf  /  PocketSurf2026"
echo "Server IP: 192.168.4.1"
echo ""
echo "  home.local   Home Dashboard"
echo "  files.local  File Server (SFTPGo)"
echo "  tasks.local  Task Manager (Vikunja)"
echo "  wiki.local   Knowledge Base (BookStack)"
echo "  chat.local   Chat"
echo ""
echo "Status:"
echo "  systemctl status pocket-surf-home"
echo "  podman ps --pod"
