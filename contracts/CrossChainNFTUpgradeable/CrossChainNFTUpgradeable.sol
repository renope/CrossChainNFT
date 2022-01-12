// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/IERC721MetadataUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "./WrapERC721Upgradeable.sol";

contract CrossChainNFTUpgradeable is OwnableUpgradeable, WrapERC721Upgradeable {

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


    constructor(){}
    function initialize() initializer public {
        __WrapERC721_init(0x75D0b767029305B2Ad067f6742e8e5B1BBdC5D3E);
        __ERC721_init("CrossChainNFTUpgradeable", "CCN");
        __WrapERC721DataStorage_init();
        __Ownable_init();
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
        uint256 targetChainId
    ) public payable {
        require(msg.value >= getFee(targetChainId));
        _lock(contAddr, tokenId, from);
        uint256 chainId;
        assembly {chainId := chainid()}
        emit RelayerCallSafeMintWrappedToken(
            targetChainId,
            to,
            chainId,
            contAddr,
            tokenId,
            IERC721MetadataUpgradeable(contAddr).tokenURI(tokenId)
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
    function wReturnCrossChainRequest(
        uint256 wTokenId,
        address to
    ) public payable {
        WrappedToken memory wToken = wrappedTokens[wTokenId];
        require(msg.value >= getFee(wToken.chainId), "insufficient fee");

        uint256 chainId = wToken.chainId;
        address contAddr = wToken.contAddr;
        uint256 tokenId = wToken.tokenId;

        burnWrappedToken(wTokenId);

        emit RelayerCallRedeem(chainId, contAddr, tokenId, to);
    }


    /**
     * @dev assigns the fee needed to the corresponding chain id.
     */
    mapping (uint256 => uint256) currentFee;

    /**
     * @dev Returns the fee needed to transfer a token to the `targetChainId`.
     *
     * Requirements:
     *
     * - `targetChainId` should be supported by this contract.
     */
    function getFee(uint256 targetChainId) public view returns(uint256 fee) {
        // require(currentFee[targetChainId] != 0, "targetChainId not supported");
        fee = currentFee[targetChainId];
    }

    /**
     * @dev Sets the fee needed to transfer a token to the `targetChainId`.
     *
     * Requirements:
     *
     * - only owner can call this function.
     */
    function setFee(uint256 targetChainId, uint256 fee) public onlyOwner {
        currentFee[targetChainId] = fee;
    }

    /**
     * @dev multiple transaction version of `setFee()`.
     */
    function setFees(uint256[] memory targetChainIds, uint256[] memory fees) public onlyOwner {
        require(targetChainIds.length == fees.length, "arrays are not in the same lenght");
        for(uint256 index = 0; index <= targetChainIds.length; index++){
            setFee(targetChainIds[index], fees[index]);
        }
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