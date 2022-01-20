// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;


import "@openzeppelin/contracts/token/ERC721/ERC721.sol";


/**
 * @dev Every wToken is representing a real NFT which holds its data in this contract. 
 * when a wToken mints, its data sets and when a wToken burns its data will be burned too.
 */
abstract contract WrapERC721DataStorage is ERC721 {

    struct WrappedToken {
        uint256 chainId;
        address contAddr;
        uint256 tokenId;
        string uri;
    }

    mapping(uint256 => WrappedToken) wrappedTokens;


    event TokenData(
        uint256 wTokenId,
        uint256 chainId,
        address contAddr,
        uint256 tokenId,
        string uri
    );


    /**
     * @dev wTokens returns the uri of real NFTs representing.
     */
    function tokenURI(uint256 wTokenId) public view virtual override returns (string memory){
        require(_exists(wTokenId), "ERC721Metadata: URI query for nonexistent token");
        return wrappedTokens[wTokenId].uri;
    }

    function _setwTokenData(
        uint256 _wTokenId,
        uint256 _chainId,
        address _contAddr,
        uint256 _tokenId,
        string memory _uri
    ) internal {
        wrappedTokens[_wTokenId] = WrappedToken(_chainId, _contAddr, _tokenId, _uri);
        emit TokenData(_wTokenId, _chainId, _contAddr, _tokenId, _uri);
    }

    function _burnTokenData(uint256 _wTokenId) internal {
        delete wrappedTokens[_wTokenId];
    }
}