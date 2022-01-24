// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorInterface.sol";


// addresses special for Avalanche fuji testnet 
abstract contract FujiPriceConsumer {


    function __priceConsumer_init() internal {
        _setAggregator(4, 0x86d67c3D38D2bCeE722E601025C25a575021c6EA); // rinkeby ETHUSD(4)
        _setAggregator(43113, 0x5498BB86BC934c8D34FDA08E81D444153d0D06aD); // fuji AVAXUSD(43113)
        _setPriceUSD(80001, 2.28 * 10 ** 8); // mumbai MATICUSD(80001)
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