#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
FOUNDRY_DIR="$ROOT_DIR/foundry"

if [[ ! -d "$FOUNDRY_DIR" ]]; then
  echo "Foundry folder not found at: $FOUNDRY_DIR" >&2
  exit 1
fi

cd "$FOUNDRY_DIR"

# Loads PRIVATE_KEY from foundry/.env if present
if [[ -f ".env" ]]; then
  # shellcheck disable=SC1091
  source ".env"
fi

if [[ -z "${PRIVATE_KEY:-}" ]]; then
  echo "PRIVATE_KEY is not set. Put it in foundry/.env" >&2
  exit 1
fi

forge clean
forge build
forge script script/Deploy.s.sol:Deploy --rpc-url rsk --broadcast --legacy -vvv

