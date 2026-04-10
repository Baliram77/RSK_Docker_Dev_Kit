const hre = require("hardhat");

async function main() {
  const [deployer] = await hre.ethers.getSigners();
  if (!deployer) {
    throw new Error(
      "No deployer signer. Set PRIVATE_KEY in the environment (dev key only) before deploying."
    );
  }

  console.log("Deployer:", await deployer.getAddress());

  const ERC20 = await hre.ethers.getContractFactory("MintableERC20");
  const token = await ERC20.deploy("DevToken", "DVT", await deployer.getAddress(), {
    gasPrice: 0
  });
  await token.waitForDeployment();
  console.log("MintableERC20:", await token.getAddress());

  const ERC721 = await hre.ethers.getContractFactory("MintableERC721");
  const nft = await ERC721.deploy("DevNFT", "DNFT", await deployer.getAddress(), {
    gasPrice: 0
  });
  await nft.waitForDeployment();
  console.log("MintableERC721:", await nft.getAddress());

  const mintTx1 = await token.mint(await deployer.getAddress(), hre.ethers.parseEther("1000000"), {
    gasPrice: 0
  });
  await mintTx1.wait();

  const mintTx2 = await nft.mint(await deployer.getAddress(), 1, { gasPrice: 0 });
  await mintTx2.wait();

  console.log("Minted initial ERC20 + ERC721 to deployer");
}

main().catch((err) => {
  console.error(err);
  process.exitCode = 1;
});

