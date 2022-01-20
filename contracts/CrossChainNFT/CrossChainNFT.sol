// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;


import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./WrapERC721.sol";
import "../implementation/CrossChainImplementationInterface.sol";

contract CrossChainNFT is Ownable, Pausable, WrapERC721 {

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


    constructor() 
        WrapERC721(0x75D0b767029305B2Ad067f6742e8e5B1BBdC5D3E)
        ERC721("Cross-Chain-NFT", "CCN")
    {
        implementation = CrossChainImplementationInterface(0x72753D08D630B4190a561c821Ad965161e2A5d6E); //implementation address on avalancheFujiTestnet
    }

    CrossChainImplementationInterface implementation;

    function newImplementation(address addr) public onlyOwner {
        implementation = CrossChainImplementationInterface(addr);
    }


    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }


    function requestTransferCrossChain(
        address contAddr,
        address from,
        uint256 targetChainId,
        address to,
        uint256 tokenId,
        uint256 dappId
    ) public payable {
        requestTransferCrossChain(
            contAddr,
            from,
            targetChainId,
            to,
            tokenId,
            dappId,
            ""
        );
    }

    function requestReleaseLockedToken(
        uint256 wTokenId,
        address to,
        uint256 dappId
    ) public payable {
        requestReleaseLockedToken(
            wTokenId,
            to,
            dappId,
            ""
        );
    }

    /**
     * @dev Lock the `tokenId` from `from` in this contract. `targetChainId` and transfer to `to`.
     * 
     *  WARNING:
     * 
     * - if `to` on `targetChainId` does not exist, token would be transfered back to `from` address.
     * - If `to` refers to a smart contract, it must implementation {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     * 
     * Requirements:
     *
     * - relayer transaction fee should be paid.
     * - `from` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
     *
     * Emits a {RelayerCallSafeMintWrappedToken} event.
     * the relayer uses this event to mint a wToken on the `targetChainId`.
     */
    function requestTransferCrossChain(
        address contAddr,
        address from,
        uint256 targetChainId,
        address to,
        uint256 tokenId,
        uint256 dappId,
        bytes memory data
    ) public payable whenNotPaused {

        _lock(contAddr, from, tokenId);

        uint256 chainId;
        assembly {chainId := chainid()}

        string memory uri = IERC721Metadata(contAddr).tokenURI(tokenId);

        implementation.requestTransferCrossChain{value : msg.value}(
            targetChainId,
            to,
            chainId,
            contAddr,
            tokenId,
            uri,
            dappId,
            data
        );

        emit RelayerCallSafeMintWrappedToken(
            targetChainId,
            to,
            chainId,
            contAddr,
            tokenId,
            uri
        );
    }

    /**
     * @dev Get back the wToken on current chainId.
     * 
     * Requirements:
     * 
     * - relayer transaction fee should be paid.
     * 
     * Emits a {RelayerCallRedeem} event.
     * the relayer uses this event to redeem the collateral token on the other chainId.
     */
    function requestReleaseLockedToken(
        uint256 wTokenId,
        address to,
        uint256 dappId,
        bytes memory data
    ) public payable {
        WrappedToken memory wToken = wrappedTokens[wTokenId];

        uint256 chainId = wToken.chainId;
        address contAddr = wToken.contAddr;
        uint256 tokenId = wToken.tokenId;

        _burnWrappedToken(wTokenId);

        implementation.requestReleaseLockedToken{value : msg.value}(
            chainId,
            contAddr,
            to,
            tokenId,
            dappId,
            data
        );

        emit RelayerCallRedeem(chainId, contAddr, to, tokenId);
    }
    

    /**
     * @dev Returns the data of wTokenId.
     */
    function getLockedTokenData(uint256 wTokenId) public view returns(
        uint256 chainId,
        address contAddr,
        uint256 tokenId,
        uint256 releaseGasFee
    ) {
        WrappedToken memory wToken = wrappedTokens[wTokenId];
        chainId = wToken.chainId;
        contAddr = wToken.contAddr;
        tokenId = wToken.tokenId;
        releaseGasFee = implementation.redeemFee(chainId);
    }
}