## Rootstock Docker-Compose Dev Kit

One-command **local Rootstock (RSK) regtest** developer stack.

Rootstock local development is usually slow to set up (node config, funded accounts, explorer, tooling). This devkit makes it predictable: you start a full local stack in minutes and immediately deploy contracts with Foundry.

- Rootstock node (**RSKj regtest**) with deterministic, pre-funded accounts
- Blockscout **UI** + Blockscout **API** (backend)
- PostgreSQL for Blockscout
- Foundry workspace with sample contracts + tests + deploy script

### When to use this repo

- You want a **local Rootstock chain** for fast iteration (no faucets, no waiting for public testnets).
- You need a local explorer (**Blockscout UI**) to inspect blocks/txs/contracts.
- You want to run CI to ensure the whole stack still boots and contracts still compile/test.

### Prerequisites

- **Docker Desktop** (with `docker compose` available)
- **Foundry** (for deploy/tests in `foundry/`)
  - Install guide: `https://book.getfoundry.sh/getting-started/installation`

### Quickstart (Windows/macOS/Linux)

From repo root:

```bash
cd rootstock-devkit
docker compose up -d
docker compose ps
```

Open:

- **Blockscout UI**: `http://localhost:4000`
- **RSK JSON-RPC**: `http://localhost:4444`

### Developer commands

If you have `make` installed:

```bash
cd rootstock-devkit
make up
make test
make deploy
make reset
```

If you **don’t** have `make` (common on Windows), use scripts:

```bash
cd rootstock-devkit
./scripts/start.sh
./scripts/reset.sh
./scripts/deploy.sh
./scripts/fund.sh 0xYourAddressHere 100000000000000000
```

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

### Deploy sample contracts (Foundry)

```bash
cd rootstock-devkit
./scripts/deploy.sh
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
  - Check `docker compose ps` in `rootstock-devkit/`.
  - The UI is served by the **frontend** container; if it’s not running, restart: `docker compose up -d`.

- **Blockscout UI returns 404**
  - That usually means you’re hitting the backend API container directly. Make sure you’re using `http://localhost:4000` (UI), not `4001` (API).

- **Foundry “nonce too low” on deploy**
  - Reset the chain with `./scripts/reset.sh`, or use a different pre-funded dev key in `foundry/.env`.

### Environment variables (`rootstock-devkit/.env`)

- **`RSK_RPC_PORT`**: Host port for RSKj JSON-RPC (default `4444`)
- **`RSK_P2P_PORT`**: Host port for RSKj P2P (default `5050`)
- **`BLOCKSCOUT_PORT`**: Host port for Blockscout UI (default `4000`)
- **`BLOCKSCOUT_API_PORT`**: Host port for Blockscout backend API (default `4001`)
- **`POSTGRES_PORT`**: Host port for Postgres (default `5432`)
- **`POSTGRES_DB` / `POSTGRES_USER` / `POSTGRES_PASSWORD`**: Postgres credentials for Blockscout
- **`RSK_MINING_INTERVAL_MS`**: Reserved for local tuning; current setup uses **automine** (mine-on-tx)
- **`BLOCKSCOUT_LOG_LEVEL`**: Backend log verbosity

### Folder READMEs

- **Docker configs**: `rootstock-devkit/docker/README.md`
- **Scripts**: `rootstock-devkit/scripts/README.md`
- **Foundry workspace**: `rootstock-devkit/foundry/README.md`

### Rootstock links

- **Developer portal**: `https://dev.rootstock.io/`
- **Discord**: `https://discord.gg/rootstock`
- **Telegram** (announcements): `https://t.me/RSKsmartcontracts`
- **X (Twitter)**: `https://x.com/rootstock_io`
- **Testnet Blockscout**: `https://rootstock-testnet.blockscout.com/`

