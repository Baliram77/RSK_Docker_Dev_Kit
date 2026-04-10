#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
FOUNDRY_DIR="$ROOT_DIR/foundry"

TO="${1:-}"
AMOUNT_WEI="${2:-100000000000000000}" # 0.1 RBTC default

if [[ -z "$TO" ]]; then
  echo "Usage: $0 <to_address> [amount_wei]" >&2
  echo "Example: $0 0xabc... 1000000000000000000" >&2
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

cast send "$TO" --value "$AMOUNT_WEI" --rpc-url http://localhost:4444 --private-key "$PRIVATE_KEY" --legacy

