import { defineConfig } from "hardhat/config";
import hardhatEthers from "@nomicfoundation/hardhat-ethers";

const RSK_REGTEST_RPC_URL = process.env.RSK_REGTEST_RPC_URL || "http://127.0.0.1:4444";
const PRIVATE_KEY = process.env.PRIVATE_KEY || "";

export default defineConfig({
  plugins: [hardhatEthers],
  solidity: {
    version: "0.8.28",
    settings: {
      optimizer: { enabled: true, runs: 200 },
      evmVersion: "london",
    },
  },
  defaultNetwork: "hardhat",
  networks: {
    hardhat: {
      type: "edr-simulated",
    },
    rskRegtest: {
      type: "http",
      url: RSK_REGTEST_RPC_URL,
      chainId: 33,
      accounts: PRIVATE_KEY ? [PRIVATE_KEY] : [],
      // Rootstock uses legacy txs; setting gasPrice forces type-0 behavior in common tooling.
      gasPrice: 0,
    },
  },
  paths: {
    // Keep Hardhat sources inside this workspace (Hardhat 3 enforces this).
    sources: "contracts",
    cache: "cache",
    artifacts: "artifacts",
  },
});

