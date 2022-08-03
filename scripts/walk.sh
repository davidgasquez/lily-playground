#!/usr/bin/env bash
#
# Usage: ./walk.sh [from_epoch] [to_epoch] [tasks]
# Example: ./walk.sh 2040000 2050000 internal_messages

set -Eeuo pipefail

FROM_EPOCH=$1
TO_EPOCH=$2
TASKS=$3
REPO_PATH="${REPO_PATH:-".lily"}"

echo "Generating CSVs for ${TASKS} from ${FROM_EPOCH} to ${TO_EPOCH}"

# Around one day earlier than the start epoch
FROM_DATE=$(lily-shed convert -s epoch $(($FROM_EPOCH-3000)))

# lily-shed snapshot -m 24 $FROM_DATE

# lily init --repo=.lily --config=config.toml --import-snapshot minimal_finality_stateroots_*.car
