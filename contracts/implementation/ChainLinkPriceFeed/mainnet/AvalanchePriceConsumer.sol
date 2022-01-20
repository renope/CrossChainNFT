// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorInterface.sol";


// addresses special for Avalanche Mainnet 
abstract contract AvalanchePriceConsumer {


    function __priceConsumer_init() internal {
        _setAggregator(1, 0x976B3D034E162d8bD72D6b9C989d545b839003b0); // ETHUSD(1)
        _setAggregator(43114, 0x0A77230d17318075983913bC2145DB16C7366156); // AVAXUSD(43114)
        _setPriceUSD(56, 472.77 * 10 ** 8); // BNBUSD(56)
        _setPriceUSD(137, 2.28 * 10 ** 8); // MATICUSD(137)
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
        return uint256(_priceUSD(targetChainId) / _priceUSD(currentChainId) * 10 ** 18);
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