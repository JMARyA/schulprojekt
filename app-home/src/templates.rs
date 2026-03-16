use maud::{html, Markup, DOCTYPE};

/// Reusable back button component
fn back_button(href: &str) -> Markup {
    html! {
        a href=(href) class="back-link" {
            span style="margin-right: 0.5rem;" { "◀" }
            "Zurück"
        }
    }
}

pub fn base(title: &str, content: Markup) -> Markup {
    html! {
        (DOCTYPE)
        html lang="de" {
            head {
                meta charset="utf-8";
                meta name="viewport" content="width=device-width, initial-scale=1.0";
                title { (title) }
                script src="/static/htmx.js" {}
                link rel="stylesheet" href="/static/styles.css";
            }
            body {
                (content)
            }
        }
    }
}

pub fn home_page() -> Markup {
    let services = vec![
        ("Files", "files.local", "📁", "Dateiablage und SFTP-Zugriff"),
        ("Tasks", "tasks.local", "✓", "Aufgabenverwaltung mit Vikunja"),
        ("Wiki", "wiki.local", "📚", "Wissensdatenbank mit BookStack"),
        ("Chat", "chat.local", "💬", "Lokaler Messenger"),
    ];

    base("Pocket Surf", html! {
        // Navigation bar
        nav class="navbar" {
            div class="nav-content" {
                div class="nav-logo" {
                    "🌊 Pocket Surf"
                }
                div class="nav-menu" {
                    button class="menu-button" onclick="toggleMenu()" {
                        "⚙️"
                    }
                    div class="dropdown-menu" id="menu" {
                        a href="/settings" class="menu-item" { "⚙️ Einstellungen" }
                        a href="/about" class="menu-item" { "ℹ️ Über" }
                    }
                }
            }
        }

        // Background
        div class="background" {}

        // Main content
        div class="content-wrapper" {
            div class="hero" {
                h1 class="hero-title" { "Willkommen" }
                p class="hero-subtitle" { "Deine Services, überall verfügbar" }
            }

            main class="main" {
                div class="app-grid" {
                    @for (name, url, icon, desc) in services {
                        a href=(format!("http://{}", url)) class="app-card" {
                            div class="app-card-inner" {
                                div class="app-icon" { (icon) }
                                div class="app-info" {
                                    div class="app-name" { (name) }
                                    div class="app-desc" { (desc) }
                                }
                            }
                        }
                    }
                }
            }
        }

        script {
            (maud::PreEscaped(r#"
            function toggleMenu() {
                const menu = document.getElementById('menu');
                menu.classList.toggle('show');
            }
            // Close menu when clicking outside
            document.addEventListener('click', function(event) {
                const menu = document.getElementById('menu');
                const button = document.querySelector('.menu-button');
                if (!menu.contains(event.target) && !button.contains(event.target)) {
                    menu.classList.remove('show');
                }
            });
            "#))
        }
    })
}

pub fn settings_page_with_message(message: Option<(&str, bool)>) -> Markup {
    base("Einstellungen", html! {
        nav class="navbar" {
            div class="nav-content" {
                (back_button("/"))
                div class="nav-logo" { "⚙️ Einstellungen" }
            }
        }

        div class="background" {}

        div class="content-wrapper" {
            main class="settings-main" {
                @if let Some((msg, is_success)) = message {
                    @if is_success {
                        div class="alert alert-success" {
                            "✓ " (msg)
                        }
                    } @else {
                        div class="alert alert-error" {
                            "✗ " (msg)
                        }
                    }
                }

                div class="settings-list" {
                    a href="/settings/wifi" class="settings-item" {
                        div class="settings-item-icon" { "📡" }
                        div class="settings-item-content" {
                            div class="settings-item-title" { "WiFi Hotspot" }
                            div class="settings-item-subtitle" { "SSID, Passwort, Kanal konfigurieren" }
                        }
                        div class="settings-item-arrow" { "›" }
                    }
                }

                div class="settings-list" style="margin-top: 2rem;" {
                    div class="settings-item" style="cursor: default;" {
                        div class="settings-item-icon" { "🔐" }
                        div class="settings-item-content" {
                            div class="settings-item-title" { "Sicherheit" }
                        }
                    }
                }

                form
                    action="/api/password/change"
                    method="post"
                    class="wifi-form"
                    style="margin-top: 1rem;"
                {
                    h3 { "Passwort ändern" }

                    div class="form-group" {
                        label for="current_password" { "Aktuelles Passwort" }
                        input
                            type="password"
                            id="current_password"
                            name="current_password"
                            required;
                    }

                    div class="form-group" {
                        label for="new_password" { "Neues Passwort" }
                        input
                            type="password"
                            id="new_password"
                            name="new_password"
                            minlength="6"
                            required;
                        small { "Mindestens 6 Zeichen" }
                    }

                    div class="form-group" {
                        label for="confirm_password" { "Passwort bestätigen" }
                        input
                            type="password"
                            id="confirm_password"
                            name="confirm_password"
                            minlength="6"
                            required;
                    }

                    div class="form-actions" {
                        button type="submit" class="btn btn-primary" { "Passwort ändern" }
                    }
                }

                form action="/api/logout" method="post" style="margin-top: 2rem;" {
                    button type="submit" class="btn btn-secondary" style="width: 100%;" { "Abmelden" }
                }
            }
        }
    })
}

pub fn settings_page() -> Markup {
    settings_page_with_message(None)
}

pub fn wifi_settings_with_message(config: &crate::config::WifiConfig, message: Option<(&str, bool)>) -> Markup {
    base("WiFi Einstellungen", html! {
        nav class="navbar" {
            div class="nav-content" {
                (back_button("/settings"))
                div class="nav-logo" { "📡 WiFi Hotspot" }
            }
        }

        div class="background" {}

        div class="content-wrapper" {
            main class="settings-main" {
                @if let Some((msg, is_success)) = message {
                    @if is_success {
                        div class="alert alert-success" {
                            "✓ " (msg)
                        }
                    } @else {
                        div class="alert alert-error" {
                            "✗ " (msg)
                        }
                    }
                }

                form
                    action="/api/wifi/update"
                    method="post"
                    class="wifi-form"
                {
                    div class="form-group" {
                        label for="ssid" { "SSID (Netzwerkname)" }
                        input
                            type="text"
                            id="ssid"
                            name="ssid"
                            value=(config.ssid)
                            required;
                    }

                    div class="form-group" {
                        label for="password" { "Passwort" }
                        input
                            type="password"
                            id="password"
                            name="password"
                            value=(config.password)
                            minlength="8"
                            required;
                        small { "Mindestens 8 Zeichen" }
                    }

                    div class="form-group" {
                        label for="channel" { "Kanal" }
                        select id="channel" name="channel" {
                            @for ch in 1..=11 {
                                option value=(ch) selected[ch == config.channel] { (ch) }
                            }
                        }
                    }

                    div class="form-actions" {
                        button type="submit" class="btn btn-primary" { "Speichern" }
                        button type="button" class="btn btn-secondary" onclick="window.location='/'" {
                            "Abbrechen"
                        }
                    }
                }

                div class="info-box" {
                    p {
                        strong { "Hinweis: " }
                        "Nach dem Speichern wird der WiFi-Hotspot neu gestartet. "
                        "Sie müssen sich mit dem neuen Netzwerk erneut verbinden."
                    }
                }
            }
        }
    })
}

pub fn wifi_settings(config: &crate::config::WifiConfig) -> Markup {
    wifi_settings_with_message(config, None)
}

pub fn login_page_with_message(error_msg: Option<&str>) -> Markup {
    base("Anmelden", html! {
        nav class="navbar" {
            div class="nav-content" {
                a href="/" class="back-link" { "◀" }
                div class="nav-logo" { "🔐 Anmelden" }
            }
        }

        div class="background" {}

        div class="content-wrapper" {
            main class="settings-main" {
                @if let Some(msg) = error_msg {
                    div class="alert alert-error" {
                        "✗ " (msg)
                    }
                }

                form
                    action="/api/login"
                    method="post"
                    class="wifi-form"
                {
                    h2 { "Einstellungen Anmelden" }
                    p style="color: var(--text-light); margin-bottom: 2rem;" {
                        "Bitte geben Sie das Admin-Passwort ein, um auf die Einstellungen zuzugreifen."
                    }

                    div class="form-group" {
                        label for="password" { "Passwort" }
                        input
                            type="password"
                            id="password"
                            name="password"
                            required
                            autofocus;
                    }

                    div class="form-actions" {
                        button type="submit" class="btn btn-primary" { "Anmelden" }
                    }
                }

                div class="info-box" style="margin-top: 2rem;" {
                    p {
                        strong { "Standard-Passwort: " }
                        code { "admin" }
                    }
                    p style="margin-top: 0.5rem; font-size: 0.9rem;" {
                        "Bitte ändern Sie das Passwort nach dem ersten Anmelden."
                    }
                }
            }
        }
    })
}

pub fn login_page() -> Markup {
    login_page_with_message(None)
}
