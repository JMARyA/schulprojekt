use maud::{html, Markup, DOCTYPE};

pub fn base(title: &str, content: Markup) -> Markup {
    html! {
        (DOCTYPE)
        html lang="de" {
            head {
                meta charset="utf-8";
                meta name="viewport" content="width=device-width, initial-scale=1.0";
                title { (title) }
                script src="https://unpkg.com/htmx.org@2.0.0" {}
                style {
                    (include_str!("styles.css"))
                }
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
            (r#"
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
            "#)
        }
    })
}

pub fn settings_page() -> Markup {
    base("Einstellungen", html! {
        nav class="navbar" {
            div class="nav-content" {
                a href="/" class="back-link" { "← Zurück" }
                div class="nav-logo" { "⚙️ Einstellungen" }
            }
        }

        div class="background" {}

        div class="content-wrapper" {
            main class="settings-main" {
                div class="settings-list" {
                    a href="/settings/wifi" class="settings-item" {
                        div class="settings-item-icon" { "📡" }
                        div class="settings-item-content" {
                            div class="settings-item-title" { "WiFi Hotspot" }
                            div class="settings-item-subtitle" { "SSID, Passwort, Kanal konfigurieren" }
                        }
                        div class="settings-item-arrow" { "›" }
                    }
                    a href="/settings/services" class="settings-item" {
                        div class="settings-item-icon" { "📦" }
                        div class="settings-item-content" {
                            div class="settings-item-title" { "Services" }
                            div class="settings-item-subtitle" { "Dienste verwalten" }
                        }
                        div class="settings-item-arrow" { "›" }
                    }
                    a href="/settings/network" class="settings-item" {
                        div class="settings-item-icon" { "🌐" }
                        div class="settings-item-content" {
                            div class="settings-item-title" { "Netzwerk" }
                            div class="settings-item-subtitle" { "IP-Adressen und DNS" }
                        }
                        div class="settings-item-arrow" { "›" }
                    }
                }
            }
        }
    })
}

pub fn wifi_settings(config: &crate::config::WifiConfig) -> Markup {
    base("WiFi Einstellungen", html! {
        nav class="navbar" {
            div class="nav-content" {
                a href="/settings" class="back-link" { "← Einstellungen" }
                div class="nav-logo" { "📡 WiFi Hotspot" }
            }
        }

        div class="background" {}

        div class="content-wrapper" {
            main class="settings-main" {
                form
                    hx-post="/api/wifi/update"
                    hx-swap="outerHTML"
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

pub fn success_message(message: &str) -> Markup {
    html! {
        div class="alert alert-success" {
            "✓ " (message)
        }
    }
}

pub fn error_message(message: &str) -> Markup {
    html! {
        div class="alert alert-error" {
            "✗ " (message)
        }
    }
}
