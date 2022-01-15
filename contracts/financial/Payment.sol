// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;


// import "./ChainLinkPriceFeed/EthereumPriceConsumer.sol";
// import "./ChainLinkPriceFeed/BinancePriceConsumer.sol";
// import "./ChainLinkPriceFeed/MaticPriceConsumer.sol";
// import "./ChainLinkPriceFeed/RinkebyPriceConsumer.sol";
import "./ChainLinkPriceFeed/MumbaiPriceConsumer.sol";

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "./IPayment.sol";

contract Payment is Initializable, IPayment,
// EthereumPriceConsumer,
// BinancePriceConsumer,
// MaticPriceConsumer,
// RinkebyPriceConsumer,
MumbaiPriceConsumer
{

    function initialize() initializer public {
        __Ownable_init();
    }


    int256 feeRatio;
    /**
     * @dev assigns the fee needed to the corresponding chain id.
     */
    mapping (uint256 => uint256) currentFee;


    function payFee(uint256 targetChainId, bytes memory data) external payable {
        require(msg.value >= getFee(targetChainId), "insufficient fee");
    }


    /**
     * @dev Returns the fee needed to transfer a token to the `targetChainId`.
     *
     * Requirements:
     *
     * - `targetChainId` should be supported by this contract.
     */
    function getFee(uint256 targetChainId) public view returns(uint256 fee) {
        // require(currentFee[targetChainId] != 0, "targetChainId not supported");
        return uint256(feeRatio * price(targetChainId));
    }

    /**
     * @dev Sets the fee needed to transfer a token to the `targetChainId`.
     *
     * Requirements:
     *
     * - only owner can call this function.
     */
    function setFeeRatio(int256 fee) public onlyOwner {
        feeRatio = fee;
    }



    /**
     * @dev Returns Eth supply of the contract
     */
    function totalSupply() public view returns(uint256){
        return address(this).balance;
    }

    /**
     * @dev Withdraw Eth paid by users.
     *
     * Requirements:
     *
     * - only owner can call this function.
     */
    function withdrawCash(address payable to) external onlyOwner {
        to.transfer(totalSupply());
    }
}