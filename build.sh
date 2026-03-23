#!/usr/bin/env bash
# Merge base.yml with an extra cloud-init file using yq and output to stdout.
#
# Usage (local):
#   ./build.sh                             # output base.yml only
#   ./build.sh extra.yml [more.yml ...]    # deep-merge base + extras
#
# Usage (remote):
#   curl -fsSL https://raw.githubusercontent.com/TheR1D/cloudinit/main/build.sh | bash
#   curl -fsSL https://raw.githubusercontent.com/TheR1D/cloudinit/main/build.sh | bash -s -- extra.yml
#
# Prerequisites: op (1Password CLI), yq, curl
set -euo pipefail

BASE_YML_URL="https://raw.githubusercontent.com/TheR1D/cloudinit/main/base.yml"

# Use /dev/tty so the prompt works even when stdin is a pipe (e.g. curl | bash)
read -rp "1Password environment ID: " op_env_id </dev/tty

yq eval-all '. as $item ireduce ({}; . *+ $item)' \
  <(curl -fsSL "$BASE_YML_URL") "$@" \
  | op run --no-masking --environment "$op_env_id" -- \
    yq 'with(.. | select(tag == "!!str" and . == "*${*}*"); . |= envsubst)'
