#!/usr/bin/env bash
#
# Example: ./partial_repository_archive.sh 2022-05-12 2022-06-01 internal_messages

# Set the date range to archive.
FROM_DATE=$1
TO_DATE=$2
TASK=$3

# Get the related epochs
FROM_EPOCH=$(lily-shed convert -s date $1_00-00-00)
TO_EPOCH=$(lily-shed convert -s date $2_00-00-00)

echo "Creating partial repository archive from ${FROM_EPOCH} to ${TO_EPOCH}"

# Download closest chain snapshot
lily-shed snapshot ${1}_00-00-00

# Initialize repository
lily init --repo=.lily --config=config.toml --import-snapshot minimal_finality_stateroots_*.car

# Spawn daemon
lily daemon --repo=.lily --config=config.toml &

# Wait for full chain to be synced
lily sync wait

# Walk the chain
lily job run --storage=CSV --tasks=$TASK walk --from $FROM_EPOCH --to $TO_EPOCH

# Wait for the job to finish
lily job wait --id 1

# Stop the daemon
lily stop

# Archive the repository to S3
# rclone copy --s3-acl=bucket-owner-full-control --progress .lily/config.toml "s3:${S3_PATH}/partial-${FROM_EPOCH}-${TO_EPOCH}/"
# rclone copy --s3-acl=bucket-owner-full-control --progress .lily/mainnet/datastore "s3:${S3_PATH}/partial-${FROM_EPOCH}-${TO_EPOCH}/datastore"
