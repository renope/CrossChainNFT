// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "./PaymentData.sol";

contract Payment is PaymentData {

    /**
     * @dev Returns the fee needed to mint a token on the `targetChainId`.
     *
     * Requirements:
     *
     * - `targetChainId` should be supported by this contract.
     */
    function _mintFee(uint256 targetChainId) internal view returns(uint256 fee) {
        return feeRatio * mintGas * gasPrice(targetChainId) * price(targetChainId) / 10 ** 18;
    }


    /**
     * @dev Returns the fee needed to redeem a token on the `targetChainId`.
     *
     * Requirements:
     *
     * - `targetChainId` should be supported by this contract.
     */
    function _redeemFee(uint256 targetChainId) internal view returns(uint256 fee) {
        return feeRatio * mintGas * gasPrice(targetChainId) * price(targetChainId) / 10 ** 8;
    }


    /**
     * @dev Transfer most of value to the relayer to mint a wToken on other chain 
     * and the rest to the dapp as bonus.
     *
     * Requirements:
     *
     * - value should be more than minimum value needed to mint a wToken.
     */
    function _payMintFee(uint256 value, uint256 targetChainId, uint256 dappId) internal {
        uint256 minValue = _mintFee(targetChainId) * 90/100;
        require(value >= minValue, "insufficient fee");
        payable(owner()).transfer(minValue);
        dapps[dappId].transfer(value - minValue);
    }


    /**
     * @dev Transfer most of value to the relayer to redeem a token on other chain 
     * and the rest to the dapp as bonus.
     *
     * Requirements:
     *
     * - value should be more than minimum value needed to redeem a token.
     */
    function _payRedeemFee(uint256 value, uint256 targetChainId, uint256 dappId) internal {
        uint256 minValue = _redeemFee(targetChainId) * 90/100;
        require(value >= minValue, "insufficient fee");
        payable(owner()).transfer(minValue);
        dapps[dappId].transfer(value - minValue);
    }
}