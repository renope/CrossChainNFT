// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/utils/ERC721HolderUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/CountersUpgradeable.sol";
import "./WrapERC721DataStorageUpgradeable.sol";

abstract contract WrapERC721Upgradeable is Initializable, ERC721Upgradeable, ERC721HolderUpgradeable, WrapERC721DataStorageUpgradeable, OwnableUpgradeable{
    using CountersUpgradeable for CountersUpgradeable.Counter;
    CountersUpgradeable.Counter private _tokenIdCounter;

    address public relayer;

    function __WrapERC721_init(address _relayer) internal onlyInitializing {
        relayer = _relayer;
    }


    modifier onlyRelayer() {
        require(msg.sender == relayer, "restricted function to relayer");
        _;
    }

    //overriden function
    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721Upgradeable, WrapERC721DataStorageUpgradeable)
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
        IERC721Upgradeable NFT = IERC721Upgradeable(contAddr);
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
        IERC721Upgradeable NFT = IERC721Upgradeable(contAddr);
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
        _setwTokendata(wTokenId, chainId, contAddr, tokenId, uri);
    }

    /**
     * @dev Recycle the `wTokenId`.
     * 
     * Requirements:
     *
     * - caller should be owner or approved by the owner.
     */
    function burnWrappedToken(uint256 wTokenId) public {
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