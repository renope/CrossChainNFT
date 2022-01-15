// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorInterface.sol";


//addresses special for Polygon Mumbai
abstract contract MumbaiPriceConsumer is OwnableUpgradeable {

    // AggregatorInterface constant ETHUSD = AggregatorInterface(0x0715A7794a1dc8e42615F059dD6e406A6594651A);
    // AggregatorInterface constant MATICUSD = AggregatorInterface(0xd0D5e3DB44DE05E9F294BB0a3bEEaF030DE24Ada);

    // constructor () {
    //     addAggregator(4, 0x0715A7794a1dc8e42615F059dD6e406A6594651A);
    //     addAggregator(80001, 0xd0D5e3DB44DE05E9F294BB0a3bEEaF030DE24Ada);
    // }

    function __priceConsumer_init() internal {
        addAggregator(4, 0x0715A7794a1dc8e42615F059dD6e406A6594651A);
        addAggregator(80001, 0xd0D5e3DB44DE05E9F294BB0a3bEEaF030DE24Ada);
    }

    mapping(uint256 => AggregatorInterface) chainIdToAggregator;

    function price(uint256 targetChainId) public view returns(int256) {
        // require(chainIdToAggregator[targetChainId] != AggregatorInterface(address(0)), "no aggregator by this chain id regestered");
        uint256 currentChainId;
        assembly {currentChainId := chainid()}
        return chainIdToAggregator[targetChainId].latestAnswer()
        / chainIdToAggregator[currentChainId].latestAnswer();
    }

    function addAggregator(uint256 chainId, address aggregatorAddress) public onlyOwner{
        chainIdToAggregator[chainId] = AggregatorInterface(aggregatorAddress);
    }
}