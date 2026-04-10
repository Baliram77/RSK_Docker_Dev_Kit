## Rootstock Docker-Compose Dev Kit

One-command **local Rootstock (RSK) regtest** developer stack.

Rootstock local development is usually slow to set up (node config, funded accounts, explorer, tooling). This devkit makes it predictable: you start a full local stack in minutes and immediately deploy contracts with Foundry.

- Rootstock node (**RSKj regtest**) with deterministic, pre-funded accounts
- Blockscout **UI** + Blockscout **API** (backend)
- PostgreSQL for Blockscout
- Foundry workspace with sample contracts + tests + deploy script

### What’s new / different (why this exists)

This repo is intentionally **RSKj-based** (real Rootstock node) and ships an explorer that uses an **RSK-compatible Blockscout build** (RSK behavior is compile-time in Blockscout).

It also provides **two compose profiles** so you can choose between **fast boot** and **full explorer** without editing files.

### Maintenance commitment (project expectations)

- Versions are **pinned** in `rootstock-devkit/.env` and should be bumped intentionally.
- CI is expected to keep the “boot stack + run forge tests” path working on every change.

### When to use this repo

- You want a **local Rootstock chain** for fast iteration (no faucets, no waiting for public testnets).
- You need a local explorer (**Blockscout UI**) to inspect blocks/txs/contracts.
- You want to run CI to ensure the whole stack still boots and contracts still compile/test.

### Prerequisites

- **Docker Desktop** (with `docker compose` available)
- **Foundry** (for deploy/tests in `foundry/`)
  - Install guide: `https://book.getfoundry.sh/getting-started/installation`

### Apple Silicon (M1/M2/M3) / ARM notes

- **RSKj image is `linux/amd64`**. On Apple Silicon, Docker Desktop will run it via emulation.
- **Expected impact**: slower startup and higher CPU usage vs a native amd64 machine.
- If you hit platform errors: `DOCKER_DEFAULT_PLATFORM=linux/amd64 docker compose --profile full up -d`

### Quickstart (Windows/macOS/Linux)

From `rootstock-devkit/`:

```bash
# Full stack (RSKj + Postgres + Blockscout)
docker compose --profile full up -d
docker compose --profile full ps
```

Open:

- **Blockscout UI**: `http://localhost:4000`
- **RSK JSON-RPC**: `http://localhost:4444`

### Compose profiles (lite vs full)

- **Lite** (fast boot): RSKj only

```bash
docker compose --profile lite up -d
```

- **Full** (explorer): RSKj + Postgres + Blockscout (backend + UI)

```bash
docker compose --profile full up -d
```

### Developer commands

If you have `make` installed:

```bash
make up
make test
make deploy
make reset
```

If you **don’t** have `make` (common on Windows), use scripts:

```bash
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
           │                 ┌───────────────────────┘                │
           │                 │                                        │
           │        ┌────────▼────────┐                               │
           │        │ RPC proxy (nginx)│                               │
           │        │ forces Host hdr  │                               │
           │        └──────────────────┘                               │
           │                              ┌──────────┴───────────┐    │
5432 ─────▶│                              │ Postgres             │    │
           │                              │ postgres:17          │    │
           │                              └──────────────────────┘    │
           │                                                         │
           │   ┌──────────────────────────────────────────────────┐  │
4000 ─────▶│   │ Blockscout frontend (UI)                          │  │
           │   │ ghcr.io/blockscout/frontend                         │  │
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
  - Run `docker compose --profile full up -d`, then check `docker compose --profile full ps` in `rootstock-devkit/`.
  - The UI is served by the **frontend** container; if it’s not running, restart: `docker compose up -d`.

- **Blockscout UI returns 404**
  - That usually means you’re hitting the backend API container directly. Make sure you’re using `http://localhost:4000` (UI), not `4001` (API).

- **Blockscout API returns 200 but shows no blocks**
  - This stack includes `rootstock-rskj-rpc-proxy` (nginx) to make RSKj’s RPC compatible with Blockscout’s default Host header behavior inside Docker.
  - Reset and restart full: `docker compose --profile full down -v --remove-orphans && docker compose --profile full up -d`

- **Foundry “nonce too low” on deploy**
  - Reset the chain with `./scripts/reset.sh`, or use a different pre-funded dev key in `foundry/.env`.

### Environment variables (`rootstock-devkit/.env`)

- **About `.env`**
  - We keep `rootstock-devkit/.env` committed because it contains **no real secrets** (it’s just ports + pinned image tags + local DB defaults).
  - If you prefer the conventional pattern, copy `rootstock-devkit/.env.example` to `rootstock-devkit/.env` and edit your local values.
- **Pinned images**
  - `RSKJ_IMAGE`, `RSKJ_TAG`
  - `BLOCKSCOUT_RSK_IMAGE`, `BLOCKSCOUT_RSK_TAG`
  - `BLOCKSCOUT_FRONTEND_IMAGE`, `BLOCKSCOUT_FRONTEND_TAG`
- **`RSK_RPC_PORT`**: Host port for RSKj JSON-RPC (default `4444`)
- **`RSK_P2P_PORT`**: Host port for RSKj P2P (default `5050`)
- **`BLOCKSCOUT_PORT`**: Host port for Blockscout UI (default `4000`)
- **`BLOCKSCOUT_API_PORT`**: Host port for Blockscout backend API (default `4001`)
- **`POSTGRES_PORT`**: Host port for Postgres (default `5432`)
- **`POSTGRES_DB` / `POSTGRES_USER` / `POSTGRES_PASSWORD`**: Postgres credentials for Blockscout
- **`RSK_MINING_INTERVAL_MS`**: Reserved for local tuning; current setup uses **automine** (mine-on-tx)
- **`BLOCKSCOUT_LOG_LEVEL`**: Backend log verbosity

### Folder READMEs

- **Docker configs**: `docker/README.md`
- **Scripts**: `scripts/README.md`
- **Foundry workspace**: `foundry/README.md`

### Benchmarks

See `BENCHMARKS.md` for cold-start measurements (lite vs full).

### End-to-end validation (RSKj + Blockscout)

Run these checks after `--profile full up -d`:

```bash
# 1) chain id (33 => 0x21)
curl -s -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","method":"eth_chainId","params":[],"id":1}' \
  http://localhost:4444/

# 2) Blockscout UI
curl -s -o /dev/null -w "%{http_code}\n" http://localhost:4000/

# 3) Blockscout API (latest blocks endpoint)
curl -s -o /dev/null -w "%{http_code}\n" http://localhost:4001/api/v2/blocks
```

Expected:

- `eth_chainId` returns `0x21`
- UI returns HTTP `200`
- API returns HTTP `200`

