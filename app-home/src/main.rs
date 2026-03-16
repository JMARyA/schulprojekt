mod config;
mod routes;
mod templates;

use actix_web::{middleware, web, App, HttpServer, cookie::Key};
use actix_session::{SessionMiddleware, storage::CookieSessionStore};
use std::io;

# TODO : back button redesign
# TODO : integrate into installer / systemd unit workdir

#[actix_web::main]
async fn main() -> io::Result<()> {
    // Initialize logger
    env_logger::init_from_env(env_logger::Env::new().default_filter_or("info"));

    log::info!("Starting Pocket Surf Home Dashboard...");

    let bind_addr = "0.0.0.0:3000";
    log::info!("Binding to {}", bind_addr);

    // Generate a random session key
    let secret_key = Key::generate();

    HttpServer::new(move || {
        App::new()
            // Middleware
            .wrap(middleware::Logger::default())
            .wrap(middleware::Compress::default())
            .wrap(
                SessionMiddleware::builder(CookieSessionStore::default(), secret_key.clone())
                    .cookie_secure(false) // Set to true in production with HTTPS
                    .build()
            )

            // Static assets (embedded, no external resources)
            .route("/static/htmx.js", web::get().to(routes::serve_htmx))
            .route("/static/styles.css", web::get().to(routes::serve_css))

            // Public routes
            .route("/", web::get().to(routes::index))
            .route("/about", web::get().to(routes::about))
            .route("/login", web::get().to(routes::login_page))
            .route("/api/login", web::post().to(routes::login))
            .route("/api/logout", web::post().to(routes::logout))

            // Protected settings routes
            .route("/settings", web::get().to(routes::settings))
            .route("/settings/wifi", web::get().to(routes::wifi_settings))
            .route("/api/wifi/update", web::post().to(routes::update_wifi))
            .route("/api/password/change", web::post().to(routes::change_password))
    })
    .bind(bind_addr)?
    .run()
    .await
}
