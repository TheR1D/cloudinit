#!/usr/bin/env bash
set -euo pipefail

BASE_YML_URL="https://raw.githubusercontent.com/TheR1D/cloudinit/main/base.yml"

# Resolve each arg: fetch URLs via curl, pass local paths as-is.
sources=()
for arg in "$@"; do
  if [[ "$arg" =~ ^https?:// ]]; then
    sources+=(<(curl -fsSL "$arg"))
  else
    sources+=("$arg")
  fi
done

yq eval-all '. as $item ireduce ({}; . *+ $item)' \
  <(curl -fsSL "$BASE_YML_URL") ${sources[@]+"${sources[@]}"} \
  | yq 'with(.. | select(tag == "!!str" and . == "*${*}*"); . |= envsubst)'
