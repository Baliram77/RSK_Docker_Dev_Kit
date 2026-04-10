import { HDNodeWallet, Mnemonic } from "ethers";

const mnemonic =
  process.env.DEVKIT_MNEMONIC ??
  "test test test test test test test test test test test junk";

const m = Mnemonic.fromPhrase(mnemonic);

const count = Number.parseInt(process.env.DEVKIT_ACCOUNTS ?? "10", 10);
const basePath = process.env.DEVKIT_HD_PATH ?? "m/44'/60'/0'/0";

const accounts = [];
for (let i = 0; i < count; i++) {
  const path = `${basePath}/${i}`;
  const w = HDNodeWallet.fromMnemonic(m, path);
  accounts.push({
    index: i,
    path,
    address: w.address,
    privateKey: w.privateKey,
  });
}

console.log(JSON.stringify({ mnemonic, basePath, accounts }, null, 2));

