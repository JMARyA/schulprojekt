use serde::{Deserialize, Serialize};
use std::fs;
use std::io::{self, BufRead, BufReader, Write};
use std::path::Path;

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct WifiConfig {
    pub ssid: String,
    pub password: String,
    pub channel: u8,
    pub country_code: String,
}

impl Default for WifiConfig {
    fn default() -> Self {
        Self {
            ssid: "PocketSurf".to_string(),
            password: "PocketSurf2026".to_string(),
            channel: 7,
            country_code: "DE".to_string(),
        }
    }
}

impl WifiConfig {
    /// Get the path to hostapd.conf from environment or use default
    fn get_hostapd_path() -> String {
        std::env::var("CONFIG_PATH")
            .map(|p| format!("{}/hostapd.conf", p))
            .unwrap_or_else(|_| "/config/hostapd.conf".to_string())
    }

    /// Read current WiFi configuration from hostapd.conf
    pub fn read() -> io::Result<Self> {
        let path_str = Self::get_hostapd_path();
        let path = Path::new(&path_str);

        if !path.exists() {
            return Ok(Self::default());
        }

        let file = fs::File::open(path)?;
        let reader = BufReader::new(file);

        let mut config = Self::default();

        for line in reader.lines() {
            let line = line?;
            let line = line.trim();

            // Skip comments and empty lines
            if line.starts_with('#') || line.is_empty() {
                continue;
            }

            if let Some((key, value)) = line.split_once('=') {
                match key.trim() {
                    "ssid" => config.ssid = value.trim().to_string(),
                    "wpa_passphrase" => config.password = value.trim().to_string(),
                    "channel" => {
                        if let Ok(ch) = value.trim().parse() {
                            config.channel = ch;
                        }
                    }
                    "country_code" => config.country_code = value.trim().to_string(),
                    _ => {}
                }
            }
        }

        Ok(config)
    }

    /// Write WiFi configuration to hostapd.conf
    pub fn write(&self) -> io::Result<()> {
        let content = self.generate_hostapd_conf();
        let path = Self::get_hostapd_path();

        // Write to temp file first, then move
        let temp_path = format!("{}.tmp", path);
        fs::write(&temp_path, content)?;
        fs::rename(&temp_path, &path)?;

        Ok(())
    }

    /// Generate hostapd.conf content
    fn generate_hostapd_conf(&self) -> String {
        format!(
r#"# hostapd configuration for Pocket Surf WiFi Hotspot
# This creates a WiFi access point on the Raspberry Pi
# Managed by Pocket Surf Home App

# Interface to use for the AP
interface=wlan0

# Driver interface type
driver=nl80211

# SSID (Network Name)
ssid={}

# Hardware mode: g = 2.4GHz
hw_mode=g

# Channel to use (1-11 for 2.4GHz)
channel={}

# Enable 802.11n
ieee80211n=1

# QoS support
wmm_enabled=1

# Country code (adjust for your location)
country_code={}

# Authentication algorithm
auth_algs=1

# WPA/WPA2 security
wpa=2
wpa_key_mgmt=WPA-PSK
rsn_pairwise=CCMP

# WiFi password
wpa_passphrase={}

# Logging
logger_syslog=-1
logger_syslog_level=2
logger_stdout=-1
logger_stdout_level=2
"#,
            self.ssid,
            self.channel,
            self.country_code,
            self.password
        )
    }

    /// Validate configuration
    pub fn validate(&self) -> Result<(), String> {
        if self.ssid.is_empty() {
            return Err("SSID darf nicht leer sein".to_string());
        }

        if self.ssid.len() > 32 {
            return Err("SSID darf maximal 32 Zeichen lang sein".to_string());
        }

        if self.password.len() < 8 {
            return Err("Passwort muss mindestens 8 Zeichen lang sein".to_string());
        }

        if self.password.len() > 63 {
            return Err("Passwort darf maximal 63 Zeichen lang sein".to_string());
        }

        if !(1..=11).contains(&self.channel) {
            return Err("Kanal muss zwischen 1 und 11 liegen".to_string());
        }

        Ok(())
    }
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct SystemStatus {
    pub cpu_usage: f32,
    pub ram_used: u64,
    pub ram_total: u64,
    pub disk_used: u64,
    pub disk_total: u64,
}

impl SystemStatus {
    pub fn get() -> io::Result<Self> {
        // Read CPU usage from /proc/stat
        let cpu_usage = Self::read_cpu_usage()?;

        // Read memory info from /proc/meminfo
        let (ram_total, ram_used) = Self::read_memory()?;

        // Read disk usage
        let (disk_total, disk_used) = Self::read_disk_usage()?;

        Ok(Self {
            cpu_usage,
            ram_used,
            ram_total,
            disk_used,
            disk_total,
        })
    }

    fn read_cpu_usage() -> io::Result<f32> {
        // Simplified CPU usage - in production you'd want to calculate delta
        let stat = fs::read_to_string("/proc/stat")?;
        let first_line = stat.lines().next().unwrap_or("");

        if let Some(cpu_line) = first_line.strip_prefix("cpu  ") {
            let values: Vec<u64> = cpu_line
                .split_whitespace()
                .filter_map(|s| s.parse().ok())
                .collect();

            if values.len() >= 4 {
                let idle = values[3];
                let total: u64 = values.iter().sum();
                let usage = 100.0 - (idle as f32 / total as f32 * 100.0);
                return Ok(usage);
            }
        }

        Ok(0.0)
    }

    fn read_memory() -> io::Result<(u64, u64)> {
        let meminfo = fs::read_to_string("/proc/meminfo")?;
        let mut mem_total = 0u64;
        let mut mem_available = 0u64;

        for line in meminfo.lines() {
            if let Some(value) = line.strip_prefix("MemTotal:") {
                mem_total = value.trim().split_whitespace().next()
                    .and_then(|s| s.parse().ok())
                    .unwrap_or(0) * 1024; // Convert KB to bytes
            } else if let Some(value) = line.strip_prefix("MemAvailable:") {
                mem_available = value.trim().split_whitespace().next()
                    .and_then(|s| s.parse().ok())
                    .unwrap_or(0) * 1024;
            }
        }

        let mem_used = mem_total.saturating_sub(mem_available);
        Ok((mem_total, mem_used))
    }

    fn read_disk_usage() -> io::Result<(u64, u64)> {
        // Read from statvfs for root filesystem
        // For now, return placeholder values
        // In production, use nix or libc bindings for statvfs
        Ok((256 * 1024 * 1024 * 1024, 64 * 1024 * 1024 * 1024)) // 256GB total, 64GB used
    }
}
