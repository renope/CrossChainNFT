// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;



// import "./ChainLinkPriceFeed/mainnet/EthereumPriceConsumer.sol";
// import "./ChainLinkPriceFeed/mainnet/BinancePriceConsumer.sol";
// import "./ChainLinkPriceFeed/mainnet/MaticPriceConsumer.sol";
// import "./ChainLinkPriceFeed/mainnet/AvalanchePriceConsumer.sol";
// import "./ChainLinkPriceFeed/testnet/RinkebyPriceConsumer.sol";
import "./ChainLinkPriceFeed/testnet/MumbaiPriceConsumer.sol";
// import "./ChainLinkPriceFeed/testnet/FujiPriceConsumer.sol";
import "./GasPriceConsumer.sol";

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";


contract PaymentData is GasPriceConsumer, Initializable, OwnableUpgradeable,
// EthereumPriceConsumer
// BinancePriceConsumer
// MaticPriceConsumer
// RinkebyPriceConsumer
MumbaiPriceConsumer
// FujiPriceConsumer
{


    function __PaymentData_init() internal onlyInitializing  {
        _setDappPercent(10);
        _setFeeRatio(2);
        _setMintGas(59536); //not tested
        _setRedeemGas(59536); //not tested
    }


    /**
     * @dev set every variable in the contract by the relayer in one transaction.
     */
    function set(
        uint256 _mintGas,
        uint256 _redeemGas,
        uint256 _feeRatio,
        uint256 _dappPercent,
        uint256[] memory dappIds,
        address[] memory dappAddresses,
        uint256[] memory aggregatorChainIds,
        address[] memory aggregatorAddresses,
        uint256[] memory coinChainIds,
        int256[] memory coinPricesUSD
    ) public onlyOwner {
        require(dappIds.length == dappAddresses.length, "dapp arrays are not same length.");
        require(aggregatorChainIds.length == aggregatorAddresses.length, "aggregator arrays are not same length.");
        require(coinChainIds.length == coinPricesUSD.length, "coin price arrays are not same length.");
        _setMintGas(_mintGas);
        _setRedeemGas(_redeemGas);
        _setFeeRatio(_feeRatio);
        _setDappPercent(_dappPercent);
        for(uint256 i = 0; i < dappIds.length; i++){
            _setDapp(dappIds[i], dappAddresses[i]);
        }
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

    mapping(uint256 => address payable) dapps;
    function _setDapp(uint256 _dappId, address _dappAddress) internal {
        dapps[_dappId] = payable(_dappAddress);
    }
}