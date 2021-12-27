const { ethers, upgrades } = require("hardhat");


async function main() {
    const [deployer] = await ethers.getSigners();

    const CrossChainNFT = await ethers.getContractFactory("CrossChainNFT");
    const CCh = await CrossChainNFT.deploy();
    console.log("CrossChainNFT Contract Address:", CCh.address);

    // const NFTTransparent = await ethers.getContractFactory("NFTTransparent");
    // const Transparent = await upgrades.deployProxy(NFTTransparent);
    // await Transparent.deployed();
    // console.log("NFTTransparent Contract Address:", Transparent.address);

    // const NFTTransparent2 = await ethers.getContractFactory("NFTTransparent");
    // const upgraded = await upgrades.upgradeProxy("0x65A52682Df507552d37FC2235eF2bC7FfD4BF181", NFTTransparent2);
    // console.log("upgraded.");
}
  
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });