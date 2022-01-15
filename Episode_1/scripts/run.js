// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");

async function main() {
  // Hardhat always runs the compile task when running scripts with its command
  // line interface.
  //
  // If this script is run directly using `node` you may want to call compile
  // manually to make sure everything is compiled
  // await hre.run('compile');

  // We get the contract to deploy
  const NFTContract = await hre.ethers.getContractFactory("NFT");
  const nftContract = await NFTContract.deploy(
    "MelkeyNFT",
    "MELK",
    "www.example.com",
    "www.example/hidden.com"
  );

  await nftContract.deployed();

  console.log("NFT deployed to:", nftContract.address);

  await nftContract.mint(1);
  await nftContract.mint(3);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
