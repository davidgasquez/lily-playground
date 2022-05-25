#!/usr/bin/env bash

# Get chain snapshot
curl -sI https://fil-chain-snapshots-fallback.s3.amazonaws.com/mainnet/minimal_finality_stateroots_latest.car |
    perl -ne '/x-amz-website-redirect-location:\s(.+)\.car/ && print "$1.sha256sum\n$1.car"' |
    xargs wget

# Initialize Lily
lily init \
    --repo=/worspaces/lily-playground/.lily \
    --config=/worspaces/lily-playground/config.toml \
    --import-snapshot minimal.car