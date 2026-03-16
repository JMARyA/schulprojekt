use actix_web::{web, HttpResponse, Result};
use actix_session::Session;
use serde::Deserialize;

use crate::config::{WifiConfig, AuthConfig};
use crate::templates;

/// Check if user is authenticated
fn is_authenticated(session: &Session) -> bool {
    session.get::<bool>("authenticated").unwrap_or(Some(false)).unwrap_or(false)
}

/// Redirect to login if not authenticated
fn require_auth(session: &Session) -> Option<HttpResponse> {
    if !is_authenticated(session) {
        Some(HttpResponse::Found()
            .append_header(("Location", "/login"))
            .finish())
    } else {
        None
    }
}

/// Home page
pub async fn index() -> Result<HttpResponse> {
    let html = templates::home_page();
    Ok(HttpResponse::Ok().content_type("text/html").body(html.into_string()))
}

/// WiFi settings page
pub async fn wifi_settings(session: Session) -> Result<HttpResponse> {
    if let Some(redirect) = require_auth(&session) {
        return Ok(redirect);
    }

    match WifiConfig::read() {
        Ok(config) => {
            let html = templates::wifi_settings(&config);
            Ok(HttpResponse::Ok().content_type("text/html").body(html.into_string()))
        }
        Err(e) => {
            log::error!("Failed to read WiFi config: {}", e);
            let msg = format!("Fehler beim Laden der Konfiguration: {}", e);
            let config = WifiConfig::default();
            let html = templates::wifi_settings_with_message(&config, Some((&msg, false)));
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
pub async fn update_wifi(session: Session, form: web::Form<WifiUpdateForm>) -> Result<HttpResponse> {
    if let Some(redirect) = require_auth(&session) {
        return Ok(redirect);
    }

    let mut config = WifiConfig::read().unwrap_or_default();

    config.ssid = form.ssid.clone();
    config.password = form.password.clone();
    config.channel = form.channel;

    // Validate configuration
    if let Err(e) = config.validate() {
        log::warn!("Invalid WiFi config: {}", e);
        let html = templates::wifi_settings_with_message(&config, Some((&e, false)));
        return Ok(HttpResponse::BadRequest().content_type("text/html").body(html.into_string()));
    }

    // Write configuration
    match config.write() {
        Ok(_) => {
            log::info!("WiFi configuration updated successfully");

            // Restart hostapd service
            let restart_result = std::process::Command::new("systemctl")
                .args(&["restart", "hostapd"])
                .output();

            let message = match restart_result {
                Ok(output) if output.status.success() => {
                    log::info!("hostapd service restarted successfully");
                    "Konfiguration gespeichert und WiFi-Hotspot wurde neu gestartet!"
                }
                Ok(output) => {
                    log::warn!("Failed to restart hostapd: {:?}", String::from_utf8_lossy(&output.stderr));
                    "Konfiguration gespeichert! Bitte starten Sie den WiFi-Dienst manuell neu (systemctl restart hostapd)"
                }
                Err(e) => {
                    log::error!("Failed to execute systemctl: {}", e);
                    "Konfiguration gespeichert! Bitte starten Sie den WiFi-Dienst manuell neu (systemctl restart hostapd)"
                }
            };

            let html = templates::wifi_settings_with_message(&config, Some((message, true)));
            Ok(HttpResponse::Ok().content_type("text/html").body(html.into_string()))
        }
        Err(e) => {
            log::error!("Failed to write WiFi config: {}", e);
            let msg = format!("Fehler beim Speichern: {}", e);
            let html = templates::wifi_settings_with_message(&config, Some((&msg, false)));
            Ok(HttpResponse::InternalServerError().content_type("text/html").body(html.into_string()))
        }
    }
}

/// Settings overview page
pub async fn settings(session: Session) -> Result<HttpResponse> {
    if let Some(redirect) = require_auth(&session) {
        return Ok(redirect);
    }

    let html = templates::settings_page();
    Ok(HttpResponse::Ok().content_type("text/html").body(html.into_string()))
}

/// Serve embedded HTMX script
pub async fn serve_htmx() -> Result<HttpResponse> {
    let content = include_str!("htmx.min.js");
    Ok(HttpResponse::Ok()
        .content_type("application/javascript")
        .body(content))
}

/// Serve embedded CSS
pub async fn serve_css() -> Result<HttpResponse> {
    let content = include_str!("styles.css");
    Ok(HttpResponse::Ok()
        .content_type("text/css")
        .body(content))
}

/// About page
pub async fn about() -> Result<HttpResponse> {
    let html = templates::base("Über Pocket Surf", maud::html! {
        nav class="navbar" {
            div class="nav-content" {
                a href="/" class="back-link" { "◀" }
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

/// Login page
pub async fn login_page(session: Session) -> Result<HttpResponse> {
    // If already authenticated, redirect to settings
    if is_authenticated(&session) {
        return Ok(HttpResponse::Found()
            .append_header(("Location", "/settings"))
            .finish());
    }

    let html = templates::login_page();
    Ok(HttpResponse::Ok().content_type("text/html").body(html.into_string()))
}

#[derive(Deserialize)]
pub struct LoginForm {
    password: String,
}

/// Handle login
pub async fn login(session: Session, form: web::Form<LoginForm>) -> Result<HttpResponse> {
    match AuthConfig::read() {
        Ok(auth_config) => {
            if auth_config.verify_password(&form.password) {
                // Set session
                if let Err(e) = session.insert("authenticated", true) {
                    log::error!("Failed to set session: {}", e);
                    let html = templates::login_page_with_message(Some("Fehler beim Anmelden"));
                    return Ok(HttpResponse::InternalServerError().content_type("text/html").body(html.into_string()));
                }

                log::info!("User authenticated successfully");

                // Redirect to settings
                Ok(HttpResponse::Found()
                    .append_header(("Location", "/settings"))
                    .finish())
            } else {
                log::warn!("Failed login attempt");
                let html = templates::login_page_with_message(Some("Falsches Passwort"));
                Ok(HttpResponse::Unauthorized().content_type("text/html").body(html.into_string()))
            }
        }
        Err(e) => {
            log::error!("Failed to read auth config: {}", e);
            let msg = format!("Fehler beim Laden der Konfiguration: {}", e);
            let html = templates::login_page_with_message(Some(&msg));
            Ok(HttpResponse::InternalServerError().content_type("text/html").body(html.into_string()))
        }
    }
}

/// Handle logout
pub async fn logout(session: Session) -> Result<HttpResponse> {
    session.purge();
    Ok(HttpResponse::Found()
        .append_header(("Location", "/"))
        .finish())
}

#[derive(Deserialize)]
pub struct PasswordChangeForm {
    current_password: String,
    new_password: String,
    confirm_password: String,
}

/// Change password
pub async fn change_password(session: Session, form: web::Form<PasswordChangeForm>) -> Result<HttpResponse> {
    if let Some(redirect) = require_auth(&session) {
        return Ok(redirect);
    }

    // Validate passwords match
    if form.new_password != form.confirm_password {
        let html = templates::settings_page_with_message(Some(("Die neuen Passwörter stimmen nicht überein", false)));
        return Ok(HttpResponse::BadRequest().content_type("text/html").body(html.into_string()));
    }

    // Validate password requirements
    if let Err(e) = AuthConfig::validate_password(&form.new_password) {
        let html = templates::settings_page_with_message(Some((&e, false)));
        return Ok(HttpResponse::BadRequest().content_type("text/html").body(html.into_string()));
    }

    match AuthConfig::read() {
        Ok(auth_config) => {
            // Verify current password
            if !auth_config.verify_password(&form.current_password) {
                let html = templates::settings_page_with_message(Some(("Aktuelles Passwort ist falsch", false)));
                return Ok(HttpResponse::Unauthorized().content_type("text/html").body(html.into_string()));
            }

            // Change password
            match auth_config.change_password(&form.new_password) {
                Ok(new_config) => {
                    match new_config.write() {
                        Ok(_) => {
                            log::info!("Password changed successfully");
                            let html = templates::settings_page_with_message(Some(("Passwort erfolgreich geändert", true)));
                            Ok(HttpResponse::Ok().content_type("text/html").body(html.into_string()))
                        }
                        Err(e) => {
                            log::error!("Failed to write auth config: {}", e);
                            let msg = format!("Fehler beim Speichern: {}", e);
                            let html = templates::settings_page_with_message(Some((&msg, false)));
                            Ok(HttpResponse::InternalServerError().content_type("text/html").body(html.into_string()))
                        }
                    }
                }
                Err(e) => {
                    log::error!("Failed to change password: {}", e);
                    let msg = format!("Fehler beim Ändern des Passworts: {}", e);
                    let html = templates::settings_page_with_message(Some((&msg, false)));
                    Ok(HttpResponse::InternalServerError().content_type("text/html").body(html.into_string()))
                }
            }
        }
        Err(e) => {
            log::error!("Failed to read auth config: {}", e);
            let msg = format!("Fehler beim Laden der Konfiguration: {}", e);
            let html = templates::settings_page_with_message(Some((&msg, false)));
            Ok(HttpResponse::InternalServerError().content_type("text/html").body(html.into_string()))
        }
    }
}
