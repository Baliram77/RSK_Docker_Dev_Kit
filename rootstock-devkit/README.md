## Rootstock Docker-Compose Dev Kit

One-command **local Rootstock (RSK) regtest** developer stack:

- Rootstock node (**RSKj regtest**) with deterministic, pre-funded accounts
- Blockscout **UI** + Blockscout **API** (backend)
- PostgreSQL for Blockscout
- Foundry workspace with sample contracts + tests + deploy script

### Architecture (text diagram)

```text
           ┌─────────────────────────────────────────────────────────┐
           │                      Docker network                      │
           │                                                         │
Host       │   ┌──────────────┐     ┌────────────────────────────┐   │
ports      │   │ RSKj regtest  │     │ Blockscout backend (API)   │   │
           │   │ rsksmart/rskj │◀────│ blockscout/blockscout-rsk  │   │
4444 ─────▶│   │ RPC :4444     │     │ listens :4000 internally   │   │
5050 ─────▶│   └──────────────┘     └───────────────▲────────────┘   │
           │                                         │                │
           │                              ┌──────────┴───────────┐    │
5432 ─────▶│                              │ Postgres             │    │
           │                              │ postgres:17          │    │
           │                              └──────────────────────┘    │
           │                                                         │
           │   ┌──────────────────────────────────────────────────┐  │
4000 ─────▶│   │ Blockscout frontend (UI)                          │  │
           │   │ ghcr.io/blockscout/frontend                        │  │
           │   │ talks to backend at http://localhost:4001/api      │  │
           │   └──────────────────────────────────────────────────┘  │
           └─────────────────────────────────────────────────────────┘
```

### Services and endpoints

- **RSKj JSON-RPC**: `http://localhost:4444`
- **Blockscout UI**: `http://localhost:4000`
- **Blockscout API**: `http://localhost:4001/api`

### Quickstart (1 command)

```bash
cd rootstock-devkit
make up
```

### Deploy sample contracts (Foundry)

```bash
cd rootstock-devkit
make deploy
```

This uses `foundry/.env` (`PRIVATE_KEY=...`) and broadcasts **legacy** transactions to `http://localhost:4444`.

### Fund a new account (RBTC)

Send RBTC from your configured `foundry/.env` key:

```bash
cd rootstock-devkit
./scripts/fund.sh 0xYourAddressHere 100000000000000000
```

### Common issues + fixes

- **Blockscout UI shows “connection refused”**
  - Run `make up`, then check `docker compose ps` in `rootstock-devkit/`.
  - The UI is served by the **frontend** container; if it’s not running, restart: `docker compose up -d`.

- **Blockscout UI returns 404**
  - That usually means you’re hitting the backend API container directly. Make sure you’re using `http://localhost:4000` (UI), not `4001` (API).

- **Foundry “nonce too low” on deploy**
  - Re-run using a different pre-funded key from the genesis list, or reset chain state with `make reset`.

### Environment variables (`rootstock-devkit/.env`)

- **`RSK_RPC_PORT`**: Host port for RSKj JSON-RPC (default `4444`)
- **`RSK_P2P_PORT`**: Host port for RSKj P2P (default `5050`)
- **`BLOCKSCOUT_PORT`**: Host port for Blockscout UI (default `4000`)
- **`BLOCKSCOUT_API_PORT`**: Host port for Blockscout backend API (default `4001`)
- **`POSTGRES_PORT`**: Host port for Postgres (default `5432`)
- **`POSTGRES_DB` / `POSTGRES_USER` / `POSTGRES_PASSWORD`**: Postgres credentials for Blockscout
- **`RSK_MINING_INTERVAL_MS`**: Reserved for local tuning; current setup uses **automine** (mine-on-tx)
- **`BLOCKSCOUT_LOG_LEVEL`**: Backend log verbosity

