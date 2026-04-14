## Scripts

These are convenience scripts for day-to-day local development.

### Requirements

- **Docker** + `docker compose` for start/stop/reset
- **Foundry** (`forge` + `cast`) for deploy/fund

### Start / stop / reset

- `./scripts/start.sh [lite|full]`: start a profile (default: `full`)
- `./scripts/stop.sh [lite|full]`: stop a profile (default: `full`)
- `./scripts/reset.sh [lite|full]`: wipe volumes and restart a profile (default: `full`)

### Switching between `lite` and `full`

Docker Compose profiles share the same project/network. If you’re running `full`, then bringing down `lite` may show “network is still in use” (because `full` still uses it).

- **Switch full → lite**:

```bash
docker compose --profile full down -v --remove-orphans
./scripts/start.sh lite
```

- **Switch lite → full**:

```bash
docker compose --profile lite down -v --remove-orphans
./scripts/start.sh full
```

### Deploy

- `./scripts/deploy.sh`: deploy the Foundry sample contracts
  - reads `foundry/.env` for `PRIVATE_KEY`
  - uses `--legacy` transactions
  - prints deployed addresses

Example:

```bash
./scripts/deploy.sh
```

### Fund an account

- `./scripts/fund.sh <to_address> [amount_wei]`
  - sends RBTC from the `PRIVATE_KEY` in `foundry/.env`
  - default amount is `0.1 RBTC` (in wei)

Example:

```bash
./scripts/fund.sh 0xYourAddressHere 100000000000000000
```

### Derive deterministic dev accounts

Hardhat workspace owns npm deps (lockfile under `hardhat/`). From `hardhat/`:

- `npm run derive-accounts` (runs `scripts/derive-accounts.mjs`)
  - prints the first 10 accounts derived from the standard test mnemonic
  - useful for verifying the genesis-funded addresses/private keys

### Windows note

If you see “permission denied”, run:

```bash
chmod +x scripts/*.sh
```

### Benchmarks

Measure cold-start time (fresh volumes) for `lite` / `full`:

```bash
./scripts/bench.sh lite
./scripts/bench.sh full
```

