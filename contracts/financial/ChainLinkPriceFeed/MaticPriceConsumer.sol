// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorInterface.sol";


//addresses special for Polygon Mainnet
abstract contract MaticPriceConsumer is OwnableUpgradeable {

    // AggregatorInterface constant ETHUSD = AggregatorInterface(0xF9680D99D6C9589e2a93a78A04A279e509205945);
    // AggregatorInterface constant BNBUSD = AggregatorInterface(0x82a6c4AF830caa6c97bb504425f6A66165C2c26e);
    // AggregatorInterface constant MATICUSD = AggregatorInterface(0xAB594600376Ec9fD91F8e885dADF0CE036862dE0);

    // constructor () {
    //     addAggregator(1, 0xF9680D99D6C9589e2a93a78A04A279e509205945);
    //     addAggregator(56, 0x82a6c4AF830caa6c97bb504425f6A66165C2c26e);
    //     addAggregator(137, 0xAB594600376Ec9fD91F8e885dADF0CE036862dE0);
    // }

    function __priceConsumer_init() internal {
        addAggregator(1, 0xF9680D99D6C9589e2a93a78A04A279e509205945);
        addAggregator(56, 0x82a6c4AF830caa6c97bb504425f6A66165C2c26e);
        addAggregator(137, 0xAB594600376Ec9fD91F8e885dADF0CE036862dE0);
    }

    mapping(uint256 => AggregatorInterface) chainIdToAggregator;

    function price(uint256 targetChainId) public view returns(int256) {
        uint256 currentChainId;
        assembly {currentChainId := chainid()}
        return chainIdToAggregator[targetChainId].latestAnswer()
        / chainIdToAggregator[currentChainId].latestAnswer();
    }

    function addAggregator(uint256 chainId, address aggregatorAddress) public onlyOwner{
        chainIdToAggregator[chainId] = AggregatorInterface(aggregatorAddress);
    }
}