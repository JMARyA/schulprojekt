#!/bin/bash
# Quick fix script for dnsmasq timeout issues
# Run as root: sudo bash fix-dnsmasq.sh

set -e

echo "=== Pocket Surf - dnsmasq Fix ==="
echo ""

if [ "$EUID" -ne 0 ]; then
    echo "Please run as root (sudo bash fix-dnsmasq.sh)"
    exit 1
fi

# Stop services first
echo "[1/4] Stopping services..."
systemctl stop dnsmasq || true
systemctl stop hostapd || true

# Disable systemd-resolved if it's running
echo "[2/4] Checking for systemd-resolved conflicts..."
if systemctl is-active --quiet systemd-resolved; then
    echo "    Found systemd-resolved - this conflicts with dnsmasq on port 53"
    echo "    Disabling systemd-resolved..."
    systemctl stop systemd-resolved
    systemctl disable systemd-resolved
    rm -f /etc/resolv.conf
    echo "nameserver 127.0.0.1" > /etc/resolv.conf
    echo "    systemd-resolved disabled"
else
    echo "    systemd-resolved not running - good!"
fi

# Update dnsmasq systemd override with proper dependencies
echo "[3/4] Updating dnsmasq service configuration..."
mkdir -p /etc/systemd/system/dnsmasq.service.d
cat > /etc/systemd/system/dnsmasq.service.d/pocket-surf.conf << 'EOF'
[Unit]
After=dhcpcd.service
Wants=dhcpcd.service

[Service]
ExecStart=
ExecStart=/usr/sbin/dnsmasq --keep-in-foreground --conf-file=/etc/pocket-surf/dnsmasq.conf
Restart=on-failure
RestartSec=5
EOF

# Restart services in correct order
echo "[4/4] Restarting services..."
systemctl daemon-reload
systemctl restart dhcpcd
sleep 2
systemctl restart hostapd
sleep 2
systemctl restart dnsmasq

# Check status
echo ""
echo "=== Service Status ==="
echo ""
echo "hostapd:"
systemctl is-active hostapd && echo "  ✓ Running" || echo "  ✗ Failed"
echo ""
echo "dnsmasq:"
systemctl is-active dnsmasq && echo "  ✓ Running" || echo "  ✗ Failed"
echo ""

# Show recent logs if dnsmasq failed
if ! systemctl is-active --quiet dnsmasq; then
    echo "dnsmasq failed to start. Recent logs:"
    journalctl -u dnsmasq -n 20 --no-pager
    exit 1
fi

echo "=== Fix Complete ==="
echo ""
echo "dnsmasq should now be running properly!"
echo "You can verify with: systemctl status dnsmasq"
