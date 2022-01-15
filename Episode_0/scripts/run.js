const main = async () => {
  const NFTContract = await hre.ethers.getContractFactory("NFT");
  // we need to put in our constructor arguements
  const nftContract = await NFTContract.deploy(
    "MelkyNFT",
    "MELK",
    "ipfs://abcdefh"
  );
  await nftContract.deployed();

  // to get the address of the contract
  console.log("Contract has been deployed to:", nftContract.address);

  const ownerBalance = await nftContract.balanceOf(nftContract.address);
  console.log(ownerBalance);

  await nftContract.mintNFT();
  await nftContract.mintNFT();
  await nftContract.mintNFT();
  await nftContract.mintNFT();
};

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
};

runMain();
