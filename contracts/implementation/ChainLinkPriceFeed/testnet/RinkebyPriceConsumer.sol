// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorInterface.sol";


//addresses special for Rinkeby Testnet
abstract contract RinkebyPriceConsumer {

    // ETHUSD(1) = 0x8A753747A1Fa494EC906cE90E9f37563A8AF630e;
    // BNBUSD(56) = 0xcf0f51ca2cDAecb464eeE4227f5295F2384F84ED;
    // MATICUSD(137) = 0x7bAC85A8a13A4BcD8abb3eB7d6b4d632c5a57676;


    function __priceConsumer_init() internal {
        _setAggregator(4, 0x8A753747A1Fa494EC906cE90E9f37563A8AF630e); // mumbai MATICUSD(80001)
        _setAggregator(80001, 0x7bAC85A8a13A4BcD8abb3eB7d6b4d632c5a57676); // rinkeby ETHUSD(4)
        _setPriceUSD(43113, 88.26 * 10 ** 8); // fuji AVAXUSD(43113)
    }

    mapping(uint256 => AggregatorInterface) chainIdToAggregator;
    mapping(uint256 => int256) chainIdToPrice;


    /**
     * @dev Returns the price of the coin of `targetchainId` with 8 decimal places.
     */
    function price(uint256 targetChainId) public view returns(uint256) {
        require(_priceUSD(targetChainId) != 0, "chain Id not supported");
        uint256 currentChainId;
        assembly {currentChainId := chainid()}
        return uint256(_priceUSD(targetChainId) / _priceUSD(currentChainId) * 10 ** 8);
    }

    function _priceUSD(uint256 chainId) internal view returns(int256) {
        return chainIdToAggregator[chainId] != AggregatorInterface(address(0)) ?
        chainIdToAggregator[chainId].latestAnswer() :
        chainIdToPrice[chainId];
    }

    function _setAggregator(uint256 chainId, address aggregatorAddress) internal{
        chainIdToAggregator[chainId] = AggregatorInterface(aggregatorAddress);
    }

    function _setPriceUSD(uint256 chainId, int256 priceUSD) internal{
        chainIdToPrice[chainId] = priceUSD;
    }
}