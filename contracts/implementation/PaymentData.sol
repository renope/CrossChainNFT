// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;



// import "./ChainLinkPriceFeed/mainnet/EthereumPriceConsumer.sol";
// import "./ChainLinkPriceFeed/mainnet/BinancePriceConsumer.sol";
// import "./ChainLinkPriceFeed/mainnet/MaticPriceConsumer.sol";
// import "./ChainLinkPriceFeed/mainnet/AvalanchePriceConsumer.sol";
// import "./ChainLinkPriceFeed/testnet/RinkebyPriceConsumer.sol";
// import "./ChainLinkPriceFeed/testnet/MumbaiPriceConsumer.sol";
import "./ChainLinkPriceFeed/testnet/FujiPriceConsumer.sol";
import "./GasPriceConsumer.sol";

import "@openzeppelin/contracts/access/Ownable.sol";


contract PaymentData is GasPriceConsumer, Ownable,
    // EthereumPriceConsumer
    // BinancePriceConsumer
    // MaticPriceConsumer
    // RinkebyPriceConsumer
    // MumbaiPriceConsumer
    FujiPriceConsumer
{


    constructor()  {
        _setDappPercent(10);
        _setFeeRatio(2);
        _setMintGas(260000); //not tested
        _setRedeemGas(260000); //not tested
    }


    /**
     * @dev set every variable in the contract by the relayer in one transaction.
     */
    function set(
        uint256 _mintGas,
        uint256 _redeemGas,
        uint256 _feeRatio,
        uint256 _dappPercent,
        uint256[] memory aggregatorChainIds,
        address[] memory aggregatorAddresses,
        uint256[] memory coinChainIds,
        int256[] memory coinPricesUSD
    ) public onlyOwner {
        require(aggregatorChainIds.length == aggregatorAddresses.length, "aggregator arrays are not same length.");
        require(coinChainIds.length == coinPricesUSD.length, "coin price arrays are not same length.");
        
        if(_mintGas != 0){_setMintGas(_mintGas);}
        if(_redeemGas != 0){_setRedeemGas(_redeemGas);}
        if(_feeRatio != 0){_setFeeRatio(_feeRatio);}
        if(_dappPercent != 0){_setDappPercent(_dappPercent);}

        for(uint256 i = 0; i < aggregatorChainIds.length; i++){
            _setAggregator(aggregatorChainIds[i], aggregatorAddresses[i]);
        }
        for(uint256 i = 0; i < coinChainIds.length; i++){
            _setPriceUSD(coinChainIds[i], coinPricesUSD[i]);
        }
    }



    uint256 mintGas;
    function _setMintGas(uint256 _mintGas) internal{
        mintGas = _mintGas;
    }

    uint256 redeemGas;
    function _setRedeemGas(uint256 _redeemGas) internal{
        redeemGas = _redeemGas;
    }

    uint256 feeRatio;
    function _setFeeRatio(uint256 _feeRatio) internal{
        feeRatio = _feeRatio;
    }

    uint256 dappPercent;
    function _setDappPercent(uint256 _dappPercent) internal{
        dappPercent = _dappPercent;
    }
}