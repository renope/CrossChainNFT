// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorInterface.sol";


//addresses special for Polygon Mumbai
abstract contract MumbaiPriceConsumer {


    constructor() {
        _setAggregator(4, 0x0715A7794a1dc8e42615F059dD6e406A6594651A); // mumbai MATICUSD(80001)
        _setAggregator(80001, 0xd0D5e3DB44DE05E9F294BB0a3bEEaF030DE24Ada); // rinkeby ETHUSD(4)
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
        return uint256(_priceUSD(targetChainId) * 10 ** 18 / _priceUSD(currentChainId));
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