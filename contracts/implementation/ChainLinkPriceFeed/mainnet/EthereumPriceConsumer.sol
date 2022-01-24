// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorInterface.sol";


// addresses special for Ethereum Mainnet 
abstract contract EthereumPriceConsumer {

    constructor() {
        _setAggregator(1, 0xF9680D99D6C9589e2a93a78A04A279e509205945); // ETHUSD(1)
        _setAggregator(56, 0x14e613AC84a31f709eadbdF89C6CC390fDc9540A); // BNBUSD(56)
        _setAggregator(137, 0x7bAC85A8a13A4BcD8abb3eB7d6b4d632c5a57676); // MATICUSD(137)
        _setAggregator(43114, 0xFF3EEb22B5E3dE6e705b44749C2559d704923FD7); // AVAXUSD(43114)
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