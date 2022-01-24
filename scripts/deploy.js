const { ethers, upgrades } = require("hardhat");


async function main() {
    const [deployer] = await ethers.getSigners();

    // const CrossChainNFT = await ethers.getContractFactory("CrossChainNFT");
    // const CCN = await CrossChainNFT.deploy();
    // await CCN.deployed();
    // console.log("CrossChainNFT Contract Address:", CCN.address);

    const CrossChainImplementation = await ethers.getContractFactory("CrossChainImplementation");
    const CCI = await CrossChainImplementation.deploy();
    await CCI.deployed();
    console.log("CrossChainImplementation Contract Address:", CCI.address);
}
  
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });