// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "./WrapERC721DataStorage.sol";

abstract contract WrapERC721 is ERC721, ERC721Holder, WrapERC721DataStorage, Ownable{
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;

    address public relayer;

    constructor(address _relayer) {
        setRelayer(_relayer);
    }


    modifier onlyRelayer() {
        require(msg.sender == relayer, "restricted function to relayer");
        _;
    }

    //overriden function
    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, WrapERC721DataStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    /**
     * @dev Lock the `tokenId` of `contAddr` in this contract.
     * 
     * Requirements:
     *
     * - this contract should be approved by the owner of the token
     */
    function _lock(address contAddr, uint256 tokenId, address from) internal {
        IERC721 NFT = IERC721(contAddr);
        NFT.safeTransferFrom(from, address(this), tokenId);
    }

    /**
     * @dev Redeem the `tokenId` of `contAddr` and transfer it to `to`.
     * 
     * Requirements:
     *
     * - only relayer can call this function.
     */
    function redeem(address contAddr, uint256 tokenId, address to) public onlyRelayer {
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
     * - only relayer can call this function.
     */
    function safeMintWrappedToken(
        address to,
        uint256 chainId,
        address contAddr,
        uint256 tokenId,
        string memory uri
    ) public onlyRelayer returns(uint256 wTokenId) {
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

    /**
     * @dev Set a new relayer to do cross chain transactions.
     */
    function setRelayer(address newRelayer) public onlyOwner {
        relayer = newRelayer;
    }
}