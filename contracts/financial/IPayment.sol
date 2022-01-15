// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

interface IPayment {

    function payFee(uint256 targetChainId, bytes memory data) external payable;

    /**
     * @dev Returns the fee needed to transfer a token to the `targetChainId`.
     *
     * Requirements:
     *
     * - `targetChainId` should be supported by this contract.
     */
    function getFee(uint256 targetChainId) external view returns(uint256 fee);
} 