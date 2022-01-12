// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;


import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";

abstract contract WrapERC721DataStorageUpgradeable is Initializable, ERC721Upgradeable {

    function __WrapERC721DataStorage_init() internal onlyInitializing {
        __Context_init_unchained();
        __ERC165_init_unchained();
        __WrapERC721DataStorage_init_unchained();
    }

    function __WrapERC721DataStorage_init_unchained() internal onlyInitializing {
    }

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

    function _setwTokenData(
        uint256 _wTokenId,
        uint256 _chainId,
        address _contAddr,
        uint256 _tokenId,
        string memory _uri
    ) internal {
        wrappedTokens[_wTokenId] = WrappedToken(_chainId, _contAddr, _tokenId, _uri);
        emit TokenWrapped(_wTokenId);
    }

    function getwTokenData(uint256 wTokenId) public view returns(
        uint256 chainId,
        address contAddr,
        uint256 tokenId,
        string memory uri
    ) {
        WrappedToken memory wToken = wrappedTokens[wTokenId];
        chainId = wToken.chainId;
        contAddr = wToken.contAddr;
        tokenId = wToken.tokenId;
        uri = wToken.uri;
    }

    function _burnTokenData(uint256 _wTokenId) internal {
        delete wrappedTokens[_wTokenId];
        emit WTokenBurned(_wTokenId);
    }
}