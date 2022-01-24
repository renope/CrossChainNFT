// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "./CrossChainImplementationInterface.sol";
import "../CrossChainNFT/MintRedeemInterface.sol";
import "./Payment.sol";

contract CrossChainImplementation is CrossChainImplementationInterface, Payment{

    function version() public pure returns(string memory) {
        return "0.2.0";
    }

    MintRedeemInterface crossChain;

    
    /**
     * @dev Emitted to request the relayer to mint a wToken owned by `to` on `targetChainId`.
     */
    event RelayerCallSafeMintWrappedToken(
        uint256 targetChainId,
        address to,
        uint256 chainId,
        address contAddr,
        uint256 tokenId,
        string uri
    );

    /**
     * @dev Emitted to request the relayer to redeem the locked token and transfer it to `to`.
     */
    event RelayerCallRedeem(
        uint256 chainId,
        address contAddr,
        address to,
        uint256 tokenId
    );


    constructor(){
        crossChain = MintRedeemInterface(0x16539214c06b69b3bc4c2613cFE8a6BCf6d2A4aC); //CrossChainNFT on Fuji
    }

    function mintFee(uint256 targetChainId) public view returns(uint256){
        return _mintFee(targetChainId);
    }
    
    function redeemFee(uint256 targetChainId) public view returns(uint256){
        return _redeemFee(targetChainId);
    }

    
    function requestTransferCrossChain(
        uint256 targetChainId,
        address to,
        uint256 chainId,
        address contAddr,
        uint256 tokenId,
        string memory uri,
        address dappAddr
    ) public payable {
        _payMintFee(msg.value, targetChainId, dappAddr);

        emit RelayerCallSafeMintWrappedToken(
            targetChainId,
            to,
            chainId,
            contAddr,
            tokenId,
            uri
        );
    }

    function requestReleaseLockedToken(
        uint256 chainId,
        address contAddr,
        address to,
        uint256 tokenId,
        address dappAddr
    ) public payable{
        _payRedeemFee(msg.value, chainId, dappAddr);
        emit RelayerCallRedeem(chainId, contAddr, to, tokenId);
    }

    function redeem(address contAddr, address to, uint256 tokenId) public onlyOwner {
        crossChain.redeem(contAddr, to, tokenId);
    }


    function safeMintWrappedToken(
        uint256 chainId,
        address contAddr,
        address to,
        uint256 tokenId,
        string memory uri
    ) public onlyOwner {
        crossChain.safeMintWrappedToken(chainId, contAddr, to, tokenId, uri);
    }
}