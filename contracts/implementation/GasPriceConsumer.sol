// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;


// gas prices of defferent chain ids 
abstract contract GasPriceConsumer {

    function __gasPriceConsumer_init() internal {
        _setGasPriceGwei(1, 2500000007); //tested on rinkeby, kovan 
        _setGasPriceGwei(56, 30000000000); //not tested...
        _setGasPriceGwei(137, 30000000000); //tested on polygon mainnet
        _setGasPriceGwei(43114, 30000000000); //not tested...
    }

    mapping(uint256 => uint256) chainIdToGasPriceGwei;

    function gasPrice(uint256 chainId) internal view returns(uint256){
        return chainIdToGasPriceGwei[chainId];
    }

    function _setGasPriceGwei(uint256 _chainId, uint256 _gasPrice) internal {
        chainIdToGasPriceGwei[_chainId] = _gasPrice;
    }
}