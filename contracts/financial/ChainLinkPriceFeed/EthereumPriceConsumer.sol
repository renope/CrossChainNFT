// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorInterface.sol";


//addresses special for Ethereum Mainnet
abstract contract EthereumPriceConsumer is OwnableUpgradeable {

    // AggregatorInterface constant ETHUSD = AggregatorInterface(0xF9680D99D6C9589e2a93a78A04A279e509205945);
    // AggregatorInterface constant BNBUSD = AggregatorInterface(0x14e613AC84a31f709eadbdF89C6CC390fDc9540A);
    // AggregatorInterface constant MATICUSD = AggregatorInterface(0x7bAC85A8a13A4BcD8abb3eB7d6b4d632c5a57676);

    // constructor () {
    //     addAggregator(1, 0xF9680D99D6C9589e2a93a78A04A279e509205945);
    //     addAggregator(56, 0x14e613AC84a31f709eadbdF89C6CC390fDc9540A);
    //     addAggregator(137, 0x7bAC85A8a13A4BcD8abb3eB7d6b4d632c5a57676);
    // }

    function __priceConsumer_init() internal {
        addAggregator(1, 0xF9680D99D6C9589e2a93a78A04A279e509205945);
        addAggregator(56, 0x14e613AC84a31f709eadbdF89C6CC390fDc9540A);
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