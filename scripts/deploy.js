const { ethers, upgrades } = require("hardhat");


async function main() {
    const [deployer] = await ethers.getSigners();

  // const ERC721simple = await ethers.getContractFactory("ERC721simple");
  // const simple = await ERC721simple.deploy();
  // await simple.deployed();
  // console.log(simple.address);

    // const CrossChainNFT = await ethers.getContractFactory("CrossChainNFT");
    // const CCN = await CrossChainNFT.deploy();
    // await CCN.deployed();
    // console.log("CrossChainNFT Contract Address:", CCN.address);

    // const CrossChainImplementation = await ethers.getContractFactory("CrossChainImplementation");
    // const CCI = await upgrades.deployProxy(CrossChainImplementation);
    // await CCI.deployed();
    // console.log("CrossChainImplementation Contract Address:", CCI.address);



///////// upgrade /////////

    // // mainnet
    // const CrossChainImplementation = await ethers.getContractFactory("CrossChainImplementation");
    // const upgraded = await upgrades.upgradeProxy("0xDc2a2Fd72266EE8e17CC19067B20Df2F5F470e87", CrossChainImplementation);
    // console.log("CrossChainImplementation upgraded.");


    // mumbai
    const CrossChainImplementation = await ethers.getContractFactory("CrossChainImplementation");
    const upgraded = await upgrades.upgradeProxy("0x9beBDb3cD9ED9D487AcE7cABbe2aF718C3aF66A3", CrossChainImplementation);
    console.log("upgraded at : 0x9beBDb3cD9ED9D487AcE7cABbe2aF718C3aF66A3");

    // // rinkeby
    // const CrossChainImplementation = await ethers.getContractFactory("CrossChainImplementation");
    // const upgraded = await upgrades.upgradeProxy("0x2CC9CB8636E011C81588508E2dce053d05D4D4d0", CrossChainImplementation);
    // console.log("upgraded at : 0x2CC9CB8636E011C81588508E2dce053d05D4D4d0");
}
  
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });