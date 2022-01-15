// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorInterface.sol";


//addresses special for Rinkeby Testnet
abstract contract RinkebyPriceConsumer is OwnableUpgradeable {

    // AggregatorInterface constant ETHUSD = AggregatorInterface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
    // AggregatorInterface constant BNBUSD = AggregatorInterface(0xcf0f51ca2cDAecb464eeE4227f5295F2384F84ED);
    // AggregatorInterface constant MATICUSD = AggregatorInterface(0x7bAC85A8a13A4BcD8abb3eB7d6b4d632c5a57676);

    // constructor () {
    //     addAggregator(1, 0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
    //     addAggregator(56, 0xcf0f51ca2cDAecb464eeE4227f5295F2384F84ED);
    //     addAggregator(137, 0x7bAC85A8a13A4BcD8abb3eB7d6b4d632c5a57676);
    // }

    function __priceConsumer_init() internal {
        addAggregator(1, 0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
        addAggregator(56, 0xcf0f51ca2cDAecb464eeE4227f5295F2384F84ED);
        addAggregator(137, 0x7bAC85A8a13A4BcD8abb3eB7d6b4d632c5a57676);
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