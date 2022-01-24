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
interface MintRedeemInterface {

    /**
     * @dev Redeem the `tokenId` of `contAddr` and transfer it to `to`.
     * 
     * Requirements:
     *
     * - only implementationAddr can call this function.
     */
    function redeem(address contAddr, address to, uint256 tokenId) external;


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
    ) external;

}