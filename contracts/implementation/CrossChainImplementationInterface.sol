// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

interface CrossChainImplementationInterface {
    
    function requestTransferCrossChain(
        uint256 targetChainId,
        address to,
        uint256 chainId,
        address contAddr,
        uint256 tokenId,
        string memory uri,
        address dappAddr
    ) external payable;

    function requestReleaseLockedToken(
        uint256 chainId,
        address contAddr,
        address to,
        uint256 tokenId,
        address dappAddr
    ) external payable;

    function mintFee(uint256 targetChainId) external view returns(uint256);
    
    function redeemFee(uint256 targetChainId) external view returns(uint256);
} 