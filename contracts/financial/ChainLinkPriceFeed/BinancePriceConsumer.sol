// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorInterface.sol";


//addresses special for Binance Smart Chain Mainnet
abstract contract BinancePriceConsumer is OwnableUpgradeable {

    // AggregatorInterface constant ETHUSD = AggregatorInterface(0x9ef1B8c0E4F7dc8bF5719Ea496883DC6401d5b2e);
    // AggregatorInterface constant BNBUSD = AggregatorInterface(0x0567F2323251f0Aab15c8dFb1967E4e8A7D42aeE);
    // AggregatorInterface constant MATICUSD = AggregatorInterface(0x7CA57b0cA6367191c94C8914d7Df09A57655905f);

    // constructor () {
    //     addAggregator(1, 0x9ef1B8c0E4F7dc8bF5719Ea496883DC6401d5b2e);
    //     addAggregator(56, 0x0567F2323251f0Aab15c8dFb1967E4e8A7D42aeE);
    //     addAggregator(137, 0x7CA57b0cA6367191c94C8914d7Df09A57655905f);
    // }

    function __priceConsumer_init() internal {
        addAggregator(1, 0x9ef1B8c0E4F7dc8bF5719Ea496883DC6401d5b2e);
        addAggregator(56, 0x0567F2323251f0Aab15c8dFb1967E4e8A7D42aeE);
        addAggregator(137, 0x7CA57b0cA6367191c94C8914d7Df09A57655905f);
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