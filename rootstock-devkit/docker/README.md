## Docker configs

This folder contains the configuration files mounted into containers by `docker-compose.yml`.

### What this controls

- **RSKj behavior** (regtest, RPC settings, mining/automine, genesis allocation)
- **Blockscout backend metadata** (chain type, network label, coin symbol, etc.)

### Layout

- `rskj/`
  - `config.conf`
    - RPC is enabled and bound to `0.0.0.0:4444` inside the container
    - regtest config selected (`blockchain.config.name = regtest`)
    - automine enabled (`miner.client.autoMine = true`) so blocks appear quickly during dev
  - `genesis.json`
    - preloads deterministic dev accounts with large RBTC balances
    - used to ensure **no faucet** is required
- `blockscout/`
  - `blockscout.env`
    - backend env for the RSK Blockscout image (`CHAIN_TYPE=rsk`)
    - UI is served by a separate frontend container (configured in `docker-compose.yml`)

### Notes

- **Do not put secrets here**. All values in this folder are committed to git.
- If you change `rskj/genesis.json`, you must **wipe volumes** for it to take effect:

```bash
docker compose down -v --remove-orphans
docker compose up -d
```

### Quick debugging

- Check container status:

```bash
docker compose ps
```

- View RSKj logs:

```bash
docker logs -n 200 rootstock-rskj-regtest
```

- View Blockscout backend logs:

```bash
docker logs -n 200 rootstock-blockscout-backend
```


