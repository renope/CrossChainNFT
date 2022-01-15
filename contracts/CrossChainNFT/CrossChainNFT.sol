// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;


import "@openzeppelin/contracts/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./WrapERC721.sol";
import "../financial/IPayment.sol";

contract CrossChainNFT is Ownable, WrapERC721 {

    function version() public pure returns(string memory) {
        return "1.0.0";
    }

    IPayment payment;

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
     * @dev Emitted to request the relayer to redeem the collateral token and transfer it to `to`.
     */
    event RelayerCallRedeem(
        uint256 chainId,
        address contAddr,
        uint256 tokenId,
        address to
    );


    constructor() 
        WrapERC721(0x75D0b767029305B2Ad067f6742e8e5B1BBdC5D3E)
        ERC721("Cross-Chain-NFT", "CCN")
    {
        payment = IPayment(address(0));
    }
    


    function transferCrossChainRequest(
        address contAddr,
        uint256 tokenId,
        address from,
        address to,
        uint256 targetChainId
    ) public payable {
        transferCrossChainRequest(
            contAddr,
            tokenId,
            from,
            to,
            targetChainId,
            ""
        );
    }

    /**
     * @dev Lock the `tokenId` from `from` in this contract. `targetChainId` and transfer to `to`.
     * 
     *  WARNING:
     * 
     * - if `to` on `targetChainId` does not exist, token would be transfered back to `from` address.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
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
    function transferCrossChainRequest(
        address contAddr,
        uint256 tokenId,
        address from,
        address to,
        uint256 targetChainId,
        bytes memory data
    ) public payable {

        payment.payFee{value : msg.value}(targetChainId, data);

        _lock(contAddr, tokenId, from);
        uint256 chainId;
        assembly {chainId := chainid()}
        emit RelayerCallSafeMintWrappedToken(
            targetChainId,
            to,
            chainId,
            contAddr,
            tokenId,
            IERC721Metadata(contAddr).tokenURI(tokenId)
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
        bytes memory data
    ) public payable {
        WrappedToken memory wToken = wrappedTokens[wTokenId];

        payment.payFee{value : msg.value}(wToken.chainId, data);

        uint256 chainId = wToken.chainId;
        address contAddr = wToken.contAddr;
        uint256 tokenId = wToken.tokenId;

        _burnWrappedToken(wTokenId);

        emit RelayerCallRedeem(chainId, contAddr, tokenId, to);
    }
}