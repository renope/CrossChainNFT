// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "./WrapERC721DataStorage.sol";
import "../implementation/CrossChainImplementationInterface.sol";



/**
 * @dev this is a multi chain contract. when an NFT locks in a contract on a chain; its corresponding
 * wToken will be minted in the other chain. and when the wToken burns in a chain; the real NFT will
 * be redeemed in its own chain.
 */
abstract contract WrapERC721 is ERC721Holder, WrapERC721DataStorage, Ownable{
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;

    address public implementationAddr;
    CrossChainImplementationInterface implementation;

    /**
     * @dev Set a new implementationAddr to do cross chain transactions.
     */
    function setImplementation(address _implementationAddr) public onlyOwner {
        implementationAddr = _implementationAddr;
        implementation = CrossChainImplementationInterface(_implementationAddr); //implementation address
    }

    modifier onlyImplementation() {
        require(msg.sender == implementationAddr, "restricted function to implementationAddr");
        _;
    }


    /**
     * @dev Lock the `tokenId` of `contAddr` in this contract.
     * 
     * Requirements:
     *
     * - this contract should be approved by the owner of the token
     */
    function _lock(address contAddr, address from, uint256 tokenId) internal {
        IERC721 NFT = IERC721(contAddr);
        NFT.safeTransferFrom(from, address(this), tokenId);
    }

    /**
     * @dev Redeem the `tokenId` of `contAddr` and transfer it to `to`.
     * 
     * Requirements:
     *
     * - only implementationAddr can call this function.
     */
    function redeem(address contAddr, address to, uint256 tokenId) public onlyImplementation {
        IERC721 NFT = IERC721(contAddr);
        NFT.safeTransferFrom(address(this), to, tokenId);
    }


    /**
     * @dev SafeMint a wToken and transfer it to `to`.
     * 
     * wToken holds the the data of real token.
     * 
     * Requirements:
     *
     * - only implementationAddr can call this function.
     */
    function safeMintWrappedToken(
        uint256 chainId,
        address contAddr,
        address to,
        uint256 tokenId,
        string memory uri
    ) public onlyImplementation returns(uint256 wTokenId) {
        wTokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, wTokenId);
        _setwTokenData(wTokenId, chainId, contAddr, tokenId, uri);
    }

    /**
     * @dev Recycle the `wTokenId`.
     * 
     * Requirements:
     *
     * - caller should be owner or approved by the owner.
     */
    function _burnWrappedToken(uint256 wTokenId) internal {
        require(_isApprovedOrOwner(_msgSender(), wTokenId), "ERC721Burnable: caller is not owner nor approved");
        _burn(wTokenId);
        _burnTokenData(wTokenId);
    }
}