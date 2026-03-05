# Build stage
FROM docker.io/library/rust:1-slim as builder

# Install build dependencies
RUN apt-get update && \
    apt-get install -y pkg-config libssl-dev && \
    rm -rf /var/lib/apt/lists/*

# Create app directory
WORKDIR /app

# Copy manifests
COPY Cargo.toml ./

# Create dummy main to cache dependencies
RUN mkdir src && \
    echo "fn main() {}" > src/main.rs && \
    cargo build --release && \
    rm -rf src

# Copy source code
COPY src ./src

# Build for release
RUN touch src/main.rs && \
    cargo build --release

# Runtime stage
FROM docker.io/library/debian:12-slim

# Install runtime dependencies
RUN apt-get update && \
    apt-get install -y ca-certificates curl && \
    rm -rf /var/lib/apt/lists/*

# Create non-root user
RUN useradd -m -u 1000 pocket && \
    mkdir -p /config && \
    chown pocket:pocket /config

WORKDIR /app

# Copy binary from builder
COPY --from=builder /app/target/release/pocket-surf-home /app/pocket-surf-home

# Set ownership
RUN chown pocket:pocket /app/pocket-surf-home

# Switch to non-root user
USER pocket

# Expose port
EXPOSE 3000

# Set environment
ENV RUST_LOG=info
ENV CONFIG_PATH=/config

# Run the application
CMD ["/app/pocket-surf-home"]
