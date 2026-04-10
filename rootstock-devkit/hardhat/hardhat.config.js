require("@nomicfoundation/hardhat-ethers");

const RSK_REGTEST_RPC_URL = process.env.RSK_REGTEST_RPC_URL || "http://127.0.0.1:4444";
const PRIVATE_KEY = process.env.PRIVATE_KEY || "";

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: {
    version: "0.8.28",
    settings: {
      optimizer: { enabled: true, runs: 200 },
      evmVersion: "london"
    }
  },
  defaultNetwork: "hardhat",
  networks: {
    hardhat: {},
    rskRegtest: {
      url: RSK_REGTEST_RPC_URL,
      chainId: 33,
      accounts: PRIVATE_KEY ? [PRIVATE_KEY] : [],
      // Rootstock uses legacy txs; setting gasPrice forces type-0 behavior in common tooling.
      gasPrice: 0
    }
  },
  paths: {
    // Reuse the same Solidity sources as the Foundry workspace.
    sources: "../foundry/src",
    cache: "cache",
    artifacts: "artifacts"
  }
};

