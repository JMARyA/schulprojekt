use actix_web::{web, HttpResponse, Result};
use serde::Deserialize;

use crate::config::WifiConfig;
use crate::templates;

/// Home page
pub async fn index() -> Result<HttpResponse> {
    let html = templates::home_page();
    Ok(HttpResponse::Ok().content_type("text/html").body(html.into_string()))
}

/// WiFi settings page
pub async fn wifi_settings() -> Result<HttpResponse> {
    match WifiConfig::read() {
        Ok(config) => {
            let html = templates::wifi_settings(&config);
            Ok(HttpResponse::Ok().content_type("text/html").body(html.into_string()))
        }
        Err(e) => {
            log::error!("Failed to read WiFi config: {}", e);
            let html = templates::error_message(&format!("Fehler beim Laden der Konfiguration: {}", e));
            Ok(HttpResponse::InternalServerError().content_type("text/html").body(html.into_string()))
        }
    }
}

#[derive(Deserialize)]
pub struct WifiUpdateForm {
    ssid: String,
    password: String,
    channel: u8,
}

/// Update WiFi configuration
pub async fn update_wifi(form: web::Form<WifiUpdateForm>) -> Result<HttpResponse> {
    let mut config = WifiConfig::read().unwrap_or_default();

    config.ssid = form.ssid.clone();
    config.password = form.password.clone();
    config.channel = form.channel;

    // Validate configuration
    if let Err(e) = config.validate() {
        log::warn!("Invalid WiFi config: {}", e);
        let html = templates::error_message(&e);
        return Ok(HttpResponse::BadRequest().content_type("text/html").body(html.into_string()));
    }

    // Write configuration
    match config.write() {
        Ok(_) => {
            log::info!("WiFi configuration updated successfully");

            // TODO: Restart hostapd service
            // This requires root privileges or proper systemd integration
            // For now, just show success message

            let html = templates::success_message(
                "Konfiguration gespeichert! Starten Sie den WiFi-Dienst neu, um die Änderungen zu übernehmen."
            );
            Ok(HttpResponse::Ok().content_type("text/html").body(html.into_string()))
        }
        Err(e) => {
            log::error!("Failed to write WiFi config: {}", e);
            let html = templates::error_message(&format!("Fehler beim Speichern: {}", e));
            Ok(HttpResponse::InternalServerError().content_type("text/html").body(html.into_string()))
        }
    }
}

/// Settings overview page
pub async fn settings() -> Result<HttpResponse> {
    let html = templates::settings_page();
    Ok(HttpResponse::Ok().content_type("text/html").body(html.into_string()))
}

/// System settings page (placeholder)
pub async fn system_settings() -> Result<HttpResponse> {
    let html = templates::base("System Einstellungen", maud::html! {
        nav class="navbar" {
            div class="nav-content" {
                a href="/settings" class="back-link" { "← Einstellungen" }
                div class="nav-logo" { "⚙️ System" }
            }
        }
        div class="background" {}
        div class="content-wrapper" {
            main class="settings-main" {
                div class="wifi-form" {
                    p { "Noch in Entwicklung..." }
                }
            }
        }
    });
    Ok(HttpResponse::Ok().content_type("text/html").body(html.into_string()))
}

/// About page
pub async fn about() -> Result<HttpResponse> {
    let html = templates::base("Über Pocket Surf", maud::html! {
        nav class="navbar" {
            div class="nav-content" {
                a href="/" class="back-link" { "← Zurück" }
                div class="nav-logo" { "ℹ️ Über" }
            }
        }
        div class="background" {}
        div class="content-wrapper" {
            main class="settings-main" {
                div class="wifi-form" {
                    h2 { "Pocket Surf" }
                    p { "Mobiler Server für Unterwegs" }
                    br;
                    p { strong { "Version: " } "0.1.0" }
                    p { strong { "Hardware: " } "Raspberry Pi 5 (8 GB RAM)" }
                    p { strong { "OS: " } "Raspberry Pi OS" }
                    br;
                    p style="color: var(--text-light)" {
                        "Schulprojekt Berufsschule Lauingen 2026"
                    }
                    p style="color: var(--text-light); font-size: 0.9rem" {
                        "Erion Sahitaj • Angelo Rodriguez • Matthias Holme"
                    }
                }
            }
        }
    });
    Ok(HttpResponse::Ok().content_type("text/html").body(html.into_string()))
}
