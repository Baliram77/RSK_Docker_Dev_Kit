## Rootstock Docker-Compose Dev Kit

Local Rootstock (RSK) dev environment with one command: RSKj **regtest** + Blockscout + PostgreSQL.

### What runs

- **RSKj** (`rsksmart/rskj:VETIVER-9.0.0`)
  - **Regtest** mode
  - JSON-RPC on `http://localhost:${RSK_RPC_PORT}` (default `4444`)
  - Pre-funded dev accounts (see `docker/rskj/genesis.json`)
- **PostgreSQL** (`postgres:17`) for Blockscout
- **Blockscout (RSK)** (`blockscout/blockscout-rsk:7.0.2`)
  - Explorer UI on `http://localhost:${BLOCKSCOUT_PORT}` (default `4000`)

### Quickstart

1) Copy env (optional) and start:

```bash
cd rootstock-devkit
docker compose up -d
```

2) Open Blockscout:

- `http://localhost:4000`

3) RPC endpoint:

- `http://localhost:4444`

### How services connect

- **Blockscout → RSKj**: `ETHEREUM_JSONRPC_HTTP_URL=http://rskj:4444` (Docker network DNS)
- **Blockscout → Postgres**: `DATABASE_URL=postgresql://...@postgres:5432/...`
- **Startup ordering**: Blockscout waits for **RSKj healthcheck** (JSON-RPC responds) and **Postgres healthcheck**.

