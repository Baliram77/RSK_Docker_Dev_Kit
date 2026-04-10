#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

PROFILE="${1:-full}"
RUNS="${2:-3}"

if [[ "$PROFILE" != "lite" && "$PROFILE" != "full" ]]; then
  echo "Usage: $0 [lite|full] [runs]" >&2
  exit 2
fi

echo "Benchmarking profile: $PROFILE"
echo "Runs: $RUNS"
echo

service_health() {
  local svc="$1"
  local cid
  cid="$(docker compose --profile "$PROFILE" ps -q "$svc" 2>/dev/null || true)"
  if [[ -z "$cid" ]]; then
    echo "missing"
    return 0
  fi

  # If the container has no healthcheck, .State.Health won't exist.
  docker inspect --format '{{if .State.Health}}{{.State.Health.Status}}{{else}}no-healthcheck{{end}}' "$cid" 2>/dev/null || echo "unknown"
}

wait_healthy() {
  local svc="$1"
  local seconds="$2"

  for _ in $(seq 1 "$seconds"); do
    local st
    st="$(service_health "$svc")"
    if [[ "$st" == "healthy" ]]; then
      return 0
    fi
    sleep 1
  done

  return 1
}

for i in $(seq 1 "$RUNS"); do
  echo "== Run $i/$RUNS (cold start) =="

  docker compose --profile "$PROFILE" down -v --remove-orphans >/dev/null 2>&1 || true

  start_ms="$(date +%s%3N)"
  docker compose --profile "$PROFILE" up -d >/dev/null

  # Wait for RSKj healthcheck (defined in docker-compose.yml)
  if ! wait_healthy rskj 180; then
    echo "RSKj did not become healthy in time" >&2
    docker compose --profile "$PROFILE" ps || true
    docker logs --tail=200 rootstock-rskj-regtest || true
    exit 1
  fi

  if [[ "$PROFILE" == "full" ]]; then
    # Wait for Blockscout backend healthcheck (added in docker-compose.yml)
    if ! wait_healthy blockscout-backend 360; then
      echo "Blockscout backend did not become healthy in time" >&2
      docker compose --profile "$PROFILE" ps || true
      docker logs --tail=200 rootstock-blockscout-backend || true
      exit 1
    fi
  fi

  end_ms="$(date +%s%3N)"
  elapsed_ms="$((end_ms - start_ms))"

  echo "Cold start to healthy (ms): $elapsed_ms"
  echo
done

