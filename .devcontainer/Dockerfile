FROM golang:1.18 AS builder

RUN apt-get update && apt-get install -y ca-certificates build-essential clang ocl-icd-opencl-dev ocl-icd-libopencl1 jq libhwloc-dev

ARG RUST_VERSION=nightly
ENV XDG_CACHE_HOME="/tmp"

ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:$PATH

RUN wget "https://static.rust-lang.org/rustup/dist/x86_64-unknown-linux-gnu/rustup-init"; \
    chmod +x rustup-init; \
    ./rustup-init -y --no-modify-path --profile minimal --default-toolchain $RUST_VERSION; \
    rm rustup-init; \
    chmod -R a+w $RUSTUP_HOME $CARGO_HOME; \
    rustup --version; \
    cargo --version; \
    rustc --version;

# Build Lily Shed
RUN git clone https://github.com/kasteph/lily-shed.git /tmp/lily-shed
WORKDIR /tmp/lily-shed
RUN go build

# Build Lily
RUN git clone --branch v0.11.0 https://github.com/filecoin-project/lily /tmp/lily
WORKDIR /tmp/lily
RUN export CGO_ENABLED=1 && make clean all

FROM mcr.microsoft.com/vscode/devcontainers/base:ubuntu-22.04

# Install aria2 to download snapshots
RUN apt-get update && apt-get install -y aria2 redis-server

# Install Lily
COPY --from=builder /tmp/lily/lily /usr/bin/lily
COPY --from=builder /tmp/lily-shed/lily-shed /usr/bin/lily-shed
COPY --from=builder /usr/lib/x86_64-linux-gnu/libOpenCL.so* /lib/
COPY --from=builder /usr/lib/x86_64-linux-gnu/libhwloc.so* /lib/
COPY --from=builder /usr/lib/x86_64-linux-gnu/libnuma.so* /lib/
COPY --from=builder /usr/lib/x86_64-linux-gnu/libltdl.so* /lib/
