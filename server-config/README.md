# Server Configuration Files

Configuration files for the Pocket Surf mobile server network stack.

## Network Architecture

```
Client Device
    |
    | WiFi: PocketSurf
    |
[Raspberry Pi - 192.168.4.1]
    |
    +-- hostapd (WiFi AP)
    +-- dnsmasq (DHCP + DNS)
    |       |
    |       +-- Assigns IPs: 192.168.4.10-50
    |       +-- Resolves *.local to 192.168.4.1
    |
    +-- Caddy (Reverse Proxy :80/:443)
            |
            +-- home.local → :3000
            +-- files.local → :8080
            +-- tasks.local → :3456
            +-- wiki.local → :6875
            +-- chat.local → :8000
```

## Files

- `hostapd.conf` - WiFi hotspot configuration
- `dnsmasq.conf` - DHCP and DNS with local domain rewrites
- `Caddyfile` - Reverse proxy routing
- `install.sh` - Installation script

## Service Ports

| Service | Port | Domain |
|---------|------|--------|
| Home Dashboard | 3000 | home.local |
| SFTPGo | 8080 | files.local |
| Vikunja | 3456 | tasks.local |
| BookStack | 6875 | wiki.local |
| Local Chat | 8000 | chat.local |
