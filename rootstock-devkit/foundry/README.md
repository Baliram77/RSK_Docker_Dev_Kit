## Foundry

This folder is a **ready-to-run Foundry workspace** preconfigured for the Rootstock DevKit regtest node.

It includes:

- Minimal **mintable ERC20** + **mintable ERC721** example contracts
- Focused tests (minting + transfers + approvals)
- A deploy script that broadcasts **legacy** transactions to the local Rootstock JSON-RPC

### Rootstock regtest (this devkit)

- **RPC**: `http://localhost:4444`
- **Chain ID**: `33`
- **Deployment tx type**: legacy (use `--legacy`)

### Project layout

- **Contracts**
  - `src/MintableERC20.sol`
  - `src/MintableERC721.sol`
- **Scripts**
  - `script/Deploy.s.sol` (deploys both contracts and prints addresses)
- **Tests**
  - `test/MintableERC20.t.sol`
  - `test/MintableERC721.t.sol`

### Files to look at

- **ERC20**: `src/MintableERC20.sol`
- **ERC721**: `src/MintableERC721.sol`
- **Deploy script**: `script/Deploy.s.sol`
- **Tests**:
  - `test/MintableERC20.t.sol`
  - `test/MintableERC721.t.sol`

### Environment

Set your dev key in `.env` (already gitignored). Use **only** the deterministic dev keys from the DevKit genesis (never a real wallet key):

```bash
cp .env.example .env
```

The DevKit provides pre-funded accounts; one safe default is already present in `.env.example`.

## Documentation

https://book.getfoundry.sh/

## Usage

### Build + test (local)

```shell
$ forge build
$ forge test
```

### Deploy to local Rootstock regtest

```shell
$ forge script script/Deploy.s.sol:Deploy --rpc-url rsk --broadcast --legacy -vvv
```

The script prints both deployed contract addresses in the logs.

### Useful commands

```shell
$ forge fmt
$ forge clean
$ cast block-number --rpc-url http://localhost:4444
```

### Common issues

- **Nonce too low**
  - Your deployer account already used some nonces. Either:
    - reset the chain (`docker compose down -v` then `up -d`), or
    - switch `PRIVATE_KEY` to another pre-funded dev key.

- **Deployment succeeds but Blockscout doesn’t show it yet**
  - Ensure the stack is running (`docker compose ps`) and check Blockscout UI at `http://localhost:4000`.
