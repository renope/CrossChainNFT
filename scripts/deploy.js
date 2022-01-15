const { ethers, upgrades } = require("hardhat");


async function main() {
    const [deployer] = await ethers.getSigners();

    // const CrossChainNFT = await ethers.getContractFactory("CrossChainNFT");
    // const CCN = await CrossChainNFT.deploy();
    // console.log("CrossChainNFT Contract Address:", CCN.address);

    // const CrossChainNFTUpgradeable = await ethers.getContractFactory("CrossChainNFTUpgradeable");
    // const CCNU = await upgrades.deployProxy(CrossChainNFTUpgradeable);
    // await CCNU.deployed();
    // console.log("CrossChainNFTUpgradeable Contract Address:", CCNU.address);


    // // mainnet
    // const CrossChainNFTUpgradeable = await ethers.getContractFactory("CrossChainNFTUpgradeable");
    // const upgraded = await upgrades.upgradeProxy("0xDc2a2Fd72266EE8e17CC19067B20Df2F5F470e87", CrossChainNFTUpgradeable);
    // console.log("CrossChainNFTUpgradeable upgraded.");


    // // mumbai
    // const CrossChainNFTUpgradeable = await ethers.getContractFactory("CrossChainNFTUpgradeable");
    // const upgraded = await upgrades.upgradeProxy("0x747B9900E1d77FAd241ed4C632b08B75bc45de8b", CrossChainNFTUpgradeable);
    // console.log("CrossChainNFTUpgradeable upgraded.");


    // rinkeby
    const CrossChainNFTUpgradeable = await ethers.getContractFactory("CrossChainNFTUpgradeable");
    const upgraded = await upgrades.upgradeProxy("0xa8ED58AEea81B8ddcb17Bda7a1E05Cf8549578B9", CrossChainNFTUpgradeable);
    console.log("CrossChainNFTUpgradeable upgraded.");
}
  
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });