// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorInterface.sol";


//addresses special for Polygon Mainnet
abstract contract MaticPriceConsumer {

    function __priceConsumer_init() internal {
        _setAggregator(1, 0xF9680D99D6C9589e2a93a78A04A279e509205945); // ETHUSD(1)
        _setAggregator(56, 0x82a6c4AF830caa6c97bb504425f6A66165C2c26e); // BNBUSD(56)
        _setAggregator(137, 0xAB594600376Ec9fD91F8e885dADF0CE036862dE0); // MATICUSD(137)
        _setPriceUSD(43114, 88.26 * 10 ** 8); // AVAXUSD(43114)
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