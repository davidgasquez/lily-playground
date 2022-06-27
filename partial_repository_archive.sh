#!/usr/bin/env bash
#
# Example: ./partial_repository_archive.sh 2022-05-13 2022-06-01

# Set the date range to archive.
FROM_DATE=$1
TO_DATE=$2

# Get the related epochs
FROM_EPOCH=$(lily-shed convert -s date $1_00-00-00)
TO_EPOCH=$(lily-shed convert -s date $2_00-00-00)

echo "Creating partial repository archive from $FROM_EPOCH to $TO_EPOCH"

# Download chain snapshot
SNAPSHOT_URL="https://fil-chain-snapshots-fallback.s3.amazonaws.com/mainnet/minimal_finality_stateroots_${FROM_EPOCH}_${FROM_DATE}_00-00-00.car"
echo "Downloading $SNAPSHOT_URL"
aria2c -x16 $SNAPSHOT_URL

# Initialize repository
# lily init --repo=.lily --config=config.toml --import-snapshot minimal_finality_stateroots_1803120_2022-05-13_00-00-00.car

# Spawn daemon
# lily daemon --repo=.lily --config=config.toml 2>&1 | tee -a lily.log
