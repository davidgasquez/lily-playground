#!/usr/bin/env bash

# Get chain snapshot
curl -sI https://fil-chain-snapshots-fallback.s3.amazonaws.com/mainnet/minimal_finality_stateroots_latest.car |
    perl -ne '/x-amz-website-redirect-location:\s(.+)\.car/ && print "$1.sha256sum\n$1.car"' |
    xargs wget

# Initialize Lily
lily init --repo=.lily --config=config.toml  --import-snapshot minimal.car

# Spawn daemon
lily daemon

# Wait for sync
lily sync wait

# Run a walk job
lily job run --storage=CSV --window=30s --tasks="blocks" walk --from=1841000 --to=1841040

# Run a watch job
lily job run --storage=CSV --window=30s --tasks="blocks" watch  --confidence=100
