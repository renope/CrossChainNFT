// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorInterface.sol";


//addresses special for Binance Smart Chain Mainnet
abstract contract BinancePriceConsumer {


    function __priceConsumer_init() internal {
        _setAggregator(1, 0x9ef1B8c0E4F7dc8bF5719Ea496883DC6401d5b2e); // ETHUSD(1)
        _setAggregator(56, 0x0567F2323251f0Aab15c8dFb1967E4e8A7D42aeE); // BNBUSD(56)
        _setAggregator(137, 0x7CA57b0cA6367191c94C8914d7Df09A57655905f); // MATICUSD(137)
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