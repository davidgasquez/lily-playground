#!/usr/bin/env bash

# Get chain snapshot
aria2c -x16 https://fil-chain-snapshots-fallback.s3.amazonaws.com/mainnet/minimal_finality_stateroots_latest.car

# Initialize Lily
lily init --repo=.lily --config=config.toml --import-snapshot minimal_finality_stateroots_latest.car

# Spawn daemon
lily daemon --repo=.lily --config=config.toml

# Wait for sync
lily sync wait

# Run a walk job
lily job run --storage=CSV --window=30s --tasks="blocks" walk --from=1841000 --to=1841040 notify --queue="Notifier1"

# Run a watch job
lily job run --storage=CSV --window=30s --tasks="blocks" watch --confidence=100
