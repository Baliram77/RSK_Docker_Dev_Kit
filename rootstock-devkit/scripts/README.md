## Scripts

These are convenience scripts for day-to-day local development.

### Requirements

- **Docker** + `docker compose` for start/stop/reset
- **Foundry** (`forge` + `cast`) for deploy/fund

### Start / stop / reset

- `./scripts/start.sh`: start the full stack (`docker compose up -d`)
- `./scripts/stop.sh`: stop containers (`docker compose down`)
- `./scripts/reset.sh`: wipe volumes and restart (fresh chain + fresh DB)

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

- `./scripts/derive-accounts.mjs`
  - prints the first 10 accounts derived from the standard test mnemonic
  - useful for verifying the genesis-funded addresses/private keys

### Windows note

If you see “permission denied”, run:

```bash
chmod +x scripts/*.sh
```

