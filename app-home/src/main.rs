mod config;
mod routes;
mod templates;

use actix_web::{middleware, web, App, HttpServer};
use std::io;

#[actix_web::main]
async fn main() -> io::Result<()> {
    // Initialize logger
    env_logger::init_from_env(env_logger::Env::new().default_filter_or("info"));

    log::info!("Starting Pocket Surf Home Dashboard...");

    let bind_addr = "0.0.0.0:3000";
    log::info!("Binding to {}", bind_addr);

    HttpServer::new(|| {
        App::new()
            // Middleware
            .wrap(middleware::Logger::default())
            .wrap(middleware::Compress::default())

            // Routes
            .route("/", web::get().to(routes::index))
            .route("/settings", web::get().to(routes::settings))
            .route("/settings/wifi", web::get().to(routes::wifi_settings))
            .route("/settings/system", web::get().to(routes::system_settings))
            .route("/settings/services", web::get().to(routes::system_settings))
            .route("/settings/network", web::get().to(routes::system_settings))
            .route("/about", web::get().to(routes::about))
            .route("/api/wifi/update", web::post().to(routes::update_wifi))
    })
    .bind(bind_addr)?
    .run()
    .await
}
