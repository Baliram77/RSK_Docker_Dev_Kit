## Cold-start benchmarks

Rootstock asked that any “under a minute” (or similar) startup claim be backed by real measurements.

This repo includes a helper script that measures **cold start time** (fresh volumes) for:

- **`lite`**: RSKj regtest only
- **`full`**: RSKj + Postgres + Blockscout backend + Blockscout frontend

### How to run

From `rootstock-devkit/`:

```bash
chmod +x ./scripts/bench.sh

# 3 cold starts for each profile (default)
./scripts/bench.sh lite
./scripts/bench.sh full

# Or specify run count
./scripts/bench.sh lite 5
./scripts/bench.sh full 5
```

### What to report (copy/paste to your PR / Rootstock thread)

- **Machine**: CPU model, RAM, OS, Docker Desktop version
- **Profile**: lite/full
- **Runs**: N
- **Results**: list of milliseconds and (optionally) average/median

### Notes

- The script uses `docker compose down -v` to ensure a true cold start.
- “Healthy” means:
  - RSKj answers `web3_clientVersion`
  - and for `full`, Blockscout answers `GET /api/v2/blocks` with HTTP 200.

