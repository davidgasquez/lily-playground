#!/usr/bin/env bash

# Get chain snapshot
aria2c -x16 https://fil-chain-snapshots-fallback.s3.amazonaws.com/mainnet/minimal_finality_stateroots_latest.car

# Initialize Lily
lily init --repo=.lily --config=config.toml --import-snapshot minimal_finality_stateroots_latest.car

# Spawn daemon
lily daemon --repo=.lily --config=config.toml

# Wait for sync
lily sync wait

# Initialize TimescaleDB
lily migrate --db="postgres://postgres:password@timescaledb:5432/postgres?sslmode=disable" --latest --schema postgres --name lily

# Notify a walk job
lily job run --storage="Timescale" --window=30s --tasks="blocks" walk --from=1961761 --to=1961780 notify --queue="Notifier1"

# Run the notified walk job
lily job run --storage="Timescale" tipset-worker --queue="Worker1"

# Run a walk job and save to CSV
lily job run --storage=CSV --tasks="internal_messages" walk --from=2023400 --to=2023450

# Run a watch job and save to CSV
lily job run --storage=CSV --window=30s --tasks="blocks" watch --confidence=100
