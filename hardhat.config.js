require("@nomiclabs/hardhat-waffle");
require("@nomiclabs/hardhat-etherscan");
require('@openzeppelin/hardhat-upgrades');

const { PRIVATE_KEY, ALCHEMY_API_KEY, POLYGONSCAN_API_KEY, ETHERSCAN_API_KEY } = require('./secret.json');

module.exports = {
  solidity: "0.8.11",
  networks: {
    mainnet: {
      url: `https://polygon-mainnet.g.alchemy.com/v2/${ALCHEMY_API_KEY}`,
      accounts: [`0x${PRIVATE_KEY}`],
    },
    mumbai: {
      url: `https://polygon-mumbai.g.alchemy.com/v2/${ALCHEMY_API_KEY}`,
      accounts: [`0x${PRIVATE_KEY}`],
    },
    rinkeby: {
      url: `https://eth-rinkeby.alchemyapi.io/v2/${ALCHEMY_API_KEY}`,
      accounts: [`0x${PRIVATE_KEY}`],
    },
    kovan: {
      url: `https://eth-kovan.alchemyapi.io/v2/${ALCHEMY_API_KEY}`,
      accounts: [`0x${PRIVATE_KEY}`],
    },
  },
  etherscan: {
    // Your API key for Polygonscan
    // Obtain one at https://polygonscan.com/ for polygon networks
    apiKey: `${POLYGONSCAN_API_KEY}`
    // Your API key for Etherscan
    // Obtain one at https://polygonscan.com/ for polygon networks
    // apiKey: `${ETHERSCAN_API_KEY}`
  },
};
