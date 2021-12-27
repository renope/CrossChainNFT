// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;


import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

abstract contract WrapERC721DataStorage is ERC721 {

    struct WrappedToken {
        uint256 chainId;
        address contAddr;
        uint256 tokenId;
        string uri;
    }

    mapping(uint256 => WrappedToken) wrappedTokens;

    event TokenWrapped(uint256 wTokenId);
    event WTokenBurned(uint256 wTokenId);


    /**
     * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
     */
    function tokenURI(uint256 wTokenId) public view virtual override returns (string memory){
        require(_exists(wTokenId), "ERC721Metadata: URI query for nonexistent token");
        return wrappedTokens[wTokenId].uri;
    }

    function _setwTokendata(
        uint256 _wTokenId,
        uint256 _chainId,
        address _contAddr,
        uint256 _tokenId,
        string memory _uri
    ) internal {
        wrappedTokens[_wTokenId] = WrappedToken(_chainId, _contAddr, _tokenId, _uri);
        emit TokenWrapped(_wTokenId);
    }

    function _burnTokenData(uint256 _wTokenId) internal {
        delete wrappedTokens[_wTokenId];
        emit WTokenBurned(_wTokenId);
    }
}